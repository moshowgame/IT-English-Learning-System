/* ============================================================
 * AI Configuration Module
 * Manages AI provider config (URL, Token, Model) with Base64
 * encoded localStorage. NOT real encryption — security by obscurity.
 * ============================================================ */
(function () {
    'use strict';

    const AI_CONFIG_KEY = 'it_english_ai_config_v1';

    // Preset providers (OpenAI-compatible chat completions)
    const SAMPLES = {
        deepseek: {
            label: 'DeepSeek (推荐 / Recommended)',
            url: 'https://api.deepseek.com/v1/chat/completions',
            model: 'deepseek-v4-flash',
            temperature: 0.3
        },
        openai: {
            label: 'OpenAI',
            url: 'https://api.openai.com/v1/chat/completions',
            model: 'gpt-4o-mini',
            temperature: 0.3
        },
        moonshot: {
            label: 'Moonshot (月之暗面 Kimi)',
            url: 'https://api.moonshot.cn/v1/chat/completions',
            model: 'moonshot-v1-8k',
            temperature: 0.3
        },
        qwen: {
            label: 'Qwen (通义千问)',
            url: 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
            model: 'qwen-turbo',
            temperature: 0.3
        },
        zhipu: {
            label: 'Zhipu GLM (智谱)',
            url: 'https://open.bigmodel.cn/api/paas/v4/chat/completions',
            model: 'glm-4-flash',
            temperature: 0.3
        }
    };

    // Simple Base64 helpers — also handles UTF-8 safely
    function encode(str) {
        return btoa(unescape(encodeURIComponent(str)));
    }
    function decode(str) {
        try {
            return decodeURIComponent(escape(atob(str)));
        } catch (e) {
            return '';
        }
    }

    const AIConfig = {
        load() {
            try {
                const raw = localStorage.getItem(AI_CONFIG_KEY);
                if (!raw) return null;
                return JSON.parse(decode(raw));
            } catch (e) {
                return null;
            }
        },
        save(cfg) {
            localStorage.setItem(AI_CONFIG_KEY, encode(JSON.stringify(cfg)));
            document.dispatchEvent(new CustomEvent('ai-config-updated'));
        },
        clear() {
            localStorage.removeItem(AI_CONFIG_KEY);
            document.dispatchEvent(new CustomEvent('ai-config-updated'));
        },
        isConfigured() {
            const c = this.load();
            return !!(c && c.url && c.token);
        }
    };

    window.AIConfig = AIConfig;
    window.AI_SAMPLES = SAMPLES;

    // ============= Modal =============
    function buildModal() {
        const cfg = AIConfig.load() || {};
        return `
        <div class="ai-modal-overlay" id="aiSettingsModal">
            <div class="ai-modal">
                <div class="ai-modal-header">
                    <h3>🤖 AI Settings / AI 配置</h3>
                    <button type="button" class="ai-modal-close" data-ai-close aria-label="Close">&times;</button>
                </div>
                <div class="ai-modal-body">
                    <div class="ai-notice">
                        <strong>⚠️ 安全提示 / Security Notice</strong><br>
                        API Token 以 Base64 编码存储在浏览器 localStorage（不加密，等同明文）。建议使用专用、额度受限的 Token。<br>
                        Token is stored as Base64 in browser localStorage (NOT encrypted). Use a dedicated token with limited quota.
                    </div>

                    <div class="ai-form-row">
                        <label>Provider 厂商预设</label>
                        <select id="aiProviderPreset" class="form-control">
                            <option value="">-- Custom 自定义 --</option>
                            ${Object.keys(SAMPLES).map(k => `<option value="${k}">${SAMPLES[k].label}</option>`).join('')}
                        </select>
                    </div>

                    <div class="ai-form-row">
                        <label>API URL <span class="ai-req">*</span></label>
                        <input type="text" id="aiUrl" class="form-control"
                               placeholder="https://api.deepseek.com/v1/chat/completions"
                               value="${escapeAttr(cfg.url || '')}">
                        <small>OpenAI 兼容的 chat completions endpoint</small>
                    </div>

                    <div class="ai-form-row">
                        <label>API Token <span class="ai-req">*</span></label>
                        <div class="ai-token-group">
                            <input type="password" id="aiToken" class="form-control"
                                   placeholder="sk-..." value="${escapeAttr(cfg.token || '')}">
                            <button type="button" class="btn btn-outline-secondary" id="aiTokenToggle" tabindex="-1">👁</button>
                        </div>
                    </div>

                    <div class="ai-form-row">
                        <label>Model 模型</label>
                        <input type="text" id="aiModel" class="form-control"
                               placeholder="deepseek-v4-flash" value="${escapeAttr(cfg.model || 'deepseek-v4-flash')}">
                    </div>

                    <div class="ai-form-row">
                        <label>Temperature (0-1，越高越有创造性)</label>
                        <input type="number" id="aiTemperature" class="form-control"
                               min="0" max="2" step="0.1" value="${cfg.temperature || 0.3}">
                    </div>
                </div>
                <div class="ai-modal-footer">
                    <button type="button" class="btn btn-outline-danger" id="aiClearBtn">🗑 Clear 清除</button>
                    <button type="button" class="btn btn-secondary" data-ai-close>Cancel 取消</button>
                    <button type="button" class="btn btn-primary" id="aiSaveBtn">💾 Save 保存</button>
                </div>
            </div>
        </div>`;
    }

    function escapeAttr(s) {
        return String(s).replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    function attachHandlers(modal) {
        modal.querySelectorAll('[data-ai-close]').forEach(el => {
            el.addEventListener('click', hideModal);
        });
        modal.addEventListener('click', e => {
            if (e.target === modal) hideModal();
        });

        // Preset -> auto-fill
        modal.querySelector('#aiProviderPreset').addEventListener('change', e => {
            const sample = SAMPLES[e.target.value];
            if (sample) {
                modal.querySelector('#aiUrl').value = sample.url;
                modal.querySelector('#aiModel').value = sample.model;
                modal.querySelector('#aiTemperature').value = sample.temperature;
            }
        });

        // Token visibility toggle
        modal.querySelector('#aiTokenToggle').addEventListener('click', () => {
            const inp = modal.querySelector('#aiToken');
            inp.type = inp.type === 'password' ? 'text' : 'password';
        });

        // Save
        modal.querySelector('#aiSaveBtn').addEventListener('click', () => {
            const url = modal.querySelector('#aiUrl').value.trim();
            const token = modal.querySelector('#aiToken').value.trim();
            const model = modal.querySelector('#aiModel').value.trim() || 'deepseek-v4-flash';
            const temperature = parseFloat(modal.querySelector('#aiTemperature').value) || 0.3;

            if (!url) { alert('请填写 API URL / Please enter API URL'); return; }
            if (!token) { alert('请填写 API Token / Please enter API Token'); return; }

            AIConfig.save({ url, token, model, temperature });
            flashStatus('✅ AI 配置已保存 / AI config saved');
            hideModal();
        });

        // Clear
        modal.querySelector('#aiClearBtn').addEventListener('click', () => {
            if (confirm('确定清除 AI 配置？/ Clear AI config?')) {
                AIConfig.clear();
                modal.querySelector('#aiUrl').value = '';
                modal.querySelector('#aiToken').value = '';
                modal.querySelector('#aiModel').value = 'deepseek-v4-flash';
                modal.querySelector('#aiTemperature').value = '0.3';
                flashStatus('🗑 已清除 / Cleared');
            }
        });
    }

    function showModal() {
        let modal = document.getElementById('aiSettingsModal');
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', buildModal());
            modal = document.getElementById('aiSettingsModal');
            attachHandlers(modal);
        }
        modal.classList.add('ai-modal-show');
    }
    function hideModal() {
        const modal = document.getElementById('aiSettingsModal');
        if (modal) modal.classList.remove('ai-modal-show');
    }

    function flashStatus(msg) {
        const bar = document.querySelector('.ai-status-bar');
        if (!bar) return;
        bar.textContent = msg;
        bar.classList.add('ai-status-show');
        clearTimeout(bar._timer);
        bar._timer = setTimeout(() => bar.classList.remove('ai-status-show'), 3000);
    }

    // Global API
    window.AISettings = { show: showModal, hide: hideModal, flash: flashStatus };
})();

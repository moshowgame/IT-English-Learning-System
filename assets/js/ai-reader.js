/* ============================================================
 * AI Reader Module
 * Injects "AI 阅读" controls into article pages, lets user call
 * their own AI provider to translate/explain or role-play dialogues.
 * ============================================================ */
(function () {
    'use strict';

    // ---- Extract article content ----
    function extractScenario() {
        const sections = document.querySelectorAll('.article-section');
        for (const s of sections) {
            const h = s.querySelector('h2');
            if (h && /Scenario/i.test(h.textContent)) {
                // Get the first <p> after the heading
                const p = s.querySelector('p');
                return p ? p.textContent.trim() : '';
            }
        }
        return '';
    }

    function extractDialogue() {
        const lines = document.querySelectorAll('.dialogue-line');
        return Array.from(lines).map(line => {
            const speaker = (line.querySelector('.speaker')?.textContent || '').replace(':', '').trim();
            const en = line.querySelector('.en')?.textContent.trim() || '';
            const cn = line.querySelector('.cn')?.textContent.trim() || '';
            return { speaker, en, cn };
        });
    }

    function extractKeyPhrases() {
        const items = document.querySelectorAll('.phrase-list li');
        return Array.from(items).slice(0, 10).map(li => {
            const em = li.querySelector('em');
            return em ? em.textContent.trim() : li.textContent.trim();
        });
    }

    // ---- Inject control panel after dialogue-block ----
    function injectPanels() {
        document.querySelectorAll('.dialogue-block').forEach(block => {
            // Skip if already injected
            if (block.parentNode.querySelector(':scope > .ai-reader-panel')) return;

            const panel = document.createElement('div');
            panel.className = 'ai-reader-panel';
            panel.innerHTML = `
                <div class="ai-reader-toolbar">
                    <span class="ai-reader-label">🤖 AI 助手</span>
                    <button class="btn btn-sm btn-outline-primary ai-act" data-act="explain">
                        📖 详细翻译 + 文化注释
                    </button>
                    <button class="btn btn-sm btn-outline-success ai-act" data-act="roleplay">
                        🎭 AI 角色扮演
                    </button>
                    <button class="btn btn-sm btn-outline-info ai-act" data-act="quiz">
                        ✏️ AI 出题
                    </button>
                    <button class="btn btn-sm btn-outline-secondary ai-cfg">
                        ⚙️ 配置
                    </button>
                </div>
                <div class="ai-reader-output" hidden></div>
            `;
            block.parentNode.insertBefore(panel, block.nextSibling);
        });
    }

    // ---- Call AI API (OpenAI-compatible chat completions) ----
    async function callAI(messages, signal) {
        const cfg = window.AIConfig?.load();
        if (!cfg) return { error: '请先配置 AI / Please configure AI first.' };
        if (!cfg.url || !cfg.token) return { error: 'AI 配置不完整 / AI config incomplete.' };

        try {
            const res = await fetch(cfg.url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + cfg.token
                },
                body: JSON.stringify({
                    model: cfg.model || 'deepseek-v4-flash',
                    messages,
                    temperature: cfg.temperature ?? 0.3,
                    stream: false
                }),
                signal
            });

            if (!res.ok) {
                const text = await res.text();
                return { error: 'API ' + res.status + '：' + text.substring(0, 300) };
            }

            const data = await res.json();
            const content = data.choices?.[0]?.message?.content
                || data.choices?.[0]?.text
                || '(空响应 / Empty response)';
            return { content };
        } catch (e) {
            if (e.name === 'AbortError') return { error: '已取消 / Cancelled' };
            return { error: '网络错误: ' + e.message };
        }
    }

    // ---- Render output ----
    function escapeHtml(s) {
        return String(s).replace(/[&<>"']/g, c => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
        }[c]));
    }

    function md2html(md) {
        // Tiny markdown -> HTML (just headings, bold, lists, code)
        let html = escapeHtml(md);
        html = html.replace(/^### (.+)$/gm, '<h4>$1</h4>');
        html = html.replace(/^## (.+)$/gm, '<h3>$1</h3>');
        html = html.replace(/^# (.+)$/gm, '<h3>$1</h3>');
        html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');
        html = html.replace(/`([^`]+)`/g, '<code>$1</code>');
        html = html.replace(/^\d+\. (.+)$/gm, '<li>$1</li>');
        html = html.replace(/^[-*] (.+)$/gm, '<li>$1</li>');
        html = html.replace(/(<li>(?:.|\n)*?<\/li>)/g, m => '<ul>' + m + '</ul>');
        html = html.replace(/<\/ul>\s*<ul>/g, '');
        html = html.replace(/\n{2,}/g, '</p><p>');
        html = html.replace(/\n/g, '<br>');
        return '<p>' + html + '</p>';
    }

    function showOutput(panel, html, action) {
        const out = panel.querySelector('.ai-reader-output');
        out.innerHTML = `
            <div class="ai-output-header">
                <span>${action}</span>
                <button class="ai-output-close" aria-label="Close">×</button>
            </div>
            <div class="ai-output-body">${html}</div>
        `;
        out.hidden = false;
        out.querySelector('.ai-output-close').addEventListener('click', () => {
            out.hidden = true;
            out._abortController?.abort();
        });
        out.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    function showLoading(panel, action) {
        const out = panel.querySelector('.ai-reader-output');
        out.innerHTML = `
            <div class="ai-output-header">
                <span>${action}</span>
                <button class="ai-output-close" aria-label="Close">×</button>
            </div>
            <div class="ai-output-body">
                <div class="ai-loading">
                    <span class="ai-spinner"></span>
                    AI 思考中... (Thinking... 请稍候)
                </div>
            </div>
        `;
        out.hidden = false;
        out.querySelector('.ai-output-close').addEventListener('click', () => {
            out.hidden = true;
            out._abortController?.abort();
        });
    }

    function showError(panel, msg) {
        const out = panel.querySelector('.ai-reader-output');
        out.innerHTML = `
            <div class="ai-output-header">
                <span>❌ 错误</span>
                <button class="ai-output-close" aria-label="Close">×</button>
            </div>
            <div class="ai-output-body">
                <div class="ai-error">${escapeHtml(msg)}</div>
            </div>
        `;
        out.hidden = false;
    }

    // ---- Build prompts ----
    function buildExplainPrompt(scenario, dialogue) {
        const dialogueText = dialogue.map(d => `${d.speaker}: ${d.en}`).join('\n');
        return [
            {
                role: 'system',
                content: '你是一个在外资银行 IT 部门工作的资深英语沟通教练，专长帮中国员工提升英语口语和职场沟通。请用中文回答，输出使用 Markdown 格式。'
            },
            {
                role: 'user',
                content: `请针对以下银行 IT 场景对话，提供：
1) **逐句详细翻译**（翻译要自然、地道，符合职场场景，比原文小字中文更详尽）
2) **关键短语解析**（俚语/缩略语/银行术语，挑出 3-5 个重点）
3) **文化/职场 Tips**（这个场景下的潜规则、注意事项、native speaker 的说话方式）
4) **可改进建议**（如果有更地道的表达方式，请指出）

场景：${scenario}

对话：
${dialogueText}`
            }
        ];
    }

    function buildRoleplayPrompt(scenario, dialogue) {
        // Find who user might want to play; default to last speaker
        const lastSpeaker = dialogue[dialogue.length - 1]?.speaker || 'You';
        const otherSpeakers = [...new Set(dialogue.map(d => d.speaker))].filter(s => s !== lastSpeaker);
        const aiChar = otherSpeakers[0] || 'Other party';

        return [
            {
                role: 'system',
                content: `你正在扮演一个银行 IT 场景中的角色（${aiChar}），用户扮演 ${lastSpeaker}。规则：
- 保持角色一致，回复使用地道、自然的英语
- 一次只说 1-2 句话
- 等用户用英文回复后再继续
- 根据用户的英文水平（中级），可适当给出表达建议（用中文括号提示）
- 场景设定：${scenario}

参考对话历史：${dialogue.map(d => `${d.speaker}: ${d.en}`).join('\n')}

请先介绍自己的角色，然后以该角色身份发起第一句对话。`
            },
            {
                role: 'user',
                content: '请开始角色扮演。'
            }
        ];
    }

    function buildRoleplayChat(messages, scenario, dialogue, userInput) {
        // Continue roleplay conversation
        const aiChar = dialogue.find(d => !/You|TL|Me/i.test(d.speaker))?.speaker || 'Other party';
        const sysMsg = {
            role: 'system',
            content: `你是银行 IT 场景中的角色（${aiChar}），与用户对话。规则：
- 保持角色一致，回复使用地道英语（1-2 句）
- 场景：${scenario}
- 如果用户的英文有明显错误或不自然，可在回复末尾用中文括号简短提示更地道的说法`
        };
        return [sysMsg, ...messages, { role: 'user', content: userInput }];
    }

    function buildQuizPrompt(scenario, dialogue, keyPhrases) {
        const dialogueText = dialogue.map(d => `${d.speaker}: ${d.en}`).join('\n');
        return [
            {
                role: 'system',
                content: '你是英语口语老师，请用中文出题，输出 Markdown。'
            },
            {
                role: 'user',
                content: `基于以下银行 IT 场景对话，请生成 3 道练习题：
1) **英译中题**：选 2 个最难的句子让用户翻译
2) **情境填空题**：挖空 1 个关键短语让用户填
3) **开放问答**：基于对话内容生成 1 个让用户用英语自由发挥的问题

提供答案（先藏起来，让用户先思考）。

场景：${scenario}
关键短语：${keyPhrases.join('; ')}

对话：
${dialogueText}`
            }
        ];
    }

    // ---- State for ongoing roleplay ----
    const roleplayState = new WeakMap(); // panel -> {messages, scenario, dialogue}

    // ---- Click handlers ----
    async function handleClick(e) {
        const cfgBtn = e.target.closest('.ai-cfg');
        if (cfgBtn) {
            if (window.AISettings) window.AISettings.show();
            return;
        }

        const btn = e.target.closest('.ai-act');
        if (!btn) return;

        const panel = btn.closest('.ai-reader-panel');
        if (!panel) return;

        if (!window.AIConfig?.isConfigured()) {
            alert('请先配置 AI（点击 ⚙️ 配置）\nPlease configure AI first (click ⚙️)');
            if (window.AISettings) window.AISettings.show();
            return;
        }

        const act = btn.dataset.act;
        const scenario = extractScenario();
        const dialogue = extractDialogue();
        const keyPhrases = extractKeyPhrases();

        if (act === 'explain') {
            showLoading(panel, '📖 详细翻译 + 文化注释');
            const result = await callAI(buildExplainPrompt(scenario, dialogue));
            if (result.error) showError(panel, result.error);
            else showOutput(panel, md2html(result.content), '📖 详细翻译 + 文化注释');
        }
        else if (act === 'roleplay') {
            // Initialize or continue roleplay
            let state = roleplayState.get(panel);
            if (!state) {
                showLoading(panel, '🎭 启动 AI 角色扮演...');
                const initMessages = buildRoleplayPrompt(scenario, dialogue);
                const result = await callAI(initMessages);
                if (result.error) { showError(panel, result.error); return; }
                state = {
                    messages: [
                        ...initMessages,
                        { role: 'assistant', content: result.content }
                    ],
                    scenario, dialogue
                };
                roleplayState.set(panel, state);
                renderRoleplay(panel, state);
            } else {
                renderRoleplay(panel, state);
            }
        }
        else if (act === 'quiz') {
            showLoading(panel, '✏️ AI 出题中...');
            const result = await callAI(buildQuizPrompt(scenario, dialogue, keyPhrases));
            if (result.error) showError(panel, result.error);
            else showOutput(panel, md2html(result.content), '✏️ AI 出题');
        }
    }

    function renderRoleplay(panel, state) {
        const out = panel.querySelector('.ai-reader-output');
        const lastAi = [...state.messages].reverse().find(m => m.role === 'assistant');
        const transcript = state.messages
            .filter(m => m.role !== 'system')
            .map(m => {
                const tag = m.role === 'user' ? '🧑 You' : '🤖 AI';
                return `<div class="ai-msg ai-msg-${m.role}"><b>${tag}:</b> ${escapeHtml(m.content).replace(/\n/g, '<br>')}</div>`;
            }).join('');

        out.innerHTML = `
            <div class="ai-output-header">
                <span>🎭 角色扮演模式</span>
                <button class="ai-output-close" aria-label="Close">×</button>
            </div>
            <div class="ai-output-body">
                <div class="ai-roleplay-transcript">${transcript}</div>
                <div class="ai-roleplay-input">
                    <textarea class="form-control" rows="2" placeholder="用英文回复 AI 角色... Type your reply in English..."></textarea>
                    <button class="btn btn-primary btn-sm ai-send">发送 Send</button>
                    <button class="btn btn-outline-secondary btn-sm ai-reset">重置 Reset</button>
                </div>
            </div>
        `;
        out.hidden = false;

        out.querySelector('.ai-output-close').addEventListener('click', () => {
            out.hidden = true;
        });
        out.querySelector('.ai-reset').addEventListener('click', () => {
            roleplayState.delete(panel);
            out.hidden = true;
        });
        out.querySelector('.ai-send').addEventListener('click', async () => {
            const ta = out.querySelector('textarea');
            const userText = ta.value.trim();
            if (!userText) return;
            ta.disabled = true;
            state.messages.push({ role: 'user', content: userText });
            ta.value = '';

            const newMessages = buildRoleplayChat(
                state.messages.slice(2), state.scenario, state.dialogue, userText
            );

            const sendBtn = out.querySelector('.ai-send');
            sendBtn.disabled = true;
            sendBtn.textContent = '⏳ 等待 AI...';

            const result = await callAI(newMessages);
            ta.disabled = false;
            sendBtn.disabled = false;
            sendBtn.textContent = '发送 Send';

            if (result.error) {
                state.messages.push({ role: 'assistant', content: '❌ ' + result.error });
            } else {
                state.messages.push({ role: 'assistant', content: result.content });
            }
            renderRoleplay(panel, state);
        });
    }

    // ---- Init ----
    function init() {
        injectPanels();
        document.addEventListener('click', handleClick);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

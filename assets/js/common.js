/* ============================================================
   IT English Learning System — Common JS (vanilla, no jQuery)
   ============================================================ */
(function () {
    'use strict';

    var KNOWN_TOP_DIRS = ['ba', 'developer', 'tech-lead', 'architect', 'pm',
                          'itso', 'senior-manager', 'business', 'scenarios', 'assets'];

    /* ---------- Active nav highlighting ---------- */
    function highlightActiveNav() {
        var links = document.querySelectorAll('.site-header .nav-link');
        if (!links.length) return;
        var norm = function (p) { return p.replace(/\/index\.html$/, '/').replace(/\/+$/, '/'); };
        var here = norm(window.location.pathname);
        links.forEach(function (link) {
            var href = link.getAttribute('href');
            if (!href || href === '#') return;
            var target;
            try { target = norm(new URL(href, window.location.href).pathname); }
            catch (e) { return; }
            if (target !== '/' && here.indexOf(target) === 0) {
                link.classList.add('active');
            }
        });
    }

    /* ---------- Answer toggles ----------
       Two legacy markups exist across the site:
       1. <button class="answer-toggle">  + sibling <div class="answer">
       2. <button data-toggle="answer">   + sibling <div class="answer-box" style="display:none">
    */
    function findAnswerPanel(btn) {
        var el = btn.nextElementSibling;
        while (el) {
            if (el.classList && (el.classList.contains('answer') || el.classList.contains('answer-box'))) {
                return el;
            }
            break;
        }
        return btn.parentElement
            ? btn.parentElement.querySelector('.answer, .answer-box')
            : null;
    }

    document.addEventListener('click', function (e) {
        var btn = e.target.closest('.answer-toggle, [data-toggle="answer"]');
        if (!btn) return;
        var panel = findAnswerPanel(btn);
        if (!panel) return;

        if (!btn.dataset.originalLabel) {
            btn.dataset.originalLabel = btn.textContent.trim() || 'Show Answer';
        }
        var opening = !panel.classList.contains('open');
        panel.style.display = ''; // strip legacy inline display:none
        panel.classList.toggle('open', opening);
        btn.textContent = opening ? 'Hide Answer' : btn.dataset.originalLabel;
    });

    /* ---------- Back to top ---------- */
    var toTop = document.createElement('button');
    toTop.className = 'btn-to-top';
    toTop.title = 'Back to top';
    toTop.setAttribute('aria-label', 'Back to top');
    toTop.textContent = '↑';
    document.body.appendChild(toTop);

    window.addEventListener('scroll', function () {
        toTop.classList.toggle('show', window.scrollY > 400);
    }, { passive: true });

    toTop.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });

    /* ---------- QR lightbox ---------- */
    var lightbox = null;

    function buildLightbox() {
        lightbox = document.createElement('div');
        lightbox.className = 'qr-lightbox';
        lightbox.setAttribute('role', 'dialog');
        lightbox.setAttribute('aria-modal', 'true');
        lightbox.setAttribute('aria-label', 'QR Code Preview');
        lightbox.innerHTML =
            '<div class="qr-lightbox-inner" role="document">' +
              '<button type="button" class="qr-lightbox-close" aria-label="Close">&times;</button>' +
              '<img alt="">' +
              '<div class="qr-lightbox-caption">' +
                '<span class="caption-text"></span>' +
                '<span class="scan-tip">长按图片或截图后用微信/支付宝扫码 · Tap or save to scan</span>' +
              '</div>' +
            '</div>';
        document.body.appendChild(lightbox);

        lightbox.addEventListener('click', function (e) {
            if (e.target === lightbox) closeQrLightbox();
        });
        lightbox.querySelector('.qr-lightbox-close').addEventListener('click', function (e) {
            e.stopPropagation();
            closeQrLightbox();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' || e.keyCode === 27) closeQrLightbox();
        });
    }

    function openQrLightbox(src, caption) {
        if (!lightbox) buildLightbox();
        lightbox.querySelector('img').setAttribute('src', src);
        lightbox.querySelector('.caption-text').textContent = caption || 'QR Code';
        lightbox.classList.add('is-open');
        document.body.classList.add('qr-lightbox-open');
        lightbox.querySelector('.qr-lightbox-close').focus();
    }

    function closeQrLightbox() {
        if (!lightbox) return;
        lightbox.classList.remove('is-open');
        document.body.classList.remove('qr-lightbox-open');
    }

    document.addEventListener('click', function (e) {
        var img = e.target.closest('.footer-donate-qr .donate-item img');
        if (!img) return;
        e.preventDefault();
        var label = img.closest('.donate-item').querySelector('.donate-label');
        openQrLightbox(img.getAttribute('src'), label ? label.textContent : 'QR Code');
    });

    /* ---------- Footer author / donate injection ----------
       Depth is derived generically from the first known top-level folder
       in the path, so it also works under a GitHub Pages project subpath
       and for new sections (senior-manager, business, scenarios). */
    function computeAssetPrefix() {
        var segs = window.location.pathname.split('/').filter(Boolean);
        var i = -1;
        for (var k = 0; k < segs.length; k++) {
            if (KNOWN_TOP_DIRS.indexOf(segs[k]) !== -1) { i = k; break; }
        }
        var depth = (i === -1) ? 0 : segs.length - 1 - i;
        var prefix = '';
        for (var d = 0; d < depth; d++) prefix += '../';
        return prefix;
    }

    function injectAuthorAndDonate() {
        var footer = document.querySelector('.site-footer');
        if (!footer || footer.querySelector('.footer-author-block')) return;

        var prefix = computeAssetPrefix();

        var githubSvg = '<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg>';
        var csdnSvg = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M16.46 11.63a4.4 4.4 0 0 1-1.07 3.07l-5.08 5.08a4.5 4.5 0 0 1-6.36-6.36l3.55-3.55a1 1 0 0 1 1.42 1.42l-3.55 3.55a2.5 2.5 0 0 0 3.54 3.54l5.08-5.08a2.5 2.5 0 0 0-3.54-3.54l-1.11 1.11a1 1 0 1 1-1.42-1.42l1.11-1.1a4.5 4.5 0 0 1 6.43 6.28zm5.43-6.36a4.5 4.5 0 0 0-6.36 0l-5.08 5.08a4.5 4.5 0 0 0 6.36 6.36l-1.11-1.11a2.5 2.5 0 0 1-3.54-3.54l5.08-5.08a2.5 2.5 0 0 1 3.54 3.54l-3.55 3.55a1 1 0 0 0 1.42 1.42l3.55-3.55a4.5 4.5 0 0 0-.31-6.67z"/></svg>';

        var block = document.createElement('div');
        block.innerHTML =
            '<div class="footer-author-block">' +
              '<span class="author-name">by Moshow<span class="zh">郑锴</span></span>' +
              '<span class="footer-social-links">' +
                '<a href="https://github.com/moshowgame" target="_blank" rel="noopener" title="GitHub @moshowgame">' + githubSvg + '<span>GitHub</span></a>' +
                '<a href="https://zhengkai.blog.csdn.net/" target="_blank" rel="noopener" title="CSDN @zhengkai">' + csdnSvg + '<span>CSDN</span></a>' +
              '</span>' +
            '</div>' +
            '<div class="footer-donate-block">' +
              '<div class="donate-title">如果这个学习系统帮到了你，欢迎打赏支持作者 <span class="heart">&hearts;</span></div>' +
              '<div class="footer-donate-qr">' +
                '<div class="donate-item wechat">' +
                  '<img src="' + prefix + 'assets/images/wechat-qr.jpg" alt="WeChat Pay QR Code" loading="lazy">' +
                  '<div class="donate-label">微信打赏</div>' +
                '</div>' +
                '<div class="donate-item alipay">' +
                  '<img src="' + prefix + 'assets/images/alipay-qr.jpg" alt="Alipay QR Code" loading="lazy">' +
                  '<div class="donate-label">支付宝</div>' +
                '</div>' +
              '</div>' +
            '</div>';

        var brand = footer.querySelector('.footer-brand');
        var container = footer.querySelector('.container') || footer;
        if (brand) {
            brand.after(block);
        } else {
            container.prepend(block);
        }

        var ps = container.querySelectorAll(':scope > p:not(:first-child)');
        if (ps.length > 0) {
            var wrap = document.createElement('div');
            wrap.className = 'footer-copyright-line';
            ps[0].parentNode.insertBefore(wrap, ps[0]);
            ps.forEach(function (p) { wrap.appendChild(p); });
        }
    }

    /* ---------- TTS: read aloud (Web Speech API) ----------
       Injected on every page: per-dialogue-line buttons, per-dialogue
       "play whole conversation" with live highlighting, and per-item
       buttons on phrase / vocabulary lists. English text only. */
    var tts = (function () {
        var synth = window.speechSynthesis || null;
        var voice = null;
        var rate = parseFloat(localStorage.getItem('ttsRate')) || 1;
        var token = 0;

        function pickVoice() {
            if (!synth) return;
            var all = synth.getVoices() || [];
            var en = all.filter(function (v) { return /^en[-_]/i.test(v.lang); });
            if (!en.length) { voice = null; return; }
            /* HSBC context — prefer a British voice, fall back to US */
            var nice = /(Google UK English Female|Google UK English Male|Serena|Daniel|Kate|Sonia|Libby|Aria|Ryan)/i;
            voice =
                en.find(function (v) { return /en[-_]GB/i.test(v.lang) && nice.test(v.name); }) ||
                en.find(function (v) { return /en[-_]GB/i.test(v.lang); }) ||
                en.find(function (v) { return /en[-_]US/i.test(v.lang) && nice.test(v.name); }) ||
                en.find(function (v) { return /en[-_]US/i.test(v.lang); }) ||
                en[0];
        }

        if (synth) {
            pickVoice();
            if (typeof synth.addEventListener === 'function') {
                synth.addEventListener('voiceschanged', pickVoice);
            } else if (typeof synth.onvoiceschanged !== 'undefined') {
                synth.onvoiceschanged = pickVoice;
            }
        }

        function cancel() {
            if (synth) { try { synth.cancel(); } catch (e) { /* ignore */ } }
            token++;
        }

        function speakOne(text, onend) {
            if (!synth || !text) { if (onend) setTimeout(onend, 0); return; }
            var my = token;
            var u = new SpeechSynthesisUtterance(text);
            if (voice) { u.voice = voice; u.lang = voice.lang; } else { u.lang = 'en-GB'; }
            u.rate = rate;
            u.pitch = 1;
            var done = false;
            function finish() {
                if (done) return;
                done = true;
                if (my === token && onend) onend();
            }
            u.onend = finish;
            u.onerror = finish; /* cancel() also fires onerror in Chrome */
            synth.speak(u);
        }

        function playSequence(items, onItem, onDone) {
            cancel();
            if (!items.length) return;
            var my = token;
            var i = 0;
            (function next() {
                if (my !== token) return;
                if (i >= items.length) { if (onDone) onDone(); return; }
                var idx = i++;
                if (onItem) onItem(items[idx], idx);
                speakOne(items[idx].text, next);
            })();
        }

        return {
            supported: !!synth,
            cancel: cancel,
            say: function (text, onend) { cancel(); speakOne(text, onend); },
            playSequence: playSequence,
            getRate: function () { return rate; },
            setRate: function (r) { rate = r; localStorage.setItem('ttsRate', String(r)); }
        };
    })();

    function injectTts() {
        var hasDialogue = document.querySelectorAll('.dialogue-block').length > 0;

        if (!tts.supported) {
            if (hasDialogue) {
                var note = document.createElement('div');
                note.className = 'tts-unsupported';
                note.textContent = '当前浏览器不支持语音朗读（Web Speech API），建议使用 Chrome / Edge 浏览器。';
                var firstBlock = document.querySelector('.dialogue-block');
                firstBlock.parentNode.insertBefore(note, firstBlock);
            }
            return;
        }

        /* ---- Dialogue blocks: toolbar + per-line buttons ---- */
        document.querySelectorAll('.dialogue-block').forEach(function (block) {
            if (block.querySelector('.tts-bar')) return;
            var lines = block.querySelectorAll('.dialogue-line');
            if (!lines.length) return;

            var bar = document.createElement('div');
            bar.className = 'tts-bar';
            bar.innerHTML =
                '<span class="tts-bar-label">🔊 朗读 / Listen</span>' +
                '<button type="button" class="tts-btn tts-play">▶ 播放整段对话</button>' +
                '<button type="button" class="tts-btn tts-stop" hidden>⏹ 停止</button>' +
                '<span>语速 <select class="tts-select tts-rate">' +
                  '<option value="0.75">0.75x</option>' +
                  '<option value="0.9">0.9x</option>' +
                  '<option value="1">1x</option>' +
                  '<option value="1.25">1.25x</option>' +
                '</select></span>';
            block.insertBefore(bar, block.firstChild);

            var playBtn = bar.querySelector('.tts-play');
            var stopBtn = bar.querySelector('.tts-stop');
            var rateSel = bar.querySelector('.tts-rate');
            rateSel.value = String(tts.getRate());
            rateSel.addEventListener('change', function () {
                tts.setRate(parseFloat(rateSel.value));
            });

            function clearAll() {
                block.querySelectorAll('.dialogue-line.speaking').forEach(function (l) {
                    l.classList.remove('speaking');
                });
                playBtn.hidden = false;
                stopBtn.hidden = true;
            }

            stopBtn.addEventListener('click', function () {
                tts.cancel();
                clearAll();
            });

            playBtn.addEventListener('click', function () {
                var items = Array.prototype.map.call(lines, function (line) {
                    var en = line.querySelector('.en');
                    return { el: line, text: en ? en.textContent.replace(/\s+/g, ' ').trim() : '' };
                }).filter(function (it) { return it.text; });

                playBtn.hidden = true;
                stopBtn.hidden = false;
                tts.playSequence(items, function (item) {
                    block.querySelectorAll('.dialogue-line.speaking').forEach(function (l) {
                        l.classList.remove('speaking');
                    });
                    item.el.classList.add('speaking');
                }, clearAll);
            });

            lines.forEach(function (line) {
                if (line.querySelector('.tts-line-btn')) return;
                var en = line.querySelector('.en');
                if (!en || !en.textContent.trim()) return;
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'tts-line-btn';
                btn.title = '朗读这句 / Read this line';
                btn.textContent = '🔊';
                btn.setAttribute('aria-label', 'Read this line aloud');
                line.appendChild(btn);
                btn.addEventListener('click', function () {
                    tts.cancel();
                    block.querySelectorAll('.dialogue-line.speaking').forEach(function (l) {
                        l.classList.remove('speaking');
                    });
                    line.classList.add('speaking');
                    tts.say(en.textContent.replace(/\s+/g, ' ').trim(), function () {
                        line.classList.remove('speaking');
                    });
                });
            });
        });

        /* ---- Phrase / vocabulary lists: per-item button ---- */
        document.querySelectorAll('.phrase-list li, .vocab-list li').forEach(function (li) {
            if (li.querySelector('.tts-line-btn')) return;
            var enEl = li.querySelector('.english') || li.querySelector('strong');
            if (!enEl) return;
            var em = li.querySelector('em');
            var tag = li.querySelector('.tag');
            var text = em ? em.textContent : enEl.textContent;
            if (tag && !em) text = text.replace(tag.textContent, ' ');
            text = text.replace(/\s+/g, ' ').trim();
            if (!text) return;

            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'tts-line-btn tts-inline-btn';
            btn.title = '朗读 / Read aloud';
            btn.textContent = '🔊';
            btn.setAttribute('aria-label', 'Read aloud');
            enEl.appendChild(btn);
            btn.addEventListener('click', function () {
                tts.cancel();
                tts.say(text);
            });
        });
    }

    /* ---------- AI status badge (home page) ---------- */
    function updateAiStatusBadge() {
        var badge = document.getElementById('aiStatusBadge');
        if (!badge) return;
        if (window.AIConfig && window.AIConfig.isConfigured()) {
            var cfg = window.AIConfig.load();
            var model = (cfg && cfg.model) ? cfg.model : '?';
            badge.textContent = '🟢 已配置 / Configured (' + model + ')';
            badge.classList.add('configured');
        } else {
            badge.textContent = '⚪ 未配置 / Not Configured';
            badge.classList.remove('configured');
        }
    }

    function init() {
        highlightActiveNav();
        injectAuthorAndDonate();
        injectTts();
        updateAiStatusBadge();
        document.addEventListener('ai-config-updated', updateAiStatusBadge);

        /* stop any ongoing speech when leaving the page */
        window.addEventListener('beforeunload', function () {
            if (window.speechSynthesis) { try { window.speechSynthesis.cancel(); } catch (e) {} }
        });

        var openBtn = document.getElementById('aiOpenSettings');
        if (openBtn && window.AISettings) {
            openBtn.addEventListener('click', function () {
                window.AISettings.show();
            });
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

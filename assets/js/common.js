/* ============================================
   IT English Learning System - Common JS
   ============================================ */

$(function () {
    'use strict';

    // Highlight active nav link
    function highlightActiveNav() {
        var path = window.location.pathname;
        $('.site-header .nav-link').each(function () {
            var $link = $(this);
            var href = $link.attr('href');
            if (!href || href === '#') return;
            // Normalize trailing slashes
            var normPath = path.replace(/\/index\.html$/, '/').replace(/\/+$/, '/');
            var normHref = href.replace(/\/index\.html$/, '/').replace(/\/+$/, '/');
            if (normPath.indexOf(normHref) === 0 && normHref !== '/') {
                $link.addClass('active');
            } else if (normHref === '/' && (path === '/' || path.endsWith('index.html'))) {
                $link.addClass('active');
            }
        });
    }

    // Toggle answer visibility
    $(document).on('click', '.answer-toggle', function () {
        var $btn = $(this);
        var $answer = $btn.next('.answer');
        if ($answer.is(':visible')) {
            $answer.slideUp(150);
            $btn.text('Show Answer');
        } else {
            $answer.slideDown(150);
            $btn.text('Hide Answer');
        }
    });

    // Smooth scroll to top button (optional helper)
    var $toTop = $('<button class="btn-to-top" title="Back to top">↑</button>').css({
        position: 'fixed',
        right: '20px',
        bottom: '20px',
        width: '44px',
        height: '44px',
        'border-radius': '50%',
        background: '#003C71',
        color: '#fff',
        border: 'none',
        'font-size': '20px',
        cursor: 'pointer',
        display: 'none',
        'box-shadow': '0 4px 12px rgba(0,0,0,0.2)',
        'z-index': 999
    });
    $('body').append($toTop);
    $(window).on('scroll', function () {
        if ($(this).scrollTop() > 400) {
            $toTop.fadeIn(200);
        } else {
            $toTop.fadeOut(200);
        }
    });
    $toTop.on('click', function () {
        $('html, body').animate({ scrollTop: 0 }, 300);
    });

    // Initialize
    highlightActiveNav();
    injectAuthorAndDonate();
    setupQrLightbox();
});

/* ============================================
   QR Lightbox - Click QR image to zoom in
   ============================================ */
function setupQrLightbox() {
    // Create the lightbox container once per page
    if ($('.qr-lightbox').length === 0) {
        var $lightbox = $(
            '<div class="qr-lightbox" role="dialog" aria-modal="true" aria-label="QR Code Preview">' +
              '<div class="qr-lightbox-inner" role="document">' +
                '<button type="button" class="qr-lightbox-close" aria-label="Close">&times;</button>' +
                '<img alt="">' +
                '<div class="qr-lightbox-caption">' +
                  '<span class="caption-text"></span>' +
                  '<span class="scan-tip">长按图片或截图后用微信/支付宝扫码 · Tap or save to scan</span>' +
                '</div>' +
              '</div>' +
            '</div>'
        );
        $('body').append($lightbox);

        // Close when clicking the backdrop (outside the inner card)
        $lightbox.on('click', function (e) {
            if (e.target === this) {
                closeQrLightbox();
            }
        });

        // Close button
        $lightbox.on('click', '.qr-lightbox-close', function (e) {
            e.stopPropagation();
            closeQrLightbox();
        });

        // ESC key to close
        $(document).on('keydown', function (e) {
            if (e.key === 'Escape' || e.keyCode === 27) {
                closeQrLightbox();
            }
        });
    }

    // Delegate click handler on dynamically injected QR images
    $(document).on('click', '.footer-donate-qr .donate-item img', function (e) {
        e.preventDefault();
        var $img = $(this);
        var fullSrc = $img.attr('src');
        var caption = $img.closest('.donate-item').find('.donate-label').text() || 'QR Code';
        openQrLightbox(fullSrc, caption);
    });
}

function openQrLightbox(src, caption) {
    var $lightbox = $('.qr-lightbox');
    if ($lightbox.length === 0) return;

    $lightbox.find('img').attr('src', src);
    $lightbox.find('.caption-text').text(caption);
    $lightbox.addClass('is-open');
    $('body').addClass('qr-lightbox-open');

    // Move focus to the close button for accessibility
    $lightbox.find('.qr-lightbox-close').trigger('focus');
}

function closeQrLightbox() {
    var $lightbox = $('.qr-lightbox');
    if ($lightbox.length === 0) return;
    $lightbox.removeClass('is-open');
    $('body').removeClass('qr-lightbox-open');
}

/* ============================================
   Inject Author / Social / Donate block into footer
   ============================================ */
function injectAuthorAndDonate() {
    var $footer = $('.site-footer');
    if ($footer.length === 0) return;

    // Skip if already injected (e.g., when a page is rendered twice)
    if ($footer.find('.footer-author-block').length > 0) return;

    // Detect the right relative path to assets/images/ based on the page depth
    // - /index.html (project root)         -> depth 0 -> prefix ''
    // - /<role>/index.html (role folder)   -> depth 1 -> prefix '../'
    // - /<role>/articles/*.html (deepest)  -> depth 2 -> prefix '../../'
    var path = window.location.pathname;
    var roleRegex = /\/(ba|developer|architect|tech-lead|pm|itso)\//;
    var depth;
    if (/\/articles\//.test(path)) {
        depth = 2; // /<role>/articles/*.html
    } else if (roleRegex.test(path)) {
        depth = 1; // /<role>/index.html (or any other file inside a role folder)
    } else {
        depth = 0; // /index.html (project root)
    }
    var prefix = '';
    for (var i = 0; i < depth; i++) prefix += '../';

    // WeChat + Alipay icon SVGs
    var githubSvg = '<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg>';
    var csdnSvg = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M16.46 11.63a4.4 4.4 0 0 1-1.07 3.07l-5.08 5.08a4.5 4.5 0 0 1-6.36-6.36l3.55-3.55a1 1 0 0 1 1.42 1.42l-3.55 3.55a2.5 2.5 0 0 0 3.54 3.54l5.08-5.08a2.5 2.5 0 0 0-3.54-3.54l-1.11 1.11a1 1 0 1 1-1.42-1.42l1.11-1.1a4.5 4.5 0 0 1 6.43 6.28zm5.43-6.36a4.5 4.5 0 0 0-6.36 0l-5.08 5.08a4.5 4.5 0 0 0 6.36 6.36l-1.11-1.11a2.5 2.5 0 0 1-3.54-3.54l5.08-5.08a2.5 2.5 0 0 1 3.54 3.54l-3.55 3.55a1 1 0 0 0 1.42 1.42l3.55-3.55a4.5 4.5 0 0 0-.31-6.67z"/></svg>';

    var block = ''
        + '<div class="footer-author-block">'
        +   '<span class="author-name">by Moshow<span class="zh">郑锴</span></span>'
        +   '<span class="footer-social-links">'
        +     '<a href="https://github.com/moshowgame" target="_blank" rel="noopener" title="GitHub @moshowgame">' + githubSvg + '<span>GitHub</span></a>'
        +     '<a href="https://zhengkai.blog.csdn.net/" target="_blank" rel="noopener" title="CSDN @zhengkai">' + csdnSvg + '<span>CSDN</span></a>'
        +   '</span>'
        + '</div>'
        + '<div class="footer-donate-block">'
        +   '<div class="donate-title">如果这个学习系统帮到了你，欢迎打赏支持作者 <span class="heart">&hearts;</span></div>'
        +   '<div class="footer-donate-qr">'
        +     '<div class="donate-item wechat">'
        +       '<img src="' + prefix + 'assets/images/wechat-qr.jpg" alt="WeChat Pay QR Code" loading="lazy">'
        +       '<div class="donate-label">微信打赏</div>'
        +     '</div>'
        +     '<div class="donate-item alipay">'
        +       '<img src="' + prefix + 'assets/images/alipay-qr.jpg" alt="Alipay QR Code" loading="lazy">'
        +       '<div class="donate-label">支付宝</div>'
        +     '</div>'
        +   '</div>'
        + '</div>';

    // Insert after the footer-brand (or as the first child if brand missing)
    var $brand = $footer.find('.footer-brand');
    if ($brand.length > 0) {
        $brand.after(block);
    } else {
        $footer.find('.container').prepend(block);
    }

    // Wrap the original copyright line into a separate styled block
    var $existing = $footer.find('.container > p').not(':first');
    if ($existing.length > 0) {
        $existing.wrapAll('<div class="footer-copyright-line"></div>');
    }
}

/* ============================================
   AI Config Card wiring (home page only)
   ============================================ */
function updateAiStatusBadge() {
    var $badge = $('#aiStatusBadge');
    if ($badge.length === 0) return;
    if (window.AIConfig && window.AIConfig.isConfigured()) {
        var cfg = window.AIConfig.load();
        var model = (cfg && cfg.model) ? cfg.model : '?';
        $badge.text('🟢 已配置 / Configured (' + model + ')')
              .addClass('configured');
    } else {
        $badge.text('⚪ 未配置 / Not Configured')
              .removeClass('configured');
    }
}

$(function () {
    var $openBtn = $('#aiOpenSettings');
    if ($openBtn.length > 0 && window.AISettings) {
        $openBtn.on('click', function () {
            window.AISettings.show();
        });
    }
    updateAiStatusBadge();
    document.addEventListener('ai-config-updated', updateAiStatusBadge);
});

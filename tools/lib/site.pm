#!/usr/bin/perl
# Shared site-building library: canonical navbar, head block, article & index renderers.
package site;
use strict;
use warnings;
use utf8;
use Exporter 'import';
our @EXPORT_OK = qw(navbar head_scripts canonical_base article_page series_index_page scenarios_index_page);

my $BASE = 'https://moshowgame.github.io/IT-English-Learning-System/';

# Nav items: key => [label, path-from-root]
my @NAV = (
    ['home',           'Home',          'index.html'],
    ['ba',             'BA',            'ba/index.html'],
    ['developer',      'Developer',     'developer/index.html'],
    ['tech-lead',      'Tech Lead',     'tech-lead/index.html'],
    ['architect',      'Architect',     'architect/index.html'],
    ['pm',             'PM',            'pm/index.html'],
    ['itso',           'CyberSecurity', 'itso/index.html'],
    ['senior-manager', 'Senior Manager','senior-manager/index.html'],
    ['business',       'Business',      'business/index.html'],
    ['scenarios',      'Scenarios',     'scenarios/index.html'],
);

sub canonical_base { return $BASE; }

sub navbar {
    my ($prefix, $active) = @_;
    my $lis = '';
    for my $item (@NAV) {
        my ($key, $label, $path) = @$item;
        my $cls = ($key eq $active) ? ' active' : '';
        $lis .= "                    <li class=\"nav-item\"><a class=\"nav-link$cls\" href=\"$prefix$path\">$label</a></li>\n";
    }
    return <<HTML;
<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${prefix}index.html">
                <span class="brand-mark">IT</span>
                <span>English Learning System</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="mainNav">
                <ul class="navbar-nav ms-auto">
$lis                </ul>
            </div>
        </div>
    </nav>
</header>
HTML
}

sub head_scripts {
    # head meta block + closing script tags, with $prefix for local assets
    my ($prefix, $title, $desc, $relpath, $ogtype) = @_;
    my $canonical = $BASE . $relpath;
    return <<HTML;
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <meta name="description" content="$desc">
    <link rel="canonical" href="$canonical">
    <meta property="og:type" content="$ogtype">
    <meta property="og:title" content="$title">
    <meta property="og:description" content="$desc">
    <meta property="og:url" content="$canonical">
    <meta property="og:site_name" content="IT English Learning System">
    <meta property="og:locale" content="en_US">
    <link rel="icon" type="image/svg+xml" href="${prefix}assets/images/favicon.svg">
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap\@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${prefix}assets/css/common.css">
HTML
}

sub script_tags {
    my ($prefix) = @_;
    return <<HTML;
<script src="https://cdn.jsdelivr.net/npm/bootstrap\@5.3.2/dist/js/bootstrap.bundle.min.js" defer></script>
<script src="${prefix}assets/js/common.js" defer></script>
<script src="${prefix}assets/js/ai-config.js" defer></script>
<script src="${prefix}assets/js/ai-reader.js" defer></script>
HTML
}

sub breadcrumb {
    my (@items) = @_;   # each: [label, href or undef]
    my $lis = '';
    for my $it (@items) {
        my ($label, $href) = @$it;
        if (defined $href) {
            $lis .= "                <li class=\"breadcrumb-item\"><a href=\"$href\">$label</a></li>\n";
        } else {
            $lis .= "                <li class=\"breadcrumb-item active\">$label</li>\n";
        }
    }
    return <<HTML;
<div class="breadcrumb-bar">
    <div class="container">
        <nav>
            <ol class="breadcrumb">
$lis            </ol>
        </nav>
    </div>
</div>
HTML
}

sub article_page {
    my ($a, $series, $prefix, $relpath, $prev, $next) = @_;
    my $num2 = sprintf('%02d', $a->{num});

    my $scenario = '';
    for my $p (@{ $a->{scenario} }) {
        $scenario .= "        <p>\n            $p\n        </p>\n";
    }

    my $dialogue = '';
    for my $line (@{ $a->{dialogue} }) {
        my ($sp, $en, $cn) = @$line;
        my $cls = ($sp =~ /^You\b/) ? ' you' : '';
        $dialogue .= "            <div class=\"dialogue-line\">\n"
                   . "                <span class=\"speaker$cls\">$sp:</span>\n"
                   . "                <span class=\"text\"><span class=\"en\">$en</span><span class=\"cn\">$cn</span></span>\n"
                   . "            </div>\n";
    }

    my $phrases = '';
    for my $ph (@{ $a->{phrases} }) {
        my ($tag, $en, $cn, $note) = @$ph;
        $phrases .= "            <li>\n"
                  . "                <span class=\"english\"><span class=\"tag\">$tag</span> <em>$en</em></span>\n"
                  . "                <span class=\"chinese\">$cn</span>\n"
                  . "                <span class=\"note\">$note</span>\n"
                  . "            </li>\n";
    }

    my $vocab = '';
    for my $v (@{ $a->{vocab} }) {
        my ($term, $cn, $def) = @$v;
        $vocab .= "            <li><strong>$term</strong> $cn $def</li>\n";
    }

    my $grammar = '';
    my $gi = 0;
    for my $g (@{ $a->{grammar} }) {
        $gi++;
        my $sym = ('①','②','③')[$gi-1];
        $grammar .= "        <h3>$sym $g->[0]</h3>\n        <p>\n            $g->[1]\n        </p>\n        <p>$g->[2]</p>\n\n";
    }

    my $tips = '';
    for my $t (@{ $a->{tips} }) {
        $tips .= "            <li>$t</li>\n";
    }

    my $practice = '';
    my $pi = 0;
    for my $ex (@{ $a->{practice} }) {
        $pi++;
        my $label = $ex->{label} // 'Show Answer';
        $practice .= "        <h3>Exercise $pi — $ex->{t}</h3>\n"
                   . "        <p>$ex->{p}</p>\n"
                   . ($ex->{b} ? "        $ex->{b}\n" : '')
                   . "        <button class=\"btn btn-outline-primary btn-sm\" data-toggle=\"answer\">$label</button>\n"
                   . "        <div class=\"answer-box\" style=\"display:none;\">\n"
                   . "            <p>$ex->{a}</p>\n"
                   . "        </div>\n\n";
    }

    my $navlinks = "            <a href=\"../index.html\" class=\"btn btn-outline-secondary\">← Back to $series->{en} Home / 返回系列首页</a>\n";
    if ($prev) {
        $navlinks .= "            <a href=\"$prev->{file}\" class=\"btn btn-outline-primary\">← Previous: Article " . sprintf('%02d', $prev->{num}) . "</a>\n";
    }
    if ($next) {
        $navlinks .= "            <a href=\"$next->{file}\" class=\"btn btn-primary\">Next: Article " . sprintf('%02d', $next->{num}) . " →</a>\n";
    }

    my $title = "Article $num2: $a->{title} | $series->{en}";
    my $desc = "$a->{title} ($a->{cn}) — bilingual dialogue, key phrases, vocabulary and practice for $series->{en}. HSBC workplace English.";
    my $head = head_scripts($prefix, $title, $desc, $relpath, 'article');
    my $nav  = navbar($prefix, 'scenarios');
    my $bc   = breadcrumb(['Home', "${prefix}index.html"], ['Scenarios', "${prefix}scenarios/index.html"],
                          [$series->{en}, "../index.html"], ["$num2 · $a->{title}", undef]);
    my $scripts = script_tags($prefix);

    return <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
$head</head>
<body>

$nav
$bc
<main class="page-container">

    <section class="page-header">
        <h1>$a->{title}</h1>
        <p class="subtitle">Article $num2 · $series->{en} · $a->{cn}</p>
        <div class="meta">
            <span>⏱ $a->{read} min read</span>
            <span>$a->{diff}</span>
            <span>🎯 $a->{focus}</span>
        </div>
    </section>

    <!-- Scenario -->
    <section class="article-section">
        <h2>1. Scenario 场景背景</h2>
$scenario    </section>

    <!-- Dialogue -->
    <section class="article-section">
        <h2>2. Dialogue 英文对话</h2>
        <div class="dialogue-block">
$dialogue        </div>
    </section>

    <!-- Key Phrases -->
    <section class="article-section">
        <h2>3. Key Phrases 关键句型</h2>
        <ul class="phrase-list">
$phrases        </ul>
    </section>

    <!-- Vocabulary -->
    <section class="article-section">
        <h2>4. Vocabulary 词汇表</h2>
        <ul class="vocab-list">
$vocab        </ul>
    </section>

    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>5. Grammar Notes 语法点</h2>

$grammar    </section>

    <!-- Cultural Tips -->
    <section class="article-section">
        <h2>6. Cultural Tips 文化 / 职场 Tips</h2>
        <ul>
$tips        </ul>
    </section>

    <!-- Practice -->
    <section class="article-section">
        <h2>7. Practice 练习题</h2>

$practice    </section>

    <!-- Navigation -->
    <section class="article-section text-center">
        <p>
$navlinks        </p>
    </section>

</main>

<footer class="site-footer">
    <div class="container">
        <p>&copy; 2026 IT English Learning System · Built for HSBC IT Professionals</p>
    </div>
</footer>

$scripts</body>
</html>
HTML
}

sub _article_list_items {
    my ($arts) = @_;
    my $out = '';
    for my $a (@$arts) {
        my $n2 = sprintf('%02d', $a->{num});
        $out .= "            <li><a href=\"articles/$a->{slug}.html\">\n"
              . "                <span class=\"article-num\">$n2</span>\n"
              . "                <span class=\"article-info\">\n"
              . "                    <span class=\"title\">$a->{title} $a->{cn}</span>\n"
              . "                    <span class=\"desc\">$a->{focus}</span>\n"
              . "                </span>\n"
              . "                <span class=\"article-arrow\">›</span>\n"
              . "            </a></li>\n";
    }
    return $out;
}

sub series_index_page {
    my ($series, $arts, $prefix, $relpath) = @_;
    my $sections = '';
    for my $mi (0 .. $#{ $series->{modules} }) {
        my $m = $series->{modules}[$mi];
        my @mod_arts = grep { $_->{module} == $mi + 1 } @$arts;
        $sections .= "    <!-- Module " . ($mi + 1) . " -->\n"
                   . "    <section class=\"module-section\">\n"
                   . "        <div class=\"module-header\">\n"
                   . "            <div class=\"module-number\">" . ($mi + 1) . "</div>\n"
                   . "            <div class=\"module-title\">\n"
                   . "                <h2>$m->{title}</h2>\n"
                   . "                <p>$m->{sub}</p>\n"
                   . "            </div>\n"
                   . "        </div>\n"
                   . "        <ul class=\"article-list\">\n"
                   . _article_list_items(\\@mod_arts)
                   . "        </ul>\n"
                   . "    </section>\n\n";
    }

    my $title = "$series->{en} | HSBC IT Communication Training";
    my $head = head_scripts($prefix, $title, $series->{meta_desc}, $relpath, 'website');
    my $nav  = navbar($prefix, 'scenarios');
    my $bc   = breadcrumb(['Home', "${prefix}index.html"], ['Scenarios', "${prefix}scenarios/index.html"], [$series->{en}, undef]);
    my $scripts = script_tags($prefix);

    return <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
$head</head>
<body>

$nav
$bc
<main class="page-container">

    <!-- Series Header -->
    <section class="page-header">
        <h1>$series->{en}</h1>
        <p class="subtitle">$series->{cn} · 20 篇场景对话 · Bilingual · Practice-Driven</p>
        <div class="meta">
            <span>📝 20 Articles</span>
            <span>$series->{badge}</span>
            <span>🗣️ Practical Speaking Focus</span>
            <span>🏦 HSBC Banking Context</span>
        </div>
    </section>

    <section class="article-section">
        <h2>About This Series / 关于本系列</h2>
        <p>$series->{blurb_en}</p>
        <p>$series->{blurb_cn}</p>
    </section>

$sections</main>

<footer class="site-footer">
    <div class="container">
        <p>&copy; 2026 IT English Learning System · Built for HSBC IT Professionals</p>
    </div>
</footer>

$scripts</body>
</html>
HTML
}

sub scenarios_index_page {
    my ($series_list, $prefix, $relpath) = @_;
    my $cards = '';
    for my $s (@$series_list) {
        $cards .= "            <div class=\"col-md-6 col-lg-4\">\n"
                . "                <a class=\"role-card d-block\" href=\"$s->{key}/index.html\">\n"
                . "                    <div class=\"role-icon\">$s->{icon}</div>\n"
                . "                    <h3>$s->{en}</h3>\n"
                . "                    <div class=\"role-subtitle\">$s->{cn}</div>\n"
                . "                    <p>$s->{blurb}</p>\n"
                . "                    <div class=\"role-meta\">\n"
                . "                        <span>📄 20 Articles</span>\n"
                . "                        <span>🟢 Available</span>\n"
                . "                    </div>\n"
                . "                </a>\n"
                . "            </div>\n\n";
    }

    my $title = 'Scenario English | Cross-Role Workplace Scenarios';
    my $desc = 'Cross-role workplace English scenarios for HSBC IT professionals: job interviews, first 30 days, small talk and social English. Bilingual dialogues and practice.';
    my $head = head_scripts($prefix, $title, $desc, $relpath, 'website');
    my $nav  = navbar($prefix, 'scenarios');
    my $bc   = breadcrumb(['Home', "${prefix}index.html"], ['Scenarios', undef]);
    my $scripts = script_tags($prefix);

    return <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
$head</head>
<body>

$nav
$bc
<main class="page-container">

    <section class="page-header">
        <h1>Scenario English 通用场景英语</h1>
        <p class="subtitle">跨角色的职场英语场景系列 · For every role, from grad to MD</p>
        <div class="meta">
            <span>📚 3 Series</span>
            <span>📝 60 Articles</span>
            <span>🧭 Role-Agnostic</span>
            <span>🗣️ Practical Speaking Focus</span>
        </div>
    </section>

    <section class="article-section">
        <h2>Why Scenarios? / 为什么需要通用场景</h2>
        <p>
            The eight role tracks cover job-specific conversations. But some situations hit
            <strong>every role</strong>: the interview that gets you in, the first 30 days that
            decide your footing, and the small talk that builds the relationships your career
            runs on. Each series keeps the same 7-part format — Scenario, Dialogue, Key Phrases,
            Vocabulary, Grammar Notes, Cultural Tips, Practice.
        </p>
        <p>
            八大角色板块覆盖岗位专属对话，但有些场景<strong>不分角色</strong>：帮你拿到 Offer 的面试、
            决定你立足点的入职 30 天、以及支撑整个职业生涯的日常社交。每个系列沿用相同的七段式结构：
            场景、对话、关键句型、词汇、语法点、文化 Tips、练习。
        </p>
    </section>

    <section class="article-section">
        <h2>Choose a Series / 选择系列</h2>
        <div class="row g-4 mt-2">
$cards        </div>
    </section>

</main>

<footer class="site-footer">
    <div class="container">
        <p>&copy; 2026 IT English Learning System · Built for HSBC IT Professionals</p>
    </div>
</footer>

$scripts</body>
</html>
HTML
}

1;

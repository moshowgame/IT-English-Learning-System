#!/usr/bin/perl
# Generate sitemap.xml, robots.txt and 404.html from the actual file tree.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename qw(dirname);
use File::Find;
use POSIX qw(strftime);
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');
my $BASE = 'https://moshowgame.github.io/IT-English-Learning-System/';

# ---- collect pages ----
my @pages;
find(sub {
    return unless /\.html$/;
    return if $_ eq '404.html';
    my $rel = abs_path($File::Find::name);
    $rel =~ s/^\Q$ROOT\E[\\\/]?//;
    $rel =~ s{\\}{/}g;
    my $mtime = (stat($File::Find::name))[9];
    push @pages, { rel => $rel, mtime => $mtime };
}, $ROOT);
@pages = sort { $a->{rel} cmp $b->{rel} } @pages;

# ---- sitemap.xml ----
my $sitemap = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            . "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
for my $p (@pages) {
    my $lastmod = strftime('%Y-%m-%d', gmtime($p->{mtime}));
    my $priority = ($p->{rel} eq 'index.html') ? '1.0'
                 : ($p->{rel} =~ m{/articles/}) ? '0.6' : '0.8';
    my $freq = ($p->{rel} =~ m{/articles/}) ? 'monthly' : 'weekly';
    $sitemap .= "  <url>\n    <loc>$BASE$p->{rel}</loc>\n"
              . "    <lastmod>$lastmod</lastmod>\n"
              . "    <changefreq>$freq</changefreq>\n"
              . "    <priority>$priority</priority>\n  </url>\n";
}
$sitemap .= "</urlset>\n";
open(my $out, '>:encoding(UTF-8)', "$ROOT/sitemap.xml") or die $!;
print {$out} $sitemap; close($out);
print "sitemap.xml: " . scalar(@pages) . " URLs\n";

# ---- robots.txt ----
open($out, '>:encoding(UTF-8)', "$ROOT/robots.txt") or die $!;
print {$out} "User-agent: *\nAllow: /\n\nSitemap: ${BASE}sitemap.xml\n";
close($out);
print "robots.txt written\n";

# ---- 404.html ----
my $cards = '';
my @links = (
    ['Home', 'index.html', 'Overview & role chooser'],
    ['BA', 'ba/index.html', 'Business Analyst'],
    ['Developer', 'developer/index.html', 'Developer'],
    ['Tech Lead', 'tech-lead/index.html', 'Technical Lead'],
    ['Architect', 'architect/index.html', 'Architect'],
    ['PM', 'pm/index.html', 'Project Manager'],
    ['CyberSecurity', 'itso/index.html', 'CyberSecurity & IAM'],
    ['Senior Manager', 'senior-manager/index.html', 'Leadership'],
    ['Business', 'business/index.html', 'Business Sponsor'],
    ['Scenarios', 'scenarios/index.html', 'Interview · First 30 Days · Small Talk'],
);
for my $l (@links) {
    $cards .= "        <a class=\"btn btn-outline-primary btn-sm m-1\" href=\"$l->[1]\">$l->[0]</a>\n";
}

my $html = <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 — Page Not Found | IT English Learning System</title>
    <meta name="robots" content="noindex">
    <link rel="icon" type="image/svg+xml" href="assets/images/favicon.svg">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap\@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/common.css">
</head>
<body>

<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="index.html">
                <span class="brand-mark">IT</span>
                <span>English Learning System</span>
            </a>
        </div>
    </nav>
</header>

<main class="page-container">
    <section class="page-header text-center">
        <h1>404 · Page Not Found 页面未找到</h1>
        <p class="subtitle">This page does not exist — but every role and scenario is one click away.</p>
        <div class="meta justify-content-center">
            <span>🧭 Pick a section below</span>
            <span>🏦 HSBC Banking Context</span>
        </div>
    </section>

    <section class="article-section">
        <h2>All Sections / 全部板块</h2>
        <p class="text-center">
$cards        </p>
    </section>
</main>

<footer class="site-footer">
    <div class="container">
        <p>&copy; 2026 IT English Learning System · Built for HSBC IT Professionals</p>
    </div>
</footer>

</body>
</html>
HTML
open($out, '>:encoding(UTF-8)', "$ROOT/404.html") or die $!;
print {$out} $html; close($out);
print "404.html written\n";

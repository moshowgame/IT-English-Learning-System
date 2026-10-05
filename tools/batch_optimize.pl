#!/usr/bin/perl
# Batch-optimize all legacy pages (root + 8 role sections):
#  - replace hand-maintained navbars with the canonical one (adds Scenarios, fixes labels/links)
#  - remove jQuery, fix broken CDN URLs, normalise Bootstrap to jsdelivr 5.3.2
#  - add defer to all external scripts
#  - inject SEO head: description, canonical, og tags, favicon, preconnect, theme-color
# Idempotent: safe to run repeatedly.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename qw(dirname basename);
use File::Find;
use Cwd 'abs_path';
use lib abs_path(dirname(abs_path($0)) . '/lib');
use site qw(navbar);

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');
my $BASE = 'https://moshowgame.github.io/IT-English-Learning-System/';

my %NAVKEY = (ba => 'ba', developer => 'developer', 'tech-lead' => 'tech-lead',
              architect => 'architect', pm => 'pm', itso => 'itso',
              'senior-manager' => 'senior-manager', business => 'business');

my %INDEX_DESC = (
    'ba'             => 'Practical English for HSBC Business Analysts: standups, requirements workshops, stakeholder pushback, banking compliance. 20 bilingual scenario articles.',
    'developer'      => 'Practical English for HSBC Developers: standups, code reviews, production incidents, cross-timezone collaboration. 20 bilingual scenario articles.',
    'tech-lead'      => 'Practical English for HSBC Tech Leads: sprint planning, mentoring, technical decisions, deadline pushback. 20 bilingual scenario articles.',
    'architect'      => 'Practical English for HSBC Architects: design reviews, ADRs, NFR workshops, CTO conversations. 20 bilingual scenario articles.',
    'pm'             => 'Practical English for HSBC Project Managers: SteerCo updates, RAID logs, escalations, regulatory programmes. 20 bilingual scenario articles.',
    'itso'           => 'CyberSecurity & IAM English for HSBC: incident response, PCI-DSS/GDPR audits, access management, regulator conversations. 20 bilingual scenario articles.',
    'senior-manager' => 'Executive English for HSBC Senior Managers: SteerCo decks, board papers, strategy, succession and difficult conversations. 20 bilingual scenario articles.',
    'business'       => 'English for HSBC Business Sponsors: UAT sign-off, business cases, priorities, escalations with IT. 20 bilingual scenario articles.',
);

sub esc_attr {
    my ($s) = @_;
    $s =~ s/&/&amp;/g; $s =~ s/</&lt;/g; $s =~ s/>/&gt;/g; $s =~ s/"/&quot;/g;
    return $s;
}

sub article_description {
    my ($html, $role) = @_;
    my ($h1)    = $html =~ /<h1>([^<]+)<\/h1>/;
    my ($focus) = $html =~ /([\x{1F3AF}][^<]+)/;   # 🎯 focus line
    $h1    //= 'Workplace scenario';
    $focus //= 'bilingual dialogue with key phrases and practice';
    $focus =~ s/\s+/ /g; $focus =~ s/^\s+|\s+$//g;
    my $desc = "$h1 — $focus. Bilingual dialogue, key phrases, vocabulary and practice for HSBC $role English.";
    if (length($desc) > 165) {
        $desc = substr($desc, 0, 162);
        $desc =~ s/\s+\S*$//;
        $desc .= '…';
    }
    return $desc;
}

my @files;
find(sub {
    return unless /\.html$/;
    my $dir = $File::Find::dir;
    return if $dir =~ /[\\\/]scenarios([\\\/]|$)/;   # scenarios pages are already final
    my $rel = abs_path($File::Find::name);
    $rel =~ s/^\Q$ROOT\E[\\\/]?//;
    $rel =~ s{\\}{/}g;
    push @files, { path => $File::Find::name, rel => $rel };
}, $ROOT);
@files = sort { $a->{rel} cmp $b->{rel} } @files;

my ($nav_fixed, $head_fixed, $jq_removed, $cdn_fixed, $defer_added) = (0, 0, 0, 0, 0);

for my $f (@files) {
    my $rel = $f->{rel};
    open(my $fh, '<:encoding(UTF-8)', $f->{path}) or die "$f->{path}: $!";
    local $/; my $html = <$fh>; close($fh);
    my $orig = $html;

    # ---- path metadata ----
    my $prefix;
    my @segs = split m{/}, $rel;
    if ($rel eq 'index.html') { $prefix = ''; }
    elsif (@segs == 2)        { $prefix = '../'; }
    else                      { $prefix = '../../'; }

    my ($topdir) = $rel =~ m{^([^/]+)/};
    my $active = defined $topdir ? ($NAVKEY{$topdir} // $topdir) : 'home';

    # ---- 1. canonical navbar replacement ----
    my $nav = navbar($prefix, $active);
    if ($html =~ s{<header class="site-header">.*?</header>}{$nav}s) {
        $nav_fixed++;
    }

    # ---- 2. CDN hygiene ----
    # broken hosts / filenames
    if ($html =~ s{https://cdn\.jsdu\.net}{https://cdn.jsdelivr.net}g) { $cdn_fixed++; }
    if ($html =~ s{dist/js/javascript\.bundle\.min\.js}{dist/js/bootstrap.bundle.min.js}g) { $cdn_fixed++; }
    # normalise bootstrap to canonical jsdelivr 5.3.2
    $html =~ s{https://[^"'\s]+/npm/bootstrap\@[\d.]+/dist/css/bootstrap\.min\.css}{https://cdn.jsdelivr.net/npm/bootstrap\@5.3.2/dist/css/bootstrap.min.css}g;
    $html =~ s{https://[^"'\s]+/npm/bootstrap\@[\d.]+/dist/js/bootstrap\.bundle\.min\.js}{https://cdn.jsdelivr.net/npm/bootstrap\@5.3.2/dist/js/bootstrap.bundle.min.js}g;
    # normalise jquery CDN (before removal, to catch strays) — then remove jQuery entirely
    $html =~ s{<script src="https://(?:code\.jquery\.com|cdn\.jsdelivr\.net)/[^"]*jquery[^"]*"></script>\s*\n?}{}g;
    $jq_removed++ if $html ne $orig;

    # ---- 3. defer on all external scripts ----
    my $before = $html;
    $html =~ s{<script src="([^"]+)"></script>}{<script src="$1" defer></script>}g;
    $defer_added++ if $html ne $before;

    # ---- 4. SEO head injection (once) ----
    unless ($html =~ /rel="canonical"/) {
        my $desc;
        if ($rel eq 'index.html') {
            ($desc) = $html =~ /name="description" content="([^"]+)"/;
            $desc //= 'Role-based practical English training for HSBC IT teams: 8 roles, 160 articles plus cross-role scenario series.';
        } elsif (@segs == 2) {
            $desc = $INDEX_DESC{$topdir};
        } else {
            my ($role_label) = $topdir =~ /^itso$/ ? 'CyberSecurity' : ucfirst($topdir =~ s/-/ /gr);
            $role_label = 'Tech Lead' if $topdir eq 'tech-lead';
            $desc = article_description($html, $role_label);
        }
        my $canonical = $BASE . $rel;
        my ($title) = $html =~ /<title>([^<]+)<\/title>/;
        $title //= 'IT English Learning System';
        my $ogtype = (@segs >= 3) ? 'article' : 'website';
        my $head = join("\n",
            "    <meta name=\"description\" content=\"" . esc_attr($desc) . "\">",
            "    <link rel=\"canonical\" href=\"$canonical\">",
            "    <meta name=\"theme-color\" content=\"#002855\">",
            "    <meta property=\"og:type\" content=\"$ogtype\">",
            "    <meta property=\"og:title\" content=\"" . esc_attr($title) . "\">",
            "    <meta property=\"og:description\" content=\"" . esc_attr($desc) . "\">",
            "    <meta property=\"og:url\" content=\"$canonical\">",
            "    <meta property=\"og:site_name\" content=\"IT English Learning System\">",
            "    <meta property=\"og:locale\" content=\"en_US\">",
            "    <link rel=\"icon\" type=\"image/svg+xml\" href=\"${prefix}assets/images/favicon.svg\">",
            "    <link rel=\"preconnect\" href=\"https://cdn.jsdelivr.net\" crossorigin>",
        );
        if ($html =~ s{(<title>[^<]*</title>\r?\n)}{$1$head\n}) {
            $head_fixed++;
        } else {
            warn "no title anchor in $rel\n";
        }
    }

    if ($html ne $orig) {
        open(my $out, '>:encoding(UTF-8)', $f->{path}) or die "$f->{path}: $!";
        print {$out} $html; close($out);
    }
}

printf "Batch done: %d files | nav replaced: %d | heads injected: %d | jQuery removed: %d | CDN fixed: %d | defer added: %d\n",
    scalar(@files), $nav_fixed, $head_fixed, $jq_removed, $cdn_fixed, $defer_added;

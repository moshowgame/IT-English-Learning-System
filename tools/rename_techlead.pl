#!/usr/bin/perl
# Number the tech-lead articles: git mv SLUG.html -> NN-SLUG.html in index order,
# then update links in tech-lead/index.html and prev/next links inside articles.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename;
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');
my @ORDER = qw(
    tl-standup-update sprint-planning-lead backlog-refinement-tl one-on-one-mentoring
    cross-timezone-squad-sync running-code-review choosing-tech-approach tech-spike-poc-planning
    pair-programming-session tech-debt-sprint-planning code-review-summary-email adr-decision-email
    engineering-all-hands-update pushing-back-deadline telling-senior-dev-design-wrong saying-no-quick-fix
    handling-production-incident-escalation banking-compliance-tech-lead kyc-aml-engineering-practices
    banking-systems-integration
);

my %MAP;
for my $i (0 .. $#ORDER) {
    my $n = sprintf('%02d', $i + 1);
    $MAP{$ORDER[$i]} = "${n}-$ORDER[$i]";
}

# 1. git mv each file
for my $slug (keys %MAP) {
    my $old = "$ROOT/tech-lead/articles/$slug.html";
    my $new = "$ROOT/tech-lead/articles/$MAP{$slug}.html";
    die "missing $old\n"    unless -f $old;
    die "exists $new\n"     if -f $new;
    system('git', 'mv', "tech-lead/articles/$slug.html", "tech-lead/articles/$MAP{$slug}.html") == 0
        or die "git mv failed for $slug\n";
    print "mv  $slug.html -> $MAP{$slug}.html\n";
}

# 2. rewrite references: in tech-lead/index.html and all tech-lead article bodies
my @targets = ("$ROOT/tech-lead/index.html", glob("$ROOT/tech-lead/articles/*.html"));
for my $file (@targets) {
    open(my $fh, '<:encoding(UTF-8)', $file) or die "$file: $!";
    local $/; my $html = <$fh>; close($fh);
    my $before = $html;
    for my $slug (keys %MAP) {
        $html =~ s{href="articles/\Q$slug\E\.html"}{href="articles/$MAP{$slug}.html"}g;
        $html =~ s{href="\Q$slug\E\.html"}{href="$MAP{$slug}.html"}g;
    }
    if ($html ne $before) {
        open(my $out, '>:encoding(UTF-8)', $file) or die "$file: $!";
        print {$out} $html; close($out);
        print "links updated: ", basename($file), "\n";
    }
}

# 3. safety: any reference outside tech-lead/?
my $hits = `git grep -l -E "($ORDER[0]|tl-standup-update)" -- ':!tech-lead' 2>/dev/null`;
print "references outside tech-lead: " . ($hits =~ /\S/ ? $hits : "none\n");
print "Done.\n";

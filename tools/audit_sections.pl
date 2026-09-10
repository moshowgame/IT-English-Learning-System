#!/usr/bin/perl
# Scan all role articles for 7-section template coverage and difficulty levels.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename;
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');
my @ROLES = qw(ba developer tech-lead architect pm itso senior-manager business);

my %MARKERS = (
    scenario   => qr/<h2>\s*1\.\s*Scenario/i,
    dialogue   => qr/class="dialogue-block"/i,
    phrases    => qr/class="phrase-list"/i,
    vocabulary => qr/<h2>\s*4\.\s*Vocabulary/i,
    grammar    => qr/<h2>\s*\d?\.\s*Grammar Notes/i,
    cultural   => qr/<h2>\s*\d?\.\s*Cultural Tips/i,
    practice   => qr/<h2>\s*\d?\.\s*Practice/i,
    summary    => qr/<h2>\s*\d?\.\s*Summary/i,
);

my @unnumbered;
for my $role (@ROLES) {
    opendir(my $dh, "$ROOT/$role/articles") or die "$role: $!";
    my @files = sort grep { /\.html$/ } readdir($dh);
    closedir($dh);

    my ($no_grammar, $no_practice, $with_summary) = (0, 0, 0);
    my %diffs;
    my @missing_lines;
    for my $f (@files) {
        open(my $fh, '<:encoding(UTF-8)', "$ROOT/$role/articles/$f") or die "$f: $!";
        local $/; my $html = <$fh>; close($fh);
        my @missing = grep { $html !~ $MARKERS{$_} } sort keys %MARKERS;
        my ($diff) = $html =~ /([\x{1F7E2}\x{1F7E1}\x{1F534}])/;
        $diff //= 'NONE';
        $diffs{$diff}++;
        my ($num) = $f =~ /^(\d+)/;
        push @unnumbered, "$role/$f" unless $num;
        $no_grammar++   if grep { $_ eq 'grammar' } @missing;
        $no_practice++  if grep { $_ eq 'practice' } @missing;
        $with_summary++ unless grep { $_ eq 'summary' } @missing;
        my @real = grep { $_ ne 'summary' } @missing;
        push @missing_lines, "   $f missing: " . join(',', @real) . " [$diff]" if @real;
    }
    print "$role: " . scalar(@files) . " articles | no-grammar:$no_grammar no-practice:$no_practice with-summary:$with_summary | difficulty " .
          join(' ', map {"$_:$diffs{$_}"} sort keys %diffs) . "\n";
    print "$_\n" for @missing_lines;
}
print "\nUnnumbered files:\n";
print "   $_\n" for @unnumbered;

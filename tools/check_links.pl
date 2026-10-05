#!/usr/bin/perl
# Full-site link checker: verifies every internal href/src in every .html file resolves.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename qw(dirname);
use File::Find;
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');

# index of all files (posix-style relative)
my %exists;
find(sub {
    return unless -f $_;
    my $rel = abs_path($File::Find::name);
    $rel =~ s/^\Q$ROOT\E[\\\/]?//;
    $rel =~ s{\\}{/}g;
    $exists{lc $rel} = 1;
}, $ROOT);

my ($checked, $bad) = (0, 0);
find(sub {
    return unless /\.html$/;
    my $file = $File::Find::name;
    my $dir  = $File::Find::dir;
    open(my $fh, '<:encoding(UTF-8)', $file) or die "$file: $!";
    my $pos = 0;
    while (my $line = <$fh>) {
        $pos++;
        while ($line =~ /(?:href|src)="([^"]+)"/g) {
            my $url = $1;
            next if $url =~ /^(https?:|#|mailto:|data:)/;
            $checked++;
            # resolve relative to the file's directory
            my ($rel) = abs_path("$dir/$url") =~ /^\Q$ROOT\E[\\\/]?(.*)$/s;
            unless (defined $rel) {
                print "ESCAPES-ROOT: $file:$pos -> $url\n"; $bad++; next;
            }
            $rel =~ s{\\}{/}g;
            unless ($exists{lc $rel}) {
                print "BROKEN: $file:$pos -> $url\n";
                $bad++;
            }
        }
    }
    close($fh);
}, $ROOT);

print "Checked $checked internal links across site: " . ($bad ? "$bad BROKEN" : "all OK") . "\n";
exit($bad ? 1 : 0);

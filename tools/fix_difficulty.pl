#!/usr/bin/perl
# Add difficulty badges to article pages whose .meta lacks one.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename;
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');

my %LEVEL = (
    # ba
    'ba/articles/06-requirements-elicitation.html'   => '🟡 Intermediate',
    'ba/articles/09-brd-frd-walkthrough.html'        => '🟡 Intermediate',
    # tech-lead (numbered names)
    'tech-lead/articles/10-tech-debt-sprint-planning.html'      => '🟡 Intermediate',
    'tech-lead/articles/12-adr-decision-email.html'             => '🟡 Intermediate',
    'tech-lead/articles/18-banking-compliance-tech-lead.html'   => '🟡 Intermediate',
    'tech-lead/articles/19-kyc-aml-engineering-practices.html'  => '🔴 Advanced',
    # architect
    'architect/articles/03-design-review-meeting.html'          => '🟡 Intermediate',
    'architect/articles/05-cross-team-sync.html'                => '🟡 Intermediate',
    'architect/articles/06-writing-an-adr.html'                 => '🟡 Intermediate',
    'architect/articles/09-api-design-discussion.html'          => '🟡 Intermediate',
    'architect/articles/10-event-driven-architecture.html'      => '🔴 Advanced',
    'architect/articles/11-architecture-decision-email.html'    => '🟡 Intermediate',
    'architect/articles/13-tech-risk-memo.html'                 => '🔴 Advanced',
    'architect/articles/14-pushback-overengineering.html'       => '🔴 Advanced',
    'architect/articles/17-disagreeing-cto.html'                => '🔴 Advanced',
    'architect/articles/19-banking-architecture-terminology.html' => '🟢 Beginner-friendly',
    # pm
    'pm/articles/06-steerco-update.html'            => '🟡 Intermediate',
    'pm/articles/09-phase-gate-review.html'         => '🔴 Advanced',
    'pm/articles/13-risk-escalation-email.html'     => '🟡 Intermediate',
    'pm/articles/15-telling-sponsor-slip.html'      => '🔴 Advanced',
    'pm/articles/16-negotiating-scope.html'         => '🔴 Advanced',
    'pm/articles/17-managing-underperformer.html'   => '🔴 Advanced',
    'pm/articles/18-saying-no-last-minute.html'     => '🔴 Advanced',
    'pm/articles/19-banking-pm-terminology.html'    => '🟢 Beginner-friendly',
    # itso
    'itso/articles/05-threat-intel-briefing.html'   => '🟡 Intermediate',
    'itso/articles/06-pci-dss-audit.html'           => '🔴 Advanced',
    'itso/articles/08-mas-trm-cyber-hygiene.html'   => '🟡 Intermediate',
    'itso/articles/09-hkma-cyber-resilience.html'   => '🟡 Intermediate',
    'itso/articles/11-incident-notification.html'   => '🟡 Intermediate',
    'itso/articles/12-risk-acceptance-memo.html'    => '🟡 Intermediate',
    'itso/articles/13-audit-finding-response.html'  => '🟡 Intermediate',
    'itso/articles/14-vulnerability-disclosure.html'=> '🟡 Intermediate',
    'itso/articles/15-telling-sponsor-data-breach.html' => '🔴 Advanced',
    'itso/articles/16-pushback-security-waiver.html'=> '🔴 Advanced',
    'itso/articles/17-stop-risky-deploy.html'       => '🔴 Advanced',
    'itso/articles/18-convincing-md-mfa-pam.html'   => '🔴 Advanced',
    # senior-manager
    'senior-manager/articles/01-steerco-monthly-deck.html'      => '🔴 Advanced',
    'senior-manager/articles/02-board-update-paper.html'        => '🔴 Expert',
    'senior-manager/articles/03-qbr-business-md.html'           => '🔴 Advanced',
    'senior-manager/articles/04-annual-it-strategy.html'        => '🔴 Expert',
    'senior-manager/articles/05-vendor-rfp-decision.html'       => '🔴 Advanced',
    'senior-manager/articles/08-org-design-restructure.html'    => '🔴 Expert',
    'senior-manager/articles/11-promotion-denial.html'          => '🔴 Advanced',
    'senior-manager/articles/13-cfo-capex-conversation.html'    => '🔴 Expert',
    'senior-manager/articles/14-cro-cyber-conversation.html'    => '🔴 Expert',
    'senior-manager/articles/15-coo-operations-conversation.html' => '🔴 Advanced',
    'senior-manager/articles/16-business-md-priorities.html'    => '🔴 Advanced',
    'senior-manager/articles/17-hsbc-group-governance.html'     => '🔴 Expert',
    'senior-manager/articles/19-subsidiary-delegated-authority.html' => '🔴 Expert',
    'senior-manager/articles/20-succession-planning.html'       => '🔴 Expert',
    # business
    'business/articles/07-mvp-cut-conversation.html'    => '🟡 Intermediate',
    'business/articles/08-uat-go-live-trade.html'       => '🔴 Advanced',
    'business/articles/11-business-case.html'           => '🟡 Intermediate',
    'business/articles/13-saying-no-to-it-timeline.html'=> '🔴 Advanced',
    'business/articles/14-scope-cut-pushback.html'      => '🔴 Advanced',
    'business/articles/16-post-incident-business-review.html' => '🟡 Intermediate',
    'business/articles/17-pl-walkthrough.html'          => '🔴 Advanced',
    'business/articles/18-regulatory-drivers.html'      => '🟡 Intermediate',
);

my ($ok, $skip) = (0, 0);
for my $rel (sort keys %LEVEL) {
    my $path = "$ROOT/$rel";
    unless (-f $path) { print "MISSING: $rel\n"; next; }
    open(my $fh, '<:encoding(UTF-8)', $path) or die "$path: $!";
    local $/; my $html = <$fh>; close($fh);
    next if $html =~ /[\x{1F7E2}\x{1F7E1}\x{1F534}]/; # already has a badge
    unless ($html =~ s{(<span>⏱[^<]*</span>)}{$1\n            <span>$LEVEL{$rel}</span>}) {
        print "NO-META: $rel\n";
        next;
    }
    open(my $out, '>:encoding(UTF-8)', $path) or die "$path: $!";
    print {$out} $html; close($out);
    $ok++;
}
print "Done. $ok badges added, $skip skipped.\n";

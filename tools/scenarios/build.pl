#!/usr/bin/perl
# Build the scenarios/ section: 3 series x 20 articles + series indexes + overview.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename qw(dirname);
use Cwd 'abs_path';
use lib abs_path(dirname(abs_path($0)) . '/../lib');
use site qw(article_page series_index_page scenarios_index_page);

my $ROOT = abs_path(dirname(abs_path($0)) . '/../..');

my %SERIES = (
    'job-interview' => {
        en => 'Job Interview English', cn => '求职与英文面试', icon => 'JI',
        badge => '💼 Candidate View',
        blurb => 'From CV screening to offer call — the candidate-side English that gets you hired.',
        blurb_en => 'The eight role tracks teach you the job. This series gets you the job. It covers the interview journey from the candidate\'s chair: CV screening calls, the "tell me about yourself" opener, behavioural and technical questions, panel dynamics, salary conversations, and everything after the room — thank-you emails, follow-ups, rejections and offers.',
        blurb_cn => '八大角色板块教你做这份工作，本系列帮你拿到这份工作。覆盖应聘者视角的完整面试旅程：简历初筛电话、"请介绍一下你自己"开场、行为面与技术面、多面试官场面、薪资沟通，以及面试后的跟进邮件、拒信应对与 Offer 谈判。',
        meta_desc => 'Job interview English for HSBC IT candidates: CV screening, behavioural and technical interviews, salary negotiation, follow-up emails. Bilingual dialogues and practice.',
        modules => [
            { title => 'Getting Ready 准备阶段',       sub => '简历、开场自我介绍、研究银行与岗位、STAR 故事库' },
            { title => 'In the Interview Room 面试现场', sub => '行为面、讲项目、设计题、答不上来怎么办' },
            { title => 'Closing the Room 收尾环节',     sub => '反问环节、薪资期望、多面试官、视频面试礼仪' },
            { title => 'After the Interview 面试之后',  sub => '感谢邮件、进度跟进、拒信应对、Offer 沟通' },
            { title => 'Special Situations 特殊场景',   sub => '转行故事、职业空窗、跨地区面试、合同 vs 长期' },
        ],
    },
    'first-30-days' => {
        en => 'First 30 Days English', cn => '新员工入职 30 天', icon => '30D',
        badge => '🌱 New Joiner',
        blurb => 'Survival English for your first month — from day-one intros to the 30-day review.',
        blurb_en => 'The first 30 days decide how fast you find your feet. This series walks one full month: day-one introductions, getting your access sorted, your first standup, asking questions that sound thoughtful instead of lost, understanding accents on fast calls, the first 1:1, the first status update, and the 30-day review that sets your next quarter.',
        blurb_cn => '入职第一个月决定你多快站稳脚跟。本系列完整走完一个月：第一天的自我介绍、搞定权限与设备、第一次站会、把问题问得体面而不是显得迷茫、听懂语速很快的跨国电话、第一次 1:1、第一次进度汇报，以及定调下一季度的 30 天复盘。',
        meta_desc => 'First 30 days survival English for new HSBC IT joiners: day-one introductions, first standup, asking for help, first 1:1, 30-day review. Bilingual dialogues and practice.',
        modules => [
            { title => 'Day One 第一天',        sub => '自我介绍、找 IT 要权限、破译团队黑话、与经理第一次咖啡' },
            { title => 'Week One 第一周',       sub => '第一次站会、把问题问好、认人识别架构、团队午餐' },
            { title => 'Week Two 第二周',       sub => '求助的艺术、会议纪要与跟进、听懂口音、第一次 1:1' },
            { title => 'Weeks Three & Four 第三四周', sub => '第一次进度汇报、结对观察、合规培训、第一个小贡献' },
            { title => 'Day 30 满月复盘',       sub => '30 天 review、可执行的反馈、内部人脉、第一次回顾会发言' },
        ],
    },
    'small-talk' => {
        en => 'Small Talk & Social English', cn => '职场社交英语', icon => 'ST',
        badge => '☕ Everyday Rapport',
        blurb => 'Tea points, lifts, lunches and video calls — the everyday English relationships are built on.',
        blurb_en => 'Careers run on relationships, and relationships run on small talk. This series covers the everyday moments no role track teaches: tea-point exchanges, lift encounters, Monday-morning recaps, pre-meeting banter on video calls, team lunches, Friday drinks, cross-cultural cues across UK/HK/CN offices — plus the recovery skills for when conversation stalls and the boundaries for when it should end.',
        blurb_cn => '职业生涯靠关系推进，关系靠日常闲聊维护。本系列覆盖所有角色板块都不教的日常时刻：茶水间寒暄、电梯偶遇、周一早晨的周末回顾、视频会前的闲聊、团队午餐、周五小酌、UK/HK/CN 跨文化分寸——以及聊不下去时的救场话术和该结束时的得体退出。',
        meta_desc => 'Workplace small talk and social English for HSBC IT teams: tea points, lifts, team lunches, video call banter, cross-cultural cues. Bilingual dialogues and practice.',
        modules => [
            { title => 'Daily Moments 日常时刻',   sub => '茶水间、电梯偶遇、周一寒暄、安全话题雷达' },
            { title => 'Online & Remote 远程社交', sub => '视频会前闲聊、远程咖啡、聊天频道、表情包与语气' },
            { title => 'Team Events 团队活动',     sub => '团队午餐、周五小酌、团建日、迎新与欢送' },
            { title => 'Building Rapport 建立联结', sub => '找到共同兴趣、UK/HK/CN 跨文化、与高管闲聊、硬会议前的暖场' },
            { title => 'Boundaries & Recovery 边界与救场', sub => '话题红线与退出、冷场急救、记住名字、从闲聊到关系' },
        ],
    },
);

my @ORDER = ('job-interview', 'first-30-days', 'small-talk');

for my $key (@ORDER) {
    my $s = $SERIES{$key};
    my @arts;
    for my $part (qw(a b)) {
        my $file = "$ROOT/tools/scenarios/data/${key}_$part.pl";
        my $ret = do $file;
        die "cannot load $file: $@\n" unless $ret && ref $ret eq 'ARRAY';
        push @arts, @$ret;
    }
    @arts = sort { $a->{num} <=> $b->{num} } @arts;
    die "$key: expected 20 articles, got " . scalar(@arts) . "\n" unless @arts == 20;
    for my $a (@arts) {
        $a->{file} = sprintf('%02d', $a->{num}) . "-$a->{slug}.html";
        for my $field (qw(title cn focus)) { die "$key: $a->{num} missing $field\n" unless $a->{$field}; }
        for my $field (qw(scenario dialogue phrases vocab grammar tips practice)) {
            die "$key: $a->{num} missing $field\n" unless $a->{$field} && ref $a->{$field} eq 'ARRAY' && @{ $a->{$field} };
        }
    }

    my $adir = "$ROOT/scenarios/$key/articles";
    system('mkdir', '-p', $adir) == 0 or die "mkdir $adir failed\n";

    for my $i (0 .. $#arts) {
        my $a = $arts[$i];
        my $prev = $i > 0            ? $arts[$i - 1] : undef;
        my $next = $i < $#arts       ? $arts[$i + 1] : undef;
        my $rel  = "scenarios/$key/articles/$a->{file}";
        open(my $out, '>:encoding(UTF-8)', "$ROOT/$rel")
            or die "$rel: $!";
        print {$out} article_page($a, $s, '../../../', $rel, $prev, $next);
        close($out);
    }

    my $irel = "scenarios/$key/index.html";
    open(my $out, '>:encoding(UTF-8)', "$ROOT/$irel") or die "$irel: $!";
    print {$out} series_index_page($s, \@arts, '../../', $irel);
    close($out);
    print "OK: $key (20 articles + index)\n";
}

my $rel = 'scenarios/index.html';
open(my $out, '>:encoding(UTF-8)', "$ROOT/$rel") or die "$rel: $!";
print {$out} scenarios_index_page([ map { my %h = %{ $SERIES{$_} }; $h{key} = $_; \%h } @ORDER ], '../', $rel);
close($out);
print "OK: scenarios/index.html\n";
print "All scenarios built.\n";

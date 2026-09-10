#!/usr/bin/perl
# Insert a Grammar Notes section into articles that lack one (before Cultural Tips),
# then renumber all leading-numbered h2 headings sequentially.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use File::Basename;
use Cwd 'abs_path';

my $ROOT = abs_path(dirname(abs_path($0)) . '/..');

# Per-article Grammar Notes content (2 points each), grounded in each article's own phrases.
my %GRAMMAR = (

'itso/articles/11-incident-notification.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① The passive voice keeps incident facts neutral</h3>
        <p>
            Incident notifications state damage and scope in the <strong>passive voice</strong>:
            <em>"No passwords, no transaction history, no payment card data, no identity document
            numbers were exposed."</em> The passive removes the agent ("who did it") so the reader
            focuses on <strong>what happened</strong>, not on blame. Use it for exposure statements,
            containment steps, and next actions: <em>systems were isolated</em>, <em>credentials
            were rotated</em>, <em>the supervisor was notified</em>.
        </p>
        <p>
            事件通报里描述影响范围要用被动语态："…were exposed"。被动语态隐去动作执行者，让读者聚焦
            <strong>事实本身</strong>而不是追责。隔离系统、轮换凭证、通报监管等动作都适合被动表达。
        </p>

        <h3>② Present simple for evidence, "preliminary" for conclusions</h3>
        <p>
            Evidence statements use the <strong>present simple</strong>: <em>"Cloud provider access
            logs show 0 GET requests from non-bank IPs."</em> The logs still exist and still show it,
            so present simple is correct — not past simple. Conclusions are labelled, not asserted:
            <em>"Preliminary conclusion: no evidence of data exfiltration."</em> The adjective
            <strong>preliminary</strong> protects you — "no evidence of X" is a factual statement,
            while "X did not happen" is a guarantee you cannot give on day one.
        </p>
        <p>
            证据描述用一般现在时（logs <em>show</em>…），因为证据现在仍然成立。结论必须加限定词：
            "Preliminary conclusion: no evidence of…"（初步结论：没有……的证据）——它不等于"没有发生"，
            第一天不要把话说死。
        </p>
    </section>

HTML

'itso/articles/12-risk-acceptance-memo.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Nominalisation — memo headlines without verbs</h3>
        <p>
            Formal memos compress information into <strong>noun phrases</strong> instead of full
            sentences: <em>"Net residual risk rating: Medium."</em>, <em>"Waiver effective
            1 September 2026 to 31 March 2027 (7 months)."</em>, <em>"No automatic renewal."</em>
            Notice there is no verb at all — the colon and the noun carry the meaning. This
            "spec-sheet register" makes the memo scannable and makes each line quotable in an audit.
        </p>
        <p>
            正式备忘录用<strong>名词短语</strong>代替完整句子："Net residual risk rating: Medium"、
            "Waiver effective… (7 months)"、"No automatic renewal"——整句没有动词，冒号和名词承担全部
            含义。这种"规格书语域"让备忘录可扫读、每行都可直接引用。
        </p>

        <h3>② Tense contrast in brackets — "was High before…"</h3>
        <p>
            <em>"Net residual risk rating: Medium (was High before compensating controls)."</em>
            The bracket holds a deliberate <strong>tense contrast</strong>: present-tense rating
            (Medium <em>now</em>), past-tense history (High <em>before</em>). The past simple marks
            the improvement as completed; the present simple states today's position. One bracket,
            and the reviewer sees both the mitigation and the trajectory.
        </p>
        <p>
            括号里藏着刻意的<strong>时态对比</strong>：现在的评级用一般现在时（Medium），改善前的状态
            用一般过去时（was High before…）。一个括号，同时呈现"缓解措施已生效"和"风险已下降"两条信息。
        </p>
    </section>

HTML

'itso/articles/13-audit-finding-response.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① "Management agrees" — the institution speaks in third person</h3>
        <p>
            Audit responses are written from the institution, not from "I": <em>"Management agrees
            with the finding. Management accepts the rating of Medium."</em> Third person + present
            simple signals an <strong>official organisational position</strong>, not a personal
            opinion. Save "I" for the action rows, where a named human must own the work:
            <em>"Action 1 owner: Maria Tan."</em>
        </p>
        <p>
            审计回复以机构而非个人口吻书写："Management agrees… / Management accepts…"——第三人称 +
            一般现在时表明这是<strong>组织的正式立场</strong>。"I"只出现在行动项里，因为行动必须落到
            具体的人："Action 1 owner: Maria Tan"。
        </p>

        <h3>② Relative clauses explain causes without excuses</h3>
        <p>
            <em>"The IAM team was redirected to a P1 incident for 9 working days, which fell inside
            the campaign window."</em> The non-defining relative clause (<strong>which</strong> +
            past simple) adds the causal context in one breath, without turning the sentence into
            an apology. Pair it with a compounding-factors line: <em>"Compounding factor: …"</em> —
            a noun-phrase headline that lists context without arguing.
        </p>
        <p>
            非限定性定语从句（…, <strong>which</strong> fell inside…）一口气补齐因果背景，却不会把句子
            变成辩解。再配一个名词短语式标题行"Compounding factor: …"，把背景摆出来而不争论。
        </p>
    </section>

HTML

'itso/articles/14-vulnerability-disclosure.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① The obligation ladder: must → per Standard → by Friday</h3>
        <p>
            Disclosure emails express obligation in three registers. The standard states the rule:
            <em>"Per Group Vulnerability Management Standard v2.3 §5.1: Critical CVE — workaround
            within 48 hours, full patch within 7 days."</em> Your commitment operationalises it:
            <em>"Workaround by Friday, full patch by next Thursday."</em> Notice there is no "must"
            anywhere — <strong>per + document</strong> carries the obligation, and the <strong>by +
            time</strong> phrase carries the deadline. Save explicit "must" for what the other party
            must do.
        </p>
        <p>
            披露邮件用三个层级表达义务：标准定规则（Per Group … Standard §5.1: …）、自己的承诺落时间
            （Workaround by Friday, full patch by next Thursday）。全文没有出现 "must"——<strong>per +
            文件名</strong>自带义务感，<strong>by + 时间</strong>自带截止感。把显式的 must 留给要求对方
            做的事。
        </p>

        <h3>② Comma stacks as a spec-sheet register</h3>
        <p>
            <em>"CVE-2026-31415, Apache Log4j, RCE, CVSS 9.8 (Critical)."</em> — four data points,
            zero verbs, one sentence. Security English loves this <strong>comma-stack headline</strong>
            because scanners and humans can both parse it. The same pattern scales up:
            <em>"4 retail-banking systems confirmed affected: payment-gateway, customer-portal,
            account-opening-mobile, statement-service."</em> — count first, colon, then the list.
        </p>
        <p>
            "CVE-2026-31415, Apache Log4j, RCE, CVSS 9.8 (Critical)."——四个数据点、零动词、一句话。
            安全英语偏爱这种<strong>逗号堆叠的规格书句式</strong>：人和扫描器都能一眼解析。放大版是
            "数量 + 冒号 + 清单"："4 … systems confirmed affected: A, B, C, D."
        </p>
    </section>

HTML

'itso/articles/15-telling-sponsor-data-breach.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Framing devices: "I'll be straight with the facts"</h3>
        <p>
            Hard conversations need a <strong>framing sentence</strong> before the content:
            <em>"I'll be straight with the facts."</em> It tells the listener how to interpret
            everything that follows — no spin, no hedging. The same trick powers the structure:
            <em>"Three decisions. Decision 1, Decision 2, Decision 3."</em> Announce the count,
            then walk it — the listener always knows where they are in your update.
        </p>
        <p>
            硬对话在进入内容前需要一句<strong>定调句</strong>："I'll be straight with the facts"——
            告诉对方接下来的话不加修饰。同样的技巧支撑结构："Three decisions. Decision 1, …"——
            先报数量再逐条走，听者永远知道自己在你汇报的哪个位置。
        </p>

        <h3>② "No evidence of X" ≠ "X did not happen"</h3>
        <p>
            Compare: <em>"Preliminary conclusion: no evidence of data exfiltration."</em> versus
            "No data was exfiltrated." The first is a statement about <strong>evidence</strong> —
            grammatically a noun phrase ("evidence of + noun") — and it stays true even if new
            facts arrive. The second is a claim about <strong>reality</strong> that you may have
            to retract. In breach conversations, choose the grammar you can defend on day 30.
        </p>
        <p>
            对比："Preliminary conclusion: no evidence of data exfiltration" 与 "No data was
            exfiltrated"。前者是对<strong>证据</strong>的陈述（evidence of + 名词），即使后续出现新事实
            依然成立；后者是对<strong>现实</strong>的断言，可能被迫收回。事故沟通里，选第 30 天还能
            站得住的那种语法。
        </p>
    </section>

HTML

'itso/articles/16-pushback-security-waiver.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① "I hear X — " the concession dash before the counter</h3>
        <p>
            Professional pushback opens by <strong>restating the other side's constraint</strong>
            before countering it: <em>"I hear the latency constraint — 20 ms contractual, DAM adds
            4 ms."</em> The dash sets up the pivot. Structure: I hear + [their problem in numbers]
            — [your position]. The numbers matter: quoting "20 ms contractual" proves you listened,
            and "adds 4 ms" shows the trade-off is small against the risk.
        </p>
        <p>
            专业的 pushback 先<strong>复述对方的约束</strong>再反驳："I hear the latency constraint —
            20 ms contractual, DAM adds 4 ms."。破折号引出转折。句式：I hear + [对方的问题（带数字）]
            — [你的立场]。引用"20 ms 合同值"证明你听懂了，"adds 4 ms"说明这点延迟相对风险微不足道。
        </p>

        <h3>② "I can't recommend that" — refusal in the first person</h3>
        <p>
            Notice the grammar of the refusal: <em>"On the 'indefinite' — I can't recommend
            that."</em> Not "that's not allowed" (rules talk) and not "you can't do this" (blame
            talk), but <strong>I + can't + recommend</strong> — a first-person statement of
            professional judgement. The constructive twin is the counter-proposal:
            <em>"Counter-proposal: time-bound waiver, 18 months, expiring 31 March 2028."</em> —
            again a verbless noun-phrase headline.
        </p>
        <p>
            注意拒绝的语法：不说"that's not allowed"（规则腔）也不说"you can't do this"（指责腔），
            而是<strong>I + can't + recommend</strong>——第一人称的专业判断。"On the 'indefinite' —
            I can't recommend that." 紧跟着给出建设性对案："Counter-proposal: time-bound waiver,
            18 months, expiring 31 March 2028."——又是无动词的名词短语标题。
        </p>
    </section>

HTML

'itso/articles/17-stop-risky-deploy.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Reduced conditionals for worst-case framing</h3>
        <p>
            <em>"Blast radius if exploited in production: full PII exfiltration in less than
            1 hour."</em> This is a <strong>reduced if-clause</strong>: "if it were exploited" is
            compressed to "if exploited" (if + past participle). The reduction turns a sentence
            into a headline — exactly the register you need when the room has 90 seconds of
            patience. Full version for prose; reduced version for stakes.
        </p>
        <p>
            "Blast radius if exploited in production: …" 是一个<strong>缩略条件句</strong>：
            "if it were exploited" 压缩成 "if exploited"（if + 过去分词）。压缩让句子变成标题——
            当会议室只有 90 秒耐心时，这正是你需要的语域。行文用完整版，报价用缩略版。
        </p>

        <h3>② Verb fragments to control the room</h3>
        <p>
            <em>"Three pieces of info first, then the call."</em>, <em>"Decision tree. Three
            options. Option A, Option B, Option C."</em> — deliberate <strong>fragments</strong>.
            In high-stakes moments, fragments do two jobs full sentences cannot: they slow you
            down (each period is a beat), and they signal control (fragments are chosen, not
            rushed). The strongest line in the whole genre is also a fragment plus a modal:
            <em>"Critical SQL injection in production, public endpoint, no auth. I cannot
            recommend this."</em>
        </p>
        <p>
            "Three pieces of info first, then the call."、"Decision tree. Three options."——都是
            刻意的<strong>短句碎片</strong>。高压时刻，碎片句有两个完整句做不到的作用：强迫你放慢
            （每个句号是一个停顿），并传递掌控感（碎片是选择，不是仓促）。全类型最有力的台词也是
            碎片 + 情态动词："…, no auth. I cannot recommend this."
        </p>
    </section>

HTML

'itso/articles/18-convincing-md-mfa-pam.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Superlative + "of" group — the peer-benchmark pattern</h3>
        <p>
            <em>"We are the only one of the 5 peer banks with password + SMS as the default for
            privileged access."</em> The grammar is <strong>superlative + of + group</strong>: the
            only one of / the best of / the last of. It converts a security opinion into a market
            fact. Pair it with the regulator version of the same move:
            <em>"Every major regulator we operate under now expects phishing-resistant MFA and
            PAM."</em> — "every + singular noun + relative clause" makes the expectation sound
            total (and it is).
        </p>
        <p>
            句式是<strong>最高级 + of + 同侪群体</strong>："the only one of the 5 peer banks with…"
            把安全观点变成市场事实。同款监管版："Every major regulator we operate under now
            expects…"——every + 单数名词 + 定语从句，让"监管预期"听起来是全体一致（事实也确实如此）。
        </p>

        <h3>② The cost of doing nothing — gerund + expected loss</h3>
        <p>
            <em>"Cost of doing nothing: $4.8M expected loss over 24 months."</em> and <em>"Payback
            period: 18 months against the expected loss."</em> Two grammar choices do the
            persuasion. First, <strong>doing nothing</strong> — a gerund object makes inaction a
            decision with a price tag. Second, <strong>against</strong> — the preposition frames
            the investment as measured against a loss you are already expecting, i.e. money you
            will pay either way.
        </p>
        <p>
            "Cost of doing nothing: $4.8M expected loss" + "Payback period: 18 months against the
            expected loss"。两个语法选择完成说服：一是 <strong>doing nothing</strong>——动名词把"不作为"
            变成一个有价签的决定；二是 <strong>against</strong>——介词把投资框定为对照"你反正会付的损失"
            来衡量。
        </p>
    </section>

HTML

'itso/articles/19-iam-access-control-terminology.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① The comparative triad: easier to X, easier to Y, easier to Z</h3>
        <p>
            <em>"RBAC is easier to govern, easier to review, easier to audit."</em> One
            comparative, three infinitives — a <strong>triad</strong> that lands harder than a
            list of three separate clauses because the repetition carries the rhythm. The pattern
            is [comparative] + to + [bare infinitive]; drop the second "it is" and keep the beat.
            Use triads when you want agreement, not discussion.
        </p>
        <p>
            一个比较级 + 三个不定式："easier to govern, easier to review, easier to audit"——
            <strong>三联式</strong>比三个独立从句更有力，因为重复自带节奏。句型是 [比较级] + to +
            [动词原形]，省掉后面的 "it is"、保住节拍。想获得认同而不是讨论时，用三联式。
        </p>

        <h3>② X-is-Y metaphors teach domain relationships</h3>
        <p>
            <em>"The role is the lever. The entitlement is the screw."</em> A two-sentence
            <strong>metaphor pair</strong> explains a governance model faster than a diagram:
            lever (you govern roles) + screw (the entitlement is the fine-grained thing being
            turned). The same grammar teaches the process: <em>"The leaver process is triggered
            by HR, not by the manager."</em> — present-simple passive + <strong>not by</strong>
            contrast, which kills the most common misconception in one clause.
        </p>
        <p>
            两句<strong>隐喻对</strong>"The role is the lever. The entitlement is the screw."比一张图
            更快讲清治理模型：lever（你治理的是角色）+ screw（被精细拧动的是权限）。同一语法还能教流程：
            "The leaver process is triggered by HR, not by the manager."——一般现在时被动 + <strong>not by</strong>
            对比，一个从句消灭最常见的误解。
        </p>
    </section>

HTML

'itso/articles/20-banking-regulator-standards.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Present simple for how the system works</h3>
        <p>
            <em>"The common pattern is the 80% case. The 20% case is regulator-specific."</em>
            The present simple here is not about time — it states a <strong>permanent property
            of the system</strong>. The same tense carries the operating model:
            <em>"The regulator's voice comes through a supervisory letter."</em>, <em>"5
            attestations the CISO signs every year."</em> If a fact is structural, present
            simple; save will/going to for genuine change.
        </p>
        <p>
            这里的现在时不表示时间，而是陈述<strong>系统的恒常属性</strong>："The common pattern is
            the 80% case."、"The regulator's voice comes through a supervisory letter."、
            "…the CISO signs every year."。结构性事实用一般现在时；把 will / going to 留给真正的变化。
        </p>

        <h3>② What-clefts put the emphasis where you want it</h3>
        <p>
            <em>"The evidence pack is what the auditor and the regulator read."</em> This is a
            <strong>pseudo-cleft</strong>: [the thing you want to highlight] + is + what-clause.
            Compare the flat version — "The auditor and the regulator read the evidence pack" —
            same information, no emphasis. The cleft version puts the evidence pack on stage
            first, which is exactly the lesson of the article.
        </p>
        <p>
            "The evidence pack is what the auditor and the regulator read." 是一个<strong>假拟分裂句</strong>：
            [要强调的东西] + is + what 从句。平铺版"The auditor and the regulator read the evidence pack"
            信息相同、毫无强调。分裂句把 evidence pack 放上台面——这正是全文的主旨。
        </p>
    </section>

HTML

'senior-manager/articles/01-steerco-monthly-deck.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Signposting: list + dash + "in that order"</h3>
        <p>
            Senior leaders open with a <strong>signpost</strong> that tells the room how to
            listen: <em>"RAG, milestones, asks, decisions, risks — in that order."</em> Grammar:
            a noun list, a dash, and a prepositional phrase as instruction. No verb needed. The
            dash does the work of "I will present the following items, and here is their order".
            Also notice <em>asks</em> as a plural noun — SteerCo English treats "the ask" as a
            countable, deliverable thing.
        </p>
        <p>
            高管开场先给<strong>导航句</strong>："RAG, milestones, asks, decisions, risks — in that
            order."。语法上就是名词列表 + 破折号 + 介词短语作说明，完全不需要动词——破折号替你说出
            "我按这个顺序讲"。注意 <em>asks</em> 作复数名词：SteerCo 英语把"the ask"当成可数、可交付
            的东西。
        </p>

        <h3>② Verbless number headlines: "Plan $14.8M, committed $9.2M…"</h3>
        <p>
            <em>"Plan $14.8M, committed $9.2M, forecast $14.6M, variance $200K under plan."</em>
            Four data points, no verb, one breath — each unit is a noun + number pair, with the
            participle (<strong>committed</strong>) doing the work of "we have committed". The
            preposition tail matters: <strong>under plan / over plan / on plan</strong> — variance
            is always stated relative to the plan, and "under" sounds like good news only when
            the audience knows it is cost, not delivery.
        </p>
        <p>
            "Plan $14.8M, committed $9.2M, forecast $14.6M, variance $200K under plan."——四个数据点、
            无动词、一口气：每个单元是"名词 + 数字"，分词（committed）替你省掉 "we have committed"。
            介词尾巴很关键：<strong>under / over / on plan</strong>——偏差永远相对 plan 陈述；只有当听众
            知道这是成本而非进度时，"under"才等于好消息。
        </p>
    </section>

HTML

'senior-manager/articles/02-board-update-paper.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① "…, with one material change" — the with-tail</h3>
        <p>
            <em>"Overall direction stable, with one material change."</em> The sentence is a
            noun-phrase headline plus a <strong>with + noun phrase</strong> tail. The with-tail
            is how board papers smuggle in the exception without burying the good news: state
            the stable position, then attach the single deviation. The adjective <strong>material</strong>
            is doing board-register work — it means "significant enough to change a decision",
            a term of art, not "important" in the everyday sense.
        </p>
        <p>
            "Overall direction stable, with one material change."= 名词短语标题 + <strong>with +
            名词短语</strong>的尾巴。with-tail 是董事会文件放置例外的手法：先说稳定态势，再挂上唯一
            偏差。形容词 <strong>material</strong> 是董事会语域的专业词——意为"足以影响决策的"，
            不是日常意义的"重要"。
        </p>

        <h3>② Net direction formulas: "11 risks: 2 High, 5 Medium, 4 Low"</h3>
        <p>
            <em>"11 risks: 2 High, 5 Medium, 4 Low. Net direction: stable."</em> Grammar pattern:
            [total] + colon + [breakdown], then a verdict line in the same verbless register.
            <strong>Net direction</strong> is the board's favourite question — "are we getting
            better or worse?" — so give it its own sentence, not a buried clause. The same
            pattern closes the risk story: <em>"No regulator action against the bank."</em> —
            negation + of-phrase, zero verbs.
        </p>
        <p>
            "11 risks: 2 High, 5 Medium, 4 Low. Net direction: stable."——句式是 [总数] + 冒号 +
            [分布]，再用同样无动词的语域给出结论行。<strong>Net direction</strong>是董事会最关心的
            问题——"我们在变好还是变坏"——所以它值得独立成句，而不是埋在从句里。收尾同款：
            "No regulator action against the bank."——否定 + of 短语、零动词。
        </p>
    </section>

HTML

'senior-manager/articles/03-qbr-business-md.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Scoring speak: "7.8 out of 10" and verbatim quotes</h3>
        <p>
            <em>"Q2: 7.8 out of 10. Top detractor: 'CAB takes too long' — median 5 days, target
            3."</em> Two grammar moves. First, <strong>out of</strong> — the score always travels
            with its denominator, because "7.8" means nothing until "out of 10" lands. Second,
            the <strong>verbatim quote in single quotes</strong> — presenting the business MD's
            words as evidence, then immediately quantifying them with median/target. Quote +
            number is the strongest pairing in a QBR: voice proves the feeling, numbers prove
            the size.
        </p>
        <p>
            两个语法动作：一是 <strong>out of</strong>——分数永远带着分母出现，因为"7.8"在"out of 10"
            落地前没有意义。二是<strong>单引号内的原话引用</strong>——把业务 MD 的话当作证据呈现，紧接着用
            median / target 量化。引用 + 数字是 QBR 里最强的组合：原话证明情绪，数字证明规模。
        </p>

        <h3>② Reciprocal asks: "Three asks from me. Three asks from you."</h3>
        <p>
            <em>"Three asks from me. Three asks from you."</em> The parallel structure makes the
            QBR feel like a trade, not a demand. Grammar: [number] + asks + <strong>from +
            person</strong> — "from" marks whose side the ask sits on. Each ask then gets the
            accountability triple: <em>"Mobile App 7.0 UAT start 1 September, owned by Margaret
            (named lead)."</em> — deliverable + date + <strong>owned by + name</strong>. An ask
            without an owner is a wish.
        </p>
        <p>
            "Three asks from me. Three asks from you."——平行结构让 QBR 像一场交易而不是单方要求。
            句式：[数量] + asks + <strong>from + 人</strong>，"from" 标记 ask 属于哪一方。每个 ask 随后
            落到问责三件套："…UAT start 1 September, owned by Margaret (named lead)."——交付物 + 日期 +
            <strong>owned by + 姓名</strong>。没有 owner 的 ask 只是愿望。
        </p>
    </section>

HTML

'senior-manager/articles/04-annual-it-strategy.html' => <<'HTML',
    <!-- Grammar Notes -->
    <section class="article-section">
        <h2>Grammar Notes 语法点</h2>

        <h3>① Strategy horizons: "Three pillars for the next 3 years"</h3>
        <p>
            <em>"Three pillars for the next 3 years: bank-grade resilience, digital at scale,
            AI-enabled productivity."</em> The grammar of strategy is [count] + pillars + for the
            next + [time horizon], then a colon and three noun phrases — each one built from
            modifiers: <strong>bank-grade</strong> (hyphenated compound adjective), <strong>at
            scale</strong> (prepositional phrase as modifier), <strong>AI-enabled</strong>
            (noun + participle). Noun-phrase pillars are quotable; sentence pillars are not.
        </p>
        <p>
            战略的语法是 [数量] + pillars + for the next + [时间跨度]，冒号后接三个名词短语——每个都由
            修饰语构成：<strong>bank-grade</strong>（连字符复合形容词）、<strong>at scale</strong>（介词
            短语作修饰）、<strong>AI-enabled</strong>（名词 + 分词）。名词短语式的支柱才容易被引用，
            写成句子的支柱不会被记住。
        </p>

        <h3>② Year-3 targets and CFO register</h3>
        <p>
            <em>"Payback period blended: 28 months. NPV positive across all 3 pillars."</em> and
            <em>"Year 3: zero open Tier-1 findings, zero open supervisory letters."</em> Grammar
            choices to copy: <strong>blended</strong> as a post-positioned adjective (the payback,
            blended across pillars); <strong>NPV positive</strong> — finance abbreviation +
            adjective, no verb; <strong>zero open + noun</strong> — "zero" as a quantifier makes
            the target absolute, and the repetition of "zero open …, zero open …" is a deliberate
            rhetorical doubling for the board.
        </p>
        <p>
            可复制的语法选择：<strong>blended</strong> 后置作定语（payback period, blended…）；
            <strong>NPV positive</strong>——财务缩写 + 形容词、无动词；<strong>zero open + 名词</strong>——
            "zero"作限定词让目标绝对化，"zero open …, zero open …"的重复是为董事会设计的修辞叠用。
        </p>
    </section>

HTML
);

my $total = 0;
for my $rel (sort keys %GRAMMAR) {
    my $path = "$ROOT/$rel";
    die "missing file: $path\n" unless -f $path;
    open(my $fh, '<:encoding(UTF-8)', $path) or die "$path: $!";
    local $/; my $html = <$fh>; close($fh);

    if ($html =~ /Grammar Notes/) {
        print "SKIP (already has Grammar Notes): $rel\n";
        next;
    }

    # Anchor: optional preceding comment line + <section> + numbered "Cultural Tips" h2.
    # $1 = leading comment/indent prefix (must stay attached to Cultural Tips)
    # $2 = the section tag, $3 = the <h2> tag
    my $anchor = qr{([ \t]*(?:<!--[^\n]*-->\s*\n\s*)?)(<section class="article-section">\s*\n\s*)(<h2>)[ \t]*(?:\d+\.\s*)?Cultural Tips};
    if ($html !~ $anchor) {
        die "no Cultural Tips anchor in $rel\n";
    }
    $html =~ s{$anchor}{    $GRAMMAR{$rel}$1$2$3 Cultural Tips}
        or die "insert failed: $rel\n";

    # Renumber: strip all leading "N. " from h2 headings, then number sequentially.
    $html =~ s{<h2>\s*\d+\.\s*}{<h2>}g;
    my $n = 0;
    $html =~ s{<h2>\s*}{ '<h2>' . (++$n) . '. ' }ge;

    open(my $out, '>:encoding(UTF-8)', $path) or die "$path: $!";
    print {$out} $html; close($out);
    $total++;
    print "OK: $rel (h2 renumbered to $n)\n";
}
print "Done. Inserted into $total files.\n";

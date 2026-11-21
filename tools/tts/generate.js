/*
 * generate.js — AI 语音预生成（msedge-tts / Edge TTS 神经语音）· 整篇模式
 *
 * 每篇文章生成 ONE 个完整对话 MP3（assets/audio/<文章路径>/full.mp3），
 * 供 "▶ 播放整段对话" 按钮播放；逐句 / 句型 / 词汇的小段朗读由浏览器 TTS 负责。
 *
 * 特性：断点续跑（已有 full.mp3 跳过）、多 worker 并发、失败重试。
 *
 * 用法：
 *   node generate.js                 # 全量
 *   node generate.js --role=ba       # 只跑某个角色目录
 *   node generate.js --limit=2       # 每个目录只跑前 N 篇（测试用）
 */
const { MsEdgeTTS, OUTPUT_FORMAT } = require('msedge-tts');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..', '..');
const AUDIO_ROOT = path.join(ROOT, 'assets', 'audio');
const VOICE = 'en-GB-SoniaNeural';
const FORMAT = OUTPUT_FORMAT.AUDIO_24KHZ_48KBITRATE_MONO_MP3;
const WORKERS = 4;
const RETRIES = 2;

const DIRS = ['ba', 'developer', 'tech-lead', 'architect', 'pm', 'itso',
              'senior-manager', 'business',
              'scenarios/job-interview', 'scenarios/first-30-days', 'scenarios/small-talk'];

/* ---------- args ---------- */
const args = {};
process.argv.slice(2).forEach(a => {
    const m = a.match(/^--(\w+)(?:=(.*))?$/);
    if (m) args[m[1]] = m[2] === undefined ? true : m[2];
});
const roleFilter = args.role || null;
const limit = args.limit ? parseInt(args.limit, 10) : 0;

/* ---------- text helpers ---------- */
function decodeEntities(s) {
    return s
        .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(parseInt(n, 10)))
        .replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"').replace(/&#39;|&apos;/g, "'")
        .replace(/&nbsp;/g, ' ').replace(/&mdash;/g, '—').replace(/&hellip;/g, '…')
        .replace(/&ldquo;|&rdquo;/g, '"').replace(/&lsquo;|&rsquo;/g, "'");
}
function stripTags(s) {
    return decodeEntities(s.replace(/<[^>]+>/g, ' ')).replace(/\s+/g, ' ').trim();
}

/* ---------- extraction: full article dialogue text ---------- */
function extractDialogue(html) {
    const lineRe = /<div class="dialogue-line">([\s\S]*?)<\/div>/g;
    const lines = [];
    let m;
    while ((m = lineRe.exec(html)) !== null) {
        const en = m[1].match(/<span class="en">([\s\S]*?)<\/span>/);
        if (!en) continue;
        const text = stripTags(en[1]);
        if (text) lines.push(text);
    }
    return lines;
}

/* ---------- file discovery ---------- */
function findArticles() {
    const files = [];
    for (const dir of DIRS) {
        if (roleFilter && !dir.startsWith(roleFilter)) continue;
        const full = path.join(ROOT, dir, 'articles');
        if (!fs.existsSync(full)) continue;
        const list = fs.readdirSync(full).filter(f => f.endsWith('.html')).sort();
        for (const f of (limit ? list.slice(0, limit) : list)) {
            files.push({ dir, file: f,
                htmlPath: path.join(full, f),
                rel: dir + '/articles/' + f.replace(/\.html$/, ''),
                outDir: path.join(AUDIO_ROOT, dir, 'articles', f.replace(/\.html$/, '')) });
        }
    }
    return files;
}

/* ---------- TTS worker ---------- */
async function synthesize(client, text) {
    const { audioStream } = client.toStream(text);
    return new Promise((resolve, reject) => {
        const chunks = [];
        audioStream.on('data', c => chunks.push(c));
        audioStream.on('close', () => resolve(Buffer.concat(chunks)));
        audioStream.on('error', reject);
    });
}

async function runWorker(queue, results) {
    let client = null;
    while (queue.length) {
        const job = queue.shift();

        /* checkpoint: skip finished articles */
        const out = path.join(job.outDir, 'full.mp3');
        if (fs.existsSync(out) && fs.statSync(out).size > 0) {
            fs.writeFileSync(path.join(job.outDir, 'manifest.json'),
                JSON.stringify({ voice: VOICE, keys: ['full'] }, null, 1));
            results.done++;
            continue;
        }

        const text = job.lines.join('\n');
        let ok = false, lastErr = null;
        for (let attempt = 0; attempt <= RETRIES && !ok; attempt++) {
            try {
                if (!client) { client = new MsEdgeTTS(); await client.setMetadata(VOICE, FORMAT); }
                const buf = await synthesize(client, text);
                fs.mkdirSync(job.outDir, { recursive: true });
                fs.writeFileSync(out, buf);
                fs.writeFileSync(path.join(job.outDir, 'manifest.json'),
                    JSON.stringify({ voice: VOICE, keys: ['full'] }, null, 1));
                results.bytes += buf.length;
                results.segs++;
                ok = true;
            } catch (e) {
                lastErr = e;
                client = null; /* rebuild connection on next attempt */
                await new Promise(r => setTimeout(r, 1000 * (attempt + 1)));
            }
        }
        if (!ok) results.fail.push(job.rel + ': ' + (lastErr && lastErr.message));

        results.done++;
        console.log(`[${results.done}/${results.total}] ${job.rel}` +
            (ok ? ` — ${(fs.statSync(out).size / 1024).toFixed(0)}KB` : ` — FAILED (${lastErr && lastErr.message})`));
    }
    if (client) { try { client.close(); } catch (e) { /* ignore */ } }
}

/* ---------- main ---------- */
(async () => {
    const jobs = findArticles().map(a => {
        const html = fs.readFileSync(a.htmlPath, 'utf8');
        return { ...a, lines: extractDialogue(html) };
    }).filter(j => j.lines.length > 0);

    const results = { done: 0, total: jobs.length, segs: 0, bytes: 0, fail: [] };
    console.log(`articles with dialogue=${jobs.length}, workers=${WORKERS}, voice=${VOICE}, mode=full-article`);

    const queue = jobs.slice();
    await Promise.all(Array.from({ length: WORKERS }, () => runWorker(queue, results)));

    console.log(`\nDONE articles=${results.done}/${results.total} mp3s=${results.segs} ` +
        `bytes=${(results.bytes / 1048576).toFixed(1)}MB fails=${results.fail.length}`);
    if (results.fail.length) console.log(results.fail.join('\n'));
})().catch(e => { console.error('FATAL', e); process.exit(1); });

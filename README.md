# IT English Learning System for Foreign Bank IT
# 外企银行IT英语沟通训练系统

> 面向外企银行 IT 从业者的系统化英语沟通训练 · Bilingual · Role-Based · Practice-Driven
> A role-based English training system for foreign bank IT professionals — practical speaking, real workplace scenarios, bilingual support.

![Tech](https://img.shields.io/badge/Tech-HTML5%20%2B%20CSS3%20%2B%20Vanilla%20JS-blue)
![Dependencies](https://img.shields.io/badge/Dependencies-Zero%20%E2%80%94%20no%20CDN-success)
![No Build](https://img.shields.io/badge/Build-None-success)
![Articles](https://img.shields.io/badge/Articles-236-orange)
![Roles](https://img.shields.io/badge/Roles-8%20%2B%203%20Scenario%20Series-purple)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🌐 在线直接访问 / Read Online — 无需部署！

<p align="center">
  <a href="https://moshowgame.github.io/IT-English-Learning-System/">
    <strong>🚀 点此直接打开 → https://moshowgame.github.io/IT-English-Learning-System/</strong>
  </a>
</p>

> ✅ **已部署在 GitHub Pages，无需 clone / 无需 deploy / 无需任何配置** — 点击上方链接即可开始学习，支持手机直接访问。
> ✅ **Already live on GitHub Pages — no deploy, no setup needed.** Click the link above and start learning, works on mobile too.

---

## ✨ 项目简介 / About

本系统专为 **外企银行 IT 从业者** 设计，覆盖 **八大 IT 角色** 与 **三大通用场景系列** 共 236 篇文章，聚焦 **实用口语** 表达。每篇文章都包含真实业务场景、英文对话、关键句型、词汇、语法点与练习题。

This learning system is designed for **IT professionals working in foreign banks**. It covers daily English communication across **eight core IT roles** plus **three cross-role scenario series** — 236 articles in total, with a strong focus on **practical speaking** in real workplace contexts.

## 🎯 核心特色 / Features

| 特色 / Feature | 说明 / Description |
|---|---|
| 🏦 **真实业务场景** | SWIFT、KYC、AML、PCI-DSS 等外企银行专有术语 |
| 🗣️ **实用口语优先** | 每篇文章均配 1 段英文对话 + 紧跟小字体中文解读 |
| 🔊 **语音朗读 TTS** | 每段对话可整段连播 / 逐句朗读，支持语速调节与当前句高亮（详见下方专节） |
| 👥 **八大角色全覆盖** | BA / Developer / Tech Lead / Architect / PM / CyberSecurity&IAM / Senior Manager / Business Sponsor |
| 🧭 **通用场景系列** | 求职面试 · 入职30天生存英语 · 职场社交 Small Talk（跨角色） |
| 📚 **五大训练模块** | Daily Standup · Meeting · Written · Difficult Conversations · Banking Context |
| 📶 **四级难度分级** | 🟢 Beginner-friendly / 🟡 Intermediate / 🔴 Advanced / 🔴 Expert（全部 160 篇角色文章已标注） |
| 🤖 **AI 阅读助手** | 自带 API Key 即可在每篇文章调用 AI 翻译、角色扮演、出题（DeepSeek / OpenAI / Kimi / Qwen / GLM） |
| 🔍 **SEO 就绪** | 每页 meta description / Open Graph / canonical / sitemap.xml / robots.txt / favicon / 404 页 |
| 🚀 **现代性能** | 全站无 jQuery、无 Bootstrap，脚本 defer 加载，仅 3 个自研静态资源 |
| 🌍 **跨地区协作** | UK / HK / CN / IN 跨时区沟通话术与跨文化解读 |
| 📱 **响应式设计** | 原生 CSS Grid / Flexbox 响应式（自研实现），PC / Pad / 手机自适应 |
| 🖨️ **打印友好** | 文章打印自动隐藏导航 / footer / donate / 弹窗 |
| 🔌 **零依赖部署** | 纯静态 HTML5 + CSS3 + 原生 JS，**零 CDN、零第三方库、无需构建** — 断网/内网/离线双击 index.html 均完整可用 |

## 🔊 语音朗读 / Text-to-Speech（浏览器 TTS）

无需任何插件或 API Key，**打开文章即可听** — 基于 Web Speech API（浏览器内置语音合成）：

| 功能 | 说明 |
|---|---|
| ▶ **整段对话连播** | 对话区顶部 "🔊 朗读 / Listen" → "▶ 播放整段对话"，逐句朗读并**自动红色高亮当前句** |
| 🔉 **逐句朗读** | 每句对话右侧 🔊 小按钮，点击即读该句英文 |
| ⚡ **语速调节** | 0.75x / 0.9x / 1x / 1.25x，选择自动保存（localStorage），下次访问保持 |
| 🇬🇧 **英式发音优先** | 自动优先选择 en-GB 英式语音（贴合 HSBC 场景），无英式时回退 en-US 美式 |
| 📝 **句型 / 词汇也能听** | Key Phrases 与 Vocabulary 每个条目均带 🔊 按钮 |
| 🔌 **离线兜底** | 纯浏览器端合成，不联网也能朗读；Chrome / Edge 体验最佳 |

> 💡 使用建议：先 0.75x 慢速跟读，熟悉后切回 1x 正常语速做影子跟读（shadowing）练习。

## 📂 项目结构 / Project Structure

```
it-english/
├── index.html                    # 🏠 首页 / Homepage
├── 404.html                      # 自定义 404（GitHub Pages 自动生效）
├── sitemap.xml / robots.txt      # SEO
├── assets/
│   ├── css/common.css            # 现代化公共样式（设计令牌、毛玻璃导航、卡片体系）
│   ├── js/common.js              # 公共脚本（原生JS：角色下拉导航、语音朗读TTS、答案开关、返回顶部、QR lightbox、footer注入）
│   ├── js/ai-config.js           # AI 服务配置（BYO Key，localStorage）
│   ├── js/ai-reader.js           # AI 翻译 / 角色扮演 / 出题
│   └── images/favicon.svg        # 站点图标
├── ba/                           # 📊 业务分析师（21 篇）
├── developer/                    # 💻 开发者（22 篇）
├── tech-lead/                    # 🛠️ 技术负责人（26 篇，已统一编号）
├── architect/                    # 🏗️ 架构师（24 篇）
├── pm/                           # 📅 项目经理（20 篇）
├── itso/                         # 🔐 网络安全与身份管理（20 篇）
├── senior-manager/               # 👔 董事总经理 / 总监（20 篇）
├── business/                     # 🤝 业务发起方 / 需求方（20 篇）
├── scenarios/                    # 🧭 通用场景系列（3 系列 × 20 篇）
│   ├── index.html                # 系列总览
│   ├── job-interview/            # 💼 求职与英文面试（应聘者视角）
│   ├── first-30-days/            # 🌱 新员工入职 30 天生存英语
│   └── small-talk/               # ☕ 职场社交与 Small Talk
└── tools/                        # 🔧 一次性批量脚本（Perl，幂等可复用）
```

每个板块目录都包含：
- `index.html` — 板块入口 + 文章导航（按模块分组，含各角色 Module 6 进阶场景）
- `articles/01-*.html` 起 — 各角色 20~26 篇文章

## 🎓 八大角色 / Eight Roles

| 角色 | Role | 重点场景 |
|---|---|---|
| **BA** 业务分析师 | Business Analyst | 需求澄清、JAD 会议、BRD/FRD、UAT 管理 |
| **Developer** 开发者 | Developer | 日常站会、Code Review、事故沟通、跨时区协作 |
| **Tech Lead** 技术负责人 | Technical Lead | 技术决策、Sprint Planning、Tech Debt 管理 |
| **Architect** 架构师 | Architect | 架构评审、Solution Design、NFR、Cloud Migration |
| **PM** 项目经理 | Project Manager | SteerCo 汇报、RAID 管理、风险升级、预算跟踪 |
| **CyberSecurity&IAM** 网络安全与身份管理 | CyberSecurity & IAM | PCI-DSS、GDPR 合规、Audit 访谈、漏洞管理、MFA/PAM |
| **Senior Manager** 董事总经理/总监 | Senior Manager | SteerCo、Board 汇报、IT 战略、继任规划 |
| **Business Sponsor** 业务发起方 | Business Sponsor | 需求优先级、UAT 签批、Business Case、KPI |

## 🧭 通用场景系列 / Scenario Series（跨角色）

| 系列 | Series | 视角 |
|---|---|---|
| 💼 求职与英文面试 | Job Interview English | 应聘者：简历初筛 → STAR 行为面 → 谈薪 → Offer |
| 🌱 入职 30 天生存英语 | First 30 Days English | 新人：第一天 → 第一次站会 → 第一次 1:1 → 30 天复盘 |
| ☕ 职场社交 | Small Talk & Social English | 全员：茶水间 → 视频会前闲聊 → 跨文化信号 → 关系进阶 |

## 📐 七段式文章结构 / Article Format

1. **Scenario 场景背景** — 时间、地点、参会人、任务
2. **Dialogue 英文对话** — 双行对照（英文 + 小字体中文）
3. **Key Phrases 关键句型** — 6-10 个高频表达 + 用法说明
4. **Vocabulary 词汇表** — 专业术语 + 中文释义
5. **Grammar Notes 语法点** — 真实场景中的语法现象（160 篇角色文章已全部配齐）
6. **Cultural Tips 文化 Tips** — 中外职场文化差异、避坑指南
7. **Practice 练习题** — 翻译、找错、角色扮演（Show Answer 可展开）

## 🛠️ 技术栈 / Tech Stack

| 类别 | 选型 |
|---|---|
| 标记语言 | HTML5 |
| 样式 | 自研现代化 CSS（设计令牌 / 毛玻璃导航 / 卡片体系 / 响应式栅格），零第三方库 |
| 脚本 | **原生 JavaScript（无 jQuery）**，全部 `defer` 加载 |
| 图标 | 内联 SVG（GitHub / CSDN / 关闭按钮）+ SVG favicon |
| 构建 | **无构建** — 直接打开 `index.html` 即可 |
| 服务器 | 任意静态服务器（Python / Nginx / GitHub Pages） |

### 为什么不用框架？ / Why no framework?

- ✅ 极致轻量，无需 `npm install`，离线可用
- ✅ 双击 `index.html` 即可浏览
- ✅ 适合作为学习材料长期保存
- ✅ 部署到 GitHub Pages / Gitee Pages 零成本
- ✅ `tools/` 内的 Perl 批量脚本负责跨 250 个页面的幂等批量修改，兼得"无构建"与"可维护"

## 🚀 快速开始 / Getting Started

### 方式 0：在线访问（最简单，无需任何安装）

> 🌐 **站点已部署在 GitHub Pages，直接打开即用：**
> ### <https://moshowgame.github.io/IT-English-Learning-System/>

### 方式 1：直接打开（推荐本地浏览）
```bash
# macOS
open index.html

# Linux
xdg-open index.html

# Windows
start index.html
```

### 方式 2：本地服务器（推荐完整功能）

```bash
# Python 3
python3 -m http.server 8000

# Node.js
npx serve .

# PHP
php -S localhost:8000
```

然后访问 <http://localhost:8000>。

### 方式 3：部署到自己的 GitHub Pages

> 本仓库已在线上运行（[moshowgame.github.io/IT-English-Learning-System](https://moshowgame.github.io/IT-English-Learning-System/)）；如需部署你自己的副本：

1. 把仓库 push 到 GitHub
2. Settings → Pages → Source 选 `main` 分支根目录
3. 几分钟后访问 `https://<username>.github.io/<repo>/`
4. `sitemap.xml` / `robots.txt` / `404.html` 会自动生效

## 🧰 维护工具 / Maintenance Tools

`tools/` 目录包含幂等的批量维护脚本（Perl，Git Bash 自带解释器）：

| 脚本 | 用途 |
|---|---|
| `audit_sections.pl` | 审计所有文章的七段式结构覆盖与难度标注 |
| `insert_grammar.pl` | 为缺失 Grammar Notes 的文章插入并重新编号 |
| `rename_techlead.pl` | tech-lead 板块文件统一编号 + 链接同步 |
| `fix_difficulty.pl` | 批量补全难度分级徽章 |
| `scenarios/build.pl` | 从 `tools/scenarios/data/` 的数据文件生成全部 60 篇场景文章与索引 |
| `batch_optimize.pl` | 全站导航同步 / SEO 头注入 / defer / CDN 清洗（幂等） |
| `gen_extras.pl` | 重新生成 sitemap.xml / robots.txt / 404.html |
| `check_links.pl` | 全站死链检查 |

## 📅 学习路径建议 / Learning Path

### 🎯 新人 / New Joiners
1. 先读 **Scenarios → First 30 Days** 系列，站稳第一个月
2. 再选自己当前角色 → 读 **Daily Standup** 模块（覆盖 80% 日常沟通）

### 📈 资深员工 / Senior Staff
1. 直接看 **Difficult Conversations** 模块（🔴 Advanced / 🔴 Expert 标注）
2. 重点练 **Banking Context** 模块
3. 求职者从 **Scenarios → Job Interview** 系列开始

### 💡 通用建议
- 📅 每天 1 篇文章，约 8-12 分钟
- 🗣️ 大声朗读对话 2 遍
- ✍️ 抄写关键句型到笔记本
- 🎯 找搭档进行 role play 练习（或用 AI 助手的角色扮演模式）

## 🗺️ Roadmap

- [ ] 电话/视频会议礼仪系列（跨角色）
- [ ] 大场合演讲与 Town Hall 系列
- [ ] 员工视角晋升/调薪谈判系列
- [ ] 新角色板块：QA/测试、DevOps/SRE、数据、Product Owner
- [ ] 词汇闪卡与学习进度追踪（localStorage）
- [ ] 神经语音预生成音频（Edge TTS，多角色音色，作为浏览器 TTS 的升级）

## ⚠️ 安全提示 / Security Note

历史提交中曾误含 SSH 密钥文件（`git` / `git.pub`），现已从 git 跟踪中移除。**如果仓库曾公开，请立即轮换（rotate）该密钥**；如需彻底清除历史记录，使用 `git filter-repo` 重写后 force push。

## 👨‍💻 作者 / Author

**Moshow 郑锴** — 全栈开发者，专注企业级系统架构与金融科技

- 🐙 GitHub: [@moshowgame](https://github.com/moshowgame)
- 📝 CSDN: [zhengkai.blog.csdn.net](https://zhengkai.blog.csdn.net/)

## ☕ 打赏支持 / Support

如果这个学习系统帮到了你，欢迎打赏支持作者 ♥

| 微信 | 支付宝 |
| :---: | :---: |
| ![WeChat Pay QR](assets/images/wechat-qr.jpg) | ![Alipay QR](assets/images/alipay-qr.jpg) |

> 💡 **页面内体验**：在每个页面的 footer 点击二维码图片，可全屏放大便于扫码。

## 🤝 贡献 / Contributing

欢迎提交 PR 来：
- ➕ 补全新角色或新场景（新场景文章建议按 `tools/scenarios/data/` 的数据格式添加后运行 `build.pl`）
- 🐛 修正英语表达错误
- 🌍 添加更多地区口音 / 表达习惯
- 🎨 优化 UI / 移动端体验
- 📝 完善某篇文章的 Grammar Notes

### 提交规范
```bash
# 1. Fork 本仓库
# 2. 创建特性分支
git checkout -b feature/new-role

# 3. 提交修改
git commit -m "feat: add scenario series - phone and video meeting etiquette"

# 4. 推送并创建 PR
git push origin feature/new-role
```

## 📜 License

MIT © Moshow 郑锴

> 自由使用、修改、分发，但请保留作者署名与打赏入口。

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/moshowgame">Moshow</a> · 2026
  <br>
  <sub>专为外企银行 IT 从业者打造的英语沟通训练系统</sub>
</p>

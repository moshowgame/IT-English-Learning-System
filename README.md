# IT English Learning System for Foreign Bank IT
# 外企银行IT英语沟通训练系统

> 面向外企银行 IT 从业者的系统化英语沟通训练 · Bilingual · Role-Based · Practice-Driven
> A role-based English training system for foreign bank IT professionals — practical speaking, real workplace scenarios, bilingual support.

![Tech](https://img.shields.io/badge/Tech-HTML%20%2B%20jQuery%203%20%2B%20Bootstrap%205-blue)
![No Build](https://img.shields.io/badge/Build-None-success)
![Articles](https://img.shields.io/badge/Articles-120%2B-orange)
![Roles](https://img.shields.io/badge/Roles-6-purple)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ 项目简介 / About

本系统专为 **外企银行 IT 从业者** 设计，覆盖六大 IT 角色的日常英语沟通场景，聚焦 **实用口语** 表达。每篇文章都包含真实业务场景、英文对话、关键句型、词汇、语法点与练习题。

This learning system is designed for **IT professionals working in foreign banks**. It covers daily English communication scenarios across six core IT roles, with a strong focus on **practical speaking** in real workplace contexts.

## 🎯 核心特色 / Features

| 特色 / Feature | 说明 / Description |
|---|---|
| 🏦 **真实业务场景** | SWIFT、KYC、AML、PCI-DSS 等外企银行专有术语 |
| 🗣️ **实用口语优先** | 每篇文章均配 1 段英文对话 + 紧跟小字体中文解读 |
| 👥 **六大角色全覆盖** | BA / Developer / Tech Lead / Architect / PM / ITSO |
| 📚 **五大训练模块** | Daily Standup · Meeting · Written · Difficult Conversations · Banking Context |
| 🌍 **跨地区协作** | UK / HK / CN / IN 跨时区沟通话术 |
| 📱 **响应式设计** | Bootstrap 5，PC / Pad / 手机自适应 |
| 🖨️ **打印友好** | 文章打印自动隐藏 footer / donate / 弹窗 |
| 🖱️ **点击放大** | 点击 QR 图可全屏放大，方便扫码 |
| 🔌 **零依赖部署** | 纯静态 HTML + CDN，无需构建 |

## 📂 项目结构 / Project Structure

```
it-english/
├── index.html                    # 🏠 首页 / Homepage
├── assets/
│   ├── css/common.css            # 公共样式 (企业级深色主题、lightbox、二维码卡片)
│   ├── js/common.js              # 公共脚本 (作者信息注入、QR lightbox)
│   └── images/
│       ├── wechat-qr.jpg         # 微信打赏
│       └── alipay-qr.jpg         # 支付宝打赏
├── ba/                           # 📊 业务分析师
│   ├── index.html
│   └── articles/                 # 20 篇文章
├── developer/                    # 💻 开发者
│   ├── index.html
│   └── articles/
├── tech-lead/                    # 🛠️ 技术负责人
├── architect/                    # 🏗️ 架构师
├── pm/                           # 📅 项目经理
└── itso/                         # 🔐 IT 安全官
```

每个角色目录都包含：
- `index.html` — 角色入口 + 20 篇文章导航
- `articles/01-*.html` ~ `articles/20-*.html` — 20 篇文章

## 🎓 六大角色 / Six Roles

| 角色 | Role | 重点场景 |
|---|---|---|
| **BA** 业务分析师 | Business Analyst | 需求澄清、JAD 会议、BRD/FRD、UAT 管理 |
| **Developer** 开发者 | Developer | 日常站会、Code Review、事故沟通、跨时区协作 |
| **Tech Lead** 技术负责人 | Technical Lead | 技术决策、Sprint Planning、Tech Debt 管理 |
| **Architect** 架构师 | Architect | 架构评审、Solution Design、NFR、Cloud Migration |
| **PM** 项目经理 | Project Manager | SteerCo 汇报、RAID 管理、风险升级、预算跟踪 |
| **ITSO** 安全官 | IT Security Officer | PCI-DSS、GDPR 合规、Audit 访谈、漏洞管理 |

## 📐 五大训练模块 / Five Training Modules

每篇文章都按统一的 7 段式结构组织：

1. **Scenario 场景背景** — 时间、地点、参会人、任务
2. **Dialogue 英文对话** — 双行对照（英文 + 小字体中文）
3. **Key Phrases 关键句型** — 6-10 个高频表达 + 用法说明
4. **Vocabulary 词汇表** — 专业术语 + 音标 + 中文释义
5. **Grammar Notes 语法点** — 真实场景中的语法现象
6. **Cultural Tips 文化 Tips** — 中外职场文化差异、避坑指南
7. **Practice 练习题** — 填空、翻译、角色扮演

## 🛠️ 技术栈 / Tech Stack

| 类别 | 选型 |
|---|---|
| 标记语言 | HTML5 |
| 样式 | 自研 CSS（企业级深色主题） + Bootstrap 5（CDN） |
| 脚本 | jQuery 3.7.1（CDN） + 原生 ES6 |
| 图标 | 内联 SVG（GitHub / CSDN / 关闭按钮） |
| 构建 | **无构建** — 直接打开 `index.html` 即可 |
| 服务器 | 任意静态服务器（Python / Nginx / GitHub Pages） |

### 为什么不用框架？ / Why no framework?

- ✅ 极致轻量，**总大小 < 2MB**
- ✅ 无需 `npm install`，离线可用
- ✅ 双击 `index.html` 即可浏览
- ✅ 适合作为学习材料长期保存
- ✅ 部署到 GitHub Pages / Gitee Pages 零成本

## 🚀 快速开始 / Getting Started

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

### 方式 3：部署到 GitHub Pages

1. 把仓库 push 到 GitHub
2. Settings → Pages → Source 选 `main` 分支根目录
3. 几分钟后访问 `https://<username>.github.io/<repo>/`

## 🌐 浏览器兼容 / Browser Support

| 浏览器 | 最低版本 |
|---|---|
| Chrome / Edge | 90+ |
| Safari | 14+ |
| Firefox | 88+ |
| 移动端浏览器 | iOS 14+ / Android Chrome 90+ |

## 📅 学习路径建议 / Learning Path

### 🎯 新人 / New Joiners
1. 先选自己当前角色 → 读 **Daily Standup** 模块
2. 再读 **Meeting Workshops** 模块
3. 这两个模块覆盖 80% 日常沟通

### 📈 资深员工 / Senior Staff
1. 直接看 **Difficult Conversations** 模块
2. 重点练 **Banking Context** 模块
3. 学习与合规、InfoSec、Vendor 的沟通技巧

### 💡 通用建议
- 📅 每天 1 篇文章，约 8-12 分钟
- 🗣️ 大声朗读对话 2 遍
- ✍️ 抄写关键句型到笔记本
- 🎯 找搭档进行 role play 练习

## 👨‍💻 作者 / Author

**Moshow 郑锴** — 全栈开发者，专注企业级系统架构与金融科技

- 🐙 GitHub: [@moshowgame](https://github.com/moshowgame)
- 📝 CSDN: [zhengkai.blog.csdn.net](https://zhengkai.blog.csdn.net/)
- 💼 熟悉 Spring Boot CMS / HTML / CSS / JavaScript / Bootstrap / jQuery / TinyMCE

## ☕ 打赏支持 / Support

如果这个学习系统帮到了你，欢迎打赏支持作者 ♥

| 微信 | 支付宝 |
| :---: | :---: |
| 扫一扫 | 扫一扫 |
| 详见 `assets/images/wechat-qr.jpg` | 详见 `assets/images/alipay-qr.jpg` |

> 💡 **页面内体验**：在每个页面的 footer 点击二维码图片，可全屏放大便于扫码。

## 🤝 贡献 / Contributing

欢迎提交 PR 来：
- ➕ 补全新角色或新场景
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
git commit -m "feat: add ITSO article 21 - vendor security review"

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

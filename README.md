# Back-to-file

一个管理互联网项目开发全流程的 AI 编码助手 Skill，兼容所有 Agent Skills 标准运行时（Claude Code · Codex CLI · Codex App 等）。

> **一键安装**：`npx skills add back-to-file`（自动检测运行环境）

## 概述

通过六个阶段的文档驱动项目从 idea 到交付：

1. **概念定义** → Concept.md
2. **项目规划** → Plan.md
3. **实施拆分** → Project.md
4. **任务跟踪** → Task.md
5. **实现执行** → 视觉 Demo → Design.md（反向提炼）/ DataModel.md / API.md + 实际代码
6. **项目总结** → Summary.md

每个阶段生成一份 Markdown 文档放在项目根目录，不同 Agent 可以通过读取这些文档了解当前状态并继续推进。

## 核心特性

- **文档驱动**：项目状态完全由 Markdown 文件集合记录，无需外部数据库
- **可中断/接力**：任何时刻关闭会话，重新打开即可从断点继续
- **交叉校验**：每阶段输出自动对齐前序文档，保证一致性
- **变更追溯**：方案变更通过 Change.md 追溯，新 Agent 可理解上下文
- **按产品形态自适应**：Web 应用、CLI 工具、静态网站等自动调整阶段划分
- **跨平台兼容**：同一份 SKILL.md 同时适配 Claude Code 和 Codex CLI

## 安装

### Claude Code

```bash
mkdir -p ~/.claude/skills/back-to-file
cp SKILL.md ~/.claude/skills/back-to-file/
```

### Codex CLI

```bash
mkdir -p ~/.agents/skills/back-to-file
cp -r . ~/.agents/skills/back-to-file/
```

### Codex App

将 `AGENTS.md` 复制到项目根目录：

```bash
cp AGENTS.md /path/to/your/project/AGENTS.md
```

## 使用

在任何支持的 AI 编码助手中说：

- "我想做个网站"
- "帮我规划项目"
- "开始一个新项目"
- "梳理一下这个 idea"

Skill 会自动触发并引导你完成整个流程。

## 文件结构

```
back-to-file/
├── SKILL.md          # 主技能文件（Claude Code / Codex CLI）
├── AGENTS.md         # Codex App 版本
├── README.md         # 本文件
├── agents/
│   └── openai.yaml   # Codex 特定配置
└── evals/
    ├── evals.json    # 测试用例
    └── files/        # 测试用示例文件
```

## 许可

MIT

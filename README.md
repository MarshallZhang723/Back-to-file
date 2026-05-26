# Back-to-file

一个管理互联网项目开发全流程的 Claude Code Skill。

## 概述

通过六个阶段的文档驱动项目从 idea 到交付：

1. **概念定义** → Concept.md
2. **项目规划** → Plan.md
3. **实施拆分** → Project.md
4. **任务跟踪** → Task.md
5. **实现执行** → Design.md / DataModel.md / API.md + 实际代码
6. **项目总结** → Summary.md

每个阶段生成一份 Markdown 文档放在项目根目录，不同 Agent 可以通过读取这些文档了解当前状态并继续推进。

## 核心特性

- **文档驱动**：项目状态完全由 Markdown 文件集合记录，无需外部数据库
- **可中断/接力**：任何时刻关闭会话，重新打开即可从断点继续
- **交叉校验**：每阶段输出自动对齐前序文档，保证一致性
- **变更追溯**：方案变更通过 Change.md 追溯，新 Agent 可理解上下文
- **按产品形态自适应**：Web 应用、CLI 工具、静态网站等自动调整阶段划分

## 安装

将 `SKILL.md` 放入 Claude Code 的 skills 目录：

```bash
cp SKILL.md ~/.claude/skills/back-to-file/
```

## 使用

在 Claude Code 中说：

- "我想做个网站"
- "帮我规划项目"
- "开始一个新项目"
- "梳理一下这个 idea"

Skill 会自动触发并引导你完成整个流程。

## 许可

MIT

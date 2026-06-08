---
name: back-to-file
description: 文档驱动的项目开发全流程Skill，通过六个阶段的文档驱动项目从 idea 到交付。
---

# back-to-file

通过文档驱动管理项目开发。每个阶段生成一份 Markdown 文档放在项目根目录，不同 Agent 可以通过读取这些文档了解当前状态并继续推进。

核心流程：

```
Concept.md → Plan.md → Project.md → Task.md → Code → Summary.md
```

目标：
- 支持 Agent 接力
- 支持项目中断恢复
- 支持文档驱动开发

## 安装

```bash
npx skills add back-to-file
```

手动安装：将本目录复制到对应平台路径。

| 平台 | 路径 |
|------|------|
| Claude Code | `~/.claude/skills/back-to-file/` |
| Codex CLI | `~/.agents/skills/back-to-file/` |
| Codex App | 项目根目录 `AGENTS.md` |

> Codex App 使用仓库内的 `AGENTS.md`，详见本目录下的 AGENTS.md。

## 触发条件

检测到用户表达以下意图时启动：

**强触发**：开始项目 / 创建项目 / 项目规划 / 项目管理 / 需求拆解 / 任务拆分 / 进度管理

**弱触发**：我有个想法 / 帮我分析这个产品 / 帮我做个东西

弱触发时先确认：「是否进入 back-to-file 项目流程？」

## 阶段识别器

执行前先检查项目根目录的文档状态：

| 文件状态 | 当前阶段 |
|---------|---------|
| 不存在 Concept.md | → 阶段一 |
| 存在 Concept.md，不存在 Plan.md | → 阶段二 |
| 存在 Plan.md，不存在 Project.md | → 阶段三 |
| 存在 Project.md，不存在 Task.md | → 阶段四 |
| 存在 Task.md | → 阶段五 |
| 所有阶段标记完成 | → 阶段六 |

如果部分文档缺失但后续文档存在（如缺 Plan.md 但有 Project.md），说明文档链断裂 —— 向用户报告异常，参考 `references/failure-handbook.md` 处理。

缺失文档时先判断是否已有部分文档（中断恢复场景），从已有文档能确定的阶段开始。

## 阶段说明

### 阶段一：概念定义 → Concept.md

**职责**：引导用户回答 6 个问题，生成 Concept.md。
- 动机、问题、方案、理由、竞品分析、深层洞察

**前置**：无
**校验**：6 个问题是否完整覆盖
**模板**：`references/concept-template.md`

**用户直接提交了文档**：审查完整性，对照 6 个问题评估补充。

### 阶段二：项目规划 → Plan.md

**职责**：基于 Concept.md 生成项目蓝图。
- 产品形态、核心功能、页面结构、技术栈、设计规范

**前置**：存在完整的 Concept.md。如"待定信息"中有未定项，先向用户提问补齐。
**校验**：Plan.md 是否回应了 Concept.md 中所有问题、洞察和方案选择
**模板**：`references/plan-template.md`

### 阶段三：实施拆分 → Project.md

**职责**：把规划拆成可执行的阶段和任务。
- 根据产品形态划分阶段：Web=前端→后端→交互→部署；CLI=后端→部署；静态网站=前端→部署
- 每阶段有交付结果和验收标准

**前置**：存在完整的 Plan.md
**校验**：Project.md 是否覆盖了 Plan.md 的所有核心功能
**模板**：`references/project-template.md`
**状态管理**：每完成一个阶段将 `[ ]` 更新为 `[x]`，标注完成日期

### 阶段四：任务跟踪 → Task.md

**职责**：跟踪每个任务的执行状态，记录实施日志。
- 状态：⬜ 未开始 / 🔄 进行中 / ✅ 已完成
- 每次有进展时追加日志，不覆盖

**前置**：存在完整的 Project.md
**校验**：Task.md 的任务列表是否与 Project.md 的阶段定义一致
**模板**：`references/task-template.md`

### 阶段五：实现执行

**职责**：按 Project.md 定义的阶段顺序创建项目、编写代码、部署上线。

**前置**：存在完整的 Project.md 和 Task.md。

**执行总纲**：
1. 读取 Project.md 确定阶段顺序和任务列表
2. 进入第一个代码子步骤前初始化项目（脚手架、依赖、git）。已有则跳过
3. 需规范文档的子步骤：先生成文档→确认→再实现（Design.md/DataModel.md/API.md）
4. 无需规范文档的子步骤：直接实现（布局/配色/动效/交互集成/CI/CD/上线）
5. 每个 Task 完成后更新 Task.md，执行验证，展示进展
6. 每阶段所有 Task 完成后更新 Project.md
7. 遇技术故障 → 先一线修复，仍失败执行兜底方案（见 `references/failure-handbook.md`）

**子步骤顺序**（典型 Web 项目）：
- 5.1 前端骨架：信息布局排版 → 视觉色彩搭配 → 交互动效 → Design.md（反向提炼）
- 5.2 后端：DataModel.md → API.md → 业务逻辑实现
- 5.3 前端交互集成
- 5.4 部署：CI/CD → 上线

**验证策略**（根据产品形态选择）：

| 产品形态 | 验证方式 |
|---------|---------|
| Web 应用 | 启动 dev server → 页面 200 → 核心交互可操作 |
| 静态网站 / Landing Page | 启动 dev server → 页面渲染 → 链接可达 |
| API / 后端服务 | 启动 server → curl 关键端点 → 返回值正确 |
| CLI 工具 | 直接执行命令 → 核验 stdout/stderr |
| npm 包 / 库 | 运行测试套件 |
| 浏览器扩展 | 代码审查 + 标记「需手动加载验证」 |

**规范文档模板**：
- Design.md → `references/design-template.md`
- DataModel.md → `references/datamodel-template.md`
- API.md → `references/api-template.md`

**外部技能（前端骨架阶段）**：
- **impeccable**（内置）— 布局排版/色彩搭配/动效审查
- **design-taste-frontend**（需安装）— 反 slop 设计规则 + 三旋钮系统
- **gsap-core/scrolltrigger/timeline/react/performance**（内置）— 交互动效实现

**taste-skill 安装**：
```bash
npx skills add https://github.com/Leonxlnx/taste-skill
```

### 阶段六：项目总结 → Summary.md

**职责**：记录完成情况、关键决策和经验总结。

**触发**：所有阶段完成且验收通过，或用户主动要求总结
**模板**：`references/summary-template.md`

## 全局规则

1. **每阶段结束后展示结果** → 请求用户确认 → 未确认不得进入下一阶段
2. **修改文档必须记录 Change.md**（时间、文档、内容、原因）
3. **优先读取已有文档继续执行**，根据文档状态判断当前阶段
4. **先改规范文档，再改代码**，统一对齐
5. **遇到计划外变更**（方案不可行、需求矛盾）→ 先问用户，获得指示后再继续

完整工作流规则见 `references/workflow-rules.md`。校验规则见 `references/validation-rules.md`。变更管理见 `references/change-management.md`。

## 异常处理

| 异常场景 | 处理方式 |
|---------|---------|
| 用户跳阶段 | 允许，说明跳过后可能影响后续文档质量，请用户确认 |
| 文档缺失/断裂 | 检查已有文档确定当前阶段，从可继续的阶段开始 |
| 文档冲突 | 在 Change.md 记录冲突，优先使用最新版本 |
| 项目中断恢复 | 检查项目根目录文档状态，从中断的阶段继续 |

完整异常场景处理见 `references/failure-handbook.md`。

## 参考文件索引

| 文件 | 用途 |
|------|------|
| `references/concept-template.md` | Concept.md 模板 |
| `references/plan-template.md` | Plan.md 模板 |
| `references/project-template.md` | Project.md 模板 |
| `references/task-template.md` | Task.md 模板 |
| `references/design-template.md` | Design.md 模板 + 设计规范 |
| `references/datamodel-template.md` | DataModel.md 模板 |
| `references/api-template.md` | API.md 模板 |
| `references/summary-template.md` | Summary.md 模板 |
| `references/workflow-rules.md` | 工作流概览 + 切换规则 + 反例黑名单 + 文档速查 |
| `references/validation-rules.md` | 阶段间对齐校验 + 预检清单 |
| `references/change-management.md` | 变更管理规范 |
| `references/failure-handbook.md` | 故障处理 + 常见场景处理 |

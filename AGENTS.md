# back-to-file

本项目使用 back-to-file 工作流进行文档驱动开发。

## 执行前

1. 阅读 SKILL.md — 了解完整工作流和阶段说明
2. 检查项目根目录文档状态 → 判断当前阶段
3. 根据当前阶段读取对应 reference

## 阶段模板对照

| 阶段 | 产出文档 | 参考模板 |
|------|---------|---------|
| 一 | Concept.md | `references/concept-template.md` |
| 二 | Plan.md | `references/plan-template.md` |
| 三 | Project.md | `references/project-template.md` |
| 四 | Task.md | `references/task-template.md` |
| 五·前端 | Design.md | `references/design-template.md` |
| 五·后端 | DataModel.md | `references/datamodel-template.md` |
| 五·后端 | API.md | `references/api-template.md` |
| 六 | Summary.md | `references/summary-template.md` |

## 参考文件

- `references/workflow-rules.md` — 工作流概览、阶段切换规则、反例黑名单、文档速查
- `references/validation-rules.md` — 阶段间对齐校验规则、预检清单
- `references/change-management.md` — 变更管理规范（Change.md 格式）
- `references/failure-handbook.md` — 故障处理、常见场景处理

## 核心规则

- 每阶段完成 → 展示 → 交叉校验 → 请求用户确认 → 等待进入下一阶段
- 修改文档必须在 Change.md 追加记录
- 优先读取已有文档判断进度，从当前阶段继续

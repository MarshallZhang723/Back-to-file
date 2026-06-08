# 变更管理

**核心规则**：任何时候覆盖重写以下文档，都必须在 Change.md 中追加一条记录：

- Concept.md
- Plan.md
- Project.md
- Design.md
- DataModel.md
- API.md

## Change.md 格式

```markdown
# 变更日志

## 2024-01-01 14:30
- **修改文档**：Concept.md
- **修改内容**：更新了问题定义，从"用户找不到附近的餐厅"改为"用户无法高效比较附近餐厅的评分和价格"
- **修改原因**：用户反馈原问题定义过于宽泛，聚焦后更精准

## 2024-01-02 10:00
- **修改文档**：Plan.md
- **修改内容**：技术栈从 React + Express 改为 Next.js 全栈
- **修改原因**：简化部署架构，减少维护成本
```

## 规则

- Change.md **不会被覆盖**，只会追加
- 每次修改都记录：时间、文档、内容、原因
- Task.md 的更新日志和 Summary.md **不需要**在 Change.md 中记录

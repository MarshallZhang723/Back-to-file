# back-to-file Benchmark

> 用于比较 **当前版本 / 压缩版 / 后续版本 / 不使用Skill版本** 的标准化测试体系。

## 目录结构

```
benchmark/
├── benchmark.json           # 主配置：28 个测试场景 + 评分规则 + 维度定义
├── run-benchmark.sh         # 运行脚本（列出场景、运行、评分、对比、报告）
├── report-template.md        # 版本比较报告模板
├── datasets/                # 测试输入文件（新创建的、不在 evals/files/ 中的场景数据）
│   ├── minimal-concept.md   # 仅含 2 部分的不完整 Concept
│   ├── outdated-concept.md  # 过时的概念文档
│   ├── stale-project.md     # 更新后的实施计划（与旧概念矛盾）
│   └── summary-ready-*.md   # 已完成所有阶段的摘要测试数据
└── results/                 # 运行结果输出目录
    └── latest_report.md     # (自动生成) 最新报告
```

## 测试维度

| 维度 | 权重 | 说明 |
|------|:----:|------|
| Task Success Rate | 30% | 任务完成度，输出与预期的匹配程度 |
| State Machine Accuracy | 20% | 阶段识别和转换准确性 |
| Guardrail Compliance | 15% | 安全护栏遵守程度（STOP门、确认、Change.md） |
| Recovery Accuracy | 15% | 中断恢复和异常处理正确性 |
| Token Usage Efficiency | 10% | Token 使用效率（基线归一化） |
| Latency | 10% | 完成时间（基线归一化） |

## 场景分布 (28 个)

| 类别 | 数量 | 覆盖内容 |
|:----:|:----:|---------|
| 🟢 Happy Path | 5 | Concept→Plan→Project→Task→Summary 全流程 |
| 🔵 State Machine | 8 | 阶段检测、文档链断裂、大小写、过时文档 |
| 🟡 Recovery | 5 | Agent 接力、缺失恢复、矛盾修复、回退 |
| 🔴 Failure | 5 | 矛盾检测、跳阶段、退回处理、范围外请求 |
| 🟣 Guardrail | 5 | STOP门、Change.md、审查、跳过检测、交叉校验 |

## 使用方法

```bash
# 列出所有可用场景
./run-benchmark.sh --list

# 准备所有场景的测试环境
./run-benchmark.sh

# 只运行指定类别
./run-benchmark.sh --category happy-path

# 只运行指定场景
./run-benchmark.sh --id HP-01

# 手动测试流程
# 1. 切换到场景工作目录
# 2. 在 Claude 中运行 Prompt
# 3. 记录结果到 result.json
# 4. 运行 --report 生成报告
# 5. 运行 --compare 比较版本

# 从已有结果生成报告
./run-benchmark.sh --report

# 比较两次运行
./run-benchmark.sh --compare run_20250101_120000 run_20250102_120000
```

## 评分流程

1. **运行场景** → 在 Claude 中执行 Prompt，记录输出
2. **评分每个场景** → 对照 benchmark.json 中的 scoring_rules 逐项评分
3. **聚合评分** → 按维度和类别聚合
4. **生成报告** → 插入数据到 report-template.md
5. **版本对比** → 用 --compare 对比不同版本

## 版本比较矩阵

| 版本 | 用途 | 预期特性 |
|:----:|------|---------|
| **当前版** | 基准线 | 当前 SKILL.md 完整版本 |
| **压缩版** | 优化实验 | 精简后的版本，Token 更少但可能降低准确性 |
| **后续版** | 迭代验证 | 后续改进版本，预期得分更高 |
| **不使用Skill版** | 基线参考 | 完全不使用 Skill，纯对话完成任务 |

## 与 evals/ 的关系

- **evals/** — 开发中的快速验证（16 个场景，侧重功能覆盖）
- **benchmark/** — 版本对比的标准化测试（28 个场景，侧重量化评分和版本间对比）

benchmark 复用 evals/files/ 中的测试数据文件，并新增 datasets/ 中的场景文件。

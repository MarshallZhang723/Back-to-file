# back-to-file Benchmark 报告模板

> 此模板用于生成版本间比较报告，支持 **当前版** / **压缩版** / **后续版** / **不使用Skill版** 的横向对比。

---

## 版本信息

| 属性 | 值 |
|------|-----|
| Skill | back-to-file |
| Benchmark 版本 | 1.0 |
| 总场景数 | 28 |
| 运行日期 | {{run_date}} |
| 当前版本 | {{version_current}} |
| 对比版本 | {{version_compare}} |

---

## 1. 综合得分总览

| 版本 | 综合得分 | 排名 |
|------|---------|:----:|
| 🏆 当前版 | {{score_current}}% | {{rank_current}} |
| 压缩版 | {{score_compressed}}% | {{rank_compressed}} |
| 后续版 | {{score_future}}% | {{rank_future}} |
| 不使用Skill版 | {{score_no_skill}}% | {{rank_no_skill}} |

### 计算公式

```
综合得分 = Σ(维度得分 × 维度权重)

维度权重:
  - Task Success Rate:   30%
  - State Machine Acc:   20%
  - Guardrail Compliance: 15%
  - Recovery Accuracy:   15%
  - Token Usage:         10%
  - Latency:             10%
```

---

## 2. 六维度对比雷达图

```
                           Task Success
                              │
                              │   (雷达占位 — 在最终报告中作为 SVG/HTML 图表呈现)
                              │
            Latency ──────────┼────────── State Machine
                          ╱   │   ╲
                        ╱     │     ╲
                      ╱       │       ╲
            Token ────────────┼─────────── Guardrail
              Usage           │
                              │
                              │
                          Recovery

  图例:  当前版 ──   压缩版 ──   后续版 ──   无Skill版 ──
```

### 维度得分表

| 维度 | 权重 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 最佳版本 |
|------|:---:|:-----:|:-----:|:-----:|:---------:|:--------:|
| Task Success Rate | 30% | {{ts_current}}% | {{ts_compressed}}% | {{ts_future}}% | {{ts_no_skill}}% | {{ts_best}} |
| State Machine Accuracy | 20% | {{sm_current}}% | {{sm_compressed}}% | {{sm_future}}% | {{sm_no_skill}}% | {{sm_best}} |
| Guardrail Compliance | 15% | {{gr_current}}% | {{gr_compressed}}% | {{gr_future}}% | {{gr_no_skill}}% | {{gr_best}} |
| Recovery Accuracy | 15% | {{rc_current}}% | {{rc_compressed}}% | {{rc_future}}% | {{rc_no_skill}}% | {{rc_best}} |
| Token Usage Efficiency | 10% | {{tu_current}}% | {{tu_compressed}}% | {{tu_future}}% | {{tu_no_skill}}% | {{tu_best}} |
| Latency | 10% | {{lt_current}}% | {{lt_compressed}}% | {{lt_future}}% | {{lt_no_skill}}% | {{lt_best}} |

---

## 3. 类别维度分析

### 3.1 按场景类别聚合

| 类别 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 类别权重说明 |
|------|:-----:|:-----:|:-----:|:---------:|:-----------:|
| 🟢 Happy Path (5) | {{hp_current}}% | {{hp_compressed}}% | {{hp_future}}% | {{hp_no_skill}}% | 核心流程完成度 |
| 🔵 State Machine (8) | {{sm_cat_current}}% | {{sm_cat_compressed}}% | {{sm_cat_future}}% | {{sm_cat_no_skill}}% | 阶段检测准确性 |
| 🟡 Recovery (5) | {{rc_cat_current}}% | {{rc_cat_compressed}}% | {{rc_cat_future}}% | {{rc_cat_no_skill}}% | 中断恢复能力 |
| 🔴 Failure (5) | {{fl_current}}% | {{fl_compressed}}% | {{fl_future}}% | {{fl_no_skill}}% | 错误检测准确率 |
| 🟣 Guardrail (5) | {{gr_cat_current}}% | {{gr_cat_compressed}}% | {{gr_cat_future}}% | {{gr_cat_no_skill}}% | 安全护栏通过率 |

### 3.2 类别变化趋势

```
最佳 → 最差:   {{category_ranking}}
退化最多的类别: {{category_most_regression}}
提升最多的类别: {{category_most_improvement}}
```

---

## 4. 单场景详细得分

### 4.1 Happy Path 场景

| ID | 场景名 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 趋势 |
|:--:|--------|:-----:|:-----:|:-----:|:---------:|:----:|
| HP-01 | 完整概念创建（全量输入） | {{hp01_current}}% | {{hp01_compressed}}% | {{hp01_future}}% | {{hp01_no_skill}}% | {{hp01_trend}} |
| HP-02 | 概念到规划过渡 | {{hp02_current}}% | {{hp02_compressed}}% | {{hp02_future}}% | {{hp02_no_skill}}% | {{hp02_trend}} |
| HP-03 | 规划到实施拆分 | {{hp03_current}}% | {{hp03_compressed}}% | {{hp03_future}}% | {{hp03_no_skill}}% | {{hp03_trend}} |
| HP-04 | 实施拆分到任务跟踪 | {{hp04_current}}% | {{hp04_compressed}}% | {{hp04_future}}% | {{hp04_no_skill}}% | {{hp04_trend}} |
| HP-05 | 项目总结生成 | {{hp05_current}}% | {{hp05_compressed}}% | {{hp05_future}}% | {{hp05_no_skill}}% | {{hp05_trend}} |

### 4.2 State Machine 场景

| ID | 场景名 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 趋势 |
|:--:|--------|:-----:|:-----:|:-----:|:---------:|:----:|
| SM-01 | 空白项目→阶段一 | {{sm01_current}}% | {{sm01_compressed}}% | {{sm01_future}}% | {{sm01_no_skill}}% | {{sm01_trend}} |
| SM-02 | 仅 Concept→阶段二 | {{sm02_current}}% | {{sm02_compressed}}% | {{sm02_future}}% | {{sm02_no_skill}}% | {{sm02_trend}} |
| SM-03 | Concept+Plan→阶段三 | {{sm03_current}}% | {{sm03_compressed}}% | {{sm03_future}}% | {{sm03_no_skill}}% | {{sm03_trend}} |
| SM-04 | 三文档存在→阶段四 | {{sm04_current}}% | {{sm04_compressed}}% | {{sm04_future}}% | {{sm04_no_skill}}% | {{sm04_trend}} |
| SM-05 | 四文档存在→阶段五 | {{sm05_current}}% | {{sm05_compressed}}% | {{sm05_future}}% | {{sm05_no_skill}}% | {{sm05_trend}} |
| SM-06 | 文档链断裂检测 | {{sm06_current}}% | {{sm06_compressed}}% | {{sm06_future}}% | {{sm06_no_skill}}% | {{sm06_trend}} |
| SM-07 | 大小写敏感检测 | {{sm07_current}}% | {{sm07_compressed}}% | {{sm07_future}}% | {{sm07_no_skill}}% | {{sm07_trend}} |
| SM-08 | 过时文档检测 | {{sm08_current}}% | {{sm08_compressed}}% | {{sm08_future}}% | {{sm08_no_skill}}% | {{sm08_trend}} |

### 4.3 Recovery 场景

| ID | 场景名 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 趋势 |
|:--:|--------|:-----:|:-----:|:-----:|:---------:|:----:|
| RC-01 | Agent 接力（阶段三） | {{rc01_current}}% | {{rc01_compressed}}% | {{rc01_future}}% | {{rc01_no_skill}}% | {{rc01_trend}} |
| RC-02 | Agent 接力（阶段五） | {{rc02_current}}% | {{rc02_compressed}}% | {{rc02_future}}% | {{rc02_no_skill}}% | {{rc02_trend}} |
| RC-03 | 中间文档缺失恢复 | {{rc03_current}}% | {{rc03_compressed}}% | {{rc03_future}}% | {{rc03_no_skill}}% | {{rc03_trend}} |
| RC-04 | 文档矛盾恢复 | {{rc04_current}}% | {{rc04_compressed}}% | {{rc04_future}}% | {{rc04_no_skill}}% | {{rc04_trend}} |
| RC-05 | 用户反悔回退 | {{rc05_current}}% | {{rc05_compressed}}% | {{rc05_future}}% | {{rc05_no_skill}}% | {{rc05_trend}} |

### 4.4 Failure 场景

| ID | 场景名 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 趋势 |
|:--:|--------|:-----:|:-----:|:-----:|:---------:|:----:|
| FL-01 | 文档矛盾检测 | {{fl01_current}}% | {{fl01_compressed}}% | {{fl01_future}}% | {{fl01_no_skill}}% | {{fl01_trend}} |
| FL-02 | 跳阶段检测 | {{fl02_current}}% | {{fl02_compressed}}% | {{fl02_future}}% | {{fl02_no_skill}}% | {{fl02_trend}} |
| FL-03 | 不完整 Concept 退回 | {{fl03_current}}% | {{fl03_compressed}}% | {{fl03_future}}% | {{fl03_no_skill}}% | {{fl03_trend}} |
| FL-04 | 不支持产品形态 | {{fl04_current}}% | {{fl04_compressed}}% | {{fl04_future}}% | {{fl04_no_skill}}% | {{fl04_trend}} |
| FL-05 | 超出 Skill 范围 | {{fl05_current}}% | {{fl05_compressed}}% | {{fl05_future}}% | {{fl05_no_skill}}% | {{fl05_trend}} |

### 4.5 Guardrail 场景

| ID | 场景名 | 当前版 | 压缩版 | 后续版 | 无Skill版 | 趋势 |
|:--:|--------|:-----:|:-----:|:-----:|:---------:|:----:|
| GR-01 | STOP 门防护 | {{gr01_current}}% | {{gr01_compressed}}% | {{gr01_future}}% | {{gr01_no_skill}}% | {{gr01_trend}} |
| GR-02 | Change.md 记录 | {{gr02_current}}% | {{gr02_compressed}}% | {{gr02_future}}% | {{gr02_no_skill}}% | {{gr02_trend}} |
| GR-03 | 不完整文档审查 | {{gr03_current}}% | {{gr03_compressed}}% | {{gr03_future}}% | {{gr03_no_skill}}% | {{gr03_trend}} |
| GR-04 | 阶段跳过检测 | {{gr04_current}}% | {{gr04_compressed}}% | {{gr04_future}}% | {{gr04_no_skill}}% | {{gr04_trend}} |
| GR-05 | 跨阶段交叉校验 | {{gr05_current}}% | {{gr05_compressed}}% | {{gr05_future}}% | {{gr05_no_skill}}% | {{gr05_trend}} |

---

## 5. Token 使用分析

| 度量 | 当前版 | 压缩版 | 后续版 | 无Skill版 |
|------|:-----:|:-----:|:-----:|:---------:|
| 总 Token 消耗 | {{token_total_current}} | {{token_total_compressed}} | {{token_total_future}} | {{token_total_no_skill}} |
| 平均每场景 | {{token_avg_current}} | {{token_avg_compressed}} | {{token_avg_future}} | {{token_avg_no_skill}} |
| 最大单场景 | {{token_max_current}} | {{token_max_compressed}} | {{token_max_future}} | {{token_max_no_skill}} |
| 最小单场景 | {{token_min_current}} | {{token_min_compressed}} | {{token_min_future}} | {{token_min_no_skill}} |
| 效率(分/千Token) | {{token_efficiency_current}} | {{token_efficiency_compressed}} | {{token_efficiency_future}} | {{token_efficiency_no_skill}} |

### Token 分布（按类别）

| 类别 | 当前版 | 压缩版 | 后续版 | 无Skill版 |
|------|:-----:|:-----:|:-----:|:---------:|
| Happy Path | {{token_hp_current}} | {{token_hp_compressed}} | {{token_hp_future}} | {{token_hp_no_skill}} |
| State Machine | {{token_sm_current}} | {{token_sm_compressed}} | {{token_sm_future}} | {{token_sm_no_skill}} |
| Recovery | {{token_rc_current}} | {{token_rc_compressed}} | {{token_rc_future}} | {{token_rc_no_skill}} |
| Failure | {{token_fl_current}} | {{token_fl_compressed}} | {{token_fl_future}} | {{token_fl_no_skill}} |
| Guardrail | {{token_gr_current}} | {{token_gr_compressed}} | {{token_gr_future}} | {{token_gr_no_skill}} |

---

## 6. 延迟分析

| 度量 | 当前版 | 压缩版 | 后续版 | 无Skill版 |
|------|:-----:|:-----:|:-----:|:---------:|
| 总耗时 | {{latency_total_current}}s | {{latency_total_compressed}}s | {{latency_total_future}}s | {{latency_total_no_skill}}s |
| 平均每场景 | {{latency_avg_current}}s | {{latency_avg_compressed}}s | {{latency_avg_future}}s | {{latency_avg_no_skill}}s |
| 最快场景 | {{latency_fastest_current}} | {{latency_fastest_compressed}} | {{latency_fastest_future}} | {{latency_fastest_no_skill}} |
| 最慢场景 | {{latency_slowest_current}} | {{latency_slowest_compressed}} | {{latency_slowest_future}} | {{latency_slowest_no_skill}} |

---

## 7. 覆盖分析

### 7.1 SKILL.md 规则覆盖矩阵

| 规则区域 | 规则数 | 覆盖场景 | 覆盖率 |
|---------|:-----:|:--------:|:-----:|
| 阶段识别器（6 条） | 6 | SM-01~SM-05 | {{coverage_stage_detector}}% |
| 文档链断裂检测（1 条） | 1 | SM-06, RC-03 | {{coverage_chain_break}}% |
| 阶段一 6 问题覆盖（3 条） | 3 | HP-01, GR-01, GR-03, FL-03 | {{coverage_phase1}}% |
| 阶段二 Concept→Plan 校验（2 条） | 2 | HP-02, GR-05 | {{coverage_phase2}}% |
| 阶段三 Plan→Project 适配（2 条） | 2 | HP-03, HP-04 | {{coverage_phase3}}% |
| 阶段四 Task 跟踪（3 条） | 3 | HP-04, SM-05 | {{coverage_phase4}}% |
| 阶段五 实现执行（4 条） | 4 | SM-05, RC-02 | {{coverage_phase5}}% |
| 阶段六 Summary（2 条） | 2 | HP-05 | {{coverage_phase6}}% |
| 全局规则1 STOP 门（2 条） | 2 | GR-01, GR-04 | {{coverage_stop}}% |
| 全局规则2 Change.md（2 条） | 2 | GR-02, RC-05 | {{coverage_changemd}}% |
| 全局规则3 读取已有文档（2 条） | 2 | SM-01~SM-08, RC-01~RC-05 | {{coverage_read_existing}}% |
| 全局规则4 先文档再代码（1 条） | 1 | GR-05 | {{coverage_doc_first}}% |
| 全局规则5 计划外变更（2 条） | 2 | FL-01, FL-04, RC-05 | {{coverage_unplanned}}% |
| 异常处理表（5 条） | 5 | FL-01~FL-05 | {{coverage_exceptions}}% |
| 故障处理手册（6+8 条） | 14 | FL-01~FL-03, RC-03~RC-04 | {{coverage_failure_handbook}}% |
| **合计** | **~50 条** | **28 场景** | **{{coverage_total}}%** |

### 7.2 变更管理覆盖分析

| 变更场景 | 测试覆盖 | 场景 ID |
|---------|:-------:|:--------:|
| Plan 技术栈修改记录 Change.md | ✅ | GR-02 |
| 上游修改联动检查下游 | ✅ | RC-05 |
| Change.md 纯追加（不覆盖） | ❌ 需新增 | — |
| 多次修改验证追加模式 | ❌ 需新增 | — |

### 7.3 覆盖缺口

以下规则在当前 benchmark 中未覆盖，建议补充：

| 缺口 | 对应规则 | 建议场景 | 优先级 |
|------|---------|---------|:-----:|
| 阶段五前端骨架三旋钮 | 5.1.1 A/B/C | 代码级 eval | P2 |
| 外部技能调用(impeccable/gsap) | 阶段五引用 | 技能调用检查 | P2 |
| 前端预检清单 33 项 | validation-rules.md | 代码审查 eval | P2 |
| 多种产品形态(CLI/库/Landing) | 阶段三适配 | 非 Web 场景 | P1 |
| Change.md 多次追加验证 | change-management.md | 多轮修改 | P1 |
| 连续跳过 2 阶段 | failure-handbook.md | FL-06 变体 | P1 |
| 规范文档与代码不一致 | 全局规则4 | 代码级 eval | P2 |

### 7.4 覆盖率趋势

```
版本迭代覆盖率变化:

当前版:    ████████████████████░░░░  50%
压缩版:   ██████████████████░░░░░░  45%
后续版:   ████████████████████████  60%  (目标)
无Skill版: ████████░░░░░░░░░░░░░░░  10%  (基线参考)
```

---

## 8. 结论与建议

### 8.1 版本对比结论

| 对比维度 | 结论 |
|---------|------|
| **当前版 vs 压缩版** | {{conclusion_current_vs_compressed}} |
| **当前版 vs 后续版** | {{conclusion_current_vs_future}} |
| **有Skill vs 无Skill** | {{conclusion_skill_vs_no_skill}} |
| **最大改进点** | {{biggest_improvement}} |
| **最大退化点** | {{biggest_regression}} |

### 8.2 建议

1. **{{recommendation_1_title}}**
   {{recommendation_1_detail}}

2. **{{recommendation_2_title}}**
   {{recommendation_2_detail}}

3. **{{recommendation_3_title}}**
   {{recommendation_3_detail}}

---

## 附录 A: 场景列表

| ID | 场景名 | 类别 | 文件依赖 | 运行模式 |
|:--:|--------|:----:|:--------:|:--------:|
{{scenario_list_table}}

---

## 附录 B: 评分方法论

### B.1 评分标准

每个场景的评分由多个 criteria 组成，每个 criteria 有独立的权重和 pass_condition：

```
单场景得分 = Σ(criterion_score × criterion_weight) / Σ(weights)
```

### B.2 维度聚合

```
维度得分 = Σ(该维度下所有场景得分) / 场景数
综合得分 = Σ(维度得分 × 维度权重)
```

### B.3 版本对比

不同版本的相同场景在相同条件下运行。

Token 和 Latency 的版本间比较使用基线归一化：

```
Token 效率 = min(1.0, baseline_tokens / actual_tokens)
Latency    = min(1.0, baseline_time / actual_time)
```

---

## 附录 C: 运行环境和配置

| 配置项 | 值 |
|--------|-----|
| 模型 | {{model_name}} |
| 运行日期 | {{run_date}} |
| 总耗时 | {{total_duration}} |
| 评估者 | {{evaluator}} |

---

_报告由 back-to-file Benchmark Runner 自动生成_
_模板版本: 1.0 | 生成日期: {{report_date}}_

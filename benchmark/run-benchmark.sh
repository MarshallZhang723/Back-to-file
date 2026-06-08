#!/usr/bin/env bash
# ============================================================================
# back-to-file Benchmark Runner
# ============================================================================
# 用法:
#   ./run-benchmark.sh                    # 运行所有场景
#   ./run-benchmark.sh --category happy   # 只运行指定类别
#   ./run-benchmark.sh --id HP-01         # 只运行指定场景
#   ./run-benchmark.sh --compare v1 v2    # 比较两次运行结果
#   ./run-benchmark.sh --report           # 从已有结果生成报告
#
# 输出:
#   results/              - 每次运行的结果（JSON 格式）
#   results/report.md     - 最新报告
# ============================================================================

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BENCH_DIR="$SKILL_DIR/benchmark"
RESULT_DIR="$BENCH_DIR/results"
BENCH_JSON="$BENCH_DIR/benchmark.json"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RUN_DIR="$RESULT_DIR/run_$TIMESTAMP"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 帮助
usage() {
  cat <<EOF
用法: $(basename "$0") [选项]

选项:
  --category <name>  只运行指定类别 (happy-path|state-machine|recovery|failure|guardrail)
  --id <scenario>    只运行指定场景 ID (如 HP-01)
  --compare <r1> <r2>  比较两个运行结果
  --report           从已有结果生成 HTML 报告
  --list             列出所有可用场景
  --help             显示此帮助

示例:
  ./run-benchmark.sh --category happy-path
  ./run-benchmark.sh --id HP-01
  ./run-benchmark.sh --compare run_20250101_120000 run_20250102_120000
  ./run-benchmark.sh --report
EOF
  exit 0
}

# 场景信息
list_scenarios() {
  echo -e "${BLUE}=== back-to-file Benchmark 场景列表 ===${NC}"
  echo ""
  jq -r '.scenarios[] | "\(.id)  [\(.category)]  \(.name)"' "$BENCH_JSON" | sort
  echo ""
  echo "总计 $(jq '.scenarios | length' "$BENCH_JSON") 个场景"
  echo ""
  echo "类别分布:"
  jq -r '.meta.categories | to_entries[] | "  \(.value.label): \(.value.count) 场景 (\(.key))"' "$BENCH_JSON"
  echo ""
  echo "评估维度:"
  jq -r '.dimensions | to_entries[] | "  \(.value.label) (权重: \(.value.weight)): \(.value.description)"' "$BENCH_JSON"
  echo ""
  echo "可比较版本:"
  jq -r '.versions | to_entries[] | "  \(.value.label): \(.value.description)"' "$BENCH_JSON"
}

# 准备测试文件
setup_files() {
  local scenario_id="$1"
  local work_dir="$RUN_DIR/$scenario_id"
  mkdir -p "$work_dir"
  cd "$work_dir"

  # 从 benchmark.json 获取此场景的文件列表
  local files
  files=$(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .files[]' "$BENCH_JSON")

  # 如果没有文件需要准备，跳过
  if [ -z "$files" ]; then
    mkdir -p "$work_dir"
    return 0
  fi

  echo -e "${BLUE}准备测试文件...${NC}"

  # 复制文件到工作目录
  while IFS= read -r file; do
    local abs_path=""
    if [[ "$file" == /* ]]; then
      abs_path="$file"
    elif [[ "$file" == ../../* ]]; then
      # 引用 evals/files/ 的路径
      abs_path="$SKILL_DIR/$(echo "$file" | sed 's/^..\/..\///')"
    elif [[ "$file" == datasets/* ]]; then
      # 引用 benchmark/datasets/ 的路径
      abs_path="$BENCH_DIR/$file"
    else
      abs_path="$BENCH_DIR/$file"
    fi

    if [ -f "$abs_path" ]; then
      # 获取原文件名（去掉路径）
      local filename
      filename=$(basename "$abs_path")
      cp "$abs_path" "$work_dir/$filename"
      echo -e "  ${GREEN}✓${NC} $filename"
    else
      echo -e "  ${RED}✗${NC} 找不到文件: $abs_path"
    fi
  done <<< "$files"

  # 检查是否有重命名的需要
  local rename_target
  rename_target=$(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .rename_target // empty' "$BENCH_JSON")
  if [ -n "$rename_target" ]; then
    echo -e "${YELLOW}  文件重命名: $(ls *.md | head -1) → $rename_target${NC}"
    mv "$(ls *.md | head -1)" "$rename_target"
  fi
}

# 运行单个场景
run_scenario() {
  local scenario_id="$1"
  local scenario_name
  local scenario_prompt
  local scenario_category

  scenario_name=$(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .name' "$BENCH_JSON")
  scenario_category=$(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .category' "$BENCH_JSON")
  scenario_prompt=$(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .prompt' "$BENCH_JSON")

  # 创建运行目录
  setup_files "$scenario_id"

  echo ""
  echo -e "${YELLOW}========================================${NC}"
  echo -e "${YELLOW}  场景: $scenario_id${NC}"
  echo -e "${YELLOW}  名称: $scenario_name${NC}"
  echo -e "${YELLOW}  类别: $scenario_category${NC}"
  echo -e "${YELLOW}========================================${NC}"
  echo ""
  echo -e "${BLUE}当前工作目录:${NC} $RUN_DIR/$scenario_id"

  # 输出场景信息
  cat <<INFO > "$RUN_DIR/$scenario_id/meta.json"
{
  "id": "$scenario_id",
  "name": "$scenario_name",
  "category": "$scenario_category",
  "run_mode": $(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .run_mode // "single_prompt"' "$BENCH_JSON"),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "files": $(jq -r --arg id "$scenario_id" '.scenarios[] | select(.id==$id) | .files' "$BENCH_JSON")
}
INFO

  echo ""
  echo -e "${GREEN}请使用以下 Prompt 测试场景:${NC}"
  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "$scenario_prompt"
  echo "--------------------------------------------------------------------------------"
  echo ""
  echo -e "${YELLOW}测试准备就绪！${NC}"
  echo ""
  echo "在当前场景目录中使用以下命令切换到工作目录："
  echo "  cd $RUN_DIR/$scenario_id"
  echo ""
  echo "测试完成后，在 $RUN_DIR/$scenario_id/result.json 记录结果。"
  echo ""
}

# 记录结果到 JSON
record_result() {
  local scenario_id="$1"
  local metric="$2"
  local value="$3"
  local result_file="$RUN_DIR/$scenario_id/result.json"

  if [ ! -f "$result_file" ]; then
    echo "{}" > "$result_file"
  fi

  local tmp
  tmp=$(mktemp)
  jq --arg m "$metric" --arg v "$value" '. + {($m): $v}' "$result_file" > "$tmp" && mv "$tmp" "$result_file"
}

# 评分一个场景
score_scenario() {
  local scenario_id="$1"
  local result_file="$RUN_DIR/$scenario_id/result.json"

  if [ ! -f "$result_file" ]; then
    echo -e "${RED}  未找到结果文件: $result_file${NC}"
    return 1
  fi

  echo -e "${BLUE}评分: $scenario_id${NC}"

  # 获取评分规则
  jq -r --arg id "$scenario_id" '
    .scenarios[] | select(.id==$id) | .scoring_rules | to_entries[] |
    .key as $dim | .value | (if type == "object" then .criteria // . else . end)? // [] |
    .[] | "\($dim)::\(.id)::\(.description)::\(.weight)::\(.pass_condition)"
  ' "$BENCH_JSON" | while IFS='::' read -r dim criterion_id desc weight condition; do
    echo "    - $desc (权重: $weight, 条件: $condition)"
  done
}

# 计算聚合得分
aggregate_scores() {
  local target_dir="$1"
  echo -e "${BLUE}聚合评分...${NC}"

  # 遍历每个场景的结果
  local summary_file="$target_dir/summary.json"
  local tmp
  tmp=$(mktemp)

  # 初始化汇总结构
  cat > "$tmp" <<EOF
{
  "run_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "total_scenarios": $(jq '.scenarios | length' "$BENCH_JSON"),
  "dimensions": $(jq '.dimensions' "$BENCH_JSON"),
  "categories": $(jq '.meta.categories' "$BENCH_JSON"),
  "scenario_results": {},
  "category_scores": {},
  "dimension_scores": {},
  "overall_score": 0
}
EOF

  # 收集每个场景的结果
  for scenario_dir in "$target_dir"/[A-Z][A-Z]-[0-9][0-9]; do
    if [ -d "$scenario_dir" ]; then
      local sid
      sid=$(basename "$scenario_dir")
      local result_file="$scenario_dir/result.json"
      local score_file="$scenario_dir/score.json"

      if [ -f "$result_file" ] && [ -f "$score_file" ]; then
        local scores
        scores=$(cat "$score_file")
        tmp2=$(mktemp)
        jq --arg sid "$sid" --argjson scores "$scores" \
          '.scenario_results[$sid] = $scores' "$tmp" > "$tmp2" && mv "$tmp2" "$tmp"
      fi
    fi
  done

  # 计算类别聚合
  jq -r '.meta.categories | keys[]' "$BENCH_JSON" | while IFS= read -r cat; do
    local cat_scores
    cat_scores=$(jq --arg cat "$cat" '
      [.scenario_results | to_entries[] | select(.key | startswith(
        if $cat == "happy-path" then "HP"
        elif $cat == "state-machine" then "SM"
        elif $cat == "recovery" then "RC"
        elif $cat == "failure" then "FL"
        elif $cat == "guardrail" then "GR"
        else "XX" end
      )) | .value.task_success // 0] | if length > 0 then add / length else 0 end
    ' "$tmp")

    tmp3=$(mktemp)
    jq --arg cat "$cat" --argjson score "$cat_scores" \
      '.category_scores[$cat] = $score' "$tmp" > "$tmp3" && mv "$tmp3" "$tmp"
  done

  # 计算维度得分
  jq -r '.dimensions | keys[]' "$BENCH_JSON" | while IFS= read -r dim; do
    local dim_total=0
    local dim_count=0

    for scenario_dir in "$target_dir"/[A-Z][A-Z]-[0-9][0-9]; do
      if [ -d "$scenario_dir" ]; then
        local score_file="$scenario_dir/score.json"
        if [ -f "$score_file" ]; then
          local val
          val=$(jq -r --arg dim "$dim" '.[$dim] // 0' "$score_file")
          dim_total=$(echo "$dim_total + $val" | bc 2>/dev/null || echo "$dim_total + 0" | bc)
          dim_count=$((dim_count + 1))
        fi
      fi
    done

    if [ "$dim_count" -gt 0 ]; then
      local dim_avg
      dim_avg=$(echo "scale=4; $dim_total / $dim_count" | bc)
      tmp4=$(mktemp)
      jq --arg dim "$dim" --argjson avg "$dim_avg" \
        '.dimension_scores[$dim] = $avg' "$tmp" > "$tmp4" && mv "$tmp4" "$tmp"
    fi
  done

  # 计算综合得分（按权重加权）
  jq '
    .overall_score = (
      .dimensions as $dims |
      [.dimension_scores | to_entries[] |
        {
          key: .key,
          weighted: (.value * ($dims[.key].weight // 0))
        }
      ] | map(.weighted) | add
    )
  ' "$tmp" > "$summary_file"

  echo -e "${GREEN}聚合完成: $summary_file${NC}"
}

# 生成报告
generate_report() {
  local target_dir="$1"

  if [ ! -f "$target_dir/summary.json" ]; then
    aggregate_scores "$target_dir"
  fi

  local report_file="$target_dir/report.md"

  # 读取汇总数据
  local overall
  overall=$(jq '.overall_score' "$target_dir/summary.json")
  local total
  total=$(jq '.total_scenarios' "$target_dir/summary.json")

  # 生成报告头部
  cat > "$report_file" <<EOF
# back-to-file Benchmark 报告

**运行时间**: $(jq -r '.run_timestamp' "$target_dir/summary.json")
**总场景数**: $total
**综合得分**: $(printf "%.1f" "$(echo "$overall * 100" | bc)")%

---

## 维度得分

EOF

  # 维度得分表
  echo "| 维度 | 得分 | 权重 | 加权得分 |" >> "$report_file"
  echo "|------|------|------|---------|" >> "$report_file"

  jq -r '
    .dimensions as $dims |
    .dimension_scores | to_entries[] |
    "| \($dims[.key].label) | \((.value * 100) | floor)% | \(($dims[.key].weight * 100 | floor))% | \(((.value * $dims[.key].weight * 100) | floor))% |"
  ' "$target_dir/summary.json" >> "$report_file"

  echo "" >> "$report_file"

  # 类别得分
  echo "## 类别得分" >> "$report_file"
  echo "" >> "$report_file"
  echo "| 类别 | 得分 | 场景数 |" >> "$report_file"
  echo "|------|------|-------|" >> "$report_file"

  jq -r '
    .categories as $cats |
    .category_scores | to_entries[] |
    "| \($cats[.key].label) | \((.value * 100) | floor)% | \($cats[.key].count) |"
  ' "$target_dir/summary.json" >> "$report_file"

  echo "" >> "$report_file"

  # 各场景详细结果
  echo "## 场景详细结果" >> "$report_file"
  echo "" >> "$report_file"

  jq -r '
    .scenario_results | to_entries[] |
    "### \(.key)\n\n- Task Success: \((.value.task_success // 0) * 100)%\n- State Machine: \((.value.state_machine // 0) * 100)%\n- Guardrail: \((.value.guardrail // 0) * 100)%\n- Recovery: \((.value.recovery // 0) * 100)%\n- Token Usage: \((.value.token_usage // 0) * 100)%\n- Latency: \((.value.latency // 0) * 100)%\n"
  ' "$target_dir/summary.json" >> "$report_file"

  echo -e "${GREEN}报告生成: $report_file${NC}"

  # 同时复制到 results/latest
  cp "$report_file" "$RESULT_DIR/latest_report.md"
  echo -e "${GREEN}最新报告已同步: $RESULT_DIR/latest_report.md${NC}"
}

# 比较两次运行
compare_runs() {
  local run1="$1"
  local run2="$2"
  local dir1="$RESULT_DIR/$run1"
  local dir2="$RESULT_DIR/$run2"

  if [ ! -d "$dir1" ]; then
    echo -e "${RED}未找到结果目录: $dir1${NC}"
    exit 1
  fi
  if [ ! -d "$dir2" ]; then
    echo -e "${RED}未找到结果目录: $dir2${NC}"
    exit 1
  fi

  # 确保有 summary
  if [ ! -f "$dir1/summary.json" ]; then
    aggregate_scores "$dir1"
  fi
  if [ ! -f "$dir2/summary.json" ]; then
    aggregate_scores "$dir2"
  fi

  local compare_file="$RESULT_DIR/compare_${run1}_vs_${run2}.md"

  # 读取得分
  local overall1 overall2
  overall1=$(jq '.overall_score' "$dir1/summary.json")
  overall2=$(jq '.overall_score' "$dir2/summary.json")

  cat > "$compare_file" <<EOF
# Benchmark 版本对比报告

**版本 A**: $run1（综合得分: $(printf "%.1f" "$(echo "$overall1 * 100" | bc)")%）
**版本 B**: $run2（综合得分: $(printf "%.1f" "$(echo "$overall2 * 100" | bc)")%）
**对比日期**: $(date -u +%Y-%m-%d)

---

## 维度对比

| 维度 | 版本 A | 版本 B | 变化 |
|------|--------|--------|------|
EOF

  # 维度对比行
  jq -r '
    .dimensions as $dims |
    $dims | keys[] as $k |
    "\($k)"
  ' "$dir1/summary.json" | while IFS= read -r dim; do
    local s1 s2
    s1=$(jq -r --arg d "$dim" '.dimension_scores[$d] // 0' "$dir1/summary.json")
    s2=$(jq -r --arg d "$dim" '.dimension_scores[$d] // 0' "$dir2/summary.json")
    local p1 p2
    p1=$(echo "$s1 * 100" | bc)
    p2=$(echo "$s2 * 100" | bc)
    local diff
    diff=$(echo "scale=1; $p2 - $p1" | bc)
    local arrow
    if (( $(echo "$diff > 0" | bc -l) )); then
      arrow="📈 +$diff%"
    elif (( $(echo "$diff < 0" | bc -l) )); then
      arrow="📉 $diff%"
    else
      arrow="➡️ 0%"
    fi
    local label
    label=$(jq -r --arg d "$dim" '.dimensions[$d].label' "$dir1/summary.json")
    echo "| $label | $(printf "%.1f" "$p1")% | $(printf "%.1f" "$p2")% | $arrow |" >> "$compare_file"
  done

  echo "" >> "$compare_file"

  # 类别对比
  echo "## 类别对比" >> "$compare_file"
  echo "" >> "$compare_file"
  echo "| 类别 | 版本 A | 版本 B | 变化 |" >> "$compare_file"
  echo "|------|--------|--------|------|" >> "$compare_file"

  jq -r '.meta.categories | keys[]' "$BENCH_JSON" | while IFS= read -r cat; do
    local s1 s2
    s1=$(jq -r --arg c "$cat" '.category_scores[$c] // 0' "$dir1/summary.json")
    s2=$(jq -r --arg c "$cat" '.category_scores[$c] // 0' "$dir2/summary.json")
    local p1 p2
    p1=$(echo "$s1 * 100" | bc)
    p2=$(echo "$s2 * 100" | bc)
    local diff
    diff=$(echo "scale=1; $p2 - $p1" | bc)
    local arrow
    if (( $(echo "$diff > 0" | bc -l) )); then
      arrow="📈 +$diff%"
    elif (( $(echo "$diff < 0" | bc -l) )); then
      arrow="📉 $diff%"
    else
      arrow="➡️ 0%"
    fi
    local label
    label=$(jq -r --arg c "$cat" '.categories[$c].label' "$BENCH_JSON")
    echo "| $label | $(printf "%.1f" "$p1")% | $(printf "%.1f" "$p2")% | $arrow |" >> "$compare_file"
  done

  echo "" >> "$compare_file"
  echo "---" >> "$compare_file"
  echo -e "\n_由 back-to-file Benchmark Runner 自动生成_" >> "$compare_file"

  echo -e "${GREEN}对比报告生成: $compare_file${NC}"
}

# 主函数
main() {
  mkdir -p "$RESULT_DIR"

  # 参数解析
  local mode="run_all"
  local filter_category=""
  local filter_id=""
  local run1=""
  local run2=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --help|-h) usage ;;
      --list|-l) list_scenarios; exit 0 ;;
      --category) shift; filter_category="$1"; mode="filtered" ;;
      --id) shift; filter_id="$1"; mode="single" ;;
      --compare) shift; run1="$1"; shift; run2="$1"; mode="compare" ;;
      --report) mode="report" ;;
      *) echo -e "${RED}未知选项: $1${NC}"; usage ;;
    esac
    shift
  done

  case "$mode" in
    "compare")
      compare_runs "$run1" "$run2"
      ;;
    "report")
      local latest
      latest=$(ls -td "$RESULT_DIR"/run_* 2>/dev/null | head -1)
      if [ -z "$latest" ]; then
        echo -e "${RED}未找到运行结果${NC}"
        exit 1
      fi
      generate_report "$latest"
      ;;
    "run_all"|"filtered"|"single")
      mkdir -p "$RUN_DIR"

      echo -e "${BLUE}=== back-to-file Benchmark Runner ===${NC}"
      echo -e "运行时间: $(date)"
      echo -e "结果目录: $RUN_DIR"
      echo ""

      # 收集要运行的场景 ID
      local scenario_ids
      if [ -n "$filter_id" ]; then
        scenario_ids="$filter_id"
      elif [ -n "$filter_category" ]; then
        scenario_ids=$(jq -r --arg cat "$filter_category" \
          '.scenarios[] | select(.category==$cat) | .id' "$BENCH_JSON")
      else
        scenario_ids=$(jq -r '.scenarios[].id' "$BENCH_JSON")
      fi

      echo "将运行以下场景:"
      echo "$scenario_ids"
      echo ""

      local count=0
      while IFS= read -r sid; do
        if [ -n "$sid" ]; then
          run_scenario "$sid"
          count=$((count + 1))
        fi
      done <<< "$scenario_ids"

      echo ""
      echo -e "${GREEN}========================================${NC}"
      echo -e "${GREEN}  已准备 $count 个场景${NC}"
      echo -e "${GREEN}  运行目录: $RUN_DIR${NC}"
      echo -e "${GREEN}========================================${NC}"
      echo ""
      echo "测试完成后，运行以下命令生成报告:"
      echo "  $0 --report"
      echo ""

      # 保存运行元数据
      cat > "$RUN_DIR/run_meta.json" <<EOF
{
  "timestamp": "$TIMESTAMP",
  "mode": "$mode",
  "filter_category": "$filter_category",
  "filter_id": "$filter_id",
  "scenarios_prepared": $count
}
EOF

      # 打开结果目录（macOS）
      if command -v open &>/dev/null; then
        open "$RUN_DIR"
      fi
      ;;
  esac
}

main "$@"

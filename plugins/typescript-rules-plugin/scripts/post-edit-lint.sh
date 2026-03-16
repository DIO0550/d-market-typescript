#!/usr/bin/env bash
set -euo pipefail

# --- stdin から編集されたファイルパスを取得 ---
input="$(cat)"
file="$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<< "$input")"

# 対象拡張子のみ処理
case "$file" in
  *.ts|*.tsx|*.js|*.jsx) ;;
  *) exit 0 ;;
esac

# ファイルが存在しなければスキップ（削除の場合など）
[ -f "$file" ] || exit 0

# --- 最寄りの package.json を探索 ---
find_nearest_package_json() {
  local dir="$1"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/package.json" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

project_root="$(find_nearest_package_json "$(dirname "$file")")" || exit 0
pkg="$project_root/package.json"

# --- package.json からリンターの有無を判定 ---
has_dep() {
  jq -e --arg name "$1" '
    (.dependencies[$name] // .devDependencies[$name]) != null
  ' "$pkg" >/dev/null 2>&1
}

# pnpm exec をプロジェクトルートで実行
run_tool() {
  (cd "$project_root" && pnpm exec "$@")
}

diag=""
ran_lint=false

# --- oxlint (ESLint より高速な代替。両方あれば oxlint を優先) ---
if has_dep "oxlint"; then
  run_tool oxlint --fix "$file" >/dev/null 2>&1 || true
  result="$(run_tool oxlint "$file" 2>&1 | head -30)" || true
  if [ -n "$result" ]; then
    diag="${diag}[oxlint]
${result}

"
  fi
  ran_lint=true
fi

# --- ESLint (oxlint が無い場合のフォールバック) ---
if [ "$ran_lint" = false ] && has_dep "eslint"; then
  run_tool eslint --fix "$file" >/dev/null 2>&1 || true
  result="$(run_tool eslint "$file" 2>&1 | head -30)" || true
  if [ -n "$result" ]; then
    diag="${diag}[eslint]
${result}

"
  fi
fi

# --- Biome (フォーマッター + リンター) ---
if has_dep "@biomejs/biome"; then
  run_tool biome check --fix "$file" >/dev/null 2>&1 || true
  result="$(run_tool biome check "$file" 2>&1 | head -30)" || true
  if [ -n "$result" ]; then
    diag="${diag}[biome]
${result}

"
  fi
fi

# --- 診断結果をフィードバック ---
if [ -n "$diag" ]; then
  jq -Rn --arg msg "$diag" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: ("Lint diagnostics:\n" + $msg + "\nFix the remaining issues above.")
    }
  }'
fi

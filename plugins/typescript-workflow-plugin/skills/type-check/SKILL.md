---
name: type-check
description: TypeScriptプロジェクトの型チェック実行スキル。tscによる型エラー検出とレポート。型チェック実行時は必ずエージェント（Task tool）を使用し、直接Bashで型チェックコマンドを実行しない。
---

# Type Check Skill

型チェック実行時は **必ずエージェント（Task tool）を使用** する。

## 実行方法

Task tool を使用:
- subagent_type: "type-check-agent"
- prompt: "型チェックを実行"

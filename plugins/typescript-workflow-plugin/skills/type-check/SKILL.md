---
name: type-check
description: TypeScriptプロジェクトの型チェック実行スキル。原則はエージェント（Task tool）経由で実行し、利用不可時のみ直接コマンドでフォールバックする。
---

# Type Check Skill

型チェック実行は **原則エージェント（Task tool）を使用** する。

## 実行方法

Task tool:
- subagent_type: "type-check-agent"
- prompt: "型チェックを実行"

## フォールバック（Task tool が使えない場合）

Task tool が利用できない場合のみ、以下の順で直接実行してよい：

1. `pnpm run type-check`
2. `yarn tsc --noEmit`
3. `npm run type-check`

実行後は型エラー件数と、主要なエラー種別を要約して報告する。

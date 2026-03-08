---
name: test
description: TypeScriptプロジェクトのテスト実行スキル。原則はエージェント（Task tool）経由で実行し、利用不可時のみ直接コマンドでフォールバックする。
---

# Test Skill

テスト実行は **原則エージェント（Task tool）を使用** する。

## 実行方法

Task tool:
- subagent_type: "test-agent"
- prompt: "テストを実行"

## フォールバック（Task tool が使えない場合）

Task tool が利用できない場合のみ、以下の順で直接実行してよい：

1. `pnpm run test`
2. `yarn test`
3. `npm run test`

実行後は失敗テストの要約と、再現コマンドを必ず報告する。

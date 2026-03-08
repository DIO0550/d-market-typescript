---
name: workflow-setup
description: TypeScript プロジェクトの指示ファイルに d-market ワークフロースキル活用ガイドを追加するセットアップスキル。`setup` 名衝突回避のため workflow-setup を使用。
---

# TypeScript ワークフロースキル セットアップ

プロジェクトの指示ファイルに TypeScript ワークフロースキルの利用ガイドを追記する。

## 目的

typescript-workflow-plugin 導入後、指示ファイルに利用ルールを追記して AI の参照先を明確化する。

## 対象スキル

| スキル | 用途 |
|:--|:--|
| `test` | テスト実行 - エージェント経由で実行 |
| `type-check` | 型チェック（tsc）- エージェント経由で実行 |
| `file-search` | TypeScript ファイル・シンボル検索 - エージェント経由で実行 |

## 実行手順

### 1. 書き込み先の決定

以下の優先順で書き込み先を決定する。

| 優先度 | ファイル | 用途 |
|:--|:--|:--|
| 1 | `CLAUDE.md` | Claude Code |
| 2 | `.cursorrules` | Cursor |
| 3 | `.github/copilot-instructions.md` | GitHub Copilot |
| 4 | その他 | ユーザーが指定したファイル |

複数候補がある場合はユーザー確認。候補がなければ `CLAUDE.md` を新規作成する。

### 2. 既存セクションの確認

`## TypeScript ワークフロー` が既にある場合は、次の `##` 見出しまでを上書き更新する。

### 3. 以下のセクションを生成して追記する

```markdown
## TypeScript ワークフロー

以下の操作は対応するスキルを使用すること。

- テスト実行時は `test` スキルを使用
- 型チェック時は `type-check` スキルを使用
- TypeScript ファイル・シンボル検索時は `file-search` スキルを使用
```

### 4. ユーザーへの確認

追記内容と書き込み先を提示し、承認後に書き込む。

### 5. 完了報告

完了後、対象ファイルと追加スキルを報告する。

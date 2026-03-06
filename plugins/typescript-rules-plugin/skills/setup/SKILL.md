---
name: setup
description: TypeScript/Reactプロジェクトの指示ファイル（CLAUDE.md、.cursorrules等）にd-marketスキル活用ガイドを追加するセットアップスキル。プラグインのインストール後やプロジェクト初期設定時に使用。
disable-model-invocation: true
---

# TypeScript ルールスキル セットアップ

プロジェクトの指示ファイルに TypeScript / React 開発ルール系の d-market スキル活用ガイドを追記する。

## 目的

d-market の typescript-rules-plugin をインストール後、プロジェクトの指示ファイルに明示的なスキル利用指示を追加することで、AI が状況に応じてスキルを自動参照するようにする。

## 対象スキル

| スキル | 用途 |
|:--|:--|
| `implementation-workflow` | 実装開始時のエントリーポイント |
| `coding-standards` | TypeScript コーディング規約 |
| `tdd` | TDD Red-Green-Refactor サイクル |
| `testing` | ユニットテスト・統合テストのルール |
| `code-similarity-ts` | コード重複検出 |
| `typescript-code-review-skill` | コードレビュー（命名規則・テスト品質） |
| `typescript-performance-review-skill` | パフォーマンスレビュー |

## 実行手順

### 1. 書き込み先の決定

プロジェクトルートで以下のファイルを探し、書き込み先を決定する。

| 優先度 | ファイル | 用途 |
|:--|:--|:--|
| 1 | `CLAUDE.md` | Claude Code |
| 2 | `.cursorrules` | Cursor |
| 3 | `.github/copilot-instructions.md` | GitHub Copilot |
| 4 | その他 | ユーザーが指定したファイル |

複数存在する場合や判断できない場合は、ユーザーに確認する。いずれも存在しない場合は `CLAUDE.md` を新規作成する。

### 2. similarity-ts の検出

`which similarity-ts` を実行し、コマンドが存在するか確認する。存在しない場合は `code-similarity-ts` の行を省略する。

### 3. 既存セクションの確認

`## TypeScript 開発ルール` 見出しが既に存在する場合は、次の見出し（`##` レベル）までの範囲を上書き更新する。

### 4. 以下のセクションを生成して追記する

```markdown
## TypeScript 開発ルール

TypeScript コードを変更するすべての作業で以下のスキルを参照すること。

- 実装開始時は `implementation-workflow` スキルのフローに従う
- コーディング中は `coding-standards` スキルを参照
- テスト作成時は `tdd` および `testing` スキルを参照
- コード重複が疑われる場合は `code-similarity-ts` スキルを使用
- コードレビュー時は `typescript-code-review-skill` スキルを参照
- パフォーマンス確認時は `typescript-performance-review-skill` スキルを参照
```

**注意**:
- `similarity-ts` がインストールされていない場合、`code-similarity-ts` 行は省略する。

### 5. ユーザーへの確認

追記内容と書き込み先をユーザーに提示し、承認を得てから書き込む。

### 6. 完了報告

書き込み完了後、対象ファイルと追加したスキル一覧を報告する。

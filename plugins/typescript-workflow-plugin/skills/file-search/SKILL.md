---
name: file-search
description: TypeScriptプロジェクトのファイル検索スキル。原則は Task tool で検索し、利用不可時のみ `rg` / `find` へフォールバックする。
---

# TypeScript File Search Skill

## ルール（自動適用）

TypeScript（.ts/.tsx）検索では以下に従う。

### 基本ルール

1. **Task tool を優先**: 検索は `file-search-agent` へ委譲する
2. **直接検索は限定**: `rg` / `find` は除外条件に該当する場合のみ
3. **結果を起点に判断**: 検索結果を受けて次のアクションを決める

### 適用条件

以下で自動適用する：
- `.ts` または `.tsx` ファイルを検索しようとしている
- TypeScriptの関数、クラス、インターフェース、型を探している
- TypeScriptプロジェクトの構造を把握しようとしている
- コード内の特定のパターンを検索しようとしている

### 除外条件

以下は直接検索を許可：
- 既に検索対象のファイルパスが明確に分かっている場合
- 単一ファイルの内容を確認する場合
- 設定ファイル（package.json, tsconfig.json等）の検索
- Task tool が利用できない実行環境の場合（`rg` / `find` による検索を許可）

## 実行方法

### Task tool での呼び出し

```
Task tool:
  subagent_type: "file-search-agent"
  prompt: |
    以下の検索を実行してください。

    検索対象: {検索したい内容}
```

### 検索リクエストの例

- 「UserService クラスを探して」
- 「認証関連のファイルを検索」
- 「useAuth フックの定義場所を特定」
- 「API エンドポイントの一覧を取得」

## 参照エージェント

詳細は `agents/file-search-agent.md` を参照。

## 期待される結果

- 検索マッチ数のサマリー
- 関連度順のファイル一覧
- 重要なコードスニペット
- 依存関係の情報（必要に応じて）

---
name: testing
description: 単体テストルール。フラット構造（describe不使用）、モック使用制限、パラメータ化テスト、テストピラミッドなどの規約を定義。テストコードを新規作成・修正する際に参照すること。Vitest/Jest対応。
user-invocable: false
---

# 単体テストルール

## 基本ルール

- **網羅テスト**: 正常系・異常系・境界値のテストケースを作成
- **振る舞いのテスト**: 実装詳細ではなく振る舞いを確認
- **モックは最小限**: 基本はモックを使用しない
- **フラット構造**: describeブロックは使用しない。グループ化はファイル分割で行う
- **テストケース名**: 日本語で記述
- **パラメータ化**: `test.each` を活用
- **条件分岐禁止**: テストコード内で `if`/`else`/`switch` を使用しない。分岐が必要な場合は `test.each` またはテストケースの分割で対応

## テスト構造（フラット原則）

```typescript
// ✅ 推奨: describeなしのフラット構造
test("有効な認証情報でログインするとトークンが返る", () => {
  const result = login({ email: "test@example.com", password: "valid" });
  expect(result.token).toBeDefined();
});

test("無効なメールではValidationErrorが発生する", () => {
  expect(() => login({ email: "invalid", password: "valid" }))
    .toThrow(ValidationError);
});
```

## 条件分岐の禁止

```typescript
// ❌ 悪い例: if で分岐するテスト
test("数値を分類する", () => {
  const values = [0, 1, -1];
  for (const v of values) {
    const result = classify(v);
    if (v === 0) {
      expect(result).toBe("zero");
    } else if (v > 0) {
      expect(result).toBe("positive");
    } else {
      expect(result).toBe("negative");
    }
  }
});

// ✅ 良い例: test.each で分割
test.each([
  [0, "zero"],
  [1, "positive"],
  [-1, "negative"],
])("classify(%i) は %s を返す", (value, expected) => {
  expect(classify(value)).toBe(expected);
});
```

## モックルール

### モック禁止対象
- 自作の関数・コンポーネント
- プロジェクト内のユーティリティ関数
- 内部状態管理ロジック

### モック許可対象
- HTTPリクエスト（fetch、axiosなど）
- 外部API呼び出し
- ファイルシステムアクセス
- データベース接続
- 時間依存処理（Date、setTimeoutなど）

## パラメータ化テスト

```typescript
test.each([
  [1, 2, 3],
  [5, 5, 10],
  [-1, 1, 0],
])("add(%i, %i) は %i を返す", (a, b, expected) => {
  expect(add(a, b)).toBe(expected);
});
```

## テストピラミッド

| レベル | 比率 | 対象 |
|:-|:-|:-|
| 単体テスト | 70-80% | 関数、メソッド、個別コンポーネント |
| 統合テスト | 15-25% | モジュール間連携、API統合 |
| E2Eテスト | 5-10% | ユーザーシナリオ全体 |

## ディレクトリ構成

テストファイルの配置は以下のいずれか（プロジェクトに合わせて選択）：

### ファイル命名規則

```
{テスト対象のファイル名(拡張子なし)}.{カテゴリ}.test.ts|tsx
```

- テスト対象のファイル名をそのまま使う（例: `user-login.ts` → `user-login.validation.test.ts`）
- カテゴリでグループを分割する（describe の代わり）
- カテゴリ例: `validation`, `error`, `boundary`, `integration` など

### コロケーション（テスト対象と同一フォルダ）

```
src/
├── user-login.ts
├── user-login.validation.test.ts
├── user-login.error.test.ts
├── user-registration.ts
├── user-registration.test.ts
└── helpers/
    ├── user-utils.ts
    └── user-utils.test.ts
```

### __tests__ ディレクトリ

```
__tests__/
├── user-login.validation.test.ts
├── user-login.error.test.ts
├── user-registration.test.ts
└── helpers/
    └── user-test-utils.ts
```

## 適正化指針

- **重複テストの排除**: 同じ振る舞いを複数方法でテストしない
- **実装詳細のテスト禁止**: privateメソッドや内部状態の直接テストは行わない
- **公開インターフェースのみテスト**: 外部から呼び出される関数に集中
- **ファイル分割**: 100-150行を超えたら分割


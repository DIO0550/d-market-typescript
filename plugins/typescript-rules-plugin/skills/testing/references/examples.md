# テストコード例

## フラット構造の例

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

## 条件分岐の禁止例

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

## パラメータ化テストの例

```typescript
test.each([
  [1, 2, 3],
  [5, 5, 10],
  [-1, 1, 0],
])("add(%i, %i) は %i を返す", (a, b, expected) => {
  expect(add(a, b)).toBe(expected);
});
```

## ディレクトリ構成

テストファイルの配置は以下のいずれか（プロジェクトに合わせて選択）。

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

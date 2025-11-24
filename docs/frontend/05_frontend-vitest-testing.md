# Frontend での Vitest を用いたテスト方法について

このテンプレートでは、フロントエンドのテストランナーとして **Vitest** を標準で導入しています。
基本的な実行コマンドや、テストファイルの置き方、サンプルテストの書き方について説明します。

---

## 前提

* フロントエンドのディレクトリ: `frontend/`
* パッケージマネージャ: `pnpm`
* テストランナー: `Vitest`
* 主なコマンドは `package.json` の `scripts` に定義されています。

```jsonc
"scripts": {
  "dev": "vite",
  "build": "tsc -b && vite build",
  "preview": "vite preview",

  "lint": "eslint .",
  "lint:fix": "eslint . --fix",

  "test": "vitest run",
  "test:watch": "vitest",
  "test:coverage": "vitest run --coverage",
  "test:ui": "vitest --ui"
}
```

---

## テストの基本コマンド

フロントエンドのテストは、`frontend/` ディレクトリで `pnpm` 経由で実行します。

```bash
cd frontend

# 1 回だけテストを実行（CI でもこのコマンドを使用）
pnpm test

# ファイル変更を監視しながらテストを実行
pnpm test:watch

# カバレッジレポートを生成
pnpm test:coverage

# ブラウザ UI でテスト実行状況を確認
pnpm test:ui
```

* 日常開発では `pnpm test:watch` を使うと、ファイル保存のたびに素早くテストを再実行できます。
* CI（GitHub Actions）では `pnpm test` を利用して、1 回だけテストを実行しています。

---

## テストファイルの配置ルール

Vitest は、デフォルトで以下のようなファイルをテストとして検出します。

* `**/*.test.ts`
* `**/*.test.tsx`
* `**/*.spec.ts`
* `**/*.spec.tsx`

このテンプレートでは、例として以下のような構成を推奨します。

```text
frontend/
  src/
    lib/
      math.ts
    __tests__/
      math.test.ts
```

* `src/__tests__/` 配下にまとめる形でも、
* 各コンポーネントと同じ階層に `xxx.test.tsx` を置く形でも、
  プロジェクト方針に合わせて好きなスタイルで構いません。

---

## 最小のサンプルテスト

### 1. テスト対象の関数を用意する

例として、単純な `add` 関数を作成します。

```ts
// frontend/src/lib/math.ts
export function add(a: number, b: number): number {
  return a + b;
}
```

### 2. テストファイルを作成する

```ts
// frontend/src/__tests__/math.test.ts
import { describe, it, expect } from 'vitest';
import { add } from '../lib/math';

describe('add', () => {
  it('adds two numbers', () => {
    expect(add(1, 2)).toBe(3);
  });
});
```

これで、以下のコマンドでテストが実行されることを確認できます。

```bash
cd frontend
pnpm test
```

---

## React コンポーネントのテストについて（補足）

このテンプレートでは、まずは **ロジック（関数・フックなど）のテスト** を書ける状態を用意しています。React コンポーネントのテストも行いたい場合は、次のようなライブラリを追加導入することを検討してください。

* `@testing-library/react`
* `@testing-library/jest-dom`

これらを導入した上で、`vitest.config` または `vite.config` の `test` セクションに `environment: 'jsdom'` を設定することで、ブラウザ環境を模したテストが書けるようになります。

（React コンポーネントテストの具体例は、別途必要になった段階で追加してください。）

---

## CI（GitHub Actions）との連携

GitHub Actions では、`frontend-ci.yaml` から以下のように `pnpm test` を呼び出しています。

```yaml
- name: Run Vitest
  run: pnpm test
```

* CI では watch モードは不要なため、`vitest run` を実行する `pnpm test` を利用しています。
* ローカルと CI で同じ `scripts` を使うことで、挙動の差異を減らす狙いがあります。

---

## まとめ

* テストランナーは **Vitest** を標準採用しています。
* 基本コマンド：

  * `pnpm test`（1 回実行）
  * `pnpm test:watch`（開発用の監視モード）
  * `pnpm test:coverage`（カバレッジ）
* テストファイルは `*.test.ts(x)` / `*.spec.ts(x)` として作成します。
* まずは関数レベルのテストから気軽に書き始め、必要に応じて React コンポーネントのテスト環境を拡張していくことを想定しています。

## 公式ドキュメント
[vitest]
https://vitest.dev/guide/
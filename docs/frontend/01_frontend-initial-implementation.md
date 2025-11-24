# Frontend の初期導入パッケージについて

このテンプレートでは、フロントエンドに以下のパッケージを初期導入しています。  
必要に応じて、他のパッケージ／ライブラリに置き換えたり、追加して利用してください。

## 初期導入パッケージ／ライブラリ（主要なもの）

- `vite`  
  - 開発サーバー／ビルドツール
- `react` / `react-dom`  
  - UI ライブラリ本体
- `typescript`  
  - TypeScript サポート
- `eslint`  
  - コード品質チェック（`pnpm lint` で実行）
- `vitest`  
  - テストランナー（`pnpm test` で実行）

※ 上記以外にも、開発体験向上のためのパッケージがいくつか導入されています。

## パッケージを変更・削除したい場合

不要なパッケージを削除したい場合は、以下のように `pnpm remove` を利用してください。

```bash
cd frontend

# dependencies からパッケージを削除（例: react-router-dom を削除）
pnpm remove react-router-dom

# devDependencies からパッケージを削除（例: vitest を削除）
pnpm remove -D vitest
```

※ 詳細なオプションや使い方は pnpm の公式ドキュメントを参照してください。

[pnpm 公式ドキュメント（remove）]
https://pnpm.io/ja/cli/remove
# Laravel+React/TypeScript/Vite利用準備
---
## Laravel のバージョンを変更したい場合

このテンプレートは、デフォルトでは特定バージョンの Laravel を backend 配下に作成しています。
別のバージョンで Laravel プロジェクトを作り直したい場合は、以下の手順を実行してください。

1. VS Code でこのリポジトリを開く

2. コマンドパレットから **“Dev Containers: Reopen in Container”** を実行し、コンテナ内に入る

3. 既存の `backend` ディレクトリを削除する

   * 例: `rm -rf backend`

4. コンテナ内から、任意のバージョンを指定して Laravel プロジェクトを再作成する

   ```bash
   composer create-project --prefer-dist laravel/laravel:"<version>" backend
   ```

   例: Laravel 12 系で作成したい場合

   ```bash
   composer create-project --prefer-dist laravel/laravel:"^12.0" backend
   ```

5. 作成が完了したら、必要に応じて `.env` の設定を調整し、`php artisan key:generate` を実行してください
   （初回は `post_create.sh` でも自動実行されますが、作り直した場合は手動実行を推奨します）。

---

## Vite テンプレートを変更したい場合

frontend 配下の Vite プロジェクトを、別のテンプレート（React 以外や別バリアント）に作り直したい場合は、以下の手順を実行してください。

1. VS Code でこのリポジトリを開く

2. コマンドパレットから **“Dev Containers: Reopen in Container”** を実行し、コンテナ内に入る

3. 既存の `frontend` ディレクトリを削除する

   * 例: `rm -rf frontend`

4. コンテナ内から、任意の Vite テンプレートでプロジェクトを作成する

   ```bash
   pnpm create vite@latest frontend --template <template-name>
   ```

   例: React + TypeScript のテンプレートにしたい場合

   ```bash
   pnpm create vite@latest frontend --template react-ts
   ```

5. 作成が完了したら、`cd frontend` して `pnpm install` を実行し、依存関係をインストールします。

6. 必要に応じて、backend 側との連携部分（API の URL など）を調整してください。

# Laravel + React/TypeScript/Vite DevContainer Template

VS Code Dev Containers を使って
**Laravel（backend） + React/TypeScript/Vite（frontend）** の開発環境をすぐに立ち上げられるテンプレートリポジトリです。

* Docker + Docker Compose + Dev Containers で開発環境を統一
* `post_create.sh` により、コンテナ初回起動時に依存関係のインストールなどを自動実行
* Laravel / Vite / React Router / Zod / Jotai / Vitest / Tailwind / Storybook などを前提にした拡張をしやすい構成
* backend / frontend とも、本番運用を意識して **ランタイム用コンテナと開発用 workspace コンテナを分離**

---

## 前提・対象読者

* VS Code と Dev Containers 拡張機能を使ってローカルに開発環境を作りたい人
* Laravel + React/TypeScript/Vite の組み合わせを何度も使い回したい人（テンプレ化したい人）
* チーム開発で「clone → Reopen in Container ですぐ動かしたい」人

### 動作前提

* Docker / Docker Desktop がインストール済み
* Visual Studio Code
* VS Code 拡張機能

  * Dev Containers (ms-vscode-remote.remote-containers)

---

## 技術スタック

### 言語・ツール

* PHP 8.4（CLI / FPM）
* Laravel 12（backend）
* Node.js 24（Dev Containers Features によるインストール）
* pnpm（Node 24 + corepack / features 由来）
* React + TypeScript + Vite（frontend）

### パッケージ管理

* **Composer** : PHP / Laravel 用
* **pnpm** : Node.js / frontend 用

---

## コンテナ構成（Docker Compose）

### compose.base.yaml

本番・CI と共通で利用可能な **ランタイム用サービス** を定義しています。

* **php**

  * PHP-FPM ランタイムコンテナ
  * PHP 拡張（pdo, pdo_pgsql, xdebug など）を Dockerfile で管理
* **nginx**

  * Web サーバコンテナ
  * `php` コンテナにリバースプロキシ
* **postgres**

  * PostgreSQL 17 データベースコンテナ
  * 設定ファイル（`postgresql.conf` / `pg_hba.conf` / `pg_ident.conf`）をボリュームマウント

### compose.dev.yaml

開発専用の設定を定義しています。

* **workspace**

  * VS Code が attach する開発用コンテナ
  * PHP CLI / Composer / Node / pnpm など開発ツールを利用
* **php / nginx / postgres**

  * `compose.base.yaml` のサービスに対して

    * ポート公開（`80:80`, `5432:5432`）
    * Xdebug 用環境変数（開発時のみ）
      などの **開発専用設定を上書き・追加**

Dev Containers からはこの 2 枚をマージして利用します：

```jsonc
"dockerComposeFile": [
  "../compose.base.yaml",
  "../compose.dev.yaml"
],
"service": "workspace",
"workspaceFolder": "/workspace"
```

---

## Dev Container 構成

### workspace コンテナ

* ベースイメージ: `php:8.4-cli`
* インストール済み:

  * PHP CLI + `pdo`, `pdo_pgsql`
  * Composer（`composer:2` イメージからコピー）
  * Node.js 24 / pnpm / 各種 CLI（Dev Containers Features）
* 役割:

  * VS Code の作業コンテナ
  * `composer install`, `php artisan`, `pnpm install`, `pnpm dev` などのコマンドを実行

### php コンテナ

* ベースイメージ: `php:8.4-fpm`
* PHP 拡張:

  * `pdo`, `pdo_pgsql`
  * `xdebug`（開発用）
* 役割:

  * nginx からの PHP 実行（Laravel アプリケーションの実行）

### nginx コンテナ

* ベースイメージ: `nginx:stable`
* 設定:

  * `docker/nginx/conf.d` を `/etc/nginx/conf.d` としてマウント
* 役割:

  * `/var/www/html`（＝ backend）をドキュメントルートとして参照
  * `php` コンテナの PHP-FPM にリクエストを転送

### postgres コンテナ

* ベースイメージ: `postgres:17`
* 設定:

  * `docker/db/*.conf` を設定ファイルとしてマウント
* 役割:

  * Laravel backend 用の PostgreSQL データベース

---

## Dev Containers Features

`devcontainer.json` で以下の Features を利用しています（一例）:

* `ghcr.io/devcontainers/features/node:1`

  * Node.js 24 / npm / pnpm などをインストール
* `ghcr.io/devcontainers/features/common-utils:2`

  * curl / git / zsh / Oh My Zsh などの便利 CLI ツールをインストール

Node / pnpm などのバージョン管理は Dev Containers Features に任せ、
PHP / PHP拡張 / ランタイム構成は Dockerfile で管理する方針です。

---

## ディレクトリ構成

```text
.
├── .devcontainer           # devcontainer の設定（devcontainer.json, post_create 用設定など）
├── .pnpm-store             # pnpm のストア（必要に応じて .gitignore 推奨）
├── .vscode                 # VS Code の設定（推奨拡張機能や tasks など）
├── backend                 # Laravel アプリケーション
├── frontend                # React/TypeScript/Vite アプリケーション
├── compose.base.yaml       # ランタイム共通（php/nginx/postgres）の Docker Compose 設定
├── compose.dev.yaml        # 開発用 workspace + 開発専用設定の Docker Compose 設定
├── docker                  # 各種コンテナ向け Dockerfile / 設定ファイル群
├── docs                    # ドキュメント類（任意）
├── scripts                 # 各種スクリプト（post_create.sh など）
└── README.md
```

---

## クイックスタート（このテンプレートリポジトリの利用方法）

1. **テンプレートを自分のリポジトリとして作成 / clone**
  1. github [my-laravel-react-template](https://github.com/Yamazaki-Katsunori/my-laravel-react-template) へアクセス
  2. 「use this template」> 「Create a new Repository」項目をクリック
  3. 「General」で 「Owner」を自分に指定し、「Repository name」に任意のリポジトリ名を記入
  4. (任意) 「Description」にリポジトリの説明を記載
  5. (任意)「Configuration」項目で Public or Private のリポジトリとするか選択
  6. 「Create repository」ボタンをクリック

   ```bash
   git clone <your-repo-url>
   cd <your-repo-dir>
   ```

2. **VS Code でフォルダを開く**

3. コマンドパレットから
   **「Dev Containers: Reopen in Container」** を実行

4. コンテナのビルド & 起動完了後、`post_create.sh` が自動実行されます

   * backend:

     * `composer install`
     * `.env` が無い場合は `.env.example` からコピー & `php artisan key:generate`
   * frontend:

     * `pnpm install --frozen-lockfile`

5. ブラウザからアクセス

   * Laravel（nginx 経由）: `http://localhost`（ルーティング設定に依存）
   * Vite dev サーバ（必要に応じて）

     * workspace 内で `cd frontend && pnpm dev`
     * `http://localhost:5173` にアクセス

---

## git clone 後の利用準備について（詳細）

詳細なセットアップや拡張方法は、以下の Docs を参照してください。

1. [Laravel+React/TypeScript/Vite 利用準備](/docs/setup-devcontainers/01_setup.md)
2. [react-router/zod/jotai を利用する場合](/docs/setup-devcontainers/02_setup-react-router-zod-jotai.md)
3. [vitest を利用する場合](/docs/setup-devcontainers/03_setup-vitest.md)
4. [Tailwind CSS v4 + Vite を利用する場合](/docs/setup-devcontainers/04_setup-tailwind-css-vite.md)
5. [Storybook を利用する場合](/docs/setup-devcontainers/05_setup-storybook.md)

## Frontend（React/TypeScript/Vite）について

このテンプレートでは、frontend 配下のコード構成として以下の考え方を採用しています。

- package by feature
  - ページ種別や技術（components/hooks/utils）ではなく、「機能・関心ごと」にコードをまとめる方針です。
- BCD Design（Base / Case / Domain + Shared）
  - コンポーネントを「どのくらいドメインに依存しているか」という観点で分類します。

詳細な背景や設計意図は、 以下のドキュメントにまとめましたので、ご参照ください。

1. [Frontendの初期導入されているパッケージについて](/docs/frontend/01_frontend-initial-implementation.md)
2. [Frontendディレクトリ構成について](/docs/frontend/02_frontend-directory.md)
3. [Frontendディレクトリの基本ルールについて](/docs/frontend/03_frontend-rule.md)
4. [Frontendディレクトリルールの具体例について](/docs/frontend/04_frontend-specific-examples.md)
5. [FrontendでのVitestを用いたテスト方法について](/docs/frontend/05_frontend-vitest-testing.md)

## Backend(PHP/Laravel)について

1. [Backendの初期導入されているパッケージについて](/docs/frontend/01_frontend-directory.md)
2. [Peck/Rectorの導入について](/docs/backend/02_backend-peck-rector-install.md)
3. [Backendでのテスト方法について](/docs/backend/03_backend-testing.md)
#!/usr/bin/env bash
set -euo pipefail

BACKEND_DIR="/workspace/backend"
FRONTEND_DIR="/workspace/frontend"

echo ">>> post_create.sh start run"

###
# [backend] Laravel セットアップ
###
if [ -d "$BACKEND_DIR" ] && [ -f "$BACKEND_DIR/composer.json" ]; then
  echo "[backend] Laravel セットアップ開始"
  cd "$BACKEND_DIR"

  # 依存インストール（vendor が無ければ）
  if [ ! -d "vendor" ]; then
    echo "[backend] vendor が無いため composer install 実行"
    composer install --no-interaction --prefer-dist
  else
    echo "[backend] vendor が存在するため composer install はスキップ"
  fi

  # ディレクトリが消えていても困らないように一応作っておく（idempotent）
  mkdir -p storage/framework storage/logs bootstrap/cache

  # .env がない & .env.example がある場合だけ作成＋key生成
  if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    echo "[backend] .env を .env.example からコピーして APP_KEY 生成"
    cp .env.example .env
    php artisan key:generate
  fi
else
  echo "[backend] Laravel セットアップ スキップ（ディレクトリ or composer.json 不在）"
fi

###
# [frontend] React/TypeScript/Vite セットアップ
###
if [ -d "$FRONTEND_DIR" ] && [ -f "$FRONTEND_DIR/package.json" ]; then
  echo "[frontend] React/TypeScript/Vite セットアップ開始"
  cd "$FRONTEND_DIR"

  # 依存インストール（node_modules が無ければ）
  if [ ! -d "node_modules" ]; then
    echo "[frontend] node_modules が無いため pnpm install --frozen-lockfile 実行"
    pnpm install --frozen-lockfile
  else
    echo "[frontend] node_modules が存在するため pnpm install はスキップ"
  fi
else
  echo "[frontend] React/TypeScript/Vite セットアップ スキップ（ディレクトリ or package.json 不在）"
fi

echo ">>> post_create.sh finished"

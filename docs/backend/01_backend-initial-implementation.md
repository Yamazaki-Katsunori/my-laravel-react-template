# Backend の初期導入パッケージについて

このテンプレートでは、バックエンドに以下のパッケージを初期導入しています。  
必要に応じて、他のパッケージ／ライブラリに置き換えたり、追加して利用してください。

## 初期導入パッケージ／ライブラリ（主要なもの）

- `phpstan/phpstan` / `nunomaduro/larastan`  
  - PHP / Laravel 向けの静的解析ツール
- `laravel/pint`  
  - コード整形ツール（Laravel 推奨のコードスタイル）
- `pestphp/pest` / `pestphp/pest-plugin-laravel`  
  - テストフレームワーク（PHPUnit をラップしたシンタックスシュガー）
- `phpunit/phpunit`（Laravel 標準バンドル）  
  - Laravel が標準で利用するテストフレームワーク

※ 上記以外にも、Laravel に標準で導入されているパッケージは、そのままの状態で利用可能です。

## パッケージを変更・削除したい場合

不要なパッケージを削除したい場合は、以下のように `composer remove` を利用してください。

```bash
cd backend

# 例: PHPStan を削除
composer remove phpstan/phpstan

# 例: Larastan を削除
composer remove nunomaduro/larastan

# 例: Pest 関連を削除
composer remove pestphp/pest pestphp/pest-plugin-laravel
```

※ Laravel 本体やフレームワークに強く依存しているパッケージ（例: laravel/framework, laravel/pint など）を削除する場合は、
影響範囲が大きいため、各プロジェクト方針に応じて慎重に判断してください。

※ 詳細なオプションや使い方は Composer の公式ドキュメントを参照してください。

[Composer 公式ドキュメント（remove）]
https://getcomposer.org/doc/03-cli.md#remove-rm-uninstall
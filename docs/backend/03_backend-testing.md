# Backend でのテスト方法について（Pest / PHPUnit）

このテンプレートでは、バックエンドのテストフレームワークとして **Pest v4** を標準で導入しています。
Laravel 標準の **PHPUnit** もあわせて利用可能です。

ここでは、基本的な実行コマンドやテストファイルの置き方、サンプルテストの書き方について説明します。

---

## 前提

* バックエンドのディレクトリ: `backend/`
* テストフレームワーク:

  * メイン: Pest (`pestphp/pest`, `pestphp/pest-plugin-laravel`)
  * ベース: PHPUnit (`phpunit/phpunit`)
* 主なコマンドは `backend/composer.json` の `scripts` に定義されています。

例：

```jsonc
"scripts": {
  // Lint 系
  "lint:php": "pint --test",
  "lint:php:fix": "pint",
  "lint:phpstan": "phpstan analyse",
  "lint": [
    "@composer lint:php",
    "@composer lint:phpstan"
  ],

  // テスト系（Pest を標準利用）
  "test": "pest",
  "test:coverage": "pest --coverage",

  // 必要に応じて PHPUnit を直接叩くためのスクリプト
  "test:phpunit": [
    "@php artisan config:clear --ansi",
    "@php artisan test"
  ]
}
```

※ 実際の `scripts` 定義はプロジェクトの最新状態を参照してください。

---

## Pest を使ったテストの基本コマンド

バックエンドのテストは、`backend/` ディレクトリで `composer` 経由で実行します。

```bash
cd backend

# Pest でテストを実行（標準）
composer test

# カバレッジレポートを生成
composer test:coverage
```

* このテンプレートでは `composer test` が Pest を呼び出す前提になっています。
* PHPUnit ベースのコマンドを使いたい場合は、`composer test:phpunit` を利用できます。

---

## PHPUnit を使ったテスト実行（任意）

Laravel 標準の PHPUnit を使ったテストも、引き続き利用可能です。

```bash
cd backend

# Laravel 標準の PHPUnit テストを実行
composer test:phpunit

# もしくは直接 artisan コマンドで実行
php artisan test
```

* Pest は PHPUnit の上に成り立っているため、既存の `tests/` 内の PHPUnit テストもそのまま動作します。
* 新規にテストを書く場合は、基本的には Pest スタイルでの記述を推奨します。

---

## テストファイルの配置ルール

Laravel + Pest の標準構成では、テストファイルは `tests/` ディレクトリに配置します。

```text
backend/
  tests/
    Feature/
      ExampleTest.php
    Unit/
      ExampleTest.php
    Pest.php
```

* `Pest.php` には、Pest 全体に共通するヘルパや設定を記述できます。
* ドメイン駆動設計（DDD）で進める場合は、以下のような構成にしてもよいでしょう。

```text
backend/
  tests/
    Unit/
      Domain/
        TouristGuide/
          GuideNameTest.php
    Feature/
      Http/
        Controllers/
          ExampleControllerTest.php
```

プロジェクトごとの命名規則やディレクトリ構成に合わせて整理してください。

---

## 最小のサンプルテスト（値オブジェクトなどの例）

### 1. テスト対象クラスの例（値オブジェクト）

例として、`GuideName` という名前の値オブジェクトを考えます。

```php
// backend/app/Domain/TouristGuide/GuideName.php

namespace App\Domain\TouristGuide;

class GuideName
{
    public function __construct(
        private string $value,
    ) {
        // 必要に応じてバリデーションなどを実装
    }

    public function value(): string
    {
        return $this->value;
    }

    public function __toString(): string
    {
        return $this->value;
    }
}
```

### 2. Pest でのテスト例

```php
// backend/tests/Unit/Domain/TouristGuide/GuideNameTest.php

use App\Domain\TouristGuide\GuideName;

it('creates a guide name', function () {
    $name = new GuideName('Yamada Taro');

    expect($name->value())->toBe('Yamada Taro')
        ->and((string) $name)->toBe('Yamada Taro');
});
```

この状態で、以下のコマンドでテストが実行されることを確認できます。

```bash
cd backend
composer test
```

---

## HTTP/API テスト（Feature テスト）の例

Pest + Laravel の組み合わせでは、HTTP レスポンスを簡潔にテストできます。

```php
// backend/tests/Feature/Http/ExampleApiTest.php

use Illuminate\Foundation\Testing\RefreshDatabase;
use function Pest\Laravel\getJson;

uses(RefreshDatabase::class);

it('returns 200 for the health check endpoint', function () {
    getJson('/api/health')
        ->assertOk()
        ->assertJson([
            'status' => 'ok',
        ]);
});
```

* `uses(RefreshDatabase::class);` を付けることで、テストごとに DB をリセットできます。
* `getJson()`, `postJson()` などのヘルパを利用して、API の挙動を確認できます。

---

## CI（GitHub Actions）との連携

GitHub Actions では、`backend-ci.yaml` から以下のようにテストを実行します。

```yaml
- name: Run PHP lint (Pint + PHPStan)
  run: composer lint

- name: Run tests (Pest)
  run: composer test
```

* CI では Pest を標準テストランナーとして利用しています。
* 必要に応じて、`composer test:phpunit` を用いたジョブを追加し、PHPUnit ベースのテストを別ジョブで実行することも可能です。

---

## まとめ

* バックエンドのテストランナーは **Pest v4** を標準採用しています。
* 基本コマンド：

  * `composer test`（Pest でテストを実行）
  * `composer test:coverage`（Pest + カバレッジ）
  * `composer test:phpunit`（必要に応じて PHPUnit ベースのテストを実行）
* テストファイルは `tests/Unit` / `tests/Feature` 配下に配置します。
* 値オブジェクトやドメインサービスなどのユニットテスト、HTTP/API の Feature テストを組み合わせて、段階的にカバレッジを広げていくことを想定しています。


## 公式ドキュメント
[Pest]
https://pestphp.com/docs/installation

[PHPUnit]
https://docs.phpunit.de/en/11.5/
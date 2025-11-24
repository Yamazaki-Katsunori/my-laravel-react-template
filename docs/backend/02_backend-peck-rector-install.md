# Peck / Rector の導入ガイド（任意）

このテンプレートでは、コード品質向上・リファクタリング支援ツールとして **Peck** / **Rector** の利用を推奨していますが、初期状態ではインストールしていません。

* 導入は **各プロジェクトの方針に応じて任意**
* CI に組み込みたい場合も、プロジェクト側で判断してください

ここでは、それぞれの概要と導入／アンインストール方法の例を紹介します。

---

## Peck について

### 概要

**Peck** は、コード中の「命名」「コメント」「文字列」などを解析し、**スペルミスや不自然な英語表現を検出する CLI ツール** です。

* 対象：クラス名・メソッド名・変数名・コメント・文字列など
* 利用シーンの例：

  * ユビキタス言語を英語で統一したい
  * ドメインモデルの命名やコメントの typo を早期に見つけたい
  * PR 前に「言葉の品質チェック」を自動化したい

日本語メインのプロジェクトでも利用できますが、**英語の命名・コメントが多いほど効果が高い** ツールです。

### 導入方法（例）

```bash
cd backend

# Peck を開発用依存としてインストール
composer require --dev rias/peck
```

`composer.json` にスクリプトを追加すると便利です。

```jsonc
"scripts": {
  "peck": "peck run app"
}
```

* 上記例では `app` ディレクトリ配下をチェックする想定です。
* 対象ディレクトリはプロジェクトに合わせて変更してください。

### 実行方法（例）

```bash
cd backend

# コードのスペルチェックを実行
composer peck
```

### アンインストール方法（例）

```bash
cd backend

# Peck の依存を削除
composer remove rias/peck
```

---

## Rector について

### 概要

**Rector** は、PHP コードの自動リファクタリング／自動アップグレードを行うツールです。

* 利用シーンの例：

  * PHP 8.x / Laravel のバージョンアップ対応
  * コーディングスタイルや API の利用方法を新しい書き方に統一したい
  * 大規模リファクタリングの作業量を減らしたい

Rector は **設定次第で大きくコードを書き換える** ため、

* まずは `--dry-run` で差分を確認する
* Git 管理下でのみ実行する

といった運用ルールを推奨します。

### 導入方法（例）

```bash
cd backend

# Rector 本体と Laravel 用セットを開発用依存としてインストール
composer require --dev rector/rector rector/rector-laravel
```

プロジェクトルート（`backend/`）に `rector.php` を作成します。以下はごくシンプルな例です。

```php
<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\LevelSetList;
use Rector\Set\ValueObject\SetList;

return static function (RectorConfig $rectorConfig): void {
    // 解析対象ディレクトリ
    $rectorConfig->paths([
        __DIR__ . '/app',
        __DIR__ . '/database',
    ]);

    // PHP バージョンのレベルセット（例: PHP 8.2）
    $rectorConfig->sets([
        LevelSetList::UP_TO_PHP_82,
        // Laravel 向けのセットを追加したい場合はここに追記
        // SetList::LARAVEL_130, など（利用バージョンに応じて変更）
    ]);
};
```

`composer.json` にスクリプトを追加すると便利です。

```jsonc
"scripts": {
  "rector": "rector process --dry-run"
}
```

### 実行方法（例）

```bash
cd backend

# 差分のみ確認（コードは書き換えない）
composer rector

# 実際に書き換えたい場合（必ず Git 管理下で実行してください）
rector process
```

### アンインストール方法（例）

```bash
cd backend

# Rector 関連の依存を削除
composer remove rector/rector rector/rector-laravel
```

---

## 導入時の注意点とおすすめ方針

* **Peck**

  * 小さな導入コストで「言葉の品質」を底上げできるツールです。
  * 英語ベースのドメインモデルを多用する場合は導入を検討してください。
  * CI に組み込む場合は、`composer peck` を GitHub Actions などから呼び出す構成を推奨します。

* **Rector**

  * 非常に強力ですが、その分 **設定と運用ルールが重要** なツールです。
  * まずは開発者のローカル環境で `--dry-run` を試し、
    チーム合意が取れてから CI 導入を検討することをおすすめします。
  * バージョンアッププロジェクトや大規模リファクタリングで特に威力を発揮します。

どちらのツールも、このテンプレートでは **「任意で導入する拡張ツール」** として扱っています。プロジェクトの規模・メンバー構成・運用ルールに応じて、必要に応じて導入をご検討ください。

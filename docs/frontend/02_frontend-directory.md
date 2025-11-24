# Frontend ディレクトリ構成

frontend/src はおおよそ次のような構成を想定しています。

## Frontend ディレクトリ構成 Tree
```tree
frontend/
  src/
    app/         # アプリ全体のエントリ・ルーティング・レイアウトなど
    base/        # BCD の Base: 文脈を持たない UI（Button, TextField など）
    case/        # BCD の Case: 特定の状況で使われる UI
    components/  # 接続確認用などのサンプルコンポーネント置き場
    domain/      # ドメイン（機能）ごとの UI + ロジック（package by feature の中心）
    shared/      # BCD の Common に相当: 複数ドメインから共有される関心
    lib/         # 汎用的なユーティリティ・hooks（OSS に出しても違和感ないレベル）
    store/       # グローバルな状態管理（Jotai など）
    styles/      # グローバルスタイルや Tailwind 設定など
    types/       # 共通の型定義（API レスポンス型など）
    App.tsx
    main.tsx
    App.css
    index.css
```

各ディレクトリの大まかな役割は以下の通りです。

## 各ディレクトリの役割
- app/
  - ルーティングや全体レイアウトなど、「アプリケーションの骨組み」を置く場所です。

- base/
  - Button や TextField など、特定のビジネス文脈を持たない UI コンポーネントを置きます。

- case/
  - 検索フォーム、確認ダイアログなど、特定の状況（ケース）に紐づく UIを置きます。

- domain/
  - ユーザ管理、ガイド登録など、機能・ドメインごとの UI やロジックをまとめる場所です。
  - 新しい機能を追加するときは、まずここにディレクトリを切ることを推奨します。

- shared/
  - Category や Tag のように、複数のドメインから共有されるドメイン関心を置く場所です。

- components/
  - このテンプレートでは、Laravel 側との接続確認用コンポーネント （例: /api/health を叩く ApiHealthCheck）を配置しています。
  - 実際のアプリ開発では、機能が固まってきたタイミングで domain/ や shared/ へ移動して構いません。

- lib/
  - axios クライアントや共通 hooks など、特定のドメインに依存しない汎用ロジックをまとめます。

- store/
  - Jotai などのグローバル state を扱う atom / hook を置く場所です。

- styles/
  - グローバル CSS や Tailwind 関連の設定をまとめます。

- types/
  - 共通で利用する型定義（API レスポンス型など）を置きます。
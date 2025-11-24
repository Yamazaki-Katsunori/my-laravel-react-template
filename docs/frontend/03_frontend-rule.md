# 基本ルール（推奨）

このテンプレートでは、以下のようなルールでフロントエンドのコードを配置することを推奨します。

1. 新しい機能はまず `domain/` にディレクトリを切る
   ```
   例: タスク管理機能 → src/domain/taskManagement/
   
   その配下に components/, hooks/, api/, types/ などを切っていきます。
   ```

2. 複数のドメインで使い回したくなった UI は `base/` / `case/` / `shared/` に切り出す
   ```
   汎用 UI（Button, Modal など） → base/
   
   特定の状況に特化した UI（検索ダイアログ、削除確認ダイアログなど）    → case/
   
   複数ドメインにまたがるドメイン関心（Tag, Category, Status など） → shared/
   ```

3. Laravel API とのやりとりは、基本 /api 配下で行う
   ```
   vite.config.ts で /api を nginx(Laravel) にプロキシする設定を入れています。
   
   API クライアントは src/lib/apiClient.ts のような形で 1 箇所にまとめ、 domain/** や shared/** から利用することを想定しています。
   ```

4. components/ は「サンプル置き場」として軽く使う
   ```
   このテンプレートでは、components/ApiHealthCheck.tsx をLaravel API /api/health の接続確認サンプルとして用意しています。
   
   プロジェクトが育ってきたら、このようなサンプルは 適切な domain/ または shared/ 配下へ移動して構いません。
   ```
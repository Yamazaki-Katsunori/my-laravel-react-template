# valkey の確認方法について

valkey の動作確認方法を以下に記載します。

## valkeyへの疎通動作確認方法
1. ターミナルを開き `cd backend` を実行
2. `php artisan tinker` を実行
3. 以下の内容を実施
   ```
   > use Illuminate\Support\Facades\Redis;

   > Redis::set('valkey_test', 'ok');
     => true 
   > Redis::get('valkey_test');
     => "ok"
   ```
4. 3の実施内容の通り、`Redis::set('valkey_test', 'ok')`の結果が`true`かつ `Redis::get('valkey_test')`の結果が `"ok"`であることを確認
5. ローカルPC上のターミナルからvalkeyコンテナに対し、以下のコマンドを実行してもkeyの確認が可能
   ```
   docker compose -f compose.base.yaml -f compose.dev.yaml exec valkey valkey-cli keys '*'
   ```
# Mailpit の確認方法

Mailpitへの疎通確認方法は以下の通りとなります。

Mailpit URL: http://localhost:8025/

## 疎通確認方法
1. ターミナルを開き `cd backend` を実行
2. `php artisan tinker` を実行
3. tinker が起動したら `Mail::raw('test', fn($m) => $m->to('test@example.com'))` を実行
4. `http://localhost:8025/` へアクセス
5. Mailpit の inbox にメールが受信されていることを確認。


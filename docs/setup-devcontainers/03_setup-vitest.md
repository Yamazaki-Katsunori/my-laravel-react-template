# vitest を利用する場合
`vitest`を導入したい場合、以下のコマンドを実施
※バージョン指定は適宜変更してください。
```
cd frontend

pnpm add -D \
  vitest@^4.0.10 \
  @vitest/ui \
  jsdom \
  @testing-library/react \
  @testing-library/user-event \
  @testing-library/jest-dom

pnpm install
```
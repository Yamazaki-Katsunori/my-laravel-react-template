# Frontend ディレクトリルールの具体例

このドキュメントでは、`frontend/src` の構成ルールを実際に適用したときの例をまとめます。

* 「新しい機能を 1 つ生やしたとき」
* 「汎用 UI コンポーネントを切り出したとき」

などの **Before / After や手順を残しておく場所** として利用してください。

---

## 例1: タスク管理機能を追加する場合

### 目的

* フロントエンドに「タスク管理」機能を追加する。
* Laravel 側には `/api/tasks` 系の API がある前提。
* package by feature / BCD の方針に沿って、`domain/` 配下にまとめて置きたい。

### 最終的なディレクトリ構成（After）

```text
src/
  domain/
    taskManagement/
      components/
        TaskListPage.tsx
        TaskForm.tsx
      hooks/
        useTaskList.ts
        useTaskForm.ts
      api/
        taskApi.ts
      types/
        task.ts
```

各ファイルの役割は以下の通りです。

* **`TaskListPage.tsx`**

  * タスク一覧画面コンポーネント（ルーティングの単位）。
  * 例: `/tasks` にマッピングされるページを想定。

* **`TaskForm.tsx`**

  * タスクの作成・編集フォーム UI。
  * `base/` や `case/` 以下の Button / Dialog などのコンポーネントを組み合わせて構成する。

* **`useTaskList.ts` / `useTaskForm.ts`**

  * 一覧取得やフォーム状態・バリデーションなどのロジックを担当するカスタムフック。
  * UI とロジックを分離しておくことで、テストや再利用がしやすくなる。

* **`taskApi.ts`**

  * Laravel 側の `/api/tasks/...` と通信する API クライアント。
  * 例:

    * `GET /api/tasks` → タスク一覧取得
    * `POST /api/tasks` → タスク作成
    * `PUT /api/tasks/:id` → タスク更新
    * `DELETE /api/tasks/:id` → タスク削除

* **`task.ts`**

  * タスクの型定義。
  * 例:

    * `Task`
    * `TaskStatus`（`"todo" | "in_progress" | "done"` など）

### 実装ステップ例

1. **ディレクトリを切る**

   ```bash
   mkdir -p src/domain/taskManagement/{components,hooks,api,types}
   ```

2. **型定義を作る（`types/task.ts`）**

   ```ts
   // src/domain/taskManagement/types/task.ts
   export type TaskStatus = 'todo' | 'in_progress' | 'done'

   export type Task = {
     id: number
     title: string
     description?: string
     status: TaskStatus
     createdAt: string
     updatedAt: string
   }
   ```

3. **API クライアントを作る（`api/taskApi.ts`）**

   ```ts
   // src/domain/taskManagement/api/taskApi.ts
   import { Task } from '../types/task'

   const baseUrl = '/api/tasks'

   export const fetchTasks = async (): Promise<Task[]> => {
     const res = await fetch(baseUrl)
     if (!res.ok) throw new Error(`Failed to fetch tasks: ${res.status}`)
     return res.json()
   }

   // 必要に応じて create/update/delete も追加
   ```

4. **ロジック用フックを追加（`hooks/useTaskList.ts`）**

   ```ts
   // src/domain/taskManagement/hooks/useTaskList.ts
   import { useEffect, useState } from 'react'
   import { fetchTasks } from '../api/taskApi'
   import type { Task } from '../types/task'

   export const useTaskList = () => {
     const [tasks, setTasks] = useState<Task[]>([])
     const [loading, setLoading] = useState(false)
     const [error, setError] = useState<string | null>(null)

     useEffect(() => {
       const load = async () => {
         setLoading(true)
         setError(null)
         try {
           const data = await fetchTasks()
           setTasks(data)
         } catch (e) {
           setError((e as Error).message)
         } finally {
           setLoading(false)
         }
       }
       load()
     }, [])

     return { tasks, loading, error }
   }
   ```

5. **画面コンポーネントを作る（`components/TaskListPage.tsx`）**

   ```tsx
   // src/domain/taskManagement/components/TaskListPage.tsx
   import { useTaskList } from '../hooks/useTaskList'

   export const TaskListPage = () => {
     const { tasks, loading, error } = useTaskList()

     if (loading) return <div>Loading tasks...</div>
     if (error) return <div style={{ color: 'red' }}>Error: {error}</div>

     return (
       <div>
         <h1>Tasks</h1>
         <ul>
           {tasks.map((task) => (
             <li key={task.id}>
               [{task.status}] {task.title}
             </li>
           ))}
         </ul>
       </div>
     )
   }
   ```

6. **ルーティングに組み込む**

   * 例: `src/app/routes.tsx` や `App.tsx` から `TaskListPage` を参照する。

---

## 例2: 汎用 UI コンポーネントを追加する場合

### 目的

* どの画面からでも利用できる汎用的な Button を作成し、`base/` 配下に配置する。
* 特定の機能（タスク管理など）に依存しない UI として定義する。

### ディレクトリ構成

```text
src/
  base/
    Button/
      Button.tsx
      index.ts
```

### 実装例

```tsx
// src/base/Button/Button.tsx
import type { ButtonHTMLAttributes, ReactNode } from 'react'

type Props = {
  children: ReactNode
} & ButtonHTMLAttributes<HTMLButtonElement>

export const Button = ({ children, ...props }: Props) => {
  return (
    <button {...props}>
      {children}
    </button>
  )
}
```

```ts
// src/base/Button/index.ts
export * from './Button'
```

### 利用イメージ

```tsx
// 例: 任意のドメインコンポーネントから利用
import { Button } from '@/base/Button'

export const TaskListHeader = () => {
  return (
    <div>
      <h2>Tasks</h2>
      <Button onClick={() => console.log('create task')}>
        新規タスク作成
      </Button>
    </div>
  )
}
```

* ドメインに依存しない、どの画面からでも使えるような UI は `base/` へ配置します。
* ドメイン固有のラベルや挙動を持つ Button（例: 「タスクを削除する」専用ボタン）は、

  * `domain/taskManagement` 配下のコンポーネントとして定義し、
  * `base/Button` を組み合わせて実装するのがおすすめです。

---

## 新しい具体例を追加するときのフォーマット（テンプレ）

このファイルに例を追加するときは、次のようなフォーマットで追記すると整理しやすくなります。

````md
## 例X: （例のタイトル）

### 目的

- 何をしたいのか
- なぜこのディレクトリ構成／ルールを適用するのか

### Before（任意）

```text
# 変更前のツリーや状態
````

### After

```text
# 変更後のツリー
```

### 実装ステップ（任意）

1. やったこと1
2. やったこと2
3. ...

### 補足・注意点（任意）

* 詰まりやすかったポイント
* 今後の改善候補

```

このフォーマットに従って、実際の開発で出てきたパターンを少しずつ追加していくことで、  
自分やチームの「フロントエンド構成のナレッジベース」として育てていくことができます。

```

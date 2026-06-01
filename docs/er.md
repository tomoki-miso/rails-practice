```mermaid

erDiagram
  users ||--o{ organization_members : "ユーザーは0以上の組織に参加する"
  organizations ||--o{ organization_members : "組織は0以上のメンバーを持つ"

  organizations ||--o{ projects : "組織は0以上のプロジェクトを持つ"
  projects ||--o{ tasks : "プロジェクトは0以上のタスクを持つ"

  users ||--o{ tasks : "ユーザーは0以上のタスクを作成する : creator"
  users ||--o{ tasks : "ユーザーは0以上のタスクを担当する : asigneee"

  users {
    string id PK
    string name "ユーザー名"
    string avatar "ユーザーアイコン"
    string email "メールアドレス"
  }

  organizations {
    string id PK
    string name "組織名"
  }

  organization_members {
    string id PK
    string organization_id FK
    string user_id FK
    string role "ロール/権限"
  }

  projects {
    string id PK
    string organization_id FK
    string name "プロジェクト名"
    string description "プロジェクト説明"
  }

  tasks {
    string id PK
    string project_id FK
    string creator_id FK
    string assignee_id FK "nullable"
    string title "タスクタイトル"
    string description "説明"
    timestamp deadline "期日"
  }
  ```

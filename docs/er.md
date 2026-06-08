```mermaid

erDiagram
  users ||--o{ group_members : "ユーザーは0以上のグループに参加する"
  groups ||--o{ group_members : "グループは0以上のメンバーを持つ"

  groups ||--o{ rounds : "輪読会は0以上の回を持つ"
  groups ||--o{ comments : "輪読会のPDFは0以上のコメントを持つ"
  comments ||--o{ comments : "コメントは0以上の返信コメントを持つ(1段のみ)"

  users ||--o{ comments : "ユーザーは0以上のコメントを作成する"

  rounds ||--o{ preparation_completions : "回は0以上の予習完了を持つ"
  users ||--o{ preparation_completions : "ユーザーは0以上の予習完了を持つ"

  users {
    int id PK
    string name "ユーザー名(表示名)"
    string avatar "ユーザーアイコン"
    string email UK "メールアドレス"
    string password_digest "パスワードハッシュ"
  }

  groups {
    int id PK
    string title "タイトル"
    string description "説明文"
    string file_path "PDFファイルパス"
    int byte_size "PDFファイルサイズ"
  }

  group_members {
    int id PK
    int group_id FK "UNIQUE(group_id, user_id)"
    int user_id FK
    int role "0:主催者 1:メンバー"
  }

  rounds {
    int id PK
    int group_id FK
    int number "回番号"
    datetime held_on "開催日(任意)"
    int start_page "開始ページ"
    int end_page "終了ページ"
  }

  preparation_completions {
    int id PK
    int round_id FK "UNIQUE(round_id, user_id)"
    int user_id FK
    datetime completed_at "予習完了日時"
  }

  comments {
    int id PK
    int group_id FK
    int user_id FK
    int reply_comment_id FK "親コメントID(返信時のみ・1段ネスト制限はアプリ層で担保)"
    int page "ページ"
    int kind "0:問い 1:気付き 2:感想 3:雑学 4:その他"
    string content "内容"
  }
  ```

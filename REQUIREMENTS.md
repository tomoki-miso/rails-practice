# Rails 学習用アプリ 要件定義

## Context

「チームタスク管理ツール」を題材に、Rails 7 標準スタック (Slim + Hotwire = Turbo + Stimulus + importmap-rails) だけで完結させる構成で学ぶ。**React は採用しない**。フロント側に別エコシステム (npm パッケージ管理、ビルドツール、SPA フレームワーク) を持ち込まないので、Rails 自体の理解に時間を集中投下できる。実務でも「The One Person Framework」「Rails で全部済ませる」哲学を取る現場 (37signals 系、スタートアップ初期) があり、その流派を体験できる。

- **学習者前提**: Rails を多少経験している中級入門レベル。JavaScript は最小限の知識でよい
- **学習期間目安**: 1ヶ月 (React 学習がない分、Rails / Hotwire / SQL / テストに時間を割ける)
- **アーキテクチャ**: Rails 7 monolith + Slim + Hotwire (Turbo + Stimulus) + importmap-rails + Bootstrap 5

> 構成検討時に比較した代替案 (Rails API + React SPA / Slim + 部分 React) は `docs/alternatives/` に保管。

---

## 1. プロダクト概要

### 1.1 プロダクト像
チーム単位でプロジェクトを切り、タスクを担当・進行管理する SaaS 風アプリ。

### 1.2 想定ユーザーストーリー
- ユーザーはサインアップしてメール確認を経てログインする
- 自分のチームを作るか、招待メールでチームに参加する
- チーム内にプロジェクトを作成し、タスクを切り、メンバーにアサインする
- タスクには担当・期限・優先度・ステータス・コメントが付く
- 担当アサイン時に通知メールが届く
- タスク一覧は担当・ステータス・期限・フリーワードで絞り込める

### 1.3 ロール
- **Owner**: チームの全権
- **Admin**: メンバー招待・プロジェクト管理
- **Member**: タスク操作のみ

---

## 2. アーキテクチャ

```
                       ┌──────────────────────────────────────┐
                       │  Rails 7 (monolith)                  │
                       │                                      │
   Browser ──HTTP──▶  │  ┌─ Routes ─ Controllers ─ Views ──┐ │
                       │  │  - Slim テンプレート           │ │
                       │  │  - turbo_frame_tag             │ │
                       │  │  - turbo_stream                │ │
                       │  │  - data-controller="..."       │ │
                       │  │     ← Stimulus controllers     │ │
                       │  └─────────────────────────────────┘ │
                       │                                      │
                       │  app/javascript/controllers/         │
                       │   └─ Stimulus (importmap で配信)     │
                       │                                      │
                       │  Devise (Cookie) / Pundit            │
                       │  Sidekiq Worker / ActionCable        │
                       └──────────┬──────────────┬────────────┘
                                  │              │
                            ┌─────▼──────┐  ┌────▼─────┐
                            │ PostgreSQL │  │  Redis    │
                            └────────────┘  └──────────┘
```

### 2.1 Hotwire の使い分け方針

| 役割 | 使う技術 | 例 |
|------|----------|-----|
| ページ遷移 | **Turbo Drive** | 全画面遷移を SPA 風に。デフォルトで有効 |
| ページ内の部分更新 | **Turbo Frame** | タスク一覧の絞り込み結果、コメント追加 |
| サーバ起点の部分更新 | **Turbo Stream** | 別ユーザーがタスクを更新した時の反映 (任意) |
| 軽い JS インタラクション | **Stimulus** | ドロップダウン、モーダル、確認ダイアログ |
| ドラッグ&ドロップ | **Stimulus + SortableJS** | タスクボードの並べ替え |

### 2.2 JS の扱い
- **importmap-rails** を採用してビルドレス構成にする (Rails 7 デフォルト)
- npm / Node はローカル開発に不要 (Stimulus 公式や SortableJS は CDN/JSPM 経由でインポート)
- **Bootstrap 5** を採用:
  - CSS: `dartsass-rails` + `bootstrap` gem。`application.scss` で `@import "bootstrap"` し、必要な変数 ($primary など) を上書きしてブランドカラーをカスタマイズ
  - JS: Bootstrap の JS バンドル (`bootstrap.bundle.js`、Popper 同梱版) を importmap で pin。`data-bs-toggle` 系の属性で modal / dropdown / collapse 等が動く
  - 一部の小さなインタラクション (確認ダイアログ、フォームバリデーション表示など) は **Stimulus** で書き、Bootstrap の素の JS と棲み分ける

---

## 3. 機能要件

### 3.1 認証 (Devise + 通常セッション)
- サインアップ / ログイン / ログアウト (Devise デフォルト View を Slim 化)
- メール確認 (`:confirmable`)
- パスワードリセット (`:recoverable`)
- Cookie + CSRF トークン

### 3.2 認可 (Pundit)
- Policy / Scope を活用 (他版と同じ)

### 3.3 チーム管理
- Slim + form_with で CRUD
- メール招待 (Sidekiq で非同期送信)
- メンバー一覧・ロール変更は **Turbo Frame で部分更新**
- ロール変更ドロップダウンは **Stimulus controller**

### 3.4 プロジェクト管理
- Slim で CRUD
- アーカイブ機能

### 3.5 タスク管理 (★ Hotwire が主役)
- タスク CRUD は `form_with` + Turbo
- **タスクボード**: Slim でカラム描画、**Stimulus + SortableJS** でドラッグ&ドロップ、移動時に fetch でステータス更新 → Turbo Stream で反映
- ステータス: `todo` / `in_progress` / `done`
- 期限、優先度
- 編集モーダルは Stimulus controller でトグル

### 3.6 コメント
- タスク詳細ページに `turbo_frame_tag :comments`
- コメント投稿 → サーバが Turbo Stream で `append` を返す → リロード不要で一覧に追加される
- polymorphic 設計は維持

### 3.7 検索・フィルタ (Ransack)
- タスク一覧の絞り込みフォームを `turbo_frame_tag :task_list` で囲む
- 入力変更時に **Stimulus controller で auto submit** → Turbo Frame が結果だけ差し替え
- URL に検索条件を反映 (`history.replaceState`) してリロード可能にする

### 3.8 通知 (Sidekiq + ActionMailer)
- 担当アサイン時の通知メール (非同期)
- 期限前リマインドメール (定期実行)
- 通知一覧ページは Turbo Frame でページネーション

### 3.9 ページネーション
- Kaminari + Slim partial
- 「次へ」リンクが Turbo で差分読み込み

---

## 4. データモデル (概要)

他版と同一。

```
User ──┬─< Membership >──┬── Team ──< Project ──< Task ──< Comment
       │                 │                          │
       │                 └─< Invitation             └── assignee: User
```

### 主要アソシエーション (学習ポイント)
- `User has_many :teams, through: :memberships` — **has_many :through**
- `Team has_many :projects, dependent: :destroy`
- `Comment belongs_to :commentable, polymorphic: true` — **polymorphic**
- `Task belongs_to :assignee, class_name: 'User', optional: true`
- `Membership` の `role` — **enum**

---

## 5. 学習要素チェックリスト

### 5.1 必須要素 (ユーザー指定)
- [x] **アソシエーション** — has_many, belongs_to, has_many :through, polymorphic, enum
- [x] **RSpec** — model / request / system spec (system spec で UI を一気通貫)
- [x] **Devise** — confirmable, recoverable, 通常セッション

### 5.2 バックエンド実務要素 (他版と共通)
- [ ] Pundit による認可
- [ ] N+1 検出 (Bullet) と includes/eager_load
- [ ] ページネーション (Kaminari)
- [ ] 検索 (Ransack)
- [ ] 非同期処理 (Sidekiq + Redis)
- [ ] メール送信 (ActionMailer + Devise の confirmable)
- [ ] FactoryBot + Faker
- [ ] ストロングパラメータ
- [ ] バリデーション (DB 制約 + モデル)
- [ ] マイグレーションのベストプラクティス
- [ ] セキュリティ基本 (mass assignment, SQLi, CSRF, mass-assignment)
- [ ] 環境変数と Rails credentials の使い分け
- [ ] ロギング (Lograge)

### 5.3 View / Hotwire 実務要素 (本版の主役)
- [ ] **Slim** — レイアウト、partial、ヘルパー、Devise view の Slim 化
- [ ] **form_with** — エラー表示、`local: false` のデフォルト挙動、`turbo: false` の使い分け
- [ ] **Turbo Drive** — リンク遷移の SPA 化、`data-turbo="false"` の使い所
- [ ] **Turbo Frame** — `turbo_frame_tag` での部分更新、`turbo-frame target` 属性
- [ ] **Turbo Stream** — `append / prepend / replace / update / remove`、サーバから流す
- [ ] **Stimulus** — controller の作り方、`data-controller / data-action / data-*-target`
- [ ] **importmap-rails** — JS の配信、外部ライブラリの pin、ビルドレス構成の理解
- [ ] **Bootstrap 5 + dartsass-rails** — SCSS 変数の上書きでブランド調整、Grid / Utility / Component の使い分け
- [ ] **Bootstrap の JS と Stimulus の併存** — `data-bs-*` で動く既製インタラクションと、自前 Stimulus controller の役割分担
- [ ] **Capybara system spec** — Turbo の非同期挙動を待つ書き方 (`have_css` の暗黙待機、`Capybara.default_max_wait_time`)

### 5.4 インフラ・運用要素 (他版と共通)
- [ ] Docker + docker-compose (Node が不要なので Dockerfile はシンプル)
- [ ] GitHub Actions による CI (Ruby のみで完結、ESLint/Prettier は不要)
- [ ] RuboCop / Slim-Lint / **erb_lint は不要**
- [ ] Lefthook で pre-commit
- [ ] モノリスとしてのデプロイ (Render or Fly.io)
- [ ] README / ADR (「なぜ Hotwire を選んだか」「React と比べての判断軸」を 1 本書く)
- [ ] PR ベース開発フロー

---

## 6. スコープ外 (YAGNI)

- React / Vue / Svelte などのフロントフレームワーク
- npm 依存のフロントビルド (jsbundling-rails, cssbundling-rails も非採用)
- 画像アップロード (Active Storage)
- 国際化 (i18n)
- 全文検索エンジン
- 監視ツール連携
- リッチテキストエディタ (Action Text)
- マルチテナント分離
- **ActionCable によるリアルタイムマルチユーザー同期** — Turbo Stream の理解までで止める (broadcasts まで踏み込まない)

---

## 7. 完了の判断基準

1. **動作**: サインアップ → メール確認 → チーム作成 → メンバー招待 → プロジェクト作成 → タスク作成 → ドラッグ&ドロップでステータス変更 → コメント追加 → 通知メール受信、まで一気通貫
2. **テスト**: 主要モデル/request spec + system spec で Hotwire を含む UI を E2E 検証
3. **CI**: PR ごとに RuboCop / Slim-Lint / RSpec が緑
4. **デプロイ**: 本番 URL から上記フローを実行できる
5. **コード品質**: linter 指摘ゼロ、Bullet 警告ゼロ
6. **ドキュメント**: README + ADR (Hotwire 採択理由)

---

## 8. 1ヶ月の進め方の目安

| Week | テーマ | 学習要素 |
|------|-------|---------|
| Week 1 | 環境構築と認証 | Docker / Rails / Slim / Devise / Bootstrap 5 (dartsass-rails) / importmap / 最初の Stimulus controller / RSpec 雛形 |
| Week 2 | コアドメイン | Team / Project / Task の CRUD、アソシエーション、Pundit、N+1 対策、Capybara system spec の習熟 |
| Week 3 | Hotwire 本番投入 | Turbo Frame で絞り込み、Turbo Stream でコメント追加、Stimulus + SortableJS でドラッグ&ドロップ、Ransack |
| Week 4 | 仕上げ | Sidekiq + メール、system spec / request spec 拡充、CI、デプロイ、README/ADR |

「**Week 1 の終わりに Stimulus controller が 1 つ動いていること**」と「**Week 3 の終わりに Turbo Stream で何かが非同期更新されること**」を 2 つのチェックポイントにする。

---

## 9. 検証方法 (学習成果のセルフチェック)

他版と共通の項目に加えて、本版固有:

- Turbo Drive がオンの状態で、JS で `addEventListener` した処理が消える条件 (`turbo:load` vs `DOMContentLoaded`) を説明できるか
- `turbo_frame_tag` と `turbo_stream` の役割の違いを説明できるか
- `format.turbo_stream` で `update / replace / append` をどう使い分けるかを説明できるか
- Stimulus の lifecycle (`connect / disconnect`) と Turbo の挙動の関係を説明できるか
- importmap-rails と jsbundling-rails をどう選ぶかを説明できるか
- system spec で Turbo の非同期更新を待つ「正しい書き方」(`sleep` を使わない) を説明できるか
- Hotwire と SPA、どんなアプリでどちらを選ぶかを技術判断として説明できるか

これらが答えられれば、Rails 7 標準スタックで現代的な Web アプリを構築する一通りの土台ができている。

# タスク管理を行う LINE Bot

## Versions

- Ruby version

  3.2.2

- Rails version

  7.0.4.3

## システム概要

### - システム -

LINE Bot を用いて、大学の課題を締め切り日時と共に登録し、管理ができるシステム

<img src="/images/system.png" alt="" width="50%" height="auto">

### - LINE Bot を開発した理由 -

学校の課題の締め切りを毎度毎度アクセスして確認をしたり、メモに残しておくことに面倒さを感じた。その点、LINE 上で登録をして管理ができれば、確認も記録も容易にできると思ったので、開発をすることにした。

### - このアプリの補足点 -

Tasks テーブルしか作成しておらず、データベースに登録したデータが LINE Bot 上で統一されてしまう。それに加え、タスク以外の単語や言葉でも登録が可能な点がある。しかし、今回のアプリケーションは、自分用に作成したものであり、ユーザーに使用してもらうことを想定していないので、その点は排除した上で作成を行なった。その上で、アプリケーションの土台はしっかりと作成したかったので、基本的なバリデーションの処理コードは追加した。

今後、ユーザーに使用してもらうためのアプリケーションに、 LINE Bot の導入を考えているので、その作成の際にはもう少し設計にこだわっていこうと思う。

### - 主な機能 -

- **タスク一覧取得**

登録されているタスクの一覧を取得。

<div style="display: flex;">
  <img src="/images/list1.png" alt="" width="43%" height="auto" style="margin-right: 10px;">
  <img src="/images/list2.png" alt="" width="43%" height="auto">
</div>

---

- **タスクの登録**

タスクを登録。形式が異なるものや、期限が過ぎている場合は登録されない。

<div style="display: flex;">
  <img src="/images/create1.png" alt="" width="43%" height="auto" style="margin-right: 10px;">
  <img src="/images/create2.png" alt="" width="43%" height="auto">
</div>

---

- **タスクの更新**

タスクの更新。形式が異なるものや、該当するタスクがない、期限が過ぎている場合は更新されない。

<div style="display: flex;">
  <img src="/images/update1.png" alt="" width="43%" height="auto" style="margin-right: 10px;">
  <img src="/images/update2.png" alt="" width="43%" height="auto">
</div>

---

- **タスクの削除**

タスクの削除。形式が異なるものや、該当するタスクがない場合は更新されない。

<div style="display: flex;">
  <img src="/images/delete1.png" alt="" width="43%" height="auto" style="margin-right: 10px;">
  <img src="/images/delete2.png" alt="" width="43%" height="auto">
</div>

## 工夫した点

### - サービスクラスの導入 -

コードの可読性と保守性を向上させるために、サービスクラスを導入し、処理を独立したクラスにカプセル化した。

**利点と理由**

- 利点

  1.  コントローラー内のロジックがシンプルになる。

  2.  機能の拡張が容易になる。

- 理由

  1. タスクの登録やバリデーションの処理が複雑化している

  2. 複雑な拡張を加える可能性がある

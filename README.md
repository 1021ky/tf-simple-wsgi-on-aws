# tf-simple-wsgi-on-aws

## このリポジトリについて

terraformで以下の構成をセットアップするための練習用リポジトリ

* ELB
  * HTTPリクエストを受け付ける
* nginx on EC2
  * 静的コンテンツを返す
  * バックエンドへのルーティングを行う
* apache wsgi
  * 動的コンテンツを返す

### 実行環境
- Terraform version 0.11 を想定
- OSは Mac,Windowsから動作確認済み
  - Windowsだとパスの参照がうまく行かないため *PLATFORM = "WIN"* は使用不可


### 完成品
- 灰色部分は最初の terraform apply では作成不可(先にコンソールでSNSの認証を済ませておく)
<img width="406" alt="aws_doujou_terraform" src="https://user-images.githubusercontent.com/38773075/58137725-4a852f80-7c6e-11e9-8487-feb2381e2fb8.PNG">


### 使い方(1か2のどちらかを使用)

1. `.tfvars` を自分で用意する

2. `sample.tfvars` を全体選択しコメントアウトを解除後、値を入力して使用
  - *# # PLATFORM = "WIN"* のようにコメントアウトが二重のところは完全にコメントアウトしない
  - `secret_key`を記載したファイルはpublicリポジトリにアップロードしない(.gitignoreに追加する)

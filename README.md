# README

# 概要
このリポジトリは新しいRailsアプリケーションのDocker開発環境を構築するときに最低限必要なものを記載したもの。

# 確認済みMWバージョン
- ruby 2.7.1
- rails 6.0.4
- PostgreSQL 12.2 

# 使い方
1. Dockerfileに記載している以下の変数の値を変更する
- RUBY_VERSION
- APP_NAME

2. APP_NAMEに合わせて、docker-compose.ymlを変更する

3. Railsアプリケーション用のコンテナの構築、作成、起動
```bash
$ docker-compose up -d --build
$ docker-compose exec web bash
```

4. Railsアプリケーションを作成する
```bash
$ gem install rails
$ rails new ${APP_PATH} --database=postgresql --skip-keeps --force
```
※`--force `オプションはREADME.mdと.gitignoreをオーバーライドするため。

5. Railsアプリケーション起動
```bash
$ rails s -p 3000 -b '0.0.0.0'
```

5. Dockerfileのbundle install部分のコメントアウトをはずす


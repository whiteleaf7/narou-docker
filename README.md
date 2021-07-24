# Narou.rb Docker Image

Narou.rb を Docker で実行するための Docker Image です。<br>
Docker さえあれば一切環境構築なしで Narou.rb WEB UI を立ち上げることができます。

Narou.rb 作者製です。<br>
~~最新バージョンへの追随は本体とほぼ同時に行う予定です。~~<br>
Linux 版の kindlegen の配布が終了してしまったため、現在更新停止中です。

イメージ内容は下記で構成されます。

- Alpine Linux
- Ruby 2.7
- [改造版AozoraEpub3](https://github.com/kyukyunyorituryo/AozoraEpub3)
- kindlegen 2.9

# 使い方（docker コマンド編)

docker コマンドで直接コンテナを立ち上げます。<br>
コマンドが長いのでエイリアスを切ったりしましょう。<br>
後述する docker-compose でやったほうが正直楽です。

コマンドを実行したフォルダが小説管理用のフォルダになるので移動しておきます。

```sh
$ mkdir ~/novel && cd $_
$ docker run --rm -it -p 127.0.0.1:33000-33001:33000-33001 -v $(pwd):/novel:cached whiteleaf/narou
```

docker から始まるコマンド１行で WEB UI が起動します。<br>
http://localhost:33000/ にアクセスしてください。

ポートを変える場合、前半部分の 33000-33001 部分を変更するだけでOKです。<br>
例えば 8000 ポートに変える場合は -p 127.0.0.1:8000-8001:33000-33001 と
指定してください（websocket 用のポートのために +1 したポートも併記する必要があります）

# 使い方（docker-compose 編）

docker-compose のほうが楽なので、こちらを推奨します。<br>
ただし、設定ファイルを１つ用意する必要があります。

コマンドを実行したフォルダが小説管理用のフォルダになるので移動しておきます。

```sh
$ mkdir ~/novel && cd $_
```

下記の内容を docker-compose.yml という名前でを同じフォルダに用意します。

```yml
version: "3.7"

services:
  app:
    image: whiteleaf/narou
    command: ["narou", "web", "-np", "33000"]
    volumes:
      - .:/novel:cached
    tty: true
    stdin_open: true
    ports:
      - "127.0.0.1:33000-33001:33000-33001"
```

ファイルを用意したら下記コマンドを打ちます。

```sh
$ docker-compose up
```

自動的に WEB UI が起動します。<br>
http://localhost:33000/ にアクセスしてください。

ポートを変える場合は docker コマンドと同様に ports の項の前半部分を変更してください。
# イメージを更新する

```sh
$ docker pull whiteleaf/narou
```

更新がある場合、上記コマンドで環境を最新にできます

# CUI としてコマンドを使いたい場合

## docker で直接使う

```sh
$ docker run --rm -it -v $(pwd):/novel:cached whiteleaf/narou narou list
```

## docker-compose で使う

```sh
docker-compose run --rm app narou list
```

おまけ<br>
[dip](https://github.com/bibendi/dip) を使うと便利です

dip.yml として下記を用意して、
```yml
version: "4"
interaction:
  narou:
    description: Run narou command
    service: app
    command: narou
```

```sh
$ dip narou list

# docker-compose up と同じ
$ dip up

# 下記を実行すると、narou コマンドを透過的に実行出来る様になる
$ eval "$(dip console)"
$ narou list
```

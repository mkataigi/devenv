# devenv

mkataigi's dotfiles

# 構築方法（local)

```
./bin/init_myenv [-f]
```

# 構築方法(docker)

```
docker build -t devenv . --build-arg githuboauthtoken=<gitのoauth token>
```

# provisioning

## 復旧手順

### システム環境設定

- デスクトップとスクリーンセーバー
  - 壁紙、ランダムな順序
- Dock
  - 左
  - Dockを自動的に表示/非表示
- Mission Control
  - ホットコーナー
    - 左上、ディスプレイをスリープさせる
- キーボード
  - ショートカット
    - Mission Control
      - デスクトップXへの切り替え
- Bluetooth
  - メニューバーにBluetoothを表示

### 設定

- Doc整理
  - 不要なものを削除
- Finder
  - 環境設定
    - 全てのファイル名拡張子を表示

### ソフトウェアインストール

- 1password
  - https://1password.com/jp/
- dropbox
  - https://help.dropbox.com/ja-jp/installs-integrations/desktop/download-dropbox
  - ssh keyをコピー
    - ~/Dropbox/Development/keys => ~/.ssh

```
chmod 700 .ssh
chmod 600 .ssh/*
```

- Homebrew
  - https://brew.sh/index_ja

### Homebrew

- 初期clone

```
mkdir repo
cd repo
git clone git@github.com:mkataigi/devenv.git
git clone git@github.com:mkataigi/provisioning.git
```

- 設定

```
~/repo/devenv/bin/init_myenv.sh
cp ~/repo/provisioning/mba/Chrome_Bookmarks.txt ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
```

- homebrew

```
brew tap Homebrew/bundle
cd ~/repo/provisioning/mba/
brew bundle
```

- mac設定

```
~/repo/provisioning/mba/mac_defaults.sh
```

## アプリケーション設定

### shell

- システム環境設定
  - ユーザとグループ
    - ctrl + clickで詳細オプション
      - ログインシェルを `/usr/local/bin/zsh`

### Slack

- plaidinc
- mkataigi
- mohikan

## プログラム系

### JS

```
brew install yarn
yarn add nvm
```

### Python

```
pip install -r pip.txt
```

### Visual Studio Code

- Visual Studio Code Settings Sync
  - https://gist.github.com/mkataigi/1d847dc679a59a9eb665c14b07d623b0

---
name: system-backup
description: PCのシステム状態をバックアップするスキル。Macのdefaults、Chromeブックマーク、インストール済みアプリケーション、Homebrew/pip/npmパッケージ一覧を指定ディレクトリに保存し、git管理下であればコミット＆プッシュする。このスキルは「システムバックアップ」「設定をバックアップ」「環境情報を保存」などのリクエストに対して使用する。
---

# System Backup

## Overview

Macのシステム状態を指定ディレクトリにバックアップするスキル。以下の情報を個別のファイルに保存する：

- `defaults.txt` - Macのdefaults設定
- `chrome_bookmarks.json` - Chromeのブックマーク
- `applications.txt` - /Applications以下のアプリケーション一覧
- `brew.txt` - Homebrewでインストールされたformulae/casks
- `pip.txt` - Pythonのpipパッケージ一覧
- `npm.txt` - Node.jsのグローバルnpmパッケージ一覧

## Usage

バックアップを実行するには、`scripts/backup.sh`スクリプトを使用する：

```bash
bash /path/to/system-backup/scripts/backup.sh <backup-directory>
```

### 引数

- `<backup-directory>` - バックアップファイルを保存するディレクトリのパス（必須）

### 動作

1. 指定ディレクトリが存在しない場合は作成
2. 各システム情報を個別のファイルに保存（毎回上書き）
3. 指定ディレクトリがgit管理下の場合：
   - 変更があればコミット（メッセージ: `System backup: YYYY-MM-DD HH:MM:SS`）
   - origin/masterにプッシュ

### 例

```bash
# バックアップを実行
bash scripts/backup.sh ~/repo/my-backup

# 特定のディレクトリにバックアップ
bash scripts/backup.sh /Users/username/dotfiles/backup
```

## Notes

- Python/Node.jsがインストールされていない場合、該当ファイルにはその旨が記載される
- Chromeがインストールされていない場合、chrome_bookmarks.jsonにはその旨が記載される
- gitリポジトリでない場合、コミット/プッシュはスキップされる

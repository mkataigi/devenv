---
name: system-update-cleanup
description: Homebrewパッケージの更新とDockerの不要イメージ削除を行うシステムクリーンアップスキル。「システムクリーンアップ」「brew更新」「docker掃除」「パッケージ更新」などのリクエストに対して使用してください。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash
---

# System Cleanup Skill

以下の処理を順番に実行してください。

### Step 1: Homebrewの更新

Homebrewのフォーミュラ情報を最新化し、インストール済みパッケージをアップグレードします。

```bash
brew update
brew upgrade
```

各コマンドの出力を記録し、更新されたパッケージがあればリストアップしてください。

### Step 2: Dockerの不要イメージの削除

dangling状態（タグなし）のDockerイメージを削除します。

```bash
docker images -qf dangling=true | xargs docker rmi
```

Dockerが起動していない場合やdanglingイメージが存在しない場合は、その旨を報告してスキップしてください。

### Step 3: 結果の報告

全ての処理が完了したら、以下の形式で結果を報告してください。

```
## System Cleanup 完了

### Homebrew
- 更新されたフォーミュラ: X件
- アップグレードされたパッケージ: (パッケージ名を列挙、なければ「なし」)

### Docker
- 削除されたdanglingイメージ: X件 (またはスキップ理由)

### エラー・警告
- (あれば記載)
```

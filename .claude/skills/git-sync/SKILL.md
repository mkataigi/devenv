---
name: git-sync
description: 指定したディレクトリ配下のGitリポジトリを一括で同期・クリーンアップします。複数のリポジトリのメインブランチを最新化し、マージ済みブランチを削除したい場合に使用してください。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash
argument-hint: <directory_path>
---

# Git Sync Skill

ユーザーが指定したディレクトリに対して、以下の処理を順番に実行してください。

### Step 1: サブディレクトリの検出とGitリポジトリの判定

指定されたディレクトリ直下のサブディレクトリを一覧取得し、それぞれが以下のいずれかに該当するか確認します：

1. **通常のGitリポジトリ**: `.git` ディレクトリが存在する
2. **Git Worktree**: `.git` ファイルが存在し、中身が `gitdir: ...` の形式になっている

該当しないディレクトリはスキップします。

### Step 2: 各リポジトリに対する処理

検出した各Gitリポジトリに対して、以下の処理を実行します。

#### 2-1. メインブランチの特定

以下のコマンドでデフォルトブランチを特定します：

```bash
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'
```

取得できない場合は、`main`、`master`、`develop` の順で存在するブランチを探します。

#### 2-2. リモートの最新情報を取得

```bash
git fetch --prune origin
```

#### 2-3. メインブランチを最新に更新

現在のブランチを記録してから、メインブランチをチェックアウトして更新します：

```bash
current_branch=$(git branch --show-current)
git checkout <main_branch>
git pull origin <main_branch>
```

#### 2-4. 元のブランチに戻り、メインブランチをマージ（必要な場合）

現在のブランチがメインブランチでなかった場合：

```bash
git checkout <current_branch>
git merge <main_branch> --no-edit
```

マージコンフリクトが発生した場合は、その旨を報告してスキップします。

#### 2-5. マージ済みブランチの削除

リモートで削除済み、かつローカルでマージ済みのブランチを削除します：

```bash
# マージ済みブランチを取得（メインブランチとcurrent branchは除外）
git branch --merged <main_branch> | grep -v "^\*" | grep -v <main_branch> | grep -v <current_branch> | while read branch; do
  # リモートに存在しないか確認
  if ! git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    git branch -d "$branch"
  fi
done
```

### Step 3: Worktree特有の処理

ディレクトリがWorktreeの場合（`.git`がファイルで`gitdir:`を含む）：

1. Worktreeのディレクトリ名を取得
2. そのディレクトリ名と同名のブランチが存在するか確認

```bash
worktree_name=$(basename "$PWD")
if git show-ref --verify --quiet "refs/heads/$worktree_name"; then
  # ブランチが存在する場合：メインブランチをマージ
  git checkout "$worktree_name"
  git merge <main_branch> --no-edit
else
  # ブランチが存在しない場合：メインブランチから新規作成
  git checkout -b "$worktree_name" <main_branch>
fi
```

### Step 4: 結果の報告

全ての処理が完了したら、以下の形式で結果を報告してください：

```
## Git Sync 完了

### 処理したリポジトリ
- repo1: メインブランチ(main)を更新、feature-branchにマージ完了
- repo2: メインブランチ(master)を更新（メインブランチで作業中のためマージ不要）
- repo3: Worktree - 新規ブランチ「repo3」を作成

### 削除したブランチ
- repo1: old-feature, bugfix-123
- repo2: なし

### エラー・警告
- repo4: マージコンフリクトが発生（手動解決が必要）
```

## Notes

- 未コミットの変更がある場合は、その旨を警告してスキップするか、stashするかをユーザーに確認してください
- ネットワークエラーが発生した場合は、そのリポジトリをスキップして次に進んでください
- 処理前に必ず現在の状態を確認し、破壊的な操作を行う前にユーザーに確認を取ってください

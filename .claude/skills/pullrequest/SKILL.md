---
name: pullrequest
description: GitHub CLI を使用してプルリクエストを作成します。変更をプルリクエストとして提出したい場合に使用してください。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read
arguments:
  - name: issue
    description: 紐づけるissue番号（例: 123）。指定するとPRがissueにリンクされます。
    required: false
---

# プルリクエスト作成スキル

GitHub CLI を使用してプルリクエストを作成します。

**重要**: PR タイトルと説明はすべて日本語で記述してください。

## 前提条件

1. GitHub CLI がインストールされていること:

   ```bash
   # macOS
   brew install gh

   # Windows
   winget install --id GitHub.cli

   # Linux
   # https://github.com/cli/cli/blob/trunk/docs/install_linux.md を参照
   ```

2. GitHub で認証済みであること:
   ```bash
   gh auth login
   ```

## プルリクエストの作成

1. まず、@.github/pull_request_template.md のテンプレートに従って PR 説明を準備

2. `gh pr create --draft` コマンドでプルリクエストを作成:

   ```bash
   # 基本的なコマンド構造
   gh pr create --draft --title "✨(scope): 説明的なタイトル" --body "PR 説明" --base main
   ```

   適切なフォーマットの複雑な PR 説明には `--body-file` オプションを使用:

   ```bash
   # 適切なテンプレート構造で PR を作成
   gh pr create --draft --title "✨(scope): 説明的なタイトル" --body-file .github/pull_request_template.md --base main
   ```

## Issue との紐付け

`$ARGUMENTS` に issue 番号が指定された場合（例: `--issue 123`）、PR を該当 issue にリンクします。

**紐付け方法**: PR 説明の末尾に `Closes #<issue番号>` を追加することで、PR がマージされた際に issue が自動的にクローズされます。

```bash
# issue 番号が指定された場合のコマンド例
gh pr create --draft --title "✨(scope): 説明的なタイトル" --body "PR 説明

Closes #123" --base main
```

**キーワードの種類**:
- `Closes #123` - PR マージ時に issue をクローズ
- `Fixes #123` - バグ修正の場合に使用
- `Resolves #123` - 同様に issue をクローズ

issue が指定された場合は、必ず PR 説明に上記のキーワードを含めてください。

## ベストプラクティス

1. **言語**: PR タイトルと説明は常に日本語を使用

2. **PR タイトル形式**: 絵文字付きの Conventional Commit 形式を使用

   - タイトルの先頭に適切な絵文字を必ず含める
   - 実際の絵文字文字を使用（`:sparkles:` のようなコード表現ではなく）
   - 例:
     - `✨(supabase): ステージング用リモート設定を追加`
     - `🐛(auth): ログインリダイレクトの問題を修正`
     - `📝(readme): インストール手順を更新`

3. **説明テンプレート**: 常に @.github/pull_request_template.md の PR テンプレート構造を使用

4. **テンプレートの正確性**: PR 説明がテンプレート構造に正確に従っていることを確認:

   - PR-Agent セクション（`pr_agent:summary` と `pr_agent:walkthrough`）を変更・リネームしない
   - すべてのセクションヘッダーをテンプレートと完全に一致させる
   - テンプレートにないカスタムセクションを追加しない

5. **ドラフト PR**: 作業中の場合はドラフトとして開始
   - コマンドに `--draft` フラグを使用
   - 完了したら `gh pr ready` でレビュー準備完了に変換

## 避けるべき一般的なミス

1. **日本語以外のテキストを使用**: すべての PR コンテンツは日本語で記述
2. **不正確なセクションヘッダー**: 常にテンプレートの正確なセクションヘッダーを使用
3. **カスタムセクションの追加**: テンプレートで定義されたセクションのみを使用
4. **古いテンプレートの使用**: 常に現在の @.github/pull_request_template.md ファイルを参照

## セクションの欠落について

「N/A」や「なし」とマークされていても、すべてのテンプレートセクションを含めてください。

## 便利な GitHub CLI PR コマンド

```bash
# 自分のオープンな PR を一覧表示
gh pr list --author "@me"

# PR ステータスを確認
gh pr status

# 特定の PR を表示
gh pr view <PR-NUMBER>

# PR ブランチをローカルにチェックアウト
gh pr checkout <PR-NUMBER>

# ドラフト PR をレビュー準備完了に変換
gh pr ready <PR-NUMBER>

# PR にレビュアーを追加
gh pr edit <PR-NUMBER> --add-reviewer username1,username2

# PR をマージ
gh pr merge <PR-NUMBER> --squash
```

## テンプレートを使用した PR 作成

一貫した説明で PR 作成を簡素化するには、テンプレートファイルを作成できます：

1. `pr-template.md` という名前のファイルに PR テンプレートを作成
2. PR 作成時に使用:

```bash
gh pr create --draft --title "feat(scope): タイトル" --body-file pr-template.md --base main
```

## 関連ドキュメント

- [PR テンプレート](.github/pull_request_template.md)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub CLI ドキュメント](https://cli.github.com/manual/)

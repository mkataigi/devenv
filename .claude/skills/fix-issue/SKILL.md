---
name: fix-issue
description: GitHub Issue を分析し、修正を実装します。Issue の問題を理解して修正したい場合に使用してください。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
argument-hint: <issue-number>
---

# Issue 修正スキル

GitHub Issue $ARGUMENTS を分析し、修正を実装してください。

## 実行手順

1. `gh issue view` で Issue の詳細を取得
2. Issue に記載された問題を理解
3. コードベースで関連ファイルを検索
4. 問題を修正するために必要な変更を実装
5. 修正を検証するテストを作成・実行
6. コードがリントと型チェックを通過することを確認
7. 説明的なコミットメッセージを作成

## 注意事項

- GitHub 関連のタスクにはすべて GitHub CLI（`gh`）を使用してください

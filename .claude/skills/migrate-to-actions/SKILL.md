---
name: migrate-to-actions
description: Cloud Build から GitHub Actions への移行を自動化します。cloudbuild.yml を GitHub Actions ワークフローと docker-bake.hcl に変換したい場合に使用してください。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
argument-hint: [--dry-run] [--system-name <name>] [--force]
---

# Migrate to Actions

Cloud Build から GitHub Actions への移行を自動化するスキルです。

## 使い方

```bash
# 対話的モードで実行
/migrate-to-actions

# ドライランで確認
/migrate-to-actions --dry-run

# システム名を指定
/migrate-to-actions --system-name organization

# 強制的に上書き
/migrate-to-actions --force
```

## オプション

- なし : 対話的モードで実行
- `--dry-run` : 実際のファイル生成は行わず、プレビューのみ表示
- `--system-name <名前>` : システム名を指定（自動推定をスキップ）
- `--force` : 既存ファイルを確認なしで上書き

## 移行プロセス

### Phase 1: 初期確認と解析

```bash
実行開始:
  - 現在のディレクトリ構造を確認
  - cloudbuild.yml の存在確認と解析
  - Dockerfile の探索と解析
  - システム名の推定（ディレクトリ名から）

自動推定:
  - ビルドステップ数
  - 使用イメージ名
  - ビルド引数
  - タグ付けルール
```

### Phase 2: 対話的確認

```bash
🔍 解析結果:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
システム名: organization
Dockerfiles:
  - ./docker/production.app.Dockerfile
  - ./docker/production.web.Dockerfile
イメージ数: 2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ この内容で移行を進めてよろしいですか？ [Y/n]:
```

### Phase 3: ファイル生成

生成されるファイル構造：

```bash
# 現在のディレクトリ: {repository-root}/systems/{system_name}/
./
├── docker-bake.hcl                    # 新規作成（現在のシステムディレクトリ内）
├── migration-report.md                # 移行レポート（現在のシステムディレクトリ内）
└── .dockerignore                      # 更新または作成（必要な場合）

# リポジトリルート: {repository-root}/
{repository-root}/
└── .github/
    └── workflows/
        └── build-{system_name}.yml    # 新規作成（リポジトリルートに作成）
```

**重要**:

- `docker-bake.hcl` は各システムのディレクトリ内（例: `systems/organization/`）に作成
- GitHub Actions ワークフローはリポジトリルートの `.github/workflows/` に作成

#### GitHub Actions ワークフロー生成

```yaml
# .github/workflows/build-{system_name}.yml として生成される内容
name: build-{system_name}
on:
  workflow_dispatch:
  pull_request:
    types: [closed, labeled, synchronize]
    branches: [develop]
    paths:
      - systems/{system_name}/**
      - .github/workflows/build-{system_name}.yml

jobs:
  build-and-create-pr:
    uses: ./.github/workflows/build-and-create-pr.yml
    with:
      system_name: {system_name}
    secrets: inherit
    permissions:
      contents: read
      id-token: write
      packages: write
      pull-requests: write
```

**重要**: コマンド実装時には、以下の点を厳守してください：

1. **ワークフローファイル名**: `build-{system_name}.yml` 形式
2. **name フィールド**: `build-{system_name}` 形式
3. **paths の設定**:
   - `systems/{system_name}/**`
   - `.github/workflows/build-{system_name}.yml`
4. **with.system_name**: 検出または指定された system_name を使用
5. **その他の設定**: 変更不可（完全に同じ形式を維持）

### Phase 4: 検証

```bash
📋 検証ステップ:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. docker-bake.hcl 構文チェック... ✅
2. Dockerfile 参照確認... ✅
3. ローカルビルドテスト実行中...
   - app イメージ... ✅
   - web イメージ... ✅
4. GitHub Actions ワークフロー検証... ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 注意事項

- **前提条件**: Cloud Build を使用している Google Cloud プロジェクト
- **制限事項**: Docker Buildx のインストールが必要
- **推奨事項**: 本番環境への適用前に開発環境で検証
- **ワークフロー形式**: 指定された形式を厳密に維持（system_name 以外は変更禁止）

## 移行後の確認

```bash
# Docker Buildx での動作確認
docker buildx bake --print -f docker-bake.hcl
docker buildx bake -f docker-bake.hcl

# GitHub Actions でのテスト
act -j build-and-create-pr
```

## トラブルシューティング

```bash
# cloudbuild.yml が見つからない場合
❌ エラー: cloudbuild.yml が見つかりません
💡 ヒント: Cloud Build を使用しているシステムのルートディレクトリで実行してください

# Dockerfile が見つからない場合
❌ エラー: Dockerfile が見つかりません
💡 ヒント: 以下の場所を確認しました:
   - ./Dockerfile
   - ./docker/Dockerfile
   - ./docker/*.Dockerfile

# ビルド検証エラー
❌ エラー: ローカルビルドテストが失敗しました
💡 ヒント:
   - Docker Desktop が起動していることを確認
   - docker buildx がインストールされていることを確認
```

## コマンド動作の詳細

### 実行時の処理フロー

`/migrate-to-actions` を実行すると、以下の処理を自動的に行います：

1. **現在のディレクトリを確認**して `cloudbuild.yml` の存在をチェック
2. **Dockerfileを自動探索**（`./Dockerfile`、`./docker/*.Dockerfile` など）
3. **システム名を自動推定**（ディレクトリ名または `systems/` 配下の名前から）
4. **解析結果を表示**して確認を求める
5. **必要なファイルを生成**：
   - `docker-bake.hcl`（現在のディレクトリ）
   - `.github/workflows/build-{system_name}.yml`（リポジトリルート）
   - `migration-report.md`（移行レポート）
6. **検証を実行**（Docker Buildxでの構文チェックなど）

### エラー時の対処

コマンド実行時に以下のようなチェックと対処を行います：

- `cloudbuild.yml` が見つからない場合は適切なエラーメッセージを表示
- Dockerfileが見つからない場合は探索した場所を明示
- 既存ファイルがある場合はバックアップを作成（`--force` オプションなしの場合）
- 生成したファイルの検証に失敗した場合は詳細なエラー情報を提供

# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## リポジトリアーキテクチャ

これはGNU StowとGitサブモジュールを使用して設定ファイルを管理する個人のdotfilesリポジトリです。各設定カテゴリがサブモジュールまたはスタンドアロンディレクトリとして整理されたモジュラーアーキテクチャに従っています：

**サブモジュール構造：**
| パス | 説明 | タイプ |
|------|------|--------|
| `zsh/` | Zshシェル設定 | サブモジュール |
| `.config/nvim/` | Neovim設定 | サブモジュール |
| `.config/wezterm/` | Weztermターミナル設定 | サブモジュール |
| `.config/starship/` | Starshipプロンプト設定 | サブモジュール |
| `.config/yabai/` | Yabaiウィンドウマネージャー設定 | サブモジュール |
| `.config/skhd/` | Simple hotkey daemon設定 | サブモジュール |
| `brew/` | Homebrewパッケージ定義 | サブモジュール |

**主要ファイル：**
- `install.sh` - dotfiles全体のインストールを統括するメインセットアップスクリプト
- `.gitmodules` - 全コンポーネントリポジトリのGitサブモジュール設定
- `brew/.Brewfile` - macOSセットアップ用の包括的Homebrewパッケージリスト

## 一般的なコマンド

### 初期セットアップ
```bash
# 完全なdotfilesセットアップ（すべてを実行）
./install.sh
```

### パッケージ管理
```bash
# Homebrewパッケージのインストール/更新
brew bundle --file="$HOME/.Brewfile"

# サブモジュールの更新
git submodule update --remote --merge
```

### Stow操作
```bash
# 特定の設定をstow
stow <directory>

# .configサブディレクトリをstow
cd .config && stow <config-name> -t "$HOME/.config"

# stowされた設定を削除
stow -D <directory>
```

## 開発ワークフロー

このリポジトリはGitサブモジュールを広く使用しているため、開発は通常以下を含みます：

1. **サブモジュールへの変更：** 特定のサブモジュールディレクトリに移動してそこで変更を行う
2. **親リポジトリの更新：** サブモジュールの変更後、新しいコミットを参照するよう親dotfilesリポジトリを更新する
3. **変更のテスト：** テストのために `stow -D` と `stow` を使用して設定を再リンクする

## インストールプロセス

`install.sh` スクリプトは以下の順序に従います：
1. `brew/` ディレクトリをstowして `.Brewfile` を `$HOME` に配置
2. Homebrewが存在しない場合はインストール
3. `brew bundle` を実行してすべてのパッケージをインストール
4. すべての `.config/*` サブディレクトリを `~/.config/` にstow
5. 残りのディレクトリ（install.sh、.git、.gitmodules、README.md、.config、brewを除く）を `$HOME` にstow

## アーキテクチャの注記

- カスタムスクリプトの代わりにGNU Stowをシンボリックリンク管理に使用
- サブモジュール経由でカテゴリ別（シェル、エディタ、ターミナルなど）に関心を分離
- Homebrew Brewfileによる集中パッケージ管理
- 包括的な開発ツールを備えたmacOS環境向けに設計

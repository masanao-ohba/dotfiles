#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "🛠 Setting up dotfiles..."

# === 1. brewディレクトリをstowして ~/.Brewfile を配置 ===
if [ -d "brew" ]; then
  echo "🔗 Stowing brew → ~/"
  stow brew
fi

# === 2. Homebrewのインストール（存在しない場合のみ） ===
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# === 3. ~/.Brewfile を用いて brew bundle 実行 ===
if [ -f "$HOME/.Brewfile" ]; then
  echo "📚 Installing packages from ~/.Brewfile..."
  brew bundle --file="$HOME/.Brewfile"
else
  echo "⚠️  ~/.Brewfile not found, skipping Homebrew packages"
fi

# === 4. .config/* → ~/.config/* に stow ===
if [ -d ".config" ]; then
  mkdir -p ~/.config
  for sub in .config/*; do
    [ -d "$sub" ] || continue
    name=$(basename "$sub")
    echo "🔗 Stowing .config/$name → ~/.config/$name"
    (cd .config && stow "$name" -t "$HOME/.config")
  done
fi

# === 5. その他ディレクトリを ~/ に stow（brew/.config 除く） ===
EXCLUDE=("install.sh" ".git" ".gitmodules" "README.md" ".config" "brew")
for dir in */; do
  dir=${dir%/}
  if [[ " ${EXCLUDE[*]} " == *" $dir "* ]]; then
    continue
  fi
  echo "🔗 Stowing $dir → ~/"
  stow "$dir"
done

echo "✅ Setup complete!"

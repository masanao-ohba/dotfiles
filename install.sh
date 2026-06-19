#!/bin/bash
set -e
cd "$(dirname "$0")"

# === Configuration ===
DRY_RUN=false

# === Argument Parsing ===
# Parse --dry-run / -n flag first, collect remaining args as modules
MODULES=()
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      DRY_RUN=true
      ;;
    *)
      MODULES+=("$arg")
      ;;
  esac
done

# === Helper Functions ===

# Print message with optional [DRY-RUN] prefix
log() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] $1"
  else
    echo "$1"
  fi
}

# Stow a .config/* subdirectory to ~/.config/
# Usage: stow_config_module <name>
stow_config_module() {
  local name="$1"
  if [ -d ".config/$name" ]; then
    log "🔗 Stowing .config/$name → ~/.config/$name"
    if [ "$DRY_RUN" = true ]; then
      (cd .config && stow -v --simulate "$name" -t "$HOME/.config" 2>&1 || true)
    else
      mkdir -p ~/.config
      (cd .config && stow "$name" -t "$HOME/.config")
    fi
    return 0
  else
    return 1
  fi
}

# Stow a regular directory to ~/
# Usage: stow_root_module <name>
stow_root_module() {
  local name="$1"
  if [ -d "$name" ]; then
    log "🔗 Stowing $name → ~/"
    if [ "$DRY_RUN" = true ]; then
      stow -v --simulate "$name" 2>&1 || true
    else
      stow "$name"
    fi
    return 0
  else
    return 1
  fi
}

# Symlink a .config submodule as a single directory link
# For tools that read ~/.config/<name>/ (e.g. nvim): plain stow unfolds the
# package contents into ~/.config/ and drops the <name>/ level, so the tool
# never finds its config. Link the whole directory instead.
# Usage: symlink_config_dir <name>
symlink_config_dir() {
  local name="$1"
  if [ -d ".config/$name" ]; then
    log "🔗 Linking .config/$name → ~/.config/$name (directory symlink)"
    if [ "$DRY_RUN" = true ]; then
      log "    Would: ln -sfn $PWD/.config/$name ~/.config/$name"
    else
      mkdir -p ~/.config
      ln -sfn "$PWD/.config/$name" "$HOME/.config/$name"
    fi
    return 0
  else
    return 1
  fi
}

# Stow claude directory with --no-folding (file-level symlinks)
# Creates ~/.claude/ with symlinks to individual files
# Usage: stow_claude_module
stow_claude_module() {
  if [ -d "claude" ]; then
    log "🔗 Stowing claude → ~/.claude (no-folding)"
    if [ "$DRY_RUN" = true ]; then
      stow -v --simulate --no-folding "claude" 2>&1 || true
    else
      stow --no-folding "claude"
    fi
    return 0
  else
    return 1
  fi
}

# === Argument mode: Stow specified modules only ===
if [ ${#MODULES[@]} -gt 0 ]; then
  for arg in "${MODULES[@]}"; do
    if [ "$arg" = "claude" ] || [ "$arg" = ".claude" ]; then
      stow_claude_module || log "⚠️  Module not found: claude"
    elif [ "$arg" = "nvim" ]; then
      symlink_config_dir "$arg" || log "⚠️  Module not found: nvim"
    elif ! stow_config_module "$arg" && ! stow_root_module "$arg"; then
      log "⚠️  Module not found: $arg"
    fi
  done
  exit 0
fi

log "🛠 Setting up dotfiles..."

# === 1. Stow brew directory to place ~/.Brewfile ===
if [ -d "brew" ]; then
  stow_root_module "brew"
fi

# === 2. Install Homebrew (if not present) ===
if ! command -v brew >/dev/null 2>&1; then
  if [ "$DRY_RUN" = true ]; then
    log "📦 Would install Homebrew (not currently installed)"
  else
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# === 3. Run brew bundle with ~/.Brewfile ===
if [ -f "$HOME/.Brewfile" ]; then
  if [ "$DRY_RUN" = true ]; then
    log "📚 Would install packages from ~/.Brewfile"
    log "    (Run 'brew bundle check --file=\"\$HOME/.Brewfile\"' to see what would be installed)"
  else
    echo "📚 Installing packages from ~/.Brewfile..."
    brew bundle --file="$HOME/.Brewfile"
  fi
else
  log "⚠️  ~/.Brewfile not found, skipping Homebrew packages"
fi

# === 4. Stow .config/* → ~/.config/* ===
if [ -d ".config" ]; then
  for sub in .config/*; do
    [ -d "$sub" ] || continue
    name=$(basename "$sub")
    stow_config_module "$name"
  done
fi

# === 5. Stow other directories to ~/ (excluding brew/.config) ===
EXCLUDE=("install.sh" ".git" ".gitmodules" "README.md" ".config" "brew" "claude")
for dir in */; do
  dir=${dir%/}
  if [[ " ${EXCLUDE[*]} " == *" $dir "* ]]; then
    continue
  fi
  stow_root_module "$dir"
done

# === 6. Stow claude directory to ~/.claude (file-level symlinks) ===
stow_claude_module

log "✅ Setup complete!"

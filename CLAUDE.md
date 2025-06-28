# CLAUDE.md

This file provides guidance for Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a personal dotfiles repository that manages configuration files using GNU Stow and Git submodules. It follows a modular architecture where each configuration category is organized as either a submodule or standalone directory:

**Submodule Structure:**

| Directory | Description | Type |
|-----------|-------------|------|
| `zsh/` | Zsh shell configuration | submodule |
| `.config/nvim/` | Neovim configuration | submodule |
| `.config/wezterm/` | Wezterm terminal configuration | submodule |
| `.config/starship/` | Starship prompt configuration | submodule |
| `.config/yabai/` | Yabai window manager configuration | submodule |
| `.config/skhd/` | Simple hotkey daemon configuration | submodule |
| `brew/` | Homebrew package definitions | submodule |

**Key Files:**
- `install.sh` - Main setup script that orchestrates the entire dotfiles installation
- `.gitmodules` - Git submodule configuration for all component repositories
- `brew/.Brewfile` - Comprehensive Homebrew package list for macOS setup

## Common Commands

### Initial Setup
```bash
# Complete dotfiles setup (runs everything)
./install.sh
```

### Package Management
```bash
# Install/update Homebrew packages
brew bundle --file="$HOME/.Brewfile"

# Update submodules
git submodule update --remote --merge
```

### Stow Operations
```bash
# Stow a specific configuration
stow <directory>

# Stow .config subdirectories
cd .config && stow <config-name> -t "$HOME/.config"

# Remove stowed configuration
stow -D <directory>
```

## Development Workflow

Since this repository uses Git submodules extensively, development typically involves:

1. **Changes to submodules:** Navigate to the specific submodule directory and make changes there
2. **Update parent repository:** After submodule changes, update the parent dotfiles repository to reference the new commits
3. **Test changes:** Use `stow -D` and `stow` to re-link configurations for testing

## Installation Process

The `install.sh` script follows this sequence:
1. Stow the `brew/` directory to place `.Brewfile` in `$HOME`
2. Install Homebrew if it doesn't exist
3. Run `brew bundle` to install all packages
4. Stow all `.config/*` subdirectories to `~/.config/`
5. Stow remaining directories (excluding install.sh, .git, .gitmodules, README.md, .config, and brew) to `$HOME`

## Architecture Notes

- Uses GNU Stow for symbolic link management instead of custom scripts
- Separation of concerns by category (shell, editor, terminal, etc.) via submodules
- Centralized package management through Homebrew Brewfile
- Designed for macOS environments with comprehensive development tooling

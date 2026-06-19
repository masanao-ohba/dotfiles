# dotfiles

Personal dotfiles managed with GNU Stow and Git submodules

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=flat&logo=macos&logoColor=F0F0F0)

## Overview

Modular dotfiles repository for macOS development environment, featuring:

- Configuration management via GNU Stow
- Modular design with Git submodules
- Automated setup with Homebrew
- Configurations for Zsh, Neovim, Wezterm, Starship, Yabai, and more

## Purpose & Philosophy

### Why This Repository?

Setting up a new Mac or recovering from a system failure should be painless. This repository enables:

- **One-command setup** - Run `install.sh` and walk away with a fully configured environment
- **Version-controlled configurations** - Track changes, rollback mistakes, sync across machines
- **Reproducible environment** - Exact same setup on any Mac, every time

### Design Principles

| Principle | Implementation |
|-----------|----------------|
| **Modularity** | Each tool's config is an independent submodule that can evolve separately |
| **Simplicity** | GNU Stow handles symlinks - no custom scripts or complex logic |
| **Declarative** | Brewfile defines all packages; configs define all settings |
| **Minimal coupling** | Components work independently; removing one doesn't break others |

### Architecture Concept

```
~/.dotfiles/           (this repo - orchestration layer)
├── submodule/         (independent config repos)
│   ├── zsh/
│   ├── nvim/
│   └── ...
└── install.sh         (stow + brew = complete setup)
```

The parent repository acts as an **orchestration layer** that:
1. Aggregates independent configuration repositories via submodules
2. Uses GNU Stow to create symlinks to appropriate locations
3. Uses Homebrew to install required packages

Each submodule maintains its own history, allowing focused commits and easier debugging.

## Quick Start

```bash
git clone --recursive <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

| Directory | Description | Type |
|-----------|-------------|------|
| `zsh/` | Zsh shell configuration | submodule |
| `.config/nvim/` | Neovim configuration | submodule |
| `.config/wezterm/` | Wezterm terminal configuration | submodule |
| `.config/starship/` | Starship prompt configuration | submodule |
| `.config/yabai/` | Yabai window manager configuration | submodule |
| `.config/skhd/` | Simple hotkey daemon configuration | submodule |
| `brew/` | Homebrew package definitions | submodule |
| `.claude/` | Claude Code CLI configuration | submodule |

## Installation Process

The `install.sh` script follows this sequence:
1. Stow the `brew/` directory to place `.Brewfile` in `$HOME`
2. Install Homebrew if it doesn't exist
3. Run `brew bundle` to install all packages
4. Stow all `.config/*` subdirectories to `~/.config/`
5. Stow remaining directories to `$HOME`

## Package Management

```bash
# Install/update Homebrew packages
brew bundle --file="$HOME/.Brewfile"

# Update submodules
git submodule update --remote --merge
```

## License

MIT

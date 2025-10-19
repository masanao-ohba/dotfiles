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

#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
WIN_DIR="$REPO_DIR/windows"
HOME_DIR="$HOME"

NVIM_TARGET="$HOME_DIR/AppData/Local/nvim"

link() {
	local src="$1"
	local dest="$2"

	if [ ! -e "$src" ]; then
		echo "  SKIP (source missing): $src"
		return
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
		echo "  BACKUP: $dest -> $backup"
		mv "$dest" "$backup"
	fi

	mkdir -p "$(dirname "$dest")"

	ln -s "$src" "$dest"
	echo "  LINKED: $dest -> $src"
}

echo ""
echo "=== Dotfiles Deploy ==="
echo "Source: $WIN_DIR"
echo "Home:   $HOME_DIR"
echo ""

# shell & git
echo "[shell & git]"
link "$WIN_DIR/.bashrc" "$HOME_DIR/.bashrc"
link "$WIN_DIR/.inputrc" "$HOME_DIR/.inputrc"
link "$WIN_DIR/.gitconfig" "$HOME_DIR/.gitconfig"

# neovim
echo "[neovim]"
link "$WIN_DIR/.config/nvim" "$NVIM_TARGET"

# wezterm
echo "[wezterm]"
link "$WIN_DIR/.config/wezterm" "$HOME_DIR/.config/wezterm"

# komorebi
echo "[komorebi]"
link "$WIN_DIR/.config/komorebi" "$HOME_DIR/.config/komorebi"

# whkd
echo "[whkd]"
link "$WIN_DIR/.config/whkd" "$HOME_DIR/.config/whkd"

# fastfetch
echo "[fastfetch]"
link "$WIN_DIR/.config/fastfetch" "$HOME_DIR/.config/fastfetch"

# TODO: once IT unlocks PATH, add to user PATH:
#   %USERPROFILE%\scoop\shims
#   %USERPROFILE%\scoop\apps\nodejs\current
#   %USERPROFILE%\scoop\apps\git\current\bin
#   %APPDATA%\npm
# Then remove the scoop full path aliases from .bashrc

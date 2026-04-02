#!/bin/bash

# full setup script for Windows machine

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
WIN_DIR="$REPO_DIR/windows"
HOME_DIR="$HOME"

NVIM_TARGET="$HOME_DIR/AppData/Local/nvim"

# --- helpers --------------------------------------------------

link() {
	local src="$1"
	local dest="$2"

	if [ ! -e "$src" ]; then
		echo "  SKIP (source missing): $src"
		return
	fi

	# already correctly linked
	if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
		echo "  OK (already linked): $dest"
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

manual() {
	echo "  [MANUAL] $1"
}

add_to_path() {
	local path_entry="$1"
	local current_path
	current_path=$(powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('PATH', 'User')" 2>/dev/null | tr -d '\r')

	if echo "$current_path" | grep -qi "$(echo "$path_entry" | sed 's/\\/\\\\/g')"; then
		echo "  OK (already in PATH): $path_entry"
	else
		powershell.exe -NoProfile -Command \
			"[Environment]::SetEnvironmentVariable('PATH', [Environment]::GetEnvironmentVariable('PATH', 'User') + ';$path_entry', 'User')" 2>/dev/null
		echo "  ADDED to user PATH: $path_entry"
	fi
}

# --- prerequisites --------------------------------------------

echo ""
echo "========================================"
echo "  Windows Dotfiles Install"
echo "========================================"
echo ""
echo "Source: $WIN_DIR"
echo "Home:   $HOME_DIR"
echo ""

echo "[prerequisites]"
manual "Enable Developer Mode: Settings > For Developers > Developer Mode"
manual "Install Git for Windows: https://git-scm.com/download/win (default install path)"
manual "Install Scoop: irm get.scoop.sh | iex (from PowerShell)"
manual "Install tools: scoop install neovim eza fastfetch mingw nodejs"
manual "Install font: scoop bucket add nerd-fonts && scoop install Noto-NF"
manual "Install Claude Code: ~/scoop/apps/nodejs/current/npm install -g @anthropic-ai/claude-code"
echo ""

read -n 1 -s -r -p "Complete prerequisites above, then press any key to continue..."
echo ""
echo ""

# --- symlinks -------------------------------------------------

echo "[symlinks: shell & git]"
link "$WIN_DIR/.bashrc" "$HOME_DIR/.bashrc"
link "$WIN_DIR/.inputrc" "$HOME_DIR/.inputrc"
link "$WIN_DIR/.gitconfig" "$HOME_DIR/.gitconfig"

echo "[symlinks: neovim]"
link "$WIN_DIR/.config/nvim" "$NVIM_TARGET"

echo "[symlinks: fastfetch]"
link "$WIN_DIR/.config/fastfetch" "$HOME_DIR/.config/fastfetch"

echo "[symlinks: wezterm]"
link "$WIN_DIR/.config/wezterm" "$HOME_DIR/.config/wezterm"

echo "[symlinks: komorebi]"
link "$WIN_DIR/.config/komorebi" "$HOME_DIR/.config/komorebi"

echo "[symlinks: whkd]"
link "$WIN_DIR/.config/whkd" "$HOME_DIR/.config/whkd"

# --- PATH setup -----------------------------------------------

echo ""
echo "[PATH setup]"
add_to_path "%USERPROFILE%\\scoop\\shims"
add_to_path "%USERPROFILE%\\scoop\\apps\\nodejs\\current"
add_to_path "%USERPROFILE%\\AppData\\Local\\Programs\\Git\\bin"
add_to_path "%APPDATA%\\npm"

# --- post-install manual steps --------------------------------

echo ""
echo "[terminal setup]"
manual "Windows Terminal > Settings > Add New Profile > Git Bash"
manual "  Command line: C:/Users/<username>/AppData/Local/Programs/Git/bin/bash.exe --login -i"
manual "  Starting directory: %USERPROFILE%"
manual "  Set as default profile"
manual "  Appearance > Font: NotoSansMono Nerd Font"
manual "  Appearance > Color scheme: add Matugen from windows/.config/windows-terminal/matugen-scheme.json"
manual "  Appearance > Transparency: adjust opacity to taste"
manual "  Settings JSON > add: \"launchMode\": \"focus\""
echo ""

echo "[ssh setup]"
manual "Generate key: ssh-keygen -t ed25519 -C \"your-email@example.com\""
manual "Add public key to GitHub: cat ~/.ssh/id_ed25519.pub"
manual "SSH agent auto-starts via .bashrc, restart bash to verify"
echo ""

echo "[neovim verification]"
manual "Run: nvim"
manual "Lazy.nvim should auto-bootstrap and install all plugins"
manual "Run :checkhealth to verify clipboard, treesitter, providers"
manual "Run :Mason to install LSPs (lua_ls, cssls, omnisharp if needed)"
echo ""

echo "[key swap]"
manual "Mechanical keyboard: swap Alt and Win keys in VIA"
echo ""

echo "[tiling WM]"
manual "Install: scoop bucket add extras && scoop install komorebi whkd"
manual "Install: scoop install wezterm"
manual "Install: scoop install flow-launcher"
manual "Start: komorebic start && whkd"
manual "Add Komorebi + WHKD to Windows startup (shell:startup folder or Task Scheduler)"
echo ""

echo "========================================"
echo "  Done!"
echo "========================================"
echo ""

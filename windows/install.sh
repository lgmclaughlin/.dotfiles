#!/bin/bash

# full setup script for Windows machine

set -e

export MSYS=winsymlinks:nativestrict

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WIN_DIR="$REPO_DIR/windows"
HOME_DIR="$HOME"

NVIM_TARGET="$HOME_DIR/AppData/Local/nvim"
BAK_DIR="$SCRIPT_DIR/bak"

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
		mkdir -p "$BAK_DIR"
		local name
		name="$(basename "$dest")-$(date +%Y%m%d%H%M%S)"
		mv "$dest" "$BAK_DIR/$name"
		echo "  BACKUP: $dest -> $BAK_DIR/$name"
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
link "$WIN_DIR/.gitconfig-personal" "$HOME_DIR/.gitconfig-personal"
link "$WIN_DIR/.gitconfig-work" "$HOME_DIR/.gitconfig-work"

echo "[symlinks: neovim]"
link "$WIN_DIR/.config/nvim" "$NVIM_TARGET"

echo "[symlinks: fastfetch]"
link "$WIN_DIR/.config/fastfetch" "$HOME_DIR/.config/fastfetch"

echo "[symlinks: komorebi]"
link "$WIN_DIR/.config/komorebi" "$HOME_DIR/.config/komorebi"
link "$WIN_DIR/.config/komorebi/komorebi.json" "$HOME_DIR/komorebi.json"

echo "[symlinks: whkd]"
link "$WIN_DIR/.config/whkd/whkdrc" "$HOME_DIR/.config/whkdrc"

echo "[symlinks: yasb]"
link "$WIN_DIR/.config/yasb" "$HOME_DIR/.config/yasb"

echo "[symlinks: glow]"
link "$WIN_DIR/.config/glow/glow.yml" "$LOCALAPPDATA/glow/Config/glow.yml"

echo "[symlinks: zellij]"
mkdir -p "$APPDATA/Zellij/config"
link "$WIN_DIR/.config/zellij/config.kdl" "$APPDATA/Zellij/config/config.kdl"
link "$WIN_DIR/.config/zellij/layouts" "$APPDATA/Zellij/config/layouts"

echo "[symlinks: windows terminal]"
WT_STATE=$(echo "$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_"*/LocalState 2>/dev/null | head -1 | tr '\\' '/')
if [ -d "$WT_STATE" ]; then
  link "$WIN_DIR/.config/windows-terminal/settings.json" "$WT_STATE/settings.json"
else
  echo "  SKIP (Windows Terminal Store package not found)"
fi

# --- scripts --------------------------------------------------

echo ""
echo "[scripts]"
mkdir -p "$HOME_DIR/bin"
for script in "$WIN_DIR/scripts/"*.sh; do
	[ -f "$script" ] || continue
	dest="$HOME_DIR/bin/$(basename "$script" .sh)"
	cp "$script" "$dest"
	chmod +x "$dest"
	echo "  INSTALLED: $dest"
done
for script in "$WIN_DIR/scripts/"*.bat; do
	[ -f "$script" ] || continue
	dest="$HOME_DIR/bin/$(basename "$script")"
	cp "$script" "$dest"
	echo "  INSTALLED: $dest"
done

# --- PATH setup -----------------------------------------------

echo ""
echo "[PATH setup]"
add_to_path "%USERPROFILE%\\scoop\\shims"
add_to_path "%USERPROFILE%\\scoop\\apps\\nodejs\\current"
add_to_path "%USERPROFILE%\\AppData\\Local\\Programs\\Git\\bin"
add_to_path "%APPDATA%\\npm"
add_to_path "%USERPROFILE%\\bin"

# --- post-install manual steps --------------------------------

echo ""
echo "[terminal setup]"
manual "Install Windows Terminal from Microsoft Store if not present"
manual "Settings are managed via symlink — no manual configuration needed"
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
manual "Install: scoop bucket add extras && scoop install komorebi whkd yasb zellij"
manual "Install: scoop install flow-launcher"
manual "Start: komorebic start --whkd && yasb"
echo ""

echo "[startup shortcuts]"
STARTUP_DIR="$HOME_DIR/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
create_shortcut() {
	local name="$1"
	local target="$2"
	local args="${3:-}"
	powershell.exe -NoProfile -Command "
		\$ws = New-Object -ComObject WScript.Shell
		\$s = \$ws.CreateShortcut('$STARTUP_DIR\\$name.lnk')
		\$s.TargetPath = '$target'
		\$s.Arguments = '$args'
		\$s.Save()
	" 2>/dev/null
	echo "  SHORTCUT: $name"
}
create_shortcut "komorebi" "$HOME_DIR\\scoop\\shims\\komorebic.exe" "start --whkd"
create_shortcut "yasb" "$HOME_DIR\\scoop\\shims\\yasb.exe" ""
create_shortcut "Flow.Launcher" "$HOME_DIR\\scoop\\apps\\flow-launcher\\current\\Flow.Launcher.exe" ""
echo ""

echo "========================================"
echo "  Done!"
echo "========================================"
echo ""

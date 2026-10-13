#!/usr/bin/env bash
#
# Shared dotfiles installer. Called by platform install scripts.
#
# Expects:
#   SHARED_DIR  - path to shared/ directory
#   NVIM_TARGET - where nvim config lives on this platform
#   do_link     - function: do_link <src> <dest> (creates symlink)

set -e

echo "[shared: .config]"
do_link "$SHARED_DIR/.config/git" "$HOME/.config/git"
do_link "$SHARED_DIR/.config/glow" "$HOME/.config/glow"
do_link "$SHARED_DIR/.config/word" "$HOME/.config/word"

echo "[shared: neovim]"
mkdir -p "$NVIM_TARGET/lua/custom/plugins"
do_link "$SHARED_DIR/.config/nvim/init.lua" "$NVIM_TARGET/init.lua"
do_link "$SHARED_DIR/.config/nvim/colors" "$NVIM_TARGET/colors"
do_link "$SHARED_DIR/.config/nvim/lua/comments.lua" "$NVIM_TARGET/lua/comments.lua"
do_link "$SHARED_DIR/.config/nvim/lua/devtools.lua" "$NVIM_TARGET/lua/devtools.lua"
do_link "$SHARED_DIR/.config/nvim/lua/kickstart" "$NVIM_TARGET/lua/kickstart"
do_link "$SHARED_DIR/.config/nvim/lua/custom/markdown.lua" "$NVIM_TARGET/lua/custom/markdown.lua"
do_link "$SHARED_DIR/.config/nvim/lua/custom/plugins/init.lua" "$NVIM_TARGET/lua/custom/plugins/init.lua"
do_link "$SHARED_DIR/.config/nvim/lua/custom/plugins/debug.lua" "$NVIM_TARGET/lua/custom/plugins/debug.lua"

echo "[shared: claude]"
mkdir -p "$HOME/.claude"
do_link "$SHARED_DIR/.claude/skills" "$HOME/.claude/skills"

echo "[shared: claude status line]"
mkdir -p "$HOME/.claude/scripts"
do_link "$SHARED_DIR/.claude/scripts/statusline.py" "$HOME/.claude/scripts/statusline.py"

# Claude Code on Windows needs C:/ style paths, so convert Git Bash paths when cygpath exists
statusline_script="$HOME/.claude/scripts/statusline.py"
settings_file="$HOME/.claude/settings.json"
register_script="$SHARED_DIR/.claude/scripts/register_statusline.py"
if command -v cygpath >/dev/null 2>&1; then
	statusline_script="$(cygpath -m "$statusline_script")"
	settings_file="$(cygpath -m "$settings_file")"
	register_script="$(cygpath -m "$register_script")"
fi

python_bin="$(command -v python3 || command -v python || true)"
if [ -n "$python_bin" ]; then
	"$python_bin" "$register_script" "$settings_file" "$statusline_script"
else
	echo "  SKIP (python not found): statusLine not registered in $settings_file"
fi

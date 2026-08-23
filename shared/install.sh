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
do_link "$SHARED_DIR/.claude/common" "$HOME/.claude/common"

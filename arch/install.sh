#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SHARED_DIR="$REPO_DIR/shared"
ARCH_DIR="$REPO_DIR/arch"

# shared config ------------------------------------------------

echo "Linking shared configs..."

ln -sfn "$SHARED_DIR/.config/git" "$HOME/.config/git"
ln -sfn "$SHARED_DIR/.config/glow" "$HOME/.config/glow"
ln -sfn "$SHARED_DIR/.config/word" "$HOME/.config/word"

echo "Linking shared nvim config..."

mkdir -p "$HOME/.config/nvim/lua/custom/plugins"
ln -sf "$SHARED_DIR/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sfn "$SHARED_DIR/.config/nvim/colors" "$HOME/.config/nvim/colors"
ln -sf "$SHARED_DIR/.config/nvim/lua/comments.lua" "$HOME/.config/nvim/lua/comments.lua"
ln -sf "$SHARED_DIR/.config/nvim/lua/devtools.lua" "$HOME/.config/nvim/lua/devtools.lua"
ln -sfn "$SHARED_DIR/.config/nvim/lua/kickstart" "$HOME/.config/nvim/lua/kickstart"
ln -sf "$SHARED_DIR/.config/nvim/lua/custom/markdown.lua" "$HOME/.config/nvim/lua/custom/markdown.lua"
ln -sf "$SHARED_DIR/.config/nvim/lua/custom/plugins/init.lua" "$HOME/.config/nvim/lua/custom/plugins/init.lua"
ln -sf "$SHARED_DIR/.config/nvim/lua/custom/plugins/debug.lua" "$HOME/.config/nvim/lua/custom/plugins/debug.lua"

echo "Linking arch-specific nvim plugins..."

for f in "$ARCH_DIR/.config/nvim/lua/custom/plugins/"*.lua; do
	[ -f "$f" ] || continue
	ln -sf "$f" "$HOME/.config/nvim/lua/custom/plugins/$(basename "$f")"
	echo "  LINKED: $(basename "$f")"
done

echo "Done."

# timesyncd ---------------------------------------------------

echo "Setting up timesync..."

sudo mkdir -p /etc/systemd/
sudo cp install/timesyncd.conf /etc/systemd/timesyncd.conf
sudo chmod 644 /etc/systemd/timesyncd.conf
sudo timedatectl set-timezone America/Los_Angeles
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
sleep 5

echo "Done."

# wlsunset ----------------------------------------------------

set -e

echo "Installing wlsunset systemd user service..."

systemctl --user daemon-reload
systemctl --user enable --now wlsunset.service
systemctl --user status --no-pager wlsunset.service

echo "Done."

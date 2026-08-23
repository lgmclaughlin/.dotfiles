#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SHARED_DIR="$REPO_DIR/shared"
ARCH_DIR="$REPO_DIR/arch"

# shared config ------------------------------------------------

NVIM_TARGET="$HOME/.config/nvim"

do_link() { ln -sfn "$1" "$2"; }
source "$SHARED_DIR/install.sh"

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

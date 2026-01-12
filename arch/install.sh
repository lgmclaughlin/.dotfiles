#!/usr/bin/env bash

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

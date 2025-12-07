#!/usr/bin/env bash

set -e

echo "Installing wlsunset systemd user service..."

systemctl --user daemon-reload

systemctl --user enable --now wlsunset.service

echo "Done!"
systemctl --user status --no-pager wlsunset.service

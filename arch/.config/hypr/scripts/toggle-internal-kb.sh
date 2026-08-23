#!/usr/bin/env bash

KB="at-translated-set-2-keyboard"
TP="tpps/2-elan-trackpoint"
STATEFILE="/tmp/internal-kb-disabled"

if [ -f "$STATEFILE" ]; then
    hyprctl keyword "device[$KB]:enabled" true
    hyprctl keyword "device[$TP]:enabled" true
    rm "$STATEFILE"
    notify-send "Internal Keyboard" "Unlocked"
else
    hyprctl keyword "device[$KB]:enabled" false
    hyprctl keyword "device[$TP]:enabled" false
    touch "$STATEFILE"
    notify-send "Internal Keyboard" "Locked"
fi

#!/bin/bash

RES=$1
SCALE=$2

MONITOR_COUNT=$(hyprctl monitors -j | jq '. | length')

if [ "$MONITOR_COUNT" -le 1 ]; then
	systemctl suspend
elif [ -n "$RES" ] && [ -n "$SCALE" ]; then
	hyprctl keyword monitor eDP-1, "$RES", 0x0, "$SCALE"
fi

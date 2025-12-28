#!/bin/bash

THRESHOLD=8
FLAG_FILE="/tmp/battery_suspend_flag"

BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$THRESHOLD" ]; then
    if [ ! -f "$FLAG_FILE" ]; then
        notify-send -u critical "Battery Low" "System will suspend in 30 seconds unless plugged in."
        sleep 30

        RECHECK_STATUS=$(cat "$BAT_PATH/status")
        if [ "$RECHECK_STATUS" = "Discharging" ]; then
            touch "$FLAG_FILE"
            systemctl suspend
        fi
    fi
elif [ "$STATUS" != "Discharging" ] || [ "$CAPACITY" -gt "$THRESHOLD" ]; then
    [ -f "$FLAG_FILE" ] && rm "$FLAG_FILE"
fi

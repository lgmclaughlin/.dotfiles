#!/bin/bash

ACTION="$1"
INTERNAL_MON="$2"
EXTERNAL_MON="$3"
INTERNAL_RES="$4"
INTERNAL_SCALE="$5"
EXTERNAL_RES="$6"
EXTERNAL_SCALE="$7"

get_monitor_count() {
    hyprctl monitors all -j | jq '. | length'
}

case "$ACTION" in
    close)
        if [ "$(get_monitor_count)" -gt 1 ]; then
            hyprctl keyword monitor "$INTERNAL_MON", "$EXTERNAL_RES", 0x0, "$EXTERNAL_SCALE"
        else
            systemctl suspend
        fi
        ;;
    open)
    	hyprctl keyword monitor "$INTERNAL_MON", "$INTERNAL_RES", 0x0, "$INTERNAL_SCALE"
        ;;
esac

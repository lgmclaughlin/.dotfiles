#!/bin/bash

DEVICE="mx-ergo-s-mouse"
DEFAULT_SENS="0.0"

usage() {
    echo "Usage: $0 [sensitivity]"
    echo "  sensitivity: float (e.g. 0.5, 1.0, -0.8)"
    exit 1
}

if [ "$#" -gt 1 ]; then
    usage
fi

if [ -n "$1" ]; then
    if ! [[ "$1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        usage
    fi
    hyprctl keyword "device[$DEVICE]:sensitivity" "$1"
    YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool click 0x40
else
    hyprctl keyword "device[$DEVICE]:sensitivity" "$DEFAULT_SENS"
    YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool click 0x80
fi

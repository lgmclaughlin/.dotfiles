#!/bin/bash

DATA_DIR="$HOME/.remind"

usage() {
    echo "Usage:"
    echo "  remind start <action> <increment>   Start a reminder"
    echo "  remind stop <action>                Stop a reminder"
    echo "  remind list                          Show active reminders"
    echo ""
    echo "  <action>     Name (e.g. Move, RestEyes)"
    echo "  <increment>  Interval: 20m, 1h, 1.5h"
    echo ""
    echo "Reminders fire on clock-aligned boundaries and stop at midnight."
}

to_minutes() {
    local inc="$1"
    if [[ "$inc" =~ ^([0-9]+\.?[0-9]*)h$ ]]; then
        awk "BEGIN {printf \"%g\", ${BASH_REMATCH[1]} * 60}"
    elif [[ "$inc" =~ ^([0-9]+\.?[0-9]*)m$ ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "Bad increment: $inc. Use 20m, 1h, 1.5h, etc." >&2
        return 1
    fi
}

to_seconds() {
    local mins="$1"
    awk "BEGIN {printf \"%d\", $mins * 60}"
}

next_trigger_epoch() {
    local interval_mins="$1"
    local now_epoch
    now_epoch=$(date +%s)
    local midnight_epoch
    midnight_epoch=$(date -d "tomorrow 00:00" +%s 2>/dev/null)
    if [[ -z "$midnight_epoch" ]]; then
        # msys/git-bash: date -d not always available, compute manually
        local h m s
        h=$(date +%H); m=$(date +%M); s=$(date +%S)
        h=$((10#$h)); m=$((10#$m)); s=$((10#$s))
        local secs_left=$(( (23 - h) * 3600 + (59 - m) * 60 + (60 - s) ))
        midnight_epoch=$(( now_epoch + secs_left ))
    fi

    local interval_secs
    interval_secs=$(to_seconds "$interval_mins")
    local day_start_epoch
    day_start_epoch=$(( midnight_epoch - 86400 ))
    local elapsed=$(( now_epoch - day_start_epoch ))
    local remainder=$(( elapsed % interval_secs ))

    local next_epoch
    if [[ "$remainder" -lt 2 ]]; then
        next_epoch=$(( now_epoch + interval_secs - remainder ))
    else
        next_epoch=$(( now_epoch + interval_secs - remainder ))
    fi

    if [[ "$next_epoch" -ge "$midnight_epoch" ]]; then
        echo ""
        return 1
    fi
    echo "$next_epoch"
}

format_time() {
    date -d "@$1" +"%l:%M %p" 2>/dev/null || date -r "$1" +"%l:%M %p" 2>/dev/null
}

send_notification() {
    local action="$1"
    local title="Reminder"
    local body="Time to $action!"

    if command -v powershell.exe &>/dev/null; then
        powershell.exe -NoProfile -Command "[System.Media.SystemSounds]::Exclamation.Play()" &>/dev/null
        powershell.exe -NoProfile -Command "
            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
            \$i = New-Object System.Windows.Forms.NotifyIcon
            \$i.Icon = [System.Drawing.SystemIcons]::Information
            \$i.BalloonTipTitle = '$title'
            \$i.BalloonTipText = '$body'
            \$i.Visible = \$true
            \$i.ShowBalloonTip(10000)
            Start-Sleep -Seconds 12
            \$i.Visible = \$false
            \$i.Dispose()
        " &>/dev/null &
    elif command -v notify-send &>/dev/null; then
        notify-send "$title" "$body"
        if command -v paplay &>/dev/null; then
            paplay /usr/share/sounds/freedesktop/stereo/message.oga &>/dev/null &
        elif command -v aplay &>/dev/null; then
            aplay /usr/share/sounds/freedesktop/stereo/message.oga &>/dev/null &
        fi
    else
        echo -e "\a"
        echo "[$title] $body"
    fi
}

do_start() {
    local action="$1"
    local increment="$2"
    if [[ -z "$action" || -z "$increment" ]]; then usage; return 1; fi

    mkdir -p "$DATA_DIR"
    local pidfile="$DATA_DIR/$action.pid"

    if [[ -f "$pidfile" ]]; then
        local stored_pid
        stored_pid=$(cut -d'|' -f1 "$pidfile")
        if kill -0 "$stored_pid" 2>/dev/null; then
            echo "'$action' already running (PID $stored_pid)."
            return 1
        fi
        rm -f "$pidfile"
    fi

    local mins
    mins=$(to_minutes "$increment") || return 1

    local next
    next=$(next_trigger_epoch "$mins")
    if [[ -z "$next" ]]; then
        echo "No triggers left before midnight."
        return 1
    fi

    local script_path
    script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    nohup bash "$script_path" _daemon "$action" "$increment" </dev/null &>/dev/null &
    local daemon_pid=$!
    echo "$daemon_pid|$increment" > "$pidfile"

    local next_fmt
    next_fmt=$(format_time "$next")
    echo "Started '$action' every $increment. Next:$next_fmt. Stops at midnight."
}

do_stop() {
    local action="$1"
    if [[ -z "$action" ]]; then usage; return 1; fi

    local pidfile="$DATA_DIR/$action.pid"
    if [[ ! -f "$pidfile" ]]; then
        echo "No active '$action' reminder."
        return 1
    fi

    local stored_pid
    stored_pid=$(cut -d'|' -f1 "$pidfile")
    kill "$stored_pid" 2>/dev/null
    rm -f "$pidfile"
    echo "Stopped '$action'."
}

do_list() {
    if [[ ! -d "$DATA_DIR" ]]; then echo "No active reminders."; return; fi

    local files=("$DATA_DIR"/*.pid)
    if [[ ! -f "${files[0]}" ]]; then echo "No active reminders."; return; fi

    echo "Active reminders:"
    for f in "${files[@]}"; do
        local name
        name=$(basename "$f" .pid)
        local content
        content=$(cat "$f")
        local stored_pid inc
        stored_pid=$(echo "$content" | cut -d'|' -f1)
        inc=$(echo "$content" | cut -d'|' -f2)

        if kill -0 "$stored_pid" 2>/dev/null; then
            local mins next next_fmt
            mins=$(to_minutes "$inc")
            next=$(next_trigger_epoch "$mins")
            if [[ -n "$next" ]]; then
                next_fmt=$(format_time "$next")
                echo "  $name  every $inc  next:$next_fmt  (PID $stored_pid)"
            else
                echo "  $name  every $inc  next: done  (PID $stored_pid)"
            fi
        else
            echo "  $name  (stopped)"
            rm -f "$f"
        fi
    done
}

run_daemon() {
    local action="$1"
    local increment="$2"
    local mins
    mins=$(to_minutes "$increment")
    local start_day
    start_day=$(date +%Y-%m-%d)

    while true; do
        local today
        today=$(date +%Y-%m-%d)
        if [[ "$today" != "$start_day" ]]; then break; fi

        local next
        next=$(next_trigger_epoch "$mins")
        if [[ -z "$next" ]]; then break; fi

        local now_epoch wait
        now_epoch=$(date +%s)
        wait=$(( next - now_epoch ))
        if [[ "$wait" -gt 0 ]]; then sleep "$wait"; fi

        today=$(date +%Y-%m-%d)
        if [[ "$today" != "$start_day" ]]; then break; fi

        send_notification "$action"
    done

    local pidfile="$DATA_DIR/$action.pid"
    rm -f "$pidfile"
}

case "${1:-}" in
    start)   do_start "$2" "$3" ;;
    stop)    do_stop "$2" ;;
    list)    do_list ;;
    _daemon) run_daemon "$2" "$3" ;;
    *)       usage ;;
esac

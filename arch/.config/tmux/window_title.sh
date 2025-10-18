#!/usr/bin/env bash

# param -------------------------------------------------------

WINDOW_ID=$1

# get active --------------------------------------------------

ACTIVE_PANE=$(tmux list-panes -F "#{pane_id} #{window_id} #{pane_current_path} #{pane_current_command}" | awk -v win="$WINDOW_ID" '$2==win {print $1; exit}')

CMD=$(tmux display-message -p -t "$ACTIVE_PANE" "#{pane_current_command}")
PATH=$(tmux display-message -p -t "$ACTIVE_PANE" "#{pane_current_path}")

# set window title ---------------------------------------------

if [[ "$CMD" == "nvim" ]]; then
    nvim_file=$(tmux display-message -p -t "$ACTIVE_PANE" "#{pane_current_path}/#{pane_title}")
    echo "$nvim_file"
else
    echo "${PATH##*/}"
fi

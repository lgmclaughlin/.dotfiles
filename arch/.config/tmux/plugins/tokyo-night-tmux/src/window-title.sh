#!/usr/bin/env bash

pane_id="$1"
path="$2"
cmd=$(tmux display-message -p -t "$pane_id" "#{pane_current_command}")

if [ "$cmd" = "nvim" ]; then
  tmux display-message -p -t "$pane_id" "#{pane_title}"
elif [[ "$cmd" == "bash" || "$cmd" == "zsh" || "$cmd" == "fish" ]]; then
  if [ "$path" == "/home/lgm" ]; then
    title="~"
  elif [ "$path" == "/" ]; then
    title="/"
  else
    title="/$(basename "$path")"
  fi
  echo "$title"
else
  tmux display-message -p "#W"
fi

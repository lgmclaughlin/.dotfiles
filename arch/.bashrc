# if not interactive, return

[[ $- != *i* ]] && return

# aliases

alias ls='exa -lah --group-directories-first'
alias grep='grep --color=auto'
alias v='nvim'

# autorun

fastfetch

export EXA_COLORS="\
	di=38;5;31:\
	ln=38;5;38:\
	ex=38;5;117:\
	*.sh=38;5;117:\
	fi=38;5;195"

# setup pre-command for pwd printing

__is_first_prompt=true

precmd() {
	if [ "$__is_first_prompt" = true ]; then
		__is_first_prompt=false
		return
	fi

	local dir="$PWD"

	if [[ "$dir" == "$HOME" ]]; then
		echo -e "\n~"
	elif [[ "$dir" == "$HOME"* ]]; then
		dir="${dir#$HOME/}"
		echo -e "\n$dir"
	else
		dir="${dir#/}"
		echo -e "\n$dir"
	fi
}

PROMPT_COMMAND=precmd

# custom commands

clear() {
	command clear
	fastfetch
	__is_first_prompt=true
}

o() {
	if [ $# -lt 1 ]; then
		echo "Usage: o <app> [workspace_number] [options...]"
		return 1
	fi

	local app="$1"
	shift

	local workspace=""
	local options=()

	if [[ "$1" =~ ^[0-9]+$ ]]; then
		workspace="$1"
		shift
	fi

	options=("$@")

	if [ -z "$workspace" ]; then
		hyprctl dispatch workspace +1
	else
		hyprctl dispatch workspace "$workspace"
	fi

	nohup "$app" "${options[@]}" >/dev/null 2>&1 &
	disown
}

# prompt string

PS1="$ "

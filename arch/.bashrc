# check interactive -------------------------------------------

[[ $- != *i* ]] && return

# export ------------------------------------------------------

export PATH="/usr/lib/ccache/bin/:$PATH"
export PATH="$PATH:$HOME/.local/bin/"

# aliases -----------------------------------------------------

alias c='clear'
alias ls='exa -la --group-directories-first'
alias lt='exa -a --no-header --tree --level=1'
alias grep='grep --color=auto'

alias v='nvim'

alias gs='git status'
alias gr='git restore'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gcl='git clone'

alias db='dotnet build'
alias dr='dotnet run'
alias dt='dotnet test'

alias t='tmux'
alias tl='tmux ls'
alias ta='tmux a'
alias tn='tmux new -s'
alias tat='tmux a -t'
alias tk='tmux kill-session -t'

alias sp='spotify_player'

# autorun -----------------------------------------------------

fastfetch

export EXA_COLORS="\
	di=38;5;31:\
	ln=38;5;38:\
	ex=38;5;117:\
	*.sh=38;5;117:\
	fi=38;5;195"

# precmd -------------------------------------------------

__is_first_prompt=true

precmd() {
	local dir="${PWD#$HOME/}"

	if [[ "$__is_first_prompt" = true ]]; then
		__is_first_prompt=false
		if [[ ! "$dir" == "$HOME" ]]; then
			echo -e "$dir"
		fi
		return
	fi


	if [[ "$dir" == "$HOME" ]]; then
		echo -e "\n~"
	elif [[ "$dir" == "$HOME"* ]]; then
		dir="$dir"
		echo -e "\n$dir"
	else
		dir="${dir#/}"
		echo -e "\n$dir"
	fi
}

PROMPT_COMMAND=precmd

# custom commands ---------------------------------------------

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

tln() {
	if [ -z "$1" ]; then
		echo "Usage: tln <session_name>"
		return 1
	fi

	local name="$1"
	local conf="$HOME/.config/tmux/tmux.conf"

	tmux -L "$name" -f "$conf" new -As "$name" 2>/dev/null || echo "No tmux server found for socket '$name'"
}

tll () {
	if [ -z "$1" ]; then
		echo "Usage: tll <session_name>"
		return 1
	fi

	local name="$1"

	tmux -L "$name" ls 2>/dev/null || echo "No tmux server found for socket '$name'"
}

tla () {
	if [ -z "$1" ]; then
		echo "Usage: tla <session_name>"
		return 1
	fi

	local name="$1"

	tmux -L "$name" attach 2>/dev/null || echo "No tmux server found for socket '$name'"
}

tlk () {
	if [ -z "$1" ]; then
		echo "Usage: tlk <session_name>"
		return 1
	fi

	local name="$1"

	tmux -L "$name" kill-server 2>/dev/null || echo "No tmux server found for socket '$name'"
}

tclearsaves () {
	command rm -rf ~/.tmux/session-saves/*
}

# prompt str --------------------------------------------------

PS1="$ "

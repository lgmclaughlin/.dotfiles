# check interactive -------------------------------------------

[[ $- != *i* ]] && return

# export ------------------------------------------------------

export PATH="/usr/lib/ccache/bin/:$PATH"
export PATH="$PATH:$HOME/.local/bin/"
export HYPRSHOT_DIR=/home/lgm/pictures/

# aliases -----------------------------------------------------

alias c='clear'

alias ls='exa -la --group-directories-first'
alias lst='exa -a --tree --group-directories-first'
alias lstg='exa -a --tree --git-ignore --group-directories-first'

alias grp='grep --color=auto'
alias grpr='grep -r --color=auto'

alias v='nvim'

alias t='tmux'
alias tl='tmux ls'
alias ta='tmux a'
alias tn='tmux new -s'
alias tat='tmux a -t'
alias tk='tmux kill-session -t'

alias gs='git status'
alias gr='git restore'
alias grs='git restore --staged'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gcl='git clone'
alias gl='git log'

alias db='dotnet build'
alias dr='dotnet run'
alias dt='dotnet test'

alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias deeww='docker compose -p epicww exec sandbox bash -lc "bash"'

alias ewwssh='ssh -i ~/.ssh/bluehost_epicww epicwood@162.241.218.139'
alias ewwcd='cd ~/dev/web/epicww/staging/5658'
alias ewwtcd='cd ~/dev/web/epicww/staging/5658/workspace/wp-content/themes/epicww/'
alias ewwst='ewwcd && ./setup/start.sh'

alias sbcd='cd ~/dev/git/personal/sandbox/'
alias sblcd='cd ~/.local/share/sandbox/logs/'
alias sbpcd='cd ~/.local/share/sandbox/projects/'
alias sbcl='rm -rf ~/.local/share/sandbox/logs/commands/* && rm -rf ~/.local/share/sandbox/logs/sessions/* && rm -rf ~/.local/share/sandbox/projects/*/logs/commands/* && rm -rf ~/.local/share/sandbox/projects/*/logs/sessions/*'

alias tws='timew summary'
alias twsa='timew summary :all'
alias twsw='timew summary :week'
alias twst='timew start'
alias twstp='timew stop'
alias twsr='timew retag'
alias twts='twt -t Scale'
alias twte='twt -t EpicWW'

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

## twt - shorthand for timew track with relative day offsets
## usage: twt [-t tag ...] <days_ago> <HHMM> - <days_ago> <HHMM>
twt() {
	local tags=()

	while [[ "$1" == "-t" ]]; do
		shift
		while [[ $# -gt 0 && "$1" != "-t" && "$1" != "-" && ! "$1" =~ ^[0-9]+$ ]]; do
			tags+=("$1")
			shift
		done
	done

	local days_start="$1"
	local time_start="$2"
	shift 2

	[[ "$1" == "-" ]] && shift

	local days_end="$1"
	local time_end="$2"

	local start end

	if [[ "$days_start" -eq 0 ]]; then
		start="$time_start"
	else
		start="$(date -d "-${days_start} days" +%Y%m%d)T${time_start}"
	fi

	if [[ "$days_end" -eq 0 ]]; then
		end="$time_end"
	else
		end="$(date -d "-${days_end} days" +%Y%m%d)T${time_end}"
	fi

	timew track "$start" - "$end" "${tags[@]}"
}

# prompt str --------------------------------------------------

# PS1="$ "
PS1='\[\033[38;2;255;255;255;48;2;255;40;40m\]  $ \[\033[0m\] '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

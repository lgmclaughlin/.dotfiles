# check interactive -------------------------------------------

[[ $- != *i* ]] && return

# ssh agent ---------------------------------------------------

env=~/.ssh/agent.env
agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }
agent_start () {
	(umask 077; ssh-agent >| "$env")
	. "$env" >| /dev/null ;
}
agent_load_env
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
	agent_start
	ssh-add ~/.ssh/ed25519_scale
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
	ssh-add ~/.ssh/ed25519_scale
fi
unset env

# export ------------------------------------------------------

# TODO: update username
export PATH="$HOME/scoop/shims:$PATH"
export PATH="$HOME/scoop/apps/nodejs/current:$PATH"
export PATH="$HOME/scoop/persist/nodejs/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin/"

# aliases -----------------------------------------------------

alias c='clear'

alias ls='eza -la --group-directories-first'
alias lst='eza -a --tree --group-directories-first'
alias lstg='eza -a --tree --git-ignore --group-directories-first'

alias grp='grep --color=auto'
alias grpr='grep -r --color=auto'

alias v='nvim'

# scoop full paths (workaround for PATH restrictions)
# TODO: remove these once PATH is unlocked by IT
alias npm='~/scoop/apps/nodejs/current/npm'
alias node='~/scoop/apps/nodejs/current/node'
alias claude='~/scoop/persist/nodejs/bin/claude'

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

# TODO: update project-specific aliases with Windows paths
# alias sbcd='cd ~/dev/git/personal/sandbox/'

alias tws='timew summary'
alias twsa='timew summary :all'
alias twsw='timew summary :week'
alias twst='timew start'
alias twstp='timew stop'
alias twsr='timew retag'
alias twts='twt -t Scale'
alias twte='twt -t EpicWW'

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

PS1='\[\033[38;2;255;255;255;48;2;255;40;40m\]  $ \[\033[0m\] '

# fnm (fast node manager) ------------------------------------
# TODO: uncomment after installing fnm (scoop install fnm)
# eval "$(fnm env --use-on-cd)"

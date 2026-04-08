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
	ssh-add ~/.ssh/ed25519_lgmclaughlin
	ssh-add ~/.ssh/ed25519_lgmclaughlin-scale
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
	ssh-add ~/.ssh/ed25519_lgmclaughlin
	ssh-add ~/.ssh/ed25519_lgmclaughlin-scale
fi
unset env

# export ------------------------------------------------------

export PATH="$HOME/scoop/shims:$PATH"
export PATH="$HOME/AppData/Local/Programs/Git/usr/bin:$PATH"
export PATH="$HOME/AppData/Local/Programs/Git/bin:$PATH"
export SHELL="$HOME/AppData/Local/Programs/Git/bin/bash.exe"
export PATH="$HOME/scoop/apps/nodejs/current:$PATH"
export PATH="$HOME/scoop/persist/nodejs/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$LOCALAPPDATA/cframe/bin/"

# aliases -----------------------------------------------------

alias c='clear'

alias ls='eza -la --group-directories-first'
alias lst='eza -a --tree --group-directories-first'
alias lstg='eza -a --tree --git-ignore --group-directories-first'

alias grp='grep --color=auto'
alias grpr='grep -r --color=auto'

alias tk='taskkill //f //im'

alias v='nvim'

alias p='pandoc -f markdown+hard_line_breaks'

alias tz='tar -a -c -f'
alias tgz='tar -zcvf'

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

alias cr='claude --resume'
alias cm='claude --model claude-opus-4-5-20251101'
alias cmr='claude --model claude-opus-4-5-20251101 --resume'

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

present() {
	local md="$1"
	local tmp
	tmp=$(mktemp /tmp/present_XXXXXX.docx)
	awk '/^\|/ && prev != "" && prev !~ /^\|/ { print "" } { print; prev = $0 }' "$md" \
		| pandoc -f markdown -o "$tmp" --wrap=none --columns=200
	powershell.exe -NoProfile -Command "Start-Process -FilePath '$(cygpath -w "$tmp")' -Wait"
	rm -f "$tmp"
}

# zellij session management ----------------------------------

zln() {
	if [ -z "$1" ]; then
		echo "Usage: zln <session_name>"
		return 1
	fi
	zellij attach --create "$1"
}

znt() {
	zellij action new-tab --cwd "$(cygpath -w "$PWD")"
}

zll() {
	zellij list-sessions 2>/dev/null || echo "No active zellij sessions"
}

zlc() {
	if [ "$1" = "--all" ]; then
		zellij kill-all-sessions > /dev/null 2>&1
		rm -rf "$LOCALAPPDATA/Zellij/cache/contract_version_1/session_info/"*
		echo "Cleared all session caches"
		return
	fi
	local session="${1:-main}"
	local cache_dir="$LOCALAPPDATA/Zellij/cache/contract_version_1/session_info/$session"
	if [ -d "$cache_dir" ]; then
		zellij kill-session "$session" > /dev/null 2>&1
		rm -rf "$cache_dir"
		echo "Cleared cache for session: $session"
	else
		echo "No cache found for session: $session"
	fi
}

# prompt str --------------------------------------------------

nvim() {
    if [ -n "$ZELLIJ" ] && [ -n "$1" ]; then
        (zellij action rename-tab "${1##*/}" &>/dev/null &)
    fi
    command nvim "$@"
}

_zellij_sync() {
    local name="${PWD##*/}"
    [ "$PWD" = "$HOME" ] && name="~"
    (zellij action rename-tab "$name" &>/dev/null &)
}

if [ -n "$ZELLIJ" ]; then
    if [[ ! "$PROMPT_COMMAND" =~ _zellij_sync ]]; then
        PROMPT_COMMAND="_zellij_sync${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    fi
fi

PS1='\[\033[38;2;255;255;255;48;2;255;40;40m\]  $ \[\033[0m\] '

# fnm (fast node manager) ------------------------------------
# TODO: uncomment after installing fnm (scoop install fnm)
# eval "$(fnm env --use-on-cd)"

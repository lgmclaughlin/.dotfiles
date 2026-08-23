# check interactive -------------------------------------------

[[ $- != *i* ]] && return

# local overrides (secrets, machine-specific config) ----------

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

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

export MSYS=winsymlinks:nativestrict
export PATH="$HOME/scoop/shims:$PATH"
export PATH="$HOME/AppData/Local/Programs/Git/usr/bin:$PATH"
export PATH="$HOME/AppData/Local/Programs/Git/bin:$PATH"
export SHELL="$HOME/AppData/Local/Programs/Git/bin/bash.exe"
export PATH="$HOME/scoop/apps/nodejs/current:$PATH"
export PATH="$HOME/scoop/apps/postgresql/18.3/bin:$PATH"
export PATH="$HOME/scoop/persist/nodejs/bin:$PATH"
export PATH="$HOME/AppData/Roaming/Python/Scripts:$PATH"
export PATH="$PATH:C:\Tools\SysInternals"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$LOCALAPPDATA/cframe/bin/"
export PATH="$PATH:C:\Program Files (x86)\cloudflared"
export PATH="$PATH:C:\Program Files\qView"
export PYENV="$HOME/.pyenv/pyenv-win"
export PYENV_HOME="$PYENV"
export PATH="$PYENV/bin:$PYENV/shims:$PATH"

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

alias qv='qview'

# scoop full paths (workaround for PATH restrictions)
# TODO: remove these once PATH is unlocked by IT
# alias npm='~/scoop/apps/nodejs/current/npm'
# alias node='~/scoop/apps/nodejs/current/node'
# alias claude='~/scoop/persist/nodejs/bin/claude'

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
alias glo='git log --oneline'

alias sad='komorebic stop; shopify app dev;'

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
alias cm='claude --model claude-opus-4-6'
alias cmn='claude --model claude-opus-4-6 --name'
alias cmr='claude --model claude-opus-4-6 --resume'

alias pcd='cd ~/projects/'

alias ccd='cd ~/projects/cerebro-agent-redesign/'

alias prcd='cd ~/projects/prc'

alias scd='cd ~/projects/sigma-port/'

alias rd='v ~/Documents/projects/.priority/RUNDOWN.md'

alias pv='.venv/Scripts/python.exe'

pgoc() {
  local role="${1:-tally}"
  local host="scale-ops-db.cluster-cmoaqcnataer.us-east-1.rds.amazonaws.com"
  local secret_id user pass

  case "$role" in
    admin)
      secret_id="rds!cluster-c6248435-ef9f-4ef9-a197-d5ec4d24f49c"
      ;;
    tally)
      secret_id="tally/prod/db-credentials"
      ;;
    tally-dev)
      secret_id="tally/dev/db-credentials"
      ;;
    *)
      echo "Unknown role: $role (use admin, tally, or tally-dev)"
      return 1
      ;;
  esac

  local secret
  secret=$(aws secretsmanager get-secret-value \
    --secret-id "$secret_id" \
    --query "SecretString" --output text \
    --region us-east-1) || return 1

  if [[ "$secret" == postgresql://* ]]; then
    export PGDSN="$secret"
  else
    user=$(echo "$secret" | python -c "import sys,json; print(json.load(sys.stdin)['username'])")
    pass=$(echo "$secret" | python -c "import sys,json; import urllib.parse; print(urllib.parse.quote(json.load(sys.stdin)['password'], safe=''))")
    export PGDSN="postgresql://${user}:${pass}@${host}:5432/scale_ops?sslmode=require"
  fi

  echo "PGDSN set for ${role} (${user:-dsn})"
  PAGER=less psql "$PGDSN"
}

pgic() {
  local role="${1:-cerebro}"
  local host="scale-internal-tools-db.cmoaqcnataer.us-east-1.rds.amazonaws.com"
  local secret_id

  case "$role" in
    cerebro)
      secret_id="cerebro/prod/db-credentials"
      ;;
    cerebro-dev)
      secret_id="cerebro/dev/db-credentials"
      ;;
    sentrack)
      secret_id="sentrack/db-credentials"
      ;;
    *)
      echo "Unknown role: $role (use cerebro, cerebro-dev, or sentrack)"
      return 1
      ;;
  esac

  local secret
  secret=$(aws secretsmanager get-secret-value \
    --secret-id "$secret_id" \
    --query "SecretString" --output text \
    --region us-east-1) || return 1

  local user pass db
  user=$(echo "$secret" | python -c "import sys,json; print(json.load(sys.stdin)['username'])")
  pass=$(echo "$secret" | python -c "import sys,json; import urllib.parse; print(urllib.parse.quote(json.load(sys.stdin)['password'], safe=''))")
  db=$(echo "$secret" | python -c "import sys,json; print(json.load(sys.stdin)['database'])")
  export PGDSN="postgresql://${user}:${pass}@${host}:5432/${db}?sslmode=require"

  echo "PGDSN set for ${role} (${user}@${db})"
  PAGER=less psql "$PGDSN"
}

pgi() {
  pg_ctl init -D "$HOME/scoop/apps/postgresql/18.3/data"
}

pgst() {
  pg_ctl start -D "$HOME/scoop/apps/postgresql/18.3/data"
}

pgc() {
  local db="${1:-scamdalf}"
  psql -d "$db"
}

pgoq() {
  if [[ -z "$PGDSN" ]]; then
    echo "Run pgoc first to connect"
    return 1
  fi
  psql "$PGDSN" -c "$1"
}

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
	awk '/^\|/ && prev != "" && prev !~ /^\|/ { print "" } /^[[:space:]]*(-|[0-9]+\.)/ && prev != "" && prev !~ /^[[:space:]]*(-|[0-9]+\.)/ && prev !~ /^$/ { print "" } { print; prev = $0 }' "$md" \
		| pandoc -f markdown -o "$tmp" --wrap=none --columns=200 --reference-doc="$HOME/.config/word/template.docx"
	powershell.exe -NoProfile -Command "Start-Process -FilePath '$(cygpath -w "$tmp")' -Wait"
	rm -f "$tmp"
}

makemd() {
	local docx="$1"
	local out="${2:-${docx%.docx}.md}"
	pandoc -f docx -t markdown --wrap=none "$docx" -o "$out"
	echo "Wrote $out"
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
		rm -rf "$LOCALAPPDATA/Temp/zellij/contract_version_1/"*
		echo "Cleared all sessions"
		return
	fi
	local session="${1:-main}"
	zellij kill-session "$session" > /dev/null 2>&1
	rm -rf "$LOCALAPPDATA/Zellij/cache/contract_version_1/session_info/$session"
	rm -rf "$LOCALAPPDATA/Temp/zellij/contract_version_1/$session"
	echo "Cleared session: $session"
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

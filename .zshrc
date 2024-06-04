# Antonio Bartalesi's config for the Z shell from hell

# Enable colors and change prompt:
autoload -U colors && colors

# allows parameter expansion, arithmatic, and shell substitution in prompts
setopt prompt_subst

function make_prompt() {
	# Check if root
	if [ $UID -eq 0 ]; then
		USER_COLOR="red";
	else
		USER_COLOR="yellow";
	fi

	PROMPT="%B[%F{${USER_COLOR}}%n%f@%F{"green"}%M%f:%F{"cyan"}%~%f]%b "
}

function check_last_exit_code() {
	local LAST_EXIT_CODE=$?
		if [[ $LAST_EXIT_CODE -ne 0 ]]; then
			PROMPT="%K{red}${LAST_EXIT_CODE}%k ${PROMPT}";
		fi
}

function check_ssh() {
	if [[ $SSH_CLIENT ]]; then
		PROMPT="%B%F{"magenta"}SSH%f%b${PROMPT}";
	fi
}

function check_virtualenv() {
	if [[ $VIRTUAL_ENV ]]; then
		PROMPT="(%B%F{"blue"}${VIRTUAL_ENV_PROMPT}%f%b) ${PROMPT}";
	fi
}

typeset -a precmd_functions
# append the function to our array of precmd functions
precmd_functions+=(make_prompt)
precmd_functions+=(check_last_exit_code)
precmd_functions+=(check_ssh)
precmd_functions+=(check_virtualenv)

# Config dir and repo
ZSH_CONFDIR="${HOME}/.config/zsh"
mkdir -p ${ZSH_CONFDIR}

# Try to clone and install from the config repo
# known_hosts_file="${HOME}/.ssh/known_hosts"
# git_host_publickey=$(<"${ZSH_CONFDIR}/host_signature")
# if [ ! -f "${known_hosts_file}" ]; then
#     echo "${git_host_publickey}" > "${known_hosts_file}"
# else
#     # Check if the line exists in the file
#     if ! grep -q "${git_host_publickey}" "${known_hosts_file}"; then
#         echo "${git_host_publickey}" >> "${known_hosts_file}"
#     fi
# fi
# git clone "git@bartalesi.eu:~/bartalesi-zsh.git" ${ZSH_CONFDIR} &> /dev/null
# git -C ${ZSH_CONFDIR} pull origin master &> /dev/null
# if ! diff "${ZSH_CONFDIR}/zshrc" "${HOME}/.zshrc" > /dev/null; then
# 	make install -C ${ZSH_CONFDIR} &> /dev/null
# 	_lastcommit=$(git -C ${ZSH_CONFDIR} log -1 master --oneline --pretty=format:%B)
# 	echo "ZSH updated! Last commit is \"${_lastcommit}\""
# 	echo "Shell reload is recommended"
# fi

# History in .local directory:
HISTSIZE=10000
SAVEHIST=10000
HISTDIR="${HOME}/.local/share/zsh/history"
mkdir -p ${HISTDIR}
HISTFILE="${HISTDIR}/${HOST}"

# Load aliases and shortcuts if existent.
[ -f "/usr/bin/nvim" ] && alias vim=nvim && alias vi=nvim && export VISUAL=nvim
if [ -f "${ZSH_CONFDIR}/aliasrc" ]; then
	source "${ZSH_CONFDIR}/aliasrc"
fi

if [ -f "${ZSH_CONFDIR}/aliasrc_maxiv" ]; then
	source "${ZSH_CONFDIR}/aliasrc_maxiv"
fi

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files in completion

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Python virtualenvwrapper
if [ -f /usr/bin/virtualenvwrapper_lazy.sh ]; then
	export WORKON_HOME=~/Documents/venvs
	source /usr/bin/virtualenvwrapper_lazy.sh
fi

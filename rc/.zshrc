# ~tgyurci/.zshrc

# Options

## Changing Directories
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_TO_HOME PUSHD_MINUS

## Completion
setopt ALWAYS_TO_END

## Expansion and globbing
setopt EXTENDED_GLOB GLOB_STAR_SHORT WARN_CREATE_GLOBAL

## History
setopt HIST_FIND_NO_DUPS HIST_IGNORE_DUPS HIST_REDUCE_BLANKS

## Input/Output
setopt NO_FLOW_CONTROL INTERACTIVE_COMMENTS

## Job Control
setopt AUTO_CONTINUE NO_BG_NICE LONG_LIST_JOBS

## Scripts and Functions
setopt C_BASES OCTAL_ZEROES

## Shell Emulation
setopt BSD_ECHO

## Zle
setopt NO_BEEP COMBINING_CHARS

# Init

src() {
	if [[ -f "$1" ]]; then
		source "$1"
	fi
}

## Set UNAME_S for .shrc
if [[ -z "$UNAME_S" ]]; then
	# this is the only fork() in the Zsh rc files
	typeset -r UNAME_S=$(uname -s)
fi

## Common configuration
emulate sh -c 'src "$HOME/.shrc"'

# Parameters

DIRSTACKSIZE=30
fignore=(.class .o .swp)
HISTSIZE=2048
unset HISTFILE
KEYTIMEOUT=5
LISTMAX=0
READNULLCMD="$PAGER"

## Prompt
PROMPT='%(!.%B%n%b.%n)@%(!.%B%m%b.%m):%~%# '

## Right prompt
RPROMPT='%(3V.%3v .)%(2V.%B%2v%b .)%(1V.%1v .)%(1j.&%j .)%(0?..%B?%?%b )'

if [[ -o login ]]; then
	RPROMPT="${RPROMPT}%UL%L%u"
else
	RPROMPT="${RPROMPT}L%L"
fi

RPROMPT="${RPROMPT}%(5V./%B%5v%b.)"

case "$TERM" in
	(screen*) ;;
	(*) RPROMPT="$RPROMPT %l" ;;
esac

# Functions

## Autoload functions

autoload -Uz add-zsh-hook
autoload -Uz backward-word-match
autoload -Uz edit-command-line
autoload -Uz forward-word-match
autoload -Uz insert-composed-char
autoload -Uz vcs_info
autoload -Uz zargs
autoload -Uz zmv

## Terminal title
case "$TERM" in
	(xterm*)
		_set-term-title() {
			print -Pn '\e]0;%n@%m%(4V. [%4v].)\a'
		}
	;;
	(screen*)
		_set-term-title() {
			print -Pn '\e_%n@%m%(4V. [%4v].)\e\\'
			print -Pn '\ek%m(%l)%(5V./%5v.)\e\\'
		}
	;;
esac

add-zsh-hook precmd _set-term-title

## VCS Info
_set-vcs-info() {
	if zstyle -t ":rc-base:$HOST:$PWD" vcs_info_enable; then
		vcs_info
		psvar[3]="$vcs_info_msg_0_"
	else
		unset vcs_info_msg_0_ vcs_info_msg_1_
		psvar[3]=""
	fi
}

add-zsh-hook precmd _set-vcs-info

## Extra prompt info functions

_set-vi-mode-prompt() {
	local mode

	case "$KEYMAP" in
		(viins|main)
			case "$ZLE_STATE" in
				(*insert*) mode="I" ;;
				(*overwrite*) mode="R" ;;
				(*) mode="I?" ;;
			esac
		;;
		(vicmd) mode="N" ;;
		(viopp) mode="O" ;;
		(*) mode="?" ;;
	esac

	psvar[2]="$mode"
}

_set-histno-prompt() {
	local hist

	if [[ "$HISTNO" == "$HISTCMD" ]]; then
		hist="!$HISTNO"
	else
		hist="!${HISTNO}/${HISTCMD}"
	fi

	psvar[1]="$hist"
}

_redraw-prompt() {
	local status_line reply

	zle reset-prompt

	zstyle -s ":rc-base:$HOST:$PWD" status-line status_line

	if [[ -n "$status_line" && $KEYS_QUEUED_COUNT == 0 ]]; then
		zle -M -- "$status_line"
	fi
}

## Zle widgets

zle-history-line-set() {
	_set-histno-prompt
	_redraw-prompt
}

zle-keymap-select() {
	_set-vi-mode-prompt
	_redraw-prompt
}

zle-line-init() {
	_set-vi-mode-prompt
	_set-histno-prompt
	_redraw-prompt
}

# Zle widgets

zle -N backward-word-match
zle -N edit-command-line
zle -N forward-word-match
zle -N insert-composed-char
zle -N zle-history-line-set
zle -N zle-keymap-select
zle -N zle-line-init

# Keybindings

bindkey -v

## Insert key
if [[ -n "$terminfo[kich1]" ]]; then
	bindkey -M vicmd "$terminfo[kich1]" vi-insert
fi

## Delete key
if [[ -n "$terminfo[kdch1]" ]]; then
	bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
	bindkey -M viins "$terminfo[kdch1]" vi-delete-char
fi

## Home key
if [[ -n "$terminfo[khome]" ]]; then
	bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
	bindkey -M viins "$terminfo[khome]" vi-beginning-of-line
fi

## End key
if [[ -n "$terminfo[kend]" ]]; then
	bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
	bindkey -M viins "$terminfo[kend]" vi-end-of-line
fi

## Navigating in insert mode

bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
bindkey -M viins '^F' vi-forward-char
bindkey -M viins '^B' vi-backward-char

## Jump over real shell parameters in command line

bindkey -M vicmd "B" backward-word-match
bindkey -M vicmd "W" forward-word-match

## Searching in history

bindkey -M viins '^X^B' history-beginning-search-backward
bindkey -M viins '^X^P' history-incremental-pattern-search-backward
bindkey -M viins '^X^N' history-incremental-pattern-search-forward
bindkey -M isearch '^M' accept-search

## Edit command line in external editor

bindkey -M vicmd '^Xv' edit-command-line
bindkey -M viins '^Xv' edit-command-line
bindkey -M vicmd '^X^V' edit-command-line
bindkey -M viins '^X^V' edit-command-line

## Insert composed characters

bindkey -M viins '^K' insert-composed-char

## Insert parameter again

bindkey -M viins "^X^W" copy-prev-shell-word

# Styles

## Custom word matching/jumping

zstyle ":zle:*" word-style shell

## VCS Info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '[%b]%c%u'
zstyle ':vcs_info:*' actionformats '[%b|%a]%c%u'
zstyle ':vcs_info:*' check-for-staged-changes yes
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'

# Aliases

alias d='dirs -v'
alias po='popd'
alias pu='pushd'

# Local configuration

src "${XDG_CONFIG_HOME:-"$HOME/.config"}/rc-local/.zshrc.local"
src "$HOME/.zshrc.local"
[[ -n "$ZDOTDIR" ]] && src "$ZDOTDIR/.zshrc.local"

# Cleanup

unset -f src

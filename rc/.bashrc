# ~tgyurci/.bashrc

umask 022

#[[ $- != *i* ]] && return
[ -z "$PS1" ] && return

src() {
	[ -f "$1" ] && source "$1"
}

if [ -z "$UNAME_S" ]; then
	UNAME_S=$(uname -s)
fi

# Common configuration
src "$HOME/.common.sh"

HISTCONTROL=ignoreboth
unset HISTFILE
HISTFILESIZE=0
HISTSIZE=1024
PS1='\u@\h:\w\$ '

if [ -z "$HOST_S" ]; then
	HOST_S="${HOSTNAME%%.*}"
fi

if [ -z "$TTY_S" ]; then
	TTY=$(tty)
	TTY_S=${TTY#/dev/}
	TTY_S=${TTY_S##tty}
fi

shopt -s checkwinsize

case "$TERM" in
	(xterm*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOST_S}\007"'
	;;
	(screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOST_S}\033\\"; echo -ne "\\033k${HOST_S}($TTY_S)\033\\"'
	;;
esac

# Local configuration
src "$HOME/.local.sh"
src "$HOME/.local.bash"

unset command_not_found_handle
unset src

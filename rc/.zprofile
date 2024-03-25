# ~tgyurci/.zprofile

if [[ -f "$HOME/.profile" ]]; then
	emulate sh -c '. "$HOME/.profile"'
fi

if [[ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/rc-local/.zprofile.local" ]]; then
	. "${XDG_CONFIG_HOME:-"$HOME/.config"}/rc-local/.zprofile.local"
fi

if [[ -f "$HOME/.zprofile.local" ]]; then
	. "$HOME/.zprofile.local"
fi

if [[ -n "$ZDOTDIR" && -f "$ZDOTDIR/.zprofile.local" ]]; then
	. "$ZDOTDIR/.zprofile.local"
fi

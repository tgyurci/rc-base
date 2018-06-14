#!/bin/sh

set -euf

fail() {
	echo "$@" >&2
	exit 1
}

n_opt=""

while getopts ":n-" opt; do
	case "$opt" in
		n) n_opt="1" ;;
		-) break ;;
		\?) fail "Invalid flag: $OPTARG" ;;
	esac
done
shift $(($OPTIND - 1))

[ $# -gt 1 ] || fail "Usage: $0 [-n] [--] source target ..."

source="$1"
shift

[ "rc" = "$source" ] || [ "rc-extra" = "$source" ] || fail "Source must be rc or rc-extra"

for target; do
	#(cd rc && find . -type f -print0) | rsync -crpmv -0 --files-from=- ${n_opt:+"-n"} \
	rsync -crpmv ${n_opt:+"-n"} \
		--exclude-from=sync-exclude \
		"${source}/" "$target"
done

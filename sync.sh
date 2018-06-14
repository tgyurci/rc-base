#!/bin/sh

if [ "$1" = "-n" ]; then
	dry_run="-n"
	shift
else
	dry_run=""
fi

for host in "$@"; do
	#(cd rc && find . -type f -print0) | rsync -crpmv -0 --files-from=- $dry_run \
	rsync -crpmv $dry_run \
		--exclude="*.swp" \
		--exclude=".ssh" \
		--exclude=".local.sh" \
		--exclude=".*.local" \
		rc/ "$host"
done

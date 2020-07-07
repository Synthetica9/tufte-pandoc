#! /usr/bin/env nix-shell
#! nix-shell -i bash 

set -euxo pipefail

function files_to_watch() {
	scons --tree all --dry-run $@ \
		| grep --only-matching -P '(?<=\+\-).*$' \
		| sort \
		| uniq \
		| (xargs ls -d 2>/dev/null || true)
}

while :
do
	files_to_watch | (entr -apz -- scons || true)
done
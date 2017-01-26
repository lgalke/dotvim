#!/usr/bin/env sh
BASE=$( cd $(dirname "$0"); pwd -P)
REPO=$BASE/pack/$1
echo "Creating dir $REPO"
mkdir -p "$REPO"
shift
for identifier in $@; do
	TARGET="https://github.com/$identifier.git"
	echo "[SM] Installing submodule $TARGET in $REPO"
	cd "$REPO" && git submodule add --force "$TARGET"
done

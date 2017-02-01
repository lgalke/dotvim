#!/usr/bin/env sh
BASE=$( cd $(dirname "$0"); pwd -P)
REPO=$BASE/pack/$1
cd "$REPO"
shift
for identifier in $@; do
	cd "$REPO" && git rm "$identifier"
done

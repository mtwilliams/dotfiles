#!/bin/sh

# Check a single branch when called with an argument.
if [ $# -ge 1 ]; then
  UPSTREAM=$(git rev-parse --abbrev-ref "$1@{u}" 2>/dev/null)
  [ -z "$UPSTREAM" ] && exit 0
  AHEAD=$(git rev-list --count "$UPSTREAM..$1" 2>/dev/null)
  [ -n "$AHEAD" ] && [ "$AHEAD" -gt 0 ] && echo "$1"
  exit 0
fi

git fetch --quiet

git for-each-ref --format="%(refname:short)" refs/heads/ | xargs -P 0 -I {} "$0" {} | sort

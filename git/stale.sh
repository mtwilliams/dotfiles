#!/bin/sh

git fetch --quiet

for BRANCH in $(git for-each-ref --format="%(refname:short)" refs/heads/); do
  UPSTREAM=$(git rev-parse --abbrev-ref "$BRANCH@{u}" 2>/dev/null)
  if [ -z "$UPSTREAM" ]; then
    continue
  fi
  BEHIND=$(git rev-list --count "$BRANCH..$UPSTREAM" 2>/dev/null)
  if [ -n "$BEHIND" ] && [ "$BEHIND" -gt 0 ]; then
    echo "$BRANCH"
  fi
done

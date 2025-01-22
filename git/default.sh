#!/bin/sh

BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed "s@^refs/remotes/origin/@@")

if [ -z "$BRANCH" ]; then
  BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}');
fi

echo "$BRANCH"

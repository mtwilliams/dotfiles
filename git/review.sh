#!/bin/sh

BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
if [ -z "$BASE" ]; then
  if git show-ref --verify --quiet refs/remotes/origin/main; then
    BASE=main
  elif git show-ref --verify --quiet refs/remotes/origin/master; then
    BASE=master
  else
    BASE=$(git default)
  fi
fi

if [ -z "$BASE" ]; then
  echo "Unable to determine the default branch."
  exit 1
fi

MB=$(git merge-base HEAD "origin/$BASE")

git diff "$MB..HEAD"

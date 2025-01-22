#!/bin/sh

# Determine the default branch.
DEFAULT=$(git default)

if [ -z "$DEFAULT" ]; then
  echo "Unable to determine the default branch."
  exit 1
fi

# List merged branches, excluding the default branch and the current branch.
MERGED=$(git branch --merged | grep -v '^\*' | grep -v "$DEFAULT")

if [ -z "$MERGED" ]; then
  echo "No merged branches to delete."
  exit 0
fi

# Delete the merged branches.
echo "$MERGED" | xargs -n 1 git branch -d

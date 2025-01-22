#!/bin/sh

# Ensure the new branch is specified.
if [ $# -ne 1 ]; then
  exit 1
fi

TARGET=$1

# Determine the current branch.
BRANCH=$(git rev-parse --abbrev-ref HEAD) || exit 1

# Get the upstream branch for the current branch.
UPSTREAM=$(git rev-parse --abbrev-ref "$BRANCH@{u}" 2>/dev/null)

# Create a new branch from the current state.
git branch "$TARGET"

if [ -n "$UPSTREAM" ]; then
  # Move the current branch back to match upstream.
  git reset --soft $UPSTREAM
else
  # Move the current branch back one commit.
  git reset --soft HEAD~
fi

echo "Moved diverging commits to $TARGET."

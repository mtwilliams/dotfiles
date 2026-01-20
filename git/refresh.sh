#!/bin/sh

BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git log -1 --format=%H)

if [ -n "$1" ]; then
  # Try to get upstream for the argument as a local branch.
  UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name "$1@{u}" 2>/dev/null)

  if [ -n "$UPSTREAM" ]; then
    # It's a local branch with an upstream.
    :
  else
    # Try to use it directly as a reference.
    if git rev-parse --verify "$1" >/dev/null 2>&1; then
      UPSTREAM="$1"
    else
      echo "Could not resolve $1 as a local branch with upstream or as a remote branch reference."
      exit 1
    fi
  fi
else
  # Use the upstream branch of the current branch if not specified.
  UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>/dev/null)
  if [ -z "$UPSTREAM" ]; then
    echo "No upstream branch set for $BRANCH. Use \`git branch --set-upstream-to\` to configure it."
    exit 1
  fi
fi

git fetch --quiet

echo "Attempting to fast-forward $BRANCH to $UPSTREAM..."
if git merge --ff-only "$UPSTREAM"; then
  BEHIND=$(git rev-list --count "$COMMIT..$UPSTREAM" 2>/dev/null);
  if [ "$BEHIND" -gt 0 ]; then
    echo "$BRANCH successfully fast-forwarded to $UPSTREAM."
    echo "Showing changes between $BRANCH and $UPSTREAM:"
    git log --oneline --graph "$COMMIT..$UPSTREAM"
  else
    echo "No changes between $BRANCH and $UPSTREAM."
  fi
else
  echo "Fast-forward failed. Your branch has diverged. Resolve conflicts or rebase manually."
fi

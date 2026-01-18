#!/bin/sh

BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git log -1 --format=%H)
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>/dev/null)

if [ -z "$UPSTREAM" ]; then
  echo "No upstream branch set for $BRANCH. Use \`git branch --set-upstream-to\` to configure it."
  exit 1
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

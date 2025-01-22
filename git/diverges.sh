#!/bin/sh

# Ensure at least one argument is provided.
if [ $# -lt 1 ]; then
  exit 1
fi

A=$1

# Use upstream of A if not specified.
if [ $# -eq 1 ]; then
  B=$(git rev-parse --abbrev-ref "$A@{u}" 2>/dev/null)
  if [ -z "$B" ]; then
    echo "No upstream branch set for $A."
    exit 1
  fi
else
  B=$2
fi

git rev-list --boundary "$A...$B" | grep "^-" | sed "s/^-//"

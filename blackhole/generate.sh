#!/bin/bash

BLACKLISTS="$HOME/.dotfiles/blackhole/blacklists"
WHITELISTS="$HOME/.dotfiles/blackhole/whitelists"

# Ensure the blacklists and whitelists directories exist.
mkdir -p "$BLACKLISTS"
mkdir -p "$WHITELISTS"

# Strips empty lines, comments, and trailing whitespace.
function clean() {
  awk '
    # Remove full-line comments and empty lines.
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*#/ { next }
    
    # Remove inline comments and trailing whitespace.
    {
      # Remove inline comments.
      sub(/[[:space:]]*#.*$/, "")

      # Remove trailing comments.
      sub(/[[:space:]]+$/, "")

      # Convert to lowercase and print.
      print tolower($0)
    }
  ' "${1:-/dev/stdin}"
}

# Generate a hosts file that makes hosts unrouteable.
#
# 1. Aggregate the whitelists and blacklists.
# 2. Strip any empty lines and comments.
# 3. Generate entries for anything that's been blacklisted but not whitelisted.
echo "# This file was auto-generated on $(date -u +"%Y-%m-%dT%H:%M:%SZ")."
UNROUTEABLE="0.0.0.0"
find "$BLACKLISTS" -type f -print0 | xargs -0 cat | clean | sort -u | comm -23 - <(
  find "$WHITELISTS" -type f -print0 | xargs -0 cat | clean | sort -u
) | sed "s/^/$UNROUTEABLE /"
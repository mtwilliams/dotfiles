#!/bin/bash

function verbose() {
  [[ "${VERBOSE:-0}" -eq 1 ]] && echo "$@" >&2
}

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

# Extracts hostnames from blacklists.
function parse() {
  local FILE="${1:-/dev/stdin}"
  local LINE

  # Regular expressions matching common parts.
  local HOSTNAME="([[:alnum:]_.-]+)"
  local IP="(0\.0\.0\.0|127\.0\.0\.1)"

  while IFS="" read -r LINE || [[ -n "$LINE" ]]; do
    # Parse hosts file format (0.0.0.0 or 127.0.0.1 followed by a hostname).
    if [[ "$LINE" =~ ^${IP}[[:space:]]+${HOSTNAME}$ ]]; then
      echo "${BASH_REMATCH[2]}"
    # Parse Adblock-style hostnames.
    elif [[ "$LINE" =~ ^${HOSTNAME}$ ]]; then
      echo "$LINE"
    else
      # Replace "[.]" with "." to "deneutralize" URLs.
      LINE=$(echo "$LINE" | sed 's/\[.\]/./g')

      # Remove trailing paths after a "/" or "?" to isolate the hostname.
      LINE=$(echo "$LINE" | sed 's#[/?].*##')

      # Remove schemaless prefixes like "//".
      LINE=$(echo "$LINE" | sed 's#^//##')

      # If the processed line is a valid hostname, output it.
      if [[ "$LINE" =~ ^${HOSTNAME}$ ]]; then
        echo "$LINE"
      fi
    fi
  done < <(clean "$FILE")
}

# Extracts hostnames from several blacklists.
function parse_from_index() {
  local URL="$1"
  local TIMEOUT="${2:-60}"

  verbose " Fetching and extracting lists from \"$URL\"..."

  curl -m $TIMEOUT -Y 0 -y 3 --fail -s "$URL" | clean | while IFS="" read -r LINE || [[ -n "$LINE" ]]; do
    verbose "  Fetching and processing \"$LINE\"..."

    # Fetch and parse.
    curl -m $TIMEOUT -Y 0 -y 3 --fail -s "$LINE" | parse
  done
}

# Build a conservative blacklist that shouldn't contain any false positives.
echo "Building $BLACKLISTS/default.txt from Firebog..."
parse_from_index "https://v.firebog.net/hosts/lists.php?type=tick" > "$BLACKLISTS/default.txt"

# Build a blacklist that may contain some false positives.
# echo "Building $BLACKLISTS/extra.txt from Firebog..."
# parse_from_index "https://v.firebog.net/hosts/lists.php?type=nocross" > "$BLACKLISTS/extra.txt"

echo "Done."

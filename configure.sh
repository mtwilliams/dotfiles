#!/bin/bash

# Determine platform and flavor.
case "$OSTYPE" in
  darwin*)
    export PLATFORM=mac
  ;;

  linux*)
    export PLATFORM=linux

    # Identifiy the distribution.
    if [[ -f /etc/os-release ]]; then
      export FLAVOR=$(source /etc/os-release && echo $ID)
    elif [[ -f /etc/lsb-release ]]; then
      export FLAVOR=$(source /etc/lsb-release && echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]')
    elif [[ -f /etc/debian_version ]]; then
      export FLAVOR=debian
    elif [[ -f /etc/redhat-release ]]; then
      export FLAVOR=redhat
    else
      export FLAVOR=unknown
    fi
  ;;

  *bsd*)
    export PLATFORM=bsd
    export FLAVOR=$(uname -s | tr '[:upper:]' '[:lower:]')
  ;;

  *)
    echo "Unknown or unsupported platform."
    exit 1
  ;;
esac

# Detect if running under Windows Subystem for Linux (WSL).
if [[ "$OSTYPE" == "linux"* ]]; then
  if grep -q -i microsoft /proc/version 2>/dev/null || [[ "$(uname -r)" == *"microsoft"* ]]; then
    export WSL=1
  fi
fi

SCRIPTS="$HOME/.dotfiles/configure"
FLAGS="$HOME/.dotfiles/flags"

# Ensure the flags directory exists.
mkdir -p "$FLAGS"

# Runs a configuration script.
function run() {
  local SCRIPT="$1"
  local ALWAYS="$2"

  # Derive the name from the path.
  NAME=$(basename "$SCRIPT" .sh)
  NAME=${NAME#*-}

  # Get the description from the script, or default to the name.
  DESCRIPTION=$(bash -c "source '$SCRIPT'; description" 2>/dev/null || echo "$NAME")

  # Execute the script if it has not been run, or if forced.
  if [[ "$ALWAYS" == "true" || ! -f "$FLAGS/$NAME" ]]; then
    echo "* $DESCRIPTION"

    # Capture and process script output.
    if OUTPUT=$(bash "$SCRIPT" 2>&1); then
      [[ "$ALWAYS" != "true" ]] && touch "$FLAGS/$NAME"
      if [[ -n "$OUTPUT" ]]; then
        # Indent output with 4 spaces.
        echo "$OUTPUT" | sed 's/^/    /'
      fi
    else
      # Indent output with 4 spaces.
      echo "$OUTPUT" | sed 's/^/    /'
      echo ""
      echo "Failed to perform this step."
      exit 1
    fi
  else
    # Indicate the script was skipped.
    echo ". $DESCRIPTION"
  fi
}

# Runs configuration scripts under a directory.
function run_all_under() {
  local DIR="$1"
  local ALWAYS="$2"

  find "$DIR" -maxdepth 1 -type f -name "*.sh" | sort | while read -r SCRIPT; do
    run "$SCRIPT" "$ALWAYS"
  done
}

echo "Will configure this \"$PLATFORM\" machine."

if [[ "$PLATFORM" == "mac" ]]; then
  # Ensure Homebrew is available for the rest of the script.
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Authenticate up front.
sudo --validate

# Maintain `sudo` privilege for the duration of the script.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Run scripts under `~/.dotfiles/configure/once` (executed based on flags).
run_all_under "$SCRIPTS/once" "false"

# Run scripts under `~/.dotfiles/configure/$PLATFORM` (always executed).
run_all_under "$SCRIPTS/$PLATFORM" "true"

# Run scripts under `~/.dotfiles/configure` (always executed).
run_all_under "$SCRIPTS" "true"

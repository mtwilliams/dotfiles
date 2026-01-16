#!/bin/bash

description() {
  echo "Install mise and plugins"
}

main() {
  # Install mise via the official installer.
  curl https://mise.run | sh

  # Activate mise for the remainder of this script.
  eval "$(~/.local/bin/mise activate bash)"

  # Install plugins for languages of choice.
  mise use --global node@latest
  mise use --global python@latest
  mise use --global erlang@latest
  mise use --global elixir@latest

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi

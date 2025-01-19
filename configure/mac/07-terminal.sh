#!/bin/bash

description() {
  echo "Install Ghostty"
}

main() {
  # Install through Homebrew.
  brew install ghostty

  # TODO: Point configuration files.
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi


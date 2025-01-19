#!/bin/bash

description() {
  echo "Install Visual Studio Code"
}

main() {
  # Install through Homebrew.
  brew install --cask visual-studio-code
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi


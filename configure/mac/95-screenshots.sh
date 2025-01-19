#!/bin/bash

description() {
  echo "Configure screenshots"
}

main() {
  # Save screenshots to ~/Desktop/Screenshots.
  defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"

  # Save screenshots as PNG, rather than other formats.
  defaults write com.apple.screencapture type -string "png"

  # Disable shadow in screenshots.
  defaults write com.apple.screencapture disable-shadow -bool true

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi


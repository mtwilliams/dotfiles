#!/bin/bash

description() {
  echo "Configure Dock"
}

main() {
  # Use reasonably sized icons.
  defaults write com.apple.dock tilesize -int 64

  # Hide the dock (without delay) when not in use.
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.5

  # Show indicator lights for open applications.
  defaults write com.apple.dock show-process-indicators -bool true

  # Don't animate openining applications from the Dock.
  defaults write com.apple.dock launchanim -bool false

  # Minimize windows with the "genie" effect.
  defaults write com.apple.dock mineffect -string "genie"

  # Minimize windows to their application icon.
  defaults write com.apple.dock minimize-to-application -bool true

  # Don’t show recent applications in Dock.
  defaults write com.apple.dock show-recents -bool false

  # Disable hot corners.
  for corner in tl tr bl br; do
    defaults delete com.apple.dock wvous-${corner}-corner 2>/dev/null
    defaults delete com.apple.dock wvous-${corner}-tlmodifier 2>/dev/null
  done

  # Don't automatically rearrange spaces based on most recent use.
  defaults write com.apple.dock mru-spaces -bool false

  # Maintain seperate spaces for each display.
  defaults write com.apple.spaces "spans-displays" -bool false

  # Restart for changes to take effect.
  killall -q SystemUIServer
  killall -q Dock

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
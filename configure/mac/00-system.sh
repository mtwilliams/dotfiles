#!/bin/bash

description() {
  echo "Configure macOS"
}

main() {
  # Automatically check for software updates.
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

  # Check for software updates daily, not just once per week.
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

  # Download newly available updates in background.
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

  # Automatically install critical updates.
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

  # Automatically update apps through the App Store.
  defaults write com.apple.commerce AutoUpdate -bool true

  # Allow the App Store to reboot the machine on macOS updates.
  defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
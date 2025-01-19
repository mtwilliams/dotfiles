#!/bin/bash

description() {
  echo "Make various adjustments to macOS to reduce noise"
}

main() {
  # Disable Siri.
  # defaults write com.apple.assistant.support "Assistant Enabled" -bool false
  # defaults write com.apple.Siri StatusMenuVisible -bool false

  # Disable dictation pop up.
  defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 1

  # Instantly dismiss the emoji palette.
  #
  # https://github.com/lgarron/first-world/issues/39
  # defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -boolean false

  # Prevent Photos from opening automatically when devices are plugged in.
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

  # Prevent Time Machine from prompting to use new hard drives as backup volume.
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # Make crash reports appear as notifications rather than popups.
  defaults write com.apple.CrashReporter UseUNC 1

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
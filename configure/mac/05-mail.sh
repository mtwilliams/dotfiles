#!/bin/bash

description() {
  echo "Configure Mail"
}

main() {
  # Copy email addresses as `jdoe@example.com` instead of `John Doe <jdoe@example.com>`.
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  # Don't load remote content by default?
  # defaults write com.apple.mail-shared DisableURLLoading -bool true

  # Disable new message sound.
  # defaults write "com.apple.mail" "NewMessagesSoundName" '""'

  # Check for new messages automatically.
  # defaults write "com.apple.mail" "AutoFetch" '1'
  # defaults write "com.apple.mail" "PollTime" '"-1"'

  # Restart for changes to take effect.
  killall -q Mail

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
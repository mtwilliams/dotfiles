#!/bin/bash

description() {
  echo "Configure screensaver and lock screen"
}

main() {
  # Trigger screensaver after being idle for 1 minute.
  defaults -currentHost write com.apple.screensaver idleTime 60

  # Immediately require password after screensaver or sleep.
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
#!/bin/bash

description() {
  echo "Configure iCloud"
}

main() {
  # Don't backup Desktop and Documents folders.
  defaults write com.apple.finder "FXICloudDriveDesktop" -boolean false
  defaults write com.apple.finder "FXICloudDriveDocuments" -boolean false

  # Save to disk (not to iCloud) by default.
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi


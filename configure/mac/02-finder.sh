#!/bin/bash

description() {
  echo "Configure Finder"
}

main() {
  # Set the default location for new Finder windows to the home directory.
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

  # Use current directory as default search scope in Finder.
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Show path and status bars.
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool false


  # Sidebar

  # Don't show iCloud Desktop in the sidebar.
  defaults write com.apple.finder "SidebarShowingiCloudDesktop" -boolean false

  #  ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.FavoriteItems.sfl3
  # com.apple.LSSharedFileList.FavoriteItems
  # ShowRecentTags=0

  # Don't show recent tags in the sidebar.
  defaults write com.apple.finder ShowRecentTags -bool false

  # Use list view in all Finder windows by default.
  #
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`.
  defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"

  # Snap-to-grid.
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  # Show hidden files by default.
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Always show file extensions.
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Disable warning when changing file extensions.
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Hide icons for hard drives, servers, and removable media on the desktop.
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

  # Disable QuickLook on small icons.
  #
  # https://mastodon.social/@chockenberry/110385041988304201
  defaults write com.apple.finder QLInlinePreviewMinimumSupportedSize -int 256

  # Don't open a new Finder window when a volume is mounted.
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool false

  # Avoid creating .DS_Store files on servers and removable media.
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Disable the warning before emptying the Trash.
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Always empty the Trash securely.
  defaults write com.apple.finder EmptyTrashSecurely -bool true

  # Automatically remove items from trash after 30 days.
  defaults write com.apple.finder FXRemoveOldTrashItems -bool true

  # Restart for changes to take effect.
  killall -q Finder

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
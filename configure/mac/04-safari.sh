#!/bin/bash

description() {
  echo "Configure Safari"
}

# TODO(mtwilliams): There's some additional configuration that still requires
# manual intervention as it isn't easily accessible through `defaults`. It
# may still be available through defaults but not under `com.apple.Safari`,
# otherwise AppleScript may be necessary.

main() {
  ## General

  # Restore session when launched.
  defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true

  # Only show the domain.
  #
  # The entire address is shown when the focused on the address bar.
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool false

  # Displays tabs separately.
  defaults write com.apple.Safari ShowStandaloneTabBar -bool true

  # Hide the bookmarks bar.
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  # Show the status bar.
  defaults write com.apple.Safari ShowOverlayStatusBar -bool true

  # Open new windows/tabs to start page.
  defaults write com.apple.Safari HomePage -string ""
  defaults write com.apple.Safari.SandboxBroker Homepage -string ""
  defaults write com.apple.Safari NewWindowBehavior '4'
  defaults write com.apple.Safari NewTabBehavior '4'

  ## Search

  # Use DuckDuckGo as search engine.
  #
  # This also affects Spotlight.
  defaults write -g NSPreferredWebServices '{NSWebServicesProviderWebSearch = { NSDefaultDisplayName = DuckDuckGo; NSProviderIdentifier = "com.duckduckgo"; }; }'
  defaults write com.apple.Safari SearchProviderIdentifier -string com.duckduckgo
  defaults write com.apple.Safari SearchProviderShortName -string DuckDuckGo

  # Don't preload the top hit from searches.
  defaults write com.apple.Safari PreloadTopHit -bool false

  # Disable website-specific search.
  defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool false

  ## Experience

  # Allow websites to request the ability to send push notifications.
  defaults write com.apple.Safari CanPromptForPushNotifications '1'

  # Spell check, but don't correct.
  defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
  defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

  ## AutoFill

  # Don't store passwords and other sensitive data with Safari.
  defaults write com.apple.Safari AutoFillPasswords -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

  ## Privacy

  # Enable Do Not Track.
  #
  # https://en.wikipedia.org/wiki/Do_Not_Track
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

  # Don't send searches to Apple.
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  ## Security

  # Prevent accessing websites over HTTP.
  # defaults write com.apple.Safari UseHTTPSOnly -bool true

  # Don't automatically open "safe" files.
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  ## Extensions

  # Allow extensions.
  defaults write com.apple.Safari ExtensionsEnabled -bool true

  # Automatically update extensions.
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

  # Install 1Password for Safari.
  mas purchase 1569813296

  ## Developer

  # Enable the developer tools.
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi

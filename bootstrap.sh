#!/bin/bash

# Bootstrapping script for a new Mac.

# Grant full disk access to Terminal.
#
# System Preferences → Privacy & Security → Full Disk Access
echo "You must grant full disk access to your Terminal."
echo ""
echo "Verify that the necessary permission has been granted, and if so, continue. Otherwise, grant the permission and restart your Terminal."
echo ""
echo "Proceed? (y/N)" 
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
read -r CONTINUE
if [[ $CONTINUE =~ ^([yY][eE][sS]|[yY])$ ]]; then
  :
else
  exit 1
fi

# Authenticate up front.
sudo --validate

# Maintain `sudo` privilege for the duration of the script.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make Homebrew available under `bash` and `zsh` until we can perform additional setup.
#
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
echo >> ~/.bash_profile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Ensure Homebrew is available for the rest of the script.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install a command-line interface for the App Store.
brew install mas

# Install Xcode.
XCODE_APP_ID=497799835
mas purchase $XCODE_APP_ID

# Adopt it.
#
# This is necessary because Homebrew sets up Xcode command line tools.
sudo xcode-select -s /Applications/Xcode.app

# Accept the license.
sudo xcodebuild -license accept

# Install commonly used tools.
brew install coreutils moreutils findutils

# Install commonly used build tools.
brew install make autoconf binutils

# Install commonly used developer tools.
brew install openssl curl openssh gnupg git

# We now have an environment that is capable enough to setup centralized configuration. 
git clone https://github.com/mtwilliams/dotfiles.git ~/.dotfiles
. ~/.dotfiles/configure.sh

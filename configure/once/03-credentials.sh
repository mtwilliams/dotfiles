#!/bin/bash

description() {
  echo "Setup various credentials"
}

main() {
  # Generate an SSH keypair.
  #
  # https://stackoverflow.com/questions/43235179
  ssh-keygen -q -t ed25519 -C "me@mtwilliams.io" -f ~/.ssh/id_ed25519 -N "" <<<y >/dev/null 2>&1

  # Remind me to add the key to Github.
  echo "Make sure you add $HOME/.ssh/id_ed25519.pub to Github."

  # Install support for Yubikeys.
  if [[ "$PLATFORM" == "mac" ]]; then
    brew install --cask yubico-authenticator
    brew install --cask yubico-yubikey-manager
    brew install ykman
  else
    :
  fi

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi

#!/bin/bash

description() {
  echo "Set the machine name"
}

# Generates a random alphanumeric string of the specified length.
keygen() {
  local length=${1:-16}
  LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c "$length"
}

# Derives a stable identifier from a Mac's serial number.
unique_device_identifier() {
  ioreg -d2 -c IOPlatformExpertDevice \
    | awk -F\" '/IOPlatformSerialNumber/ { printf $(NF-1) }' \
    | tr -d '\n' \
    | shasum -a 256 \
    | head -c 64 \
    | "$HOME/.dotfiles/bin/base36" -e -x \
    | tr '[:upper:]' '[:lower:]'
}

# Determines a Mac's form factor.
laptop_or_desktop() {
  if [[ $(sysctl -n hw.model) == MacBook* ]]; then
    echo "laptop"
  else
    # With the introduction of Apple Silicon, `hw.model` no longer aligns with
    # the marketing names, so these have to be pulled out I/O registry.
    if [[ $(ioreg -rc IOPlatformDevice -k product-name | awk -F'"' '/"product-name"/ {print $4}') == MacBook* ]]; then
      echo "laptop"
    else
      echo "desktop"
    fi
  fi
}

main() {
  local NAME

  if [[ "$PLATFORM" == "mac" ]]; then
    # Derive a name that's stable across reinstalls.
    NAME="michael-$(laptop_or_desktop)-$(unique_device_identifier | head -c 8)"
  else
    NAME="michael-unknown-$(keygen 8)"
  fi

  if [[ "$PLATFORM" == "mac" ]]; then
    sudo scutil --set ComputerName "$NAME"
    sudo scutil --set HostName "$NAME"
    sudo scutil --set LocalHostName "$NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$NAME"
  else
    exit 1
  fi

  echo "Machine was named \"$NAME\"".
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi

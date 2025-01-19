#!/bin/bash

description() {
  echo "Setup dnsmasq to block ads, trackers, and malicious hosts"
}

main() {
  if [[ "$PLATFORM" == "mac" ]]; then
    # Install dnsmasq.
    brew install dnsmasq

    # Configure it to act as a forwarding resolver.
    "$HOME/.dotfiles/blackhole/dnsmasq.sh" >$(brew --prefix)/etc/dnsmasq.conf

    # Fetch lists of domains we want to block.
    "$HOME/.dotfiles/blackhole/fetch.sh"
    
    # Generate a hosts file to block them.
    local HOSTS="$(brew --prefix)/etc/dnsmasq.hosts"
    "$HOME/.dotfiles/blackhole/generate.sh" >$HOSTS
    chmod 0644 $HOSTS

    # Set it up as a service.
    sudo brew services start dnsmasq

    # Configure the machine to use it.
    sudo "$HOME/.dotfiles/blackhole/adopt.sh"
  else
    exit 1
  fi
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi

#!/bin/bash

# Discover physical network interfaces (Wi-Fi, Ethernet, Thunderbolt).
# Excludes virtual interfaces like Tailscale, VPN, Bluetooth PAN.
SERVICES=$(networksetup -listallnetworkservices | grep -E 'Wi-Fi|Ethernet|Thunderbolt')

# Point them to their defaults.
while read -r SERVICE; do
  [[ -z "$SERVICE" ]] && continue
  networksetup -setdnsservers "$SERVICE" empty
done <<< "$SERVICES"

# Flush the local cache.
dscacheutil -flushcache
killall -HUP mDNSResponder

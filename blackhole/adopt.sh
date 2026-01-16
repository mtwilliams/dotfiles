#!/bin/bash

# Discover physical network interfaces (Wi-Fi, Ethernet, Thunderbolt).
# Excludes virtual interfaces like Tailscale, VPN, Bluetooth PAN.
SERVICES=$(networksetup -listallnetworkservices | grep -E 'Wi-Fi|Ethernet|Thunderbolt')

# Point them to dnsmasq.
while read -r SERVICE; do
  [[ -z "$SERVICE" ]] && continue
  networksetup -setdnsservers "$SERVICE" 127.0.0.1
done <<< "$SERVICES"

# Flush the local cache.
dscacheutil -flushcache
killall -HUP mDNSResponder

#!/bin/bash

# Discover all networks.
SERVICES=$(networksetup -listallnetworkservices | grep 'Wi-Fi\|Ethernet\|USB')

# Point them to their defaults.
while read -r SERVICE; do
  networksetup -setdnsservers "$SERVICE" empty
done <<< "$SERVICES"

# Flush the local cache.
dscacheutil -flushcache
killall -HUP mDNSResponder
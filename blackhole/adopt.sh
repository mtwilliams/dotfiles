#!/bin/bash

# Discover all networks.
SERVICES=$(networksetup -listallnetworkservices | grep 'Wi-Fi\|Ethernet\|USB')

# Point them to dnsmasq.
while read -r SERVICE; do
  networksetup -setdnsservers "$SERVICE" 127.0.0.1
done <<< "$SERVICES"

# Flush the local cache.
dscacheutil -flushcache
killall -HUP mDNSResponder
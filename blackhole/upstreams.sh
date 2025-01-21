#!/bin/bash

# Determine the active network interface.
INTERFACE=$(route get default | awk '/interface:/ {print $2}')

# Determine the name servers provided by DHCP.
ipconfig getpacket "$INTERFACE" | awk -F '[{}]' '/domain_name_server/ {gsub(/, /, "\n", $2); print $2}'

# Fallback to CloudFlare.
echo "1.1.1.1"
echo "1.0.0.1"

# Fallback to Google.
echo "8.8.8.8"
echo "8.8.4.4"
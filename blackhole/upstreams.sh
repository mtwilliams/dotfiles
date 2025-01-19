#!/bin/bash

# Determine the active network interface.
INTERFACE=$(route get default | awk '/interface:/ {print $2}')

# Determine the name servers provided by DHCP.
ipconfig getpacket "$INTERFACE" | awk -F '[{}]' '/domain_name_server/ {gsub(/, /, "\n", $2); print $2}'
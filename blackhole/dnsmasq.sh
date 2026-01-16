#!/bin/bash

echo "# Listen on localhost only."
echo "listen-address=127.0.0.1"
echo ""

echo "# Don't leak malformed domain names and private addresses."
echo "domain-needed"
echo "bogus-priv"
echo ""

echo "# Don't use /etc/resolv.conf to get upstreams."
echo "no-resolv"
echo ""

echo "# Resolve against blocklist."
echo "addn-hosts=$(brew --prefix)/etc/dnsmasq.hosts"
echo ""

echo "# Forward to upstreams."
awk '!/^[[:space:]]*$/ && !/^[[:space:]]*#/' "$HOME/.dotfiles/blackhole/upstreams.txt" | sed 's/^/server=/'
echo ""

echo "# Don't cache so dnsmasq acts purely as a forwarding resolver."
echo "cache-size=0"
echo ""

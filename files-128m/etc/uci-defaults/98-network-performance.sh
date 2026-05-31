#!/bin/sh

# DNS cache tuning for the original 128M RAM model. This keeps lookup latency
# low without letting dnsmasq claim too much memory over long uptimes.
uci -q set dhcp.@dnsmasq[0].cachesize='2048'
uci -q set dhcp.@dnsmasq[0].min_cache_ttl='1800'
uci -q set dhcp.@dnsmasq[0].allservers='1'
uci -q commit dhcp

mkdir -p /etc/security
touch /etc/security/limits.conf
grep -qF '* soft nofile 32768' /etc/security/limits.conf || echo '* soft nofile 32768' >> /etc/security/limits.conf
grep -qF '* hard nofile 32768' /etc/security/limits.conf || echo '* hard nofile 32768' >> /etc/security/limits.conf

exit 0

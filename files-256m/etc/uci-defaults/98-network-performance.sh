#!/bin/sh

# DNS cache tuning for the 256M RAM factory model.
uci -q set dhcp.@dnsmasq[0].cachesize='4096'
uci -q set dhcp.@dnsmasq[0].min_cache_ttl='1800'
uci -q set dhcp.@dnsmasq[0].allservers='1'
uci -q commit dhcp

# File descriptor limits for proxy workloads. Keep this idempotent because
# uci-defaults scripts can be retried if any earlier command fails.
mkdir -p /etc/security
touch /etc/security/limits.conf
grep -qF '* soft nofile 32768' /etc/security/limits.conf || echo '* soft nofile 32768' >> /etc/security/limits.conf
grep -qF '* hard nofile 32768' /etc/security/limits.conf || echo '* hard nofile 32768' >> /etc/security/limits.conf

exit 0

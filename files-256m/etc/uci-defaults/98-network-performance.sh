#!/bin/sh

# DNS cache tuning — 256M 版本（主路由场景，无代理负担）。
# cachesize=4096: 有限 RAM 下均衡分配，避免 DNS 缓存占用过多内存
# min_cache_ttl=3600: 较高 TTL 减少上游 DNS 查询频率，节约 CPU/内存资源
#                   主路由无代理切换需求，缓存过期延迟影响较小
# allservers=1: 并发查询所有上游 DNS 服务器，取最快响应
uci -q set dhcp.@dnsmasq[0].cachesize='4096'
uci -q set dhcp.@dnsmasq[0].min_cache_ttl='3600'
uci -q set dhcp.@dnsmasq[0].allservers='1'
uci -q commit dhcp

# File descriptor limits for router workloads. Keep this idempotent because
# uci-defaults scripts can be retried if any earlier command fails.
mkdir -p /etc/security
touch /etc/security/limits.conf
grep -qF '* soft nofile 8192' /etc/security/limits.conf || echo '* soft nofile 8192' >> /etc/security/limits.conf
grep -qF '* hard nofile 8192' /etc/security/limits.conf || echo '* hard nofile 8192' >> /etc/security/limits.conf

# 上游公共 DNS。
uci -q del dhcp.@dnsmasq[0].server
uci -q add_list dhcp.@dnsmasq[0].server='223.5.5.5'
uci -q add_list dhcp.@dnsmasq[0].server='119.29.29.29'
uci commit dhcp

exit 0


#!/bin/sh
# ==========================================
# 首次开机初始化脚本 (执行一次后自动销毁)
# ==========================================

# 1. 强制设置语言、主题、主机名
uci set luci.main.lang='zh_cn'
uci set luci.main.mediaurlbase='/luci-static/aurora'
uci set system.@system[0].hostname='ZN-M2'

# 2. 默认开启防火墙软件与硬件流量卸载 (NSS 核心)
uci set firewall.@defaults[0].flow_offloading='1'
uci set firewall.@defaults[0].flow_offloading_hw='1'

# 3. 保存并应用配置
uci commit luci
uci commit system
uci commit firewall

exit 0#!/bin/sh
# ==========================================
# 首次开机初始化脚本 (执行一次后自动销毁)
# ==========================================

# 1. 强制设置语言为简体中文
uci set luci.main.lang='zh_cn'

# 2. 强制设置主题为 Aurora
uci set luci.main.mediaurlbase='/luci-static/aurora'

# 3. 强制设置主机名为 ZN-M2 
uci set system.@system[0].hostname='ZN-M2'

# 4. 保存并应用配置
uci commit luci
uci commit system

exit 0

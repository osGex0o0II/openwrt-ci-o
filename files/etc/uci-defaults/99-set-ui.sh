#!/bin/sh
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

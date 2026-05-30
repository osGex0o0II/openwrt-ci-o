#!/bin/bash
# =======================================================
# 自定义 DIY 脚本 (针对 兆能 M2 纯有线主路由)
# =======================================================

echo "========== 注入第三方 Aurora 主题 =========="
# 将 Aurora 主题源码克隆到 package 目录下，让 OpenWrt 编译系统能够识别并编译它
git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora

echo "========== DIY 脚本执行完毕 =========="

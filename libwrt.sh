#!/bin/bash
# =======================================================
# 自定义 DIY 脚本 (针对 兆能 M2 纯有线主路由)
# =======================================================

echo "========== 注入第三方 Aurora 主题 =========="
git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora

echo "========== 强制更新 HomeProxy 到最新版 (适配 sing-box 1.12) =========="
# 1. 彻底删除源码树中可能存在的旧版 HomeProxy (防止依赖冲突)
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf package/feeds/luci/luci-app-homeproxy
rm -rf package/luci-app-homeproxy

# 2. 拉取 ImmortalWrt 官方最新版的 HomeProxy 源码
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy

echo "========== DIY 脚本执行完毕 =========="#!/bin/bash
# =======================================================
# 自定义 DIY 脚本 (针对 兆能 M2 纯有线主路由)
# =======================================================

echo "========== 注入第三方 Aurora 主题 =========="
# 将 Aurora 主题源码克隆到 package 目录下，让 OpenWrt 编译系统能够识别并编译它
git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora

echo "========== DIY 脚本执行完毕 =========="

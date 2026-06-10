<div align="center">

# ZN-M2 LiBwrt 6.12 NSS Builds

**为 ZN-M2（兆能 M2）路由器编译的 Qualcomm NSS 硬件加速固件**

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/osGex0o0II/ZN-M2-LiBwrt-Builder/zn-m2-1g-proxy-gateway.yml?branch=main&label=1G%20Build&logo=github&style=for-the-badge)](https://github.com/osGex0o0II/ZN-M2-LiBwrt-Builder/actions/workflows/zn-m2-1g-proxy-gateway.yml)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/osGex0o0II/ZN-M2-LiBwrt-Builder/zn-m2-256m-main-router.yml?branch=main&label=256M%20Build&logo=github&style=for-the-badge)](https://github.com/osGex0o0II/ZN-M2-LiBwrt-Builder/actions/workflows/zn-m2-256m-main-router.yml)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-6.12-00B5E2?logo=openwrt&logoColor=white&style=for-the-badge)](https://openwrt.org)
[![License](https://img.shields.io/github/license/osGex0o0II/ZN-M2-LiBwrt-Builder?style=for-the-badge)](LICENSE)

</div>

---

<div align="center">

![Preview](https://raw.githubusercontent.com/eamonxg/assets/master/aurora/preview/theme/multi-device-showcase.png)

</div>

---

本仓库通过 GitHub Actions 自动编译 ZN-M2 路由器固件，基于 LiBwrt `openwrt-6.x` 的 `main-nss` 分支，启用 Qualcomm NSS 硬件加速。

> **硬件说明**：两个变体的 Wi-Fi 天线均已拆除，作为纯有线路由器使用。1G 改版板载 USB 3.0 接口仅保留供电功能（数据已禁用），256M 原厂无 USB 接口。

## 固件变体

两个变体均作为主路由使用，区别在于 1G 版额外包含透明代理能力（HomeProxy + sing-box）。

| 特性 | 1G (Mod) | 256M (Stock) |
|:---|:---:|:---:|
| 内存 | 1GB | 256MB（实际可用 ~157MB） |
| USB 3.0 | ✅（仅供电） | — |
| 透明代理 (HomeProxy + sing-box) | ✅ | — |
| UPnP / Zerotier / WOL | ✅ | ✅ |
| 定时重启 | ✅ | ✅ |
| ttyd 网页终端 | ✅ | ✅ |
| NSS 硬件加速 | ✅ | ✅ |
| BBR 拥塞控制 | ✅ | ✅ |
| ZRAM 内存交换 | ✅ | ✅ |
| Aurora 主题 | ✅ | ✅ |
| 配置文件 | [`zn-m2-1g-proxygateway.config`](configs/zn-m2-1g-proxygateway.config) | [`zn-m2-256m-mainrouter.config`](configs/zn-m2-256m-mainrouter.config) |

## 刷机方法

### 首次刷入（从原厂固件）

1. 下载对应变体的 `*-factory.ubi` 文件
2. 通过 TFTP 或 U-Boot 刷入固件

### 升级（已运行 OpenWrt/LiBwrt）

1. 下载对应变体的 `*-sysupgrade.bin` 文件
2. 通过 LuCI 网页界面（系统 → 备份/升级）上传刷入，**取消勾选"保留配置"**
3. 或通过 SSH 执行：
   ```sh
   sysupgrade -n /tmp/LiBwrt-*-sysupgrade.bin
   ```

> ⚠️ 建议升级时不保留旧配置（`-n`），避免跨版本配置兼容性问题。

## 使用指南

1. **Fork** 本仓库到你的 GitHub 账户
2. 进入 **Actions** 页面，启用 Workflows
3. 选择对应的变体 Workflow，点击 **Run workflow** 启动编译
4. 编译完成后，从 [Releases](../../releases) 页面下载固件

> 首次编译约需 2-3 小时，启用缓存后后续编译可缩短至 1 小时左右。

## 默认配置

| 项目 | 值 |
|:---|:---|
| 管理地址 | `192.168.1.1` |
| 用户名 | `root` |
| 密码 | `password` |
| 主机名 | `ZN-M2` |
| LuCI 语言 | 简体中文 |
| 默认主题 | Aurora |

> ⚠️ 首次登录后请立即修改默认密码。

## 自定义

- 编辑对应变体的 `.config` 文件可调整软件包（参考 [OpenWrt 包列表](https://openwrt.org/packages/start)）
- `files/` 目录下的文件会在编译时复制到所有变体的固件根目录
- `files-256m/` 目录下的文件仅对 256M 变体生效（如内存适配的 DNS/sysctl 配置）
- 修改 [`libwrt.sh`](libwrt.sh) 可添加自定义编译步骤（如禁用/启用硬件节点、注入第三方包）

## 性能优化

固件默认启用以下网络优化：

- **BBR 拥塞控制** + `fq` qdisc，实测千兆 NAT 吞吐提升 6-10 倍（参考 [openwrt#7733](https://github.com/openwrt/openwrt/issues/7733)）
- **TCP 缓冲区 4MB**，匹配千兆 BDP 带宽延迟积
- **ZRAM 内存交换**，为低内存设备提供 OOM 安全网
- **NSS 硬件加速**，IPQ6000 芯片全程硬件转发

## 致谢

- [LiBwrt/openwrt-6.x](https://github.com/LiBwrt/openwrt-6.x) — 基础源码与 NSS 支持
- [immortalwrt/homeproxy](https://github.com/immortalwrt/homeproxy) — HomeProxy 应用
- [eamonxg/luci-theme-aurora](https://github.com/eamonxg/luci-theme-aurora) — Aurora 主题

## 许可证

[MIT](LICENSE)

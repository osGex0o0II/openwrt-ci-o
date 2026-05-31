# ZN-M2 LiBwrt 6.12 NSS Builds

[![中文](https://img.shields.io/badge/语言-中文-blue)](#中文) [![English](https://img.shields.io/badge/lang-English-red)](#english)

---

<a id="中文"></a>

## 中文

本仓库使用 GitHub Actions 自动编译适用于 **ZN-M2（兆能 M2）** 路由器的 LiBwrt 固件，基于 `openwrt-6.x` 的 `main-nss` 分支，启用 Qualcomm NSS 硬件加速。

### 固件变体

**1G HomeProxy**（`ZN-M2-1G-6.12-NSS-HomeProxy`）
- 适用于 **1GB 内存** 升级版 ZN-M2
- 集成 HomeProxy + sing-box 透明代理、ttyd 网页终端
- 配置文件：`configs/zn-m2-1g-homeproxy.config`

**128M Performance**（`ZN-M2-128M-6.12-NSS-Performance`）
- 适用于 **128MB 原厂内存** ZN-M2
- 移除代理和终端以节省空间，保留 Aurora 主题和性能调优
- 配置文件：`configs/zn-m2-128m-performance.config`

### 共同特性

- Qualcomm NSS 硬件加速
- Aurora 主题、简体中文 LuCI、主机名 `ZN-M2`
- BBR 拥塞控制与基础网络调优
- 禁用 WiFi 和存储相关软件包（纯有线路由）

### 构建

打开 GitHub Actions，运行对应变体的 workflow，构建完成后从匹配的 release tag 下载固件。

### 默认登录

| 项目 | 值 |
|------|-----|
| 地址 | `192.168.1.1` |
| 用户 | `root` |
| 密码 | `password` |

[切换到 English](#english)

---

<a id="english"></a>

## English

This repository builds wired-only LiBwrt `openwrt-6.x` `main-nss` firmware for **ZN-M2** using GitHub Actions, with Qualcomm NSS hardware acceleration enabled.

### Variants

**1G HomeProxy** (`ZN-M2-1G-6.12-NSS-HomeProxy`)
- For the **1GB RAM** upgraded ZN-M2
- Includes HomeProxy, sing-box transparent proxy, and ttyd web terminal
- Config file: `configs/zn-m2-1g-homeproxy.config`

**128M Performance** (`ZN-M2-128M-6.12-NSS-Performance`)
- For the **128MB RAM** original ZN-M2
- Removes proxy and web terminal packages to save space, keeps Aurora theme and performance tuning
- Config file: `configs/zn-m2-128m-performance.config`

### Common Features

- Qualcomm NSS hardware acceleration
- Aurora theme, Simplified Chinese LuCI, hostname `ZN-M2`
- BBR congestion control and basic network tuning
- WiFi and storage-related packages disabled (wired-only router)

### Build

Open GitHub Actions, run the workflow for the variant you need, and download firmware from the matching release tag after the build completes.

### Default Login

| Item | Value |
|------|-------|
| Address | `192.168.1.1` |
| User | `root` |
| Password | `password` |

[Switch to 中文](#中文)

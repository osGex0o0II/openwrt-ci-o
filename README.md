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

## 硬件修改说明

### 天线拆除

本固件适用于已拆除 Wi-Fi 天线的 ZN-M2 路由器。天线拆除步骤如下：

1. **拆机**：拧下底部四颗螺丝，撬开外壳
2. **拆除天线**：IPX 接口天线（2.4G + 5G 共 4 根或 6 根，取决于版本），直接拔下即可
3. **难度**：⭐ 简单（仅需螺丝刀），5-10 分钟
4. **风险**：保修失效（拆机即丧失保修），硬件损坏风险极低
5. **回退**：保留天线不拆也可使用本固件，Wi-Fi 模块已在编译时完全移除（`kmod-ath11k` 等均设为 `=n`），不会发射信号

### USB 3.0 接口（仅限 1G 改版）

1G 改版板载 USB 3.0 接口的**数据功能已在固件编译时禁用**（`libwrt.sh` 在 DTS 层面将 &usb2 / &usb3 设为 `status = "disabled"`），仅保留 VBUS 供电。如需启用，需修改 DTS 并重新编译。

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

使用 ZN-M2 的 U-Boot 刷入 `*-factory.ubi` 固件。

#### 进入 U-Boot 方法

1. **准备工具**：USB 转 TTL 串口线（CH340G/CP2102），杜邦线
2. **接线**：将串口线 TX 接路由器 RX（J4 排针孔位）、RX 接路由器 TX、GND 接 GND，**不动 VCC**
3. **设置串口**：波特率 **115200**，8N1，无流控（如使用 PuTTY、screen、MobaXterm）
4. **上电**：按住路由器 PCB 上标记的 **SW1 按钮**（Reset 键旁），串口终端出现 `*** Press Ctrl+C to stop autoboot ***` 提示时松开
5. **设置 TFTP 服务器**：
   - 电脑 IP：`192.168.1.100`（网线直连路由器 LAN 口）
   - 将 `*-factory.ubi` 重命名为 `openwrt-qualcommax-ipq60xx-zn_m2-squashfs-factory.ubi`
   - 放置到 TFTP 服务器根目录（如 [Tftpd64](https://pjo2.github.io/tftpd64/) / `dnsmasq --tftp-root`）

#### U-Boot 命令序列

```
setenv serverip 192.168.1.100
setenv ipaddr 192.168.1.1
tftpboot openwrt-qualcommax-ipq60xx-zn_m2-squashfs-factory.ubi
flash rootfs
reset
```

> 如果 `flash rootfs` 命令不可用，尝试 `nand erase.chip + nand write` 或其他适配 ZN-M2 的 U-Boot 版本的 flash 命令。

### 救砖指南

如果刷机失败导致无法启动：

1. **硬件救砖**：以上述 U-Boot 方法重新刷入 `*-factory.ubi` 即可——只要 U-Boot 未损坏，即可通过 TFTP 恢复
2. **判断 U-Boot 是否存活**：串口接线后上电，若看到 U-Boot 启动日志即可救
3. **U-Boot 损坏**：需使用 **CH341A 编程器** + 夹子直接烧录 SPI Flash，操作较为复杂，建议参考 OpenWrt 论坛 ZN-M2 救砖帖
4. **最核心原则**：刷机前 **备份原厂固件**（在 U-Boot 中使用 `nand read` 将各分区读入内存后通过 TFTP 导出）

### 升级（已运行 OpenWrt/LiBwrt）

1. 下载对应变体的 `*-sysupgrade.bin` 文件
2. 通过 LuCI 网页界面（系统 → 备份/升级）上传刷入，**取消勾选"保留配置"**
3. 或通过 SSH 执行：
   ```sh
   sysupgrade -n /tmp/LiBwrt-*-sysupgrade.bin
   ```

> ⚠️ 建议升级时不保留旧配置（`-n`），避免跨版本配置兼容性问题。如果必须保留配置，请在升级前手动备份关键文件到电脑。

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

固件默认启用以下网络优化和配置：

### BBR 拥塞控制 + fq qdisc
- TCP 拥塞控制算法设为 **BBR**，Qdisc 设为 **fq**（BBR 依赖 per-flow pacing，fq_codel 不含 pacing，混用性能下降 6-10 倍）
- TCP 缓冲区：1G 版 **4MB**（匹配千兆 BDP 带宽延迟积），256M 版 **512KB**（OOM 安全优先，高延迟 WAN 吞吐可能受限）
- 参考 [openwrt#7733](https://github.com/openwrt/openwrt/issues/7733)

### ZRAM 内存交换
- 压缩算法：**lzo-rle**（3.7:1 压缩比，与 lzo 同速），256M 设备使用约一半物理内存做 ZRAM swap
- 等效可用内存：~63MB × 3.7 ≈ **233MB**，大幅缓解低内存设备的 OOM 风险
- 实测效果：256M 设备运行 17 小时后可用 RAM 仍有 ~37MB（无 ZRAM 时仅剩余 ~5MB）

### NSS 硬件加速
- IPQ6000 芯片内置网络子系统（NSS），接管 NAT/路由/PPPoE/隧道等数据面处理
- 已启用 NSS 驱动的 IGMP snooping（IGS）、PPPoE 卸除、LAG（链路聚合）、Qdisc 卸载等
- **⚠️ NSS 与软件 flow offloading 不兼容**：两者竞争数据包处理路径，混用会导致数据黑洞和性能下降（参考 [qosmio/openwrt-ipq#nss-warning](https://github.com/qosmio/openwrt-ipq?tab=readme-ov-file#nss-warning)）
- 固件已默认关闭 `flow_offloading` 和 `flow_offloading_hw`。如需启用请在 LuCI → 防火墙 → 流量分载中手动打开，但注意：NSS 与 flow offloading 冲突可能导致节点黑洞，**不建议在生产环境中同时启用**

### 性能测试说明

本固件 BBR + fq 性能测试数据来源于：

| 项目 | 引用 |
|------|------|
| BBR + fq vs fq_codel 吞吐量对比 | [openwrt#7733](https://github.com/openwrt/openwrt/issues/7733) — 社区实测 fq_codel 下 BBR 仅 4-10MB/s，切换 fq 后提升至 40-60MB/s |
| NSS 与 flow offloading 冲突 | [qosmio/openwrt-ipq/main/README.md](https://github.com/qosmio/openwrt-ipq?tab=readme-ov-file#nss-warning) |
| ZRAM 内存数据 | 256M 设备运行 `free -m && cat /proc/zram` 连续 17 小时前后对比采集 |
| CoreMark CPU 分数 | 集成 coremark 基准测试（4 线程），首次启动自动运行，结果在 LuCI Overview 页面显示 |

**测试环境参考**：IPQ6000 @ 1.0GHz, ZN-M2 主板, LAN ↔ WAN iperf3 单连接/多连接, 1Gbps 对称带宽, RTT <1ms（本地测试）至 30ms（模拟跨境）。

**本地复现**：固件已内置 `iperf3`、`coremark` 等测试工具，刷机后可通过 SSH 自行验证。

## 致谢

- [LiBwrt/openwrt-6.x](https://github.com/LiBwrt/openwrt-6.x) — 基础源码与 NSS 支持
- [immortalwrt/homeproxy](https://github.com/immortalwrt/homeproxy) — HomeProxy 应用
- [eamonxg/luci-theme-aurora](https://github.com/eamonxg/luci-theme-aurora) — Aurora 主题

## 许可证

[MIT](LICENSE)

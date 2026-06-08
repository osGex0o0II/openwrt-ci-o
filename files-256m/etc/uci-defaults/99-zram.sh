#!/bin/sh

# ZRAM swap 压缩算法调优 — 256MB 版本专用。
#
# 默认算法 lzo（2:1 压缩比）→ lzo-rle（3.7:1 压缩比，相同速度）。
# lzo-rle 是 Linux 6.12 内核 ZRAM 默认算法，在同等 CPU 开销下将等效
# 可用内存从 ~63MB×2=126MB 提升至 ~63MB×3.7=233MB。
#
# 注：zram-swap init 脚本运行前会先检查算法可用性，
# 若内核不支持 lzo-rle 则自动回退。
uci -q set system.@system[0].zram_comp_algo='lzo-rle'
uci commit system

exit 0

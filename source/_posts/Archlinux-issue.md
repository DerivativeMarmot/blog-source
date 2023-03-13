---
title: Archlinux-issue
tags:
  - archlinux
excerpt: 使用 archlinux 时遇到的问题
abbrlink: 85a2cafc
date: 2022-07-29 16:15:38
index_img:
---

# During installation

## virtual machine

### no internet in vm
- 进入 windows 服务管理 services.msc
- 找到并开启 VMware DHCP Service 和 VMware NAT Service
- linux 安装 dhcpcd
- 虚拟机网络选项选择 NAT
- linux 开启 dhcpcd 服务
```shell
> arch-chroot /mnt
> pacman -Syu dhcpcd
> systemctl start dhcpcd
> systemctl enable dhcpcd
```
## phisical machine



# After installed

## virtual machine

## phisical machine
### File ... is corrupted (invalid or corrupted package (PGP signature)).
更新 archlinux-keyring
```shell
> sudo pacman -S archlinux-keyring
```
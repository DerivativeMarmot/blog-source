---
title: windows 下映射网络文件夹 | rclone
excerpt: webdav
index_img: /img/rclone/cover.jpg
tag:
  - windows
  - rclone
  - webdav
abbrlink: '49635e49'
date: 2022-07-26 20:43:23
---
# 简介

windows下映射网络文件夹

# 下载和启动 rclone

```text
https://rclone.org/downloads/
```

解压文件夹，文件夹内打开 cmd，输入

```text
> rclone
```

# config

## 默认 config 路径

```text
> rclone config file
# C:\Users\<username>\AppData\Roaming\rclone\rclone.conf
```

## 生成 config

```text
> rclone config

name = <name> # example(marmot)
type = webdav
url = <网络文件夹> # example(https://dav.xxx.org)
vendor = sharepoint-ntlm # self-host
user = <username> #如果有验证
pass = <password> #如果有验证
```

# 安装 winfsp

```
https://winfsp.dev/rel/
```

不装报错

```text
Fatal error: failed to mount FUSE fs: mount stopped before calling Init: mount failed: cgofuse: cannot find winfsp
```

# 挂载

## 查看列表

```text
> rclone lsf "marmot:"
```

## 挂载在 Z 盘

```text
> rclone mount "marmot:" Z:
```

# 没了
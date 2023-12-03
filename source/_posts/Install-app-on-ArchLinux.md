---
title: Arch Linux Setup
excerpt: 在 arch 上安装各种 app
index_img: /img/Install-app-on-ArchLinux/cover.jpg
tags:
  - archlinux
abbrlink: 56e4b39
date: 2021-07-26 20:43:23
---



# 密钥登陆 | ssh

## 生成

生成密钥对，并将公钥复制进authorized_key
```shell
> ssh-keygen -t ed25519 -b 4096
> mv public.key ~/.ssh/authorized_key
```
将私钥存入本地

## 开启验证，并禁用密码登录和 root 登陆

```shell
> vim /etc/ssh/sshd_config

  PubkeyAuthentication yes
  PasswordAuthentication no
  PermitRootLogin no
```

## 重启ssh

```shell
> sudo systemctl restart sshd.service
```


# 防火墙 firewalld

```shell
> sudo pacman -Syu firewalld
> sudo systemctl enable firewalld.service
> sudo systemctl start firewalld.service # 不会断开已经建立 tcp 链接的端口
> sudo systemctl restart firewalld.service

# 添加端口
> sudo firewall-cmd --zone=public --permanent --add-port=<port>/tcp
> sudo firewall-cmd --zone=public --permanent --add-port=<port>/udp

# 移除端口
> sudo firewall-cmd --zone=public --permanent --remove-port=<port>/tcp
> sudo firewall-cmd --zone=public --permanent --remove-port=<port>/udp
```


# tar

```shell
> tar -zcvf <output> <input> # 压缩
> tar -zxvf <input> -C <ouput> # 解压
	-c new tar file
	-x extract tar file
	-z gzip
	-v show output
	-f archive name
	-C dir
```


# nginx-mainline

## 简介
nginx-mainline 相较于 nginx
- 更多的 feature
- 更新的版本
- 修复了 bug

## setup

```shell
> sudo pacman -Syu nginx-mainline
> paru -S nginx-mainline-mod-dav-ext # 提供 webdav 服务，网络文件夹
> paru -S nginx-mainline-mod-fancyindex # 网络文件索引
```

## 添加 host

```shell
> sudo vim /etc/nginx/nginx.conf
```

### 主域名 | main domain

```shell
server{
	server_name xxx.xxx;
	root path/to/root;
	location / {
		index index.html index.php;
	}
}
```

### 子域名 | subdomain

- 本地文件夹
```shell
server{
	server_name subdomain.xxx.xxx;
	root path/to/dir;
	location / {
		index index.html index.php;
	}
}
```

- 开放出来的端口
```shell
server{
	server_name subdomain.xxx.xxx;
	location / {
		proxy_pass http://127.0.0.1:<port>;
	}
}
```

## 权限

### 403 Forbidden 问题
网页根目录，**其他用户**至少要 r, x 权限，及 005
推荐更改为
```shell
> sudo chmod -R 755 path/to/webroot
```

# certbot

## 安装

```shell
> sudo pacman -Syu certbot-nginx
```

## 添加域名

```shell
> vim /etc/nginx/nginx.conf
server{
    server_name <domain>;
    listen 80;
}
```

## 为域名签证书

```shell
> sudo certbot --nginx --rsa-key-size 4096
```


# qBittorrent

## qBittorrent 安装和运行

安装
```shell
> sudo pacman -Syu qbittorrent-nox
```

运行 qBittorrent
```shell
> qbittorrent-nox
```

弹出的提示语表明 WebUI 已经在 localhost:8080 处运行了

打开浏览器输入地址 + 端口 (例如: 192.168.0.1:8080)

根据提示语，默认用户名是admin，默认密码是adminadmin

登陆进去就能看见 qbittorrent 整体的 WebUI 界面了

## 配置qBittorrent

### 设置语言

- 鼠标停在左上角的 Tools
- 点击Options
- 点击Web UI
- English
- 滑倒最底下找到并点击 简体中文
- 将滚动条滑倒最底下
- 点击s ave

### 配置https

我们回到arch 的命令行上

ctrl+c 关掉正在运行 WebUI

进入 qb 的配置文件夹

```shell
> cd /home/$USER/.config/qBittorrent
```

创建新的文件夹并进入，此文件夹用来存放证书和密钥

```shell
> mkdir ssl
> cd ssl
```

接下来有两个方法可供选择

#### ~~方法1：自己生成密钥（不推荐）~~

##### 生成证书和密钥

```shell
> openssl req -x509 -newkey rsa:4096 -days 365 -keyout server.key -out server.crt -nodes
```

此过程会被询问 国家名字，电子邮件什么的。但这些都不需要管，一直按Enter就可以

运行 ls 命令

```shell
> ls
```

确认有没有 server.crt 和 server.key 这两个文件，有就说明生成成功了

设置这两个文件为只读权限

```shell
> chmod 400 server.crt
> chmod 400 server.key
```

##### 使用证书和密钥

进入 qb 的配置文件

```shell
> cd /home/$USER/.config
> vim qBittorrent.config
```

找到有 WebUI\HTTPS 前缀的的三个参数并添加或更改它们的值

```shell
WebuUI\HTTPS\CertificationPath=/home/$USER/.config/qBittorrent/ssl/server.crt
WebuUI\HTTPS\Eabled=true
WebuUI\HTTPS\KeyPath=/home/$USER/.config/qBittorrent/ssl/server.key
```

最后保存退出 (ESC -> : -> wq -> Enter)

#### 方法2：使用 letsencrypt 获取证书链（推荐）

详情查看 [certbot](#certbot)

获取到的密钥默认会保存在

```shell
> /etc/letsencrypt/live/<your.domain>
```

这里会生成4个 .pem 文件

使用 ls 命令查看（要加sudo），README文件不要管，我们用不着

```shell
> sudo ls /etc/letsencrypt/live/<your.domain>
> cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```


# h5ai

## nginx

```
location / {
	/h5ai/_h5ai/public/index.php
}
```

重启 nginx 服务

```
> sudo systemctl restart nginx.service
```



## 主页面加密码：

https://www.tok9.com/archives/386/



## public/index.php 加密码

```shell
> head /dev/urandom | tr -dc A-Za-z0-9 | head -c length ; echo '' # 随机字符串
> echo -n "密码" |sha512sum # 加密密码
```



### extensions

```shell
> sudo pacman -S imagick # 安装 imagemagick (PDF thumbs)
> sudo pacman -S ffmpeg

> sudo vim /etc/php/php.ini
enable
	gd
	zip
	exif
add
	extension=imagick
> sudo systemctl restart php-fpm.service
```


# AriaNg + aria2 （2023/09/16 更新）

## 简介
AriaNg 是 aria2 的 web-ui

## 下载 AriaNg 静态页面

[AriaNg Releases](https://github.com/mayswind/AriaNg/releases)

## aria2 配置文件
```shell
> mkdir -p ~/.aria2
> touch .aria2/aria2.session # 没有 session 文件会报错
> vim .aria2/aria2.conf
  ## 文件保存设置 ##

  # 下载目录。可使用绝对路径或相对路径, 默认: 当前启动位置
  dir=</path/to/downloads>

  ## RPC 设置 ##

  # 启用 JSON-RPC/XML-RPC 服务器, 默认:false
  enable-rpc=true

  # 接受所有远程请求, 默认:false
  rpc-allow-origin-all=true

  # 允许外部访问, 默认:false
  rpc-listen-all=true

  # RPC 监听端口, 默认:6800
  rpc-listen-port=6800

  # RPC 密钥 非必要
  # rpc-secret=<随机字符串>

  # RPC 服务 SSL/TLS 加密, 默认：false,  如果使用 https 需开启
  # rpc-secure=true

  # 在 RPC 服务中启用 SSL/TLS 加密时的证书文件(.pem/.crt)
  # rpc-certificate=</path/to/fullchain.pem>
  # rpc-private-key=</path/to/.aria2/privkey.pem>
```

## 添加 https 证书
 - 启动后将生成配置文件
 - 添加证书
  ```shell
  > sudo cp /etc/letsencrypt/<domain_name>/fullchain.pem .
  > sudo cp /etc/letsencrypt/<domain_name>/privkey.pem .
  > sudo chown $USER:$USER fullchain.pem privkey.pem
  > chmod 400 fullchain.pem privkey.pem
  > vim .aria2/aria2.conf
    rpc-secure=true
    rpc-certificate=/path/to/fullchain.pem
    rpc-private-key=/path/to/privkey.pem
  ```

## 将 aria2 加入 systemd
```shell
> vim /lib/systemd/system/aria2.service
  [Unit]
  Description=Aria2 Service
  After=network.target

  [Service]
  ExecStart=/usr/bin/aria2c --conf-path=</path/to/aria2.conf>

  [Install]
  WantedBy=default.target

> sudo systemctl enable aria2
> sudo systemctl start aria2
```

# Docker (2022/7/28 更新)

## 安装

```shell
sudo pacman -Syu docker docker-compose
```

## 加入 docker 组
如果不想使用 sudo 来运行 docker 命令，那就将用户加入 docker 组

 - 创建 docker 组（可跳过。一般情况下，当你安装完 docker 后，docker 组会自动创建。）
```shell
> sudo groupadd docker
```

 - 添加用户到 docker 组
```shell
> sudo usermod -aG docker $USER
```

## 启动 docker 服务
```shell
> sudo systemctl start docker.socket
> sudo systemctl enable docker.socket
```

## docker-compose

### 说明
- 基于 docker-compose.yaml 运行 docker
- 可读性强
- 具备较强的可迁移性

### 通用模板
```yml
version: '<docker-compose版本号>'

services:
  <container_specifier>:
    image: <image_name from dockerhub>
    container_name: <container_name>
    volumes:
      - </path/to/dir>:</path/to/dir/in/container>
    ports:
      - <port>:<port>
    command: <cmd>
    user: <id>:<id>
    restart: always
```

- id 获取方式
```shell
> id -u <username>
> id -g <username>
```

### 运行与关闭

```text
docker
├── container1
│	├── # 当前位置
│	└── docker-compose.yaml
│
├── container2
│	└── docker-compose.yaml
│
└── container3
	└── docker-compose.yaml
```

**同级目录存在 docker-compose.yaml 文件才可运行**

```shell
> docker-compose up # 前台运行
> docker-compose up -d # 后台运行

> docker-compose down # 关闭
```


# atom (2022/8/22 更新)

## 简介

- 文本编辑器

## 安装

- 安装 remakepkg
```shell
> paru -S remakepkg
```

- 在 [Arch Linux Repositories](https://archlinux.pkgs.org/) 下载最新版 apm

- 新建 REPKGBUILD，并添加
```shell
> vim REPKGBUILD
remove-depend nodejs-lts-gallium
add-depend nodejs
```

- 更改依赖
```shell
> repkg -i ./<文件名> -r REPKGBUILD
>>> Removing dependency nodejs-lts-gallium
>>> Adding dependency nodejs
>>> Adding provision apm=2.6.5-2
>>> Successfully created ./<新文件名>
```

- 本地安装 apm
```shell
> sudo pacman -U ./<新文件名>
```

- 安装 atom editor
```shell
> paru -S atom-editor-beta-bin
```

# dwm (2022/10/12 更新)
## 简介
窗口管理器

## 安装
```shell
> sudo pacman -Syu xorg xorg-xinit base-devel
> sudo pacman -Syu rofi feh alacritty picom

> cp /etc/X11/xinit/xinitrc ~/.xinitrc
> exec dwm

> git clone git://git.suckless.org/dwm
> cd dwm
> make clean install
> startx
```

# komga

## 简介
管理和查看本地图片集（或漫画）

## 连接 Tachiyomi
- 从 Tachiyomi 添加 kmoga 扩展来支持远程连接 kmoga
- 填写 服务器地址，用户名和密码 来连接 komga 服务器
- Tachiyomi 最大可支持同时连接三个 kmoga 服务器


# NTFS-3G （2023/12/02 更新）

## 简介
用于在 Linux 上装载 NTFS 格式的硬盘。


# 参考内容

[Linux设置密钥登录 - 简书 (jianshu.com)](https://www.jianshu.com/p/51bd2b82ff35)

[设置 SSH 通过密钥登录 | 菜鸟教程 (runoob.com)](https://www.runoob.com/w3cnote/set-ssh-login-key.html)

[Shell 教程 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-shell.html)

[SSL安全证书证书安装_中间证书/证书链安装指南 - 帮助文档 - 亿速云 (yisu.com)](https://www.yisu.com/help/id_104.html)

[nodejs-lts-gallium and nodejs are in conflict](https://bbs.archlinux.org/viewtopic.php?id=275264)

[使用 HTTPS 连接 Aria2](https://tech.he-sb.top/posts/use-https-on-aria2/)

[aria2.service](https://github.com/gutenye/systemd-units/blob/master/aria2/aria2.service)
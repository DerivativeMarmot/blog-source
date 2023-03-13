---
title: 使用 py-kms 激活 Windows 和 Office
excerpt: 无需 exe 程序，一行命令远程激活 Windows 和 Office
tags:
  - windows
  - linux
  - kms
  - py-kms
  - activator
abbrlink: b255e5fb
date: 2022-10-13 23:35:10
index_img: /img/py-kms/cover.png
---

# py-kms

## 简介
激活 Windows 和 Office

## 准备

### 设备

Wincows
Linux

### docker-compose 部署
```yaml
version: '3'

services:
  kms:
    image: ghcr.io/py-kms-organization/py-kms:latest
    ports:
      - 1688:1688
    environment:
      - IP=0.0.0.0
      - HWID=RANDOM
      - LOGLEVEL=INFO
    restart: always
    volumes:
      - ./db:/home/py-kms/db
```
- 冒号左边的端口 ```1688``` 可以改成其他可用的端口

### 安装 Windows （可跳过）


### 自定义安装 Office 套件（可跳过）
<div class="alert alert-info">
    <p class="alert-heading">
        <b>值得一提:</b>
    </p>
    <div class="alert-body">
        <p>自定义安装可<b>自行选择</b>需要安装的套件</p>
    </div>
</div>

- 创建文件夹 ```office_setup```
- 进入 [Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117) 下载 ```Office Deployment Tool```，保存到 ```office_setup``` 中
- 双击运行 ```Office Deployment Tool``` 并提取文件到 ```office_setup``` 中
- 进入 [Office 自定义工具](https://config.office.com/deploymentsettings) 选择需求（版本，想要安装的软件套件 Word，PowerPoint，Excel 等）
  - 推荐选择 Office LTSC 标准版 2021
- 导出 xml 格式的配置文件，命名为 ```all-in-one```，保存到 ```office_setup``` 中
- 打开 cmd 进入```office_setup``` 目录
  - 执行 ```setup.exe /configure all-in-one.xml```
- 等待安装结束

## 激活

<div class="alert alert-warning">
    <p class="alert-heading">
        <b>注意:</b>
    </p>
    <div class="alert-body">
        <p>以下命令需要以管理员身份运行</p>
    </div>
</div>

### 激活 Windows

<div class="alert alert-warning">
    <p class="alert-heading">
        <b>注意:</b>
    </p>
    <div class="alert-body">
        <p>slmgr 命令在 C:\Windows\system32\ 目录下</p>
        <p>无窗口模式：在命令前添加 cscript //nologo 并将 slmgr 改为 slmgr.vbs</p>
    </div>
</div>

```shell
# 安装产品密钥 (可忽略)
system32> slmgr /ipk <产品密钥> 
或
system32> cscript //nologo slmgr.vbs /ipk <产品密钥> 

# 卸载产品密钥 (可忽略)
system32> slmgr /upk 

# 激活 windows (ip:1688)
system32> slmgr /skms <ip地址>:1688 && slmgr /ato 
或
# 激活 windows (端口反代)
system32> slmgr /skms <域名> && slmgr /ato

```

### 激活 Office

<div class="alert alert-warning">
    <p class="alert-heading">
        <b>注意:</b>
    </p>
    <div class="alert-body">
        <p>必须是 volume license (VL) 版本的 Office</p>
        <p>opps 命令在 C:\Program Files\Microsoft Office\OfficeXX 目录下</p>
    </div>
</div>

```shell
# 查看状态，包括后5位产品密钥 (可忽略)
OfficeXX> cscript //nologo ospp.vbs /dstatus 

# 卸载产品密钥 (可忽略)
OfficeXX> cscript //nologo ospp.vbs /unpkey:<后5位> 

# 安装产品密钥 (可忽略)
OfficeXX> cscript //nologo ospp.vbs /inpkey:<产品密钥> 

# 激活 Office (ip:1688)
OfficeXX> cscript //nologo ospp.vbs /sethst:<ip地址> && cscript //nologo ospp.vbs /setprt:1688 && cscript //nologo ospp.vbs /act
或
# 激活 Office (端口反代)
OfficeXX> cscript //nologo ospp.vbs /sethst:<域名> && cscript //nologo ospp.vbs /act
```

看到 ```<Product activation successful>``` 说明激活成功了

## 完善

如果发现右键**新建选项**中没有出现安装的 office 软件，可采取以下任一措施

- 在控制面板中找到 office 右键 -> 更改 -> 快速修复
- 添加并修改新建选项顺序：[更改Windows系统右击新建的文件顺序](https://blog.csdn.net/qq_37504892/article/details/107727369)

# 参考内容

[py-kms on github](https://github.com/SystemRage/py-kms)
[Activation Procedure](https://py-kms.readthedocs.io/en/latest/Usage.html#activation-procedure)
[GVLK keys](https://py-kms.readthedocs.io/en/latest/Keys.html)
[更改Windows系统右击新建的文件顺序](https://blog.csdn.net/qq_37504892/article/details/107727369)
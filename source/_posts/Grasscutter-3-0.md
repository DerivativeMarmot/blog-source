---
title: 部署 Grasscutter 3.0 到远端 archlinux 服务器
tags:
  - grasscutter
  - archlinux
excerpt: 搭建 Grasscutter
abbrlink: c511ff01
date: 2022-08-27 10:10:57
index_img:
---

# 服务器端 (Linux)

## mongodb

## 最新的 jar 包

 - **方法1： 自行编译**
```shell
> git clone https://github.com/Grasscutters/Grasscutter
> cd Grasscutter
> ./gradlew jar
```

 - **方法2： 直接下载(需要登陆 github)**

新建 Grasscutter 文件夹
```shell
> mkdir Grasscutter && cd Grasscutter
```
访问 actions 页面
```link
https://github.com/Grasscutters/Grasscutter/actions/workflows/build.yml
```
 - 找到最新的（最上面的）标有绿色对勾的 workflow，并点击
 - 找到下方的 Artifacts，并点击其中的 Grasscutter 开始下载
 - 下载后解压出 dev jar 包

执行此步骤需要添加 keystore.p12

### 目前文件结构
```text
Grasscutter
├── keystore.p12
└── Grasscutter.jar
```

## 添加 resources

在 Grasscutter 文件夹下新建 resources-koko
```shell
> mkdir resources-koko
```

下载 resources 到 resources-koko 文件夹
```shell
> cd resources-koko
> git clone https://github.com/Koko-boya/Grasscutter_Resources
> cd ..
```

建立软连接
```shell
> ln -s resources-koko/Grasscutter_Resources/Resources/ resources
```

### 目前文件结构

```text
Grasscutter
├── keystore.p12
├── Grasscutter.jar
├── resources -> resources-koko/Grasscutter_Resources/Resources/
└── resources-koko
```

## 初始化

```shell
> java -jar <jar包> # jar 包每个版本名字可能不一样，故用可替换语句代替
```
首次运行会先生成 config.json，并检测能否连接 mongodb 和 resources 是否完整。

### 目前文件结构

```text
Grasscutter
├── keystore.p12
├── Grasscutter.jar
├── resources -> resources-koko/Grasscutter_Resources/Resources/
├── resources-koko
└── config.json
```

## 配置 config

```shell
> vim config.json

修改 http 下的
bindPort: "<port>"
accessAddress: "<serverIP>"
accessPort: "<port>"
# 说明： port 可以是任何已开放并为占用的端口
# 如果

修改 game 下的
accessAddress: "<serverIP>"
accessPort: "22102"
```

## 启动服务器
```shell
> screen -R grasscutter # optional
> java -jar <jar包>
```

# 本地（Windows）

## 启用 mitm proxy

## 开始游戏

 - 下载最新的 zip 包
```link
https://github.com/Grasscutters/Cultivation/releases
```
 - 解压并已管理员的方式运行 cultivation.exe
 - 勾选 connect via Grasscutter，并填入 服务器ip 和 端口
 - 点击右上角齿轮，进入设置
   - 添加 game.exe (不是 launcher.exe)
   - 取消勾选 use internal proxy
 - 退出设置界面
 - 开始游戏
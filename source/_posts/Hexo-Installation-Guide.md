---
title: 个人博客搭建指南 | Hexo篇
excerpt: 搭建自己的个人博客 | Hexo
index_img: /img/Hexo-Installation-Guide/cover.jpg
tags:
  - hexo
  - archlinux
  - github
abbrlink: c4f446aa
date: 2021-01-30 18:36:27
---

<!-- -->
<!--
# 准备
下载并安装 Nodejs，git
切换至 root 用户
```shell
> sudo pacman -Syu nodejs git
> su root
```

## 安装nodejs

在nodejs官网下载二进制压缩包。
```
> mkdir /usr/local/lib/node/nodejs
```
新建文件夹，并将压缩包解压在这个路径下

### 添加全局环境变量

在最后一行添加
```
> vim /etc/profile
# Nodejs
export NODEJS_HOME=/usr/local/lib/node/nodejs
export PATH=$PATH:NODEJS_HOME/bin
```

- *NODEJS_HOME 使系统找到nodejs的安装路径。
- *PATH 是全局环境变量，所以我要添加新的路径，而不是覆写。
- $PATH保存的原来系统的全局环境变量，使用符号 ":" 来分割不同的路径。

在最后一行添加
```
> vim /root/.bashrc
source /etc/profile
```

*用来将 全局环境变量 应用到每个terminal
然后执行

```
source /root/.bashrc
```

*应用.bashrc文件
最后关闭所有的 terminal 再重新打开，这样刚刚添加的全局环境变量就成功应用到了每个打开的 terminal。

## 安装git
```
sudo apt install git
```
### 配置git
```
git config --user.name "<YOUR NAME>"
git config --user.email "<EMAIL ADDRESS>"
```
举个栗子：
```
git config --user.name "DerivativeMarmot"
git config --user.email "DerivativeMarmot@gamil.com"
```

## 检查安装
```
node -v
npm --version
```
-->
<!-- -->

# 准备

## 安装 nodejs，git

```shell
> sudo pacman -Syu nodejs git
```

## 配置 git

通用配置
```shell
> vim ~/.gitconfig
[user]
	name = <username>
	email = <email-address>
	password = <personal-access-token>
[credential]
	helper = cache --timeout <seconds>
[core]
	editor = /usr/bin/vim
```

# 安装 Hexo

## 创建 Blog 文件夹

来到你home的路径下（就是有Documents, Pictures, Downloads 的那个目录下）
```shell
> cd /home/<user>
```

创建 Blog 文件夹并进入
```shell
> mkdir Blog
> cd Blog/
```

## 安装

### 国外安装

通过 npm 安装 hexo，其中 -g 表示 global 意思是 全局安装；hexo-cli 就是 hexo 本体了。
```shell
> npm install -g hexo-cli
```

### 国内安装

```shell
> npm install -g cnpm --registry=https://registry.npm.taobao.org
> cnpm install -g hexo-cli
```
因为网速或其他的原因，使用 [国外安装](#国外安装) 的方法在国内可能会安装失败。
我们先用 npm 安装淘宝的镜像源 cnpm，再用 cnpm 来安装 hexo.

## 检查安装

```shell
> hexo -v
```

# 使用 Hexo

## 快速开始

### 初始化
```shell
> hexo init
```

hexo 在 Blog 文件夹里初始化运行框架所需的文件，请等待一小会儿。
初始化之后会生成一个 hello world 的样本博客可供参考。

### 启动

```shell
> hexo s
```

启动之后，终端提示网页已生成在 localhost:4000。
打开浏览器，在地址栏输入 localhost:4000 就能看到你的博客界面。

## 添加博客

### 新建博客

回到终端，键盘按下 ctrl+c 来停止博客运行。
新建文章。
```shell
> hexo n "MyFirstBlog"
```

n 表示 new 意思是 新建

### 编写博客

进入文章保存文件夹
```shell
> cd source/_post
```

进入到博客本体，在这里你会看到你刚刚创建的博客，文件名是你刚刚取的。
hello_world.md 是之前初始化的时候生成的，你在浏览页面的时候应该也看到了。

随便写点东西。支持markdown格式
```shell
> vim MyFirstBlog.md
```

### 生成博客

```shell
> hexo clean && hexo g && hexo s
```
 - clean: 清理浏览器缓存的作用，并删除 public 下的文件
 - g: generate, 在 public 下生成 html
 - s: start, 启动

### 预览博客

打开浏览器，在地址栏输入 localhost:4000
你应该就能看到，刚刚编写的的博客了

## 添加 README.md

```shell
# 新建 README.md
> touch source/README.md
> echo "# blog supported by [Hexo](https://hexo.io/)" > source/README.md

# 找到 skip_render 参数，并添加 README.md
> vim _config.yml
skip_render: README.md

```

# 部署到远端服务器

## 部署到 github pages

**安装插件**
```shell
> npm install --save hexo-deployer-git
```

### option 1: 部署到主文件夹 github.io

#### 新建仓库

仓库名设置为
```
<username>.github.io
```

#### 更改 _config.yml 文件

在 Blog 文件夹下
```shell
> vim _config.yml
```

找到 deployment 的设置，添加缺失的内容

```shell
deploy:
	type: git
	repo: https://github.com/<username>/<username>.github.io.git
	branch: main
```

#### 部署

```shell
> hexo clean && hexo d
```

#### 浏览

浏览器访问
```plaintext
<usrname>.github.io
```

### option 2: 部署到子文件夹 github.io/blog

<div class="alert alert-warning">
    <p class="alert-heading">
        <b>注意:</b>
    </p>
    <div class="alert-body">
        <p>前提是，可以访问 &lt;username&gt;.github.io </p>
    </div>
</div>

#### 新建仓库

仓库名设置为 blog, 或者其他名字

#### 更改 _config.yml 文件

在 Blog 文件夹下，找到 deployment 的设置，添加缺失的内容
```shell
> vim _config.yml
deploy:
	type: git
	repo: https://github.com/<username>/<刚刚新建的仓库名称>.git
	branch: gh-pages
```

#### 部署

```shell
> hexo clean && hexo d
```

#### 浏览

浏览器访问
```plaintext
<usrname>.github.io/<刚刚新建的仓库名称>
```

<div class="alert alert-warning">
    <p class="alert-heading">
        <b>注意:</b>
    </p>
    <div class="alert-body">
        <p>由于 github 的延迟，等待 2-3 分钟之后，才能看到。</p>
    </div>
</div>


# 迁移
TODO


# 参考资料
[手把手教你从0开始搭建自己的个人博客 |无坑版视频教程| hexo_哔哩哔哩 (゜-゜)つロ 干杯~-bilibili](https://www.bilibili.com/video/BV1Yb411a7ty)
font-family: Monaco, Consolas, "Andale Mono", "DejaVu Sans Mono", monospace;

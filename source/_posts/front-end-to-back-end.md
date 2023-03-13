---
title: 网页前后端连接
abbrlink: 1fca957b
date: 2022-11-07 00:11:20
excerpt: 前端 html 发送表单至后端 mysql
tags:
 - php
 - archlinux
 - docker
 - nginx
 - html
---

# 简介
前端 html 发送表单至后端 mysql


# 安装
```shell
> sudo pacman -Syu nginx php php-fpm
```

# 配置
```shell
> sudo vim /etc/php/php.ini
```
取消注释
```conf
extension=mysqli
```

```shell
> sudo vim /etc/nginx/nginx.conf
```
添加
```conf
location ~ \.php$ {
        # 404
        try_files $fastcgi_script_name =404;

        # default fastcgi_params
        include fastcgi_params;

        # fastcgi settings
        fastcgi_pass			unix:/run/php-fpm/php-fpm.sock;
        fastcgi_index			index.php;
        fastcgi_buffers			8 16k;
        fastcgi_buffer_size		32k;

        # fastcgi params
        fastcgi_param DOCUMENT_ROOT	$realpath_root;
        fastcgi_param SCRIPT_FILENAME	$realpath_root$fastcgi_script_name;
        #fastcgi_param PHP_ADMIN_VALUE	"open_basedir=$base/:/usr/lib/php/:/tmp/";
    }

```

# 启动服务
```shell
> sudo systemctl start php-fpm
> sudo systemctl start nginx
```

# mysql Docker 镜像
```yml
version: '3.1'
services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "3308:3306"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    restart: always
    environment:
      PMA_HOST: db
      PMA_USER: root
      PMA_PASSWORD: root
    ports:
      - "8011:80"
```
```shell
> docker-compose up
```
访问 localhost:8011 进入 phpadmin

# html & php
index.html
```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Contact Form - PHP/MySQL Demo Code</title>
</head>

<body>
    <fieldset>
        <legend>Contact Form</legend>
        <form name="frmContact" method="post" action="./userdata.php">
            <p>
                <label for="username">username </label>
                <input type="text" name="txtUsername" id="txtUsername">
            </p>
            <p>
                <label for="password">password</label>
                <input type="text" name="txtPassword" id="txtPassword">
            </p>
            <p>&nbsp;</p>
            <p>
                <input type="submit" name="Submit" id="Submit" value="Submit">
            </p>
        </form>
    </fieldset>
</body>

</html>
```

userdata.php
```php
<?php
#phpinfo();
$con = mysqli_connect('localhost:3308','root','root','db_connect');

// get the post records
$txtUsername = $_POST['txtUsername'];
$txtPassword = $_POST['txtPassword'];

// database insert SQL code
$sql = "INSERT INTO `tbl_contact` (`username`, `password`) VALUES ('$txtUsername', '$txtPassword')";

// insert in database 
$rs = mysqli_query($con, $sql);

if($rs)
{
	echo "Contact Records Inserted";
}

?>
```

访问 html 填写表单，刷新 phpadmin
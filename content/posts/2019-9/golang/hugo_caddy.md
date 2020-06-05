---
title: "Hugo和caddy github webhook 实现网站的自动更新"
date: 2019-09-11T22:00:05+08:00
draft: false
tags: ["hugo","caddy","go"]
categories: [ "golang 软件" ]
series: ["hugo和caddy"]
img: "images/blog/2019/website.png"
toc: true
---

### hugo

#### 安装hugo
首先到hugo的[release](https://github.com/gohugoio/hugo/releases)下载最新的hugo，同时在[hugo themes](https://themes.gohugo.io/)下载自己喜欢的主题，具体的操作，可以到[hugo](https://gohugo.io)官网了解.

- windows直接下载对应的文件，配置到`path`路径

- linux 下载对应的版本，解压后，把可执行文件放到`/usr/local/bin/`目录下 （一定要将hugo可执行文件拷贝到`/usr/local/bin/`目录下，不然在caddy中会提示没有在path路径中）

  ``` shell
  sudo cp -v hugo /usr/local/bin
  ```
- 如果想要自己编译的话，需要安装`go`环境，具体安装可以自行百度

  ``` shell
  # 通过这个方法安装，同样要把hugo可执行文件，告别到/usr/local/bin目录下
  
  git clone https://github.com/gohugoio/hugo.git
  cd hugo
  go install
  
  # 或者
  go get github.com/gohugoio/hugo
  ```
#### 创建hugo网站

首先，创建一个网站的工作目录`webSite`，在该目录下执行以下命令

```shell
hugo new site example.com
```
然后下载对应的主题，比如我们下[hermit](https://github.com/Track3/hermit)主题，将下载的主题放在`themes`目录下，将`hermit`的`exampleSite`目录下的`content`,`config.toml`，拷贝到`example.com/`目录，替换全部,

执行命令:

``` shell
hugo server
```
启动成功后，根据提示，访问`localhost:1313`就可以访问到网页了.

### Caddy介绍

[Caddy](https://caddyserver.com/)是一个新兴的Web服务器程序，它支持`HTTP/2`和自动的`HTTPS`，考虑到易用性和安全性，`Caddy`可以用于通过单个配置文件快速部署支持`HTTPS`的站点。- 

- 首先要把你的网站域名，解析到你指定的服务器公网IP上

#### 第一步：安装Caddy的最新稳定版

`Windows`用户访问[下载地址](https://caddyserver.com/download)选择对应的`windows`版本下载安装即可。

大多数的服务器都是`linux`，这里详细介绍`linux`的安装过程

![caddy选项](/images/blog/2019/caddy下载.png)

![linux脚本下载](/images/blog/2019/caddy下载2.png)

1. 选择根据你的linux版本选择，我这里是64位

2. 选择`http.git`插件，因为我们后面要通过`github`来实现自动的网页更新

3. 授权方式选择个人

 也可以直接通过shell命令下载相对应的caddy版本
 ``` shell
curl https://getcaddy.com | bash -s personal http.git
 ```

在安装和配置caddy之前，我们需要创建一个非root账户。执行caddy最好使用非root用户，避免使用root用户造成的安全问题。

Caddy二进制文件将被安装在/usr/local/bin

``` shell
which caddy

# 输出
/usr/local/bin/caddy
```

#### 第二步：配置Caddy

使用你刚刚创建的用户账号登录，操作接下来的步骤。

创建一个专门的系统用户：`caddy`和一组同名的caddy：

``` shell
# 注意这里创建的用户 caddy只能用于管理caddy服务，不能用于登录
sudo useradd -r -d /var/www -M -s /sbin/nologin caddy
```

创建网站主目录`/var/www`

``` shell
sudo mkidr -p /var/www/example.com
sudo chown -R caddy:caddy /var/www
```

创建一个目录来存放SSL证书

``` shell
sudo mkdir /etc/ssl/caddy
sudo chown -R caddy:root /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
```

创建专用目录来存放Caddy配置文件`Caddyfile`,`Caddyfile`是用来配置caddy服务器。

``` shell
sudo mkidr /etc/caddy
sudo chown -R root:caddy /etc/caddy

sudo touch /etc/caddy/Caddyfile
sudo chown caddy:caddy /etc/caddy/Caddyfile
cat <<EOF | sudo tee -a /etc/caddy/Caddyfile
example.com {
    root /var/www/example.com
    gzip
    tls admin@example.com
}
EOF
```

1. `example.com`替换为你的域名
2. root 表示为你的网站根路径，就是前面创建的example.com目录
3. gzip 表示启用压缩
4. tls 表示启用HTTPS，`admin@example.com` 替换为你常用的邮箱即可。  
   

如果想要更加深入的配置可以访问[官网](https://caddyserver.com/docs)了解


#### 第三步：配置caddy服务，设置为开启启动

为了方便Caddy的操作，我们把caddy设置为linux中的一个服务，用systemd来管理。

首先创建Caddy systemd文件

``` shell
sudo vi /etc/systemd/system/caddy.service
```

编写内容:

``` shell
[Unit]
Description=Caddy HTTP/2 web server
Documentation=https://caddyserver.com/docs
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Restart=on-abnormal

; User and group the process will run as.
User=caddy
Group=caddy

; Letsencrypt-issued certificates will be written to this directory.
Environment=CADDYPATH=/etc/ssl/caddy

; Always set "-root" to something safe in case it gets forgotten in the Caddyfile.
ExecStart=/usr/local/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
ExecReload=/bin/kill -USR1 $MAINPID

; Use graceful shutdown with a reasonable timeout
KillMode=mixed
KillSignal=SIGQUIT
TimeoutStopSec=5s

; Limit the number of file descriptors; see `man systemd.exec` for more limit settings.
LimitNOFILE=1048576
; Unmodified caddy is not expected to use more than that.
LimitNPROC=512

; Use private /tmp and /var/tmp, which are discarded after caddy stops.
PrivateTmp=true
; Use a minimal /dev
PrivateDevices=false
; Hide /home, /root, and /run/user. Nobody will steal your SSH-keys.
ProtectHome=true
; Make /usr, /boot, /etc and possibly some more folders read-only.
ProtectSystem=full
; … except /etc/ssl/caddy, because we want Letsencrypt-certificates there.
;   This merely retains r/w access rights, it does not add any new. Must still be writable on the host!
ReadWriteDirectories=/etc/ssl/caddy

; The following additional security directives only work with systemd v229 or later.
; They further retrict privileges that can be gained by caddy. Uncomment if you like.
; Note that you may have to add capabilities required by any plugins in use.
;CapabilityBoundingSet=CAP_NET_BIND_SERVICE
;AmbientCapabilities=CAP_NET_BIND_SERVICE
;NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
```

保存退出后，启动Caddy服务并使其在系统引导时自动启动:

``` shell 
sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service
```

#### 第四步：修改防火墙规则

为了允许访问者访问Caddy网站，需要打开80和443端口：

``` shell
sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
```

一般云服务器运营商都会提供一个入站和出战规则，因此如果打开了相关端口，还是无法访问，可以查看入站规则，是否允许80和443端口。

#### 第五步:为你的网站创建一个网页
``` shell
echo '<h1>Hello World!</h1>' | sudo tee /var/www/example.com/index.html
```
重启Caddy服务加载新的内容：
``` shell
sudo systemctl restart caddy.service
```

最后通过`http://example.com`或`https://example.com`。可以看到Hello Worlad!这个的域名替换为你的自己的域名，并且需要解析到你刚刚配置的服务器公网IP。

### 使用github的webhook来实现网站的自动更新，同时将caddy和hugo结合使用

首先我们要创建一个github项目，将我们本地的hugo网站上传到github上

然后我们要修改Caddyfile文件

``` shell
example.com {
    root /var/www/example.com/public
    gzip
    tls admin@example
    git {
       repo https://github.com/XXX/example.com.git
       path /var/www/example.com
       clone_args --recursive
       pull_args --recurse-submodules
       hook /webhook webhook的密码
       then hugo -–destination=/var/www/example.com/puglic
       hook_type github   
    }
}
```

`repo`：你github项目的gith地址

`path`：git下来的项目要保存的位置

`hook`：webhook的地址和密码

`then`：当github项目更新后，执行这段shell命令, `hugo –-destination=/var/www/example.com/puglic`这条命令的意思是，把md文件编译为html的静态文件，提供个给caddy来使用，因此，上面的root路径，我们也要修改为对应的html对应的路径。

修改完Caddyfile文件后，我们需要重启我们的caddy服务
``` shell
sudo systemctl restart caddy.service
```

在该github项目，找到setting
![github_setting](/images/blog/2019/github_setting.png)

![github_webhooks](/images/blog/2019/github_webhook.png)

#### 测试

第一次访问`http://example.com`或`https://example.com`，看到的是全英文的网页.

我们修改 config.toml

``` toml
# 修改为你的网站的域名
baseURL = "https://example.com"
languageCode = "zh-cn"
defaultContentLanguchage = "zh-cn"
title = "我的个人博客"

# 这个改为true，因为要使用中文
hasCJKLanguage = true 

[author]
  name = "xx"

# 我们将以下及格内容修改为中
[menu]
  [[menu.main]]
    name = "文章"
    url = "posts/"
    weight = 10
  [[menu.main]]
    name = "关于"
    url = "about-hugo/"
    weight = 20
```

上传到GitHub上

``` shell
git add .
git commit -m "中文化"
git push origin master
```

等待几分钟，访问`http://example.com`或`https://example.com`，网页的英文变为了中文.

我们成功的首先了hugo和caddy加上github webhook的服务器网页的自动更新.

**参考资料**

[Centos7上安装和配置Caddy](https://3mile.top/archives/2018/05/26/#)

[Caddy+Hugo双GO组合并实现github的webhook钩子推送](https://3mile.github.io/archives/2018/0526/)

[使用hugo搭建博客网站](https://itlaws.cn/post/hugo-guide/)
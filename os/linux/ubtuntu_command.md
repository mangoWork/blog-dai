## Ubuntu常见的命令
### 1.	第一次使用root设置密码
*	sudo passwd root

### 2.ssh的安装
* sudo apt-get install  openssh-server

* 重启ssh命令：

* sudo /etc/init.d/ssh resart

  * 查看ssh是否启动


  * ps -e | grep ssh
  * ssh命令
  * ssh-keygen -t rsa

### 3.设置静态IP
* 在对应的/etc/network/interfaces中添加如下代码

```
  auto eth0
  iface eth0 inet static
  address 192.168.0.117
  gateway 192.168.0.1 #这个地址你要确认下 网关是不是这个地址
  netmask 255.255.255.0
  network 192.168.0.0
  broadcast 192.168.0.255	
```

* 最后重启网卡

  *sudo /etc/init.d/network restart

### 4.端口号查询的相关命令
* netstat -a  查看已经连接的服务端口
* netstat -ap查看所有的端口
* netstat -ap|grep 8080
* lsof -i:8888查看8888端口
* netstat -tap|grep mysql 查看mysql端口已经连接
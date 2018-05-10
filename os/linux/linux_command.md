## linux中常用的命令

### 1. Crontab的格式

*  第一列表示分钟： 1~59
*  第二列小时：1~23
*  第三列表示日：1~31
*  第四列表示月：1~12
*  第五列表示星期：0~6（0表示星期天）
*  第六列表示要运行的命令
*  格式：
  * 分 时 日 月 星期  运行的命令
*  `30 21 * * * /usr/local/apache/bin/apachectl restart`
  * 上面的例子表示每晚的21:30重启apache
*  `45 4 1,10,22 * * /usr/local/apache/bin/apachectl restart`
  * 上面的例子表示每月1、10、22日的4 : 45重启apache
*  `0,30 18-23 * * * /usr/local/apache/bin/apachectl restart`
  * 上面的例子表示在每天18 : 00至23 : 00之间每隔30分钟重启apache
*  `0 */1 * * * /usr/local/apache/bin/apachectl restart`
  * 每一小时重启apache
*  `0 23-7/1 * * * /usr/local/apache/bin/apachectl restart`
  * 晚上11点到早上7点之间，每隔一小时重启apache
*  `0 11 4 * mon-wed /usr/local/apache/bin/apachectl restart`
  * 每月的4号与每周一到周三的11点重启apache
*  `0 4 1 jan * /usr/local/apache/bin/apachectl restart`
  * 一月一号的4点重启apache
*  `0 6 */2 * * /command `
  * 看到这个我们如果理解成每xx执行就是，每两天的6点钟执行命令。在这里*的范围是1-31，*/2表示任务在奇数天执行，那么在1、3、5、7、8、10、12月，月末最后一天执行后，紧接着第二天仍然后执行，那这就不是每2天执行一次。

### 2.  Centos开放80端口

* 命令如下所示：

  >  firewall-cmd --zone=public --add-port=80/tcp --permanent

* 当执行以上命令的时候，如果出现了success表明添加成功

* 命令含义：

  --zone # 作用域

  --add-port=80/tcp # 添加端口，格式为：端口/通讯协议

  --permanent # 永久生效，没有此参数重启后失效

* 接着重启防火墙

  > systemctl restart firewall.service

### 3.  如何让连接新主机时，不进行公钥确认

* 在首次连接服务器的时候， 会弹出公钥确认的提示，会导致任务失败。SSH客户端的StrictHostKeyChecking配置指令，可以实现当第一次连接服务器时，自动接收新的公钥。只需要修改``/etc/ssh/ssh_config``文件，包含下列句子：

  ```shell
  Host localhost
    StrictHostKeyChecking no
  Host 0.0.0.0
    StrictHostKeyChecking no
  # 主机名以hadoop-*开头不用检查ssh公钥  在/etc/ssh/ssh_config 文件
  Host hadoop-mango-*
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null    # 防止远程主机公钥改变导致 SSH 连接失败
  ```

  ​


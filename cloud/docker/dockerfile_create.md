## Dockerfile文件的编写

### 1.	docker的基本框架

* Dockerfile一般包含下面几个部分：

  1. 基础镜像
  2. 景象维护者
  3. 镜像操作命令
  4. 容器启动命令：当容器基于该镜像的容器启动的时候需要执行哪些命令

* 容器基本内容如下：

  ```shell
  # Version 0.1

  # 基础镜像
  FROM ubuntu:lastest

  # 维护者信息
  MATAINER 1192297699@qq.com

  # 镜像操作命令
  RUN apt-get -yqq update && apt-get install -yqq apache2 && apt-get clean

  # 启动容器命令
  CMD["/usr/sbin/apachectl", "-D", "FOREGROUND"]
  ```

* 切换到dockerfile所在的目录，执行

  ```shell
  cd /home/dlm/tomcatiso
  docker build -t dlm:0.1
  ```

### 2.dockerfile编写常用命令 

* 指定容器运行的用户

  * 该用户最为后续的run命令的执行用户

    ```shell
    User dlm
    ```

* 指定为后续命令的执行目录

  * 由于我们需要运行的是一个静态网站，将启动后的工作目录切换到/var/www/html

    ```shell
    WORKDIR /var/www/html
    ```

* 对外连接端口号

  * 由于内部服务会启动web服务，我们需要把对应的80端口暴露出来，可以提供给容器间互联使用，可以使用命令EXPOSE，在镜像中添加一句：

    ```shell
    EXPOSE 80
    ```

* 设置容器主机名

  * ENV命令能够对容器的环境变量进行设置，我们使用命令设置由该容器的主机名为dlm，向dockerfile添加一句：

    ```shell
    ENV HOSTNAME dlm
    ```

* 向镜像中添加文件

  * 向镜像中添加文件有两种命令：COPY和ADD。

    ```shell
    COPY tmp.txt /var/www/html
    ```

  * ADD命令支持添加本地的tar压缩包到指定的目录，压缩包会被解压为目录，也可以自动下载URL并拷贝到镜像，例如：

    ```shell
    ADD tmp.tar /var/www/html
    ADD http://www.daiqiaobing.net/zookeeper.tar /var/www/html
    ```

### 3.CMD与ENTRYPOINT

* ENTRYPOINT 容器启动后执行命令，让容器执行表现的向一个可执行程序一样，与CMD的区别是不可被docker run覆盖，会把docker run后面的参数传递给ENTRYPOINT指令的参数。dockerfile中只能指定一个ENTRYPOINT，如果指定了很多，只有最后一个有效。docker run命令的-entrypoint参数可以把指定的参数继续传递给ENTRYPOINT。

### 4.挂载数据卷

* 将apache访问的日志数据存在宿主机可以访问的数据卷中：

  ```shell
  VOLUME ["/var/log/apache2"]
  ```

### 5.设置容器内的环境变量

* 编写如下所示：

  ```shell
  ENV APACHE_RUN_USER www-data
  ENV APACHE_RUN_GROUP www-data
  ENV APACHE_LOG_DIR /var/log/apche2
  ENV APACHE_PID_FILE /var/run/apache2.pid
  ENV APACHE_RUN_DIR /var/run/apache2
  ENV APACHE_LOCK_DIR /var/lock/apche2
  ```

### 6. dockerfile完整示列

```shell
# Version 0.2

# 基础镜像
FROM ubuntu:latest

# 维护者信息
MAINTAINER shiyanlou@shiyanlou.com

# 镜像操作命令
RUN apt-get -yqq update && apt-get install -yqq apache2 && apt-get clean
RUN apt-get install -yqq supervisor
RUN mkdir -p /var/log/supervisor

VOLUME ["/var/log/apche2"]

ADD html.tar /var/www
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html

ENV HOSTNAME shiyanloutest
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apche2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apche2

EXPOSE 80

# 容器启动命令
CMD ["/usr/bin/supervisord"]
```
















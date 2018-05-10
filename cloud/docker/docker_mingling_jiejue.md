# docker命令以及问题解决
## docker命令

1. docker导入导出镜像或者容器

   * docker导入镜像

     ```shell
     docker load < image.tar
     ```

   * docker导出镜像

     ```shell
     docker save images > /opt/image.tar
     ```

   * 导入容器

     ```shell
     docker import tomcat.tar
     ```

   * 导出容器

     ```shell
     docker export b9123723b2n3 > tomcat.tar
     ```

     ​

## docker问题解决
### 1.如何解决docker拉取镜像速度慢的问题？
*	在dockerpull的时候指定远程仓库路径
  * docker pull daocloud.io/library/ubuntu:tag


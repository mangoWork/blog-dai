# python中错误解决

## 1. Django中的错误解决

1. 启动web的时候的错误为：‘’‘解决：CentOS下的 error while loading shared libraries: libmysqlclient.so.16: cannot open shared object file: No such file or dir’

   * 原因：
     * 缺少共享库libmysqlclient.so.20，般都是ldconfig 没有找到共享库的位置，或者 软链接的问题


   * 解决办法：

     * 先找到对应的libmysqlclient.so文件，或者下载（如果下载则忽略这一步骤）

       ```shell
       updatedb
       locate libmysqlclient.so
       ```

     * 到libmysqlclient.so 文件下做一个软连接到/usr/lib

       ```shell
       ln -s /usr/local/mysql/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.20
       ```

       ​

     ​

     ​


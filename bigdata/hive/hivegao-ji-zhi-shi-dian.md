### Hive知识点
#### HiveServer2
* 开启Hive服务，用于远程操作，一般用于JDBC/ODBC
* 其中JDBC的操作跟操作mmysql数据库类似(使用JDBC连接之前一定要先启动hiveserver2)

#### Hive数据压缩
* 常见的压缩(压缩格式: bzip2, gzip, lzo, snappy等
)
    * 压缩比：bzip2>gzip>lzo bzip2最节省存储空间
    * 解压速度：lzo>gzip>bzip2 lzo解压速度是最快的

#### Hive数据存储

#### Hive的优化

#### Hive使用案例
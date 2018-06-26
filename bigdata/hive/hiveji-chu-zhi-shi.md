## Hive的基础知识以及相关的概念

### Hive是什么？

&nbsp;　　Hive是基于Hadoop的一个数据仓库工具，可以将结构化数据文件映射为一张表，并提供类SQL查询的功能。

&nbsp;　　1. 使用HQL作为查询接口。
&nbsp;　　2. 使用HDFS作为存储
&nbsp;　　3. 使用MapReduce进行计算

&nbsp;　　**Hive的本质是将HQL转换为MapReduce程序**

1. 灵活性和扩展性比较好：支持UDF，自定义文件存储格式等；
2. 适合离线处理数据；

### Hive的架构

> Hive的架构包括用户接口、元数据、Hadoop、驱动器，如下图所示


#### 用户接口：Client
&nbsp;　　CLI(Hive shell)、JDBC/ODBC(Java访问Hive)，WebUI(浏览器访问Hive)
#### 元数据：MetaStore
&nbsp;　　元数据包括：表名、表所属的数据库(默认是default)、表的拥有者、列/分区字段、表的类型(是否是外部表)、表的数据所在目录等。
#### Hadoop
&nbsp;　　使用HDFS进行存储，使用MapReduce进行计算。
#### 驱动器：Driver



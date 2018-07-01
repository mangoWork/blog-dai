### Hive知识点
#### HiveServer2
* 开启Hive服务，用于远程操作，一般用于JDBC/ODBC
* 其中JDBC的操作跟操作mmysql数据库类似(使用JDBC连接之前一定要先启动hiveserver2)

#### Hive数据压缩
* 常见的压缩(压缩格式: bzip2, gzip, lzo, snappy等
)
    * 压缩比：bzip2>gzip>lzo bzip2最节省存储空间
    * 解压速度：lzo>gzip>bzip2 lzo解压速度是最快的
* 四种压缩对比
|压缩格式|split|native|压缩率|速度|是否hadoop自带|linux命令|换成压缩格式后，原来的应用程序是否要修改|
|:----:|:----:|:----:|:----:|:----:|:------:|
|gzip|否|是|很高|比较快|是，直接使用|有|和文本处理一样，不需要修改|
|lzo|是|是|比较高|很快|否，需要安装|有|需要建索引，还需要指定输入格式|
|snappy	|否|是|比较高|很快|否，需要安装|没有|和文本处理一样，不需要修改|
|bzip2|是|否|最高|慢|是，直接使用	|有|和文本处理一样，不需要修改|


#### Hive数据存储

* 数据文件的是存储主要有以下几种：
    * Avro (Hive 0.9.1 and later)
    * ORC (Hive 0.11 and later)
    * RegEx
    * Thrift
    * Parquet (Hive 0.13 and later)
    * CSV (Hive 0.14 and later)
    * JsonSerDe (Hive 0.12 and later in hcatalog-core)

* 什么是行式存储和列式存储？
    * 现在有一张表，如图所示：
    ![](./img/fields.png)
    
    * 行式存储，如下所示：
    ![](./img/rows.png)

    * 列式存储，如下所示：
    ![](./img/cloumns.png)
    
#### Hive的优化

#### Hive使用案例
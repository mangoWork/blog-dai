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
&nbsp;　　**解析器：**将SQL字符串转换为抽象的语法树AST，这一步一般都用第三方工具库完成，比如antlr；对AST进行语法分析，比如表是否存在、字段 是否存在、SQL语义是否有误(比如select中被判定为聚合的字段在group by中是否出现)；
&nbsp;　　**编译器：**将AST编译生成逻辑执行计划；
&nbsp;　　**优化器：**对逻辑执行计划进行优化；
&nbsp;　　**执行器：**把逻辑执行计划转换为可以运行的物理计划。对于Hive来说就是MR/TEZ/Spark;

### Hive优点与使用场景
#### 优点
* 操作接口采用类SQL语法，提供快速开发能力(简单、容易上手)；
* 避免了去写MapReduce，减少开发人员的学习成本；
* 统一的元数据管理，可与impala/Spark共享元数据；
* 易扩展(HDFS+MapReduce:可扩展集群规模；支持自定义函数)

#### 使用场景
* 数据的离线处理；比如：日志分析，海量结构化数据离线分析...
* Hive的执行延迟比较高，因此Hive常用语数据分析的，对实时性要求不高的场合；
* Hive优势在于处理大数据，对于处理小数据没有优势，因此Hive的执行延迟比较高。

### Hive安装

#### 数据仓库位置的配置

```xml
	<!-- default
		/user/hive/warehouse
	注意事项
		* 在仓库目录下，没有对默认的数据库default创建文件夹
		* 如果某张表属于default数据库，直接在数据仓库目录下创建一个文件夹 -->
	<property>
		<name>hive.metastore.warehouse.dir</name>
		<value>/user/hive/warehouse</value>
	</property>
```

* 在安装的时候需要对hdfs中的hive仓库的目录进行权限的赋值：


```shell
  $HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
  $ $HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
  $ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
  $ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse
```

#### Hive运行日志的配置

* 对应的日志文件路径的配置($HIVE_HOME/conf/hive-log4j.properties
)

```properties
hive.log.dir=/opt/modules/hive-0.13.1/logs
hive.log.file=hive.log
```

* 制定Hiv运行时现实log日志级别($HIVE_HOME/conf/hive-log4j.properties)

```properties
hive.root.logger=INFO,DRFA
```

#### 在cli命令行上显示当前数据库，以及查询表的行头信息
* 编辑文件``$HIVE_HOME/conf/hive-site.xml``

```xml
		<property>
			<name>hive.cli.print.header</name>
			<value>true</value>
			<description>Whether to print the names of the columns in query output.</description>
		</property>

		<property>
			<name>hive.cli.print.current.db</name>
			<value>true</value>
			<description>Whether to include the current database in the Hive prompt.</description>
		</property>
```

#### 在启动的时候配置属性信息

```shell
$ bin/hive --hiveconf <property=value>
```

####  查看当前所有的配置信息
```shell
	hive > set ;

	hive (db_hive)> set system:user.name ;
		system:user.name=beifeng
	hive (db_hive)> set system:user.name=beifeng ;

	此种方式，设置属性的值，仅仅在当前会话session生效
```	

#### Hive命令帮助

```shell
[beifeng@hadoop-senior hive-0.13.1]$ bin/hive -help
usage: hive
 -d,--define <key=value>          Variable subsitution to apply to hive
                                  commands. e.g. -d A=B or --define A=B
    --database <databasename>     Specify the database to use
 -e <quoted-query-string>         SQL from command line
 -f <filename>                    SQL from files
 -H,--help                        Print help information
 -h <hostname>                    connecting to Hive Server on remote host
    --hiveconf <property=value>   Use value for given property
    --hivevar <key=value>         Variable subsitution to apply to hive
                                  commands. e.g. --hivevar A=B
 -i <filename>                    Initialization SQL file
 -p <port>                        connecting to Hive Server on port number
 -S,--silent                      Silent mode in interactive shell
 -v,--verbose                     Verbose mode (echo executed SQL to the
                                 console)

* bin/hive -e <quoted-query-string>
eg:
	bin/hive -e "select * from db_hive.student ;"

* bin/hive -f <filename>
eg:
	$ touch hivef.sql
		select * from db_hive.student ;
	$ bin/hive -f /opt/datas/hivef.sql 
	$ bin/hive -f /opt/datas/hivef.sql > /opt/datas/hivef-res.txt
```

* bin/hive -i <filename> （与用户udf相互使用）

* 在hive cli命令窗口中如何查看hdfs文件系统（hive (default)> dfs -ls / ） 

* 在hive cli命令窗口中如何查看本地文件系统(hive (default)> !ls /opt/datas)


##### Hive中桶以及分区
&nbsp;　　**分区：**由于Hive实际是存储在HDFS上的抽象，Hive的一个分区名对应一个目录名，子分区名就是子目录名，并不是一个实际字段。按照数据表的某列或某些列分为多个区，区从形式上是文件夹（HDFS里的文件夹）

&nbsp;　　**桶：**相较于分区，分桶的粒度更小，而且与分区不同的是，分区是人为设定分区字段建立一个用于管理的“伪列”，而分桶是按照某列的属性值的Hash计算结果进行区分。 
&nbsp;　　eg.按照id属性分为3个桶，就是对id属性值的hash值对3取摸，按照取模结果对数据分桶。如取模结果为0的数据记录存放到一个文件，取模为1的数据存放到一个文件，取模为2的数据存放到一个文件。





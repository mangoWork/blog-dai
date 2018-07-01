### 深入了解Hive知识点

#### 数据库的操作
1. 创建数据库

    ```shell
      CREATE (DATABASE|SCHEMA) [IF NOT EXISTS] database_name
      [COMMENT database_comment]
      [LOCATION hdfs_path]
      [WITH DBPROPERTIES (property_name=property_value, ...)];
    ```

2. 删除数据库

  ```shell
    DROP (DATABASE|SCHEMA) [IF EXISTS] database_name [RESTRICT|CASCADE];
  ```

3. 修改数据库

  ```shell
  ALTER (DATABASE|SCHEMA) database_name SET DBPROPERTIES (property_name=property_value, ...);   -- (Note: SCHEMA added in Hive 0.14.0)
 
  ALTER (DATABASE|SCHEMA) database_name SET OWNER [USER|ROLE] user_or_role;   -- (Note: Hive 0.13.0 and later; SCHEMA added in Hive 0.14.0)
  
  ALTER (DATABASE|SCHEMA) database_name SET LOCATION hdfs_path; -- (Note: Hive 2.2.1, 2.4.0 and later)
  ```

4. 使用数据库

  ```shell
  USE database_name;
  USE DEFAULT;
  
  ```
  
5. 查看数据库信息

  ```shell
  desc database db_hive_03 ;
  desc database extended db_hive_03 ;
  ```
  * **extended**（更详细）
  
#### 表的操作(*)

1. 创建表

```shell
# 创建表，指定表的类型，表的名称
CREATE [TEMPORARY] [EXTERNAL] TABLE [IF NOT EXISTS] [db_name.]table_name
  ## 表的列，包含列的名称、列的类型
  [(col_name data_type [COMMENT col_comment], ... [constraint_specification])]
  ## 表的描述
  [COMMENT table_comment]
  ## 分区表，指定分区的列的名称，类型
  [PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)]
  ## 数据文件中数据存储格式，每行分隔，每列分隔，数据文件类型
  [
   [ROW FORMAT row_format] 
   [STORED AS file_format]
     | STORED BY 'storage.handler.class.name' [WITH SERDEPROPERTIES (...)]  -- (Note: Available in Hive 0.6.0 and later)
  ]
  ## 数据文件在HDFS上的位置
  [LOCATION hdfs_path]
  ## 表的属性设置
  [TBLPROPERTIES (property_name=property_value, ...)]   -- (Note: Available in Hive 0.6.0 and later)
  ## 子查询
  [AS select_statement];   -- (Note: Available in Hive 0.5.0 and later; not supported for external tables)
 
 # 创建表，指定表的类型[TEMPORARY] [EXTERNAL]
CREATE [TEMPORARY] [EXTERNAL] TABLE [IF NOT EXISTS] [db_name.]table_name
  ## 指定表结构相同的表的名称
  LIKE existing_table_or_view_name
  ## 数据文件在HDFS上的位置
  [LOCATION hdfs_path];
 
 ## 表中列的数据类型
data_type
  : primitive_type(*)
  | array_type
  | map_type(*)
  | struct_type
  | union_type  -- (Note: Available in Hive 0.7.0 and later)
 
primitive_type
  : TINYINT
  | SMALLINT
  | INT
  | BIGINT
  | BOOLEAN
  | FLOAT
  | DOUBLE
  | DOUBLE PRECISION -- (Note: Available in Hive 2.2.0 and later)
  | STRING
  | BINARY      -- (Note: Available in Hive 0.8.0 and later)
  | TIMESTAMP   -- (Note: Available in Hive 0.8.0 and later)
  | DECIMAL     -- (Note: Available in Hive 0.11.0 and later)
  | DECIMAL(precision, scale)  -- (Note: Available in Hive 0.13.0 and later)
  | DATE        -- (Note: Available in Hive 0.12.0 and later)
  | VARCHAR     -- (Note: Available in Hive 0.12.0 and later)
  | CHAR        -- (Note: Available in Hive 0.13.0 and later)
 
array_type
  : ARRAY < data_type >
 
map_type
  : MAP < primitive_type, data_type >
 
struct_type
  : STRUCT < col_name : data_type [COMMENT col_comment], ...>
 
union_type
   : UNIONTYPE < data_type, data_type, ... >  -- (Note: Available in Hive 0.7.0 and later)
 
 ## 数据文件中数据存储格式
row_format
  : DELIMITED 
  ## 每列数据分隔符
  [FIELDS TERMINATED BY char [ESCAPED BY char]] [COLLECTION ITEMS TERMINATED BY char]
        [MAP KEYS TERMINATED BY char]
  ## 每行数据分隔符
  [LINES TERMINATED BY char]
        [NULL DEFINED AS char]   -- (Note: Available in Hive 0.13 and later)
  | SERDE serde_name [WITH SERDEPROPERTIES (property_name=property_value, property_name=property_value, ...)]
 ## 数据文件存储格式
file_format:
  : SEQUENCEFILE
  | TEXTFILE (*)    -- (Default, depending on hive.default.fileformat configuration)
  | RCFILE      -- (Note: Available in Hive 0.6.0 and later)
  | ORC (*)        -- (Note: Available in Hive 0.11.0 and later)
  | PARQUET     -- (Note: Available in Hive 0.13.0 and later)
  | AVRO        -- (Note: Available in Hive 0.14.0 and later)
  | JSONFILE    -- (Note: Available in Hive 4.0.0 and later)
  | INPUTFORMAT input_format_classname OUTPUTFORMAT output_format_classname
 
constraint_specification:
  : [, PRIMARY KEY (col_name, ...) DISABLE NOVALIDATE ]
    [, CONSTRAINT constraint_name FOREIGN KEY (col_name, ...) REFERENCES table_name(col_name, ...) DISABLE NOVALIDATE 
```

* 实例
  * 简单的创建表
    ```shell
    create table mango.emp(
      empno int,
      ename string,
      job string,
      mgr int,
      hiredate string,
      sal double,
      comm double,
      deptno int
      )
      row format delimited fields terminated by '\t';
    ```
  * 通过**as select**创建表
    ```shell
      CREATE TABLE new_key_value_store
         ROW FORMAT SERDE "org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe"
         STORED AS RCFile
         AS
      SELECT (key % 1024) new_key, concat(key, value) key_value_pair
      FROM key_value_store
      SORT BY new_key, key_value_pair;
    ```

  * 通过**Like**创建表
  ```shell
    CREATE TABLE empty_key_value_store
  LIKE key_value_store [TBLPROPERTIES (property_name=property_value, ...)];
  ```
  
  
* **EXTERNAL** 
  * 内部表也称之为MANAGED_TABLE；
    * 默认存储在/user/hive/warehouse下，也可以通过location指定
    * 删除表时，会删除表数据以及元数据
  * 外部表称之为EXTERNAL_TABLE；
    * 在创建表时可以自己指定目录位置(LOCATION)；
    * 删除表时，只会删除元数据不会删除表数据
    
* **location**
> 设置数据存储在HDFS中的位置

* 分区表
  * 分区表实际上就是对应一个HDFS文件系统上的独立的文件夹，该文件夹
下是该分区所有的数据文件。Hive中的分区就是分目录，把一个大的数据
集根据业务需要分割成更小的数据集。
  * 在查询时通过WHERE子句中的表达式来选择查询所需要的指定的分区，
这样的查询效率会提高很多。
  * 分区表在HDFS中的对对应的存储的目录如下所示：

  ```shell
    	/user/hive/warehouse/bf_log/
		/20150911/
			20150911.log
		/20150912/
			20150912.log
  ```
  
  * 相关案例如下所示：
  
  ```shell
  create EXTERNAL table IF NOT EXISTS default.emp_partition(
      empno int,
      ename string,
      job string,
      mgr int,
      hiredate string,
      sal double,
      comm double,
      deptno int
    )
    partitioned by (month string,day string)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' ;
    
  load data local inpath '/opt/datas/emp.txt' into table default.emp_partition partition (month='201509',day='13') ;
  
  select * from emp_partition where month = '201509' and day = '13' ;
  
  ```

* 通过导入数据到HDFS使得在Hive中生效：
  * 方式一
  
  ```shell
  dfs -mkdir -p /user/hive/warehouse/dept_part/day=20150913 ;
  dfs -put /opt/datas/dept.txt /user/hive/warehouse/dept_part/day=20150913 ;

  hive (default)> msck repair table dept_part ;
  ```
  
  * 方式二
  
  ```shell
  dfs -mkdir -p /user/hive/warehouse/dept_part/day=20150914 ;
  dfs -put /opt/datas/dept.txt /user/hive/warehouse/dept_part/day=20150914 ;
  
  alter table dept_part add partition(day='20150914');
  ```
  
#### 加载数据到Hive中

* 使用方式 
> load data [local] inpath 'filepath' [overwrite] into table tablename [partition (partcol1=val1,...)];

* 原始文件存储的位置
	* 本地 local
	* hdfs
* 对表的数据是否覆盖
	* 覆盖 overwrite
	* 追加
* 分区表加载，特殊性
	partition (partcol1=val1,...)

#### 加载数据的五种方式 

1. 加载本地文件到hive表
load data local inpath '/opt/datas/emp.txt' into table default.emp ;
2. 加载hdfs文件到hive中
load data inpath '/user/beifeng/hive/datas/emp.txt' overwrite into table default.emp ;
3. 加载数据覆盖表中已有的数据
load data inpath '/user/beifeng/hive/datas/emp.txt' into table default.emp ;
4. 创建表是通过insert加载
create table default.emp_ci like emp ;
insert into table default.emp_ci select * from default.emp ;
5. 创建表的时候通过location指定加载
5. 创建表的时候通过select加载


#### 导出查询的结果 ：

```shell
insert overwrite local directory '/opt/datas/hive_exp_emp'
select * from default.emp ;

insert overwrite local directory '/opt/datas/hive_exp_emp2'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' COLLECTION ITEMS TERMINATED BY '\n'
select * from default.emp ;

bin/hive -e "select * from default.emp ;" > /opt/datas/exp_res.txt

insert overwrite directory '/user/beifeng/hive/hive_exp_emp' select * from default.emp ;
```

#### 
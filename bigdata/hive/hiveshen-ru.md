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



### 深入了解Hive知识点


#### 数据库的操作
1. 查看数据库

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


#### 表的操作(*)




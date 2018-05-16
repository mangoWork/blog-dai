### Spark的重要扩展
    > Spark的基础平台扩展了5个主要的Spark库，包括支持结构化数据的Spark SQL、处理实时数据的Spark Streaming、用于机器学习的MLib、用于图形计算的GraphX、用于统计分析的SparkR，各种程序库与Spark核心API高度整合在一起，并在不断改进。

#### Spark SQL和DataFrame
    * Spark SQL是Spark的一个处理结构化数据的模块，提供一个DataFrame编写抽象。它可以看作是一个分布式SQL查询引擎，主要由Catalys优化、Spark SQL内核、Hive支持三部分组成。
    * DataFrame是以指定列组织的分布式数据集合，在Spark SQL中，相当于关系数据库的一个表，或R/Python的一个数据框架。
    * DataFrames支持多种数据源构建，如下图所示：
    ![DataFrames支持多种数据源构建](../img/dataframes_data.png)

#### Spark Streaming
    * Spark Streaming属于核心Spark 的扩展，支持，高吞吐量和容错的实时流数据处理，它可以接受来自Kafka、Flume、Twitter、ZeroMQ或TCP SOcket的数据源，使用复杂的算法和高级功能来进行处理，如Map、Reduce、Join、Window等，处理的结果数据能够存入文件系统、数据库。

#### Spark MLib和ML
    * MLib是Spark对常用机器学习算法的实现库。MLib支持4种最常见的机器学习问题：二元分类、回归、聚类和协同过滤以及一个底层的梯度下降优化基础算法。

![spakr结构图](../img/spark_arch.png)
## Spark简介
### 1. Spark是什么？
    Spark是基于内存计算的大数据并行计算框架。Spark基于内存计算，提高了在大数据环境下数据处理的实时性，同时保证了容错性和高可伸缩性，允许用户将Spark部署在大量廉价硬件之上形成集群。

### 2. Spark与Hadoop

    更准确的说，Spark是一个计算框架，而Hadoop中包含计算框架MapReduce和分布式文件系统HDFS，Hadoop更广泛地说还包括在其生态系统之上的其他系统，如Hbase、Hive等。

#### Spark相对于Hadoop的优势
* 中间结果输出
    * 基于MapReduce的计算引擎通常会将中间结果输出到磁盘上，进行存储和容错。出于任务管道承接的考虑，当一些查询结果翻译到MapReduce任务时，往往会产生多个Stage，而这些串联的Stage又依赖于底层文件系统(HDFS)来存储每一个Stage。
    Spark将执行模型抽象为通用的有向无环图执行计划(DAG),这些可以将多个Stage的任务串联或者并行执行，而无需将Stage中间结果输出到HDFS中。类似的引擎包括Dryad、Tez。


高彦杰 著. Spark大数据处理：技术、应用与性能优化 (大数据技术丛书) (Kindle位置241). 机械工业出版社. Kindle 版本. 
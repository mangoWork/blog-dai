## Spark简介
### 1. Spark是什么？
    Spark是基于内存计算的大数据并行计算框架。Spark基于内存计算，提高了在大数据环境下数据处理的实时性，同时保证了容错性和高可伸缩性，允许用户将Spark部署在大量廉价硬件之上形成集群。

### 2. Spark与Hadoop

    更准确的说，Spark是一个计算框架，而Hadoop中包含计算框架MapReduce和分布式文件系统HDFS，Hadoop更广泛地说还包括在其生态系统之上的其他系统，如Hbase、Hive等。

#### Spark相对于Hadoop的优势
* 中间结果输出
    * 基于MapReduce的计算引擎通常会将中间结果输出到磁盘上，进行存储和容错。出于任务管道承接的考虑，当一些查询结果翻译到MapReduce任务时，往往会产生多个Stage，而这些串联的Stage又依赖于底层文件系统(HDFS)来存储每一个Stage。
    
    * Spark将执行模型抽象为通用的有向无环图执行计划(DAG),这些可以将多个Stage的任务串联或者并行执行，而无需将Stage中间结果输出到HDFS中。类似的引擎包括Dryad、Tez。
    
* 数据格式和内存布局
    * 由于MapReduce Schema on Read处理方式会引起较大的处理开销。Spark抽象出分布式内存存储结构弹性分布式数据集RDD进行数据存储。RDD支持粗粒度写操作，但对于读操作，RDD可以精确到每条记录，这使得RDD可以用来做分布式索引。Spark的特性是能够控制数据在不同节点上的分区，用户可以自定义分区策略，如Hash分区等。

* 执行策略
    * MapReduce在数据Shuffle之前花费了大量的时间来排序，Spark则可减轻上述问题带来的开销。因为Spark任务在Shuffle中不是所有的情景都需要排序，所以支持基于Hash的分布式聚合，调度中采用更为通用的任务执行计划图(DAG),每一轮次的输出结果在内存缓存。

* 任务调度的开销
    * 传统的MapReduce系统，如Hadoop，是为了运行长达数小时的批量作业而设计的，在某些极端的情况下，提交一个任务的延迟非常高。
    * Spark采用了事件驱动的类库AKKA来启动任务，通过线程池复用线程来避免进程或线程启动和切换开销。
。
### 2. Spark特点
* 快速
    * Spark有先进的DAG执行引擎，支持循环数据流和内存计算；Spark的执行速度是MapReduce的100倍，在磁盘上的运行速度是MapRedice的10倍。
* 易用
    * Spark支持使用Java、Scala、Python等等
* 通用
    * Spark可以与SQL、Streaming以及复杂的分析良好结合。基于Spark，有一系列高级工具，包括Spark SQL、MLib(机器学习库)、GraphX和Spark Streaming，支持在一个应用中同时使用这些架构。
* 有效集成Hadoop
    * Spark可以制定Hadoop、YARN的版本编译出合适的发行版本
    

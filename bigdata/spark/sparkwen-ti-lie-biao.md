## Spark的问题列表

### Spark基础概念问题

#### Spark简介

#### Spark的优势？

1. Spark支持复杂查询。在简单的“map”及“reduce”操作之外，Spark还支持SQL查询、流式计算、机器学习和图算法。

2. Spark也是轻量级以及处理速度快。轻量级是因为scala语言的简洁和丰富的表达式；Spark将处理的数据的中间结果缓存在内存中，使得处理速度比较快。

3. 与HDFS等存储层兼容。Spark可以独立运行、可以运行在YARN上，可以读取HDFS中的数据。



---------

### Spark工作机制详情问题

#### Spark应用执行机制

##### Spark应用转换过程？

RDD的Action算子触发Job的提交，提交到Spark中的Job生成RDD DAG，由DAGScheduler转化为Stage DAG，每个Stage中产生相应的Task集合TaskScheduler将任务分发到Executor执行。每个任务对应相应的一个数据块，使用用户定义的函数处理数据块。


--------------

#### Spark应用执行机制



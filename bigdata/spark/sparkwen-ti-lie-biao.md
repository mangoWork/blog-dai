## Spark的问题列表

### Spark基础概念问题

#### Spark简介

#### Spark的优势？

1. Spark支持复杂查询。在简单的“map”及“reduce”操作之外，Spark还支持SQL查询、流式计算、机器学习和图算法。

2. Spark也是轻量级以及处理速度快。轻量级是因为scala语言的简洁和丰富的表达式；Spark将处理的数据的中间结果缓存在内存中，使得处理速度比较快。

3. 与HDFS等存储层兼容。Spark可以独立运行、可以运行在YARN上，可以读取HDFS中的数据。



#### Spark各个组件的作用？

1. ClusterManager：在Standalone模式中即为Master（主节点），控制整个集群，监控Worker。在YARN模式中为资源管理器。

2. Worker：从节点，负责控制计算节点，启动Executor或Driver。在YARN模式中为NodeManager，负责计算节点的控制。

3. Driver：运行Application的main（）函数并创建SparkContext。

4. Executor：执行器，在worker node上执行任务的组件、用于启动线程池运行任务。每个Application拥有独立的一组Executors。

5. SparkContext：整个应用的上下文，控制应用的生命周期。

6. RDD：Spark的基本计算单元，一组RDD可形成执行的有向无环图RDD Graph。

7. DAG Scheduler：根据作业（Job）构建基于Stage的DAG，并提交Stage给TaskScheduler。

8. TaskScheduler：将任务（Task）分发给Executor执行。

9. SparkEnv：线程级别的上下文，存储运行时的重要组件的引用。

#### worker、executor、stage、task、partition之间的关系？

&nbsp;　一个物理节点可以拥有一个或者多个worker。

&nbsp;　一个worker可以拥有一个或者多个executor；一个executor拥有多个cpu core和memory。

&nbsp;　每个executor由若干个core，每个core只能执行一个task。

&nbsp;　只有shuffle操作时才算作一个stage。

&nbsp;　一个partition对应一个task。

&nbsp;　**注意：**这里的core不是机器的物理cpu核数，可以理解为Executor的一个工作线程。

#### Spark的整体流程？

&nbsp;　Client提交应用，Master找到一个Worker启动Driver，Driver向Master或者资源管理器申请资源，之后将应用转化为RDD Graph，再由DAGScheduler将RDD Graph转化为Stage的有向无环图提交给TaskScheduler，由TaskScheduler提交任务给Executor执行。在任务执行的过程中，其他组件协同工作，确保整个应用顺利执行。



---------

### Spark计算模型问题

#### Spark如何读取文件？

```java
val file=sc.textFile（"hdfs：//xxx"）
```


-----------

### Spark工作机制详情问题

#### Spark应用执行机制

##### Spark应用转换过程？

RDD的Action算子触发Job的提交，提交到Spark中的Job生成RDD DAG，由DAGScheduler转化为Stage DAG，每个Stage中产生相应的Task集合TaskScheduler将任务分发到Executor执行。每个任务对应相应的一个数据块，使用用户定义的函数处理数据块。


--------------

#### Spark应用执行机制



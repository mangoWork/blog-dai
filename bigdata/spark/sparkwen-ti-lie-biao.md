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

10. Block-Manager: 负责存储管理、创建和查找块。

#### worker、executor、stage、task、partition之间的关系？

&nbsp;　一个物理节点可以拥有一个或者多个worker。

&nbsp;　一个worker可以拥有一个或者多个executor；一个executor拥有多个cpu core和memory。

&nbsp;　每个executor由若干个core，每个core只能执行一个task。

&nbsp;　只有shuffle操作时才算作一个stage。

&nbsp;　一个partition对应一个task。

&nbsp;　**注意：**这里的core不是机器的物理cpu核数，可以理解为Executor的一个工作线程。

#### Spark的整体流程？

&nbsp;　Client提交应用，Master找到一个Worker启动Driver，Driver向Master或者资源管理器申请资源，之后将应用转化为RDD Graph，再由DAGScheduler将RDD Graph转化为Stage的有向无环图提交给TaskScheduler，由TaskScheduler提交任务给Executor执行。在任务执行的过程中，其他组件协同工作，确保整个应用顺利执行。


#### 什么是RDD和RDD对象？

&nbsp;　RDD就是弹性分布式数据集，它是逻辑集中的实体，在集群中的多台机器上进行了数据分区。

&nbsp;　RDD对象实质上是一个元数据结构，存储着Block、Node等的映射关系，以及其他的元数据信息。一个RDD就是一组分区，在物理数据存储上，RDD的每个分区对应的就是一个Block，Block可以存储在内存，当内存不够时可以存储到磁盘上。

&nbsp;　每个Block中存储着RDD所有数据项的一个子集，暴露给用户的可以是一个Block的迭代器（例如，用户可以通过mapPartitions获得分区迭代器进行操作），也可以就是一个数据项（例如，通过map函数对每个数据项并行计算）。

#### RDD的两种创建方式？

&nbsp;　从文件系统中读取文件创建

&nbsp;　从父RDD中获取

#### RDD的特征？

&nbsp;　RDD有5个特征，其中分区、依赖和函数是RDD的基本特征，优先位置和分区策略是可选特征。

&nbsp;　**分区：**计算一个分区列表，能够将数据进行切分，切分后的数据能够进行并行计算，是数据集的原子组成部分。

&nbsp;　**依赖：**计算每个RDD对父RDD的依赖列表，源RDD没有依赖，通过依赖关系描述血统(lineage)。

&nbsp;　**函数：**计算每个分区，得到一个可遍历的结果，用于说明在父RDD上执行何种计算。

&nbsp;　**优先位置：**每一个分区对应的优先的计算位置(如：HDFS中对应的每个Block会优先计算)

&nbsp;　**分区策略：**描述分区模式和数据存放的位置，键-值(key-value)的RDD根据Hash进行分区，类似于MapReduce的Partioner接口，根据key来决定分配的位置。

#### Spark中的Transfomation和Action的区别？

&nbsp;　Transfomation：是指该操作从已经存在的数据集上创建一个新的数据集，是数据集的逻辑操作，并没有计算。

&nbsp;　Action：是指该方法提交一个与前一个Action之间的所有转换组成的Job进行计算，Spark会根据Action将作业且切分多个Job

#### 算子的分类

&nbsp;　1）Value数据类型的Transformation算子，这种变换并不触发提交作业，针对处理的数据项是Value型的数据。

&nbsp;　2）Key-Value数据类型的Transfromation算子，这种变换并不触发提交作业，针对处理的数据项是Key-Value型的数据对。

&nbsp;　3）Action算子，这类算子会触发SparkContext提交Job作业。


#### 宽依赖和窄依赖的区别？

&nbsp;　**窄依赖：**指父RDD的每一个分区最多一个子RDD的分区所引用。表现为一个父RDD的分区对于一个子RDD的分区或多个父RDD的分区对应于一个子RDD的分区。也就是说一个父RDD的一个分区不可能对应一个子RDD的多个分区。当子RDD的每隔分区依赖单个父分区时，分区结构不发生改变，如Map、flatMap；当子RDD依赖多个父分区时，分区结构发生变化，如Union。

&nbsp;　**宽依赖：**子RDD的每个分区都依赖于所有父RDD的所有分区或者多个分区。也就是说一个父RDD的一个分区对应一个子RDD的多个分区。当任务执行失败，宽依赖的再次执行设计多个父RDD，从而引发全部的再执行。为了规避着这点，Spark会保持Map阶段中间数据输出的持久，在机器发生故障的情况下，再次执行只需要回溯Mapper持续输出的相应分区，来获取中间数据。

##### 区别

&nbsp;　**窄依赖**的RDD可以通过相同的键进行联合分区，整个操作都可以在一个集群节点上进行，以流水线的方式计算所得父分区，不会造成网络之间数据混合。

&nbsp;　**宽依赖**RDD会涉及数据混合，宽依赖需要首先计算所有的父分区数据，然后在节点之间进行Shuffle。

&nbsp;　**窄依赖**能够有效进行失效节点恢复，重新计算丢失RDD分区的父分区，不同节点之间可以并行计算。而对于一个**宽依赖**中单个节点失效可能导致这个RDD的所有祖先丢失部分分区，因而需要重新计算(Shuffle执行固化操作以及采取Persist缓存策略，在可以固话点或者缓存 点重新计算)。

&nbsp;　执行时，调度程序会检查依赖性的类型，将**窄依赖**的RDD划到一组处理当中，即Stage。**宽依赖**在一个执行中会跨越连续的Stage，同时需要现实指定多个子RDD分区。

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



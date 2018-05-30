# 作业执行解析

## 基本概念{#基本概念}
&nbsp;　　 Spark的基本组件，包括负责集群运行的Master和Worker，负责集群资源管理器(如YARN)和执行单元Executor等，并在组件的基础上，对基于RDD数据集的静态视图和基于Partition的动态视图进行了说明，为接下来的作业执行流程铺垫。
### Spark组件{#Spark组件}
&nbsp;　　 在架构层面上，Spark Application都是由控制集群的主控节点Master、负责集群资源管理的Cluster Manager、执行具体任务的Worker节点和执行单元Executor、负责作业提交的Client端和负责作业的Driver进程组成。
&nbsp;　　 SparkClient负责任务的提交，Driver进程通过运行用户定义的main函数，在集群上执行何种并发和计算。其中，SparkContext是应用程序与集群交互的唯一通道，主要包括：获取数据、交互操作、分析和构建DAG图、通过Scheduler调度任务、Block跟踪、Shuffle跟踪。
&nbsp;　　 用户通过Client提交一个程序给Driver之后，Driver会将所有的RDD的依赖关联在一起绘制成一张DAG图；当运行任务时，调度Sheduler会配合组件Block Tracker和Shuffle Tracker进行工作；通过ClusterManager进行资源统一调度；具体任务在Worker节点进行，由Task线程池负责具体任务执行，线程池通过多个Task运行任务。
## 作业执行流程{#作业执行流程}
&nbsp;　　 提交作业有两种方式，分别是Driver运行在集群中，Driver运行在客户端，接下来分别介绍两种方式的作业运行原理。
&nbsp;　　 无论是基于哪种运行方式，基础概念是一致的。
      1. Stage,一个Spark作业一般包含一到多个Stage。
      2. Task，一个Stage包含一到多个Task，通过多个Task实现并行运行的功能。
      3. DAGScheduler，实现将Spark作业分解成一到多个Stage，每个Stage根据RDD的Partition个数决定Task的个数，然后生成相应的TaskSet放到TaskScheduler中。
### 基于Standalone模式的Spark架构{#基于Standalone模式的Spark架构}
&nbsp;　　在Standalone模式下有两种运行方式：**以Driver运行在Worker上** 和**以Driver运行在客户端**，在图中给出了Standalone模式下两种运行方式的架构。默认是Client模式（即Driver运行在客户端）。集群启动Master与Worker进程，Master负责接收客户端提交的作业，管理Worker，并提供Web展示集群与作业信息。
![](./img/sprk_stand_alone.png)


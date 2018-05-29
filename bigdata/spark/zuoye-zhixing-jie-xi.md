# 作业执行解析

## 基本概念
&nbsp;　　 Spark的基本组件，包括负责集群运行的Master和Worker，负责集群资源管理器(如YARN)和执行单元Executor等，并在组件的基础上，对基于RDD数据集的静态视图和基于Partition的动态视图进行了说明，为接下来的作业执行流程铺垫。
### Spark组件
&nbsp;    在架构层面上，Spark Application都是由控制集群的主控节点Master、负责集群资源管理的Cluster Manager、执行具体任务的Worker节点和执行单元Executor、负责作业提交的Client端和负责作业的Driver进程组成。
&nbsp;    SparkClient负责任务的提交，Driver进程通过运行用户定义的main函数，在集群上执行何种并发和计算。其中，SparkContext是应用程序与集群交互的唯一通道，主要包括：获取数据、交互操作、分析和构建DAG图、通过Scheduler调度任务、Block跟踪、Shuffle跟踪。


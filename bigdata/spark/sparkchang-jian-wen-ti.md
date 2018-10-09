### Spark常见问题总结

#### worker、executor、stage、task、partition之间的关系？

&nbsp;　　一个物理节点可以拥有一个或者多个worker。

&nbsp;　　一个worker可以拥有一个或者多个executor；一个executor拥有多个cpu core和memory。

&nbsp;　　每个executor由若干个core，每个core只能执行一个task。

&nbsp;　　只有shuffle操作时才算作一个stage。

&nbsp;　　一个partition对应一个task。

&nbsp;　　**注意：**这里的core不是机器的物理cpu核数，可以理解为Executor的一个工作线程。

----

#### 任务的并发度如何进行计算？

&nbsp;　　**任务的并发度 = Executor的数目 * Executor对应的core**
&nbsp;　　在数据的读取阶段，输入文件被分为多少个**InputSplit**就会初始化多少个Task。
&nbsp;　　在Map阶段partition数目保持不变

##### 如何通过分区调优

&nbsp;　　RDD有100个分区，那么计算的时候就会生成100个task，资源配置为10个计算节点，每个两2个核，同一时刻可以并行的task数目为20，计算这个RDD就需要5个轮次。如果计算资源不变，有101个task的话，就需要6个轮次，在最后一轮中，只有一个task在执行，其余核都在空转。如果资源不变，RDD只有2个分区，那么同一时刻只有2个task运行，其余18个核空转，造成资源浪费。这就是在spark调优中，增大RDD分区数目，增大任务并行度的做法。

------

#### Spark中的RDD是什么？有哪些特性？

#### Spark常见的算子都有哪些？以及它们之间的区别？

#### Spark中的宽依赖和窄依赖区别？

#### Spark中如何划分Stage？

#### spark-submit的时候如何引入外部jar包？

#### spark 如何防止内存溢出？
##  Spark编程中常用的API介绍

### collect
> 将分布式的RDD返回一个为单机的scala Array数组。在这个数组上运用scala的函数式操作。通过函数操作，将结果返回到Driver程序所在的节点，以数组形式存储。


![](./img/spark_scala_collect.png)


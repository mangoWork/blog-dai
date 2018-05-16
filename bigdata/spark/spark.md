### Spark文件读取
    > Spark加载HDFS和本地文件都使用textFile，区别在于前缀(hdfs://和file://)进行标识，从本地读取文件直接返回MapPartionsRDD，而从HDFS中读取问价先转换为HadoopRDD，然后在隐式的转换为MapPartionsRDD。

### 传递给Spark的Master URL格式说明
|Master URL|说明|
|:-----:|:------:|
|local|以单线程在本地运行Spark(完全无并行)|
|local[K]|在本地以K个worker线程运行Spark(将这个数字设为机器CPU核数比较理想)|
|local[*]|以机器上逻辑核数相同的Worker线程运行Spark|
|spark://ip:port|连接一个给定的Spark独立模式集群上的master，该端口号必须是配置好的，一般是7070|
|yarn-client|以client模式连接到一个YARN集群，该集群的位置可以在HADOOP_CONF_DIR变量中找到|
|yarn-cluster|以Cluster模式连接到一个YARN集群。该集群的位置可以在HADOOP_CONF_DIR变量中找到|






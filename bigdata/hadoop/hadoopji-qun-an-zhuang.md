## 该部分主要说明Hadoop集群的安装

### 1. 集群安装的说明

> 以四台机器为例搭建Hadoop集群，各个机器的职责如下（包括了NameNode的HA以及ResourceManager的HA）：


| 服务名 | master | slave1 | slave2 | slave3 |

| --- | --- | --- | --- | --- |

| NameNode | Y | Y | N | N |

| DataNode | N | Y | Y | Y |

| JuornalNode | Y | Y | Y | N |

| Zookeeper | N | Y | Y | Y |

| zkfc | Y | Y | N | N |

| ResourceManager | Y | Y | N | N |

| NodeManager | N | Y | Y | Y |

| HistoryServer | N | Y | N | N |



### 2. 安装之前的准备

* 安装使用的是centos进行安装
* 要提前配好ssh的无密码连接（用hadoop用户），在/etc/hosts中做好整个集群的hostname和ip的映射，以及安装JDK，这里就不在说明。
* 新建目录/opt/module（该目录用于存放hadoop生态系统中的组件）,并且新建hadoop用户以及hadoop用户组

    mkdir -p /opt/module
    useradd hadoopchown 
    -R hadoop:hadoop /opt/module

### 3. 安装

#### 3.1 Zookeeper的配置

* step1 解压下载的zookeeper到\/opt\/module\/zookeeper下

  ```shell
  tar -zxvf zookeeper-3.4.5-cdh5.0.0.tar.gz ./
  mv ./zookeeper-3.4.5-cdh5.0.0 /opt/module/zookeeper
  ```

* step2 修改zookeeper的配置文件zoo\_sample.cfg 重名为zoo.cfg

  ```shell
  mv /opt/module/zookeeper/conf/zoo_sample.cfg zoo.cfg
  ```

* step3 将整个zookeeper目录分别复制slave1，slave2，slave3上。分别在slave1，slave2，slave3创建dataDir属性指定的目录，并在此目录下创建myid文件。

* step4 在slave1上的myid里面写入值1、slave2上的myid里面写入值2、slave3上的myid里面写入值3

* step5 修改环境变量

  ```shell
  vi  /etc/profile
  # 添加变量
  $ZOOKEEPER_HOME=/opt/module/zookeeper
  PATH=$ZOOKEEPER_HOME/bin:$PATH
  # 退出编辑之后执行
  source /etc/profile
  ```

* step6 在slave1，slave2，slave3上执行

  ```shell
  chown -R hadoop /opt/module/zookeeper
  ```

* step7 验证是否成功

  > 分别在hadoop1，hadoop2，hadoop3上执行zkServer.sh start ,用jps命令查看进程QuorumPeerMain是否启动

#### 3.2 NameNode HA配置

* step1 将hadoop-2.8.3.tar.gz解压到\/opt\/module\/haoop下

  > tar -zxvf .\/hadoop-2.8.3.tar.gz  .\/

  > mv .\/hadoop-2.8.3 \/opt\/module\/haoop

* step2 修改etc\/hadoop\/core-site.xml

```xml

  <configuration>

    <property>
      <name>fs.defaultFS</name>
      <value>hdfs://beh</value>
    </property>

    <!-- beh是个逻辑名称，可以随意制定，它来自于hdfs-site.xml中的配置 -->

    <property>
      <name>hadoop.tmp.dir</name>
      <value>/opt/module/hadoop/tmp</value>
    </property>

    <!-- 这里的路径默认是NameNode、DataNode、JournalNode等存放数据的公共目录。用户也可以自己单独指定这三类节点的目录。 -->    

    <property>
      <name>ha.zookeeper.quorum</name>
      <value>slave1:2181,slave2:2181,slave3:2181</value>
    </property>
    <!--这里是ZooKeeper集群的地址和端口。注意，数量一定是奇数，且不少于三个节点-->

    <property>   
       <name>io.file.buffer.size</name>
       <value>131072</value>   
    </property>

<!--缓冲区大小:io.file.buffer.size默认是4KB，作为hadoop缓冲区，用于hadoop读hdfs的文件和写hdfs的文件，还有map的输出都用到了这个缓冲区容量，对于现在的硬件很保守，可以设置为128k(131072),甚至是1M(太大了map和reduce任务可能会内存溢出)。 -->

<configuration>

```

* step3. 修改hdfs-site.xml

```xml

<configuration>

    <property>

        <name>dfs.nameservices</name>

        <value>beh</value>

    </property>

    <!-- 这是此hdfs集群的逻辑名称 -->

    <property>

        <name>dfs.ha.namenodes.beh</name>

        <value>nn1,nn2</value>

    </property>

    <!-- 这是两个namenode的逻辑名称，随意起名，相互不重复即可 -->

    <property>

        <name>dfs.namenode.rpc-address.beh.nn1</name>

        <value>master:9000</value>

    </property>

    <property>

        <name>dfs.namenode.http-address.beh.nn1</name>

        <value>master:50070</value>

    </property>

    <property>

        <name>dfs.namenode.rpc-address.beh.nn2</name>

        <value>slave1:9000</value>

    </property>

    <property>

        <name>dfs.namenode.http-address.beh.nn2</name>

        <value>slave1:50070</value>

    </property>

    <property>

        <name>dfs.namenode.shared.edits.dir</name>              

        <value>qjournal://msater:8485;slave1:8485;slave2:8485/beh</value>

    </property>

 <!-- dfs.namenode.shared.edits.dir共享存储目录的位置这是配置备份节点需要随时保持同步活动节点所作更改的远程共享目录，你只能配置一个目录，这个目录挂载到两个namenode上都必须是可读写的，且必须是绝对路径。 -->     

    <property>
        <name>dfs.ha.automatic-failover.enabled.beh</name>
        <value>true</value>
    </property>

    <property>
        <name>dfs.client.failover.proxy.provider.beh</name>           
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    </property>

    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/opt/module/hadoop/journal</value>    
    </property>

    <property>        
        <name>dfs.ha.fencing.methods</name>        

        <value>sshfence</value>    

    </property>

    <property>    

        <name>dfs.ha.fencing.ssh.private-key-files</name>    

        <value>/home/hadoop/.ssh/id_rsa</value>    

    </property>

    <property>

        <name>dfs.data.dir</name>        

        <value>/hadoop_data/datafile/data</value>    

    </property>

    <!-- 这个参数用于确定将HDFS文件系统的数据保存在什么目录下。 -->

    <property>    

        <name>dfs.block.size</name>        

        <value> 134217728</value>    

    </property>

    <!-- block大小可根据实际情况进行设置，此处为128M -->

    <property>    

        <name>dfs.datanode.handler.count</name>        

        <value>3</value>    

    </property>    

    <!-- dfs.datanode.handler.count   datanode上用于处理RPC的线程数。默认为3，较大集群，可适当调大些，比如8。需要注意的是，每添加一个线程，需要的内存增加。 -->    

    <property>    

        <name>dfs.namenode.handler.count</name>    

        <value>20</value>    

    </property>

    <property>    

        <name>dfs.datanode.max.xcievers</name>    

        <value>131072</value>    

    </property>    

    <property>    

        <name>dfs.datanode.socket.write.timeout</name>    

        <value>0</value>    

    </property>    

    <property>    

        <name>dfs.socket.timeout</name>    

        <value>180000</value>    

    </property>    

    <property>    

        <name>dfs.replication</name>    

        <value>1</value>    

    </property>    

</configuration>

```

* step4 编辑 \/etc\/hadoop\/slaves

  > 添加 slave1、slave2、slave3

* step5 辑\/etc\/profile

  > 添加 HADOOP\_HOME=\/opt\/module\/hadoop

  > PATH=$HADOOP\_HOME\/bin:$HADOOP\_HOME\/sbin:$PATH

* step6 将以上的所有的配置复制到其他节点, 以下为实例

  > cp -r \/opt\/module\/hadoop\/ master@132.35.227.74:\/opt\/module\/

* step7 启动各项服务

  > 启动顺序如下所示：

  * 启动journalnode

    > 在master、slave1、slave2上执行hadoop-daemon.sh start 

    >   journalnode

  * 格式化zookeeper

    > 在master上执行hdfs  zkfc  -formatZK

  * 对hadoop1节点进行格式化和启动

    > hdfs  namenode  -format

    > hadoop-daemon.sh  start  namenode

  * 对slave1节点进行格式化和启动

    > hdfs  namenode  -bootstrapStandby

    > hadoop-daemon.sh  start  namenode

  * 在hadoop1和hadoop2上启动zkfc服务

    > hadoop-daemon.sh   start   zkfc

    > 此时hadoop1和hadoop2就会有一个节点变为active状态。

  * 启动datanode

    > 在hadoop1上执行命令hadoop-daemons.sh   start   datanode

  * 验证是否成功

    > 打开浏览器，访问 hadoop1:50070 以及 hadoop2:50070，你将会看到两个namenode一个是active而另一个是standby。

#### 3.3 ResourceManager HA配置

* step1 修改 mapred-site.xml

    ```xml

    <configuration>

        <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>

        <!-- configure historyserver -->

        <property>
            <name>mapreduce.jobhistory.address</name>
            <value>slave1:10020</value>
        </property>

        <property>
            <name>mapreduce.jobhistory.webapp.address</name>
            <value>slave1:19888</value>
        </property>

        <!-- configure staging directory -->

        <property>
    		<name>yarn.app.mapreduce.am.staging-dir</name>
            <value>/user</value>
        </property>

        <!--optimize-->
        <property>
            <name>mapred.child.java.opts</name>
            <value>-Xmx2g</value>
        </property>
        
        <property>
            <name>io.sort.mb</name>
             <value>512</value>
        </property>
        
        <property>
            <name>io.sort.factor</name>
            <value>20</value>
        </property>
        
        <property> 
            <name>mapred.job.reuse.jvm.num.tasks</name> 
            <value>-1</value>
        </property>  
        
        <property>        
            <name>mapreduce.reduce.shuffle.parallelcopies</name>   
            <value>20</value>    
        </property>
        
    </configuration>
    ```



* step2  修改yarn-site.xml

    ```xml
    <configuration>

    	<property>
     		<name>yarn.nodemanager.aux-services</name>
     		<value>mapreduce_shuffle</value>
     	</property>	

         <property>
             <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
             <value>org.apache.hadoop.mapred.ShuffleHandler</value>
         </property>

         <property>
             <name>yarn.nodemanager.local-dirs</name>
             <value>/opt/module/hadoop/nmdir</value>
         </property>

         <property>
             <name>yarn.nodemanager.log-dirs</name>
             <value>/opt/module/hadoop/logs</value>
         </property>

         <property>
             <name>yarn.log-aggregation-enable</name>
             <value>true</value>
         </property>

         <property>
             <description>Where to aggregate logs</description>
             <name>yarn.nodemanager.remote-app-log-dir</name>
             <value>hdfs://beh/var/log/hadoop-yarn/apps</value>
         </property>

         <!-- Resource Manager Configs -->
         <property>
             <name>yarn.resourcemanager.connect.retry-interval.ms</name>
             <value>2000</value>
         </property>
        
         <property>
             <name>yarn.resourcemanager.ha.enabled</name>
             <value>true</value>
         </property>

         <property>
             <name>yarn.resourcemanager.ha.automatic-failover.enabled</name>
             <value>true</value>
         </property>

     	<property>
     		<name>yarn.resourcemanager.ha.automatic-failover.embedded</name>
     		<value>true</value>
     	</property>

         <property>
             <name>yarn.resourcemanager.cluster-id</name>
             <value>beh</value>
         </property>

         <property>
             <name>yarn.resourcemanager.ha.rm-ids</name>
             <value>rm1,rm2</value>
         </property>

        <!-- 标识当前节点的resourcemansger的id 如果为slave1，则修改为rm2 -->
         <property>
             <name>yarn.resourcemanager.ha.id</name>
             <value>rm1</value>
         </property>

         <property>
             <name>yarn.resourcemanager.scheduler.class</name>
           <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>
         </property>

         <property>
             <name>yarn.resourcemanager.recovery.enabled</name>
             <value>true</value>
         </property>

         <property>
             <name>yarn.resourcemanager.store.class</name>
             <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
         </property>

         <property>
             <name>yarn.resourcemanager.zk.state-store.address</name>
             <value>slave1:2181,slave2:2181,slave3:2181</value>
         </property>

         <property>
             <name>yarn.app.mapreduce.am.scheduler.connection.wait.interval-ms</name>
             <value>5000</value>
         </property>

         <!-- RM1 configs -->
         <property>
             <name>yarn.resourcemanager.address.rm1</name>
             <value>master:23140</value>
         </property>

         <property>
             <name>yarn.resourcemanager.scheduler.address.rm1</name>
             <value>hadoop1:23130</value>
         </property>

         <property>
             <name>yarn.resourcemanager.webapp.https.address.rm1</name>
             <value>master:23189</value>
         </property>

         <property>
             <name>yarn.resourcemanager.webapp.address.rm1</name>
             <value>master:23188</value>
         </property>

         <property>
             <name>yarn.resourcemanager.resource-tracker.address.rm1</name>
             <value>master:23125</value>
         </property>

         <property>
             <name>yarn.resourcemanager.admin.address.rm1</name>
             <value>master:23141</value>
         </property>

        <!-- RM2 configs -->
         <property>
             <name>yarn.resourcemanager.address.rm2</name>
             <value>slave1:23140</value>
         </property>

         <property>
             <name>yarn.resourcemanager.scheduler.address.rm2</name>
             <value>slave1:23130</value>
         </property>

         <property>
             <name>yarn.resourcemanager.webapp.https.address.rm2</name>
             <value>slave1:23189</value>
         </property>

         <property>
             <name>yarn.resourcemanager.webapp.address.rm2</name>
             <value>slave1:23188</value>
         </property>

         <property>
             <name>yarn.resourcemanager.resource-tracker.address.rm2</name>
             <value>slave1:23125</value>
         </property>

         <property>
             <name>yarn.resourcemanager.admin.address.rm2</name>
             <value>slave1:23141</value>
         </property>

        <!-- Node Manager Configs -->
         <property>
             <description>Address where the localizer IPC is.</description>
             <name>yarn.nodemanager.localizer.address</name>
             <value>0.0.0.0:23344</value>
         </property>

         <property>
             <description>NM Webapp address.</description>
             <name>yarn.nodemanager.webapp.address</name>
             <value>0.0.0.0:23999</value>
         </property>

         <property>
             <name>yarn.nodemanager.local-dirs</name>
             <value>/opt/module/hadoop/nodemanager/yarn/local</value>
         </property>

         <property>
             <name>yarn.nodemanager.log-dirs</name>
             <value>/opt/module/hadoop/nodemanager/yarn/log</value>
         </property>

         <property>
             <name>mapreduce.shuffle.port</name>
             <value>23080</value>
         </property>

         <property>
             <name>yarn.resourcemanager.zk-address</name>
             <value>master:2181,slave1:2181,slave2:2181</value>
         </property>

    </configuration>

    ```

    ​

* step3 将配置文件信息复制到各个节点

* Step4 修改slave上的yarn-site.xml

    ```xml
    <property>
        <name>yarn.resourcemanager.ha.id</name>
        <value>rm2</value>
      </property>
    ```


* step5  创建目录并赋予权限(slave1、slave2、slave3)

    ```shell
    mkdir -p /opt/module/hadoop/nmdir
    mkdir -p /opt/module/hadoop/logs
    chown -R hadoop:hadoop /opt/module/hadoop/nmdir
    chown -R hadoop:hadoop /opt/module/hadoop/logs
    ```

    > 启动hdfs后，执行下列命令

    ```shell
    hadoop fs -mkdir -p /user/history
    hadoop fs -chmod -R 777 /user/history
    hadoop fs -chown hadoop:hadoop /user/history 
    ```

    > 创建log目录


    ​```shell
    hadoop fs -mkdir -p /var/log/hadoop-yarn
    hadoop fs -chown hadoop:hadoop /var/log/hadoop-yarn
    ​```
    
    > 创建hdfs下的/tmp
    
    ​```shell
    hadoop fs -mkdir /tmp
    hadoop fs -chmod -R 777 /tmp
    ​```

* step6 启动

    > 在master上启动: sbin/start-yarn.sh(此脚本将会启动hadoop1上的resourcemanager及所有的nodemanager)

    > 在slave1上启动resourcemanager：yarn-daemon.sh start resourcemanager

    > 在slave1上启动jobhistory server


*  step7 验证是否成功

  > 打开浏览器，访问hadoop1:23188或者hadoop2:23188，然后kill掉active的resourcemanager另一个将会变为active的，说明resourcemanager HA是成功的。
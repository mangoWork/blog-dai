## JVM调优工具
### jstat
&nbsp;　　jstat工具特别强大，有众多的可选项，详细查看堆内各个部分的使用量，以及加载类的数量。使用时，需加上查看进程的进程id，和所选参数。参考格式如下：
> jstat -options 

&nbsp;　　可以列出当前JVM版本支持的选项，常见的有class(类加载器)、compiler(JIT) 、gc(GC堆状态)、gccapacity(各区大小)、gccause(最近一次GC统计和原因)、 gcnew(新区统计)、gcnewcapacity (新区大小)、 gcold(老区统计)、gcoldcapacity(老区大小)、 gcpermcapacity(永久区大小)、 gcutil(GC统计汇总)、printcompilation(HotSpot编译统计)、printcompilation(HotSpot编译统计)

&nbsp;　　jstat –class<pid> : 显示加载class的数量，及所占空间等信息。

|显示列名|具体描述|
|:------|:------|
|Loaded|装载的类的数量|
|Bytes|装载类所占用的字节数|
|Unloaded|卸载类的数量|
|Bytes|卸载类的字节数|
|Time|装载和卸载类所花费的时间|

&nbsp;　　jstat -compiler <pid>显示VM实时编译的数量等信息。

|显示列名|具体描述|
|:------|:------|
|Compiled|编译任务执行数量|
|Failed|编译任务执行失败数量|
|Invalid|编译任务执行失效数量|
|Time|编译任务消耗时间|
|FailedType|最后一个编译失败任务的类型|
|FailedMethod|最后一个编译失败任务所在的类及方法|

&nbsp;　　jstat -gc <pid>: 可以显示gc的信息，查看gc的次数，及时间。

|显示列名|具体描述|
|:------|:------|
|S0C|年轻代中第一个survivor（幸存区）的容量 (字节)|
|S1C   |年轻代中第二个survivor（幸存区）的容量 (字节)|
|S0U   |年轻代中第一个survivor（幸存区）目前已使用空间 (字节)|
|S1U |年轻代中第二个survivor（幸存区）目前已使用空间 (字节)|
|EC   |年轻代中Eden（伊甸园）的容量 (字节)|
|EU|年轻代中Eden（伊甸园）目前已使用空间 (字节)|
|OC   |Old代的容量 (字节)|
|OU |Old代目前已使用空间 (字节)|
|PC|Perm(持久代)的容量 (字节)|
|PU|Perm(持久代)目前已使用空间 (字节)|
|YGC |从应用程序启动到采样时年轻代中gc次数|
|YGCT|从应用程序启动到采样时年轻代中gc所用时间(s)|
|FGC   |从应用程序启动到采样时old代(全gc)gc次数|
|FGCT    |从应用程序启动到采样时old代(全gc)gc所用时间(s)|
|GCT|从应用程序启动到采样时gc用的总时间(s)|

&nbsp;　　jstat -gccapacity <pid>:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小

|显示列名|具体描述|
|:------|:------|
|NGCMN |年轻代(young)中初始化(最小)的大小(字节)|
|NGCMX    |年轻代(young)的最大容量 (字节)|
|NGC    |年轻代(young)中当前的容量 (字节)|
|S0C  |	年轻代中第一个survivor（幸存区）的容量 (字节)|
|S1C  |年轻代中第二个survivor（幸存区）的容量 (字节)|
|EC|年轻代中Eden（伊甸园）的容量 (字节)|
|OGCMN |old代中初始化(最小)的大小 (字节)|
|OGCMX |old代的最大容量(字节)|
|OGC|old代当前新生成的容量 (字节)|
|OC |Old代的容量 (字节)|
|PGCMN|perm代中初始化(最小)的大小 (字节)|
|PGCMX|	perm代的最大容量 (字节)  |
|PGC|perm代当前新生成的容量 (字节)|
|PC    |Perm(持久代)的容量 (字节)|
|YGC   |从应用程序启动到采样时年轻代中gc次数|
|FGC|从应用程序启动到采样时old代(全gc)gc次数|

> 其他的选项中的参数也是大同小异，可以参考上面表格中的数据。

### jmap
&nbsp;　　jmap不仅能生成dump文件，还可以查询finalize执行队列、Java堆和永久代的详细信息，如当前使用率、当前使用的是哪种收集器等。用法如下所示：

```shell
Usage:
    jmap [option] <pid>
        (to connect to running process，pid：java进程id)
    jmap [option] <executable <core>
        (to connect to a core file，executable：产生核心dump的java可执行文件，core：需要打印配置信息的核心文件)
    jmap [option] [server_id@]<remote server IP or hostname>
        (to connect to remote debug server)

where <option> is one of:
    <none>               to print same info as Solaris pmap
    -heap                to print java heap summary（显示Java堆详细信息）
    -histo[:live]        to print histogram of java object heap; if the "live" suboption is specified, only count live objects（显示堆中对象的统计信息）
    -permstat            to print permanent generation statistics（Java堆内存的永久保存区域的类加载器的统计信息）
    -finalizerinfo       to print information on objects awaiting finalization（显示在F-Queue队列等待Finalizer线程执行finalizer方法的对象）
    -dump:<dump-options> to dump java heap in hprof binary format
                         dump-options（生成堆转储快照）:
                           live         dump only live objects; if not specified,all objects in the heap are dumped.
                           format=b     binary format
                           file=<file>  dump heap to <file>
                         Example: jmap -dump:live,format=b,file=heap.bin <pid>
    -F                   force. Use with -dump:<dump-options> <pid> or -histo to force a heap dump or histogram when <pid> does not respond. The "live" suboption is not supported in this mode.
    -h | -help           to print this help message
    -J<flag>             to pass <flag> directly to the runtime system
```
#### 示例{#示例}
&nbsp;　-dump
&nbsp;　　dump堆到文件,format指定输出格式，live指明是活着的对象,file指定文件名，命令如下所示：
>  jmap -dump:live,format=b,file=dump.hprof 24971

&nbsp;　-heap
&nbsp;　　打印heap的概要信息，GC使用的算法，heap的配置及使用情况，可以用此来判断内存目前的使用情况以及垃圾回收情况，命令如下所示：
> jmap -heap 24971

&nbsp;  -finalizerinfo
&nbsp;　　打印等待回收的对象信息，，命令如下所示：
> jmap -finalizerinfo 24971

&nbsp;　-histo
&nbsp;　　打印堆的对象统计，包括对象数、内存大小等等。jmap -histo:live 这个命令执行，JVM会先触发gc，然后再统计信息
> jmap -histo:live 24971
> jmap -histo:live 24971 | grep com.yuhuo 查询类名包含com.yuhuo的信息
> jmap -histo:live 24971 | grep com.yuhuo > histo.txt 保存信息到histo.txt文件

&nbsp;  -permstat
&nbsp;　　打印Java堆内存的永久区的类加载器的智能统计信息。对于每个类加载器而言，它的名称、活跃度、地址、父类加载器、它所加载的类的数量和大小都会被打印。此外，包含的字符串数量和大小也会被打印。
>  jmap -permstat 24971

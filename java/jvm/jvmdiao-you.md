## JVM调优工具
### jstat
&nbsp;　　jstat工具特别强大，有众多的可选项，详细查看堆内各个部分的使用量，以及加载类的数量。使用时，需加上查看进程的进程id，和所选参数。参考格式如下：
> jstat -options 

&nbsp;　　可以列出当前JVM版本支持的选项，常见的有
l  class (类加载器)、compiler(JIT) 、gc(GC堆状态)、gccapacity(各区大小)、gccause (最近一次GC统计和原因)、 gcnew (新区统计)、gcnewcapacity (新区大小)、 gcold(老区统计)、gcoldcapacity (老区大小)、 gcpermcapacity(永久区大小)、 gcutil(GC统计汇总)、printcompilation (HotSpot编译统计)、printcompilation(HotSpot编译统计)


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

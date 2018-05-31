## JVM调优工具
### jstat

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
                           live         dump only live objects; if not specified,
                                        all objects in the heap are dumped.
                           format=b     binary format
                           file=<file>  dump heap to <file>
                         Example: jmap -dump:live,format=b,file=heap.bin <pid>
    -F                   force. Use with -dump:<dump-options> <pid> or -histo
                         to force a heap dump or histogram when <pid> does not
                         respond. The "live" suboption is not supported
                         in this mode.
    -h | -help           to print this help message
    -J<flag>             to pass <flag> directly to the runtime system
```
&nbsp;　　s


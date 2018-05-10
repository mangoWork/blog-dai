### 1.如何将map非线程安全转变为线程安全的（不推荐使用）？

* 通过同步类容器来将非线程安全转变为线程安全的，`Collections.synchronizedMap(new HashMap<String,String>())`

  ```java
   //其中可以将非线程安全的map、set、list转变为线程安全的集合
  Map map = Collections.synchronizedMap(new HashMap<String,String>())
  ```

### 2. HashTable、Vector等同步类容器实现线程安全有什么缺点？

* 这种旧版的JDK实现线程安全的通常是Collections.synchronized***等工厂方法创建实现的，其底层的机制无非就是用传统的synchronized关键字对每个公用的方法进行同步，使得每一次只能有一个线程访问容器的状态（性能较低）。

### 3.ConCurrentMap如何实现高并发操作并且保证线程安全的？ 

* 内部使用段来表示不同的部分，每个段其实就是一个小的HashTable，他们有自己的锁。只要多个修改不发生在同一个段中，他们就可以并发进行。把一个整体分成16个段。也就是最高支持16个线程的并发修改操作。这也是在多线程场景中减小锁的粒度从而降低锁竞争的一种方案，并且代码中大多数共享变量使用volatile关键字声明，目的是第一时间获取修改的内容，性能非常好。


### 4. Copy-On-Write容器

* Copy-On-Write简称COW，是一种用于程序设计中的优化策略。
* 适用场景：读多  写少
* JDK中的COW容器有两种：CopyOnWriteArrayList和CopyOnWriteArraySet。
* 什么是CopyOnWrite容器
  * CopyOnWrite容器即写时复制的容器。也就是说当我们往容器中添加元素的时候，不直接往当前容器中添加，而是将当前容器进行Copy，复制出一个新的容器。这样做的好处就是可以对CopyOnWrite容器惊醒并发的读，而不需要加锁，因为当前容器不会添加任何东西。CopyOnWrite也是一种读写分离的思想，读和写不同的容器。
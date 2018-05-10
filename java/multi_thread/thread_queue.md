## 1. 队列的分类？

* 队列可以分为阻塞队列以及非阻塞队列
* 阻塞队列(BlockingQueue)：
  * ArrayBlockingQueue
  * LinkedBlockingQueue
  * PriorityBlockingQueue
  * DelayQueue
  * SynchronousQueue
* 非阻塞队列
  * ConcurrentLinkedQueue

## 2. 阻塞队列

### 2.1 ArrayBlockingQueue

* 在构造的时候需要指定容器的大小，是有界的阻塞队列。

### 2.2 LinkedBlockingQueue

* 默认的情况下该队列是没有上限的。但是也可以指定最大的容量。

### 2.3 PriorityBlockingQueue

* 该队列是没有上限的，在元素移除的时候是按照优先级顺序进行移除。

### 2.4 DelayQueue

* 是一个存放Delayed元素的无界阻塞队列，只有在延期满时才取出元素。

### 2.5 SynchronousQueue

* 一种无缓冲的等待队列，类似于无中介的直接交易。
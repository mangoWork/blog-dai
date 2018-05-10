## 1 Executor框架

### 1 Executors创建线程池的方法

* newFixedThreadPool方法，该方法返回一个固定数量的线程池，该方法的线程数始终不会发生改变，当有一个任务提交的时候，若线程池中空闲，则立即执行，若没有，则会被暂缓在一个任务队列中等待有空闲的的线程去执行。采用的队列是:`LinkedBlockingQueue`
* newSingleThreadExecutor()方法，创建一个线程的线程池，若空闲则执行，若没有，空闲线程池则暂缓在任务队列中,采用的队列是：`LinkedBlockingQueue`
* newCachedThreadPool()方法，返回创建一个可根据实际情况调整线程个数的线程池，不限制最大线程数量。若无空闲线程，则创建，并且每一个线程会在60s后自动回收。采用的队列是：`SychronousQueue`
* newScheduledThreadPool()方法，该方法返回一个SchededExecutorService对象，但该线程可以指定线程的数量。采用的队列是：`DelayedWorkQueue`

### 2. ThreadPoolExecutor?

* 利用Executors创建的线程池都会实例化ThreadPoolExecuor对象。


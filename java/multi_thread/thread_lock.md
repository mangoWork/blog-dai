## 重入锁、读写锁、锁的高级深化

### 1. CountDownLatch

* 一个线程或多个线程一直等待，直到其他线程的操作完成。CountDownLatch用一个给定的计数器来初始化，该计数器操作是原子性的。调用该类的await方法的线程会一直处于阻塞状态，直到其他线程调用countDown方法使当前计数器的值变为0，每次调用countDown计数器减1。只有当计数器为0的时候，所有调用await()方法而处于等待状态的线程会继续执行下去。这种现象只会出现一次，因为计数器不能被重置。

### 2. CyclicBarrier

* CycliBarrier也是一个同步辅助类，它允许一组线程相互等待，直到达到某个公共屏障点。通过它可以完成线程之间相互等待，只有在每个线程都准备就绪后，才能各自继续往下执行，CycllicBarrier在释放等待线程后才可以重用，所以也称之为循环barrier。

### 3. Semaphonre

* 可以控制同时访问线程个数，可以通过acquire()获取一个许可，如果没有就等待，而release()释放一个许可。

* 示列代码：

  ```java
  public class Test {
      public static void main(String[] args) {
          int N = 8;            //工人数
          Semaphore semaphore = new Semaphore(5); //机器数目
          for(int i=0;i<N;i++)
              new Worker(i,semaphore).start();
      }
       
      static class Worker extends Thread{
          private int num;
          private Semaphore semaphore;
          public Worker(int num,Semaphore semaphore){
              this.num = num;
              this.semaphore = semaphore;
          }
           
          @Override
          public void run() {
              try {
                  semaphore.acquire();
                  System.out.println("工人"+this.num+"占用一个机器在生产...");
                  Thread.sleep(2000);
                  System.out.println("工人"+this.num+"释放出机器");
                  semaphore.release();           
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
          }
      }
  }
  ```

  ​

### 4. ReentrantLock（重入锁）

* java.util.concurrent.lock中的Lock是锁的一个抽象，ReentrantLock类实现了Lock，它拥有与synchronized相同的并发性和内存语义，代码如下所示：

  ```java
  class Outputter1 {    
      private Lock lock = new ReentrantLock();// 锁对象    
      public void output(String name) {           
          lock.lock();      // 得到锁    
          try {    
              for(int i = 0; i < name.length(); i++) {    
                  System.out.print(name.charAt(i));    
              }    
          } finally {    
              lock.unlock();// 释放锁    
          }    
      }    
  }    
  ```

### 5. ReadWriteLock（读写锁）

* 允许多个线程可以同时读取，但是只能有一个线程修改共享数据（适合读多写少的情况）

* 代码如下所示：

  ```java
  class Data {        
      private int data;// 共享数据    
      private ReadWriteLock rwl = new ReentrantReadWriteLock();       
      public void set(int data) {    
          rwl.writeLock().lock();// 取到写锁    
          try {    
              System.out.println(Thread.currentThread().getName() + "准备写入数据");    
              try {    
                  Thread.sleep(20);    
              } catch (InterruptedException e) {    
                  e.printStackTrace();    
              }    
              this.data = data;    
              System.out.println(Thread.currentThread().getName() + "写入" + this.data);    
          } finally {    
              rwl.writeLock().unlock();// 释放写锁    
          }    
      }       
    
      public void get() {    
          rwl.readLock().lock();// 取到读锁    
          try {    
              System.out.println(Thread.currentThread().getName() + "准备读取数据");    
              try {    
                  Thread.sleep(20);    
              } catch (InterruptedException e) {    
                  e.printStackTrace();    
              }    
              System.out.println(Thread.currentThread().getName() + "读取" + this.data);    
          } finally {    
              rwl.readLock().unlock();// 释放读锁    
          }    
      }    
  }    
  ```

### 6. Condition

* Condition用于线程之间的通信，用于替代Object的wait()、notify()实现线程间的协作，相比使用Object的wait()、notify(),使用Condition的await()、signal()这种方式实现线程间协作更加安全和高效。推荐使用Condition

  ```java
  public class ConTest {  
        
       final Lock lock = new ReentrantLock();  
       final Condition condition = lock.newCondition();  
    
      public static void main(String[] args) {  
          // TODO Auto-generated method stub  
          ConTest test = new ConTest();  
          Producer producer = test.new Producer();  
          Consumer consumer = test.new Consumer();     
          consumer.start();   
          producer.start();  
      }  
        
       class Consumer extends Thread{  
             
              @Override  
              public void run() {  
                  consume();  
              }  
                  
              private void consume() {                                 
                      try {  
                             lock.lock();  
                    System.out.println("我在等一个新信 号"+this.currentThread().getName());  
                          condition.await();  
                            
                      } catch (InterruptedException e) {  
                          // TODO Auto-generated catch block  
                          e.printStackTrace();  
                      } finally{  
                          System.out.println("拿到一个信号"+this.currentThread().getName());  
                          lock.unlock();  
                      }  
                    
              }  
          }  
         
       class Producer extends Thread{  
             
              @Override  
              public void run() {  
                  produce();  
              }  
                  
              private void produce() {                   
                      try {  
                             lock.lock();  
                             System.out.println("我拿到锁"+this.currentThread().getName());  
                              condition.signalAll();                             
                          System.out.println("我发出了一个信号："+this.currentThread().getName());  
                      } finally{  
                          lock.unlock();  
                      }  
                  }  
       }  
  }  
  ```

### 7. 公平锁以及非公平锁？

* 公平锁是指哪个线程会先运行，那就可以先获取到锁。非公平锁是不管线程是否先运行，都随即获得锁。


* 在Lock中默认使用非公平锁（不加顺序），效率比公平锁更高。公平锁会维护锁的顺序，因此效率没有那么高。

### 8. synchronized

- 弊端
  - 在执行synchronized声明的方法有时候也有弊端，比如A线程的同步方法执行一个很长时间的任务，那么B线程就必须等待比较长的时间才能执行，这种情况下可以使用synchronized代码去优化代码执行的时间。
    * 不要使用String的常量去加锁，会出现死循环。
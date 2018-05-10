# Java面试宝典



# 一、相关概念
## 1. 面向对象的三个特征
 

## 2. 多态的好处
###  
## 3. 虚拟机是如何实现多态的
 


## 4. 接口的意义
 
## 5. 抽象类的意义



## 6. 接口和抽象类的区别 



## 7. 父类的静态方法能否被子类重写
 

## 8. 什么是不可变对象
 

## 9. 静态变量和实例变量的区别?
 


## 10. 能否创建一个包含可变对象的不可变对象?
 

## 11. java 创建对象的几种方式



## 12. switch中能否使用string做参数


## 13. switch能否作用在byte,long上? 


## 14. String s1="ab",String s2="a"+"b",String s3="a",String s4="b",s5=s3+s4请问s5==s2返回什么?



## 15. 你对String对象的intern()熟悉么?


## 16. Object中有哪些公共方法?


## 17. java当中的四种引用



## 18. WeakReference与SoftReference的区别?


## 19. 为什么要有不同的引用类型


## 20. java中==和`eqauls()`的区别,`equals()`和`hashcode的区别

##21. `equals()`和`hashcode()`的联系


## 22. a.hashCode()有什么用?与a.equals(b)有什么关系


## 23. 有没有可能两个不相等的对象有相同的hashcode



## 24. 可以在hashcode中使用随机数字吗?


## 25. a==b与a.equals(b)有什么区别


##  26. `3*0.1==0.3`返回值是什么


## 27. a=a+b与a+=b有什么区别吗?


## 28. short s1= 1; s1 = s1 + 1; 该段代码是否有错,有的话怎么改？

##29. short s1= 1; s1 += 1; 该段代码是否有错,有的话怎么改？


## 30. & 和 &&的区别


## 31. 一个.java文件内部可以有类?(非内部类)


## 32. 如何正确的退出多层嵌套循环.


## 33. 内部类的作用



## 34. final,finalize和finally的不同之处


## 35. clone()是哪个类的方法?


## 36. 深拷贝和浅拷贝的区别是什么?


## 37. static都有哪些用法?



## 38. final有哪些用法


----------


#二、数据类型相关
## 1. java中int char,long各占多少字节?



## 2. 64位的JVM当中,int的长度是多少?


## 3. int和Integer的区别


## 4. int 和Integer谁占用的内存更多?


## 5. String,StringBuffer和StringBuilder区别



### 6. String和StringBuffer


### 7. StringBuffer和StringBuilder


## 8. 什么是编译器常量?使用它有什么风险?



## 9. java当中使用什么类型表示价格比较好?
 

## 10. 如何将byte转为String
 


## 11. 可以将int强转为byte类型么?会产生什么问题?
 

----------

# 三、关于垃圾回收

## 1. 你知道哪些垃圾回收算法?


##2. 如何判断一个对象是否应该被回收
 

##3. 简单的解释一下垃圾回收
 


## 4. 调用System.gc()会发生什么?
 

----------


# 四、进程,线程相关
## 1. 说说进程,线程,协程之间的区别
 

## 2. 你了解守护线程吗?它和非守护线程有什么区别
 
## 3. 什么是多线程上下文切换
 

## 4. 创建两种线程的方式?他们有什么区别?


## 5. Thread类中的start()和run()方法有什么区别?
 

##6. 怎么检测一个线程是否持有对象监视器
 

## 7. Runnable和Callable的区别
 

## 8. 什么导致线程阻塞
 

## 9. wait(),notify()和suspend(),resume()之间的区别
 

## 10. 产生死锁的条件
 


## 11. 为什么wait()方法和notify()/notifyAll()方法要在同步块中被调用
 

## 12. wait()方法和notify()/notifyAll()方法在放弃对象监视器时有什么区别
 

## 13. wait()与sleep()的区别

 

## 14. 为什么wait,nofity和nofityAll这些方法不放在Thread类当中
 


##15. 怎么唤醒一个阻塞的线程
 

##16. 什么是多线程的上下文切换



## 17. synchronized和ReentrantLock的区别
 

## 18. FutureTask是什么
 

## 19. 一个线程如果出现了运行时异常怎么办?
 

## 20. Java当中有哪几种锁


## 21. 如何在两个线程间共享数据
 

## 22. 如何正确的使用wait()?使用if还是while?


## 23. 什么是线程局部变量ThreadLocal
 

## 24. ThreadLoal的作用是什么?
 

## 25. 生产者消费者模型的作用是什么?


## 26. 写一个生产者-消费者队列
 

### 26.1 使用阻塞队列来实现


### 26.2 使用wait-notify来实现
 

##27. 如果你提交任务时，线程池队列已满，这时会发生什么
 

##28. 为什么要使用线程池
 

##29. java中用到的线程调度算法是什么

 

##30. Thread.sleep(0)的作用是什么
 


##31. 什么是CAS
 

##32. 什么是乐观锁和悲观锁
 


## 33. ConcurrentHashMap的并发度是什么?
 

## 34. ConcurrentHashMap的工作原理
 
### 34.1  jdk 1.6:
 
### 34.2 jdk 1.8
 

## 35. CyclicBarrier和CountDownLatch区别


## 36. java中的++操作符线程安全么?


## 37. 你有哪些多线程开发良好的实践?


----------
#五、关于volatile关键字
## 1. 可以创建Volatile数组吗?
 

## 2. volatile能使得一个非原子操作变成原子操作吗?
 

## 3. volatile类型变量提供什么保证?
 

----------
#六、关于集合

## 1. Java中的集合及其继承关系
  

## 2. poll()方法和remove()方法区别?
 

## 3. LinkedHashMap和PriorityQueue的区别
 

## 4. WeakHashMap与HashMap的区别是什么?
 

## 5. ArrayList和LinkedList的区别?
 

## 6. ArrayList和Array有什么区别?


## 7. ArrayList和HashMap默认大小?


## 8. Comparator和Comparable的区别?
 

## 9. 如何实现集合排序?
 

## 10. 如何打印数组内容
 

## 11. LinkedList的是单向链表还是双向?
 

## 12. TreeMap是实现原理
 

## 13. 遍历ArrayList时如何正确移除一个元素
 


## 14. 什么是ArrayMap?它和HashMap有什么区别?
 


## 15. HashMap的实现原理



## 16. 你了解Fail-Fast机制吗


## 17. Fail-fast和Fail-safe有什么区别
 

----------


# 七、关于日期
## 1. SimpleDateFormat是线程安全的吗?
 

## 2. 如何格式化日期?


----------


# 八、关于异常
## 1. 简单描述java异常体系


## 2. 什么是异常链


## 3. throw和throws的区别
 

----------

## 九、关于序列化

## 1. Java 中，Serializable 与 Externalizable 的区别
 

----------

#十、关于JVM

## 1. JVM特性
 

## 2. 简单解释一下类加载器


## 3. 简述堆和栈的区别
 

## 4. 简述JVM内存分配



----------


#十一、其他
## 1. java当中采用的是大端还是小端?

## 2. XML解析的几种方式和特点



## 3. JDK 1.7特性
 
## 4. JDK 1.8特性
 

## 5. Maven和ANT有什么区别?
 

## 6. JDBC最佳实践


## 7. IO操作最佳实践














































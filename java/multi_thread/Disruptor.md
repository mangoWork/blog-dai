# Disrutor的基本概念以及使用

## 一、 什么是Disruptor？

* 从功能上来看，Disruptor是实现了“队列”的功能，而且是一个有界队列。使用的场景为“生产者--消费者”模型的应用场合。
* 生产者往队列中发布一项消息时，消费者能获得通知，如果没有消息的时候，消费者会被阻塞，直到生产者发布了新的消息。
* 同一个“事件”可以有多个消费者，消费者之间可以并行的处理，也可相互的依赖形成处理的先后次序。

## 二、 Disruptor的核心概念

### 1. RingBuffer

* 环行的缓冲区。曾经RingBuffer是Disruptor中的主要的对象，在3.0版本之后，其职责被简化为仅仅负责对通过Disruptor进行交换数据（事件）进行存储和更新。

### 2. Sequence Disruptor

* 通过顺序递增的序号来编号管理通过其进行交换的数据（事件），对数据（事件）的处理过程总是沿着序号逐个递增处理。一个sequence用于跟踪标识某个特定的事件处理者(RingBuffer/Consumer)的处理进度。并且也防止不同的Sequence之间的cpu缓存伪共享问题。

### 3. Sequencer

* Sequencer是Disruptor的真正核心。此接口的两个实现类`SingleProducerSequencer`、`MultiProducerSequencer`，他们定义在生产者和消费者之间快速、正确的传递数据的并发算法。

### 4. Sequence Barrier

* 用于保持对RingBuffer的main published Sequence和Consumer依赖的其它Consumer的Sequence引用。Sequence Barrier还定义了句顶Consumer是否还有可以处理的事件逻辑。

### 5. Wait  Strategy

* 定义Consumer如何进行等待下一个事件爱你的策略。（Tips：Disruptor定义了多种不同的策略，针对不同的场景，提供了不一样的性能表现）

### 6. Event

* 在disruptor的语义中，生产者和消费者之间进行交换的数据称之为事件（Event）。不是Disruptor定义的特定类型。而是由Disruptor的使用者定义并指定。

### 7. EventProcessor

* EventProcessor持有特定消费者的Sequence，并提供用于调用事件处理实现的实践循环。

### 8. EventHandler

* Disruptor定义的事件处理接口，由用户实现，用于处理事件，是Consumer的真正实现。

### 9. producer

* 生产者，只是泛指调用Disruptor发布事件的用户代码，Disruptor没有定义特定接口或类型。

## 三、如何使用Disruptor

### 1. 定义事件

* 事件(Event)就是通过 Disruptor 进行交换的数据类型。

  ```java
  public class LongEvent
  {
      private long value;
      public void set(long value)
      {
          this.value = value;
      }
  }
  ```

### 2. 定义事件工厂

* 事件工厂(Event Factory)定义了如何实例化前面第1步中定义的事件(Event)，需要实现接口 com.lmax.disruptor.EventFactory<T>。

* Disruptor 通过 EventFactory 在 RingBuffer 中预创建 Event 的实例。

* 一个 Event 实例实际上被用作一个“数据槽”，发布者发布前，先从 RingBuffer 获得一个 Event 的实例，然后往 Event 实例中填充数据，之后再发布到 RingBuffer 中，之后由 Consumer 获得该 Event 实例并从中读取数据。

  ```java
  import com.lmax.disruptor.EventFactory;

  public class LongEventFactory implements EventFactory<LongEvent>
  {
      public LongEvent newInstance()
      {
          return new LongEvent();
      }
  }
  ```

### 3. 定义事件处理的具体实现

* 通过实现接口 com.lmax.disruptor.EventHandler<T> 定义事件处理的具体实现。

  ```java
  import com.lmax.disruptor.EventHandler;

  public class LongEventHandler implements EventHandler<LongEvent>
  {
      public void onEvent(LongEvent event, long sequence, boolean endOfBatch)
      {
          System.out.println("Event: " + event);
      }
  }
  ```

### 4. 定义用于事件处理的线程池

* Disruptor 通过 java.util.concurrent.ExecutorService 提供的线程来触发 Consumer 的事件处理。例如：

  ```java
  ExecutorService executor = Executors.newCachedThreadPool();
  ```

### 5. 指定等待策略

* Disruptor 定义了 com.lmax.disruptor.WaitStrategy 接口用于抽象 Consumer 如何等待新事件，这是策略模式的应用。

* Disruptor 提供了多个 WaitStrategy 的实现，每种策略都具有不同性能和优缺点，根据实际运行环境的 CPU 的硬件特点选择恰当的策略，并配合特定的 JVM 的配置参数，能够实现不同的性能提升。

* 例如，BlockingWaitStrategy、SleepingWaitStrategy、YieldingWaitStrategy 等，其中，BlockingWaitStrategy 是最低效的策略，但其对CPU的消耗最小并且在各种不同部署环境中能提供更加一致的性能表现；

* SleepingWaitStrategy 的性能表现跟 BlockingWaitStrategy 差不多，对 CPU 的消耗也类似，但其对生产者线程的影响最小，适合用于异步日志类似的场景；

* YieldingWaitStrategy 的性能是最好的，适合用于低延迟的系统。在要求极高性能且事件处理线数小于 CPU 逻辑核心数的场景中，推荐使用此策略；例如，CPU开启超线程的特性。

  ```java
  WaitStrategy BLOCKING_WAIT = new BlockingWaitStrategy();
  WaitStrategy SLEEPING_WAIT = new SleepingWaitStrategy();
  WaitStrategy YIELDING_WAIT = new YieldingWaitStrategy();
  ```

### 6. 启动Disruptor

```java
EventFactory<LongEvent> eventFactory = new LongEventFactory();
ExecutorService executor = Executors.newSingleThreadExecutor();
int ringBufferSize = 1024 * 1024; // RingBuffer 大小，必须是 2 的 N 次方；
        
Disruptor<LongEvent> disruptor = new Disruptor<LongEvent>(eventFactory,
                ringBufferSize, executor, ProducerType.SINGLE,
                new YieldingWaitStrategy());
        
EventHandler<LongEvent> eventHandler = new LongEventHandler();
disruptor.handleEventsWith(eventHandler);
        
disruptor.start();
```

### 7. 发布事件

* Disruptor 的事件发布过程是一个两阶段提交的过程：

  * 第一步：先从 RingBuffer 获取下一个可以写入的事件的序号；
  * 第二步：获取对应的事件对象，将数据写入事件对象；
  * 第三部：将事件提交到 RingBuffer;

* 事件只有在提交之后才会通知 EventProcessor 进行处理；

  ```java
  // 发布事件；
  RingBuffer<LongEvent> ringBuffer = disruptor.getRingBuffer();
  long sequence = ringBuffer.next();//请求下一个事件序号；
      
  try {
      LongEvent event = ringBuffer.get(sequence);//获取该序号对应的事件对象；
      long data = getEventData();//获取要通过事件传递的业务数据；
      event.set(data);
  } finally{
      ringBuffer.publish(sequence);//发布事件；
  }
  ```

*  注意，最后的 ringBuffer.publish 方法必须包含在 finally 中以确保必须得到调用；如果某个请求的 sequence 未被提交，将会堵塞后续的发布操作或者其它的 producer。

* Disruptor 还提供另外一种形式的调用来简化以上操作，并确保 publish 总是得到调用。

  ```java
  static class Translator implements EventTranslatorOneArg<LongEvent, Long>{
      @Override
      public void translateTo(LongEvent event, long sequence, Long data) {
          event.set(data);
      }    
  }
      
  public static Translator TRANSLATOR = new Translator();
      
  public static void publishEvent2(Disruptor<LongEvent> disruptor) {
      // 发布事件；
      RingBuffer<LongEvent> ringBuffer = disruptor.getRingBuffer();
      long data = getEventData();//获取要通过事件传递的业务数据；
      ringBuffer.publishEvent(TRANSLATOR, data);
  }
  ```

* 此外，Disruptor 要求 RingBuffer.publish 必须得到调用的潜台词就是，如果发生异常也一样要调用 publish ，那么，很显然这个时候需要调用者在事件处理的实现上来判断事件携带的数据是否是正确的或者完整的，这是实现者应该要注意的事情。

### 8. 关闭 Disruptor

```java
disruptor.shutdown();//关闭 disruptor，方法会堵塞，直至所有的事件都得到处理；
executor.shutdown();//关闭 disruptor 使用的线程池；如果需要的话，必须手动关闭， disruptor 在 shutdown 时不会自动关闭；
```


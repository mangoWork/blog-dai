### Kafka消费者客户端

#### 偏移量和消费者位置

&nbsp;　　kafka为分区中的每条消息保存一个偏移量（offset），这个偏移量是该分区中一条消息的唯一标示符。也表示消费者在分区的位置。例如，一个位置是5的消费者(说明已经消费了0到4的消息)，下一个接收消息的偏移量为5的消息。实际上有两个与消费者相关的“位置”概念：

&nbsp;　　消费者的位置给出了下一条记录的偏移量。它比消费者在该分区中看到的最大偏移量要大一个。 它在每次消费者在调用poll(long)中接收消息时自动增长。

&nbsp;　　“已提交”的位置是已安全保存的最后偏移量，如果进程失败或重新启动时，消费者将恢复到这个偏移量。消费者可以选择定期自动提交偏移量，也可以选择通过调用commit API来手动的控制(如：commitSync 和 commitAsync)。

&nbsp;　　这个区别是消费者来控制一条消息什么时候才被认为是已被消费的，控制权在消费者，下面我们进一步更详细地讨论。

#### 消费者组和主题订阅
&nbsp;　　Kafka的消费者组概念，通过进程池瓜分消息并处理消息。这些进程可以在同一台机器运行，也可分布到多台机器上，以增加可扩展性和容错性，相同**group.id**的消费者将视为同一个消费者组。
 
&nbsp;　　分组中的每个消费者都通过subscribe API动态的订阅一个topic列表。kafka将已订阅topic的消息发送到每个消费者组中。并通过平衡分区在消费者分组中所有成员之间来达到平均。因此每个分区恰好地分配1个消费者（一个消费者组中）。所有如果一个topic有4个分区，并且一个消费者分组有只有2个消费者。那么每个消费者将消费2个分区。

&nbsp;　　消费者组的成员是**动态维护**的：如果一个消费者故障。分配给它的分区将重新分配给同一个分组中其他的消费者。同样的，如果一个新的消费者加入到分组，将从现有消费者中移一个给它，这被称为**重新平衡分组**

&nbsp;　　允许消费者通过使用**assign(Collection)**手动分配指定分区，如果使用手动指定分配分区，那么动态分区分配和协调消费者组将失效。 

#### 发现消费者故障

&nbsp;　　订阅一组topic后，当调用poll(long）时，消费者将自动加入到组中。只要持续的调用poll，消费者将一直保持可用，并继续从分配的分区中接收消息。此外，消费者向服务器定时发送心跳。 如果消费者崩溃或无法在session.timeout.ms配置的时间内发送心跳，则消费者将被视为死亡，并且其分区将被重新分配

&nbsp;　　还有一种可能，消费可能遇到“活锁”的情况，它持续的发送心跳，但是没有处理。为了预防消费者在这种情况下一直持有分区，我们使用**max.poll.interval.ms**活跃检测机制。 在此基础上，如果你调用的poll的频率大于最大间隔，则客户端将主动地离开组，以便其他消费者接管该分区。 发生这种情况时，你会看到offset提交失败（调用commitSync（）引发的CommitFailedException）。这是一种安全机制，保障只有活动成员能够提交offset。所以要留在组中，你必须持续调用poll。

#### 自动提交偏移量

```java
  Properties props = new Properties();
     props.put("bootstrap.servers", "localhost:9092");
     props.put("group.id", "test");
     props.put("enable.auto.commit", "true");
     props.put("auto.commit.interval.ms", "1000");
     props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
     props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
     KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
     consumer.subscribe(Arrays.asList("foo", "bar"));
     while (true) {
         ConsumerRecords<String, String> records = consumer.poll(100);
         for (ConsumerRecord<String, String> record : records)
             System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
     }
```

&nbsp;　　设置enable.auto.commit,偏移量由auto.commit.interval.ms控制自动提交的频率。

#### 手动提交偏移量

&nbsp;　　不需要定时的提交offset，可以自己控制offset，当消息认为已消费过了，这个时候再去提交它们的偏移量。这个很有用的，当消费的消息结合了一些处理逻辑，这个消息就不应该认为是已经消费的，直到它完成了整个处理。

```java
     Properties props = new Properties();
     props.put("bootstrap.servers", "localhost:9092");
     props.put("group.id", "test");
     props.put("enable.auto.commit", "false");
     props.put("auto.commit.interval.ms", "1000");
     props.put("session.timeout.ms", "30000");
     props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
     props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
     KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
     consumer.subscribe(Arrays.asList("foo", "bar"));
     final int minBatchSize = 200;
     List<ConsumerRecord<String, String>> buffer = new ArrayList<>();
     while (true) {
         ConsumerRecords<String, String> records = consumer.poll(100);
         for (ConsumerRecord<String, String> record : records) {
             buffer.add(record);
         }
         if (buffer.size() >= minBatchSize) {
             insertIntoDb(buffer);
             consumer.commitSync();
             buffer.clear();
         }
     }
```

&nbsp;　　在这个例子中，我们将消费一批消息并将它们存储在内存中。当我们积累足够多的消息后，我们再将它们批量插入到数据库中。如果我们设置offset自动提交（之前说的例子），消费将被认为是已消费的。这样会出现问题，我们的进程可能在批处理记录之后，但在它们被插入到数据库之前失败了。

&nbsp;　　为了避免这种情况，我们将在相应的记录插入数据库之后再手动提交偏移量。这样我们可以准确控制消息是成功消费的。提出一个相反的可能性：在插入数据库之后，但是在提交之前，这个过程可能会失败（即使这可能只是几毫秒，这是一种可能性）。在这种情况下，进程将获取到已提交的偏移量，并会重复插入的最后一批数据。这种方式就是所谓的“至少一次”保证，在故障情况下，可以重复。

&nbsp;　　如果您无法执行这些操作，可能会使已提交的偏移超过消耗的位置，从而导致缺少记录。 使用手动偏移控制的优点是，您可以直接控制记录何时被视为“已消耗”。

&nbsp;　　注意：使用自动提交也可以“至少一次”。但是要求你必须下次调用poll（long）之前或关闭消费者之前，处理完所有返回的数据。如果操作失败，这将会导致已提交的offset超过消费的位置，从而导致丢失消息。使用手动控制offset的有点是，你可以直接控制消息何时提交。、

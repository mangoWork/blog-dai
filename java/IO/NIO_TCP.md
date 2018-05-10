## 1. 服务器端

* 创建一个Selector实例
* 将其注册到各种信道， 并指出每个信道上对应的I/O操作
* 重复执行
  * 调用一种select()方法
  * 获取选取的键的列表
  * 对于已选键集中的每个键
  * 获取信道，并从键中获取附件
  * 确定准备就绪的操纵并执行，如果是accept操作，将接收的信道设置为非阻塞模式，并注册到选择器中。
  * 如果需要，修改键的操作
  * 从已选键集中移除键

## 2. 客户端

* 客户端通过信道建立连接

## 3 代码 

* 客户端代码如下所示：

```java
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class TCPEchoClientNonblocking {
  public static void main(String args[]) throws Exception{
    if ((args.length < 2) || (args.length > 3)) 
    throw new IllegalArgumentException("参数不正确");
    //第一个参数作为要连接的服务端的主机名或IP
    String server = args[0]; 
    //第二个参数为要发送到服务端的字符串
    byte[] argument = args[1].getBytes();
    //如果有第三个参数，则作为端口号，如果没有，则端口号设为7
    int servPort = (args.length == 3) ? Integer.parseInt(args[2]) : 7;
    //创建一个信道，并设为非阻塞模式
    SocketChannel clntChan = SocketChannel.open();
    clntChan.configureBlocking(false);
    //向服务端发起连接
    if (!clntChan.connect(new InetSocketAddress(server, servPort))){
      //不断地轮询连接状态，直到完成连接
      while (!clntChan.finishConnect()){
        //在等待连接的时间里，可以执行其他任务，以充分发挥非阻塞IO的异步特性
        //这里为了演示该方法的使用，只是一直打印"."
        System.out.print(".");  
      }
    }
    //为了与后面打印的"."区别开来，这里输出换行符
    System.out.print("\n");
    //分别实例化用来读写的缓冲区
    ByteBuffer writeBuf = ByteBuffer.wrap(argument);
    ByteBuffer readBuf = ByteBuffer.allocate(argument.length);
    //接收到的总的字节数
    int totalBytesRcvd = 0; 
    //每一次调用read（）方法接收到的字节数
    int bytesRcvd; 
    //循环执行，直到接收到的字节数与发送的字符串的字节数相等
    while (totalBytesRcvd < argument.length){
      //如果用来向通道中写数据的缓冲区中还有剩余的字节，则继续将数据写入信道
      if (writeBuf.hasRemaining()){
        clntChan.write(writeBuf);
      }
      //如果read（）接收到-1，表明服务端关闭，抛出异常
      if ((bytesRcvd = clntChan.read(readBuf)) == -1){
        throw new SocketException("Connection closed prematurely");
      }
      //计算接收到的总字节数
      totalBytesRcvd += bytesRcvd;
      //在等待通信完成的过程中，程序可以执行其他任务，以体现非阻塞IO的异步特性
      //这里为了演示该方法的使用，同样只是一直打印"."
      System.out.print("."); 
    }
    //打印出接收到的数据
    System.out.println("Received: " +  new String(readBuf.array(), 0, totalBytesRcvd));
    //关闭信道
    clntChan.close();
  }
}
```

* 服务器端代码如下所示;

  ```java
  import java.io.IOException;
  import java.net.InetSocketAddress;
  import java.nio.channels.SelectionKey;
  import java.nio.channels.Selector;
  import java.nio.channels.ServerSocketChannel;
  import java.util.Iterator;

  public class TCPServerSelector{
    //缓冲区的长度
    private static final int BUFSIZE = 256; 
    //select方法等待信道准备好的最长时间
    private static final int TIMEOUT = 3000; 
    public static void main(String[] args) throws IOException {
      if (args.length < 1){
        throw new IllegalArgumentException("Parameter(s): <Port> ...");
      }
      //创建一个选择器
      Selector selector = Selector.open();
      for (String arg : args){
        //实例化一个信道
        ServerSocketChannel listnChannel = ServerSocketChannel.open();
        //将该信道绑定到指定端口
        listnChannel.socket().bind(new InetSocketAddress(Integer.parseInt(arg)));
        //配置信道为非阻塞模式
        listnChannel.configureBlocking(false);
        //将选择器注册到各个信道
        listnChannel.register(selector, SelectionKey.OP_ACCEPT);
      }
      //创建一个实现了协议接口的对象
      TCPProtocol protocol = new EchoSelectorProtocol(BUFSIZE);
      //不断轮询select方法，获取准备好的信道所关联的Key集
      while (true){
        //一直等待,直至有信道准备好了I/O操作
        if (selector.select(TIMEOUT) == 0){
          //在等待信道准备的同时，也可以异步地执行其他任务，
          //这里只是简单地打印"."
          System.out.print(".");
          continue;
        }
        //获取准备好的信道所关联的Key集合的iterator实例
        Iterator<SelectionKey> keyIter = selector.selectedKeys().iterator();
        //循环取得集合中的每个键值
        while (keyIter.hasNext()){
          SelectionKey key = keyIter.next(); 
          //如果服务端信道感兴趣的I/O操作为accept
          if (key.isAcceptable()){
            protocol.handleAccept(key);
          }
          //如果客户端信道感兴趣的I/O操作为read
          if (key.isReadable()){
            protocol.handleRead(key);
          }
          //如果该键值有效，并且其对应的客户端信道感兴趣的I/O操作为write
          if (key.isValid() && key.isWritable()) {
            protocol.handleWrite(key);
          }
          //这里需要手动从键集中移除当前的key
          keyIter.remove(); 
        }
      }
    }
  }
  ```

  ​
## python中socket编程

[TOC]

### 1. 服务器端为socket方式

* 服务器端代码如下所示：

  ```python
  def service(host, port):
      sk = socket.socket()
      sk.bind((host, port))
      sk.listen(5)
      while True:
          print 'server waiting ..........'
          # 等待链接,阻塞，直到渠道链接 conn打开一个新的对象 专门给当前链接的客户端 addr是ip地址
          con, addr = sk.accept()
          # 获取客户端请求数据
          client_data = con.recv(1024)
          print str(client_data)
          # 向对方发送数据
          con.sendall('不要回答,不要回答,不要回答')
          # con.close()


  if __name__ == "__main__":
      HOST, PORT = 'localhost', 9991
      service(HOST, PORT)
  ```

* 客户端代码如下所示：

  ```python
  def client(ip):
      sk = socket.socket()
      sk.connect(ip)
      time.sleep(4)
      msg = {'status': True, 'leave': True, 'msg': '我下线了！'}
      sk.sendall(str(msg))
      server_reply = sk.recv(1024)
      print str(server_reply)
      print '我下线了'

  if __name__ == '__main__':
      address = ('localhost', 9991)
      client(address)
  ```

### 2. 服务器端为SocketServer方式

* 服务器端代码如下所示：

  ```python
  class MyTcpHandler(SocketServer.BaseRequestHandler):

      def handle(self):
          self.data = self.request.recv(1024).strip()
          print '{} wrote:'.format(self.client_address[0])
          print self.data
          self.request.sendall(self.data.upper())


  if __name__ == "__main__":
      HOST, PORT = "localhost", 9999

      # Create the server, binding to localhost on port 9999
      # ThreadingTCPServer 支持多线程并发
      server = SocketServer.ThreadingTCPServer((HOST, PORT), MyTcpHandler)
      server.serve_forever()
  ```

* 客户端代码如下所示：

  ```python
  def client():
      HOST, PORT = "localhost", 9999
      data = "mango "

      # Create a socket (SOCK_STREAM means a TCP socket)
      sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

      try:
          # Connect to server and send data
          sock.connect((HOST, PORT))
          sock.sendall(data)

          # Receive data from the server and shut down
          received = str(sock.recv(1024))
          print received
      finally:
          sock.close()

  if __name__ == '__main__':
      client()
  ```

## python中的多线程编程

### 1. python中创建线程的两种方式

#### 1.1 直接调用方式创建线程：

* 代码如下所示：

  ```python
  def say_hi(num):
      time.sleep(random.randint(0, 5))
      print 'running on number: %s' % num
      time.sleep(3)

  if __name__ == '__main__':
      # 生成线程实例 并且启动线程
      for index in range(100):
          threading.Thread(target=say_hi, args=(index,)).start()
  ```

#### 1.2 通过继承方式创建线程

* 代码如下所示：

  ```python
  class MyThread(threading.Thread):
      def __init__(self, num):
          threading.Thread.__init__(self)
          self.num = num

      def run(self):
          time.sleep(random.randint(0, 3))
          print 'the number is %s!' % self.num


  if __name__ == '__main__':
      for index in range(100):
          MyThread(index).start()
  ```

### 2. python 中join

* python 默认参数创建线程后，不管主线程是否执行完毕，都会等待子线程执行完毕才一起退出，有无join结果一样

* 如果创建线程，并且设置了daemon为true，即thread.setDaemon(True), 则主线程执行完毕后自动退出，不会等待子线程的执行结果。而且随着主线程退出，子线程也消亡。

* join方法的作用是**阻塞**，等待子线程结束，join方法有一个参数是timeout，即如果主线程等待timeout，子线程还没有结束，则主线程强制结束子线程。

* 如果线程daemon属性为False， 则join里的timeout参数无效。主线程会一直等待子线程结束。

* 如果线程daemon属性为True， 则join里的timeout参数是有效的， 主线程会等待timeout时间后，结束子线程。此处有一个坑，即如果同时有N个子线程join(timeout），那么实际上主线程会等待的超时时间最长为 timeout， 因为每个子线程的超时开始时刻是上一个子线程超时结束的时刻。

* 代码如下所示：

  ```python
  def run(n):
      print '[%s]---------running--------\n' % n
      time.sleep(2)
      print '----done-----'


  def main():
      for index in range(5):
          t = threading.Thread(target=run, args=(index,))
          t.start()
          t.join(2)
          print 'starting  thread, the name is %s' % t.getName()


  if __name__ == '__main__':
      m = threading.Thread(target=main, args=[])
      m.setDaemon(True)  # 设置为守护线程,它作为程序的主线程，当主线程退出时,m线程也会退出, 由m启动的其它子线程会同时退出,不管是否执行完任务
      m.start()
      m.join(timeout=3)
      print("---main thread done----")

  ```

### 3. 锁

#### 3.1 Lock(互斥锁)

* 用法如下所示：

  ```python
  def add_num():
      global num
      print '--get num:%s' % num
      time.sleep(1)
      lock.acquire()
      num -= 1
      lock.release()

  if __name__ == '__main__':
      num = 101
      lock = threading.Lock()
      thread_list = []
      for i in range(100):
          t = threading.Thread(target=add_num)
          t.start()
          thread_list.append(t)
      for tl in thread_list:  # 等待所有线程执行完毕
          t.join()
      print 'final num: %s' % num
  ```

#### 3.2 RLock(递归锁)

* 用法如下所示(在一个大锁中还要再包含子锁)：

  ```python
  def run1():
      print 'grab the first part data'
      lock.acquire()
      global num
      num += 1
      lock.release()
      return num


  def run2():
      print 'grab the second part data'
      lock.acquire()
      global num2
      num2 += 1
      lock.release()
      return num2


  def run3():
      lock.acquire()
      res = run1()
      print '-----------between run1 and run2 ----------'
      res2 = run2()
      lock.release()
      print res, res2

  if __name__ == '__main__':
      num, num2 = 0, 0
      lock = threading.RLock()
      for i in range(10):
          t = threading.Thread(target=run3)
          t.start()
      while threading.active_count() != 1:
          print threading.active_count
      else:
          print '-----all threads done-------'
          print num, num2
  ```

####  3.3 信号量(Semaphore)

* 互斥锁 同时只允许一个线程更改数据，而Semaphore是同时允许一定数量的线程更改数据 ，比如厕所有3个坑，那最多只允许3个人上厕所，后面的人只能等里面有人出来了才能再进去。(同时对一个全局变量修该数据不准确)

* 代码如下所示：

  ```python
  # -*- coding: utf-8 -*-
  # 信号量
  # 互斥锁 同时只允许一个线程更改数据，而Semaphore是同时允许一定数量的线程更改数据 ，
  # 比如厕所有3个坑，那最多只允许3个人上厕所，后面的人只能等里面有人出来了才能再进去。
  import threading
  import time


  def run(n):
      semaphore.acquire()
      time.sleep(1)
      print 'run the thread: %s \n' % n
      semaphore.release()


  if __name__ == '__main__':
      num = 0
      # 最多允许5个线程同时运行
      semaphore = threading.BoundedSemaphore(5)
      for i in range(20):
          t = threading.Thread(target=run, args=(i,))
          t.start()
      while threading.active_count() != 1:
          pass  # print threading.active_count()
      else:
          print('----all threads done---')
          print(num)

  ```

#### 3.4 多线程交互(Event)

* 在python多线程的环境下，threading.Event默认内置了一个标志，初始值为False，该线程通过wait()方法或者clear()方法进入等待状态，直到一个线程调用该Event的set()方法将内置标识设置为True的时候，该Event会通知所有等待状态的线程恢复运行。

*  下面代码模拟红绿灯的例子：

  ```python
  # -*- coding: utf-8 -*-
  # 通过Event来实现两个或多个线程间的交互 下面是一个红绿灯的例子
  import random
  import threading

  import time


  def light():
      if not event.isSet():
          event.set()
      count = 0
      while True:
          if count < 10:
              print '\033[42;1m--green light on---\033[0m'
          elif count < 13:
              print '\033[43;1m--yellow light on---\033[0m'
          elif count < 20:
              if event.isSet():
                  event.clear()  # 继续阻塞
              print '\033[41;1m--red light on---\033[0m'
          else:
              count = 0
              event.set()  # 唤醒所有的event， 处于等待状态
          time.sleep(1)
          count += 1


  def car(n):
      while True:
          time.sleep(random.randrange(10))
          if event.isSet():  # 绿灯
              print "car [%s] is running.." % n
          else:
              print "car [%s] is waiting for the red light.." % n


  if __name__ == '__main__':
      event = threading.Event()
      light = threading.Thread(target=light)
      light.start()
      for i in range(4):
          threading.Thread(target=car, args=(i,)).start()
  ```

  ​


## java日志的配置

### 1. log4j.properties内容

> log4j日志分为7个等级：ALL、DEBUG、INFO、WARN、ERROR、FATAL、OFF，从左到右等级由低到高，分等级是为了设置日志输出的门槛

* logger

  * 日志实例，就是代码里实例化的Logger对象

    ```shell
      log4j.rootLogger=LEVEL,appenderName1,appenderName2,...
      log4j.additivity.org.apache=false：表示不会在父logger的appender里输出，默认true
    ```

  * 这是全局logger的配置，LEVEL用来设定日志等级，appenderName定义日志输出器

  * 下面给出一个更清晰的例子，配置“com.demo.test”包下所有类中实例化的Logger对象

    ```shell
    log4j.logger.com.demo.test=DEBUG,test
    log4j.additivity.com.demo.test=false
    ```

* appender

  > 日志输出器，指定logger的输出位置  
  > log4j.appender.appenderName=className

  * appender有5种选择

    ```shell
    org.apache.log4j.ConsoleAppender（控制台）
    org.apache.log4j.FileAppender（文件）
    org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
    org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
    org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）
    ```

  * 每种appender都有若干配置项，下面逐一介绍

    * ConsoleAppender（常用）

      ```shell
        > Threshold=WARN：指定日志信息的最低输出级别，默认DEBUG
        > ImmediateFlush=true：表示所有消息都会被立即输出，设为false则不输出，默认值是true
        Target=System.err：默认值是System.out
      ```

    * FileAppender

      ```shell
        > Threshold=WARN：指定日志信息的最低输出级别，默认DEBUG
        > ImmediateFlush=true：表示所有消息都会被立即输出，设为false则不输出，默认true
        > Append=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认true
        > File=D:/logs/logging.log4j：指定消息输出到logging.log4j文件
      ```

    * DailyRollingFileAppender（常用）

      ```shell
      Threshold=WARN：指定日志信息的最低输出级别，默认DEBUG
      ImmediateFlush=true：表示所有消息都会被立即输出，设为false则不输出，默认true
      Append=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认true
      File=D:/logs/logging.log4j：指定当前消息输出到logging.log4j文件
      DatePattern='.'yyyy-MM：每月滚动一次日志文件，即每月产生一个新的日志文件。当前月的日志文件名为logging.log4j，前一个月的日志文件名为logging.log4j.yyyy-MM
      另外，也可以指定按周、天、时、分等来滚动日志文件，对应的格式如下：
      1)'.'yyyy-MM：每月
      2)'.'yyyy-ww：每周
      3)'.'yyyy-MM-dd：每天
      4)'.'yyyy-MM-dd-a：每天两次
      5)'.'yyyy-MM-dd-HH：每小时
      6)'.'yyyy-MM-dd-HH-mm：每分钟
      ```

    * RollingFileAppender

      ```shell
      Threshold=WARN：指定日志信息的最低输出级别，默认DEBUG
      ImmediateFlush=true：表示所有消息都会被立即输出，设为false则不输出，默认true
      Append=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认true
      File=D:/logs/logging.log4j：指定消息输出到logging.log4j文件
      MaxFileSize=100KB：后缀可以是KB,MB或者GB。在日志文件到达该大小时，将会自动滚动，即将原来的内容移到logging.log4j.1文件
      MaxBackupIndex=2：指定可以产生的滚动文件的最大数，例如，设为2则可以产生logging.log4j.1，logging.log4j.2两个滚动文件和一个logging.log4j文件
      ```

* layout

  > 指定logger输出内容及格式
  >
  > log4j.appender.appenderName.layout=className

  * layout有4种选择

    ```shell
    org.apache.log4j.HTMLLayout（以HTML表格形式布局）
    org.apache.log4j.PatternLayout（可以灵活地指定布局模式）
    org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串）
    org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等信息）
    ```

  * layout也有配置项，下面具体介绍

    * HTMLLayout

      ```shell
      LocationInfo=true：输出java文件名称和行号，默认false
      Title=My Logging： 默认值是Log4J Log Messages
      ```

      * PatternLayout（最常用的配置）

        > ConversionPattern=%m%n：设定以怎样的格式显示消息

        * 设置格式的参数说明如下

        ```shell
        %p：输出日志信息的优先级，即DEBUG，INFO，WARN，ERROR，FATAL
        %d：输出日志时间点的日期或时间，默认格式为ISO8601，可以指定格式如：%d{yyyy/MM/dd HH:mm:ss,SSS}
        %r：输出自应用程序启动到输出该log信息耗费的毫秒数
        %t：输出产生该日志事件的线程名
        %l：输出日志事件的发生位置，相当于%c.%M(%F:%L)的组合，包括类全名、方法、文件名以及在代码中的行数
        %c：输出日志信息所属的类目，通常就是类全名
        %M：输出产生日志信息的方法名
        %F：输出日志消息产生时所在的文件名
        %L：输出代码中的行号
        %m：输出代码中指定的具体日志信息
        %n：输出一个回车换行符，Windows平台为"rn"，Unix平台为"n"
        %x：输出和当前线程相关联的NDC(嵌套诊断环境)
        %%：输出一个"%"字符
        ```

* log4j完整配置示例

> 介绍完了log4j.properties内容，我们来配置一些常用的日志输出吧

```shell
  log4j.rootLogger=DEBUG,console,dailyFile,rollingFile,logFile
  log4j.additivity.org.apache=true
```

* 控制台console日志输出器

  ```shell
  log4j.appender.console=org.apache.log4j.ConsoleAppender
  log4j.appender.console.Threshold=DEBUG
  log4j.appender.console.ImmediateFlush=true
  log4j.appender.console.Target=System.err
  log4j.appender.console.layout=org.apache.log4j.PatternLayout
  log4j.appender.console.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
  ```

* 文件logFile日志输出器

  ```shell
  log4j.appender.logFile=org.apache.log4j.FileAppender
  log4j.appender.logFile.Threshold=DEBUG
  log4j.appender.logFile.ImmediateFlush=true
  log4j.appender.logFile.Append=true
  log4j.appender.logFile.File=D:/logs/log.log4j
  log4j.appender.logFile.layout=org.apache.log4j.PatternLayout
  log4j.appender.logFile.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
  ```

* 滚动文件rollingFile日志输出器
  ```shell
  log4j.appender.rollingFile=org.apache.log4j.RollingFileAppender
  log4j.appender.rollingFile.Threshold=DEBUG
  log4j.appender.rollingFile.ImmediateFlush=true
  log4j.appender.rollingFile.Append=true
  log4j.appender.rollingFile.File=D:/logs/log.log4j
  log4j.appender.rollingFile.MaxFileSize=200KB
  log4j.appender.rollingFile.MaxBackupIndex=50
  log4j.appender.rollingFile.layout=org.apache.log4j.PatternLayout
  log4j.appender.rollingFile.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
  ```

　　
* 定期滚动文件dailyFile日志输出器
  ```shell
  # 定期滚动日志文件(dailyFile)
  log4j.appender.dailyFile=org.apache.log4j.DailyRollingFileAppender
  log4j.appender.dailyFile.Threshold=DEBUG
  log4j.appender.dailyFile.ImmediateFlush=true
  log4j.appender.dailyFile.Append=true
  log4j.appender.dailyFile.File=D:/logs/log.log4j
  log4j.appender.dailyFile.DatePattern='.'yyyy-MM-dd
  log4j.appender.dailyFile.layout=org.apache.log4j.PatternLayout
  log4j.appender.dailyFile.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
  ```

* log4j局部日志配置

  * 以上介绍的配置都是全局的，整个工程的代码使用同一套配置，意味着所有的日志都输出在了相同的地方，你无法直接了当的去看数据库访问日志、用户登录日志、操作日志，它们都混在一起，因此，需要为包甚至是类配置单独的日志输出，下面给出一个例子，为“com.demo.test”包指定日志输出器“test”，“com.demo.test”包下所有类的日志都将输出到/log/test.log文件
    ```shell
    log4j.logger.com.demo.test=DEBUG,test
    log4j.appender.test=org.apache.log4j.FileAppender
    log4j.appender.test.File=/log/test.log
    log4j.appender.test.layout=org.apache.log4j.PatternLayout
    log4j.appender.test.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
    ```
  * 也可以让同一个类输出不同的日志，为达到这个目的，需要在这个类中实例化两个logger

  ```shell
    private static Log logger1 = LogFactory.getLog("myTest1");
    private static Log logger2 = LogFactory.getLog("myTest2");
  ```

  * 然后分别配置

    ```shell
    log4j.logger.myTest1= DEBUG,test1
    log4j.additivity.myTest1=false
    log4j.appender.test1=org.apache.log4j.FileAppender
    log4j.appender.test1.File=/log/test1.log
    log4j.appender.test1.layout=org.apache.log4j.PatternLayout
    log4j.appender.test1.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n

    log4j.logger.myTest2=DEBUG,test2
    log4j.appender.test2=org.apache.log4j.FileAppender
    log4j.appender.test2.File=/log/test2.log
    log4j.appender.test2.layout=org.apache.log4j.PatternLayout
    log4j.appender.test2.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} [%p] %m%n
    ```

* slf4j与log4j联合使用

  * log4j.properties的配置文件不发生改变，只需添加jar

  ```shell
   <dependency>
     <groupId>org.slf4j</groupId>
     <artifactId>slf4j-api</artifactId>
     <version>1.7.21</version>
   </dependency>
   <dependency>
     <groupId>org.slf4j</groupId>
     <artifactId>slf4j-log4j12</artifactId>
     <version>1.7.21</version>
   </dependency>
  ```

  * 使用如下所示：

    ```java
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    class Test {
       Logger log = LoggerFactory.getLogger(Test.class);
       public void test() {
           log.info("hello, my name is {}", "chengyi");
       }
    }
    ```




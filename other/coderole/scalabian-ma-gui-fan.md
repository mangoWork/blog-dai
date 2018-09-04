\[toc\]

### Scala编码规范

#### 格式与命名

1\) 代码格式

```
用两个空格缩进。避免每行长度超过100列。在两个方法、类、对象定义之间使用一个空白行。
```

2\) 优先考虑使用val，而非var。

3\) 当引入多个包时，使用花括号：

```scala
import jxl.write.{WritableCell, Number, Label}
```

```
  当引入超过6个包的时候，应该使用通配符**\_**
```

```scala
import org.scalatest.events._
```

4）若方法暴露为接口，则返回类型应该显式声明。例如：

```scala
   def execute(conn: Connection): Boolean = {
      executeCommand(conn, sqlStatement) match {
        case Right(result) => result
        case Left(_) => false
      }
    }
```

5\) 集合的命名规范

```
  xs, ys, as, bs等作为某种Sequence对象的名称；

  x, y, z, a, b作为sequence元素的名称。

 h作为head的名称，t作为tail的名称。
```

6）避免对简单的表达式采用花括号

```scala
//suggestion
def square(x: Int) = x * x

//avoid
def square(x: Int) = {
     x * x
}
```

7\) 泛型类型参数的命名虽然没有限制，但建议遵循如下规则：

```
  A 代表一个简单的类型，例如List\[A\]  
  B, C, D 用于第2、第3、第4等类型。例如：
```

```scala
 class List[A] {
     def map[B](f: A => B): List[B] = …
}
```

N 代表数值类型

**注意：**在Java中，通常以K、V代表Map的key与value，但是在Scala中，更倾向于使用A、B代表Map的key与value。

## 编码风格 {#编码风格}

1\) 尽可能直接在函数定义的地方使用模式匹配。例如，在下面的写法中，match应该被折叠起来\(collapse\):

```scala
list map { item =>   
     item match {     
          case Some(x) => x     
          case None => default   
     } 
}

//用下面的写法替代
list map {
   case Some(x) => x
   case None => default 
}
```

```
    它很清晰的表达了 list中的元素都被映射，间接的方式让人不容易明白。此时，传入map的函数实则为partial function。
```

2）避免使用null，而应该使用Option的None。

```scala
import java.io._

object CopyBytes extends App {
     var in = None: Option[FileInputStream]
     var out = None: Option[FileOutputStream]
     try {
          in = Some(new FileInputStream("/tmp/Test.class"))
          out = Some(new FileOutputStream("/tmp/Test.class.copy"))
          var c = 0
          while ({c = in.get.read; c != −1}) {
             out.get.write(c)
    }
     } catch {
          case e: IOException => e.printStackTrace
     } finally {
          println("entered finally ...")
          if (in.isDefined) in.get.close
          if (out.isDefined) out.get.close
     }
}
```

```
  方法的返回值也要避免返回Null。应考虑返回Option，Either，或者Try。例如：
```

```scala
import scala.util.{Try, Success, Failure} 

def readTextFile(filename: String): Try[List[String]] = { 
    Try(io.Source.fromFile(filename).getLines.toList
)

val filename = "/etc/passwd" 
readTextFile(filename) match {
    case Success(lines) => lines.foreach(println)
    case Failure(f) => println(f) 
}
```

3）若在Class中需要定义常量，应将其定义为val，并将其放在该类的伴生对象中：

```scala
class Pizza (var crustSize: Int, var crustType: String) {
     def this(crustSize: Int) {
          this(crustSize, Pizza.DEFAULT_CRUST_TYPE)
     }

     def this(crustType: String) {
          this(Pizza.DEFAULT_CRUST_SIZE, crustType)
     }

     def this() {
          this(Pizza.DEFAULT_CRUST_SIZE, Pizza.DEFAULT_CRUST_TYPE)
     }
     override def toString = s"A $crustSize inch pizza with a $crustType crust"
}

object Pizza {
     val DEFAULT_CRUST_SIZE = 12
     val DEFAULT_CRUST_TYPE = "THIN"
}
```

4）合理为构造函数或方法提供默认值。例如：

```scala
class Socket (val timeout: Int = 10000)
```

5）如果需要返回多个值时，应返回tuple。

```scala
def getStockInfo = {
     //
     ("NFLX", 100.00, 101.00)
}
```

6\) 作为访问器的方法，如果没有副作用，在声明时建议定义为没有括号。

```scala
import scala.collection.immutable.Queue

val q = Queue(1, 2, 3, 4)
val value = q.dequeue
```

7\) 将包的公有代码（常量、枚举、类型定义、隐式转换等）放到package object中。

```scala
package com.agiledon.myapp

package object model {
     // field
     val MAGIC_NUM = 42 182 | Chapter 6: Objects
￼
     // method
     def echo(a: Any) { println(a) }

    // enumeration
     object Margin extends Enumeration {
          type Margin = Value
          val TOP, BOTTOM, LEFT, RIGHT = Value
     }

    // type definition
     type MutableMap[K, V] = scala.collection.mutable.Map[K, V]
     val MutableMap = scala.collection.mutable.Map
}
```

8\) 建议将package object放到与包对象命名空间一致的目录下，并命名为package.scala。以model为例，package.scala

文件应放在：

```scala
+– com 
+– agiledon 
+– myapp 
+– model 
+– package.scala
```

9\) 若有多个样例类属于同一类型，应共同继承自一个sealed trait。

```scala
sealed trait Message
case class GetCustomers extends Message
case class GetOrders extends Message
// 注：这里的sealed，表示trait的所有实现都必须声明在定义trait的文件中。
```

10\) 考虑使用renaming clause来简化代码。例如，替换被频繁使用的长名称方法：

```scala
import System.out.{println => p}

p("hallo scala")
p("input") 
```

11\) 在遍历Map对象或者Tuple的List时，且需要访问map的key和value值时，优先考虑采用Partial Function，而非使用\_1和\_2的形式。例如：

```scala
al dollar = Map("China" -> "CNY", "US" -> "DOL")

//perfer
dollar.foreach {
     case (country, currency) => println(s"$country -> $currency")
}

//avoid
dollar.foreach ( x => println(s"$x._1 -> $x._2") )
```

    或者，考虑使用for comprehension：

```scala
for ((country, currency) <- dollar) println(s"$country -> $currency")
```

12\) 遍历集合对象时，如果需要获得并操作集合对象的下标，不要使用如下方式：

```scala
val l = List("zero", "one", "two", "three")

for (i <- 0 until l.length) yield (i, l(i))
```

而应该使用zipWithIndex方法：

```scala
for ((number, index) <- l.zipWithIndex) yield (index, number)
// 或者
l.zipWithIndex.map(x => (x._2, x._1))
```




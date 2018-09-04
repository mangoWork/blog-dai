[toc]


### Scala编码规范

#### 格式与命名

1) 代码格式 

    用两个空格缩进。避免每行长度超过100列。在两个方法、类、对象定义之间使用一个空白行。

2) 优先考虑使用val，而非var。

3) 当引入多个包时，使用花括号：

```scala
import jxl.write.{WritableCell, Number, Label}
```

当引入超过6个包的时候，应该使用通配符**_**

```scala
import org.scalatest.events._
```




    

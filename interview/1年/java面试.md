# Java知识点

# 相关概念
## 面向对象的三个特征
封装,继承,多态

* 封装
  * 把客观事物封装成为抽象类，隐藏自己的内部实现
* 继承
  * 重用父类的代码
* 多态
  * 指不同的对象对于同一消息做出不同的相应。

## 多态的好处
允许不同类对象对同一消息做出响应,即同一消息可以根据发送对象的不同而采用多种不同的行为方式(发送消息就是函数调用).主要有以下优点:

1. 可替换性:多态对已存在代码具有可替换性.
2. 可扩充性:增加新的子类不影响已经存在的类结构.
3. 接口性:多态是超类通过方法签名,向子类提供一个公共接口,由子类来完善或者重写它来实现的.
4. 灵活性:
5. 简化性:

### 代码中如何实现多态
实现多态主要有以下三种方式:
1. 接口实现
2. 继承父类重写方法
3. 同一类中进行方法重载

### 虚拟机是如何实现多态的
动态绑定技术(dynamic binding),执行期间判断所引用对象的实际类型,根据实际类型调用对应的方法.


## 接口的意义
接口的意义用三个词就可以概括:规范,扩展,回调.
## 抽象类的意义
抽象类的意义可以用三句话来概括:

    1. 为其他子类提供一个公共的类型
    2. 封装子类中重复定义的内容
    3. 定义抽象方法,子类虽然有不同的实现,但是定义时一致的

## 接口和抽象类的区别

| 比较     | 抽象类                                      | 接口                                  |
| ------ | ---------------------------------------- | ----------------------------------- |
| 默认方法   | 抽象类可以有默认的方法实现                            | ,java 8之前,接口中不存在方法的实现.              |
| 实现方式   | 子类使用extends关键字来继承抽象类.如果子类不是抽象类,子类需要提供抽象类中所声明方法的实现. | 子类使用implements来实现接口,需要提供接口中所有声明的实现. |
| 构造器    | 抽象类中可以有构造器                               | 接口中不能                               |
| 和正常类区别 | 抽象类不能被实例化                                | 接口则是完全不同的类型                         |
| 访问修饰符  | 抽象方法可以有public,protected和default等修饰       | 接口默认是public,不能使用其他修饰符               |
| 多继承    | 一个子类只能存在一个父类                             | 一个子类可以存在多个接口                        |
| 添加新方法  | 想抽象类中添加新方法,可以提供默认的实现,因此可以不修改子类现有的代码      | 如果往接口中添加新方法,则子类中需要实现该方法.            |
## 父类的静态方法能否被子类重写
不能.重写只适用于实例方法,不能用于静态方法,而子类当中含有和父类相同签名的静态方法,我们一般称之为隐藏.

## 什么是不可变对象
不可变对象指对象一旦被创建，状态就不能再改变。任何修改都会创建一个新的对象，如 String、Integer及其它包装类。

## 静态变量和实例变量的区别?
静态变量存储在方法区,属于类所有.实例变量存储在堆当中,其引用存在当前线程栈.


## 能否创建一个包含可变对象的不可变对象?
当然可以创建一个包含可变对象的不可变对象的，你只需要谨慎一点，不要共享可变对象的引用就可以了，如果需要变化时，就返回原对象的一个拷贝。最常见的例子就是对象中包含一个日期对象的引用.

## java 创建对象的几种方式
1. 采用new
2. 通过反射
3. 采用clone
4. 通过序列化机制

前2者都需要显式地调用构造方法.   造成耦合性最高的恰好是第一种,因此你发现无论什么框架,只要涉及到解耦必先减少new的使用.


## switch中能否使用string做参数
在idk 1.7之前,switch只能支持byte,short,char,int或者其对应的封装类以及Enum类型。从idk 1.7之后switch开始支持String.

## switch能否作用在byte,long上? 
可以用在byte上,但是不能用在long上.

## String对象

### 你对String对象的intern()熟悉么?

 intern()方法会首先从常量池中查找是否存在该常量值,如果常量池中不存在则现在常量池中创建,如果已经存在则直接返回.
 比如
 String s1="aa";
 String s2=s1.intern();
 System.out.print(s1==s2);//返回true

### String类初始化后是不可变的

* String使用private final char value[]来实现字符串的存储，也就是说String对象创建之后，就不能修改次对象中存储的字符串内容，就是因为如此，String才是不可变的。当使用String的replace等方法修改时，将会创建一个新的对象来实现，而不是对元对象进行修改。

  ![](../img/java/string-edit.png)

### 引用变量与对象

* A aa；
* 这个语句声明了类A的引用变量[也叫句柄]，而对象一般通过new 来创建，所以aa只是一个引用变量，而不是对象。

### 创建字符串的方式

* 创建字符串可以分为：
  * 使用""引号创建字符串
  * 使用new关键字创建字符串
* 总结：
  * 使用”“引号创建的字符串都是常量，编译期间就已经存储在`字符串常量池`中。
  * 使用new创建对象的时候对象存储在堆（heap）中，是运行期创建的。
    * new创建字符串时首先查看池中是否有相同值的字符串，如果有，则拷贝一份到堆中，然后返回堆中的地址；如果池中没有，则在堆中创建一份，然后返回堆中的地址（注意，此时不需要从堆中复制到池中，否则，将使得堆中的字符串永远是池中的子集，导致浪费池的空间）！
  * 使用只包含常量的字符串连接符如"aa" + "aa"创建的也是常量,编译期就能确定,已经确定存储到String Pool中；
  * 使用包含变量的字符串连接符如"aa" + s1创建的对象是运行期才创建的,存储在heap中；


###  使用String不一定创建对象

* 在执行到双引号包含字符串的时候，如String a = “we”，JVM会先到常量池中查找，如果有的话，返回常量池的这个实例中的引用，否则的话创建一个新实例并放在常量池中。

### 使用new String一定创建对象

* 在执行String a = new String("123")的时候，首先走常量池中取得一个实例的引用，然后在堆上面创建一个新的String实例，走以下构造函数给value属性赋值，然后把实例引用赋值给a。

### 关于String.intern()

* intern方法使用：一个初始为空的字符串，它由类String独自维护。当调用intern方法时，如果常量池中已经包含了等于此对象的字符串，则返回池中的字符串。否则，将此String对象添加到池中，并返回此String对象的引用。
* 它遵循以下规则：对于任意两个字符串 s 和 t，当且仅当 **s.equals(t)** 为 true 时，s.intern() == t.intern() 才为 true。

### 关于equals和==

* 对于==，如果作用于基本数据类型的变量，则比较其存储的“值”是否想等；如果作用域引用变量，则比较的是所指向的对象地址（是否指向同一地址）
* equals方法是基类Object中的方法，因此对于所有的继承于Object的类都会有该方法。在Object类中，equals方法是用来比较两个对象的引用是否相等，即是否指向同一个对象。
* 对于equals方法，注意：equals方法不能作用于基本数据类型的变量。如果没有对equals方法进行重写，则比较的是引用类型的变量所指向的对象的地址；而String类对equals方法进行了重写，用来比较指向的字符串对象所存储的字符串是否相等。其他的一些类诸如Double，Date，Integer等，都对equals方法进行了重写用来比较指向的对象所存储的内容是否相等。

### String中的+

* String中使用 + 字符串连接符进行字符串连接时，连接操作最开始时如果都是字符串常量，编译后将尽可能多的直接将字符串常量连接起来，形成新的字符串常量参与后续连接（通过反编译工具jd-gui也可以方便的直接看出）；

* 接下来的字符串连接是从左向右依次进行，对于不同的字符串，首先以最左边的字符串为参数创建StringBuilder对象，然后依次对右边进行append操作，最后将StringBuilder对象通过toString()方法转换成String对象（注意：中间的多个字符串常量不会自动拼接）。

  也就是说**String c = "xx" + "yy " + a + "zz" + "mm" + b; 实质上的实现过程是： String c = new StringBuilder("xxyy").append(a).append("zz").append("mm").append(b).toString();**

### String、StringBuffer、StringBuilder

* 可变与不可变：String是**不可变字符串对象**，StringBuilder和StringBuffer是**可变字符串对象**（其内部的字符数组长度可变）。
* 是否多线程安全：String中的对象是不可变的，也就可以理解为常量，显然**线程安全**。StringBuffer 与 StringBuilder 中的方法和功能完全是等价的，只是StringBuffer 中的方法大都采用了synchronized 关键字进行修饰，因此是**线程安全**的，而 StringBuilder 没有这个修饰，可以被认为是**非线程安全**的。
* String、StringBuilder、StringBuffer三者的执行效率：
  StringBuilder > StringBuffer > String 当然这个是相对的，不一定在所有情况下都是这样。比如String str = "hello"+ "world"的效率就比 StringBuilder st  = new StringBuilder().append("hello").append("world")要高。因此，这三个类是各有利弊，应当根据不同的情况来进行选择使用：
  * 当字符串相加操作或者改动较少的情况下，建议使用 String str="hello"这种形式；
  * 当字符串相加操作较多的情况下，建议使用StringBuilder，如果采用了多线程，则使用StringBuffer。

### **关于String str = new String("abc")创建了多少个对象？**

* 在**类加载的过程**中，确实在运行时常量池中创建了一个"abc"对象，而在**代码执行过程中**确实只创建了一个String对象。

### String s1="ab",String s2="a"+"b",String s3="a",String s4="b",s5=s3+s4请问s5==s2返回什么?

 返回false.在编译过程中,编译器会将s2直接优化为"ab",会将其放置在常量池当中,s5则是被创建在堆区,相当于s5=new String("ab");

----------


## Object中有哪些公共方法?
1. `equals()`
2. `clone()`
3. `getClass()`
4. `notify(),notifyAll(),wait()`
5. `toString`


## java当中的四种引用
强引用,软引用,弱引用,虚引用.不同的引用类型主要体现在GC上:

    1. 强引用：如果一个对象具有强引用，它就不会被垃圾回收器回收。即使当前内存空间不足，JVM也不会回收它，而是抛出 OutOfMemoryError 错误，使程序异常终止。如果想中断强引用和某个对象之间的关联，可以显式地将引用赋值为null，这样一来的话，JVM在合适的时间就会回收该对象
    2. 软引用：在使用软引用时，如果内存的空间足够，软引用就能继续被使用，而不会被垃圾回收器回收，只有在内存不足时，软引用才会被垃圾回收器回收。
    3. 弱引用：具有弱引用的对象拥有的生命周期更短暂。因为当 JVM 进行垃圾回收，一旦发现弱引用对象，无论当前内存空间是否充足，都会将弱引用回收。不过由于垃圾回收器是一个优先级较低的线程，所以并不一定能迅速发现弱引用对象
    4. 虚引用：顾名思义，就是形同虚设，如果一个对象仅持有虚引用，那么它相当于没有引用，在任何时候都可能被垃圾回收器回收。

更多了解参见[深入对象引用](http://blog.csdn.net/dd864140130/article/details/49885811)


## WeakReference与SoftReference的区别?
这点在四种引用类型中已经做了解释,这里简单说明一下即可:
虽然 WeakReference 与 SoftReference 都有利于提高 GC 和 内存的效率，但是 WeakReference ，一旦失去最后一个强引用，就会被 GC 回收，而软引用虽然不能阻止被回收，但是可以延迟到 JVM 内存不足的时候。

## 为什么要有不同的引用类型
不像C语言,我们可以控制内存的申请和释放,在Java中有时候我们需要适当的控制对象被回收的时机,因此就诞生了不同的引用类型,可以说不同的引用类型实则是对GC回收时机不可控的妥协.有以下几个使用场景可以充分的说明:

    1. 利用软引用和弱引用解决OOM问题：用一个HashMap来保存图片的路径和相应图片对象关联的软引用之间的映射关系，在内存不足时，JVM会自动回收这些缓存图片对象所占用的空间，从而有效地避免了OOM的问题.
    2. 通过软引用实现Java对象的高速缓存:比如我们创建了一Person的类，如果每次需要查询一个人的信息,哪怕是几秒中之前刚刚查询过的，都要重新构建一个实例，这将引起大量Person对象的消耗,并且由于这些对象的生命周期相对较短,会引起多次GC影响性能。此时,通过软引用和 HashMap 的结合可以构建高速缓存,提供性能.


## java中==和`eqauls()`的区别,`equals()`和`hashcode的区别
==是运算符,用于比较两个变量是否相等,而equals是Object类的方法,用于比较两个对象是否相等.默认Object类的equals方法是比较两个对象的地址,此时和==的结果一样.换句话说:基本类型比较用==,比较的是他们的值.默认下,对象用==比较时,比较的是内存地址,如果需要比较对象内容,需要重写equal方法
## `equals()`和`hashcode()`的联系
`hashCode()`是Object类的一个方法,返回一个哈希值.如果两个对象根据equal()方法比较相等,那么调用这两个对象中任意一个对象的hashCode()方法必须产生相同的哈希值.
如果两个对象根据eqaul()方法比较不相等,那么产生的哈希值不一定相等(碰撞的情况下还是会相等的.)

## a.hashCode()有什么用?与a.equals(b)有什么关系
hashCode() 方法是相应对象整型的 hash 值。它常用于基于 hash 的集合类，如 Hashtable、HashMap、LinkedHashMap等等。它与 equals() 方法关系特别紧密。根据 Java 规范，使用 equal() 方法来判断两个相等的对象，必须具有相同的 hashcode。

将对象放入到集合中时,首先判断要放入对象的hashcode是否已经在集合中存在,不存在则直接放入集合.如果hashcode相等,然后通过equal()方法判断要放入对象与集合中的任意对象是否相等:如果equal()判断不相等,直接将该元素放入集合中,否则不放入.

## 有没有可能两个不相等的对象有相同的hashcode
有可能，两个不相等的对象可能会有相同的 hashcode 值，这就是为什么在 hashmap 中会有冲突。如果两个对象相等，必须有相同的hashcode 值，反之不成立.


## 可以在hashcode中使用随机数字吗?
不行，因为同一对象的 hashcode 值必须是相同的

## a==b与a.equals(b)有什么区别
如果a 和b 都是对象，则 a==b 是比较两个对象的引用，只有当 a 和 b 指向的是堆中的同一个对象才会返回 true，而 a.equals(b) 是进行逻辑比较，所以通常需要重写该方法来提供逻辑一致性的比较。例如，String 类重写 equals() 方法，所以可以用于两个不同对象，但是包含的字母相同的比较。

##  `3*0.1==0.3`返回值是什么
false，因为有些浮点数不能完全精确的表示出来。(3*0.1为double类型)

## a=a+b与a+=b有什么区别吗?
+=操作符会进行隐式自动类型转换,此处a+=b隐式的将加操作的结果类型强制转换为持有结果的类型,而a=a+b则不会自动进行类型转换.如：
byte a = 127;
byte b = 127;
b = a + b; // error : cannot convert from int to byte
b += a; // ok
（译者注：这个地方应该表述的有误，其实无论 a+b 的值为多少，编译器都会报错，因为 a+b 操作会将 a、b 提升为 int 类型，所以将 int 类型赋值给 byte 就会编译出错）

## short s1= 1; s1 = s1 + 1; 该段代码是否有错,有的话怎么改？
有错误,short类型在进行运算时会自动提升为int类型,也就是说`s1+1`的运算结果是int类型.
## short s1= 1; s1 += 1; 该段代码是否有错,有的话怎么改？
+=操作符会自动对右边的表达式结果强转匹配左边的数据类型,所以没错.

## & 和 &&的区别
首先记住&是位操作,而&&是逻辑运算符.另外需要记住逻辑运算符具有短路特性,而&不具备短路特性.
```java
public class Test{
    static String name;

    public static void main(String[] args){
        if(name!=null&userName.equals("")){
            System.out.println("ok");
        }else{
            System.out.println("erro");
        }
    }
}
```

以上代码将会抛出空指针异常.

## 一个.java文件内部可以有类?(非内部类)
只能有一个public公共类,但是可以有多个default修饰的类.

## 如何正确的退出多层嵌套循环.
1. 使用标号和break;
2. 通过在外层循环中添加标识符

## 内部类的作用
内部类可以有多个实例,每个实例都有自己的状态信息,并且与其他外围对象的信息相互独立.在单个外围类当中,可以让多个内部类以不同的方式实现同一接口,或者继承同一个类.创建内部类对象的时刻不依赖于外部类对象的创建.内部类并没有令人疑惑的”is-a”关系,它就像是一个独立的实体.

内部类提供了更好的封装,除了该外围类,其他类都不能访问


## final,finalize和finally的不同之处
final 是一个修饰符，可以修饰变量、方法和类。如果 final 修饰变量，意味着该变量的值在初始化后不能被改变。finalize 方法是在对象被回收之前调用的方法，给对象自己最后一个复活的机会，但是什么时候调用 finalize 没有保证。finally 是一个关键字，与 try 和 catch 一起用于异常的处理。finally 块一定会被执行，无论在 try 块中是否有发生异常。

## clone()是哪个类的方法?
java.lang.Cloneable 是一个标示性接口，不包含任何方法，clone 方法在 object 类中定义。并且需要知道 clone() 方法是一个本地方法，这意味着它是由 c 或 c++ 或 其他本地语言实现的。

## 深拷贝和浅拷贝的区别是什么?
浅拷贝：被复制对象的所有变量都含有与原来的对象相同的值，而所有的对其他对象的引用仍然指向原来的对象。换言之，浅拷贝仅仅复制所考虑的对象，而不复制它所引用的对象。

深拷贝：被复制对象的所有变量都含有与原来的对象相同的值，而那些引用其他对象的变量将指向被复制过的新对象，而不再是原有的那些被引用的对象。换言之，深拷贝把要复制的对象所引用的对象都复制了一遍。

## static都有哪些用法?
几乎所有的人都知道static关键字这两个基本的用法:静态变量和静态方法.也就是被static所修饰的变量/方法都属于类的静态资源,类实例所共享.

除了静态变量和静态方法之外,static也用于静态块,多用于初始化操作:
```java
public class PreCache{
    static{
        //执行相关操作
    }
}
```
此外static也多用于修饰内部类,此时称之为静态内部类.

最后一种用法就是静态导包,即`import static`.import static是在JDK 1.5之后引入的新特性,可以用来指定导入某个类中的静态资源,并且不需要使用类名.资源名,可以直接使用资源名,比如:
```java
import static java.lang.Math.*;

public class Test{

    public static void main(String[] args){
        //System.out.println(Math.sin(20));传统做法
        System.out.println(sin(20));
    }
}
```

## final有哪些用法
final也是很多面试喜欢问的地方,能回答下以下三点就不错了:
1.被final修饰的类不可以被继承
2.被final修饰的方法不可以被重写
3.被final修饰的变量不可以被改变.如果修饰引用,那么表示引用不可变,引用指向的内容可变.
4.被final修饰的方法,JVM会尝试将其内联,以提高运行效率
5.被final修饰的常量,在编译阶段会存入常量池中.

回答出编译器对final域要遵守的两个重排序规则更好:
1.在构造函数内对一个final域的写入,与随后把这个被构造对象的引用赋值给一个引用变量,这两个操作之间不能重排序.
2.初次读一个包含final域的对象的引用,与随后初次读这个final域,这两个操作之间不能重排序.



----------


# 数据类型相关
## java中int char,long各占多少字节?

| 类型    | 位数   | 字节数  |
| ----- | ---- | ---- |
| short | 2    | 16   |
| int   | 4    | 32   |
| long  | 8    | 64   |
| float|4|32|
|double|8|64|
|char|2|16|

## 64位的JVM当中,int的长度是多少?
Java 中，int 类型变量的长度是一个固定值，与平台无关，都是 32 位。意思就是说，在 32 位 和 64 位 的Java 虚拟机中，int 类型的长度是相同的。

## int和Integer的区别
Integer是int的包装类型,在拆箱和装箱中,二者自动转换.int是基本类型，直接存数值，而integer是对象，用一个引用指向这个对象.

## int 和Integer谁占用的内存更多?
Integer 对象会占用更多的内存。Integer是一个对象，需要存储对象的元数据。但是 int 是一个原始类型的数据，所以占用的空间更少。

## 装箱和拆箱的实现过程

* 装箱的过程是通过调用包装器的valueOf实现的，而拆箱的过程是通过调用包装器的xxxValue方法实现的（xxx代表的是对应的基本数据类型）

## String,StringBuffer和StringBuilder区别
String是字符串常量,final修饰;StringBuffer字符串变量(线程安全);
StringBuilder 字符串变量(线程不安全).


### String和StringBuffer
String和StringBuffer主要区别是性能:String是不可变对象,每次对String类型进行操作都等同于产生了一个新的String对象,然后指向新的String对象.所以尽量不在对String进行大量的拼接操作,否则会产生很多临时对象,导致GC开始工作,影响系统性能.

StringBuffer是对对象本身操作,而不是产生新的对象,因此在有大量拼接的情况下,我们建议使用StringBuffer.

但是需要注意现在JVM会对String拼接做一定的优化:
`String s=“This is only ”+”simple”+”test”`会被虚拟机直接优化成`String s=“This is only simple test”`,此时就不存在拼接过程.

### StringBuffer和StringBuilder
StringBuffer是线程安全的可变字符串,其内部实现是可变数组.StringBuilder是jdk 1.5新增的,其功能和StringBuffer类似,但是非线程安全.因此,在没有多线程问题的前提下,使用StringBuilder会取得更好的性能.

## 什么是编译器常量?使用它有什么风险?
公共静态不可变（public static final ）变量也就是我们所说的编译期常量，这里的 public 可选的。实际上这些变量在编译时会被替换掉，因为编译器知道这些变量的值，并且知道这些变量在运行时不能改变。这种方式存在的一个问题是你使用了一个内部的或第三方库中的公有编译时常量，但是这个值后面被其他人改变了，但是你的客户端仍然在使用老的值，甚至你已经部署了一个新的jar。为了避免这种情况，当你在更新依赖 JAR 文件时，确保重新编译你的程序。
## java当中使用什么类型表示价格比较好?
如果不是特别关心内存和性能的话，使用BigDecimal，否则使用预定义精度的 double 类型。

## 如何将byte转为String
可以使用 String 接收 byte[] 参数的构造器来进行转换，需要注意的点是要使用的正确的编码，否则会使用平台默认编码，这个编码可能跟原来的编码相同，也可能不同。


## 可以将int强转为byte类型么?会产生什么问题?
我们可以做强制转换，但是Java中int是32位的而byte是8 位的，所以,如果强制转化int类型的高24位将会被丢弃，byte 类型的范围是从-128到128

----------

# 关于垃圾回收

## 如何判断一个对象是否应该被回收
这就是所谓的对象存活性判断,常用的方法有两种:1.引用计数法;2:对象可达性分析.由于引用计数法存在互相引用导致无法进行GC的问题,所以目前JVM虚拟机多使用对象可达性分析算法.

## 简单的解释一下垃圾回收
Java 垃圾回收机制最基本的做法是分代回收。内存中的区域被划分成不同的世代，对象根据其存活的时间被保存在对应世代的区域中。一般的划分为：年轻代和老年代。内存的分配是发生在年轻代中的。当一个对象存活时间足够长的时候，它就会被复制到年老代中。垃圾回收使用分代垃圾回收算法。




## 调用System.gc()会发生什么?
通知GC开始工作,但是GC真正开始的时间不确定.

----------
#关于集合

## Java中的集合及其继承关系
关于集合的体系是每个人都应该烂熟于心的,尤其是对我们经常使用的List,Map的原理更该如此.这里我们看这张图即可:
![这里写图片描述](../img/java/collections.png)

更多内容可见[集合类总结](http://write.blog.csdn.net/postedit/40826423)

## poll()方法和remove()方法区别?
poll() 和 remove() 都是从队列中取出一个元素，但是 poll() 在获取元素失败的时候会返回空，但是 remove() 失败的时候会抛出异常。

## LinkedHashMap和PriorityQueue的区别
PriorityQueue 是一个优先级队列,保证最高或者最低优先级的的元素总是在队列头部，但是 LinkedHashMap 维持的顺序是元素插入的顺序。当遍历一个 PriorityQueue 时，没有任何顺序保证，但是 LinkedHashMap 课保证遍历顺序是元素插入的顺序。

## WeakHashMap与HashMap的区别是什么?
WeakHashMap 的工作与正常的 HashMap 类似，但是使用弱引用作为 key，意思就是当 key 对象没有任何引用时，key/value 将会被回收。

## ArrayList和LinkedList的区别?
最明显的区别是 ArrrayList底层的数据结构是数组，支持随机访问，而 LinkedList 的底层数据结构是双向循环链表，不支持随机访问。使用下标访问一个元素，ArrayList 的时间复杂度是 O(1)，而 LinkedList 是 O(n)。

## ArrayList和Array有什么区别?
    1. Array可以容纳基本类型和对象，而ArrayList只能容纳对象。
    2. Array是指定大小的，而ArrayList大小是固定的

## ArrayList和HashMap默认大小?
在 Java 7 中，ArrayList 的默认大小是 10 个元素，HashMap 的默认大小是16个元素（必须是2的幂）。这就是 Java 7 中 ArrayList 和 HashMap 类的代码片段
```
private static final int DEFAULT_CAPACITY = 10;
 
 //from HashMap.java JDK 7
 static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
```

## Comparator和Comparable的区别?
Comparable 接口用于定义对象的自然顺序，而 comparator 通常用于定义用户定制的顺序。Comparable 总是只有一个，但是可以有多个 comparator 来定义对象的顺序。

## 如何实现集合排序?
你可以使用有序集合，如 TreeSet 或 TreeMap，你也可以使用有顺序的的集合，如 list，然后通过 Collections.sort() 来排序。

## 如何打印数组内容
你可以使用 Arrays.toString() 和 Arrays.deepToString() 方法来打印数组。由于数组没有实现 toString() 方法，所以如果将数组传递给 System.out.println() 方法，将无法打印出数组的内容，但是 Arrays.toString() 可以打印每个元素。

## LinkedList的是单向链表还是双向?
双向循环列表,具体实现自行查阅源码.

## TreeMap是实现原理
采用红黑树实现,具体实现自行查阅源码.

## 遍历ArrayList时如何正确移除一个元素
该问题的关键在于面试者使用的是 ArrayList 的 remove() 还是 Iterator 的 remove()方法。这有一段示例代码，是使用正确的方式来实现在遍历的过程中移除元素，而不会出现 ConcurrentModificationException 异常的示例代码。


## 什么是ArrayMap?它和HashMap有什么区别?
ArrayMap是Android SDK中提供的,非Android开发者可以略过.
ArrayMap是用两个数组来模拟map,更少的内存占用空间,更高的效率.
具体参考这篇文章:[ArrayMap VS HashMap](http://lvable.com/?p=217%5D)


## HashMap的实现原理
1   HashMap概述：  HashMap是基于哈希表的Map接口的非同步实现。此实现提供所有可选的映射操作，并允许使用null值和null键。此类不保证映射的顺序，特别是它不保证该顺序恒久不变。
2   HashMap的数据结构： 在java编程语言中，最基本的结构就是两种，一个是数组，另外一个是模拟指针（引用），所有的数据结构都可以用这两个基本结构来构造的，HashMap也不例外。HashMap实际上是一个“链表散列”的数据结构，即数组和链表的结合体。

当我们往Hashmap中put元素时,首先根据key的hashcode重新计算hash值,根绝hash值得到这个元素在数组中的位置(下标),如果该数组在该位置上已经存放了其他元素,那么在这个位置上的元素将以链表的形式存放,新加入的放在链头,最先加入的放入链尾.如果数组中该位置没有元素,就直接将该元素放到数组的该位置上.

需要注意Jdk 1.8中对HashMap的实现做了优化,当链表中的节点数据超过八个之后,该链表会转为红黑树来提高查询效率,从原来的O(n)到O(logn)




## 你了解Fail-Fast机制吗
Fail-Fast即我们常说的快速失败,更多内容参看[fail-fast机制](http://blog.csdn.net/chenssy/article/details/38151189)

* 产生Fail-Fast的原因在于程序对collection进行迭代的时候，某个线程对collection在结构上对其做了修改，这时，迭代器就会抛出ConcurrentModificationException异常，从而产生fail-fast。

## Fail-fast和Fail-safe有什么区别
Iterator的fail-fast属性与当前的集合共同起作用，因此它不会受到集合中任何改动的影响。Java.util包中的所有集合类都被设计为fail->fast的，而java.util.concurrent中的集合类都为fail-safe的。当检测到正在遍历的集合的结构被改变时，Fail-fast迭代器抛出ConcurrentModificationException，而fail-safe迭代器从不抛出ConcurrentModificationException。

----------


# 关于日期
## SimpleDateFormat是线程安全的吗?
非常不幸，DateFormat 的所有实现，包括 SimpleDateFormat 都不是线程安全的，因此你不应该在多线程序中使用，除非是在对外线程安全的环境中使用，如 将 SimpleDateFormat 限制在 ThreadLocal 中。如果你不这么做，在解析或者格式化日期的时候，可能会获取到一个不正确的结果。因此，从日期、时间处理的所有实践来说，我强力推荐 joda-time 库。

## 如何格式化日期?
Java 中，可以使用 SimpleDateFormat 类或者 joda-time 库来格式日期。DateFormat 类允许你使用多种流行的格式来格式化日期。参见答案中的示例代码，代码中演示了将日期格式化成不同的格式，如 dd-MM-yyyy 或 ddMMyyyy。



----------


# 关于异常
## 简单描述java异常体系
* Java语言将异常划分为两类：Error和Exception，如图所示：

![](../img/java/throw.png)

* Throwable：有两个重要的子类：Exception（异常）和Error（错误），两者都包含了大量的异常处理类。
* Error（错误）：是程序中无法处理的错误，表示运行应用程序中出现了严重的错误。此类错误一般表示代码运行时JVM出现问题。通常有Virtual MachineError（虚拟机运行错误）、NoClassDefFoundError（类定义错误）等。比如说当jvm耗完可用内存时，将出现OutOfMemoryError。此类错误发生时，JVM将终止线程。
* Exception（异常）：程序本身可以捕获并且可以处理的异常。
* 运行时异常(不受检异常)：RuntimeException类极其子类表示JVM在运行期间可能出现的错误。比如说试图使用空值对象的引用（NullPointerException）、数组下标越界（ArrayIndexOutBoundException）。此类异常属于不可查异常，一般是由程序逻辑错误引起的，在程序中可以选择捕获处理，也可以不处理。
* 编译异常(受检异常)：Exception中除RuntimeException极其子类之外的异常。如果程序中出现此类异常，比如说IOException，必须对该异常进行处理，否则编译不通过。在程序中，通常不会自定义该类异常，而是直接使用系统提供的异常类。

## throw和throws的区别
throw用于主动抛出java.lang.Throwable 类的一个实例化对象，意思是说你可以通过关键字 throw 抛出一个 Error 或者 一个Exception，如：`throw new IllegalArgumentException(“size must be multiple of 2″)`,
而throws 的作用是作为方法声明和签名的一部分，方法被抛出相应的异常以便调用者能处理。Java 中，任何未处理的受检查异常强制在 throws 子句中声明。

## 异常的继承

* 如果超类方法没有声明一个异常，子类覆盖方法不能声明checked exception(受检查异常)。
* 如果超类方法没有声明异常，子类覆盖方法不能声明checked exception，但可以声明unchecked exception（不受检查异常）
* 如果超类方法声明一个异常，子类重写方法可以声明相同的异常，子类异常或不声明异常，但不能声明其他异常

----------

## 关于序列化

## Java 中，Serializable 与 Externalizable 的区别
Serializable 接口是一个序列化 Java 类的接口，以便于它们可以在网络上传输或者可以将它们的状态保存在磁盘上，是 JVM 内嵌的默认序列化方式，成本高、脆弱而且不安全。Externalizable 允许你控制整个序列化过程，指定特定的二进制格式，增加安全机制。

----------

#关于JVM

## JVM特性
平台无关性.
Java语言的一个非常重要的特点就是与平台的无关性。而使用Java虚拟机是实现这一特点的关键。一般的高级语言如果要在不同的平台上运行，至少需要编译成不同的目标代码。而引入Java语言虚拟机后，Java语言在不同平台上运行时不需要重新编译。Java语言使用模式Java虚拟机屏蔽了与具体平台相关的信息，使得Java语言编译程序只需生成在Java虚拟机上运行的目标代码（字节码），就可以在多种平台上不加修改地运行。Java虚拟机在执行字节码时，把字节码解释成具体平台上的机器指令执行。

## 简单解释一下类加载器
有关类加载器一般会问你四种类加载器的应用场景以及双亲委派模型,更多的内容参看[深入理解JVM加载器](http://blog.csdn.net/dd864140130/article/details/49817357)

## 简述堆和栈的区别
VM 中堆和栈属于不同的内存区域，使用目的也不同。栈常用于保存方法帧和局部变量，而对象总是在堆上分配。栈通常都比堆小，也不会在多个线程之间共享，而堆被整个 JVM 的所有线程共享。

## 简述JVM内存分配

    1. 基本数据类型比变量和对象的引用都是在栈分配的
    2. 堆内存用来存放由new创建的对象和数组
    3. 类变量（static修饰的变量），程序在一加载的时候就在堆中为类变量分配内存，堆中的内存地址存放在栈中
    4. 实例变量：当你使用java关键字new的时候，系统在堆中开辟并不一定是连续的空间分配给变量，是根据零散的堆内存地址，通过哈希算法换算为一长串数字以表征这个变量在堆中的"物理位置”,实例变量的生命周期--当实例变量的引用丢失后，将被GC（垃圾回收器）列入可回收“名单”中，但并不是马上就释放堆中内存
    5. 局部变量: 由声明在某方法，或某代码段里（比如for循环），执行到它的时候在栈中开辟内存，当局部变量一但脱离作用域，内存立即释放


## 对象在内存中的布局、对象的创建、以及对象的访问

* **对象的内存布局**：
  * 对象在内存中的布局可以分为三块区域：对象头、实例数据、和对齐填充
  * 对象头包括两部分信息（如果是数组，则还有一部分用于记录数组长度的数据）：
    * 第一部分信息用于存储自身的运行时数据，比如哈希吗（HashCode）、GC分代年龄、锁状态标志、线程持有的锁、偏向线程的ID、偏向时间戳等等，这部分数据在32位和63位虚拟机中分别为32个和64个字节，官网称为“Mark Word”
    * 另一部分是类型指针，即是对象指向它的类的元数据指针。虚拟机通过这个指针来确定这个对象是那个类的实例。
* **对象的创建**：
  * 当虚拟机遇到new指令时，首先检查这个指令的参数能否在常量池中定位到这个类的符号引用，并检查这个类是否已经被加载、解析、初始化。如果没有则必须进行类的加载过程。
  * 为新生对象分配内存，通过指针碰撞或者空闲列表法。为了解决并发问题可以采用TLAB本地线程分配缓冲策略。
* **对象访问定位**：
  * 使用句柄和直接指针两种方式。（句柄：Object引用是一个句柄，其中包含一对指针，一个指针指向该object方法表，一个指向object的数据）

## JVM内存模型

* **内存模型**：内存模型描述了各个变量（实例域＼静态域和数组元素）之间的联系，以及在实际的计算机系统中将变量存储到内存以及从内存中取出变量这样的底层细节。
* **线程私有**：程序计数器、虚拟机栈、本地方法栈。
* **线程共享**：堆、方法区
* **虚拟机栈**：Java方法执行的内存模型，每一个Java方法在执行的时候都会创建一个栈帧用来存储局部变量表、操作数栈、动态链接、方法出口等信息。
  * **局部变量表**存放在编译期可知的基本类型和引用类型，局部变量所需你的内存空间在编译期间分配完成，运行期间不会改变大小。
  * **操作数栈**中存放指令执行时所需的操作数。
  * **动态链接：**每个栈帧中都包含一个该栈帧所属的方法引用。
  * **方法出口**：每一个方法结束无非是正常return或者抛出了Exception并没有catch语句，在方法执行完之后需要返回到方法调用的位置，返回时需要在栈帧中保存一些信息，用来恢复他的上层方法的执行状态。可能抛出StackOverflowError或者OutOfMemoryError
* **本地方法栈**：为native方法服务。可能抛出StackOverFlowError或OutOfMemoryError。
* **堆**：虚拟机管理内存中的最大的一块，在虚拟机启动的时候创建，用于存放实例和数组，从垃圾回收的角度分为新生代、老年代；在细分可以分为Eden、From Survivor、To Survivor空间、老年代。可能出现OutOfMemeryError。
* **方法区**：用来存储虚拟息、常量、静机加载的类的信态变量、即使编译后的代码数据。垃圾回收的对象为：常量池的回收和类型的卸载。可能出现OutOfMenoryError。

# 类的加载过程

* **以被初始化的六种情况：**
  * 创建类的实例
  * 访问某个类或者接口的静态变量，或者对该静态变量赋值
  * 调用类的静态方法
  * 反射，如（Class.ForName(“com.dai....”)）
  * 初始化一个类的子类
  * Java虚拟机启动时被标为启动的类
* 类的加载过程
  * 加载-->连接（验证-->准备-->解析）-->初始化
  * **加载**：类的加载时将类的.class文件中的二进制数据存放到内存中，将其存放在运行时数据区内，然后在堆区创建一个java.lang.Class对象，用来封装在方法中的数据结构。
  * **验证**：确保class文件中的字节流中的信息符合当前虚拟机的要求，包括：文件格式验证、元数据验证、字节码验证、符号引用验证。
  * **准备**:  为类变量分配内存，并设置类变量初始零值。
  * **解析**：将常量池中的符号引用替换为直接引用。这一阶段会根据实际的需求发生在初始化之前或之后，包含类或者接口的解析、字段解析、方法解析。（符号引用是无关虚拟机的内存布局。直接引用是和虚拟机相关的内存布局相关的。符号引用必须在运行期转换获得真正的入口地址）
  * **初始化**：执行clinit方法，该方法由编译器自动按书写顺序收集类中所有的类变量的赋值动作和静态语句块中的语句合并而成。
* 对象的创建的执行顺序：
  * 父类静态，子类静态、父类成员域、父类代码块、父类构造方法、子类成员域、子类代码块、子类构造方法

## 双亲委派模型

* 类加载器通过组合的方式建立的父子关系，称为双亲委派模型
* 类加载器：
  *  **Bootstrap ClassLoader**:负责加载JAVA_HOME/lib目录，或者被XboostrapPath参数所指定的路径指定的类库。
  *  **Extension ClassLoader**:负责加载JAVA_HOME/lib/ext目录，或者被java.ext.dir系统变量所指定的路径所指定的类库。
  *  **ApplicationClassLoader**：是ClassLoader.getSystemClassLoader()方法的返回值，负责架子啊用户类路径上所指定的类库。
* **工作过程**：
  * 一个类加载器收到类加载的请求，它首先不会尝试自己加载这个类而是把这个请求委托给父类去加载去完成。只有当父加载器反馈自己无法完成这个请求时，自加载器才会自己去加载。
* **作用**:
  *  Java随着它的类加载器一起具备了一种优先级的层级关系，比如Object这个类，无论哪个类加载器他最终都会委派到bootstrapClassLoader去加载。保证了Java程序的稳定执行。

## 静态分派与动态分派

* 静态分派
  *  依赖**静态类型**来定位方法执行版本的分派动作称为静态分派（根据静态参数来定位目标方法），典型的应用为overload。静态分派发生在编译阶段，因此静态分配的动作实际上不是由虚拟机执行的。
* 动态分派：
  *  根据运行期间**实际类型**来确定方法的引用，典型的应用为override。

## GC的两种判定方法

* **引用计数法**：在对象中添加一个引用计数器，每一个地方引用它值加1，当引用失效时减1。这种方法很难解决对象间互相循环的引用的问题。
* **可达性分析算法**:
  * 选一个对象为GC Roots,如果一个对象gc不可达，那么就回收。
  * 选作GC Roots对象包括下面几种：
    * 虚拟机栈中引用的对象；
    * 方法区类静态属性引用的对象；
    * 方法区常量引用对象；
    * 本地方法栈中引用的对象
  * 如果一个对象与GC ROOTS不可达时，将会被第一次标记并筛选判断是否有必要执行finalize()方法，有必要执行的进入F-QUEUE队列，稍后虚拟机将自动建立一个低优先级的线程去执行它。稍后虚拟机将进行二次标记：在finalize()方法中建立了与GC ROOTS的通路，仍然可以存活。

## Java的引用类型

* **强引用类型**：强引用类型就是平常使用的A a=new A();如果一个对象是强引用类型，垃圾回收器绝不会回收。当内存空间不足的时候宁愿抛出outofmemoryError是程序终止，也不会随意回收来解决对象内存不足的问题。

* **软引用类型**：如果一个对象只具有软引用，如果内存空间足够，垃圾回收器不会回收它；如果内存空间不足时，则回收它。一般用来缓存。使用软引用可以构建敏感数据的缓存.

  * 代码示列：

    ```java
    MyObject obj = new MyObject();  
    ReferenceQueue<MyObject> refQue = new ReferenceQueue<MyObject>();  // 使用ReferenceQueue清除失去了软引用对象的SoftReference
    SoftReference<MyObject> ref = new SoftReference<MyObject>(obj, refQue);  //SoftReference 软引用的对象  
    obj = null;// 清除对象的强引用
    Myobject obj1 = ref.get();// 如果在内存中没有被回收将会获得实例的引用，如果回收之后，调用get()方法就只能返回null
    ```

    ​

* **弱引用类型**：只具有弱引用的对象用友更短暂的生命周期。当垃圾回收器扫描内存区域的时候，如果发现了弱引用对象，不管内存空间是否足够，都会回收它的内存。如WeakHashMap,它的key被封装成弱引用，当强引用被删除的时候，弱引用占用的内存也会被回收。

* **虚引用类型**：虚引用并不会决定对象的生命周期，如果一个对象仅持有虚引用，那么它和没有任何引用一样，可以在任何时候被被垃圾回收器回收。

* 为什么需要使用软引用？

  * **如果能重新获取那些尚未被回收的Java对象的引用，必将减少不必要的访问，大大提高程序的运行速度**

## 堆里面的分区：Eden、Survival from to以及老年代的各自特点

* **Eden区**：
  *  位于Java堆新生代。（新生代中的寿命比较短）大多数情况下，对象由Eden区分配，如果启动了TLAB（本地线程分配缓冲），则优先在TLAB中分配。如果Eden区中的内存也是用完了，则引发一次Minor GC。
* **Survival区**：
  *  Survival区和Eden区相同都在Java堆的新生代。Survival有两块区：一块是**Survival to区**，另外一块是**Survival from区**。这两个区是相对的，在发生一次Minor GC时，from区会和to区互换。在发生Mimor GC时，Survival to区会把一些存活的对象移至老年代，Eden区和Survival from 区会把一些存活的对象复制进Survival to区，并清除内存。
* **老年代**：
  *  老年代存放的都是存活比较久，大小比较大的对象，因此老年代使用标记整理算法。当老年代容量满时，会触发一次Major GC（full GC），回收老年代和新生代中不在使用的对象。

## **常用的三种垃圾回收算法（标记清除，标记整理，复制算法）**：

* **标记清除**：
  * 标记清除算法分为两个步骤执行： 1.暂停用户线程，通过GC Roots可达性分析算法标记对象。2.清除未被标记的垃圾对象。
  * 缺点：
    * 效率低，需要暂停用户的线程。
    * 清除垃圾对象后内存不连续，存在较多的内存碎片。（这种算法使用比较少了）
* **复制算法**：
  * 赋值算法也分两步执行，在复制算法中一般会有至少两片的内存空间（一片是活动空间，里面存放各种对象，另一片是空闲空间，里面是空的）：
    *  暂停用户线程，标记活动空间的存活对象。
    *  把活动空间中存活对象复制到空闲空间中，清除活动空间。
  * 复制算法相比于标记清除发的优势在与内存是连续的。
  * 缺点：
    * 需要浪费一定的内存空间作为空闲空间。
    * 如果对象的存活率很高，需要复制大量的对象，则会导致效率低下。
  * 复制算法一般用于新生代Minor GC，主要因为新生代对象存活率较低。
* **标记整理**：
  * 标记整理算法是标记清除算法的改进，分为标记，整理两步：
    * .暂停用户线程，标记所有存活的对象
    * 移动所有存活的对象，按内存地址一次排序，回收末端以后的内存空间
  * 标记整理法与标记清除法相比，整理出的**内存是连续的**；而与复制法相比不需要多片内存空间。
  * 缺点：
    * 然而标记整理法的第二部比较繁琐，需要整理存活的引用地址，理论上说是效率低于复制法，因此用于Major GC(full GC)

## **Minor GC和full GC触发的机制**

* **Minor GC(**新生代GC)：
  * 大多数情况，对象在新生代Eden区中分配，当Eden区中没有足够的空间，虚拟机触发一次Minor   GC。Minor GC非常频繁、速度快。
* **Full GC**（老年代GC）：
  * 在Minor GC之前会先检查老年代中最大可用连续空间是否大于新生代中的对象，如果成立，则这次Minor GC是安全的。否则就要查看是否允许担保失败，如果不允许则改为进行Full GC,允许的话就尝试进行一次Minor GC；
  * 此外当年老代容量满的时候，也会触发一次full GC

-------

# 其他

## java当中采用的是大端还是小端?

## XML解析的几种方式和特点
DOM,SAX,PULL三种解析方式:

 - DOM:消耗内存：先把xml文档都读到内存中，然后再用DOM API来访问树形结构，并获取数据。这个写起来很简单，但是很消耗内存。要是数据过大，手机不够牛逼，可能手机直接死机
 - SAX:解析效率高，占用内存少，基于事件驱动的：更加简单地说就是对文档进行顺序扫描，当扫描到文档(document)开始与结束、元素(element)开始与结束、文档(document)结束等地方时通知事件处理函数，由事件处理函数做相应动作，然后继续同样的扫描，直至文档结束。
 - PULL:与 SAX 类似，也是基于事件驱动，我们可以调用它的next（）方法，来获取下一个解析事件（就是开始文档，结束文档，开始标签，结束标签），当处于某个元素时可以调用XmlPullParser的getAttributte()方法来获取属性的值，也可调用它的nextText()获取本节点的值。



## JDK 1.7特性
然 JDK 1.7 不像 JDK 5 和 8 一样的大版本，但是，还是有很多新的特性，如 try-with-resource 语句，这样你在使用流或者资源的时候，就不需要手动关闭，Java 会自动关闭。Fork-Join 池某种程度上实现 Java 版的 Map-reduce。允许 Switch 中有 String 变量和文本。菱形操作符(\<\>)用于类型推断，不再需要在变量声明的右边申明泛型，因此可以写出可读写更强、更简洁的代码
## JDK 1.8特性
java 8 在 Java 历史上是一个开创新的版本，下面 JDK 8 中 5 个主要的特性：
Lambda 表达式，允许像对象一样传递匿名函数
Stream API，充分利用现代多核 CPU，可以写出很简洁的代码
Date 与 Time API，最终，有一个稳定、简单的日期和时间库可供你使用
扩展方法，现在，接口中可以有静态、默认方法。
重复注解，现在你可以将相同的注解在同一类型上使用多次。

## Maven和ANT有什么区别?
虽然两者都是构建工具，都用于创建 Java 应用，但是 Maven 做的事情更多，在基于“约定优于配置”的概念下，提供标准的Java 项目结构，同时能为应用自动管理依赖（应用中所依赖的 JAR 文件.

## JDBC最佳实践
 - 优先使用批量操作来插入和更新数据
 - 使用PreparedStatement来避免SQL漏洞
 - 使用数据连接池
 - 通过列名来获取结果集

## IO操作最佳实践
1. 使用有缓冲的IO类,不要单独读取字节或字符
2. 使用NIO和NIO 2或者AIO,而非BIO
3. 在finally中关闭流
4. 使用内存映射文件获取更快的IO
















































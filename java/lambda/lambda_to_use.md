## 1. 基本的语法说明

* lambda表达式非常简单，结构类似如下结构

  ```java
  (parameters) -> expression
  //或者
  (parameters) -> { statements; }
  ```

* lambda表达式组成部分

  * paramaters：类似于方法中的形参列表，这里的参数是函数式接口里面的参数，这里的参数类型可以明确的声明也可以不声明而由JVM隐含的推断1。另外只有一个推断类型的时候可以省略括号。
  * ->:可以理解为“被用于”的意思
  * 方法体：可以是表达式也可以是代码块，是函数接口里方法的实现。代码块可以返回一个值也可以不返回，这里的代码块等同于方法的方法体。如果是表达式，也可以返回一个值，也可以不返回。

* 示列的代码：

  ```JAVA
  //示例2：接受两个int类型的参数，并返回这两个参数相加的和
  (int x,int y)->x+y;

  //示例2：接受x,y两个参数，该参数的类型由JVM根据上下文推断出来，并返回两个参数的和
  (x,y)->x+y;

  //示例3：接受一个字符串，并将该字符串打印到控制到，不反回结果
  (String name)->System.out.println(name);

  //示例4：接受一个推断类型的参数name，并将该字符串打印到控制台
  name->System.out.println(name);

  //示例5：接受两个String类型参数，并分别输出，不反回
  (String name,String sex)->{System.out.println(name);System.out.println(sex)}

  //示例6：接受一个参数x，并返回该该参数的两倍
  x->2*x
  ```

  ​

##2. 方法引用

* 方法引用是lambda表达式的一个简化写法。所引用的方法其实是lanbda表达式的方法体的实现，其语法结构为：

  ```java
  ObjectRef::methodName
  ```

  * 左边可以是类名或者实例名，中间是方法的引用符号“::”,右边是相应的方法名。方法引用分为三类：

### 2.1 静态方法引用

* 代码如下所示：

  ```java
  public class ReferenceTest {
      public static void main(String[] args) {
          Converter<String ,Integer> converter=new Converter<String, Integer>() {
              @Override
              public Integer convert(String from) {
                  return ReferenceTest.String2Int(from);
              }
          };
          converter.convert("120");
      }


      @FunctionalInterface
      interface Converter<F,T>{
          T convert(F from);
      }

      static int String2Int(String from) {
          return Integer.valueOf(from);
      }
  }
  ```

* 方法的调用代码

  ```java
  Converter<String, Integer> converter = ReferenceTest::String2Int;
   converter.convert("120");
  ```

### 2.2. 实例方法引用

* 代码如下所示：

  ```java
  public class ReferenceTest {
      public static void main(String[] args) {

          Converter<String, Integer> converter = new Converter<String, Integer>() {
              @Override
              public Integer convert(String from) {
                  return new Helper().String2Int(from);
              }
          };
          converter.convert("120");
      }

      @FunctionalInterface
      interface Converter<F, T> {
          T convert(F from);
      }

      static class Helper {
          public int String2Int(String from) {
              return Integer.valueOf(from);
          }
      }
  }
  ```

* 实例方法的引用如下所示：

  ```java
  Helper helper = new Helper();
  Converter<String, Integer> converter = helper::String2Int;
  converter.convert("120");
  ```

  ​

### 2.3 构造方法引用

* 代码如下所示：

  * 首先先定义一个父类Animal:

    ```java
    class Animal{
            private String name;
            private int age;

            public Animal(String name, int age) {
                this.name = name;
                this.age = age;
            }

           public void behavior(){

            }
        }
    ```

  * 接下来定义两个Animal的子类：Dog、Bird

    ```java
    public class Bird extends Animal {

        public Bird(String name, int age) {
            super(name, age);
        }

        @Override
        public void behavior() {
            System.out.println("fly");
        }
    }

    class Dog extends Animal {

        public Dog(String name, int age) {
            super(name, age);
        }

        @Override
        public void behavior() {
            System.out.println("run");
        }
    }
    ```

  * 随后定义一个工厂接口：

    ```java
    interface Factory<T extends Animal> {
    	T create(String name, int age);
    }
    ```

  * 接下来用传统的方法来创建Dog类和Bird类的对象：

    ```java
     Factory factory=new Factory() {
                @Override
                public Animal create(String name, int age) {
                    return new Dog(name,age);
                }
            };
            factory.create("alias", 3);
            factory=new Factory() {
                @Override
                public Animal create(String name, int age) {
                    return new Bird(name,age);
                }
            };
            factory.create("smook", 2);
    ```

  * 使用构造函数引用来创建：

    ```java
    Factory<Animal> dogFactory =Dog::new;
    Animal dog = dogFactory.create("alias", 4);

    Factory<Bird> birdFactory = Bird::new;
    Bird bird = birdFactory.create("smook", 3);
    ```

    ​

## 3. lambda的域以及访问限制

* 域即为作用域，Lambda表达式中参数在该lambda表达式范围内有效。在作用lambda表达式内，可以访问外部的变量：局部变量、类变量和静态变量。

### 3.1 访问局部变量

* 在lambda表达式外部的局部变量会被JVM隐式的编译成final类型，因此只能访问而不能修改。

  ```java
  public class ReferenceTest {
      public static void main(String[] args) {
          int n = 3;
          Calculate calculate = param -> {
              //n=10; 编译错误
              return n + param;
          };
          calculate.calculate(10);
      }

      @FunctionalInterface
      interface Calculate {
          int calculate(int value);
      }
  }
  ```

### 3.2 访问静态变量和成员变量

* 在lambda表达式内部，对静态变量和成员变量可读可写。

  ```java
  public class ReferenceTest {
      public int count = 1;
      public static int num = 2;
    
      public void test() {
          Calculate calculate = param -> {
              num = 10;//修改静态变量
              count = 3;//修改成员变量
              return n + param;
          };
          calculate.calculate(10);
      }

      public static void main(String[] args) {
      }

      @FunctionalInterface
      interface Calculate {
          int calculate(int value);
      }
  }
  ```

  ​

### 3.3 lambda不能访问函数接口的默认方法

* 在java8中，接口可以创建默认方法，但是在lambda表达式内部不支持访问默认方法。


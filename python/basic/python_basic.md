## 1. 基础数据类型
### 整数
* python可以处理任意大小的整数，当然包括负整数，写法为：1，100，-100

### 浮点数
* 浮点数也就是小数，表示方式为：0.98，-90.09

### 字符串
* 字符串是以单引号'或双引号"括起来的任意文本

### 布尔值
* 布尔值和布尔数值的表示一致，一个布尔值只有True、False两种值。布尔值可以使用and（与运算）、or（或运算）、not（非运算）运算。

### 空值
* 空值是python里的一个特殊的值，用None表示。

### 变量
* 变量可以是任意数据类型，变量名必须是大小英文、数字、和_的组合，不能用数字开头。如：a = 100;

* 静态类型与动态类型：

  * 静态类型需要在对应的变量前面指定对应的数据类型。

    ```python
    int a = 123;
    ```


## 2. list与tuple
### list
* list是一种数据类型的列表，是一种有序的集合，可以随时的添加以删除其中的元素，如：

  ```python
  classmates = ['dai','li','ming']　　#list集合<br>
  len(classmates)　　#list的长度<br>
  classmates.append('zhang')　　#在list最后添加元素<br>
  classmates.insert(1,'ok')　　#在位置1添加“ok”<br>
  classmates.pop()　　#删除list后面的元素<br>
  classmates.pop(i)　　#删除第i个元素<br>
  classmates[1] = 'Sarah'　　#修改位置1的的元素的值<br>
  L = ['Apple', 123, True]　　#list集合也可以有不同的数据类型
  ```

### tuple
* tuple是另外一种有序列表，也叫做元组。tuple和list非常相似，tuple一旦初始化了之后就不能修改，表示形式为：

  ```python
  classmates = ('dai','li','ming')
  t = ('a', 'b', ['A', 'B'])
  t[2][0] = 'X'
  t[2][1] = 'Y'#t为('a', 'b', ['X', 'Y'])
  ```

### dict（字典）与set
* python内置了字典，其他语言称之为map，使用key-value存储：如：

  ```python
  d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
  ```


* set和dict类似，也是一组key的集合，但是不能存储value。由于key不能重复，所以set中不能重复。如：

  ```python
  s = set([1, 2, 3])
  ```


## 3. 函数
* 函数的定义需要使用def语句，依次写出函数名、括号、括号中的参数以及冒号：,然后代码缩进块中编写函数体，函数的返回值使用return语句返回如下：

  ```python
  def my_abs(x):
  　　if x >= 0:
  　　　　return x
  　　else:<br>
  　　　　return -x
  ```


* 空函数：定义一个空函数需要使用pass语句。

* 函数还可以返回多个值，如下所示：

  ```python
  def move(x, y, step, angle=0):
  　　nx = x + step * math.cos(angle)
  　　ny = y - step * math.sin(angle)
  　　return nx, ny
   x, y = move(100, 100, 60, math.pi / 6)
  ```


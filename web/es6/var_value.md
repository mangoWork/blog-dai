## 1. 数组的解构赋值

* 什么是解构赋值？什么事解构？
  * 解构赋值可将数组的元素或对象的属性赋予给另一个变量
  * 从数组和对象中提取值，对变量进行赋值，这被称为解构

### 1.1 基本用法

* es6之前：

  ```javascript
  let a = 1;
  let b = 2;
  let c = 3;
  ```

* es6之后：

  ```javascript
  let [a, b, c] = [1, 2, 3];
  ```

  * 可以从数组中提取值，按照对应位置，对变量赋值。

    ```javascript
    let [foo, [[bar], baz]] = [1, [[2], 3]];
    foo // 1
    bar // 2
    baz // 3

    let [ , , third] = ["foo", "bar", "baz"];
    third // "baz"

    let [x, , y] = [1, 2, 3];
    x // 1
    y // 3

    let [head, ...tail] = [1, 2, 3, 4];
    head // 1
    tail // [2, 3, 4]

    let [x, y, ...z] = ['a'];
    x // "a"
    y // undefined
    z // []
    ```

* 如果解构不成功，变量的值就等于`undefined`。

## 2. 用途

### 2.1 **交换变量的值**

```javascript
let x = 1;
let y = 2;

[x, y] = [y, x];
```

### 2.2 从函数返回多个值

* 函数只能返回一个值，如果要返回多个值，只能将它们放在数组或对象里返回。有了解构赋值，取出这些值就非常方便。

  ```javascript
  // 返回一个数组

  function example() {
    return [1, 2, 3];
  }
  let [a, b, c] = example();

  // 返回一个对象

  function example() {
    return {
      foo: 1,
      bar: 2
    };
  }
  let { foo, bar } = example();
  ```

### 2.3 函数参数的定义

* 解构赋值可以方便地将一组参数与变量名对应起来。

  ```javascript
  // 参数是一组有次序的值
  function f([x, y, z]) { ... }
  f([1, 2, 3]);

  // 参数是一组无次序的值
  function f({x, y, z}) { ... }
  f({z: 3, y: 2, x: 1});
  ```

### 2.4 提取JSON数据

* 解构赋值对提取JSON对象中的数据，尤其有用。

  ```javascript
  let jsonData = {
    id: 42,
    status: "OK",
    data: [867, 5309]
  };

  let { id, status, data: number } = jsonData;

  console.log(id, status, number);
  // 42, "OK", [867, 5309]
  ```

  ​

### 2.5 函数参数的默认值

* ```javascript
  jQuery.ajax = function (url, {
    async = true,
    beforeSend = function () {},
    cache = true,
    complete = function () {},
    crossDomain = false,
    global = true,
    // ... more config
  }) {
    // ... do stuff
  };
  ```

### 2.6 遍历Map解构

* 任何部署了Iterator接口的对象，都可以用`for...of`循环遍历。Map结构原生支持Iterator接口，配合变量的解构赋值，获取键名和键值就非常方便。

  ```javascript
  var map = new Map();
  map.set('first', 'hello');
  map.set('second', 'world');

  for (let [key, value] of map) {
    console.log(key + " is " + value);
  }
  // first is hello
  // second is world
  ```



### 2.7 输入模块的指定方法

* 加载模块时，往往需要指定输入哪些方法。解构赋值使得输入语句非常清晰。

  ```javascript
  const { SourceMapConsumer, SourceNode } = require("source-map");
  ```

  ​


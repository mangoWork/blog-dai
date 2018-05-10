# et和const命令

## 1 let命令

### 1.1 基本用法

* ES6新增了let命令，用来声明变量。它的用法类似于`var`，但是let所声明的命令只有在let所在的代码块内有效。

  ```javascript
  {
    let a = 10;
    var b = 1;
  }

  a // ReferenceError: a is not defined.
  b // 1
  ```

* for循环的计数器，适合let命令

  ```javascript
  for (let i = 0; i < 10; i++) {
    // ...
  }
  console.log(i);
  // ReferenceError: i is not defined
  ```

* let声明的变量仅在块级作用域内有效

  ```javascript
  var a = [];
  for (let i = 0; i < 10; i++) {
    a[i] = function () {
      console.log(i);
    };
  }
  a[6](); // 6
  ```


* 不存在变量的提升

  * var命令会发生“变量提升”现象，即变量可以在声明之前使用，值为undefined。

  * 在let中不能先使用后声明，否则会报错。

    ```javascript
    // var 的情况
    console.log(foo); // 输出undefined
    var foo = 2;

    // let 的情况
    console.log(bar); // 报错ReferenceError
    let bar = 2;
    ```

### 1.2 暂时性死区

* 只要块级作用域内存在let命令，它所声明的变量就绑定这个区域，不再受到外部的影响。

  ```javascript
  var tmp = 123;
  if (true) {
    tmp = 'abc'; // ReferenceError
    let tmp;
  }
  ```

* 在上面的代码中，存在全局变量`tmp`，但是块级作用域内let又声明了一个局部变量tmp。导致了后者绑定了这个块级作用域，所以在let声明变量前，对tmp赋值会报错。

* ES6明确规定，如果块中存在let和const命令，这个块对这些命令声明的变量，从一开始就形成了封闭的作用域，凡事在声明之前使用这些变量都会报错。

* 总之，在代码块内，使用`let`命令声明变量之前，该变量都是不可用的。这在语法上，称为“暂时性死区”（temporal dead zone，简称 TDZ）。

### 1.3 不允许重复声明

* let不允许在相同作用域内重复声明同一个变量。

  ```javascript
  // 报错
  function () {
    let a = 10;
    var a = 1;
  }

  // 报错
  function () {
    let a = 10;
    let a = 1;
  }
  ```

* 不能在函数的内部重新声明参数

  ```javascript
  function func(arg) {
    let arg; // 报错
  }

  function func(arg) {
    {
      let arg; // 不报错
    }
  }
  ```

## 2 块级作用域

### 2.1 为什么需要块级作用域

* ES5只有全局作用域和函数作用域，没有块级作用域

* 在ES5中的代码：

  ```javascript
  var tmp = new Date();

  function f() {
    console.log(tmp);
    if (false) {
      var tmp = 'hello world';
    }
  }

  f(); // undefined
  ```

* 上面代码的原意是，`if`代码块的外部使用外层的`tmp`变量，内部使用内层的`tmp`变量。但是，函数`f`执行后，输出结果为`undefined`，原因在于变量提升，导致内层的`tmp`变量覆盖了外层的`tmp`变量。

### 2.2 ES6的块级作用域

* let实际上为JavaScript新增了块级作用域。

  ```javascript
  function f1() {
    let n = 5;
    if (true) {
      let n = 10;
    }
    console.log(n); // 5
  }
  ```

## 3. const命令

### 3.1 基本语法

* const声明一个只读的常量。一旦声明，常量的值就不能改变。

  ```javascript
  const PI = 3.1415;
  PI // 3.1415
  PI = 3;
  // TypeError: Assignment to constant variable.
  ```

* `const`声明的变量不得改变值，这意味着，`const`一旦声明变量，就必须立即初始化，不能留到以后赋值。

* `const`的作用域与`let`命令相同：只在声明所在的块级作用域内有效。

### 3.2 本质

* `const`实际上保证的并不是变量的值不得该动，而是变量指向的那个内存地址不得改动。

### 3.3 ES6声明变量的6种方法

* es5 只有两种声明变量的方法：var和function命令。在es6中，除了添加let和const命令，还有import 和 class命令，共6种方法。

## 4. 顶层对象属性

* 顶层对象，在浏览器环境指的是`window`对象，在Node指的是`global`对象。ES5之中，顶层对象的属性与全局变量是等价的。

* `var`命令和`function`命令声明的全局变量，依旧是顶层对象的属性；另一方面规定，`let`命令、`const`命令、`class`命令声明的全局变量，不属于顶层对象的属性。

  ```javascript
  var a = 1;
  // 如果在Node的REPL环境，可以写成global.a
  // 或者采用通用方法，写成this.a
  window.a // 1

  let b = 1;
  window.b // undefined
  ```

* 上面代码中，全局变量`a`由`var`命令声明，所以它是顶层对象的属性；全局变量`b`由`let`命令声明，所以它不是顶层对象的属性，返回`undefined`。
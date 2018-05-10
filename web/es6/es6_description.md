# ECMAScript 6简介

## 1. ECMAScript和JavaScript的关系

* ECMAScript是JavaScript的规格，JavaScript是ECMAScript的实践。（通常我们可以对这两个互换）

## 2. 转码器（Babel）

* Babel是一个广泛使用的ES6转码器，可以将ES6代码转换为ES5代码，从而在现有的环境中执行。这就意味着可以使用ES6的方式编写程序，又不用担心现有的环境的支持。下面就是一个列子：

  ```javascript
  // 转码前
  input.map(item => item + 1);

  // 转码后
  input.map(function (item) {
    return item + 1;
  });
  ```

* 配置文件.babelrc

  * Babel的配置文件是.babelrc，存放在项目的根目录下面。使用Babel的第一步就需要配置这个文件。该文件用来设置转吗规则和插件，基本格式如下所示：

    ```javascript
    {
      "presets": [],
      "plugins": []
    }
    ```

    ​

## 3. Traceur转码器

* google的Traceur转码器，也可以将ES6代码转换为ES5的代码。


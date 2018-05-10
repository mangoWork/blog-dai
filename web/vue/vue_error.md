## Vue常见的错误

### 1. 编译格式的错误

* 在编译的时候会报一些格式的错误，并非语法的错误，这个时候我们就需要在编译的时候不去检查这些格式的错误，解决办法是注释掉build/webpack.base.conf.js里面的代码，如下所示：

  ```
  {
          test: /.(js|vue)$/,
          loader: 'eslint-loader',
          enforce: "pre",
          include: [resolve('src'), resolve('test')],
          options: {
            formatter: require('eslint-friendly-formatter')
          }
        },
  ```


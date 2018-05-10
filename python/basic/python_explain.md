# python集中解释器的比较

## 1. CPython
* Cpython是用C语言开发的，所以叫做CPython，CPython也是使用最广泛的python解释器。

## 2. IPython
* IPython是基于CPython之上的一个交互式解析器，也就是说，IPython只是在交互 方式上有所加强，但是执行Python代码的功能和CPython是完全一样的。

## 3. PyPy
* PyPy是另一个Python解释器，它的目标是执行速度。PyPy采用JIT技术，对Python代码进行动态编译，并且可以显著的提高Python代码的执行速度。
* 绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。

## 4. Jython
* Jython是运行在Java平台的Python解释器，可以直接把python代码编译成Java字节码执行。

## 5. IronPython
* IronPython和Jython类似，只不过IronPython是运行在.net平台上的Python解释器，可以直接把python代码编译成.net字节码。
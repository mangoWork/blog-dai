## 装饰器partial、update_wrapper、wraps作用以及如何使用

> 在讲解partial、update_wrapper、以及wraps之前需要了解下装饰器：装饰器在实现的时候，被修饰后的函数其实已经是另外一个函数了(函数名等函数属性会发生比变化)。因此，为了不影响，python使用wraps来消除这样的副作用，因此，在我们写装饰器的时候，最好在实现之前加上wraps，它能保留原有函数的属性

### 1. partial

* 有什么用？

  > partial又叫偏函数。函数在执行的时候需要带上必要的参数，有些参数是执行之前就是可知的，这种情况下，一个函数有一个或者多个函数预先就能用上，**以便函数能够更少的参数进行调用**。

* 如何使用？

  * 首先先定义一个函数

    ```python
    def add(x, y):
        return x + y
    ```

  * 然后再利用partial对定义一个新的函数

    ```python
    add1 = partial(add, y=3) # 这里创建了一个新的函数
    ```

  * 最后再调用add1

    ```python
    print add1(4)  # 7
    print add(x=4, y=9) # 13
    ```

### 2. update_wrapper

* 有什么用？

  > update_wrapper这个函数的主要功能是负责copy原函数的一些属性，如_moudle_、_name_、_doc_、等，如果不加update_wrapper,那么被装饰器修饰的函数就会丢失其上面的一些属性信息

* 如何使用？

  * 首先定义一个函数

    ```python
    def wrapper(f):
        def wrapper_function(*args, **kwargs):
            """这个是修饰函数"""
            return f(*args, **kwargs)
        update_wrapper(wrapper_function, f)  # <<  添加了这条语句
        return wrapper_function
    ```

  * 利用装饰器定义一个新的函数

    ```python
    @wrapper
    def wrapped():
        """这个是被修饰的函数"""
        pass
    ```

  * 最后输出被装饰器修饰的函数的信息

    ```python
    print(wrapped.__doc__)  # 输出`这个是被修饰的函数`
    print(wrapped.__name__)  # 输出`wrapped`
    ```

  * `__doc__`和`__name__`属性已经是wrapped函数中的，当然，update_wrapper函数也对`__module__`和`__dict__`等属性进行了更改和更新

### 3. wraps

* 有什么作用？

  > 被装饰器修饰后的函数会编程另外一个函数，为了不受影响，利用wraps来消除这样的副作用，使它能够保持原函数的属性。

* 如何使用？

  *  首先先定义一个函数

    ```python
    def wrapper(f):
        @wraps(f)
        def wrapper_function(*args, **kwargs):
            """这个是修饰函数"""
            return f(*args, **kwargs)
        return wrapper_function
    ```

  * 利用装饰器定义一个新的函数

    ```python
    @wrapper
    def wrapped():
        """这个是被修饰的函数
        """
        pass
    ```

  * 最后输出被装饰器修饰的函数的信息

    ```python
    print(wrapped.__doc__)  # 输出`这个是被修饰的函数`
    print(wrapped.__name__)  # 输出`wrapped`
    ```

    ​

  ​
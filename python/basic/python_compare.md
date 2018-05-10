##	python常见的知识点(2.7)

###  1. 列表（list）、元组（tupe）、字典（dict）、set的区别？
*  列表（list）
  *  list是python种内置的一种数据类型，list是一种有序的集合，可以随时添加和删除其中的元素。其中list越大，查找速度越慢。查找和插入的时间随着元素的增加而增加；需要占用空间小，浪费内存小。表示方式为：
  *  `classmates = ['Michael', 'Bob', 'Tracy']`
*  元组（tupe）
  *  另外一种有序列表是元组（tupe），和list非常相似，但是tupe一旦被初始化了之后就不能被修改，表示方式如下：
  *  `classmates = ('Michael', 'Bob', 'Tracy')`
*  字典
  *  python内置了字典，在其他的语言中称之为map，使用的是键-值（key-value）方式存储，key不能重复。查找和插入速度快，但是需要占用大量的内存，内存浪费多。表示方式如下所示：
  *  `d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}`
*  set
  *    set和dic类似，也是一组key的集合，但是不能存储value。其中对应存储的key不能重复，其中set和dict的原理相同。创建对应的set的代码如下所示：
  *    `s = set([1, 2, 3])`
###  2.  locals()的作用？
* locals()返回一个包含当前作用域里面的所有的变量和他们的值的字典。
###  3.  Django中间件，如何配置，作用如何？

*  什么是中间件？
  *  中间件是介于request与response处理之间的一道处理过程，相对比较轻量级，在**全局上**改变django的输入以及输出。需要谨慎使用，会影响性能。其中每一个中间件会负责一个功能，例如：AuthenticationMiddleware与session处理相关。

    * 中间件如何配置？

    * 需要在setting.py中配置（或者在对应的项目的配置文件配置），配置的是

      ```python
      - MIDDLEWARE_CLASSES:
      MIDDLEWARE_CLASSES = [
      'django.middleware.security.SecurityMiddleware',
      'django.middleware.common.CommonMiddleware',
      'django.middleware.csrf.CsrfViewMiddleware', 
      ]
      ```


* 中间件的执行顺序？
* 我们从浏览器发出一个请求（Request）之后，得到一个响应的内容(HttpResponse),这个过程如下所示：

![](./img/process.png)

* 在每次的请求的时候都会按照配置文件中的顺序执行中间件的proccess_resuest函数，该函数会返回None或者HttpResponse（如果该函数返回None则继续执行，如果返回HttpResonse对象则不会继续执行相应的中间件或者view），其中的proccess_response会在最后执行，按照定义的中间件的相反顺序执行。

* 如何编写中间件？

* 中间件不用继承任何类（可以继承object），代码如下所示：

  * ```python
    class CommonMiddleware(object):
     　　　def process_request(self, request):
    　　　　　return None
    　　　def process_response(self, request, response):
    　　　　　return response
    ```


  ### 4. Django如何实现多表的查询？

  * 查询小明的所有完整信息

    * AuthorDetail.objects.values('sex',....)


    * 查询活着这本书的作者以及出版社名字
    * Book.objects.filter(title='活着').value('author__name','publisher__name')
    * 查询小明写了什么书
    * BOOK.objects.filter(author__name='小明').value('title')

  ***tips:**
  *   __：两个下划线可以生成表连接查询，查询关联的字段信息

    * _set：提供了对象访问相关联数据的方法。但是这种方法只能是相关类定义了关系的类（主键类访问外键类）
    * filter表示 =
    * execlude表示 !=
    * querySet.distinct()去重
    * __exact　精确等于 like 'aa'
    * __iexact　 精确等于　忽略大小写　ilike 'aa'
    * __contaions 包含 like '%aa%'
    * __icontaions  包含  忽略大小写  ilke '%aa%'


    * __gt 大于
    * __gate 大于等于
    * __it 小于
    * __ite  小于等于
    * __in 存在与一个list范围内
    * __startswith 以..开头 
    * __istartswith 以..开头  忽略大小写
    * __endswith 以..结尾
    * __iendswith 以..结尾   忽略大小写
    * __range 在..范围内
    * __year  日期字段的年份
    * __month  日期字段的月份
    * __day  日期字段的日
    * __isnull  日期字段的年份

  ### 6.Django中常用的注解有哪些？作用是什么？
  *

  ### 7.Django中内部Meta

  * Django模型是一个内部类、它用于定义一些Django模型类的行为特征。以下为可选的选项
    * abstract
      * Django模型是定义当前模型不是一个抽象类。所谓抽象类是不会有对应的数据库表的。一般用于归纳一些公共属性字段，然后继承它的子类可以继承这些字段。  如果abstract=True，说明这个模型就是一个抽象类。
    * app_label
      * 这个选项只有在一种情况下使用，就是你的模型不在默认的应用程序的models.py文件中，这时需要你指定你的模型是哪个应用程序的。
    * db_table
      * db_table是指自定义数据库的表名。
    * db_tablespace
      * 定义这个model所使用的数据库表空间。
    * get_latest_by
      *  在model中指定一个DateField或者DateTimeField。这个设置让你在使用model的Manager上的latest方法时，默认使用指定字段来排序。
    * managed
      * 默认值为True，这意味着Django可以使用命令来创建或移除对应的数据库。
    * order_with_respect_to

      * 这个选项一般多用于多对多的关系中，它指向一个关联对象，就是说关联对象找到这个对象后是它经过排序的。指定这个属性之后会得到一个get_XXX_order（）和set__XXX_order()的方法
    * ordering
      * 这个字段是告诉Django模型对象返回的结果是按照哪个字段排序：
      * ordering=['ordering']   #按照订单的升序排列
      * ordering=['-ordering']   #按照订单的降序排列   - 表示降序
      * ordering=['ordering']   #随即排序
      * ordering=['ordering','-username']   #按照ordering升序，按照username进行降序排序
    * permissions
      * permissions主要是为了在Django Admin管理模块下使用的，如果设置了这个属性，可以让指定的方法权限描述更加清晰可读。Django自动为每个设置了admin对象创建添加，删除和修改的权限。
    * proxy
      * 为了实现代理模式，如果proxy=True，表示model是其父的代理model。
    * unique_together
      *  需要使两个字段保持唯一的时候使用
    * verbose_name
      * verbose_name就是给你的模型起一个更加可读的名字，一般定义为中文
    * verbose_name_plural
      * 这个选项值得是模型的复数形式

  ### 8.Django是如何实现用户拦截的？
  * 在url.py中添加如下代码：

  ```python
  urlpatterns += required(
                partial(staff_member_required, 
         				login_url='backend:login'),
    　　  		urlpatterns
  			)
  ```

  ### 9.Django事务
* 管理数据库事务

  *  Django默认的行为是运行在自动提交模式下的，任何一个查询都立即被提交到数据库中，除非激活一个事务
    * 把事务绑定在HTTP请求上

    * 在web上的一种简单处理事务的方式是将每个请求用事务包装起来。在每个你想保存这种行为数据的配置文件中，设置ATOMIC_REQUESTS值为True

    * 工作的过程：在调用一个view里面的方法之前，django开始一个事务，如果发出的相应没有什么问题，Django就会提交这个事务。如果在view里产生异常，Django就会回滚事务。

    * 在实际的操作中，可以通过如下atomic()装饰器把这一功能简单地加载到视图函数上。

    * 表示事务仅仅是当前视图有效，诸如模版响应之类的中间件操作是运行在事务之外的

       ```python
       @transaction.non_atomic_requests
       def my_view(request):
        　 do_stuff()
       ```

    * 更加明确的控制事务

       ```python
        from django.db import IntegrityError, transaction

         @transaction.atomic
         def viewfunc(request):
       	create_parent()
       	try:
           	with transaction.atomic():
               	generate_relationships()
       	except IntegrityError:
       			handle_exception()
       	add_children()
       ```


  ### 10.Django如何处理一个请求
* 当一个用户请求Django站点的一个页面，下面是Django系统决定执行哪个python代码：

  *  Django决定要使用的根URLconf模块。通常，这个值就是ROOT_URL_CONF的设置，但是如果进来的HttpResquest对象具有一个urlconf属性（通过中间件request proccessing设置），则使用这个值替换ROOT_URL_CONF设置。

    * Django加载该Python模块并寻找可用的urlpatterns。它是django.conf.urls.url() 实例的一个Python 列表。
    * Django 依次匹配每个URL 模式，在与请求的URL 匹配的第一个模式停下来。
    * 一旦其中的一个正则表达式匹配上，Django 将导入并调用给出的视图，它是一个简单的Python 函数（或者一个基于类的视图）。


    * 如果没有匹配到正则表达式，或者如果过程中抛出一个异常，Django 将调用一个适当的错误处理视图。

  ### 11.自定义错误视图
* handler404 = 'mysite.views.my_custom_page_not_found_view'
* handler500 = 'mysite.views.my_custom_error_view'
* handler403 = 'mysite.views.my_custom_permission_denied_view'
* handler400 = 'mysite.views.my_custom_bad_request_view'

### 12.如何限制HTTP的请求方法

```python
@require_http_methods(["GET", "POST"])<br>
def my_view(request):
	do_task()
```

* require_GET()    只允许视图接受GET方法的装饰器。
* require_POST() 只允许视图接受POST方法的装饰器。
* equire_safe() 只允许视图接受 GET 和 HEAD 方法的装饰器。 这些方法通常被认为是安全的，因为方法不该有请求资源以外的目的

### 13.在session中添加用户信息以及退出一个用户

* 需要先调用authenticate(),当成功的认证该用户的时候，之后才会调用login()
* 通过logout(request)退出用户

### 14.如何实现只允许登录的用户访问？

* 可以通过代码：request.user.is_authenticated()是否登陆
* 也可以通过login_required 装饰器
  * 如果用户没有登陆，则会从定向到settings.LOGIN_URL,并将当前的访问路径传递到查询字符串中。
* 如果用户已经登陆了，则正常执行视图，视图的代码可以安全地假设用户已经登陆了。

### 15.permission_required 装饰器的作用？
* 用于检查一个用户是否有指定的权限

### 16.怎样重写用户模型？

* Django中内置的User模型不可能适合所有的项目，可以通过AUTH_USER_MODEL设置覆盖默认的User模型，其值引用一个定义的模型。

* AUTH_USER_MODEL = 'myapp.MyUser'

* 自定义的模型需要满足的要求如下所示：

    * 模型必须要有一个唯一的字段可被用于识别目的。
  * 创建一个规范的自定义模型的最简单的方法是继承AbstractBaseUser。AbstractBaseUser提供User模型的核心实现，包括散列密码和令牌化密码重置。必须提供一些关键的实施细节：

  * USERNAME_FIELD   描述User模型上用作唯一标识符的字段名称的字符串，字段必须是唯一的。

  *  REQUIRES_FIELDS   列出必须的字段

    *is_active  指示用户是否被视为“活动”的布尔属性，默认为True。如何选择实施它取决于选择身份验证后端的信息。
    *get_full_name()   用户更长且正式的标识，常用的解释会是用户的完整名称，可以是任何字符串
    *get_short_name()一个短的并且正式的用户标识符。
    *自定义了User模型之后，如果你的User模型定义了username、email、is_staff、is_active、is_superuser、last_login、date_joined跟默认的字段是一样的话，那么你就使用Django的UserManager就行了；总之，如果定义了有不同的字段的时候，你就需要自定义一个管理器，它继承BaseUserManager并提供两个额外的方法。

  *create_user(*username,password=None,**other_fields)
  *create_superuser(*username,password,**other_fields)

  *	其中create_user()和create_superuser()不同，其中create_superuser()必须要求调用方提供密码

  ### 17.用户定义以及权限
* 为了将Django的权限框架包含在自己的User类中，Django提供了PermissionsMixin。提供支持Django权限模型所需要的所有方法和数据库的字段。

### 18.用户认证自定义（一般用于自己重写user之后）

* 在stting.py中设置：

```python
AUTHENTICATION_BACKENDS= (
　　 'users.views.CustomBackend',
　　 )
# 其中定义的为用户自定义的认证对象，代码如下（需要继承ModelBackend对象，重写authenticate()方法）：

  class CustomBackend(ModelBackend):
 		def authenticate(self, username=None, password=None, **kwargs):
 			try:
  			 	user = UserProfile.objects.get(Q(username = username)|Q(email=username))
  	 			if user.check_password(password):
  					 return user
 			except Exception as e:
 				return None
```

  ### 19. \*args和**args的区别?
  用当你不确定你的函数里将要传递多少参数的时候，可以使用\*args，可以传递任意参数
  \*\*相似的，**kwargs允许你使用没有实现预定好的参数名

  ### 20.装饰器的作用？

* 为已经存在的对象添加额外的功能。

### 21.python中的重载

* 重载主要解决两个问题：
    * 可变参数类型
    * 可变参数的个数

  ### 22._new_和_init_的区别？
* 这个\__new\__是一个静态方法区，而\__init\__是一个实例方法。
* \__new\__方法会返回一个创建的实例，而\__init\__什么都不会返回
* 只有在\__new\__返回一个class的实例时后面的\__init\__才能被调用
* 当创建一个新的实例时调用\__new\__，初始化一个实例用\__init\__


### 22.	Python垃圾回收机制
* Python GC主要使用引用计数来跟踪和回收垃圾。在引用计数的基础上，通过“标记-清除”解决容器对象可能产生的循环引用问题，通过“分代回收”以空间换时间的方法提高垃圾回收效率。

  * 引用计数法

    * PyObject是每个对象必有的内容，其中ob_refcnt就是为引用计数。当一个对象有新的引用的时候，它的ob_refcnt就会增加，当引用它的对象被删除的时候，它的ob_refcnt就会减少。当obj_refcnt为0的时候，该对象的生命就结束了。
    * 优点：
      * 简单
      * 实时性
    * 缺点
      * 维护引用计数消耗资源
      * 循环引用
  * 标记-清除机制
    * 基本思路就是先按需分配，等到没有空闲的时候从寄存器和程序栈上引用出发，遍历以对象为节点、以引用为边构成图，把所有可以访问的对象上打上标记，然后清扫一遍内存空间，把没有标记的对象释放。
  * 分代技术
    * 分代回收的整体思想是：将系统中的所有内存块根据其存活的时间划分为不同的集合，每个集合就成为一个“代”。垃圾收集频率随着“代”的存活时间的增大而减小，存活时间通常利用经过几次垃圾回收来度量。
    * Python默认定义了三代对象集合，索引数越大，对象存活时间越长。


### 23.    python中的is与==？
* python中的is是对比地址，==是对比值

### 24.read、readline和readlines
* read读取整个文件
* readline读取下一行，使用生成器方法
* readlines读取整个文件到一个迭代器以供我们遍历

### 25.  如何在一个文件夹中创建多个app？
* 先将创建好的app复制到指定的文件夹中，然后在settings.py中添加代码：
* sys.path.insert(0, os.path.join(BASE_DIR, 'app'))
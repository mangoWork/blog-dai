### Django常遇到的问题

### 1. django中save()无法立即保存？

* 在进行数据库的配置的时候，在数据库的设置了`ATOMIC_REQUESTS`为True，代码如下所示：

  ```python
  DATABASES = {
      'default': {
          'ENGINE': 'django.db.backends.postgresql_psycopg2',
          'NAME': '',
          'USER': '',
          'PASSWORD': '',
          'HOST': '',
          'PORT': '',
          'ATOMIC_REQUESTS': True,
      }
  }
  ```

*  设置了`ATOMIC_REQUESTS`为True，则表示每个view都会开启事务。

*  解决办法，在对应的view中使用修饰器`@transaction.non_atomic_requests` 修饰，表示不是用事务


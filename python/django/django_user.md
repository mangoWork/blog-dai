### 1. 拦截用户的请求的示列（1）：

* 示列代码：

```python
def required(wrapping_functions,patterns_rslt):
    '''
    Used to require 1..n decorators in any view returned by a url tree

    Usage:
      urlpatterns = required(func,patterns(...))
      urlpatterns = required((func,func,func),patterns(...))

    Note:
      Use functools.partial to pass keyword params to the required 
      decorators. If you need to pass args you will have to write a 
      wrapper function.

    Example:
      from functools import partial

      urlpatterns = required(
          partial(login_required,login_url='/accounts/login/'),
          patterns(...)
      )
    '''
    if not hasattr(wrapping_functions,'__iter__'): 
        wrapping_functions = (wrapping_functions,)

    return [
        _wrap_instance__resolve(wrapping_functions,instance)
        for instance in patterns_rslt
    ]

def _wrap_instance__resolve(wrapping_functions,instance):
    if not hasattr(instance,'resolve'): return instance
    resolve = getattr(instance,'resolve')

    def _wrap_func_in_returned_resolver_match(*args,**kwargs):
        rslt = resolve(*args,**kwargs)

        if not hasattr(rslt,'func'):return rslt
        f = getattr(rslt,'func')

        for _f in reversed(wrapping_functions):
            # @decorate the function from inner to outter
            f = _f(f)

        setattr(rslt,'func',f)

        return rslt

    setattr(instance,'resolve',_wrap_func_in_returned_resolver_match)

    return instance
```

* 其中的login_required可以换成其他的修饰器。

* 使用：

  ```pyhton2.7
  urlpatterns += required(
            partial(login_required,login_url='/accounts/login/'),
            urlpatterns
        )
  ```

  ​

* 参考地址：https://www.91r.net/ask/9318962.html

### 2.拦截用户请求的示列(2):

* 示列代码：

  ```python
  from django.core.urlresolvers import RegexURLPattern, RegexURLResolver
  from django.conf.urls.defaults import patterns, url, include
  from django.contrib import admin
  from myproject.myapp.decorators import superuser_required

  class DecoratedURLPattern(RegexURLPattern):
      def resolve(self, *args, **kwargs):
          result = super(DecoratedURLPattern, self).resolve(*args, **kwargs)
          if result:
              result.func = self._decorate_with(result.func)
          return result

  class DecoratedRegexURLResolver(RegexURLResolver):
      def resolve(self, *args, **kwargs):
          result = super(DecoratedRegexURLResolver, self).resolve(*args, **kwargs)
          if result:
              result.func = self._decorate_with(result.func)
          return result

  def decorated_includes(func, includes, *args, **kwargs):
      urlconf_module, app_name, namespace = includes

      for item in urlconf_module:
          if isinstance(item, RegexURLPattern):
              item.__class__ = DecoratedURLPattern
              item._decorate_with = func

          elif isinstance(item, RegexURLResolver):
              item.__class__ = DecoratedRegexURLResolver
              item._decorate_with = func

      return urlconf_module, app_name, namespace
  ```

* 使用：

```python
urlpatterns = patterns('',
    # ...
    (r'^private/', decorated_includes(login_required, include(private.urls))),
)
```
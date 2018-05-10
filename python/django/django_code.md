### Django源码分析--------程序启动入口

> 本文章的源码分析(程序启动入口)的段落包括：1. 分析之前（创建demo项目）、2.  程序启动入口分析

### 1. demo的创建

*  在对源码进行分析之前，先创建一个django项目，创建django的项目的命令如下所示：

  ```shell
  django-admin startproject demo
  ```

*  创建之后的目录结构如下所示：

  ```shell
  ├── demo
  │   ├── __init__.py
  │   ├── settings.py
  │   ├── urls.py
  │   └── wsgi.py
  └── manage.py
  ```

*  其中django的后台进程通常通过命令``python manager.py [options]``运行的，其中``options``为相关的命令（runserver、makemigrations等等），接下来分析manager.py的具体的执行流程

### 2.  程序启动入口分析

* manager.py文件的分析，其中，manager.py的代码如下所示：

  ```python
  #!/usr/bin/env python
  import os
  import sys

  if __name__ == "__main__":
      os.environ.setdefault("DJANGO_SETTINGS_MODULE", "demo.settings")
      try:
          from django.core.management import execute_from_command_line
      except ImportError:
          try:
              import django
          except ImportError:
              raise ImportError(
                  "Couldn't import Django. Are you sure it's installed and "
                  "available on your PYTHONPATH environment variable? Did you "
                  "forget to activate a virtual environment?"
              )
          raise
      execute_from_command_line(sys.argv)
  ```

  * 其中，代码``os.environ.setdefaul...``为设置默认的环境变量，环境变量名称为``DJANGO_SETTINGS_MODULE``;代码``execute_from_command_line``方法用于读取命令行参数，并执行相关代码

*  进入``execute_from_command_line``方法，该方法的源代码如下所示：

  ```python
  def execute_from_command_line(argv=None):
      """
      A simple method that runs a ManagementUtility.
      """
      utility = ManagementUtility(argv)
      utility.execute()
  ```

  > 从代码中可以看出，``execute_from_command_line``可以直接使用``utility = ManagementUtility(argv).execute() ``替换，最终执行的是``ManagementUtility``中的``execute``方法。

* 进入``execute``方法

  * 在进入execute之后，需要获取对应命令参数(runserver),然后解析命令，设置配置路径以及python路径(如果没有设置，则设置默认的配置)，对应的代码如下所示：

    ```python
     try:
                subcommand = self.argv[1]
            except IndexError:
                subcommand = 'help'  
            parser = CommandParser(None, usage="%(prog)s subcommand [options] [args]", add_help=False)
            parser.add_argument('--settings')
            parser.add_argument('--pythonpath')
            parser.add_argument('args', nargs='*')  # catch-all
    ```

  * 紧接着获取``setting``中的``app``, 对应的代码为：

    ```python
    try:
        settings.INSTALLED_APPS
     except ImproperlyConfigured as exc:
        self.settings_exception = exc
    ```

    > 其中settings引入对应的文件django.conf.\__init\__.py, 在该文件中声明了``settings = LazySettings()``, ``LazySettings``也在该文件中，在执行``settings.INSTALLED_APPS``代码的时候，会执行``LazySettings``中的``__getattr``方法，该方法的代码如下所示：


    ```python
    def __getattr__(self, name):
            """
            Return the value of a setting and cache it in self.__dict__.
            """
            if self._wrapped is empty:
                self._setup(name)
            val = getattr(self._wrapped, name)
            self.__dict__[name] = val
            return val
    ```

    * 在``_setup``中将会先获取之前设置的``DJANGO_SETTINGS_MODULE``环境变量，如果不存在则会抛出异常，如果存在，则继续执行
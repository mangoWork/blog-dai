## Python

1.  在linux下无法使用matplotlib模块，无法安装python3-tk
   * 原因
     *   `tk`在python中自带，系统默认的是python2.X版本，当使用python3.x的时候需要重新编译
   * 解决办法：
     * 下载源文件： `wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tar.xz`
     * 解压文件：`xz -d Python-3.5.3.tar.xz&&tar -xvf Python-3.5.3.tar`
     * 配置python文件： `cd Python-3.5.3&&./configure`
     * 编译并且安装： `make&&make altinstall`
     * 校验：`import tkinter as tk`

## Django

1. 启动web的时候的错误为：‘’‘解决：CentOS下的 error while loading shared libraries: libmysqlclient.so.16: cannot open shared object file: No such file or dir’

   - 原因：

     - 缺少共享库libmysqlclient.so.20，般都是ldconfig 没有找到共享库的位置，或者 软链接的问题

   - 解决办法：

     - 先找到对应的libmysqlclient.so文件，或者下载（如果下载则忽略这一步骤）

       ```shell
       updatedb
       locate libmysqlclient.so
       ```

     -  到libmysqlclient.so 文件下做一个软连接到/usr/lib

       ```shell
       ln -s /usr/local/mysql/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.20
       ```

2. django中save()无法立即保存？

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

   * 设置了`ATOMIC_REQUESTS`为True，则表示每个view都会开启事务。

   * 解决办法，在对应的view中使用修饰器`@transaction.non_atomic_requests` 修饰，表示不是用事务

3. Django中默认使用的是内连接，如何使用左连接？


   * 数据库中对应的agent表和agentpaylog表分别如下所示：

     * agent表的代码如下所示：

       ```python
       class Agent(models.Model):
           account = models.OneToOneField(Account, on_delete=models.PROTECT, db_constraint=False)
           level = models.ForeignKey(AgentLevel, on_delete=models.PROTECT, db_constraint=False)
           parent_agent_id = models.IntegerField(default=0, help_text='父级推荐人')
           created = models.DateTimeField(auto_now_add=True, blank=True, editable=False)
           updated = models.DateTimeField(null=True, blank=True)

           class Meta:
               db_table = 'agent'
       ```

     *  agent_pay_log表的代码如下所示：

       ```python

       class AgentPayLog(models.Model):
           amount = models.DecimalField(max_digits=12, decimal_places=2, default=0, help_text='金额')
           agent = models.ForeignKey(Agent, on_delete=models.PROTECT, db_constraint=False, help_text='推广用户')
           reward_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0, help_text='用户推荐奖金金额')
           created = models.DateTimeField(auto_now_add=True, blank=True, editable=False)
           updated = models.DateTimeField(null=True, blank=True)

           class Meta:
               db_table = 'agent_pay_log'
       ```

   *  使用django中的model查询所有的Agent的id以及对应的AgentPayLog:

     ```python
     filter = [Q(agentpaylog__isnull=True) | Q(agentpaylog__isnull=False)]
             agents = Agent.objects.filter(*filter).values('id', 'agentpaylog__agent_id')
     ```

   * 其中打印出来的sql语句如下所示：

     ```sql
     SELECT `agent`.`id`, `agent_pay_log`.`agent_id`
     FROM `agent`
     LEFT OUTER JOIN `agent_pay_log` ON (`agent`.`id` = `agent_pay_log`.`agent_id`)
     WHERE(`agent_pay_log`.`id` IS NULL OR `agent_pay_log`.`id` IS NOT NULL);
     ```

     ​


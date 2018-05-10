##  Ansible模块介绍

### 1. Ansible

#### 1.1 简介

* Ansilbe是一个部署一群远程主机的工具。远程的主机可以是远程虚拟机或物理机， 也可以是本地主机。

* Ansilbe通过SSH协议实现远程节点和管理节点之间的通信。理论上说，只要管理员通过ssh登录到一台远程主机上能做的操作，Ansible都可以做到。

  包括：

  - 拷贝文件
  - 安装软件包
  - 启动服务
  - …

### 2. Playbook简介

* Ansible的任务配置文件被称之为“playbook”，我们可以称之为“剧本”。每一出剧本（playbook）中都包含一系列的任务，这个任务在ansible中又被称为一出“戏剧”(play)。一个剧本（playbook）中包含多出戏剧(play)。

#### 2.1 Playbook语法简介 

* Playbook采用一种可读性强而且容易被阅读的YAML语法编写，格式如下

  ```yaml
  house:
    family:
      name: Doe
      parents:
        - John
        - Jane
      children:
        - Paul
        - Mark
        - Simone
    address:
      number: 34
      street: Main Street
      city: Nowheretown
    zipcode: 12345
  ```

### 3. Playbook实战

#### 4.1 Shell脚本与Playbook的转换

* 现在越来越多的DevOps开始将目光转向Ansible，Ansible可以轻松的将shell脚本或简单的shell命令转换为Ansible Plays

  * 下面是安装apache的shell脚本：

    ```shell
    #!/bin/bash
    # 安装Apache
    yum install --quiet -y httpd httpd-devel
    # 复制配置文件
    cp /path/to/config/httpd.conf /etc/httpd/conf/httpd.conf
    cp /path/to/httpd-vhosts.conf /etc/httpd/conf/httpd-vhosts.conf
    # 启动Apache，并设置开机启动
    service httpd start
    chkconfig httpd on
    ```

  * 将shell转换为playbook之后如下所示：

    ```yaml
    ---
    - hosts: all

      tasks:
       - name: "安装Apache"
         command: yum install --quiet -y httpd httpd-devel
       - name: "复制配置文件"
         command: cp /tmp/httpd.conf /etc/httpd/conf/httpd.conf
         command: cp /tmp/httpd-vhosts.conf /etc/httpd/conf/httpd-vhosts.conf
       - name: "启动Apache，并设置开机启动"
         command: service httpd start
         command: chkconfig httpd on
    ```

  * 将以上playbook的内容存放为playbook.yml的文件，直接调用ansible-playbook命令，即可运行，运行结果和脚本一致：

    ```shell
    # ansible-playbook ./playbook.yml
    ```

* 其他Ansible内置的模块如下所示“：

  ```yaml
  ---
  - hosts: all
    sudo: yes

    tasks:
     - name: 安装Apache
       yum: name={{ item }} state=present
       with_items:
       - httpd
       - httpd-devel
     - name: 复制配置文件
       copy:
         src: "{{ item.src }}"
         dest: "{{ item.dest }}"
         owner: root
         group: root
         mode: 0644
       with_items:
       - {
         src: "/tmp/httpd.conf",
           dest: "/etc/httpd/conf/httpd.conf" }
       - {
         src: "/tmp/httpd-vhosts.conf",
         dest: "/etc/httpd/conf/httpd-vhosts.conf"
         }
     - name: 检查Apache运行状态，并设置开机启动
       service: name=httpd state=started enabled=yes
  ```

#### 3.2. Playbook案例解析

* 剖析以上案例：
  1. 第一行，”----“这个是YAML语法中注释的方法，就想shell脚本中的”#“号一样
  2. 第二行，”-host:all“，告诉ansible具体在哪些主机上运行我的脚本
  3. 第三行，”sudo:yes“，告诉ansible通过sudo来运行命令，这样命令将会以root的身份来运行
  4. 第四行，”tasks“,指定一系列要运行的任务
     * 每一个任务（play）以“- name: 安装Apache”开头。“- name:”字段并不是一个模块，不会执行任务实质性的操作，它只是给“task” 一个易于识别和名称。即便把name字段对应的行完全删除，也不会有任何问题。
     * 本例中我们使用yum模块来安装Apache，替代了“yum -y install httpd httpd-devel”
     * 在每一个play当中，都可以例用 with_items 来定义变量，并通过“{{ 变量名 }}”的形式来直接使用使用yum模块的state=present选项来确保软件被安装，或者使用state=absent来确保软件被删除
     * 第二个任务（play）同样是“- name”字符开头
     * 我们使用copy模块来将“src”定义的源文件（必须是ansible所在服务器上的本地文件 ）复制到“dest”定义的目的地址（此地址为远程主机的上地址）去,在传递文件的同时，还定义了文件的属主，属组和权限
     * 这个play中，我们用数组的形式给变量赋值，使用{var1: value, var2: value} 的格式来赋值，变量的个数可以任意多，不同变量间以逗号分隔，使用{{item.var1 }}的形式来调用变量，本例中为：{{ item.src }}
     * 第三个任务（play）使用了同样的结构，调用了service模块，以保证服务的正常开启

#### 3.3 Playbook与shell脚本的差异比较

* 当我们把shell脚本转换为playbook运行地时候，ansible会留下清晰的执行痕迹，明确报告我们在每一台主机都做了什么
* 当我们重复执行一个playbook时，当ansible发现系统现有状态符合playbook所定义的状态时，ansible会自动跳过该操作。shell会重复执行。

### 4. Ansible-playbook命令详解

####  4.1 限定命令执行范围

```yaml
--limit
```

* 我们可以通过-hosts：字段来指定哪些主机将会被应用到playbook的操作

* 我们也可以通过如下的命令来指定主机(仅对webservers生效)：

  ```yaml
  # ansible-playbook playbook.yml --limit webservers
  ```

#### 4.2 用户与权限设置    

```shell
--remote-user
```

* Playbook中，如果在与hosts同组的字段中没有定义user，那么Ansible将会使用你在inventory文件中定义的用户，如里inventory文件中也没定义用户，Ansible将默认使用当前系统用户身份来通过SSH连接远程主机，在运程程主机中运行play内容。

* 我们也可以直接在ansible-playbook中使用 --remote-user选项来指定用户：

  ```yaml
  # ansible-playbook playbook.yml --remote-user=tom
  ```

  ​


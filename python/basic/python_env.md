python 虚拟环境

```shell
sudo pip install virtualenv
sudo pip install virtualenvwrapper
mkdir $HOME/.virtualenvs
vi ~/.bashrc
```

添加

```shell
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=/home/pengfei/Desktop/data/mysite/imgxe/
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/bin/virtualenvwrapper.sh
```

保存退出   :wq强制性写入文件并退出。   :x 仅当文件被修改时，写入文件并退出   按esc退出编辑模式，回到命令模式

运行
source ~/.bashrc

此时virtualenvwrapper就可以使用了。
列出虚拟环境列表
workon
也可以使用
lsvirtualenv
新建虚拟环境
mkvirtualenv [虚拟环境名称]
启动/切换虚拟环境
workon [虚拟环境名称]
删除虚拟环境
rmvirtualenv [虚拟环境名称]

离开虚拟环境
deactivate


在创建好了虚拟环境之后需要安装对应的开发中的包，利用虚拟环境中自带的pip命令：
pip install -U -r requirements/DEVELOPMENT


在用pycharm中需要配置对应的python的包路径，使用虚拟环境中的包
设置对应的源码，资源文件
设置对应的setting文件
设置django server  配置其中的环境变量：DJANGO_SETTINGS_MODULE=settings.development

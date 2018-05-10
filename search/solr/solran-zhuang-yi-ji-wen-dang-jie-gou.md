## Solr的安装
### 1. Solr的安装
    * step1. 下载包
        >Solr 可从 Solr 网站获取。您可以在此下载最新版本的 Solr：https://lucene.apache.org/solr/mirrors-solr-latest-redir.html
    * step2. 解压包
        > tar -zxvf solr-7.0.0.tgz
    * step3. 启动solr
        > bin/solr start
    * step4. 查看状态
        > bin/solr status
    * step5. 创建核心
        > bin/solr create -c name

### 2. 目录介绍
> 安装 Solr 之后，您将会看到以下的目录和文件：

* bin 
    > 此目录中包含几个重要的脚本，这些脚本将使使用 Solr 更容易。

    * solr 和 solr.cmd 
        > 这是Solr 的控制脚本，也称为bin/solr（对于 * nix）或者bin/solr.cmd（对于 Windows）。这个脚本是启动和停止 Solr 的首选工具。您也可以在运行 SolrCloud 模式时创建集合或内核、配置身份验证以及配置文件。

    * post 
        > Post Tool，它提供了用于发布内容到 Solr 的一个简单的命令行界面。

    * solr.in.sh 和 solr.in.cmd 
        > 这些分别是为 * nix 和 Windows 系统提供的属性文件。在这里配置了 Java、Jetty 和 Solr 的系统级属性。许多这些设置可以在使用bin/solr或者bin/solr.cmd时被覆盖，但这允许您在一个地方设置所有的属性。

    * install_solr_services.sh 
        > 该脚本用于 * nix 系统以安装 Solr 作为服务。在 “将Solr用于生产 ” 一节中有更详细的描述。

* contrib 
    > Solr 的contrib目录包含 Solr 专用功能的附加插件。 

* dist 
    > 该dist目录包含主要的 Solr .jar 文件。

* docs 
    > 该docs目录包括一个链接到在线 Javadocs 的 Solr。

* example 
    > 该example目录包括演示各种 Solr 功能的几种类型的示例。有关此目录中的内容的详细信息，请参阅下面的 Solr 示例。

* licenses 
    > 该licenses目录包括 Solr 使用的第三方库的所有许可证。

* server 
    > 此目录是 Solr 应用程序的核心所在。此目录中的 README 提供了详细的概述，但以下是一些特点：

    > Solr 的 Admin UI（server/solr-webapp）

    > Jetty 库（server/lib）

    > 日志文件（server/logs）和日志配置（server/resources）。有关如何自定义 Solr 的默认日志记录的详细信息，请参阅配置日志记录一节。

    > 示例配置（server/solr/configsets）
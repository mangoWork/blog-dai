### 1. sourcetree安装跳过登陆的问题

* 安装 SourceTree 时，需要使用atlassian授权，因为各种原因无法完成授权，现提供跳过 atlassian账号 授权方法。

* 安装之后，转到用户本地文件夹下的 SourceTree 目录，没有则新建：

  ```shell
  %LocalAppData%\Atlassian\SourceTree\
  ```

*  新建accounts.json文件，并且保存一下内容，内容如下所示：

  ```json
  [
    {
      "$id": "1",
      "$type": "SourceTree.Api.Host.Identity.Model.IdentityAccount, SourceTree.Api.Host.Identity",
      "Authenticate": true,
      "HostInstance": {
        "$id": "2",
        "$type": "SourceTree.Host.Atlassianaccount.AtlassianAccountInstance, SourceTree.Host.AtlassianAccount",
        "Host": {
          "$id": "3",
          "$type": "SourceTree.Host.Atlassianaccount.AtlassianAccountHost, SourceTree.Host.AtlassianAccount",
          "Id": "atlassian account"
        },
        "BaseUrl": "https://id.atlassian.com/"
      },
      "Credentials": {
        "$id": "4",
        "$type": "SourceTree.Model.BasicAuthCredentials, SourceTree.Api.Account",
        "Username": "",
        "Email": null
      },
      "IsDefault": false
    }
  ]
  ```

  ​


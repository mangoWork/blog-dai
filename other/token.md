##  token在web应用中的使用

###  1. Token的介绍

​	通俗的讲，token是用户的一种凭证，需要拿到正确的用户和密码向token服务器申请才能得到，如果用户每次都使用用户名密码访问API的时候，容易泄露用户信息，带来安全隐患，所以在访问之前需要先生成token作为凭证访问API。

###  2. Keystone中的四中token

#### 2.1 四种token比较

| Token 类型    | UUID    | PKI             | PKIZ            | Fernet     |
| ----------- | ------- | --------------- | --------------- | ---------- |
| 大小          | 32 Byte | KB 级别           | KB 级别           | 约 255 Byte |
| 支持本地认证      | 不支持     | 支持              | 支持              | 不支持        |
| Keystone 负载 | 大       | 小               | 小               | 大          |
| 存储于数据库      | 是       | 是               | 是               | 否          |
| 携带信息        | 无       | user, catalog 等 | user, catalog 等 | user 等     |
| 涉及加密方式      | 无       | 非对称加密           | 非对称加密           | 对称加密(AES)  |
| 是否压缩        | 否       | 否               | 是               | 否          |
| 版本支持        | D       | G               | J               | K          |



### 3. JWT的介绍

#### 3.1. 使用场景

* 如： 当A用户关注了B用户的时候，系统发送邮件给B用户，并且附带一个链接"点此关注A用户"。链接的地址可以是这样的：

  ```http
  https://your.awesome-app.com/make-friend/?from_user=B&target_user=A
  ```

*  上面的URL主要通过URL来描述这个当然这样做有一个弊端，那就是要求用户B用户是一定要先登录的。可不可以简化这个流程，让B用户不用登录就可以完成这个操作。JWT就允许我们做到这点。

#### 3.2. JWT的组成

* 一个JWT实际上就是一个字符串，它由三部分组成：头部、荷载与签名。

* 荷载：

  *  下面就是将添加好友的描述成一个json对象。其中添加了一些其他的信息。

    ```shell
    {
        "iss": "John Wu JWT",
        "iat": 1441593502,
        "exp": 1441594722,
        "aud": "www.example.com",
        "sub": "jrocket@example.com",
        "from_user": "B",
        "target_user": "A"
    }
    ```

  * 在这里面的前五个字段都是JWT的标准所定义的。

    * iss：该JWT的签发者
    * sub：该JWT所面向的用户
    * aud：该接收JWT的一方
    * exp(expires)：什么时候过期，是一个Unix时间戳
    * iat(issued at)：什么时候签发的

  * 将json对象进行(base64编码)可以得到下面的字符串。这个字符串我们称作JWT的Payload(荷载)。

    ```shell
    eyJpc3MiOiJKb2huIFd1IEpXVCIsImlhdCI6MTQ0MTU5MzUwMiwiZXhwIjoxNDQxNTk0NzIyLCJhdWQiOiJ3d3cuZXhhbXBsZS5jb20iLCJzdWIiOiJqcm9ja2V0QGV4YW1wbGUuY29tIiwiZnJvbV91c2VyIjoiQiIsInRhcmdldF91c2VyIjoiQSJ9
    ```

  * tips:

    * Base64是一种编码，也就是说，它可以被翻译回原来的样子的。它并不是一种加密。

* 头部：

  * JWT需要一个头部，头部用于描述该JWT的最基本的信息，例如，其类型以及签名所用的算法。这也可以被表示成一个json对象：

    ```shell
    {
      "typ": "JWT",
      "alg": "HS256"
    }
    ```

  * 此时，我们也要对头部进行Base64编码：

    ```
    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
    ```

* 签名：

  *  将荷载以及头部的编码之后的字符串都用句号``.`` 连接在一起（头部在前）,就形成了

    ```
    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcm9tX3VzZXIiOiJCIiwidGFyZ2V0X3VzZXIiOiJBIn0
    ```

  *  将上面拼接完的字符串用HS256算法进行加密，我们还需要提供一个密钥。如果使用``mystar``作为密钥的话，那么就可以得到我们加密后的内容。这一部分也叫做签名：

    ```
    rSWamyAYwuHCo7IFAgd1oRpSP7nzL7BF5t7ItqpKViM
    ```

  * 最后将这一部分签名也拼接到被签名的字符串后面，我们得到了完整的JWT：

    ```
    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcm9tX3VzZXIiOiJCIiwidGFyZ2V0X3VzZXIiOiJBIn0.rSWamyAYwuHCo7IFAgd1oRpSP7nzL7BF5t7ItqpKViM
    ```

    ​

#### 3.3. 签名的目的？

*  在最后一步签名的过程中，实际上就是对头部以及荷载进行签名。一般而言，加密算法对于不同的输入产生的输出总是不一样的。
*  在服务器应用接收到JWT后，会首先对头部和荷载的内容用同一算法再次签名。那么服务器引用通过头部的``alg``字段指明了我们的加密算法。 如果服务器对头部和荷载采用同一种方法签名之后，计算出来的签名和接收到的签名不一样，那么就锁名这个Token被别人动过。应该拒绝Token。 

#### 3.4. JWT应用在单点登录

* session与JWT的比较
  * session方式存储用户id，一开始用户的session只会存储在一台服务器上。对于有多个子域的站点。当登陆之后，为了让其他的子域可以获取到session，这要求我们在多态服务器中同步Session。
  * JWT的方式不会存在，应为用户的状态被送到了客户端。只需要设置JWT的Cookies的``domain``设置为顶级域名即可。
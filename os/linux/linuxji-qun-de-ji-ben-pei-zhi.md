## Linux集群中基础的通用配置

### 配置NTP

### 配置SSH
#### SSH基于公钥认证流程
1. Client将自己的公钥存放在Server上，追加在文件authorized_keys中。(Client将自己的公钥存放在Server上。需要用户手动将公钥copy到server上。这就是在配置ssh的时候进程进行的操作。例如GitHub上SSH keys设置)
2. Server端接收到Client的连接请求后，会在authorized_keys中匹配到Client的公钥pubKey，并生成随机数R，用Client的公钥对该随机数进行加密得到pubKey(R)
，然后将加密后信息发送给Client。
3. Client端通过私钥进行解密得到随机数R，然后对随机数R和本次会话的SessionKey利用MD5生成摘要Digest1，发送给Server端。
4. Server端会也会对R和SessionKey利用同样摘要算法生成Digest2。
5. Server端会最后比较Digest1和Digest2是否相同，完成认证过程。

如下：

    ```shell
    $ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    $ chmod 0600 ~/.ssh/authorized_keys
    ```
    
ssh-keygen是用于生产密钥的工具。

&nbsp;　　-t：指定生成密钥类型（rsa、dsa、ecdsa等）
&nbsp;　　-P：指定passphrase，用于确保私钥的安全
&nbsp;　　-f：指定存放密钥的文件（公钥文件默认和私钥同目录下，不同的是，存放公钥的文件名需要加上后缀.pub）

### 配置host

### 配置Ulimit

### iptables配置

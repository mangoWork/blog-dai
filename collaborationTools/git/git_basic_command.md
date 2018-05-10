## git中常用的命令
### 1. 分支
*		查看远程分支   git branch -a
  *	查看本地分支	  git branch

### 2. git pull  origin 与git fetch的区别？
* git pull 相当于从远程获取最新版本并且merge到本地

  * git pull origin master（相当于git fetch和git merge)


  * git fetch 相当于是从远程获取最新到本地，不会自动merge
      * git fetch origin
      * git merge origin/master
  * git fetch操作包含了两个关键的步骤：
  * 创建并且更新所有的远程分支的本地分支
  * 设置当前分支的FETCH_HEAD为远程服务器的分支
  * git fetch origin branch1：branch2
  * 首先执行上面的fetch操作
  * 使用远程branch1分支在本地创建branch2（不会切换到该分支）
  * 如果本地不存在branch2分支，则会自动创建一个新的branch2分支。
    * 如果本地分支存在，并且是“fast forward”，则会合并两个分支，否则，会阻止以上操作
    * git fetch origin：branch2相当于git fetch origin master：branch2

### 3. git删除已经add的文件

* 使用git rm --cached “文件路径”，该命令将不会删除物理文件，仅仅会将该文件从缓存中删除
* 使用git rm --f “文件路径”，不仅将该文件从缓存中删除，还会将物理文件删除
* tips：
  * git reset HEAD ：清空版本库内容暂存区（慎用）
  * git rm --cached "文件"：只是将特定文件从暂存区删除

### 4. git撤销提交

* 先使用git log查看commit日志，提交的commit的哈希值
* 使用命令  git reset --hard commit_id  进行回退

### 5. git缓存当前工作

* `git stash` 可以用来缓存当前正在进行的工作，比如想pull最新代码的时候，又不想加新的commit，这时候就可以缓存当前工作。
* `git stash`
* `do some work`
* `git stash pop`
* 当你多次使用git stash的时候， 你可以使用`git stash list`打印当前git栈信息，找到对应的版本号就可以了，`git stash apply stash@{1}`

### 6. git合并commit

* 可以使用git rebase -i  commitid  以及使用git commit --fixup commitid

* git commit --fixup:

  * 提交

    ```shell
    git commit --fixup 54321
    ```

  * 开发工作完成后，待推送/评审的提交中出现大量的包含“fixup!”前缀的提交该如何处理呢？

    如果你执行过一次下面的命令，即针对错误提交 54321 及其后面所有提交执行交互式变基（注意其中的 `--autosquash` 参数），你就会惊叹 Git 设计的是这么巧妙：

    ```shell
    git rebase -i --autosquash 54321^
    ```

    ​


### 7. 撤销对某一个文件的修改

* 场景：修改了a、b文件为列，假设需要撤销文件a的修改，则修改后的两个文件：
* 如果没有被git add到索引区
  * **git checkout a**便可以撤销对文件的修改
* 如果被git add到索引区，但没有做git commit提交
  * 使用git reset将a从索引区移除（但是会保留在工作区）
    * git reset HEAD a
  * 撤销工作区文件a的修改
    * git  checkout a
* 如果被提交了，则需要先回退当前提交到工作区，然后撤销文件a的修改
  * 回退当前提交到工作区
    * git reset HEAD^
  * 撤销工作区中文件a的修改
    * git checkout a

### 8. git回退版本，删除commit

* `git reset`有三种命令方式：分别为:
  * `git reset --mixed`: 此为默认方式，不带任何参数，即使用这种方式，它回退对应的commit和index（索引）中的信息
  * `git reset --soft`:回退某个版本，只回退commit信息，不会回退索引(index)，如果还需要提交，则直接commit即可。
  * `git reset --hard`:彻底回退到某个版本，本地源码也会变为上一个版本的内容。
* 相应的示列：
  * git reset HEAD^    回退所有内容到上一个版本
  * git reset HEAD^ a.py   回退a.py这个文件的版本到上一个版本  
  * git reset –-soft HEAD~3   向前回退到第3个版本  
  * git reset –-hard origin/master   将本地的状态回退到和远程的一样  
  * it reset 057d   回退到某个版本  
  * git revert HEAD   回退到上一次提交的状态，按照某一次的commit完全反向的进行一次commit  


### 9. git向多个远程仓库push？

* 向本地git仓库添加对应的远程仓库地址，并且为远程地址命名

  ```shell
  git remote add gitee  git@gitee.com:daiqiaobing/mango-blog.git
  git remote add origin  git@gitee.com:daiqiaobing/mango-blog.git
  git push origin dlm
  git push gitee dlm
  ```

### 10. git修改commit中的提交说明

```shell
git commit --amend
```




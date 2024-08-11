# Git相关

## 介绍

Git 是一个版本控制工具。可以<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**记录和追踪**</span> 某个文件 在某一个时刻的内容和状态。

> Git 可以 <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**记录某个文件夹下的 不同文件 在不同时间节点的不同状态。Git可以去记录这些文件产生的变化**</span>

发展历史：Linus，为了管理Linux的核心代码而开发的一个分布式的版本控制工具。

Git的特点：

-  分布式
-  离线可用
-  可以回退

工作机制：

3个区+远程库：工作区（写代码，删掉代码无历史记录）；暂存区（添加暂存区：git add ；临时存储也可以删掉，无历史记录）；本地库（提交本地库：git commit;提交到本地库时会生成历史版本）；远程库（由本地库推送到远程库，push）

Git和代码托管中心：基于网络服务器的远程代码仓库。远程库=代码托管中心；托管中心分类：局域网（Gitlab）和互联网(Github,Gitee)

安装：GNU协议；安装路径要求非中文，最好无空格；Git LFS:large file support大文件支持；编辑器选择Vim;分支名字是master;修改环境变量use Git Bash only只在Git里修改，默认的是会在cmd命令行里可以修改；换行符：CRLF（windows系统）和LF（Linux系统）；credential helper 凭据管理器，选择跨平台的；enable file system caching 使用文件缓存机制；enable symbolic links 使用符号连接，软连接

## Git的使用

### Git核心流程

本地仓库：远程仓库在本地的一个映射，我们看不见摸不着。磁盘下就是这个本地仓库

暂存区：看不见摸不着

工作空间：用户可以直接操作的空间

![image-20230901203603263](.\assets\image-20230901203603263.png)

### Git 命令

| 命令名称                               | 作用           |
| -------------------------------------- | -------------- |
| `git config --global user.name 用户名` | 设置用户签名   |
| `git config --global user.email 邮箱`  | 设置用户邮箱   |
| `git init`                             | 初始化本地库   |
| `git status`                           | 查看本地库状态 |
| `git add 文件名`                       | 添加到暂存区   |
| `git commit -m “日志信息” 文件名`      | 提交到本地库   |
| `git reflog`                           | 查看历史记录   |
| `git reset --hard 版本号`              | 版本穿梭       |

#### 注册相关网站

以Gitee为例。

- 记住注册的时候 使用的 
  - 用户名
  - 密码
  - 邮箱(可以注册后自行设置)

#### 建立远程仓库

![image-20230901203646368](.\assets\image-20230901203646368.png)

#### `clone`

把远程仓库克隆到本地（一定是第一次）

```shell
# 下载远程仓库的内容，并且在本地创建一个和远程仓库名同名的文件夹
git clone https://gitee.com/common-zhou/test_50th.git

# 下载到指定的文件夹中。文件夹需要是个空目录；或者这个文件夹不存在。都可以
git clone https://gitee.com/common-zhou/test_50th.git test_50th2

git clone https://gitee.com/ciggar/test-40th.git dirName
```



在git中管理文件的版本，需要使用文本文件。

.txt .md ;  不要使用docx pptx

#### `status`

这个命令可以帮助我们查看工作区和缓冲区中的变化。

<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**工作区中的变化**</span>

<span style='color:green;background:yellow;font-size:文字大小;font-family:字体;'>**缓冲区中的变化**</span>

![image-20230901203705532](.\assets\image-20230901203705532.png)

#### `add`

这个命令可以帮助我们把工作区中的变化提交到缓冲区。

```shell
# 有以下的三种提交方式

# 文件的名字
git add fileName

# 文件的类型，通配符添加
# 只添加 .java文件结尾的文件 。从工作空间提交到缓冲区
git add *.java

# 所有文件
git add .
```

#### `commit`

`git commit`一定要写`-m`并且提交信息不能为空。

`commit`这个命令可以帮助我们把`git`仓库中 缓冲区中的内容提交到本地仓库。

<span style=color:red;background:yellow>**第一次提交的时候，需要设置 用户名和邮箱**</span>

有两种设置的方式

- 直接去用户目录下，设置` .gitconfig `这个文件,假如没有这个文件，就创建一个

  ```ini
  [user]
  	name = ciggar
  	email = 291136733@qq.com
  ```

- 执行命令去设置

  ```shell
  git config --global user.email 222@qq.com
  
  git config --global user.name xxx
  ```

设置完之后，就可以提交了，会产生一个版本信息

![image-20230901203729352](.\assets\image-20230901203729352.png)

这一步需要大家注意几件事情：

- 这一步会产生一个文件的版本号，只是前7位。
- 如果是第一次`commit`，需要设置用户名和邮件地址
- 只会把缓冲区中的变化提交到本地仓库，不会把工作区中的变化提交到本地仓库
- `commit` 的时候需要指定提交的信息，提交的信息一般要去设置模板



```shell
# 提交
git commit -m "msg"
## msg:msg信息一般要有统一的格式 例如：描述信息 (issue号)
# 1.描述信息 (issue号)
# 2.(issue号) 描述信息

git commit -m "某某bug的修改"
git commit -m "HashMap的练习"

# 尽量做到，见到描述信息可以知道这次提交是干什么的。
# 不要写什么 1 abc 
```

- 设置完之后，就可以提交了，会产生一个版本信息

![image-20230901203801264](.\assets\image-20230901203801264.png)

#### `push`

![image-20230901203816265](.\assets\image-20230901203816265.png)

`push`这个命令可以帮助我们把本地仓库中的<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**所有变化**</span> 推送到远程仓库。

- 这一步在第一次操作的时候，需要去填写对应用户名和密码

![image-20230901203828780](.\assets\image-20230901203828780.png)


> `push`的时候，能不能指定文件去 `push`呢？ 不能

> 只有当本地仓库中的版本领先于远程仓库的时候，才可以`push`

#### `pull`

会拉取远程仓库中的所有的变化到本地。并且会显示出版本号

![image-20230901203840937](.\assets\image-20230901203840937.png)

> 当本地仓库中的版本落后于远程仓库的时候，就要pull
>
> “ 落后就要pull”

#### `log`

查看仓库中的所有的版本信息

![image-20230901203853180](.\assets\image-20230901203853180.png)

>一些命令行
>
>`cd `进入文件夹

### 协作开发

#### 邀请成员加入仓库

> 不管是 开源的仓库，还是私有的仓库，都是 只有仓库中的成员才能去修改仓库中的代码。
>
> -  开源：所有人都可以访问到
> -  私有：只有仓库指定的成员才能看到

![image-20230901203913191](.\assets\image-20230901203913191.png)

#### 处理冲突

领先才能`push`,落后才能`pull`

[冲突处理·流程图]

模拟冲突处理流程：

![image-20230901203929074](.\assets\image-20230901203929074.png)

> 总结：
>
> 1.  先`push`的人不处理冲突，后`push`的人要处理 冲突
> 2.  和组员一起开发的时候，尽量不要开发同一个文件，很容易产生冲突
> 3.  `push`之前最好先`pull`一下，不然可能会`push`失败
> 4.  - 早上上班之后，第一件事情，拉取最新的代码（`pull`）
>     - 晚上下班之前，最后一件事情，把最新的本地代码推送上去（`push`）。<span style=color:yellow;background:red>**代码一定要能编译通过**</span>

`Vim`怎样使用

```tex
1.点击i 表示是编辑。才能输入
2.保存的时候，怎么保存呢？
 点击esc; 输入一个冒号  shift+: (英文状态下) ; 输入wq（保存并退出）
```

冲突的处理

```JAVA
<<<<<<<< HEAD
    
===============
 
>>>>>>>>> fgfskljasdljdlkasjksalk
    
    
// 左到=。就是你自己的代码版本   <<<<<<<<<       -->        ============
    // =到>  是远端的版本      =========       -->        >>>>>>>>>>>>
    
需要告诉git，如果保留代码。 比如是留你的版本，还是留你同事版本。 
 1.留代码
 2.删除分隔符
 3. 处理好所有的冲突之后， git  add . ;  git commit -m "处理和同事1的冲突"
 4. push 。 需要抓紧push，防止别人又push了代码 
```

### 后悔药

Git给我们提供了一些可以回退的措施，也叫作后悔药。

![image-20230901203957670](.\assets\image-20230901203957670.png)

- `git checkout`

  > 需要指定需要**回退**的文件
  >
  > chenckout后面的内容和add一样
  >
  > ```shell
  > $ git checkout text.txt
  > $ git checkout .
  > ```

  <span style=color:red;background:yellow>**这个命令，危险吗？ 危险！慎用**</span>

  > 注意：回退的内容，是找不回来的，要慎用

- `git reset`

  > <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**把缓冲区中的变化，回退到工作区。注意：git reset不会改变文件中的内容**</span>

  > 问题：能不能指定文件reset呢？ 能

- `git reset --hard  version`

![image-20230901204023706](.\assets\image-20230901204023706.png)

### 忽略文件

git在做版本控制的时候，可以让我们忽略一些文件，不去追踪这个仓库中这些文件的变化。

怎么做呢？

- 可以在Git仓库的根目录下 添加 一个 `.gitignore` 这个名字的文件，可以在这个文件中声明哪些文件不被git追踪版本信息

对于Java项目来说，我们可以忽略哪些内容呢？

```ini
# 单个文件
xxx.txt

# 配置文件夹
.idea

# 配置文件的类型
*.iml

target/*.class
```



> 注意事项：
>
> 1. 忽略文件最好是在创建这个远程仓库的时候，就应该自动创建出来
>
> ![image-20230901204046127](.\assets\image-20230901204046127.png)
>
> 2. <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**一旦一个文件已经被追踪并且提交到远程仓库中去了，那么再在.gitignore 这个文件中去忽略它的变化，是无效的**</span>

## 分支管理

Git分支是Git版本控制系统中的一种重要概念，用于在同一个Git仓库中**独立开发**多个功能或特性。在Git中，每个分支都代表着仓库中的一个完整版本，并且可以在分支上进行独立的开发和提交。

使用分支的好处是可以让多个人在同一个仓库中同时进行开发，不会相互干扰，同时也可以随时回到之前的某个状态进行修复或重新开发。当一个分支的开发完成后，可以将其合并到主分支或其他分支上。

Git默认创建一个主分支，通常称为“master”或“main”，其他分支可以基于主分支或其他分支创建，每个分支都有一个唯一的名称。在开发过程中，可以在不同的分支之间进行切换，以便进行不同的工作。例如，可以创建一个分支来解决某个bug，同时在另一个分支上开发一个新的功能，而不会影响彼此之间的工作。

总之，Git分支是一种非常有用的功能，可以帮助开发人员更好地管理代码并提高开发效率。

![image-20230901204100881](.\assets\image-20230901204100881.png)

分支操作

```shell
# 查看所有分支
$ git branch

# 创建分支并切换 iss53
$ git checkout -b iss53

# 切换分支
$ git checkout iss53

# 合并分支
$ git merge iss53
```

<span style=color:red;background:yellow>**工作过程中的一般使用步骤**</span>

```SHELL
#  一般会有一个master 主分支
#  会有一个dev分支

# 1. 如果有需求，会从dev拉一个分支，比如 dev-feature1，所有的提交都提交在这个分支上
# 1.1 从dev拉取一个分支，并切换到这个分支
git checkout -b dev-feature1

# 2. 等到开发完成，会把这个分支合并到dev。 dev经过测试，会合并到master
# 2.1先切换到dev分支
git checkout dev 

# 2.2合并刚刚的分支
git merge dev-feature1
```

### `git merge`

[Git Merge | Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/using-branches/git-merge)

![image-20230905144951568](E:\0.王道训练营\3.我的Daily笔记\FS复习笔记\assets\image-20230905144951568.png)

## 在idea上进行git操作

首先配置好git路径

![image-20230901204121036](.\assets\image-20230901204121036.png)

点击Test有版本。

<font color=red>**如果项目被git追踪了，则idea中会有对应的颜色提示。**</font>

红色代表是新增的文件

蓝色代表是文件有改动

绿色代表已经提交。其他的操作与git基本操作一致。

在文件中，可以看到文件的变动

git可以右键，然后add commit 提交信息。



**常见问题**

如果在git配置中报错fatal: Authentication failed for ''，其实就是**凭证失败**的意思

解决办法如下：[凭证失败解决](https://www.bbsmax.com/A/l1dygQ3bJe/)
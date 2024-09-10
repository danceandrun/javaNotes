# Git相关

## 介绍

Linus 的第二个伟大作品。2005年由于BitKeeper软件公司对Linux社区停止了免费使用权。Linus迫不得己自己开发了一个分布式版本控制工具，从而Git诞生了。 据说Linus花了两周时间自己用C写了一个分布式版本控制系统，这就是Git。一个月之内，Linux系统的源码已经由Git管理了。



Git 是一个版本控制工具。可以<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**记录和追踪**</span> 某个文件 在某一个时刻的内容和状态。

Git的使用有点像一个 网盘，这个网盘大家都可以来操作。只是Git比网盘要高级一点，体现在哪里呢？其实就是Git可以追踪这个`网盘` 中 文件的历史版本状态。

> Git 可以 <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**记录某个文件夹下的 不同文件 在不同时间节点的不同状态。Git可以去记录这些文件产生的变化**</span>



发展历史：Linus，为了管理Linux的核心代码而开发的一个分布式的版本控制工具。

Git的特点：

-  分布式
-  离线可用
-  可以回退

Git和SVN的对比

- Git：分布式版本控制工具
- SVN：集中式版本控制工具

## 安装Git

### 下载

[官方下载地址](https://git-scm.com/downloads)

### 安装

直接傻瓜式安装即可。

安装的时候，要注意 让Windows 记住登录凭证

## Git的使用

### Git核心流程

本地仓库：远程仓库在本地的一个映射，我们看不见摸不着。磁盘下就是这个本地仓库

暂存区：看不见摸不着

工作空间：

### Git 命令

#### 注册相关网站

以Gitee为例。

- 记住注册的时候 使用的 
  - 用户名
  - 密码
  - 邮箱(可以注册后自行设置)

#### 建立远程仓库



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


#### `push`

`push`这个命令可以帮助我们把本地仓库中的<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**所有变化**</span> 推送到远程仓库。

- 这一步在第一次操作的时候，需要去填写对应用户名和密码




> `push`的时候，能不能指定文件去 `push`呢？ 不能

> 只有当本地仓库中的版本领先于远程仓库的时候，才可以`push`

#### `pull`

会拉取远程仓库中的所有的变化到本地。并且会显示出版本号

> 当本地仓库中的版本落后于远程仓库的时候，就要pull
>
> “ 落后就要pull”

#### `log`

查看仓库中的所有的版本信息

>一些命令行
>
>`cd `进入文件夹

### 协作开发

#### 邀请成员加入仓库

> 不管是 开源的仓库，还是私有的仓库，都是 只有仓库中的成员才能去修改仓库中的代码。
>
> -  开源：所有人都可以访问到
> -  私有：只有仓库指定的成员才能看到

#### 处理冲突

领先才能`push`，落后才能`pull`

[冲突处理·流程图]

模拟冲突处理流程：

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
  >

- `git reset`

  > <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**把缓冲区中的变化，回退到工作区。注意：git reset不会改变文件中的内容**</span>

  > 问题：能不能指定文件reset呢？ 能

- `git reset --hard  version`

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
> 2. <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**一旦一个文件已经被追踪并且提交到远程仓库中去了，那么再在.gitignore 这个文件中去忽略它的变化，是无效的**</span>

## 分支管理

Git分支是Git版本控制系统中的一种重要概念，用于在同一个Git仓库中**独立开发**多个功能或特性。在Git中，每个分支都代表着仓库中的一个完整版本，并且可以在分支上进行独立的开发和提交。

使用分支的好处是可以让多个人在同一个仓库中同时进行开发，不会相互干扰，同时也可以随时回到之前的某个状态进行修复或重新开发。当一个分支的开发完成后，可以将其合并到主分支或其他分支上。

Git默认创建一个主分支，通常称为“master”或“main”，其他分支可以基于主分支或其他分支创建，每个分支都有一个唯一的名称。在开发过程中，可以在不同的分支之间进行切换，以便进行不同的工作。例如，可以创建一个分支来解决某个bug，同时在另一个分支上开发一个新的功能，而不会影响彼此之间的工作。

总之，Git分支是一种非常有用的功能，可以帮助开发人员更好地管理代码并提高开发效率。

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

## 在idea上进行git操作

首先配置好git路径

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

# 前端

学习目标

- 了解前端三件套(HTML、CSS、JS)在前端所起的作用
- 掌握HTML标签的功能，掌握重要标签(a标签，form标签)
- 了解CSS
- 了解JS的基础语法
- 掌握Vue的基础语法
- <span style=color:yellow;background:red>**重点掌握Vue项目怎么启动项目**</span>
- 掌握前后端分离是什么。前端做什么事情，后端做什么事情



前端负责页面的展示。 后端负责提供数据。 

## 启动一个自己的服务器

启动ServerSocket。监听端口8080端口

输入`http://localhost:8080/file?name=1`

`http://localhost:8080/file?name=1`

## 在淘宝页面输入手机，发生了什么事情

<span style=color:red;background:yellow>**在淘宝上搜索手机，其实就是淘宝帮我们封装了一次请求。**</span>

`https://s.taobao.com/search?q=手机`

本质上和我们自己通过url来访问没有区别。

## 输入url，发生了什么

前端发送了一个请求，给谁？给淘宝的服务器。  

`https://s.taobao.com/search?q=手机`

## url有几部分构成

`https://s.taobao.com/search?q=手机`

1.协议部分：  http/https

2.域名  或者  ip+端口。 用来做什么事情的？ 用来找哪台服务器为我们提供服务。端口是用来确定程序的。

​			默认端口； http 默认端口80； https 默认端口443

3.服务器内部路径。一直到?前面（确定程序需要做的事情）

4.参数： ?后面的部分。比如想搜索手机，搜索其他的，需要传递参数。



q=手机  ---》 键值对数据

如果是有多个参数，使用&来进行分割。 username=zhangsan&password=admin



https://www.taobao.com/

http://localhost:8080/login?username=root&password=root1

```
http://localhost:8080/file?name=1.txt 
```



## 概述

- 前端：又称web前端，网站的前台部分，运行在浏览器，<font color=red>**给客户浏览的网页。**</font>
- 后端：管理和处理数据的。前端页面上展示的数据，都是后端给的。


前端：前端怎么布的局，能放几个商品，商品怎么展示。价格的颜色。图片的大小......

后端：这个手机的图片，手机的价格。手机的型号参数......

## 学习相关

```JAVA
// 学习前端的目的:
// 1, 知道前端是怎么回事 
// 2, 前端和后端的关系
// 3, (学的比较好) 如果给你一份前端代码, 你能改一改
// 4，知道Vue项目怎么启动起来

// 学习的方法
// 1, 上课能听懂
// 2， 作业会课上讲
```

前端需要学习的东西

```` java
// HTML,CSS,JavaScript: 写网页的技术

// HTML：用于搭建基础网页，展示页面的内容
// CSS：用于美化页面，布局页面
// JavaScript：控制页面的元素，让页面有一些动态的效果
````

为什么不用最新版本？

```JAVA
// jdk  1.8       20 21
// 有没有企业用 20 21的？
没有！
// 稳定，不出bug
    
// 新资料少。旧版本，解决问题多，所以文档也多。
    
// toB   toC 
// to bussiness ： 面向企业。 版本多   1.3 1.4 1.5 1.6 1.7 1.8
    // 1.6 有三百多个小版本   1.6.001  1.6.201 1.6.205
    // 1.8 的版本了。  
// to customer : 用户量大 。 代码的版本  少
```

# HTML

## HTML基本概念

``` JAVA
HTML概念
    HTML(hyper text markup language)超文本标记语言
    是一个以.html为后缀的文本
    是一个文本,也是一个网页;该文本可以用浏览器打开
    '超文本':包含文本字体,图片,链接,甚至音乐,程序等元素的文本
    HTML 是一个使用'标签'来描述网页的文本 (标签在HTML文本中有实际意义)
  
//  超文本标记语言:  
//    首先是一个语言
//    文本语言   
//    用标签/标记  描述的文本语言

<元素>: 标签
    
```

## 快速入门

1. html文档后缀名` .html `或者 `.htm`
2. 标签分为。使用尖括号包括的起来的东西
  1. 围堵标签：有开始标签和结束标签。如` <html>` 开始标签 `</html> `结束标签
  2. 自闭合标签：开始标签和结束标签在一起。如 `<br> <hr>`

3. 标签可以嵌套：
    需要正确嵌套，不能你中有我，我中有你
    错误：`<a><b></a></b>`
    正确：`<a><b></b></a>  `

4. 在开始标签中可以定义属性。属性是由键值对构成，值需要用引号(单双都可)引起来
5. html的标签不区分大小写，但是建议使用小写。  



```html
<!DOCTYPE HTML>
<html>

	<head>
		<title>我是title</title>
	</head>
	<body>

		<div>亮剑--演员表</div>

		<hr  width="800px" align="left" noshade="noshade"/>

		李云龙-李幼斌 <br />
		赵刚-何刚

	</body>

</html>
```

注释

```JAVA
<!--我是个注释 -->
```

## 重要的body标签

`html`是一个整体都是由标签描述的文本, 所以我们研究`html`就是研究`html`不同语法标签(body部分比较重要)

### hr标签

```JAVA
<hr>:是一个横线标签,  单标签
  
属性:
  size:高度( 厚度,不同于height,不带单位时--默认px)
  width:宽度(不带单位时--默认px)
    候选值： {value}/ {value}px，代表多少个像素。
    				{value}% 占父元素的百分比
  noshade:颜色是否有阴影(纯色)
  align:对其方式。
    候选值:center left right
```

### br标签

```JAVA
<br>： 换行符，单标签
  
  在html里，直接回车换行，没有效果。   只会变成一个空格
  多个空格，也是没有效果的。						也只会变成一个空格。
  
```



**一些常见的特殊字符**

| 显示结果 | `HTML`代码 | 描述     |
| -------- | ---------- | -------- |
| 空格     | `&nbsp;`   | 空格     |
| >        | `&gt;`     | 大于符号 |
| <        | `&lt;`     | 小于符号 |
| &        | `&amp;`    |          |



### h1-h6标签

```java
<h1><h2><h3><h4><h5><h6>: 标题标签
  
属性
    align
        Left:左对齐内容（默认值）
        Center:居中对齐内容
        Right:右对齐内容
    
注意1: 自定义标签
    h0, h7, h8: 自定义标签, 自定义标签没有任何特殊效果, 等价于span标签
        
注意2: h1在一个html页面上可以出现一次, h2-h6可以在一个html页面上出现多次   
```

### div标签

```java
<div>: 给页面进行分区或者节/块
    会自动换行。
```

### span标签

```JAVA
<span> ：行内进行分块的
```

div是个大容器。span是个小容器。

### p标签

```java
<p>: 段落标签
    
注意: 段落一般用来描述大段文字, 很类似div的使用, 只不过段落会自动的在段前/段后加上一部分段落间距
```

### ==a标签==

```java
<a>超链接标签

    <a href="https://www.baidu.com" target="_blank">baidu</a>
属性:
   href: 指向要打开页面的的url
   target: 新页面的打开方法
```

```java
target
_blank:在新窗口打开
_self:它使目标文档显示在超链接所在框架或者窗口中
同组值:通过单击一个窗口中的不同链接控制另一窗口内容变化 ; 浏览器会找与target值相符的框架或者窗口中的文档，有则在其中显示文档。如果不存在，浏览器打开一个新窗口
    
         <a href="https://www.taobao.com" target="_self">taobao_self</a>
        <a href="https://www.taobao.com" target="_blank">taobao_blank</a>

```



```HTML
<!--点击taobao_aaa的时候，会让iframe这个架子里面的内容发生变化-->

<a href="https://www.taobao.com" target="aaa">taobao_aaa</a>
<iframe name="aaa" width="600px" height="600px"></iframe>
```



### img标签

```java
<img> 图片标签
    
<img src="./1.webp" alt="图片加载失败..">
属性: src用来指示图片的加载路径: 相对路径,	 绝对路径
    
    有一些网站，不想你访问它的图片。
```

不能访问的

`https://lmg.jj20.com/up/allimg/tp09/210Z614150050M-0-lp.jpg`

可以访问的

`https://www.ssfiction.com/wp-content/uploads/2020/08/20200805_5f2b1669e9a24.jpg`

`https://img1.baidu.com/it/u=3573056321,2239143646&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500`

### <font color=red>**路径问题**</font>



````java
// Java路径
// 相对路径: ./  ../   ../../
// 绝对路径: C:\Users\snow\Desktop\Day11_HTML

// 前端路径
// 相对路径:  ./  ../   ../../
// 绝对路径:  http://localhost:63342/code/com/cskaoyan/www/html/1.webp
  
  
// 路径描述
//   1.如果直接写路径，比如 father1/children1/2.jpg。则代表从当前文件目录开始，然后找father1文件夹，再找childre1文件夹，最后找2.jpg
//   等价于  ./father1/children1/2.jpg
// ./代表当前路径
// ../代表当前路径上一级
// 可以组合。  ../../代表上一级目录的上一级

即使我们在前端中写了相对路径, 这个代码被浏览器解析之后, 也要变成url(前端的绝对路径)

本质: 前端代码是运行在用户的计算机上,    后端代码是运行在我们自己的服务器上
````



### ol和ul标签

```java
<ol> 有序列表, 成套标签, 和<li>标签构成一套标签
<ul> 无序列表, 成套标签, 和<li>标签构成一套标签
 
ol属性:
  type:规定在列表中使用的标记类型(1,A,a,I,i)。
  start:规定有序列表的起始值
  reversed:规定列表顺序为降序。(9,8,7...)  
  
ul属性:
    type:
        disc:默认值。实心圆。
        circle :空心圆。
        square :实心方块。
```

### table标签

```java
<table>表格标签, 成套标签,  tr, td
<tr>表格的一行
<td>一行中一个单元格
    
属性:
    table的属性
            bgcolor: 背景颜色
            border ： 1、2  代表边框的像素
            cellpadding:规定单元边沿与其内容之间的空白。
            cellspacing:规定单元格之间的空白。
    tr的属性:
            bgcolor
            valign:规定表格行中内容的垂直对齐方式。
                    top
                    middle
                    bottom
    td的属性:  
            colspan:横跨列数
            rowspan:横跨行数
```

### input标签:  表单元素

```java
<input>输入框
    
属性:
Type
        text:默认文本
        password:密码
        button:按钮
        hidden:隐藏输入框
        radio:单选框
            
        reset:定义重置按钮。
        submit:提交  
```

### textarea标签: 表单元素

```java
< textarea > : 多行输入框
    
属性:    
    cols:列
    rows:行
    placeholder:提示
```

### select标签: 表单元素

```java
< select >: 下拉选择, 和<option>是成套标签
    
属性
option:selected(selected="selected"选中状态)
select :multiple(multiple ="multiple" 允许多选)
select :size(size ="4"下拉可见数4)
```

### <font color=red>**==form标签==**</font>

表单元素，都要通过form标签，把这些数据组织起来。



```java
<form>表单, 用来在浏览器的网页上, 通过用户输入或者点击, 生成一个url, 让浏览器根据这个url发起请求。
  用于采集用户输入的数据的，用于和服务器进行交互。比如登录页面，注册页面。
// url分为四部分: 协议,  域名or ip+端口,   服务器内部路径,   参数
  
属性：
  action: 指定提交数据的URL
  method：指定提交方式
    分类：一共七种，常用的两种，get post

 https://www.baidu.com/s?wd=java   
```



```java
// 在一个form表单中可以生成一个url给浏览器, 让浏览器根据这个生成的url发起请求
// url分为四部分: 协议,  域名or ip+端口,   服务器内部路径,   参数

// 1, form表单可以根据form标签的action构建除了参数以外前三部分urL(协议,  域名or ip+端口,   服务器内部路径)
// 2, 对form表单来讲url中的参数是由form表单里面的表单元素构成(input, textarea, select)
//    表单构成的key-value数据:  key的构成是由表单元素的name属性构成,  value是由表单元素的value属性构成(表单元素的value又是用户在表单元素上输入/选择的内容)

<form action="https://s.taobao.com/search" method="get">
    <input name="q">

    <input type="submit">
</form>

```

#### http请求方式get和post的区别: 

get和post的区别:
1, get请求'一般'把请求参数放到url之后，POST请求'一般'把参数放到请求正文里。url之后拼接参数最多1kb
2, get请求不安全,  post请求相对安全一些
3, 语义化区别： get请求一般用来获取数据,  post请求一般用来提交数据




























































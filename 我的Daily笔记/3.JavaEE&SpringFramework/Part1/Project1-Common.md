# 接口说明

接口的开发分为了两部分

- 小组开发接口 54个  基本上都是些简单接口
- 个人开发接口 15个  接口会复杂一些

以小组6人为单位的话，每个人开发的接口数 24（=54/6+15）



个人开发接口，每个人都创建自己的一个应用，在本地即可

小组开发接口，小组共建Git仓库，在Git中协作开发接口

（可以在git中首先各拉一个自己的分支，然后最后采用谁的，就将谁的合并到master上）



【腾讯文档】53th项目一进度表
https://docs.qq.com/sheet/DSlpXUkdKcENUUE1x?tab=o24wqh



**个人接口部分，老师会带着大家写其中的部分接口也会讲其中的注意事项**

# 开发Git

![image-20230405101205117](.\assets\image-20230405101205117.png)

![image-20230405101150639](.\assets\image-20230405101150639.png)

## 创建阶段

这个阶段小组在一起共同完成，有问题及时找老师

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**平时养好使用Git指令的习惯，工作的时候才不容易抓瞎**</span>

小组共建Git仓库，首次使用请使用**git clone**指令

```shell
git clone xxx.git
```

在master主干上搭建起基本的项目结构和公共内容，将这些内容push到远程仓库，

在Gitee上创建分支dev（develop的缩写）

![image-20230316105751948](.\assets\image-20230316105751948.png)

在本地仓库中，先执行pull拉取，再切换到dev分支上

```shell
git pull
git checkout dev (或git checkout -b dev)
```

![image-20230316110430931](.\assets\image-20230316110430931.png)

然后创建各自的个人分支，假如说有changfeng、tianming、yuanzhi、beihai这样的几个开发人员，分别在Gitee创建各自的分支（起点从dev）

![image-20230316110722553](.\assets\image-20230316110722553.png)

创建好的分支如下

![image-20230316110915645](.\assets\image-20230316110915645.png)

然后在本地拉取

```shell
git pull
```

![image-20230316111016782](.\assets\image-20230316111016782.png)

然后各自在自己的本地仓库中切换到自己的分支，比如假如我是长风，那么我就切换到changfeng分支

```shell
git checkout changfeng
```

![image-20230316111500118](.\assets\image-20230316111500118.png)

## 开发阶段

如果是**个人接口**，那么就切换到**自己的分支**上开发

```shell
git checkout changfeng
```

开发完成后，依次执行 `add`、`commit`、`push`命令



如果是**团队协作接口**，在个人分支上的内容都提交之后，切换到**dev分支**上

```shell
git checkout dev
```

然后测试之后保证项目能够启动，然后在进行提交，依次执行add、commit、push命令



## 合并阶段

在个人接口开发完成之后，这时候面临一个问题，相同（类似）的接口有多份，那么最终采用谁开发的这部分个人接口 --> **小组内讨论后选择**

比如选择了长风的内容 作为完整项目中的个人部分，那么我们要做的事情是，在dev上合并changfeng

- 切换到dev分支上
- 合并changfeng分支

```shell
git checkout dev
git merge changfeng
```

![image-20230316113201065](.\assets\image-20230316113201065.png)

`merge`过程有可能出现冲突，正常解决即可

## 常用指令

```shell
git status
git add 要提交到暂存区的变化
git commit -m "提交的消息"
git push
git pull
git checkout 分支名
git branch -a
git merge 分支名
```

# 资料下载

服务器目录

![](.\assets\image-20230901100834147.png)

# 数据库

提供了数据的脚本 → sql文件

/资料/SQL

- table → 建表
- data → 输入数据

![image-20220624204836017](E:\0.王道训练营\3.我的Daily笔记\3.JavaEE&SpringFramework\assets\image-20220624204836017.png)

```sql
-- 也可以使用建表语句建表
CREATE DATABASE `cskaoyan_market` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';
```

![image-20220624205024586](.\assets\image-20220624205024586.png)

![image-20220505112238172](.\assets\image-20220505112238172.png)



# 前端

/资料/前端/

![image-20220505112744861](.\assets\image-20220505112744861.png)

`cskaoyan-market-admin.zip `→ 没有打包的前端代码 → <span style='color:green;background:yellow;font-size:文字大小;font-family:字体;'>**原始代码**</span>

应用.zip → vue打包好的可以直接运行的前端应用程序 → <span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**Web容器中可以直接运行的应用**</span> 

## Tomcat启动前端应用

先复制一个tomcat出来

![image-20230316150413486](.\assets\image-20230316150413486.png)

然后在tomcat2中将前端的应用放到**/webapps/ROOT**中

![image-20230316150613495](.\assets\image-20230316150613495.png)

启动/bin/startup.bat启动tomcat

![image-20230316150710974](.\assets\image-20230316150710974.png)

如果你的前端应用跑不起来 → <span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**删掉tomcat，重新解压一个**</span>

重新解压了还跑不起来 → <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**检查环境变量 JAVA_HOME**</span>

注意你自己的tomcat的<font color='red'>**端口号**</font>是多少

work/Catalina

conf/Catalina

里的内容都是可以删除的

## npm启动前端代码

vue代码 → 查看代码

node-sass → 前端框架中用到的插件

> (c)npm rm node-sass
>
> (c)npm install node-sass
>
> (c)npm rebuild node-sass

调试代码：npm install → npm run dev

如果想要修改也可以 → 需要你自己打包 npm run build:prod

## 使用`jar`包启动（首选这种）

`java -jar frontend.jar`

# Mybatis逆向工程

逆向工程的内容会生成给到大家，可以直接使用

包含数据库表对应的实例类、Mapper接口、映射文件

> 逆向工程生成的条件
>
> `count` : `select count(*)`
>
> `ByExample:` `where `条件
>
> `BySelective` : 操作哪些列

```JAVA
MarketAddressExample example = new MarketAddressExample();
// 增加where
example.createCriteria().andUserIdEqualTo(5);
// 增加order by
example.setOrderByClause("add_time desc");
```


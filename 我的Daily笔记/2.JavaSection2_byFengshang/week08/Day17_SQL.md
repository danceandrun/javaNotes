[toc]

# 数据库构成

## 软件架构

> 在互联网的网络交互和数据访问中,一般常见两种网络架构模式: B/S结构或者C/S结构.
> B/S: Browser-Server即浏览器和服务器, 即通过浏览器和服务器发起网络交互的数据请求.B向S发起请求：http,https。比如常见的电商网站
> C/S: Client-Server即客户端和服务器, 即通过客户端和服务器发起网络交互的数据请求.C向S发起请求：TCP,Socket，自定义协议。比如QQ，微信，LOL等。
>
> C/S中很多数据存在client端，而B/S中数据都来自server
>
> MySql是CS架构的，安装好Mysql在本地一直运行的是Server，我们是  通过Client连接上去的



## MySQL的内部数据组织方式

> 在MySQL中, 我们对数据的组织逻辑上是按照库/表/数据 这种结构组织的.
> 数据库: 表示一份完整的数据仓库, 在这个数据仓库中分为多张不同的表.
> 表: 表示某种特定类型数据的的结构化清单, 里面包含多条数据.
> 数据: 表中数据的基本单元.

学习：

1. 对数据库的增删改查

2. 对表的增删改查
3. 对数据的增删改查

# SQL语言

>SQL：结构化查询语言（Structured Query Language）简称SQL，是一种专门用来和数据库通信的语言，**用于向数据库存取数据以及查询、更新和管理关系数据库系统**。
>与其他语言(Java, C++...)不同的是, SQL由很少的词构成, 这是希望从数据库读写数据时能以更简单有效的方法进行.

<span style=color:red;background:yellow><b>SQL有如下优点</b></span>

>SQL语言不是某个特定的数据库提供的语言, 它是一种数据库<u>标准语言</u>.(最初由美国国家标准局 ANSI于1986年完成第一版SQL标准的定义,即SQL-86).<font color=red><b>这也就意味着每个关系型数据库都支持SQL语言.</b></font>
>SQL简单易学, 是由多个描述性很强的单词构成, 并且这些单词数量不多.
>SQL尽管看上去很简单, 但是非常强有力; 灵活的使用SQL, 可以进行比较复杂的和高级的数据库操作.



# SQL的基础操作
## 登录数据库
>MySQL是C/S架构的软件，所以我们的Server是一直启动着的，我们使用官方提供的客户端去连接Server，然后发送命令给server端执行，server端返回执行结果。

端口3306（有时为了安全会改成33060，33061，33062等）

```shell
$ mysql -uroot -p 
输入密码

$ mysql -uroot -p123456
-- 不建议大家直接吧密码写在控制台上
不建议这样写。因为按上下键，可能能看到你的密码，不安全。
```


```SHEL
-- 大家进入企业里面了。注意用户名和密码。 一般不是root
1sad-jlka-sjdlk-asfjk-ldasjflksdjkl:3306
jkjkgfdjkgf
dsjdlkjsakldj

有个同学入职了。三天不知道怎么连数据库。

root
123456

-- 环境的问题，可以问同事，不要怕。你不知道，也可以先问同学，问老师。
-- 问问chatGPT

-- 也要注意度。 
```



# 库操作

## 查看库
```sql
-- 查看所有数据库
show databases;

-- 模糊匹配查找数据库
show databases like "test%";
-- test% 表示以test开头
-- %info  表示以info结尾
-- %info% 表示 info可以出现在任意位置

-- 查看创建数据库命令
show create database db_name;
-- 查看创建db_name 的SQL语句

`test2`
单引号的作用，标识这是一个普通的文本，不是关键字。
``的位置，在esc的下方，1的左边，注意输入法是英文的。
```


<span style=color:red;background:yellow><b>不要删除默认的自带的库。</b></span>尤其是`mysql` 、`performance_schema` 、`information_schema`

## 创建库
```sql
-- 创建一个叫 db_name 的数据库  
create database db_name;

-- 指定字符集和默认校对规则
create database db_name character set utf8mb4 collate utf8mb4_general_ci;

create database db_name character set utf8mb4 collate utf8mb4_bin;
```

```sql
-- 注意  库名，表名，列名均不区分大小写
-- dbName   db_name
-- 取数据库的名字的时候。要用  下划线进行分割。无论题目怎么要求。
-- create database teacherInfo;  
-- 能不能取这个名字？   MySQL不会给你报错。但是有可能会出现问题
-- 在windows上不区分大小写；在Linux上区分大小写。容易给后续埋下坑。

-- teacherInfo    ——--》 teacher_info
-- 不能这样写
create database teacherInfo;
-- 要用下划线来区分单词
create database teacher_info;
```

<span style=color:red;background:yellow><b>注意 ：库名，表名，列名均不区分大小写，所以如果要区分单词，使用下划线代替。</b></span>

> 比如：希望一个用来存储学生信息的库，应该命名为student_info，而不是studentInfo

阿里编程规范

> MySQL 的字符集（CHARACTER）和校对规则（COLLATION）是两个不同的概念。字符集是用来定义 MySQL 存储字符串的方式，校对规则也可以称为排序规则，是指在同一个字符集内字符之间的比较规则。字符集和校对规则是一对多的关系，每个字符集都有一个默认的校对规则。
>
> 推荐大家使用: utf8mb4 。
>
> mysql里面有一个utf8 ,但是它是三个字节的，有一些四个字节的表示不了。
>
> utf8mb4才是真正的utf-8。

什么是字符集？什么是校对规则？两者区别？

字符集是用来给字符编号的，就是MySQL存储数据的方式。比如现在有一个zhansgan 的字符串，需要存储到MySQL中。因为文件系统中，只能存二进制的。所以需要把zhangsan进行编码，编码之后，才能写入到磁盘里面。

校对规则，用来排序的。比如有一些排序规则区分大小写，有一些排序规则不区分大小写。

abc

Abc

ABc

ABC

如果区分大小写是ABC ABc Abc abc ，如果不区分大小写则是任意一个顺序。



select * from table1  order by name; 



latin1: 是个字符集，<font color=red>**不支持中文。**</font>一个字符集对应很多校对规则，其中有`_ci`,`_cs`。

```
如果大家没有设置字符集的时候，是latin1的字符集。然后不能存储中文。

latin1_swedish_ci (case insensitive)
latin1_general_cs (case sensitive)

区分大小写的 (_cs)
不区分大小写的。(_ci)
```

<span style=color:red;background:yellow><b>注意：</b></span>如果不设置字符集，有可能会使用了默认的latin1，导致存储中文报错。



标准utf8: 使用1-4字节来表示一个字符。 

在MySQL里面有utf8，但是是个假的。3个字节。所以我们一般不用utf8。

utf8mb4 ，一般使用utf8mb4来当做字符集。

默认校对规则： utf8mb4_general_ci。

utf8mb4_bin



```sql
-- 查看所有的字符集
show character set;

-- 查看所有的校对规则
show collation where charset='utf8mb4';
```



## 删除数据库

```sql
-- 删除数据库
drop database db_name ;
```

> -- 不要瞎操作。尤其是工作过程中。删库一定要小心再小心。要留证。
> -- 删库是一个高危动作。 即使有这种操作，也不应该是你来。
> -- 工作过程中，有的要注意留痕。 
> -- 在微信上，找他确认。
> -- 刘总，您刚刚在电话里说，我需要删除某个环境的某个库，我和您确认一下，防止操作错了。
>
> -- 是的。



## 修改数据库

```SQL
-- 修改指定库的  字符集和校对规则
alter database db_name character set utf8 collate utf8_bin;
```

> <font color=red><b>数据库中未提供改库名的操作</b></font>,只提供修改字符集和校对规则。


## 选择数据库
```SQL
-- 使用db_name这个库
use db_name;
```
> 一个MySQL系统中, 管理多个数据库。 我们只有进入对应的数据库中, 才能进一步操作数据库中的数据。
> 因为表都是在库里面的。所以需要进入库中，再对表进行各种操作。

```SQL
-- <注释>

-- 使用两个横线进行注释的时候。后面必须跟空格

# <注释>

/*
  <注释>
*/    
```

><font color=red><b>注意:</b></font> 
>在数据库语句中如果我们需要注释某些内容, 一般有三种方式。
>`--` 注释符(要注意的是`--`之后要有一个空格再接着书写注释内容)
>`#` 注释符 (之后不需要空格)
>`/* */` 注释符 (一般用于多行注释)

# 表操作
在表格级别的所有操作，都必须要在数据库中，所以必须要先选择数据库。
```SQL
-- 选择指定的数据库
use db_name;
```

## 创建表
```SQL
-- create table table_name  -->  固定写法，表格名自己写，多个单词，下划线隔开
-- (column_name column_type [ , column_name2 column_type])  -->  括号里面写有哪些列,以及列类型
--  
create table test_table();


-- 这个SQL相当于创建了一个test1的表。表里面有一列，列名叫id,列类型叫int
create table test1(id int);
```

<span style=color:red;background:yellow;font-size:30><b>列类型</b></span>

- 整数型数字
	- tinyint：1字节。 
	- <font color=red><b>int(integer)</b></font>: 4字节。
	- bigint: 8字节。和long比较像。
- 小数数字
	- float(M,D): 4字节。浮点型
	- <font color=red><b>double(M,D)</b></font>: 8字节。浮点型
	- decimal (M, D),dec: 压缩的“严格”定点数M+2 个字节。定点型。
  浮点数相对于定点数的优点是在长度一定的情况下，浮点数能够表示更大的范围；缺点是会引起精度问题。  
  

M代表的是允许存储的最大位数，D代表是小数位数。也就是留给整数的是 M-D位。如果整数超了，直接报错，如果小数超了，会四舍五入。



```JAVA
float(M,D) 
    // M代表允许存储的最大位数，D代表小数位数。
    // float(5,2) 代表最大存储5位数。最大2位小数。
    // 10.23 可以存进去。
    // 100.13  可以存进去
    // 1000.1  不行。 整数最大3位。
    // 100.333  可以。 四舍五入
    
    
double也是类似。
    但是要注意，它们都是浮点型。 不精确
    
存钱的时候： 如果之前是100.331  千万不能存储成后面100.33 
    
对一些精度要求比较高的数据（货币数据、科学数据），使用DECIMAL 。
    或者使用字符串的形式。
```



在 MySQL 中，定点数以字符串形式存储，在对精度要求比较高的时候（如货币、科学数据），使用 DECIMAL 的类型比较好，另外两个浮点数进行减法和比较运算时也容易出问题，所以在使用浮点数时需要注意，<u>并尽量避免做浮点数比较。</u>

- 日期
	- year：年(YYYY)。
	- time: 时分秒(HH:MM:SS)。
	- <font color=red><b>date</b></font>: 年月日(YYYY-MM-DD)。
	- <font color=red><b>datetime</b></font>: 年月日时分秒。(YYYY-MM-DD HH:MM:SS)。
	- <font color=red><b>timestamp</b></font>: 年月日时分秒。(YYYY-MM-DD HH:MM:SS)。时间戳。   

- 字符串
	- char(M): 定长字符串，设置了长度，无论存储多少长度的字符串，都会占满M。
	- <font color=red><b>varchar(M)</b></font>：变长字符串，<u>会用1-2字节来存储长度。</u>也就是 实际长度+1(2)。<span style=color:red;background:yellow>**最大长度65535字节。**</span>
	
	  > 对于zhangsan来说，首先会把内容存下，还需要存储长度8.
	  >
	  > 建表的时候，要为扩展留一些空间，varchar(5)和varchar(255)占用的空间没有区别。
	
	- text：文本字符串，会用2字节来存储长度。最大长度65535字符，约64K。如果varchar(2000)建议用text.
	- longtext：大文本字符串。会使用4字节存储长度。最大长度2^32，约4G。
	
	  > 数据库中不存过大的文件，存路径。比如我现在有一个电影 3.8G。需要存怎么办？ 把电影，找个电脑存起来，存路径。 `D:/data1/学习.mp4`
	



- <span style=color:red;background:yellow><b>举例：</b></span>
  - 现在有一个学生表，需要存储的信息包括，学生id，姓名，年龄，身高，体重，籍贯，身份证号，联系电话
  - 现在有一个图书信息表，需要存储的信息包括，序号，书名，作者，出版社，出版日期，定价，备注

```SQL
-- 现在有一个学生表，需要存储的信息包括，学生id，姓名，年龄，身高，体重，籍贯，身份证号，联系电话
create table student(
    id int,
    name varchar(200),
    age int,
    height float(10,2),
    weight float(10,2),
    address varchar(500),
    id_card varchar(50),
    phone varchar(50)
);


-- 建表语句的原则。应该留有一定扩展性。

varchar(2) varchar(5) varchar(10) varchar(50) varchar(200) 
写得多，并不一定会直接占用那么多。 varchar(5)。建表的时候留有扩展空间，防止后续数据量变大了之后，频繁去改表。
所以在最开始创建表的时候，直接写大一点点。

-- 现在有一个图书信息表，需要存储的信息包括，序号，书名，作者，出版社，出版日期，定价，备注

create table book(
    id int,
    name varchar(200),
    author_name varchar(200),
    press varchar(200),
    publication_date date,
    price decimal(10,2),
    comment text
);

-- 有一些字段，可以根据上下文进行推断，所以我们也可以做一点省略
-- 比如在书这张表里，出现了name，我们会直接认为name是书的名字，不会认为是作者或者其他人的名字，所以可以省略一点点。
-- book_name
-- 可以根据上下文推断。

class Student{
    String studentName;
    String name;
    String teacherName;
}
```

## 删除表
```sql
-- 删除名为table_name的表
drop table table_name;
```
## 查看表

```sql
-- 查看表格结构(有哪些列)
desc table_name;
describe table_name;
```



```sql
-- 查看所有表
show tables;

-- 查看表的创建语句。获取出来的语句，可以直接运行，（改改表名）
show create table table_name;
```

- <span style=color:red;background:yellow><b>举例：</b></span>
	- 查看学生表创建语句
	- 查看图书表创建语句。有哪些列
## 修改表

知道有这个东西就可以了，但是在工作中，如果有这种需求，你不要去操作。在自己的数据库上练习一下无所谓。

```sql
-- 添加列
alter table table_name add column column_name column_type;

-- 删除列
alter table table_name drop column column_name;

-- 修改某列的类型
alter table table_name modify column column_name column_type;
```



```sql
-- 修改表名
rename table old_table_name to new_table_name;
alter table old_table_name rename to new_table_name;

-- 修改表字符集 排序规则
alter table table_name character set utf8mb4 collate utf8mb4_bin;
```

不要觉得它非常简单，可以无脑冲。

是不是能够直接，把SQL准备好，然后拿上SQL就上生产环境去执行SQL了。

我一执行SQL，SQL一直卡着。客户这边也卡着。内部的锁造成的。

凌晨去执行。

## 关于字符集和校对规则的说明

有四个层次的字符集和校对规则。

```JAVA
// 数据库服务层面的。有一个字符集和校对规则，如果没有设置，为latin1。

// 数据库层面的。
// 它也有一个字符集和校对规则。如果创建的时候没有，就会直接继承服务器的参数，即latin1。
 create database test1;   

// 表层面的
它也有一个字符集和校对规则。如果创建的时候没有，就会直接继承数据库的参数。
create table test2(
	id int,
    name varchar(200)
) character set utf8mb4;
    
// 字段层面的
它也有一个字符集，如果创建的时候没有，直接继承表层次的。
create table test3(
	id int,
    name varchar(200) character set utf8mb4
) 
    
创建了一个表之后，它的字段的字符集就固定下来了。现在即使再去改库的字符集，表的字符集，也不会影响列的字符集，所以建议删掉表重新建表。  
    
 // 先创建了一个  test1的数据库，没有指定字符集。  latin1。 
 // 创建一个  test_table的表。也没有指定   latin1
//  表里面的字段也是latin1
    
// alter database test1 character set utf8mb4;
```

# 数据操作

## 添加数据
```SQL
-- 插入数据
-- 方式1，指定需要插入的列名，values需要与之对应。
insert into table_name (column1, column2, ......) values (value1, value2, ......)

insert into test1 (id, name) values (1,"zhangsan");

-- 方式2，不指定需要插入的列名。values，必须要写所有value，且与建表语句一一对应
insert into table_name values (value1, value2, ......)

-- 方式3，使用set方式
insert into table_name set column1=value1, column2=value2,...;

```



可以插入多行，只用在values后添加多个括号。
```SQL
insert into table_name values (value1, value2, ......),(valuem,valuen,......),(valuem,valuen,......)
```



> <span style=color:red;background:yellow><b>举例：</b></span>现在有一个学生表，表里有以下列，写出SQL

| 列名    | 类型   | 说明     |
| ------- | ------ | -------- |
| id      | 整型   | 学生编号 |
| name    | 字符串 | 学生姓名 |
| age     | 整型   | 学生年龄 |
| address | 字符串 | 学生地址 |
| remark  | 字符串 | 自我评价 |

> 插入几条数据

- 编号是1，姓名是 "阿妈粽" ，年龄25， 地址上海，自我评价：是一个up主
- 编号是2，姓名是 "阿斗归来了" ， 地址湖北，自我评价：是一个视频区up主
- 编号是3，姓名是 "盗月社" ， 地址上海，自我评价：做饭up主
- 编号是4，姓名是 "李云龙" ， 地址湖北，自我评价：团长

```SQL
1.插入数据
create table student1(
    id int,
    name varchar(200),
    age int,
    address varchar(200),
    remark varchar(500)
);


-- 方式1，指定需要插入的列名，values需要与之对应。
insert into table_name (column1, column2, ......) values (value1, value2, ......)

-- varchar插入数据的时候，需要用引号给引起来。 单引号和双引号都可以
insert into student1(id,name,age) values (10, "景天", 19);

-- 现在我想插入 名字  年龄  地址 ：  刘俊威  18  重庆
insert into student1(name, age, address) values ('刘俊威', '18', "重庆");


-- 方式2，不指定需要插入的列名。values，必须要写所有value，且与建表语句一一对应
insert into table_name values (value1, value2, ......)

insert into student1 values(11, '张连强', 19,'河南', '河南的同学');

-- 方式3，使用set方式
insert into table_name set column1=value1, column2=value2,...;

-- 张创亮  12  年龄18 address 广东
insert into student1 set name='张创亮',id=12, age=18, address='广东';

- 编号是1，姓名是 "阿妈粽" ，年龄25， 地址上海，自我评价：是一个up主
- 编号是2，姓名是 "阿斗归来了" ， 地址湖北，自我评价：是一个视频区up主
- 编号是3，姓名是 "盗月社" ， 地址上海，自我评价：做饭up主
- 编号是4，姓名是 "李云龙" ， 地址湖北，自我评价：团长

insert into student1 values (1, "阿妈粽", 25, "上海", "是一个up主");
insert into student1 values (2, "阿斗归来了", null, "湖北", "是一个视频区up主");
insert into student1 values (3, "盗月社", null, "上海", "做饭up主");
insert into student1 values (4, "李云龙", null, "湖北", "团长");

insert into student1 values (5, "盗月社", null, "上海", "做饭up主"),(6, "李云龙", null, "湖北", "团长");
```

## 查询数据

```SQL
-- 查询语句 关键词 select ... from 
select * from table_name;

-- select .. from 是查询的关键词

-- * 代表选出所有列
-- 也可以写表中的列，多列使用, 分割
-- 比如 select id,name from students;

-- table_name 是表名
```

以上是查询所有数据，我需要特定的数据怎么办呢？
使用where关键词。where相当于是过滤器。

```SQL
-- 找出name是 zs 的表记录
select * from table_name where name='zs';

-- 找出年龄大于 18岁的人
select * from table_name where age > 18;
```
> 后面会专门讲where的用法

<span style=color:red;background:yellow><b>举例：</b></span>：我想找出一些数据

- 名字叫做阿妈粽的
- 年龄大于18的
- 是湖北人的

## 修改数据

```sql
-- 更新满足条件的表记录，设置列值
update table_name set column1=value1, column2=value2 [ where 条件];
```



```sql
update student1 set remark = '测试remark' ;

```

- <span style=color:yellow;background:red>**记住，要加where条件，否则，所有数据都会被更改。**</span>

  <span style=color:red;background:yellow><b>举例：</b></span>

  - 更新湖北的人，地址变成湖北省。自我评价也变成湖北人，能吃辣
  
  ```SQL
  update student1 set address='湖北省',remark='湖北人，能吃辣' where address='湖北';
  ```
  

## 删除数据

```sql
-- 删除满足条件的数据
delete from table_name [WHERE 条件];
```

```SQL
想删除id=10的人。
delete from student1 where id=10;
想删除 湖北人 
delete from student1  where address = '湖北省';
```

<span style=color:yellow;background:red>**需要加where条件，否则会删除所有数据。**</span>

# 特殊关键字

数据准备
```SQL
create table `student`  (
	`id` int(11)  primary key  auto_increment,
	`name` varchar(255)   ,
	`class` varchar(255)  ,
	`chinese` float  ,
	`english` float  ,
	`math` float  
) ;
```

```SQL
insert into student (id, name, class, chinese, english, math) values (1, '武松', '一班', 70, 90, 60);
insert into student values (2, '林冲', '一班', 70, 90, 90);
insert into student values (3, '宋江', '一班', 90, 90, 20);
insert into student values (4, '贾琏', '二班', 60, 60, 60);
insert into student values (5, '贾宝玉', '二班', 95, 80, 5); 
insert into student values (6, '贾环', '二班', 25, 25, 5); 
insert into student values (7, '曹操', '三班', 90, 90, 90); 
insert into student values (8, '曹丕', '三班', 90, 80, 80); 
insert into student values (9, '曹植', '三班', 98, 90, 80); 
insert into student values (10, '刘备', '三班', 95, 90, 80); 
insert into student values (11, '诸葛亮', '三班', 98, 95, 95); 
insert into student values (12, '孙权', '三班', 80, 90, 80); 
insert intostudent (id) values (13);
```


## where-条件
> 使用`where` 关键字并指定`查询条件|表达式`, 从`数据表`中获得`满足条件`的数据内容。
> <font color=red><b>使用位置：</b></font>查询语句（select），更新语句（update），删除语句（delete）。<span style=color:yellow;background:red>**在update里，和delete必须要用。**</span>

```SQL
-- 在select语句中的含义。只查询出满足条件的数据
SELECT <查询内容>|列1,... FROM  <表名字> WHERE <查询条件>|表达式

-- 在update里面，只修改满足条件的数据
UPDATE table_name SET column1=value1, column2=value2 where 条件;

-- 在delete里面，只删除满足条件的数据
DELETE FROM TABLE_NAME WHERE 条件;

eg:

-- 想找id为1的
select * from table_name where id=1;

-- 年龄 大于20的
selct * from table_name where age > 20;

-- 想找到id大于10的
select id, name from students where id > 10;
```
使用 `where` 关键字并指定`查询条件|表达式`, 从`数据表`中获得`满足条件`的数据内容。

**在构建`where`的`查询条件|表达式`的过程中, 我们可能需要了解到一些重要的`SQL运算符`**

1. 算术运算符
| 运算符 | 作用 |
| ------ | ---- |
| +      | 加   |
| -      | 减   |
| *      | 乘   |
| /      | 除   |
| %      | 取余 |
```SQL
-- 算术运算符，不仅可以出现在where中，还可以出现在查询列中。

-- 语数外总分 小于180的
-- 语文-数学 分差大于30的
-- 加权平均，按语文0.5 英语0.1 数学0.4求加权平均分
-- 加权平均分，小于等于60的
-- 求每个人的平均分，语数外三科
-- 求每个人的平均分，只筛选出平均分小于60的

-- 找出id是奇数的
-- 找语文成绩是偶数的

-- eg:
-- 语数外总分 小于180的
	select * from students where (chinese + english + math) < 180; 
	
-- 语文和数学 分差大于30的
	select * from students where (chinese - math) > 30; 
	
-- 加权平均，按语文0.5 英语0.1 数学0.4求加权平均分
	select *, (chinese*0.5 + english*0.1 + math *0.4) from students; 
	
-- 加权平均分，小于等于60的
	select *, (chinese*0.5 + english*0.1 + math *0.4)  from students where (chinese*0.5 + english*0.1 + math *0.4) <= 60 ;  
	
-- 求每个人的平均分。语数外
    select *, (chinese + english + math) / 3 from students ;  
    
-- 求每个人的平均分，只筛选出平均分小于60的
    select *, (chinese + english + math) / 3 from students  where (chinese + english + math) /3  < 60; 
```

2. 比较和逻辑运算符
| 运算符      | 作用       | 运算符      | 作用                          |
| ----------- | ---------- | ----------- | ----------------------------- |
| =           | 等于       | <=>         | 等于<u>(可比较null)</u>       |
| !=          | 不等于     | <>          | 不等于                        |
| <           | 小于       | >           | 大于                          |
| <=          | 小于等于   | >=          | 大于等于                      |
| between and | 在闭区间内 | like        | 通配符匹配(%:通配, `_`：占位) |
| is null     | 是否为null | is not null | 是否不为null                  |
| in          | 在列表内   | not in      | 不在列表内                    |
| and         | 与         | &&          | 与                            |
| or          | 或         | \|\|        | 或                            |

 ⚡需要注意的：
- `=` 无法判断null。一般使用 is null来单独处理null
- `like` 中，`%`表示通配，`_`表示占位。 一个`_`代表一个字符。
- `between ... and ...` 两个数字第一个写小的第二个写大的

>练习：
>查询语数外总成绩大于 180 的同学信息；
>查询数学成绩在[80，90]区间的同学姓名；
>查询各科都及格的同学姓名；
>
>查询有一科成绩小于60的同学信息
>
>查询一班和二班的同学信息；(两种写法)
>
>查询姓贾的同学（只要姓贾就行）
>
>查询姓贾的同学，两个字的
>
>查询语文分数在 60 或90的同学

```SQL
-- 查询语数外总成绩大于 180 的同学信息；
select *,(chinese + english + math) from students where (chinese + english + math) > 180;

-- 查询数学成绩在[80，90]区间的同学姓名；
select * from students where math between 80 and 90;

select * from students where math >= 80 and math <=90;

-- 查询各科都及格的同学姓名；
select * from students where chinese >= 60 and math >= 60 and english >= 60;

-- 查询各科只要有一科及格的同学姓名；
select * from students where chinese >= 60 or math >= 60 or english >= 60;

select * from students where id=6;

-- 查询一班和二班的同学信息；
select * from students where class = '一班' or class = '二班';
select * from students where class in ("一班", "二班");
```

## distinct-过滤
获取某个列的不重复值。或者是某些列的不重复值
```SQL
SELECT DISTINCT <字段名> FROM <表名>;
```

>使用`DISTINCT`对数据表中`一个或多个字段`重复的数据进行过滤，重复的数据只返回其`一条`数据给用户.

```SQL
-- 返回所有的 class
select class from students;

-- 返回不重复的 class
select distinct class from students;


-- 返回所有去重后的英语成绩
-- 6条
select distinct english from students;

-- 返回两列 英语和数学去重后的结果。
-- 10条
select distinct english,math from students;

-- 13条
-- 90.90 重复了一条
-- 90,80 重复了两条
select english,math from students;
```

## limit-限制结果集

一般用来做，比如限制最大的返回数目。或者是做分页上面。

select * from students limit 10;

```SQL
SELECT <查询内容|列等> FROM  <表名字> LIMIT 记录数目
SELECT <查询内容|列等> FROM  <表名字> LIMIT 初始位置，记录数目;
SELECT <查询内容|列等> FROM  <表名字> LIMIT 记录数目 OFFSET 初始位置;

eg:
-- 限制数目 为number个
select * from tableName where condition limit number;

-- 偏移量为offsetNumber 从0开始
select * from tableName where condition limit offsetNumber, number;

-- 偏移量offsetNumber
select * from tableName where condition limit number offset offsetNumber;
```

>使用`LIMIT`对数据表查询结果集大小进行限定.
`LIMIT 记录数目`: 从第一条开始, 限定记录数目
`LIMIT 初始位置，记录数目`: 从起始位置开始, 限定记录数目
`LIMIT 记录数目 OFFSET 初始位置`: 从起始位置开始, 限定记录数目
注意: 数据(默认下标从0开始) 

```SQL
-- 从第一条开始拿 
select * from students limit 5;

-- limit offsetNumer,number 偏移数目，需要限制的总数
-- 2,5 代表从第三个开始拿 总共拿回来5个
select * from students limit 2,5;

-- limit number offset offsetNumber
-- limit 5 offset 3 代表 从第四个开始拿，总共最大拿回来五个
select * from students limit 5 offset 3;

一般用它来做分页查询。
```

## as-别名
```sql
<内容> AS <别名>
```

>`as` 关键字用来为表和字段指定别名.
>
>`as `可以省略.

```SQL
-- 可以为取出来的列名 取一个别名
select id,name as student_name,class from students;

-- 可以为一些计算的属性取别名
select (chinese + english + math) as total_score from students;

-- 也可以为表名取别名
select s.name from students as s;

select s.name from students s;
```

## order by-排序

比如我们想根据id进行排序； 或者想根据年龄进行排序。

```SQL
select <查询内容|列等> from  <表名字> order by <字段名> [asc|desc];
```

>`ORDER BY`对查询数据**结果集**进行排序.
>不加排序模式: 升序排序.
>
>`asc`: 升序排序.
>`desc`: 降序排序.

注意: 如上查询, 当我们进行**多字段排序**的时候, 会先满足第一个列的排序要求, 如果第一列一致的话, 再按照第二列进行排序, 以此类推.

在同一个列相同的情况下，可以对剩下的列再排，中间用`,`隔开。

## group by-分组

按照某个、某些字段**分组**。

> 这里“分组”的意思是？
>
> select中出现的列只有两种选项：
>
> - 在group by 中出现的字段；
> - 聚合函数。

比如想看一个班级有多少学生。班级的最高分，最低分。 

```SQL
select <查询内容|列等> from  <表名字> group by  <字段名...>

eg: 
select * from student group by class;
select * from student group by class, chinese;
select class, group_concat(name), group_concat(chinese) from student group by class;

-- 获取语文成绩大于90分的，按照班级分组
select class, group_concat(name) from students where chinese > 90 group by class;

-- 获取班级的平均分
select class, group_concat(name), avg(chinese) from students group by class;

-- 获取班级人数大于三个人的班级
select class, group_concat(name) from students group by class having count(*) > 3;

-- 获取班级平均语文成绩大于60分的
select class, group_concat(name), avg(chinese) from students group by class having avg(chinese) > 60;
```

> `goup_concat()`函数会把**每个分组的字段值**都拼接显示出来. ⚡
>
> `having` 可以让我们对分组后的各组数据过滤。(一般和分组+聚合函数配合使用)

<font color=red>**`having`注意和`where`的区别**</font>
`where`主要用于对分组前的原始表进行过滤。`having`是对`group by` 后的结果进行过滤，一般配合聚合函数一起使用。



<span style=color:red;background:yellow>**注意点：**</span>

- `group by`的`select`列中，只能有两种，<font color=red>**在group by中出现的字段**</font>，<font color=red>**聚合函数聚合起来的东西**</font>
- 多个字段分组查询时，会先按照第一个字段进行分组。如果第一个字段中有相同的值，MySQL 才会按照第二个字段进行分组。如果第一个字段中的数据都是唯一的，那么 MySQL 将不再对第二个字段进行分组.
- 如果在select 字段中，可以看出group 字段，后方可以使用数字代替，从1开始

```SQL
-- 会报错。如果有同学不报错，是因为有一个选项没开
-- select * from students group by class;
-- select id,class from students group by class;

-- 在select中出现的，只能有 group by 后的字段；或者是聚合函数聚合起来的东西
select class from students group by class;

-- 根据英语成绩进行分组
select english from students group by 1;

-- 根据英语成绩，数学成绩进行分组
-- 会先按照英语成绩分组，如果英语成绩相同，则按照数学成绩进行分组
select english,math from students group by english,math;

```



是因为没有开这个选项。有的同学 `SELECT * from students group by class;`不报错。 

[only_full_group_by](https://www.cnblogs.com/csnjava/p/16531260.html)

## 聚合函数

聚合函数只对组里的数据生效。

聚合函数一般用来计算列相关的指定值. `通常`和`分组`一起使用

| 函数  | 作用   | 函数 | 作用   |
| ----- | ------ | ---- | ------ |
| COUNT | 计数   | SUM  | 和     |
| AVG   | 平均值 | MAX  | 最大值 |
| MIN   | 最小值 |      |        |

- COUNT: 计数

  ```SQL
  select count(columnName) from tableName [where 条件];
  
    eg:
        select count(*) from students;
        select count(name) from students;
        
  -- 和分组一起使用。查看每个班级有多少人数
  
  select class,count(*) from students group by class;
  
  ```

> `COUNT(*)`:表示表中总行数
>
> `COUNT(列)`: 计算非NULL的总行数。

- SUM: 求和

  ```SQL
  SELECT <查询内容>|列等 , SUM<列 FROM  <表名字> GROUP BY HAVING SUM<表达式>|条件
    
    eg:
    select sum(chinese) from students;
    select sum(chinese), sum(english), sum(math) from students;
    
    -- 查看每个班级的语文总分
    select class,sum(chinese),group_concat(chinese) from students group by class;
  ```

- AVG: 平均值

  ```SQL
  SELECT <查询内容>|列等 , AVG<列> FROM  <表名字> GROUP BY HAVING AVG<表达式>|条件
  
  eg:
  	select avg(chinese) from students;
      select avg(chinese), avg(english), avg(math) from students;
      
      -- 按班级查看平均分
      select class,avg(chinese), avg(english), avg(math) from students group by 1;
  ```

- MAX: 最大值

  ```SQL
  SELECT <查询内容>|列等 , MAX(<列>) FROM  <表名字> GROUP BY HAVING MAX(<表达式>)|条件
  
  eg: 
      select max(chinese) from students;
      select max(chinese), max(english), max(math) from students;
  ```

- MIN: 最小值

  ```SQL
  SELECT <查询内容>|列等 , MIN(<列>) FROM  <表名字> GROUP BY HAVING MIN(<表达式>)|条件
  
  eg:
      select min(chinese) from students;
      select min(chinese), min(english), max(math) from students;
  ```



<font color=red>**练习：**</font>

- 查询每个同学的总成绩，平均成绩，并用别名表示；
- 查询数学最大值，并用别名表示；
- 查询外语最小值，并用别名表示；
- 查询全体学生的语数外各科平均成绩，并用别名表示；

```SQL
-- 练习：
-- 查询每个同学的总成绩，平均成绩，并用别名表示；
-- ROUND(100.3465,2) 四舍五入
select name, (chinese + english + math) as total_score, ((chinese + english + math)/3) as avg_score from students;

select name, (chinese + math + english) as total_score , round((chinese+math+english) /3, 2) as avg_score from students;

-- 查询数学最大值，并用别名表示；
select max(math) as max_math_score from students;

-- 查询外语最小值，并用别名表示；
select min(english) as min_english_score from students;

-- 查询全体学生的语数外各科平均成绩，并用别名表示；
select avg(chinese),avg(math),avg(english) as avg_english from students;
```



```SQL
SELECT <查询内容>|列等 , (聚合函数)|* FROM  <表名字> GROUP BY 列 HAVING (聚合函数)条件 |条件;

  eg:
      select class, group_concat(name), count(*) from students group by class;
      select class, group_concat(name), count(*) from students group by class having count(*) > 3;  
    

-- 查询班级语文总分大于200的班级(可以显示一下语文总分)

-- 查询班级平均分，学生的限制：数学大于等于60，语文大于等于60的 

-- 查询班级情况，要求学生语文最大的大于等于90，语文最少分大于等于70

-- 查询班级，语文最小成绩大于等于60，数学也是

select class from students group by class having sum(chinese) > 200;
```

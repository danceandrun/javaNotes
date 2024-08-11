[toc]

# SQL语句执行顺序


```SQL
 (5) SELECT column_name, ...   
 (1) FROM table_name, ...   
 (2) [WHERE ...]   
 (3) [GROUP BY ...]   
 (4) [HAVING ...]   
 (6) [ORDER BY ...];  
 (7) [Limit ...]
```

> -   （1） 小括号中的数字代表执行顺序
> -   SQL语句的关键字是有顺序的，需要按照上面的顺序来写
> -   要注意书写顺序。也要注意指定顺序。

# 数据完整性

主要是用来限制MySQL表中的数据，使数据符合规范，也称之为完整.

## 实体完整性

缺少了这个字段，实体就不完整。

<span style=color:red;font-size:30><b>列约束</b></span>

>MySQL可以对插入的数据进行特定的验证，只有满足条件才可以插入到数据表中，否则认为是非法插入

**主键(primary key)**

- 一个表只能有一个主键
- <font color=red>**主键具有唯一性**</font>
- <font color=red>**主键字段的值不能为null**</font>
- 声明字段时，用 primary key 标识
- 主键可以由多个字段共同组成。此时需要在字段列表后声明的方法



```SQL
create table test_primary_key(
    -- 代表这个 columnName是主键
	columnName columnType primary key,
	......
)


create table test_primary_key2(
	columnName columnType,
	......,
	primary key(columnName)
)

```

**auto_increment 自动增长约束**
一些序号，没有必须手动生成，想让mysql自动生成。

- 自动增长必须为索引 (主键或unique)
- 只能存在一个字段为自动增长。
- 默认为1开始自动增长。

```SQL
create table test_auto_increment(
	columnName columnType primary key auto_increment,
	......
)
```



```SQL
create table stu(  
   id int PRIMARY KEY auto_increment,  
   name varchar(20),  
   age int,  
   class varchar(20)  
 ) auto_increment=1000 ;
```

在上表中，id是主键，是自增的。主键值从1000开始自增，通过auto_increment来指定，假如没有指定，从1开始自增.

MYSQL在内部维护了一个计数器来实现自增，所以从大数开始。比如插入了一个100，这是即使里面只有3个数，下一个也是101。

```SQL
-- 我们可以使用一条命令去看  自动增长目前增长到哪
show create table table_name;
```

> 面试题：使用自动增长，是否能一定保证连续？
>
> 不一定，在表中有**其他唯一值约束**的时候，可能导致不连续。

## 域完整性

域完整性是针对某一具体关系数据库的约束条件，<span style=color:red;background:yellow>**它保证表中某些列不能输入无效的值。**</span>

比如这个人的姓名，不允许输入null这种值。

比如有一张学生表。 id name  id_card。



**null约束**

- null不是数据类型，是列的一个属性。一个具体的值
- 表示当前列是否可以为null，表示什么都没有
- null, 允许为空。默认
- not null, 不允许为空
  <font color=red><b>null表示没有数据，但是注意null不是空字符串。</b></font>

```SQL
create table test_null(
	columnName columnType not null,
	columnName2 columnType2 null,
	......
)

-- 这代表null
insert into test_null(column1) values (null);

-- 这个不是null。这是一个普通字符串
insert into test_null(column1) values ("null");
```



**唯一值约束**

- unique

  表示值是唯一的，不重复的

```sql
create table teacher(
	id int PRIMARY KEY,
	name varchar(20) unique,
	age int not null
);
```

> unique：
>
> 1. 插入的值不能重复
> 2. 可以插入null
> 3. null可以重复



unique和primary key的区别：

1. 主键值不能为空（null），而unique可以为空




## 参照完整性

**外键**是关系数据库中一个非常重要的概念，用于建立表与表之间的关系。一个表中的外键指向另一个表中的某个字段，这个字段通常是另一个表中的主键。外键的作用是保障数据的完整性和一致性，它可以确保两个表之间的关系正确地维护，防止数据出现不一致或者不完整的情况。

外键。关系型数据库，不仅可以存储数据，还可以存储数据和数据之间的关系，具体的体现就是外键。

```SQL
-- 声明外键
CONSTRAINT 外键名称 foreign key(列) references 表名(列名)
```



```sql
create table province(
	id int PRIMARY KEY,
	name varchar(20)
);

create table city(
	id int ,
	name varchar(20),
	province_id int,
	-- 声明外键
    -- CONSTRAINT 外键名称 foreign key(列) references 表名(列名)
	CONSTRAINT fk_pid foreign key(province_id) REFERENCES province(id)
);

-- 外键的另外一种写法
-- foreign key(列) references 表名(列名)
-- foreign key(s_id) references school(id)
 
insert into province values(41, "河南省");
insert into province values(43, "湖南省");
insert into province values(42, "湖北省");

-- 城市表插入

-- 插入城市表的时候会去寻找有没有23对应的省份，如果有，插入
-- 如果没有，那么会报错
insert into city values (6,'哈尔滨',23);

-- 不能删除还有子行的数据
delete from province where id = 32;
```

外键的优缺点：

- 优点：能够限制数据的增加、删除或者是修改操作，来保证数据的正确性。

- 缺点：

  1. 在插入（修改）子行（城市表）的数据的时候，需要去父表（省份表）中找对应的数据
  2. 在删除（修改）父表（身份表）的数据的时候，需要去检查城市表中是否有对应的数据

  总结：有了外键之后，影响了增加、删除、修改的性能



> 在公司中，大家觉得应不应该使用外键呢？看具体的情况
>
> 1. 假如公司比较小，表中的数据量不大（外键对效率的影响比较小，甚至可以忽略），可以考虑使用外键
> 2. 假如是大公司，或者是数据库表中的数据很多，（外键对于效率的影响就会很大），不应该使用外键

不建议大家用？

我就是想约束这种关系。不使用外键，怎么保证这种关系。用代码保证。

数据库来保证了事情，但是影响了效率。 

代码来实现，打个日志。

其他约束（属性）

**default 默认值属性**
当前字段的默认值。

```SQL
create table test_default(
	columnName timestamp ,
	......
);

create table test_default(
	id int primary key,
    name varchar(200),
    -- 如果你插入数据的时候，没有指定，这时候我就用默认值
    country varchar(200) default "中国"
);


CREATE TABLE `user_info`  (
  id int, 
  name varchar(200)
  create_time timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
);
```


> create table tab ( create_time timestamp default current_timestamp );
> -- 表示将当前时间的时间戳设为默认值。
> current_date, current_time
>
> ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间'

阿里编程规范有规定，表中一般要有3个字段，id create_time update_time.

**comment 注释**

```SQL
-- 作用是什么？
-- 为了让代码更好理解。
-- SQL里面的注释，是为了让SQL的字段更好理解。如果你进入了一个公司，不懂这个表里面的字段的含义。
-- 可以运行一下这个命令，看一下有没有备注帮你更好的理解这个表。    show create table test_comment;

create table test_comment(
  id int primary key auto_increment,
  name varchar(255) comment "名字",
  status int comment "0表示未付款，1表示已付款，2"
);

-- 相当于是字段的备注信息
-- 可以使用 show create table test_comment;来查看备注
```

# 多表设计

在关系型数据库中，多表设计是指将数据分散到多个表中，每个表存储不同的数据。这种设计方式可以提高数据存储的**效率和灵活性**，同时也可以更好地保障数据的**完整性和一致性**。

有关系的一些表才需要这种多表设计。 

学生表和订单表。 

用户表和用户详情表。 

## 一对一

在关系型数据库中，多表设计中的一对一关系指的是两个表之间的关系，其中一个表的记录只能对应另一个表中的一条记录，反之亦然。<span style=color:yellow;background:red>**这种关系，在任意一方添加关系即可。**</span>

- 人和身份证号
- 学号和学生

- 用户和用户详情

> 所有的一一对应的表，在逻辑上，都可以合并为一个表。

<font color=red>**思考一下，为什么本来可以用一张表，却要拆成两张表？**</font>

主要的原因是**效率**。如果一个表的列太多，比如有300列。最终数据量太大的时候，效率会很差。但是如果将其拆分成两个表，最终频繁查询的这个表，将其列弄得少一点，会提升查询效率。

**垂直拆分。**

查询的效率的问题。1000w左右的大小的表，查询效率在1s之内。

表的列非常多，300列。有1000w行数据。查询效率非常差。

拆成两张表， 一张表 5列，一张表有296列。 这时候 这个小表的效率也可以。

登录的场景，要不断的去查 用户名和密码。

## 一对多

在关系型数据库中，多表设计中的一对多关系指的是两个表之间的关系，其中一个表的记录可以对应另一个表中的多条记录，而另一个表中的每条记录只能对应一个表中的记录。<span style=color:yellow;background:red>**这种关系，会在多的一方添加字段来表示关系。**</span>

一对多是指 存在表A和表B，表A中的一条数据，对应表B中的多条数据；而表B中的一条数据，对应表A中的一条数据。

- 班级和学生（一个班级对应多个学生）
- 省份和城市（一个省份对应多个城市）

## 多对多

在关系型数据库中，多表设计中的多对多关系指的是两个表之间的关系，其中一个表的记录可以对应另一个表中的多条记录，而另一个表中的每条记录也可以对应另一个表中的多条记录。<span style=color:yellow;background:red>**这种关系通常需要通过中间表来实现。**</span>

多对多其实是指存在表A和表B，表A中的一条数据，对应表B中的多条数据；而表B中的一条数据，对应表A中的多条数据。

**互为一对多**

- 学生和课程（利用中间表，中间表存三列：一列自身id，一列学生id，一列课程id）
- 订单和商品 

## 数据库设计三大范式

数据库表设计的时候，应该遵循的规范。只有遵循了这些范式，设计出来的表才是好的。前人总结出来的一些原则，被称之为范式。

规范。

### 第一范式

每一列应该保持<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**原子性**</span>。在设计表格的时候，要遵守。

一定要留有一定空间，灵活空间。

> 原子性：表示表中的数据都是一个不可拆分的最小单元。

举个栗子：以收货地址为例如果一连串写在一起不方便找到武汉市的用户。

“原子性是跟着业务走的。”

> 第一范式：是跟着业务走的。但是业务是变动的，所以我们在设计表的时候，应该考虑之后业务的变化，来尽量的让每一列保持原子性。

### 第二范式

记录的<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**唯一性**</span>。

唯一性是指每一条记录都有唯一的标识。例如<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**主键**</span>。表中必须得有一个 主键。

这是固定的，创建任何表的时候都要创建一个Id

```SQL
create table test1(
	id int primary key auto_increment
)
```

### 第三范式

<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**数据不要冗余**</span>。

举个栗子：学生表里存了班主任的id就不要再存班主任的名字了。

在上表中，班主任名字重复存储了，冗余了

- 缺点：
  1. 重复存储了，需要占用更多的磁盘空间
  2. 如果要去修改某个老师的名字，那么需要在多个地方进行修改，增加了数据的维护成本

- 优点：
  1. 根据学生去查班主任的名字变得更简单了，查询效率变高了

> 总结：冗余数据会使数据的维护成本增加，但是可以在某些场景中，方便数据的查询 

> 那么在我们以后的工作中，要不要冗余数据呢？
>
> 要看情况。假如数据的查询需求远大于增删改的需求，那么可以考虑冗余数据；否则，不应该冗余数据，
>
> 这种冗余数据的做法叫**“反范式化设计”**。指的是反第三范式。

如果你想查的更快，而且你不是特别在意这些磁盘空间，增删改的次数比较少，可以考虑冗余数据。

冗余了数据之后，会让你查询变得更简单。

## 多表查询

多表查询是指在关系型数据库中，从多个表中查询数据的操作。多表查询可以帮助我们获得更加丰富的数据，以满足各种不同的需求。

### 连接查询

```sql
-- 如果这个表存在 就删除
drop table if exists user;
create table user(
	id int primary key auto_increment,
	name varchar(255),
	password varchar(255)
);

drop table if exists user_detail;
create table user_detail(
	id int primary key auto_increment,
	user_id int,
	address varchar(255),
	pic varchar(255)
);

insert into user values (1, "猪八戒", "zhubajie");
insert into user values (2, "孙悟空", "sunwukong");
insert into user values (3, "白骨精", "baigujing");
insert into user values (4, "唐僧", "tangseng");
insert into user values (5, "沙僧", "shaseng");

select * from user;

insert into user_detail values(null, 1, "高老庄", "猪八戒.jpg");
insert into user_detail values(null, 2, "花果山", "孙悟空.jpg");
insert into user_detail values(null, 3, "白虎岭", "白骨精.jpg");
insert into user_detail values(null, 4, "东土大唐", "唐僧.jpg");

select * from user_detail;
```



#### 交叉连接

交叉连接其实就是求多个表的**笛卡尔积**。

`cross join`

```sql
-- 交叉连接
select * from user cross join user_detail;
```

> 交叉连接的结果没有实际的意义。
>
> 但是**内连接和外连接都是基于交叉连接的结果去筛选的。**

比如表A有3条数据，表B中有4条数据，最终会有3*4=12条数据。

A:{1，2，3}

B：{A,B,C,D}

交叉连接：{1A,1B,1C,1D,2A,2B,2C,2D,3A,3B,3C,3D}

这个被称为笛卡尔积



#### 内连接

内连接（inner join）是一种SQL中的表连接操作，用于将两个或多个表中的数据进行**合并匹配**。<font color=red>**内连接只返回两个表中具有相同值的行，也就是说，只有在连接列中存在匹配值的行才会被返回。**</font>

内连接的语法如下：

```SQL
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;

-- 其中，columns是要返回的列，table1和table2是要连接的表，column是要连接的列。ON子句指定了连接条件，它指定了table1和table2之间的匹配条件。
```



`inner join`

- 显式 （ 可以省略 `inner`）

  ```sql
  -- 显式内连接
  select * from user inner join user_detail on 
  user.id = user_detail.user_id;
  -- 这个SQL语句将user和user_detail表连接起来，只返回两个表都有相同的id的行。
  ```
  
- 隐式(逐渐不再使用)

  ```sql
  -- 隐式内连接
  select * from user,user_detail 
  where user.id =user_detail.user_id;
  ```

#### 外连接

外连接（`outer join`）是一种SQL中的表连接操作，用于将两个或多个表中的数据进行合并匹配，<font color=red>**与内连接不同的是，外连接会返回左表或右表中即使没有匹配的行也会被返回，这些没有匹配的行将被填充为NULL值。**</font>

外连接有左外连接（`left outer join`）、右外连接（`right outer join`）和全外连接（`full outer join`）三种类型。

<u>说明：但是MySQL不支持全外连接。</u>

左右表中的数据都保留。

`outer`可以省略掉。



<font color=red>**左外连接**</font>

除了内连接返回的数据以外，还会返回左表未匹配上的所有数据。

左外连接返回左表中的所有行以及右表中与左表匹配的行，右表中没有匹配的行将被填充为`NULL`值。左外连接的语法如下：

```SQL
SELECT columns
FROM table1
LEFT OUTER JOIN table2
ON table1.column = table2.column;

-- 左外连接，保留匹配的数据。还会保留左表的所有数据

```



```SQL
-- 左外连接
select * from user left outer join user_detail on 
user.id = user_detail.user_id;

```



<font color=red>**右外连接**</font>

右外连接返回右表中的所有行以及左表中与右表匹配的行，左表中没有匹配的行将被填充为`NULL`值。右外连接的语法如下：

```SQL
SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;
```

```SQL
-- 右外连接
select * from user right outer join user_detail on 
user.id = user_detail.user_id;
```



> <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**连接查询最重要的，是找到连接的条件。**</span>
>
> 使用内连接还是外连接取决于想要留哪些数据。

## 子查询

在关系型数据库中，子查询是指<u>在一个 SQL 语句中嵌套另一个 SQL 语句来实现查询的方式</u>。子查询通常用于在查询结果中过滤、排序、分组或者统计数据，或者作为其他查询语句的一部分。

子查询可以嵌套多层，每一层都返回一个结果集供上一层使用。



子查询可以用于实现各种复杂的查询需求，例如，使用子查询**查询最大值或最小值**，使用子查询**实现分组统计**等等。

每一层的子查询都会生成一张临时表，效率差。由于子查询会增加查询的复杂度和执行时间，因此在使用子查询时需要注意查询性能的影响。

一个SQL语句的结果可以作为另外一个SQL语句的条件。

```sql
-- 首先先拿到Java的id
select id from tec_cource where name='Java';
-- 然后再把这个id=1 放给第二个
select * from tec_sele_cource where cource_id=1;

select * from tec_stu where id in (1,3);

-- 看学生信息
select * from tec_stu where id in (
    -- 看哪些学生选了 Java
	select student_id from tec_sele_cource where cource_id=(
        -- 获取Java的id
		select id from tec_cource where name='Java'
	)
)
```

不建议大家用。效率差。因为每一层查询会生成临时表

## 联合查询（了解）

SQL支持把多个SQL语句的结果拼装起来。

```sql
-- 写了两个SQL。把两个SQL的结果拼接起来

select * from students where class = '一班'
union
select * from students where class = '二班';

-- union要求返回的列数目要一致 
-- 我们可以使用union关键字对SQL1和SQL2的结果去做并集，一般来说联合查询作用不大

select * from students where class in ('一班','二班');
-- 当上面这个SQL语句查询速度很慢的时候，可以考虑union联合查询来提高效率。
```

`union all `将两条SQL的结果直接叠起来，不用比较是否重复.

## 数据库的备份与恢复

数据库是存储数据的地方。我们不希望数据库丢数据，如果丢了数据，对于企业的损失非常大。

所以我们需要了解数据库的备份和恢复手段。

备份产生的SQL，没有建库语句，需要你自己手动建一个库，然后再执行SQL。

### 命令行

```shell
# 备份
# 1. 打开命令行
mysqldump -uroot -p dbName>/path/dbName.sql

mysqldump -uroot -p test_52th3>test52th.sql

# 在生成的sql文件中，主要做了三件事。 删表，建表，插数据


# 恢复
# 1. 打开命令行
# 2. 连接MySQL服务器
mysql -uroot -p

# 3. 选中数据库（假如没有合适的数据库，可以新建一个）
use dbName;
# 4. 执行文件中的SQL语句，恢复数据
source /path/dbName.sql

source c:/Users/zhoubing/test52th.sql
```

### Navicat

备份和恢复有可能丢数据，所以我们需要检查数据是否完整，数据是否正确。

select count(*) from table_table;



我们在公司中，一般不会让大家去备份。

公司一般有专门，DBA 会干这个事情。

会写一定定时脚本，在专门的时间来执行备份操作。

DBA = Database Administrator



如何去校验，数据库备份前和备份后的数据，是否一致。

人眼校验。不太可能。

一般会计算一个hash。然后比较hash。



在公司里面，每个人各司其职。 

图相关。图算法。

算法工程师。 



offer ： hr ,一面二面三面。 

2w / 8h /21天 = 125一小时。 



1000。 

一个星期。 1个月。 

出道即巅峰。

# SQL题目

写sql题目：

1.理解表

2.理解题意

```SQL
-- 对于emp中最低工资小于2000的部门，列出job为'clerk'的员工的部门号，最低工资，最高工资

```


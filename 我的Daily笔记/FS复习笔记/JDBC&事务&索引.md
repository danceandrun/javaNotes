[toc]

# JDBC

学习目标：

- 了解JDBC是什么，以及定义它有什么好处
- 掌握使用JDBC访问数据库
- 掌握使用JDBC进行增删改查
- 掌握数据库注入问题，以及怎么解决数据库注入问题
- 掌握事务的使用，以及为什么需要事务
- <span style=color:red;background:yellow>**理解事务的四大特性，ACID。能用自己的话讲出来**</span>
- 事务的隔离级别（面试）

# 介绍

## 数据库的访问过程

![](.\assets\jdbc\数据库访问过程.png)



## `JDBC`是什么

JDBC（Java Database Connectivity）是Java程序与数据库进行交互的一种标准接口。

它定义了一组Java API，使得Java程序可以通过这些API来连接和操作各种**关系型数据库**（如MySQL、Oracle、SQL Server等），执行SQL语句并处理查询结果。JDBC提供了一种跨平台、可移植的方式来访问数据库，使得Java程序可以与不同的数据库进行通信而无需改变代码。

JDBC的主要优点包括：可移植性、可靠性、安全性和易于使用。

<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**JDBC具体指的就是 Java的一套标准的连接数据库的接口。**</span>

![](.\assets\jdbc\JDBC是一套标准的数据库接口.png)



那么标准的接口具体在哪儿呢？指的是哪些接口呢？（rt.jar内部的）

- `java.sql`
- `javax.sql`

# JDBC怎么用

## 第一个JDBC程序

- 新建项目

- 导包

  导包是指导入其他的人或者是组织写的代码。

  > 如何导包呢？
  >
  > 1. 下载包
  >
  >    [下载仓库地址](https://mvnrepository.com/)
  >
  >    [MySQL驱动包下载地址](https://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.47)
  >
  > 2. 把包复制到项目中，并且加载进来
  >
  >    `.jar`： 这个格式是一种压缩格式，和 .zip，.rar是类似的，这种类型的文件，可以被Java识别并且运行。
  >
  >    `.jar`文件中都是一些 `.class`文件，是可以直接运行的
  >
  >    接下来，需要把对应的jar包添加到library里面去。对着jar包右键
  >
  >    ![image-20220512160152575](.\assets\jdbc\设置AsLibrary.png)
  
- 编写应用程序

  ```JAVA
  // 1. 加载驱动  {@Link java.sql.Driver   impl : com.mysql.jdbc.Driver}
  	DriverManager.registerDriver(new Driver());
  
  //String url = "协议 + ip + 端口 + 路径 + 参数";
  	String url = "jdbc:mysql://localhost:3306/40th?useSSL=false&characterEncoding=utf8";
  	String username = "root";
  	String password = "123456";
  
  // 2. 发送用户名和密码，建立连接
  // 返回的当前是一个Connection接口，但是实际上在运行的时候，返回是Connection接口的实现类的实例
  	Connection connection = DriverManager.getConnection(url, username, password);
  
  // 3. 获取statement对象
  	Statement statement = connection.createStatement();
  
  // 4. 发送SQL语句
  	int affectedRows = statement.executeUpdate("insert into stu values (4,'云飞兄',20,'358班')");
  
  // 5. 解析结果集
  	System.out.println("affectedRows:" + affectedRows);
  
  // 6. 断开连接
  	statement.close();
  	connection.close();
  ```

MySQL版本5.7。我们选驱动 可以选 5.1.47 48 49；都可以。 8的也可以。

MySQL8的版本。只能选8，不要选5的版本。



## 使用JDBC进行增删改查

### 增

```JAVA
// 3. 发送SQL语句
// 返回值是个int，代表影响的行数。 新增的行数
int affectedRows = statement.executeUpdate("insert into stu values (1, 'zhangsan', 22)");
```

### 删

> 增、删、改都是一样的，都是使用 `statement.executeUpdate(String sql)` 来执行SQL语句，返回的结果也是一样的，都是影响的行数。

```java
// 3. 发送SQL语句
// 返回值是个int，代表影响的行数。 删除的行数
int affectedRows = statement.executeUpdate("delete from stu where id = 3");
```

### 改

```sql
int affectedRows = statement.executeUpdate("update stu set name = '孔二愣子',class='五班' where id = 4"
```

### 查

```java
// 3. 发送SQL语句
// resultSet指结果集对象，具体指代查询返回的临时表对象
ResultSet resultSet = statement.executeQuery("select * from stu");


//  解析结果集
while (resultSet.next()) {

	int id = resultSet.getInt("id");
	String name = resultSet.getString("name");
 	int age = resultSet.getInt("age");
	String className = resultSet.getString("class");

	System.out.println("id:" + id);
	System.out.println("name:" + name);
	System.out.println("age:" + age);
	System.out.println("className:" + className);

}
```

## API

> 查看类中所有方法的快捷键：ctrl + F12

### `DriverManager`

驱动管理器。可以帮助我们管理驱动，获取连接

```java
// 注册驱动
DriverManager.registerDriver(new Driver);
```

获取连接
在代码实际运行的时候，一定不可能光是一个接口，一定是一个实现类。（是MySQL提供的一个实现类。）
获取到的连接对象实际上是 JDBC4Connection 对象

```JAVA
Connection conn = DriverManager.getConnection(String url,String username,String password);
```

### `Connection`

指代连接对象。在JDBC中是一个接口，在我们使用JDBC的时候，实际上实现类是 ` com.mysql.jdbc.JDBC4Connection` 对象。

```java
// 获取statement
// 通过statement对象来执行SQL
Statement stat = connection.createStatement();

// 关闭连接
connection.close();

// 事务相关的API
connection.commit();
connection.rollback();
connection.setAutoCommit(false);
```

### `Statement`

> The object used for executing a static SQL statement and returning the results it produces.

statement对象其实就是用来去执行SQL语句，并且返回这个SQL语句产生的结果集。实际上我们在使用的时候，其实是用的Statement接口的实现类 `com.mysql.jdbc.StatementImpl`

```java
// 执行增删改的方法。新增数据的SQL，删除数据的SQL，修改数据的SQL
int affectedRows = statement.executeUpdate(String updateSql);

// 执行查询的方法
ResultSet rs  = statement.executeQuery(String querySql);

// 拿到一个ResultSet，怎么从里面获取数据。 当一个迭代器的方法使用。

// 关闭
statement.close();

// 执行sql语句
Boolean ret = statement.execute(String sql);

// 如果 ret == true，那么说明执行的是查询语句  statement.getResultSet();
// 如果 ret == false，那么说明执行的是增删改语句 statement.getUpdateCount();
// 获取影响的行数: statement.getUpdateCount();
// 获取返回的结果集：statement.getResultSet();


// 练习一下怎么去组织语言（prompt）
// 我是Java学习者，我在学习JDBC的时候，遇到了一个Statement接口，里面有一个execute()方法，我不知道如何去使用
你的任务如下： 1.简单告诉一下我它的大致作用   2.给我写个demo，示例，让我快速知道如何去使用它。
```

### `ResultSet`

这个对象表示查询的结果集。

![](.\assets\jdbc\结果集.png)

> 在查询的结果集中，有一个游标，游标可以移动，移动的时候会扫描一些行，那么对于这些扫描到的行，我们就可以获取对应的列的值。

```java
// 移动游标方法

// 向下移动
Boolean ret = resultSet.next();

// 向上移动
Boolean ret = resultSet.previous();

// 定位到第一行之前
resultSet.beforeFirst();

// 定义到最后一行之后
resultSet.afterLast();


// 获取值的方法
resultSet.getInt(String columnName);
resultSet.getString(String columnName);
resultSet.getDate(String columnName);
```

## JDBC的优化

- 提取工具类
- 连接配置放入到配置文件中
- 注册驱动利用反射，解耦
- 关闭资源（提取公共方法）

>  ⚡为什么参数写在配置文件里？
>
> 因为修改了代码，后续的流程很长。在企业中，修改代码不可能直接放到线上环境跑，需要进行**回归测试**，但是更改配置文件不需要重新测试。
>
>  ⚡整个代码中只有 `Driver` 类来自`Mysql`，
>
> `Driver`类有一个静态代码块，发现只要它加载进来，静态代码块就会执行`DriverManager.registerDriver(new Driver())`
>
> 可以通过反射将这个类加载进来。
>
> `Class.forname("com.mysql.jdbc.Driver")`
>
> ⚡（怎样做到解耦的？）
>
> 这样可以做到在编译时看不到这个类，运行时会用到这类，这样就使得只用jdbc里面的接口，为后续不使用mysql，需要切到oracle等别的数据库时提供了可能。

```java
public class JDBCUtils {

    static String url;
    static String username;
    static String password;
    static String driver;

    static {

        Properties properties = new Properties();
        try {
            properties.load(new FileInputStream("jdbc.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }


        url = properties.getProperty("url");
        username = properties.getProperty("username");
        password = properties.getProperty("password");
        driver = properties.getProperty("driverClassName");
    }


    // 获取连接
    public static Connection getConnection(){

        Connection connection = null;
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(url, username, password);
        }catch (Exception ex) {
            ex.printStackTrace();
        }

        return connection;
    }



    // 关闭资源
    public static void  close(Connection connection, Statement statement, ResultSet resultSet){

        try {

            if (resultSet != null) resultSet.close();
            if (statement!= null) statement.close();
            if (connection != null) connection.close();

        }catch (Exception ex) {
            ex.printStackTrace();
        }


    }
}
```

## 数据库注入问题

> 数据库注入是一种常见的网络安全漏洞，攻击者利用这种漏洞向网站或应用程序的数据库中插入恶意代码，从而获取敏感信息、执行非法操作等。
>
> 例如：假设有一个登录页面，用户需要输入用户名和密码才能登录。该页面的后端代码使用SQL查询语句来验证用户的身份
>
> ```sql
> select * from users where username = 'input_username' and password = 'input_password';
> ```
>
> 其中，`'input_username'` 和` 'input_password' `是用户在登录页面上输入的值。如果用户输入的值与数据库中的值匹配，则允许用户登录，否则拒绝登录。
>
> 然而，攻击者可以在输入框中输入一些恶意代码，例如：
>
> ```sql
> input_username: root
> input_password: xxx' or ' 1=1
> ```
>
> 这个输入会更改SQL查询语句，变成：
>
> ```SQL
> -- 下面这条SQL的含义，是这样的   1=1是恒等的，所以where条件相当于会没有任何条件
> -- SELECT * FROM users WHERE (username = 'admin' AND password = 'xxx') or '1=1';
> select * from users where username = 'admin' and password = 'xxx' or ' 1=1';
> 
> select * from users where username = 'admin' and password = 'xxx' ;drop database test1';
> 
> ```
>
> 这个SQL语句的含义是“从users表中选择任何一个行，其中用户名为空或1等于1，并且密码为空”。由于1等于1始终为真，因此这个SQL语句将返回users表中的所有行，从而绕过了身份验证，攻击者可以以任何用户的身份登录系统。这就是一个典型的SQL注入攻击。
>
> 为了避免SQL注入攻击，必须对用户输入的值进行过滤和转义，或使用预处理语句等安全措施来防范这种攻击。
>
> **主要的原因是字符串拼接，把用户的一些输入当做了关键字。**

```java
 public static void main(String[] args) throws SQLException {

				// Boolean ret = login("天明", "upan");

        // select * from user where name = 'xxx' and password = 'xxx';
        // select * from user where name = 'xxx' and password = 'xxx' or '1=1';

        Boolean ret = login("xxx", "xxx' or '1=1");


        if (ret) {
            System.out.println("登录成功！");

        }else {
            System.out.println("登录失败");
        }
    }

    // 登录方法
    public static Boolean login(String username,String password) throws SQLException {

        // 传入用户名和密码。根据用户名和密码查询用户，假如查询到了，说明登录成功；如果没查到，登录失败
        Connection connection = JDBCUtils.getConnection();

        Statement statement = connection.createStatement();

        String sql = "select * from user where name = '"+username+"' and password = '"+password+"'";

        System.out.println(sql);

        ResultSet resultSet = statement.executeQuery(sql);

        if (resultSet.next()) {

            return true;
        }else {
            return  false;
        }

    }
```

> 数据库注入问题产生的原因：因为SQL语句是通过字符串拼接的，这个时候用户可能输入一些字符，这些字符中包含有SQL语句中的关键字，那么通过字符串拼接SQL语句之后，可能会改变SQL语句的格式，进而引发安全性的问题。
>
> 根本的原因：MySQL把用户输入的参数当做关键字来解析了

> 如何解决数据库注入问题呢？
>
> - 使用`PreparedStatement`（预编译的`Statement`）

```java
// 登录方法2
    public static Boolean login2(String username,String password) throws SQLException {

        // 1. 获取连接
        Connection connection = JDBCUtils.getConnection();

        // 2. 获取PreparedStatement
        // 这一步，在创建PreparedStatement的时候，PreparedStatement会把当前这个没有参数的SQL语句，发送给MySQL服务器，执行预编译
        // 预编译：其实就是去解析这个SQL语句中的关键字，变成MySQL可以执行的命令
        // 在预编译之后，后续输入的字符串，就只会被MySQL当成纯文本来解析
        PreparedStatement preparedStatement = connection.prepareStatement("select * from user where name = ? and password = ?");


        // 3. 设置参数
        // 序号从 1 开始
        preparedStatement.setString(1,username);
        preparedStatement.setString(2,password);


        // 4. 传递参数，执行SQL语句
        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            return true;
        }else {
            return false;
        }
    }
```

> 总结：
>
> 1. 在安全性方法，`PreparedStatement`比 `Statement` 要好很多，没有数据库的注入问题
>
> 2. 在效率方面，执行单次SQL语句的时候，`Statement` 的效率比`PreparedStatement`要好一些
>
>    因为`Statement` 在执行一条SQL语句的时候，只会与数据库通信一次，而`PreparedStatement` 要通信两次
>    
>    `PrepareStatement` 使用的比`Statement` 多很多。`Statement` 几乎不用。

![](.\assets\jdbc\Statement建立连接.png)

![](.\assets\jdbc\PreparedStatement建立连接.png)

# 批处理 `.addBatch()`

比如，你想往数据库里面插入大量数据。 100w

其实就是批量的处理SQL语句，典型的业务场景就是一次插入大量的数据。在今后，如果需要大家使用JDBC批量插入数据，可以使用这些方法。

## for循环逐条插入

```java
// for循环来做
public static void batchUseForEach() throws SQLException {

    Statement statement = connection.createStatement();

    for (int i = 0; i < 10000; i++) {

        String sql = "insert into user values ("+i+",'foreach',null,null)";

        statement.executeUpdate(sql);

    }
}
```

> 向MySQL服务器**发送了SQL语句 1w次**，SQL语句被编译了1w次，SQL语句也被执行了1w次

## `Statement` 批处理 `statement.addBatch()`

```java
// Statement 来处理
public static void batchUseStatement() throws SQLException {

    Statement statement = connection.createStatement();

    for (int i = 10000; i < 20000; i++) {
        String sql = "insert into user values ("+i+",'batchUseStatement',null,null)";
        // 相当于在内部有一个容器。 
        statement.addBatch(sql);
    }

    // 发送SQL语句，执行
    statement.executeBatch();

}
```

> 向MySQL服务器**发送了SQL语句 1次**，这一次中包含1w条SQL语句信息，SQL语句被编译了1w次，SQL语句也被执行了1w次

## `PreparedStatement` 批处理

> **需要在数据库的`url`后面加上配置**：`rewriteBatchedStatements=true` ，表示开启批处理

```java
// PreparedStatement来处理
public static void batchUsePrepapreStatement() throws SQLException {

    // 获取PreparedStatement
    PreparedStatement preparedStatement = connection.prepareStatement("insert into user values (?,?,null,null)");


    // 循环，设置参数
    for (int i = 20000; i < 30000; i++) {

        preparedStatement.setInt(1,i);
        preparedStatement.setString(2,"PrepapreStatement");

        preparedStatement.addBatch();

    }

    // 把参数发送给MySQL服务器，执行SQL语句
    preparedStatement.executeBatch();

    // insert into user values (),(),(),(),();

}
```

> 与`MySQL`通信了 2 次，SQL语句被编译了 1 次，SQL语句被执行了 1 次

插入n条数据

for循环，通讯n次，编译n次，执行n次

statement，通讯1次，编译n次，执行n次

prepareStatement，通讯2次，编译1次，执行1次

假如需要批处理n条SQL语句，开启了`rewriteBatchedStatements`之后

|                   | 通信次数 | 编译次数 | 执行次数 | 时间 |
| ----------------- | -------- | -------- | -------- | ---- |
| for循环           | n        | n        | n        | 最长 |
| Statement         | 1        | n        | n        | 次之 |
| PreparedStatement | 2        | 1        | 1        | 最短 |

# 事务

## 介绍

> 数据库事务( `transaction`)是访问并可能操作各种数据项的一个数据库操作序列，这些操作要么全部执行,要么全部不执行，是一个不可分割的工作单位。事务由事务开始与事务结束之间执行的全部数据库操作组成。

MySQL默认是自动提交事务的，一条SQL语句就是一个事务。在下面的转账案例里，有3步骤的SQL：

1. 查询zs余额
2. zs转出1000
3. ls转入1000

希望这三条SQL操作成为一个事务。

<span style=color:red;background:yellow>**事务就是要保证一组数据库操作，要么全部成功，要么全部失败。**</span>

比如转账操作，涉及到几个方面。

账户余额表。 zs  1000 |   ls 5000 

现在zs要给ls转账，转500。现在在数据库里面，我们要进行两部操作。

1. 扣zs的钱，扣500
2. 给ls增加钱，增加500

A给B转账。涉及到两个操作，需要给A账户扣钱，然后给B账户增加钱。

如果在这个操作的过程中，出现了异常。可能会导致A账户的钱扣了，B账户的钱没有增加。

## 使用事务

开启事务

提交事务

回滚事务

- API

  ```java
  //  开启事务
  connection.setAutoCommit(false);
  
  // 提交事务
  connection.commit();
  
  // 回滚事务
  connection.rollback();
  ```

- 命令

  ```sql
  # 开始事务
  start transaction;
  
  # 提交事务
  commit;
  
  # 回滚事务
  rollback;
  ```

```SQL
create table account(
    id int primary key auto_increment,
    name varchar(50),
    money int ,
    create_time timestamp  default current_timestamp ,
    update_time timestamp  default current_timestamp on update current_timestamp
);

-- name是唯一的。   

insert into account(name, money) values ("aa", 20000);
insert into account(name, money) values ("bb", 23000);
insert into account(name, money) values ("cc", 200000);
```

```java
    private static boolean transfer(String fromName, String toName, int money) throws SQLException, ClassNotFoundException {

        // 1.获取连接
        Connection connection = JdbcUtils.getConnection();

        // 2.开启事务
        connection.setAutoCommit(false);

        try {
            // 3.1 扣A的钱
            // update account set money = money - ? where name = ? and money > ?
            PreparedStatement preparedStatementA = connection.prepareStatement("update account set money = money - ? where name = ? and " + "money > ?");
            preparedStatementA.setInt(1, money);
            preparedStatementA.setString(2, fromName);
            preparedStatementA.setInt(3, money);

            int affectedRowsA = preparedStatementA.executeUpdate();
            System.out.println(affectedRowsA);

            if (affectedRowsA != 1) {
                throw new RuntimeException("A账户信息不对" + affectedRowsA);
            }

            //int i = 1 / 0;


            // 3.2 增加B账户的钱
            // update account set money = money + ? where name = ?
            PreparedStatement preparedStatementB = connection.prepareStatement("update account set money = money + ? where name = ? ");
            preparedStatementB.setInt(1, money);
            preparedStatementB.setString(2, toName);

            int affectedRowsB = preparedStatementB.executeUpdate();
            System.out.println(affectedRowsB);

            if (affectedRowsB != 1) {
                throw new RuntimeException("B账户信息不对" + affectedRowsB);
            }

            connection.commit();

        } catch (Exception e) {
            e.printStackTrace();
            connection.rollback();
            return false;
        }
      
        return true;
}
```

## 特性

事务通常具有四个标准特性（ACID）：

- 原子性（Atomicity）

  事务是一个不可分割的操作单元（数据库的操作），事务中的操作要么就都成功，要么就都不成功。

- 一致性（Consistency）

  事务必须使数据库从一个**一致性状态**到另外一个一致性状态。

  在转账案例中，一致性是指 在转账前和转账后，（无论怎么转账），钱的总金额是前后一致的，不变的

- <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**隔离性（Isolation）**</span>

  事务与事务之间是互相隔离的，互不影响的。

  > 数据库有为隔离性设置不同的隔离级别。不同的隔离级别对于隔离性的影响是不一样的

- 持久性（Durability）

  一个事务一旦生效，那么对数据库的改变是**永久的**，不可逆转的。意思就是提交了事务之后，就已经对数据库产生的变化，那么后续再回滚就回滚不了了。

## 并发事务引发的问题

+ 脏读
+ 不可重复读
+ 幻读

## 隔离级别

当数据库有<span style=color:red;background:yellow>**多个事务同时执行**</span>的时候，可能会出现问题。

脏读（dirty read）、不可重复读（non-repeatable read）、幻读（phantom read）的问题。

- <font color=red>**脏读**</font>

  > 一个事务读取到了另外一个事务没有提交的数据。（这个比较严重）

- <font color=red>**不可重复读**</font>

  > 在同一个事务中，读取同一个数据，前后读取的数据不一致。
  >
  > 通常指的是，在一个事务中，读取到了另外一个事务已经提交的数据。

- <font color=red>**幻读**</font>

  > 指在同一个事务中，读取同一个表数据，前后读取的数量不一致。
  >
  > 通常指的是，在一个事务，读取到了另外一个事务插入或者删除的数据。

事务的隔离级别：

一个参数，可以用来控制事务和事务之间的隔离性。

- <font color=red>**读未提交**</font>（read uncommitted）

  > 读未提交是指，一个事务还没提交时，它做的变更就能被别的事务看到。
  >
  > 会产生脏读。不可重复读，幻读 会不会造成？

- <font color=red>**读已提交**</font> (read committed)

  > 读提交是指，一个事务提交之后，它做的变更才会被其他事务看到。

- <font color=red>**可重复读**</font> (repeatable read)

  > <span style=color:yellow;background:red>**这个是MySQL默认的隔离级别**</span>
  >
  > 可重复读是指，一个事务执行过程中看到的数据，总是跟这个事务在启动时看到的数据是一致的。当然在可重复读隔离级别下，未提交变更对其他事务也是不可见的。

- <font color=red>**串行化**</font> (serializable)

  > 串行化，顾名思义是对于同一行记录，“写”会加“写锁”，“读”会加“读锁”。当出现读写锁冲突的时候，后访问的事务必须等前一个事务执行完成，才能继续执行。
  >
  > 实际工作中很少采用该级别。

  >  <font color=red>**注意：**</font>你隔离得越严实，效率就会越低。因此很多时候，我们都要在二者之间寻找一个平衡点。



MVVC 

数据库这块，建议大家学的更深一点。

因为数据库问的非常多。工作过程中，使用的知识点非常少（基本就是用用SQL）。但是面试的时候，会经常问 索引，事务的隔离级别，锁，MVVC。

在工作过程中，对隔离级别基本没有感知。面试官希望通过一个难的知识点，来确定，你的学习能力，以及是否有解决问题的能力。

## 演示

<font color=red>**准备条件：**</font>有一张表，表里只有一条数据。

```SQL
create table t(
	value int
);
insert into t values (1);

-- test_52th3 代表直接进入这个库
-- 代表我进入之后不用调用 use test_52th3 
mysql -uroot -p123456 test_53th
```

```SQL
# 获取当前数据库的隔离级别
select @@transaction_isolation;
select @@tx_isolation;

# 设置隔离级别
set global transaction isolation level 隔离级别;

mysql -uroot -p123456 test_53th

set global transaction isolation level repeatable read;

update t set value=1;

# 读未提交
read uncommitted;
# 读已提交
read committed;

# 可重复读
repeatable read

# 串行化
serializable;

# 注意。设置了隔离级别。必须要重新启动一下客户端，才能生效。
```

MySQL的可重复，可以解决部分幻读问题，不能完全解决。

![image-20231010135620541](.\assets\image-20231010135620541.png)

- 读未提交：V1、V2、V3均为2。
- 读已提交: V1为1，V2为2，V3为2
- 可重复读： V1,V2为1， V3为2
- 串行化: 事务2修改的过程中。会一直等待，直到事务1提交

在MySQL中的可重复读，可以部分解决幻读的问题。你去修改了这个数据，又能看到这个数据了。



学习重点

- 理解索引是什么，为什么需要索引
- 掌握索引的数据结构，其他结构为什么不行
- MySQL中索引的实现，MyISAM和InnoDB的主键索引和非主键索引
- 理解什么是回表，什么是覆盖索引

# 索引

<span style=color:red;background:yellow>**面试的重点。**</span>

索引（Index）是数据库中一种特殊的**数据结构**，它用于提高数据库查询的效率和速度。在数据库中，索引类似于书籍中的目录，可以根据关键字快速定位到数据所在的位置，从而加速查询操作。

索引通常包括一个或多个列，每个列包含一个唯一的值，用于标识数据行。当查询语句包含一个或多个**索引列**时，数据库可以使用索引来快速定位符合条件的数据行，而**不必扫描整个数据表**。这可以大大提高查询速度，特别是对于大型数据表和复杂查询语句的情况下。

在数据库中，常用的**索引类型**包括**主键索引**、**唯一索引**、**普通索引**等。不同的索引类型适用于不同的查询场景，开发人员需要根据实际需求选择合适的索引类型。

需要注意的是，索引虽然可以提高查询效率，**但也会占用一定的存储空间**。因此，在设计数据库时需要仔细考虑索引的使用，避免过度使用索引导致数据库性能下降。同时，**索引的维护也需要一定的时间和资源**，因此需要根据实际情况定期进行索引优化和维护。

## 介绍

> 单表数据库最多在1000w数据左右。太多了之后查询性能会急剧下降。
>
> 执行一条SQL
>
> ```SQL
> select * from user;
> ```
>
> 如果是每个记录都查询一次，那么执行1000w次比较，耗时十分巨大。

什么是索引呢？索引其实就是一种可以帮助我们<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**提高查询速度**</span>的<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**数据结构**</span>。

索引类似于一部字典开头的目录，可以帮助MySQL提高查询语句的效率。

![image-20231013202742760](.\assets\image-20231013202742760.png)

![image-20231013202756895](.\assets\image-20231013202756895.png)

![image-20231013202813614](.\assets\image-20231013202813614.png)

## 索引的数据结构

> 把握3个考察指标进行比较不同的数据结构，得出使用b+树作为MySQL索引的结构

我们说索引是一个可以帮助我们高效获取数据的数据结构，那么索引采用的是什么样的数据结构呢？

**去探讨一个数据结构适不适合当索引主要有以下三个考察指标**：

- **查询单个值**

  ```SQL
  select * from user where id=10;
  ```

- **查询范围值**

  ```sql
  select * from user where id between 1 and 10;
  select * from user where age < 18;
  ```

- **插入数据**

  ```sql
  insert into user(name,age) values ("zhangsan", 20);
  ```

### **常见的数据结构**

数组，链表，有序数组，二叉搜索树，B树，B+树，Hash表

#### **数组**

![image-20231013202905072](.\assets\image-20231013202905072.png)

查找单个值，速度慢。因为要比较所有的数据

查找范围值，速度慢，因为要比较所有数据

插入值，速度快。

#### **链表**

![image-20231013202953580](.\assets\image-20231013202953580.png)

查找单个值，速度慢。因为要比较所有的数据

查找范围值，速度慢，因为要比较所有数据

插入值，速度快。

#### **有序数组**

- 查询单个值：速度快。采用二分法
- 查询范围值：速度快。因为是有序的，先查找一个边界，然后再顺着走。
- 插入数据：速度慢。因为插入一条数据，需要挪动数据。

有序数组，一般不用来做索引。但是适用于存储不需要频繁插入和删除的历史数据。

#### **二叉搜索树**

左小右大。

![image-20231013203132001](.\assets\image-20231013203132001.png)

> **定义：**
>
> - 它或者是一棵空树，或者是具有下列性质的二叉树： 
>
> - 若它的左子树不空，则左子树上所有结点的值均小于它的根结点的值；
>
> - 若它的右子树不空，则右子树上所有结点的值均大于它的根结点的值； 
> - 它的左、右子树也分别为二叉排序树。
>
> 优点： 查找单个数据方便，查找范围值不方便。
>
> 缺点：只有两个孩子。当数据量增大的时候，树的高度会升高，这个时候查询的次数就会变多。随着数据量的增大，会影响查询速度。
>
> 左子树的所有值，小于根节点的值。右子树的所有值，大于根节点。

查找单个值，速度快。
查找范围值，速度中等，因为要在父节点和子节点之间反复跳转。

插入数据，速度快。

#### **红黑树**

特殊的二叉搜索树。

查找单个值，速度快。
查找范围值，速度慢，因为要在父节点和子节点之间反复跳转。

插入数据，速度快。



存储信息的密度，高不高。

存储100w大小的表时，树高度是log2(100w)约为20。

关系型数据库，数据都是放在磁盘里面。一层就要读一次磁盘。

100w条数据。

`select * from user where id=50301;`

10ms * 20次 = 200ms = 0.2s

指针在MySQL里是6个字节，Bigint是8个字节

磁盘操作一次读写16K字节。

- 搜索树(B树、B+树)

  - B树

    - 查询单个值	 比数组和链表要方便很多，比二叉树高度降低了，查询的效率也变高了
    - <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**查询范围值     查询范围值需要在父子节点之前反复查找，其实不太方便**</span>
    - 插入数据：速度快

    ![image-20231013203645321](.\assets\image-20231013203645321.png)

    > B树对比红黑树和二叉树最大的进步：树的高度降低了，查询效率变高了。

    > **为什么说树的高度降低了之后，查询效率会变高**？
    >
    > 这个主要是和磁盘的读取策略以及 数据库的设计策略有关系。
    >
    > 结论：数据库在读取数据的时候，每一层会经过一次磁盘IO。假如数据的高度比较高，那么就需要经过多次的磁盘IO才能找到对应的数据，树的高度降低了之后，磁盘IO的次数会减少，那么这个时候查询速度增高。

  - B+树（Btree）

    - B+树其实就是在B树的基础之上进行了优化。

      - 叶子节点之间维护一个指针，方便了范围查找

      - 所有的非叶子节点，都在叶子节点中冗余一份

      - 所有的非叶子节点，只存储`key`，不存储`data`，会降低树的高度，进一步提高查询的效率。

      - > `key` 和 `data` 的解释：`data`是SQL语句中要查找的内容。可以通过存储一个地址来简化存储的大量内容。

    - 查询单个值	比较方便

    - <span style='color:red;background:yellow;'>查询范围值    比较方便</span>（因为叶子节点之间维护了一个指针，指向下一个叶子节点）

    - 插入值：方便

    - B+树其实也是MySQL官方推荐我们使用的数据结构。Btree

    - MySQL对标准的B+树做了一些优化。主要就是增加了回去的指针。

![image-20231013203902293](.\assets\image-20231013203902293.png)



- Hash表

  hash索引。在MySQL中，也有一种索引类型，叫做Hash索引，底层使用的是Hash表。

  ![image-20231013203937936](.\assets\image-20231013203937936.png)

  - 查询单个值：很方便，相对于B+树来说要方便一些
  - 查询范围值：很不方便，需要一个一个查。
  - 插入值：方便

  Hash索引是MySQL内部使用的一种索引，没有开放给用户使用。

> 我们选来做索引的就是B+树。 
>
> 索引的结构为什么选B+树。为啥不选红黑树做索引？
>
> 先分析一些显而易见的不适合用来做索引的（数组 链表  有序数组）。再对比分析，为什么红黑树和二叉搜索树不行，主要的问题，是存储信息的密度太低。

可视化数据结构：https://www.cs.usfca.edu/~galles/visualization/RedBlack.html

## 索引的实现

索引的实现其实就是去介绍一下，数据库中数据到底是怎样存储的。在介绍这个之前，我们需要先了解一下**数据库的组成结构**。

![image-20231013204134743](.\assets\image-20231013204134743.png)

（图容为sql语句执行流程图：连接器，分析器等）

了解了MySQL的结构之后，那我们就可以知道，数据的存储和存储引擎息息相关。不同的存储引擎存储数据的方式是不一样的。

MySQL底层的存储引擎是作为一个插件存在。

**存储引擎就是MySQL底层怎样组织这些数据。（这些数据最终都是在磁盘上的），也就是在磁盘上怎样组织这些数据。**

在MySQL中，有很多种存储引擎

- InnoDB（5.1之后默认的存储引擎），这个存储引擎其实一开始是以插件的形式存在的，在5.1之后，MySQL官方团队把InnoDB当成了默认的存储引擎。
- MyISAM（5.1之前默认的存储引擎），这个存储引擎是由MySQL的官方团队开发的。亲儿子。
- Memory（基本不用）

### MyISAM

`C:\ProgramData\MySQL\MySQL Server 5.7\Data`

![image-20231013204314006](.\assets\image-20231013204314006.png)

（图容为数据库在资源管理器的文件目录）

首先，来看一下MyISAM这种存储引擎是怎样存储数据的。

MyISAM的表都有三个文件：

![image-20231013204336663](.\assets\image-20231013204336663.png)

- `.frm`

  表结构定义文件。表里有哪些列，列的类型。

- `.MYD`

  数据文件，其实也就是这个表中的数据都存储到这个文件中

- `.MYI`

  索引文件，这个表中的所有的索引树都是存储在这个文件中

```SQL
mysql> create table t_myisam (
  ID int primary key,
  k int NOT NULL DEFAULT 0, 
  s varchar(16) NOT NULL DEFAULT '',
    -- index关键词 表明我想创建一个索引
    -- k 索引的名字
    -- (k) 索引列
  index k_name(k)
) engine=MyISAM;

insert into t_myisam values(100,1, 'aa'),(200,2,'bb'),(300,3,'cc'),(500,5,'ee'),(600,6,'ff'),(700,7,'gg');
```



![image-20231013204411929](.\assets\image-20231013204411929.png)

![image-20231013204451185](.\assets\image-20231013204451185.png)

MyISAM的索引分为两种类型，一种叫做主键索引，一种叫做非主键索引。

对于MyISAM来说，`.MYI`文件里面存储的是索引，`.MYD`文件里面存储的data。

对于它的主键索引，`key`是主键值，`data`是地址值。

对于它的非主键索引，`key`是索引值，`data`是地址值。

#### 主键索引

主键索引是指MyISAM默认会根据主键这一列的值，去建立一个B+树，这个B+树就叫做主键索引树。

- `key`：主键值
- `data`：主键这一行数据对应的地址值

#### 非主键索引

MyISAM中的非主键索引，是指我们可以把其他的非主键列声明为索引列，那么这样MyISAM就可以帮助我们根据这一列的值去建立一个索引树。意味着一个表可以有多个索引树。

- `key`：索引列的值
- `data`：索引列这一行数据对应的地址值

对于MyISAM中的索引来说，数据和索引是分开存储的，这种索引叫做 <span style=color:red;background:yellow>**非聚集索引。**</span>

### InnoDB

InnoDB的索引分为两种类型，一种叫做主键索引，一种叫做非主键索引。

每一个InnoDB表都有两个文件：

![image-20231013204651329](.\assets\image-20231013204651329.png)

- `.frm`

  表结构定义文件

- `.ibd`

  数据和索引文件：这个文件中存储了数据和索引。

```SQL
mysql> create table t_innodb (
  ID int primary key,
  k int NOT NULL DEFAULT 0, 
  s varchar(16) NOT NULL DEFAULT '',
  index k(k)
) engine=InnoDB;

insert into t_innodb values(100,1, 'aa'),(200,2,'bb'),(300,3,'cc'),(500,5,'ee'),(600,6,'ff'),(700,7,'gg');
```

#### 主键索引

![image-20231013204730162](.\assets\image-20231013204730162.png)

`key`：主键值

`data`：主键这一行对应的其他列的数据

在InnoDB的<span style=color:red;background:yellow>**主键索引中**</span>，索引和数据是存储在同一个数据页中，也就是索引和数据是存储在一起的，这种叫做<span style=color:red;background:yellow>聚集索引</span>。

> 在InnoDB中，**数据是依附于主键索引树来存储的**，假如没有主键的话，那么就不存在主键索引树，那么数据也没办法存储。
>
> 所以对于InnoDB的表来说，<span style=color:red;background:yellow>**必须得有一个主键。**</span>
>
> 对于InnoDB的表来说，如果用户在建表的时候，没有设置主键，那么InnoDB会维护一个隐藏的列来当做主键。

对于InnodDB表，创建表时，没有设置主键。会去找第一个 `unique`索引，并且非空的列，来作为主键索引。

比如表里面有几个字段。 k字段   s 字段   ; 在s字段上，我们设置`unique`  还设置了`not null`。这时候InnoDB就把它当做主键来看待。

在这个s字段的B+树上面，data区域，存储这一行其他的数据。

没有都没有，那么InnoDB会维护一个隐藏的列来当做主键。

1. `MyISAM`使用索引存储。主键索引和非主键索引，其实存储的都是地址。都需要去数据文件中找这个数据

2. `InnoDB`使用索引存储，主键索引，直接存储的是数据。非主键索引，存储的是主键的值。

`select * from t where k=3;`

#### 非主键索引

非主键索引是指根据其他的列建立的索引。

![image-20231013205013046](.\assets\image-20231013205013046.png)

`key`：索引列的值

`data`：这一行数据对应的主键值

在InnoDB的非主键索引中，索引只和主键存储在到了一起，实际上没有和数据存储在一起，其实也是<span style=color:red;background:yellow>**非聚集索引。**</span>

<span style=color:red;background:yellow>**对于MyISAM来说**</span>，主键索引和非主键索引，都是怎么存的？

都是存的B+树，然后key是索引的值，value都是存的地址。这个地址是指向MYD文件里面的。

<span style=color:red;background:yellow>**对于InnoDB来说，**</span>主键索引和非主键索引。

主键索引，存的B+树，key是主键的值，value是这一行的其他值。

（100,1，'aa'）

对于非主键索引，key存的是索引的值，value是主键的值。

### MyISAM 与InnoDB的区别 ⚡ 

> 面试问了解哪些存储引擎，为什么InnoDB可以替换掉MyISAM

- 存储的文件不一样，MyISAM有三个文件、InnoDB只有两个文件。

- <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**InnoDB支持事务、MyISAM不支持事务**</span>

  > 既然MyISAM不支持事务，那么MyISAM还有没有用呢？
  >
  > 有用，因为**支持了事务会使效率有一定降低**。MyISAM效率高一些，可以用于存储不需要事务的场景提高速度，比如查询历史数据不需要增删改的操作。
  >
  > 什么样的表不需要事务呢？存储什么样的数据才不需要事务呢？什么样的数据不需要使用增删改呢？ **历史数据。** **普通的日志数据。**

- InnoDB支持外键，MyISAM不支持外键

- InnoDB支持表锁和行锁，MyISAM只支持表锁

  ![image-20231013205104023](.\assets\image-20231013205104023.png)

（图容为表锁和行锁的举例）

## InnoDB举例

还是使用之前的数据。

```SQL
mysql> create table T (
  ID int primary key,
  k int NOT NULL DEFAULT 0, 
  s varchar(16) NOT NULL DEFAULT '',
  index k(k)
) engine=Innodb;

insert into T values(100,1, 'aa'),(200,2,'bb'),(300,3,'cc'),(500,5,'ee'),(600,6,'ff'),(700,7,'gg');
```

![image-20231013205218886](.\assets\image-20231013205218886.png)

（图容为ID索引树和k索引树）

如果现在查询一条SQL，经历怎样的过程？

如果查询的SQL是这样的：  select * from T where id=500;

### 回表

`select * from T where k =3;`

- 在k索引树上找到k=3的记录，取得ID=300
- 再到ID索引树查到ID=300对应的行

在这个过程中，**回到主键索引树搜索的过程**，我们称为<span style=color:yellow;background:red>**回表**</span>。可以看到，这个查询过程读了 k 索引树的 3 条记录（步骤 1、3 和 5），回表了两次（步骤 2 和 4）。在这个例子中，由于查询结果所需要的数据只在主键索引上有，所以不得不回表。那么，有没有可能经过**索引优化**，**避免回表过程**呢？

如果我们写得SQL是这样：  `select id from T where k=3;`

后续，为了避免回表，需要什么字段就拿什么字段，不要写 `*` 。

`select * from T where k between 3 and 5;`

- 去k索引树上找，k=3。拿到id=300
- 回主键索引树，取得这一行的数据。
- 去k索引树，往后拿5，拿到id=500
- 回主键索引树，取得这一行的数据。 拿id=500的数据
- 再往后拿，拿到k=6. 不符合条件，结束。 

> 有时候发现，有一条SQL，特别慢，怎么办？
>
> 检查where里面是否有索引，如果没有，尝试改造SQL，让where里面的条件走到索引。

### 覆盖索引

`select ID from T where k =3`

如果执行的语句是 这时只需要查 ID 的值，而 ID 的值已经在 k 索引树上了，因此可以直接提供查询结果，不需要回表。也就是说，在这个查询里面，索引 k 已经“覆盖了”我们的查询需求，我们称为<span style=color:yellow;background:red>**覆盖索引**</span>。由于覆盖索引可以减少树的搜索次数，显著提升查询性能，所以使用覆盖索引是一个常用的性能优化手段。

今后建议大家，不要写  `select * from T where k=3;` 需要哪些列，你就把这些列，全部写出来。

## 索引的语法

>  我们给一个列声明为主键，默认主键这一列就会是主键索引（主键这一列会默认创建一个主键索引树）

```sql
-- 查询索引
show index from innodb_user;

drop table if exists student;
-- 建立索引
create table student(
	id int PRIMARY KEY,
	name varchar(20),
	age int(10),
	gender varchar(10),
    -- index  索引的名字(列名)
    -- -- index  索引的名字(列名1, 列名2)
	index idx_name(name) using BTREE
)ENGINE=InnoDB character set utf8;

select * from student;

show index from student;

-- 删除索引
-- alter table TABLE_NAME drop index INDEX_NAME;
alter table student drop index idx_name;

-- 添加索引
alter table student add index idx_age(age);

alter table student add index idx_name_age(name,age);
```

> 发现一条SQL特别慢怎么办？
>
> 首先看一下这个SQL，SQL语法是否有问题。
>
> 其次，如果条件没有办法动，尝试建索引。
>
> `explain`命令，可以看查询的过程，查询中是否走了索引。

## 高频面试题

1. **索引采用的是什么数据结构？为什么采用这种数据结构？**

   B+树。对于为什么的回答，列举其他的数据结构，从SQL执行的3个考察角度（执行查询单个值，查询范围值，插入数据），分析每个数据结构的表现。

2. **数据库为什么推荐使用自定义主键，并且在MySQL中使用推荐使用主键自增的策略？**

   - 自定义主键：MySQL默认的使用的是InnoDB存储引擎，那么InnoDB存储引擎的数据和主键索引树是绑定在一起的，假如没有主键索引树，那么数据没有办法存储。假如没有给表指定主键的话，那么InnoDB会创建一个隐藏的列来当做主键，并建立主键索引树。假如使用了隐藏的列来当做的主键的话，那么我么查询的时候，就会浪费主键索引索引树带来的索引性能，所以推荐自己定义主键。

   - 自增的策略：

     因为自增的策略，在插入的时候，永远只会插入到索引树的右侧，那么这样就能**保证树的结构不会发生比较大的改变**，而结构改变是需要消耗时间的，所以这样就能保证插入的效率会比较稳定。

     ```SQL
     create table student1(
     	id int primary key auto_increment,
         name varchar(255),
       create_time timestamp default current_timestamp,
       update_time timestamp default current_timestamp on update current_timestamp
     )
     ```

3. **InnoDB和MyISAM有什么区别？什么情况下使用MyISAM？**

   见上文。

4. **什么是回表？如何避免回表？**

   ```sql
   create table ts(
   	id int PRIMARY KEY,
   	name varchar(20),
   	age int,
   	index idx_name(name,age) using BTREE
   )character set utf8;
   
   
   select * from ts where id = 1;  -- 查询主键索引树、查询速度快
   
   select * from ts where age = 20;  -- 遍历整个主键索引树、查询速度很慢
   
   -- 先查询index_name 整个索引的索引树，查询到的结果是主键
   -- 再根据查询到的主键值 去主键索引树查询 对应的数据
   select id,name,age from ts where name = '张三'; 
   ```

> 回表：在一次查询中，假如需要先根据非主键索引树查询主键值，然后再根据主键值查询主键索引树，这种查询了两遍索引树的情况，叫做回表。
>
> 在实际的工作中，应该要尽量避免回表的情况出现，如何避免呢？
>
> - 尽量使用主键查询
>
> - 尽量避免写 `select *`
>
> - 可以考虑使用联合索引，多个列创建一个索引。

5. **索引性能这么好，是不是一个表建立的索引越多越好？**

   > 不是。
   >
   > 1. 声明一个索引列，需要建立一个索引树，需要占用空间
   > 2. 假如声明的索引变多了之后，对应的索引树也会变多，查询的效率固然会提升，但是增删改的时候要去改变数据，改变数据势必会改变索引树的结构，维护这些索引树的成本也就提升了，增删改的效率也就降低了。
   >
   > 那么一般针对单张表，建立几个索引比较合适呢？通常**默认为一个表建立的索引不要超过5个**。

6. **什么样的列适合当索引？**

   - 数据不重复出现的
   - 值尽量不为空的（`null`）
   - 业务场景中查询条件比较多的

   - 这一列的值不经常变化的

B+树和二叉搜索树的效率。

对于Innodb的B+树来说，节点大小是16k。

id bigint ，还有引用，在MySQL中大概占6字节。bigint 8个字节。总共14个字节。

16 * 1024 / 14 = 1170个数据

三层存储大概 1170 * 1170 * 1170  = 27亿。可以使用非常小的层数存下非常大的数据。



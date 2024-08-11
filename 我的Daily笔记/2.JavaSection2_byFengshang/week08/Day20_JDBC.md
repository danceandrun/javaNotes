[toc]

## JDBC优化

- 提取工具类
- 连接配置放入到配置文件中
- 注册驱动利用反射，解耦
- 关闭资源（提取公共方法）



 ⚡为什么参数写在配置文件里？

因为修改了代码，后续的流程很长。在企业中，修改代码不可能直接放到线上环境跑，需要进行回归测试，但是更改配置文件不需要重新测试。



 ⚡整个代码中只有`Driver`类来自mysql，

`Driver`类有一个静态代码块，发现只要它加载进来，静态代码块就会执行`DriverManager.registerDriver(new Driver())`

可以通过反射将这个类加载进来。

`Class.forname("com.mysql.jdbc.Driver")`

（怎样做到解耦的？）这样可以做到在编译时看不到这个类，运行时会用到这类，这样就使得只用jdbc里面的接口，为后续不使用mysql，需要切到oracle等别的数据库时提供了可能。



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

数据库注入是一种常见的网络安全漏洞，它发生在应用程序与数据库之间的数据交互中。数据库注入攻击是利用不安全的输入验证或不正确的数据处理，将恶意的SQL（结构化查询语言）代码嵌入到应用程序的输入字段中，从而使攻击者能够执行未经授权的数据库操作。这种攻击可能导致系统被入侵、数据泄露、破坏数据完整性，甚至是完全控制系统。

数据库注入攻击的原理是，应用程序没有充分**验证或转义**用户输入，使攻击者能够在输入字段中插入恶意的SQL代码。

> 数据库注入是一种常见的网络安全漏洞，攻击者利用这种漏洞向网站或应用程序的数据库中插入恶意代码，从而获取敏感信息、执行非法操作等。例如：
>
> 假设有一个登录页面，用户需要输入用户名和密码才能登录。该页面的后端代码使用SQL查询语句来验证用户的身份，例如：
>
> ```SQL
> SELECT * FROM users WHERE username = 'input_username' AND password = 'input_password';
> ```
>
> 其中，'input_username'和'input_password'是用户在登录页面上输入的值。如果用户输入的值与数据库中的值匹配，则允许用户登录，否则拒绝登录。
>
> 然而，攻击者可以在输入框中输入一些恶意代码，例如：
>
> ```SQL
> input_username: root
> input_password: xxx' or ' 1=1
> ```
>
> 这个输入会更改SQL查询语句，变成：
>
> ```SQL
> -- 下面这条SQL的含义，是这样的   1=1是恒等的，所以where条件相当于会没有任何条件
> -- SELECT * FROM users WHERE (username = 'admin' AND password = 'xxx') or '1=1';
> SELECT * FROM users WHERE username = 'admin' AND password = 'xxx' or ' 1=1';
> 
> SELECT * FROM users WHERE username = 'admin' AND password = 'xxx' ;drop database test1';
> 
> ```
> 
>这个SQL语句的含义是“从users表中选择任何一个行，其中用户名为空或1等于1，并且密码为空”。由于1等于1始终为真，因此这个SQL语句将返回users表中的所有行，从而绕过了身份验证，攻击者可以以任何用户的身份登录系统。这就是一个典型的SQL注入攻击。
> 
>为了避免SQL注入攻击，**必须对用户输入的值进行过滤和转义**，或使用预处理语句等安全措施来防范这种攻击。



```java
 public static void main(String[] args) throws SQLException {

//        Boolean ret = login("天明", "upan");

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

> 数据库SQL注入问题产生的原因：因为SQL语句是通过字符串拼接的，这个时候用户可能输入一些字符，这些字符中包含有SQL语句中的关键字，那么通过字符串拼接SQL语句之后，可能会改变SQL语句的格式，进而引发安全性的问题。
>
> 根本的原因：**MySQL把用户输入的参数当做关键字来解析了**

> 如何解决数据库注入问题呢？
>
> - PrepareStatement（预编译的Statement）

```java
// 登录方法2
    public static Boolean login2(String username,String password) throws SQLException {

        // 1. 获取连接
        Connection connection = JDBCUtils.getConnection();

        // 2. 获取PreparedStatement
        // 这一步，在创建PreparedStatement的时候，PreparedStatement会把当前这个没有参数的SQL语句，发送给MySQL服务器，执行预编译
        // 预编译：其实就是去解析这个SQL语句中的关键字，变成MySQL可以执行的命令
        // 在预编译之后，后续输入的字符串，就只会被MySQL当成纯文本来解析
      //传参的地方先用?用来占位
        PreparedStatement preparedStatement = connection.prepareStatement("select * from user where name = ? and password = ?");


        // 3. 设置参数
      //数据库的Index比较特殊，都是从1开始编号
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



两者执行过程对比：

`Statement`的执行过程中客户端传一个`Stirng`, 服务器：1.词法解析，语法解析，判断是否有问题；2.编译,编译成语法树；3.执行SQL

![image-20220513112333234](img-jdbc/image-20220513112333234.png)

`Preparedstatement`的执行过程中客户端通过`connection`的方法`prepareStatement`先与服务器交互，服务器执行前两步：1.词法解析，语法解析，判断是否有问题；2.编译,编译成语法树；编译之后已经确定了关键字。然后客户端设置参数，再传给服务器执行SQL。这样服务器不会再将参数进行编译，直接当作字符串。

![image-20220513175504026](img-jdbc/image-20220513175504026.png)



> 总结：
>
> 1. 在安全性方法，`PreparedStatement`比`Statement`要好很多，没有数据库的注入问题
>
> 2. 在效率方面，执行单次SQL语句的时候，`Statement`的效率比`PreparedStatement`要好一些
>
>    因为`Statement`在执行一条SQL语句的时候，只会与数据库通信一次，而`PreparedStatement`要通信两次
>
>    `PrepareStatement`使用的比`Statement`多很多。`Statement`几乎不用。



# 批处理

比如，你想往数据库里面插入大量数据。 1w

其实就是批量的处理SQL语句，典型的业务场景就是一次插入大量的数据。在今后，如果需要大家使用JDBC批量插入数据，可以使用这些方法。

批处理的几种方式：

- 使用`for`循环
- 使用`statement` 的批处理方法
- 使用`prepareStatment`的批处理

## `for`循环逐条插入

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

> 向MySQL服务器发送了SQL语句 1w次，SQL语句被编译了1w次，SQL语句也被执行了1w次

## `statement`批处理

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

> 向MySQL服务器发送了SQL语句 1次，这一次中包含1w条SQL语句信息，SQL语句被编译了1w次，SQL语句也被执行了1w次

## `PreparedStatement`批处理

> 需要在数据库的url后面加上配置：rewriteBatchedStatements=true ，表示开启批处理

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
 
    // 开启了rewriteBatchedStatements参数之后 
  // insert into user values (),(),(),(),();

}
```

> 与MySQL通信了2次，SQL语句被编译了一次，SQL语句被执行了一次.

插入n条数据

for循环，通讯n次，编译n次，执行n次

statement，通讯1次，编译n次，执行n次

prepareStatement，通讯2次，编译1次，执行1次（开启了rewriteBatchedStatements参数）



假如需要批处理n条SQL语句，开启了rewriteBatchedStatements之后

|                   | 通信次数 | 编译次数 | 执行次数 | 时间 |
| ----------------- | -------- | -------- | -------- | ---- |
| for循环           | n        | n        | n        | 最长 |
| Statement         | 1        | n        | n        | 次之 |
| PreparedStatement | 2        | 1        | 1        | 最短 |

# 事务

## 介绍

> 数据库事务( transaction)是访问并可能操作各种数据项的一个数据库操作序列，这些操作要么全部执行,要么全部不执行，是一个不可分割的工作单位。事务由事务开始与事务结束之间执行的全部数据库操作组成。

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
    id int primary key,
    name varchar(50),
    money int ,
    create_time timestamp  default current_timestamp ,
    update_time timestamp  default current_timestamp on update current_timestamp
);

insert into account (id,name,money) values (1, "风华", 50000);
insert into account (id,name,money) values (2, "俊威", 300000);
insert into account (id,name,money) values (3, "豆豆", 600000);

我们这张表里有个假设。 名字唯一。
id  银行卡。
```



现在写代码主要用`prepareStatement`

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

   ⚡事务必须使数据库从一个一致性状态到另外一个一致性状态。

  原子性强调操作，而一致性强调的是数据。

  在转账案例中，一致性是指 在转账前和转账后，（无论怎么转账），钱的总金额是前后一致的，不变的。

  如何理解一致性状态？是不是和电子能级一样，只有两种状态的跃迁没有中间状态

- <span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**隔离性（Isolation）**</span>

  事务与事务之间是互相隔离的，互不影响的。

  原子性指的是同一个事务，隔离性指的是多个事务对于同一个数据库进行操作时，如果都是查询那么没有问题，但是如果有的查询但是有的增删改就可能出问题，隔离性就是保证这一点不出问题。

  > 数据库有为隔离性设置不同的隔离级别。不同的隔离级别对于隔离性的影响是不一样的

- 持久性（Durability）

  一个事务一旦生效，那么对数据库的改变是永久的，不可逆转的。意思就是提交了事务之后，就已经对数据库产生的变化，那么后续再回滚就回滚不了了

> 面试问事务的四大特性：
>
> 直接回答ACID，原子性，一致性，隔离性，持久性。一般不需要进一步解释，当问如何理解其中某一个性质时再深入讲一下。

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

脏读的问题是范围最宽泛的，出现脏读就很可能出现不可重复读和幻读。

事务的隔离级别：

一个参数，可以用来控制事务和事务之间的隔离性。



- <font color=red>**读未提交**</font>（read uncommitted）

  > 读未提交是指，一个事务还没提交时，它做的变更就能被别的事务看到。
  >
  > 会产生脏读。

- <font color=red>**读已提交**</font> (read committed)

  > 读提交是指，一个事务提交之后，它做的变更才会被其他事务看到。
  >
  > 解决了脏读问题，但是仍会有不可重复读和幻读的可能.

- <font color=red>**可重复读**</font> (repeatable read)

  > <span style=color:yellow;background:red>**这个是MySQL默认的隔离级别**</span>
  >
  > 可重复读是指，一个事务执行过程中看到的数据，总是跟这个事务在启动时看到的数据是一致的。当然在可重复读隔离级别下，未提交变更对其他事务也是不可见的。
  >
  > 解决了脏读和不可重复读，可以解决部分幻读问题，不能完全解决幻读。

- <font color=red>**串行化**</font> (serializable)

  > 串行化，顾名思义是对于同一行记录，“写”会加“写锁”，“读”会加“读锁”。当出现读写锁冲突的时候，后访问的事务必须等前一个事务执行完成，才能继续执行。
  >
  > 实际工作中很少采用该级别。

  

  >  <font color=red>**注意：**</font>你隔离得越严实，效率就会越低。因此很多时候，我们都要在二者之间寻找一个平衡点。



MVVC 

数据库这块，建议大家学的更深一点。

因为数据库问的非常多。工作过程中，使用的知识点非常少（基本就是用用SQL）。但是面试的时候，会经常问 索引，事务的隔离级别，锁，MVVC。



在工作过程中，对隔离级别基本没有感知。面试官希望通过一个难的知识点，来确定，你的学习能力，以及是否有解决问题的能力。



面试的时候会问。对大家后续职业生涯有帮助。

没钱的时候可以白嫖。有钱的时候建议支持支持原作者。



## 演示

<font color=red>**准备条件：**</font>有一张表，表里只有一条数据。

```SQL
create table t(
	value int
);
insert into t values (1);

-- test_53th 代表直接进入这个库
-- 代表我进入之后不用调用 use test_53th

mysql -uroot -p123456 test_53th
```





```SQL
# 获取当前数据库的隔离级别
select @@transaction_isolation;
select @@tx_isolation;

# 设置隔离级别
set global transaction isolation level 隔离级别;

mysql -uroot -p123456 test_52th3

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



![image-20221226112408097](img-jdbc/image-20221226112408097.png)



- 读未提交：V1、V2、V3均为2。
- 读已提交: V1为1，V2为2，V3为2
- 可重复读： V1,V2为1， V3为2
- 串行化: 事务2修改的过程中。会一直等待，直到事务1提交





```JAVA
后端工程
https://gitee.com/snow-lee/java-gui

前端工程
https://gitee.com/snow-lee/vue-gui
```

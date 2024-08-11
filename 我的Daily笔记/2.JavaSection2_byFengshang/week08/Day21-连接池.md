[toc]

学习目标

- 理解连接池是什么
- 掌握池化思想的好处
- 会使用第三方的连接池

# 连接池

最开始的时候这个连接是怎么建立的？

MySQL是C/S产品，命令行，navicat，JDBC都是客户端的作用，通过建立连接，以网络连接到服务器，用完之后需要断开连接。



连接池是创建和管理一个连接的缓冲池的技术，这些连接准备好被任何需要它们的线程使用。

![image-20230912140844132](.\assets\image-20230912140844132.png)



 ⚡**使用连接池有哪些好处？**

- **减少连接创建时间**

创建新的 JDBC 连接仍会有网络和 JDBC 驱动的开销。如果这类连接是“循环”使用的，使用该方式这些花销就可避免、平分。

- **简化的编程模式**

当使用连接池时，每一个单独的线程能够像创建了一个自己的 JDBC 连接一样操作，允许用户直接使用JDBC编程技术。

- **受控的资源使用**

如果用户不使用连接池，而是每当线程需要时创建一个新的连接，那么用户的应用程序的资源使用会产生非常大的浪费并且可能会导致高负载下的异常发生。

![image-20230912140941897](.\assets\image-20230912140941897.png)



> 面试时，如果面试官问连接池有什么好处、线程池有什么好处？应该怎么答呢？
>
> 池化技术（Pooling）是一种常见的**资源管理技术**，它可以通过预先创建和维护一定数量的资源实例来提高系统的性能和可靠性。池化技术的好处包括：
>
> 1. 提高性能：池化技术可以避免频繁地创建和销毁资源实例，从而减少了资源的开销和系统资源的消耗。这样可以提高系统的性能和响应速度。
> 2. 提高可靠性：池化技术可以监控资源实例的状态，如果资源实例出现异常或超时，池化技术会自动将其标记为无效实例，并重新创建新的实例。这样可以提高系统的可靠性和稳定性。
> 3. 节约资源：池化技术可以限制资源实例的数量，以避免过多的实例占用系统资源。这样可以节约资源，并提高系统的可扩展性和稳定性。
> 4. 简化开发：池化技术可以通过配置文件或代码来管理资源实例，使得开发人员可以更加方便地使用资源实例，同时也减少了一些资源管理的复杂性。
>
> 总之，池化技术是一种非常有用的技术，可以提高系统的性能、可靠性、节约资源和简化开发。在高并发、大数据量的应用场景下，使用池化技术可以发挥更加显著的优势。常见的池化技术包括连接池、线程池、对象池等。



# 自己实现的连接池

连接池的实现思路：你需要使用的时候，从池子里面（集合）取；使用完毕，放回池子。

思考连接池需要满足哪些功能？

1.对外提供连接

2.收回归还的连接

用连接池最主要的目的是要**循环使用**。

```JAVA
{
    private static List<Connection> connections;


    private static String driverClassName;
    private static String url;
    private static String username;
    private static String password;

    static {
        connections = new ArrayList<>();

        Properties properties = new Properties();
        try {
            properties.load(new FileInputStream("db.properties"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        driverClassName = properties.getProperty("driverClass");
        url = properties.getProperty("url");
        username = properties.getProperty("username");
        password = properties.getProperty("password");

        try {
            Class.forName(driverClassName);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        for (int i = 0; i < 5; i++) {
            try {
                connections.add(DriverManager.getConnection(url, username, password));
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    /**
     * 获取连接的方法，如果连接池为空，则直接返回null。
     *
     * @return 连接池对象
     */
    public static Connection getConnection() {
        if (connections.isEmpty()) {
            return null;
        }
        return connections.remove(0);
    }


    public static void returnConnection(Connection connection) {
        connections.add(connection);
    }

}
```

> - 实现了哪些功能
>   - 数据库的连接获取和释放
>   - 自动扩容
> - 未实现哪些功能
>   - 初始化容量，扩容数量的优化
>   - 最大连接数量的限制
>   - 没有超时自动回收功能



# 第三方提供的连接池

如果每一种连接池都有一种自己的获取连接的方式，会导致非常混乱。

```JAVA
// 连接池A提供的获取连接的方法
Connection getConnection(){}

// 连接池B提供的获取连接的方法
Connection aquireConnection(){}

// 连接池C提供的获取连接的方法
Connection get(){}
```

这样对于Java的使用者来说去使用第三方开源的数据库连接池就可能不太方便，那么Java开发者就在JDBC中定义了一个**数据库连接池的接口**（ `javax.sql.Datasource` ），其他的数据库连接池的实现都需要去实现这个接口，这就对我们Java开发者来说造成了极大的便利，方便我们去在Java中使用数据库连接池。

`DataSource` 接口，就是JDBC提供给我们的一个获取连接的接口。

```JAVA
public interface DataSource  extends CommonDataSource, Wrapper {

  Connection getConnection() throws SQLException;

  Connection getConnection(String username, String password)
    throws SQLException;
}
```

这里没有写还连接的方法，最后是怎么还连接的呢。因为不用归还直接close就行，因为close被重写了。

JDK实现连接池的时候可以有两种方式：

1. 提供一个归还连接的方法；
2. 直接重写close

`JDBC4Connection`

## DBCP

之前特别流行的连接池，但是由于中间几年没有更新，所以现在一般都是一些老项目在使用。

[官网](https://commons.apache.org/proper/commons-dbcp/index.html)

- 导包。需要两个包：`commons-dbcp、commons-pool`

![image-20230912141307404](.\assets\image-20230912141307404.png)

- 配置

```properties
username=root
password=123456
url=jdbc:mysql://localhost:3306/test7
driverClassName=com.mysql.jdbc.Driver
# 配置的参数。可以不用在url后面写。以分号分割
connectionProperties=characterEncoding=utf8;useSSL=false
# 初始化容量。
initialSize=10
```

- 使用

```JAVA
public class DbcpDataSource1 {
    public static void main(String[] args) throws SQLException {
        DataSource dataSource = null;

        try {
            Properties properties = new Properties();
            properties.load(new FileInputStream("dbcp.properties"));
            dataSource = BasicDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        Connection connection = dataSource.getConnection();

        ExecuteQueryByConnection.executeQuery(connection);

        connection.close();
    }
}


public class ExecuteQueryByConnection {
    public static void executeQuery(Connection connection) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement("select * from account");
        ResultSet resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            int id = resultSet.getInt("id");
            String name = resultSet.getString("name");
            BigDecimal money = resultSet.getBigDecimal("money");

            System.out.println(id + " __ " + name + " __ " + money);
        }
    }
}
```



## C3P0

dbcp断更后。出来的一个新的数据库连接池。

这里给大家演示一个问题，我们需要导两个包。有的时候忘记了，只导了一个，会出现什么问题？

`lang.NoClassDefFoundError: com/mchange/v2/ser/Indirector`

- 没导入包会出现这个问题
- 导包了，但是版本不对。
- 拿这个报错去搜索引擎搜索搜索。或者去ChatGPT问。



- 导包

  ![image-20230912141353240](.\assets\image-20230912141353240.png)

- 配置

<span style=color:red;background:yellow>**需要在src目录下，新建一个配置文件。**</span>

**方式一：(xml文件)**

<span style=color:red;background:yellow>**名字为固定**</span>的 `c3p0-config.xml`

```XML
<c3p0-config>
    <default-config>
        <property name="driverClass">com.mysql.jdbc.Driver</property>
        <property
                name="jdbcUrl">jdbc:mysql://localhost:3306/test7?characterEncoding=utf8&amp;useSSL=false</property>
        <property name="user">root</property>
        <property name="password">123456</property>

        <property name="checkoutTimeout">30000</property>
        <property name="idleConnectionTestPeriod">30</property>
        <property name="initialPoolSize">10</property>
        <property name="maxIdleTime">30</property>
        <property name="maxPoolSize">100</property>
        <property name="minPoolSize">10</property>

    </default-config>
</c3p0-config>
```

**方式二：(properties文件)**

名字为固定的： `c3p0.properties`

```properties
c3p0.driverClass=com.mysql.jdbc.Driver
c3p0.jdbcUrl=jdbc:mysql://localhost:3306/test7?characterEncoding=utf8&useSSL=false
c3p0.user=root
c3p0.password=123456
```

- 使用

```java
    static DataSource cpds;

    static {
      // 会自动去类路径下，会找指定的配置文件
      cpds = new ComboPooledDataSource();
    }
```

<span style=color:red;background:yellow>**注意：**</span>c3p0的配置文件位置，都是写死在C3p0的代码里，所以配置文件的名字和位置都只能是固定的。

## Druid

- 导包

![image-20230912141427048](.\assets\image-20230912141427048.png)

- 配置（写的配置文件，只要你有办法找到即可。但是尽量不要写绝对路径）

```properties
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test7?characterEncoding=utf8&useSSL=false
username=root
password=123456
```

- 使用

```JAVA
Properties properties = new Properties();
properties.load(new FileInputStream("druid.properties"));

DataSource dataSource = DruidDataSourceFactory.createDataSource(properties);
Connection connection = dataSource.getConnection();
```

## HikariCP

Springboot的一个数据库连接池。说明比较牛。



- 导包

![image-20230912141502212](.\assets\image-20230912141502212.png)

- 配置

```properties
jdbcUrl=jdbc:mysql://localhost:3306/test7?characterEncoding=utf8&useSSL=false
username=root
password=123456
```

- 使用

```JAVA
Properties properties = new Properties();
properties.load(new FileInputStream("hikaricp.properties"));

HikariConfig config = new HikariConfig(properties);
HikariDataSource hikariDataSource = new HikariDataSource(config);
Connection connection = hikariDataSource.getConnection();
```

HikariCP会提示没有日志包。

重点：

<span style=color:red;background:yellow>**池化思想**</span>。代码怎么写，不是特别重要，但是还是要练习。

**一定一定要能自己的话描述出来。**

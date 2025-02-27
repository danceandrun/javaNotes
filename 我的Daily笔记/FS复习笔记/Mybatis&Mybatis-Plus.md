# MyBatis

>SSM:  Spring   SpringMVC  MyBatis

# 介绍

>MyBatis本是apache基金会的一个开源项目ibatis ，2010年这个项目由apache迁移到了google code（代码管理仓库，类似GitHub）， 并且改名为Mybatis。2013年11月代码迁移到了github. Mybatis是一个基于Java的持久层框架。（DAO 或者Mapper）
>
>Mybatis是一个ORM框架。MyBatis是一种流行的Java持久化框架，用于简化数据库访问和操作。它提供了一种将数据库查询、插入、更新和删除操作与Java对象之间的映射的方式。
>
>```Java
>// ORM：Object Relationship Mapping。 对象关系映射(说白了, 就是可以把Java中的对象映射成关系)。 其实Mybatis就是一个可以帮助我们把 关系型数据库中的记录转化为 Java对象，把Java对象转化为关系型数据库中的记录的这么一个框架。
>
>举例来说。之前我们写的查询executeQuery()方法，查询user表，拿回来一个ResultSet对象，我们需要去遍历，如果我们在Java中有这样一个类User与之一一对应，这时候需要我们手动将这个类的属性设置进去，但是有了Mybatis，只要配置好映射关系，就可以自动完成映射。（也即从表中的记录 到 Java对象 这个过程）
>```
>
>Mybatis就是一个可以帮助我们在Java代码中更加高效的<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**去操作数据库**</span>的这么一个框架。

官网 : https://mybatis.org/mybatis-3/zh/index.html

传统的JDBC查询代码

```JAVA
com.cskaoyan.QueryDemo
```

```JAVA
public class QueryDemo {
    public static void main(String[] args) {
        // JDBC连接信息
        String url = "jdbc:mysql://localhost:3306/test_52th3"; // 替换为你的数据库连接信息
        String username = "root"; // 替换为你的数据库用户名
        String password = "123456"; // 替换为你的数据库密码

        // SQL查询语句
        String sql = "SELECT * FROM user";

        List<User> resultList = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String email = resultSet.getString("email");

                // 创建User对象并打印查询结果
                User user = new User(id, name, email);
                resultList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println(resultList);
    }
}
```

# 入门案例(Quick start)

> 1. `mybatis-config.xml` 数据库的一些连接信息
> 2. `mapper.xml `写SQL的地方
>    1. `namespace` :全局唯一
>    2. `id`: mapper中唯一

> 导包
>
> ```xml
> <!--mybatis-->
> <dependency>
>     <groupId>org.mybatis</groupId>
>     <artifactId>mybatis</artifactId>
>     <version>3.5.9</version>
> </dependency>
> 
> 
> <!-- 数据库驱动包 -->
> <dependency>
>     <groupId>mysql</groupId>
>     <artifactId>mysql-connector-java</artifactId>
>     <version>5.1.47</version>
>     <scope>runtime</scope>
> </dependency>
> ```

配置一: 配置一个Mybatis的**主配置文件**，用来获取`SqlSessionFactory`。（`mybatis-config.xml`）

>`SqlSessionFactory`：每一个Mybatis应用都是以`SqlSessionFactory`的实例对象为核心的。使用Mybatis必须以`SqlSessionFactory`的实例为核心，再以`SqlSessionFactory`的实例生产`SqlSession`实例对象的。
>` SqlSession`：这个其实表示和数据库之间的一个连接，里面封装了` Connection`对象
>
>```xml
><?xml version="1.0" encoding="UTF-8" ?>
>
><!-- 约束文件 -->
><!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "https://mybatis.org/dtd/mybatis-3-config.dtd">
>
><!-- 注意这个configuration配置包括内部配置: 不要更换配置顺序  -->
><configuration>
>
><!-- 环境的配置，其实就是去配置数据库连接-->
><environments default="development">
><environment id="development">
><transactionManager type="JDBC"/>
><dataSource type="POOLED">
>       <property name="driver" value="com.mysql.jdbc.Driver"/>
>          <property name="url" value="jdbc:mysql://localhost:3306/db7?useSSL=false&amp;characterEncoding=utf8"/>
>           <property name="username" value="root"/>
>           <property name="password" value="123456"/>
>       </dataSource>
>     </environment>
>     </environments>
>     
>     <mappers>
>   		<!--<mapper resource="UserMapper.xml"/>-->
>	<!--<mapper resource="com/cskaoyan/mapper/UserMapper.xml"/>-->
></mappers>
>
></configuration>
>    ```

配置二:  配置一个专门用来**存放`SQL`语句**的配置文件，`UserMapper.xml` 

>在`Mybatis` 中，这样的文件可以有多个。我们使用一个`xml`文件来存放一组`SQL`， 比如对学生的`SQL`，对订单的`SQL`。
>这些文件，都必须在`Mybatis`的主配置文件中，声明进来。
>
>```xml
><?xml version="1.0" encoding="UTF-8" ?>
><!DOCTYPE mapper
>PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
>"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
>   
>   <!-- namespace: 命名空间，整个项目中必须唯一，暂时可以任意取名(后面再进行标准化) -->
>     <mapper namespace="AccountMapper">
>     
><!-- 每个标签都需要一个唯一的id属性: 
>		每一个标签的id不能重复(本Mapper文件中), 用来标识一条SQL  -->
><!-- 在这个Mapper文件中, 怎么唯一表示SQL语句?
>  namespace.id (命名空间.标签的id ) 是这个SQL语句的坐标  -->
>    <!-- <insert> 插入标签 -->
>     <!-- <delete> 删除标签 -->
><!-- <update> 修改标签 -->
>     <!-- <select> 查询标签 -->
>     
>    <!-- parameterType：参数的类型(可以省略,标准语法要指明 ) -->
>    <!-- resultType：返回的结果集的类型(不能省略) -->
>    <select id="selectAccountById"  parameterType="java.lang.Integer" resultType="com.snow.www.bean.Account">
>      select * from account where id = #{id}
></select>
>     <select id="selectAccountList" resultType="com.snow.www.bean.Account">
>      select * from account
>     </select>
>     
>    </mapper>
>     ```

>使用
>
>```Java
>    @Test
>    public void test1() throws IOException {
>        // 1.读取配置文件
>        InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
>
>        // 2.创建一个SqlSessionFactory
>        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
>
>        // 3.通过SqlSessionFactory获得一个SqlSession
>        SqlSession sqlSession = sqlSessionFactory.openSession();
>
>        // 4.执行SQL语句：传入SQL语句的坐标
>        // 这里传入的 statement 是一个坐标，用来标识这个SQL的坐标。 使用 namespace.id 来唯一标识这条SQL
>        // 参数写得1，代表传进去一个参数
>        User user = sqlSession.selectOne("UserMapper.selectUserById", 1);
>        System.out.println(user);
>
>        List<User> userList = sqlSession.selectList("UserMapper.selectUserList");
>        System.out.println(userList);
>
>        // 5.关闭连接
>        sqlSession.close();
>    }
>```



>数据库表结构设计的思考：
>
>写出表名
>
>表里有哪些列 列的类型 含义

`@Data` 注解的练习

`@Builder` 建造者，方便链式编程，方法返回值一直是特定的Builder对象

`resources` 里创建文件夹时要注意，一次创建分级的包时要用 `/` 不能用 `.` 分隔

写一下`MybatisUtil.java`

> 密码不会明文存取，那么如何加密呢？
>
> 注意md5不是用来加密的，因为无法解密，但md5是用来**散列**的，特点是**单向的**。
>
> 彩虹表：将数字先计算成md5值做成的表。这样的做法容易被破解。
>
> 解决办法：
>
> 1. 多散列几次 
> 2. “加盐”，随机生成一些salt

# 动态代理(`Dynamic Proxy`)

在`JAVA` 中，**静态代理**是自己实现一个接口的类。**动态代理**是编写代码时无需手动写实现类，运行时`Mybatis`帮我们实现。动态代理时只用写接口，写SQL。

> 动态代理后续不太好理解，可以拆分步骤先记住模式。

## 动态代理

>一些问题
>
>目前Mybatis使用起来还不够灵活，不够简单
>虽然解决了**硬编码**的问题，但是出现了一些新的问题
>
>- `SQL`语句的坐标硬编码
>- `sqlSession`调用的方法需要我们去指定
>
>而`Mybatis`的动态代理可以帮助我们去**生成接口的代理对象。我们可以自己不实现接口。**
>

使用代理解决。

> 什么是代理？
>
> 你不方便做这个事情。别人方便，它可以帮你做。代理在Java中有两类实现：静态代理，动态代理。
>
> 静态代理：直接`new`一个类出来
>
> 动态代理：等到代码跑起来的时候再生成实现类。

而`Mybatis` 的动态代理可以帮助我们去生成接口的代理对象。我们可以自己不实现接口。

不需要实现接口，那么就需要遵守`Mybatis` 使用动态代理的一些规则。

**为什么接口可以拿回来就能跑**，因为动态代理，`Mybatis` 跑起来的时候给我们生成的实现类。

<span style=color:yellow;background:red>**必须要遵循的规则**</span>  ⚡

1. **接口的全限定名称** 和 `mapper.xml`中的`namespace`的值保持一致。
2. 接口中的方法和 `xml文件` 中的 `<select>` `<insert>` ` <update> ` `<delete> `标签 一一对应，并且**方法名**要和标签的`id值`保持一致，*不允许方法重载出现同名方法*。
3. **方法的返回值类型**和标签中的`resultType`保持一致( 注意:添加/删除/修改 不需要返回值类型 )

4. 参数保持一致(暂时可以不写,后面有**输入输出映射**相关内容)

<span style=color:yellow;background:red>**建议要遵守的规则：希望**</span> ⚡ 

1. 接口名和`xml名` 保持一致。文件的名字 `StudentMapper.xml`  | `StudentMapper.java` 建议保持一致。
2. `StudentMapper.xml` 和`StudentMapper.java` 在编译之后的位置应该要在同一个路径下。

> 复习一下编译打包各个文件的位置。

![image-20230901134929190](.\assets\image-20230901134929190.png)

如何使用动态代理呢？

```JAVA
@Test
public void test1() {
    // 获取SqlSession
    SqlSession sqlSession = MybatisUtil.getSqlSession();

    // 获取代理对象
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

    // 调用对应的接口，执行
    User user = userMapper.queryUserById(1);
    System.out.println(user);
}
```

## 增删改查示例

主要是知道增/删/改/查对应的标签，其中**增/删/改**时是有一个事务的，注意事务提交的3种方式，查时写`resultType` 。

### 添加

`#{属性的名字}`

```XML
<!--在UserMapper中写的内容-->
<insert id="insertUser">
    insert into user(id,name,email) values (#{id}, #{name}, #{email})
</insert>
```

在UserMapper接口

```JAVA
int insertUser(User user);
```

在测试类中的使用

> 注意事项：
>
> 1. `Mybatis`把自动提交给关闭了
>
> 2. `sqlSession`其实是对`connection`的封装

```JAVA
@Test
public void testInsert() {
    User user = new User(4, "zhangsan", "zhangsan@qq.com");

    SqlSession sqlSession = MybatisUtil.getSqlSession();

    UserMapper mapper = sqlSession.getMapper(UserMapper.class);

    int affectedRows = mapper.insertUser(user);
    System.out.println(affectedRows);

    // 获取到的SqlSession，默认不会自动提交。需要手动提交，数据才会进去
    sqlSession.commit();

    //Connection connection = sqlSession.getConnection();
    //connection.commit();
}
```

### 删除

在UserMapper.xml中的内容

```XML
<delete id="deleteUserById">
    delete from user where id = #{id};
</delete>
```

在UserMapper接口

```JAVA
int deleteUserById(Integer id);
```

在测试类中的使用

```JAVA
@Test
public void testDeleteById() {
    SqlSession sqlSession = MybatisUtil.getSqlSession(true);

    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

    int affectedRows = userMapper.deleteUserById(1);
    System.out.println(affectedRows);
}
```

### 修改

在UserMapper.xml中的内容

```XML
<update id="updateUser">
    update user set name = #{name}, email= #{email} where id = #{id};
</update>
```

在UserMapper接口

```JAVA
int updateUser(User user);
```

在测试类中的使用

```JAVA
@Test
public void testDeleteById() {
    SqlSession sqlSession = MybatisUtil.getSqlSession(true);

    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

    int affectedRows = userMapper.deleteUserById(1);
    System.out.println(affectedRows);
}
```

### 查询

在UserMapper.xml中的内容

```XML
<select id="queryUserById" resultType="com.cskaoyan.bean.User">
    select *
    from user
    where id = #{id}
</select>
```

在UserMapper接口

```JAVA
User queryUserById(Integer id);
```

在测试类中的使用

```JAVA
@Test
public void testQueryById() {
    // 获取SqlSession
    SqlSession sqlSession = MybatisUtil.getSqlSession();

    // 获取代理对象
    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

    // 调用对应的接口，执行
    User user = userMapper.queryUserById(1);
    System.out.println(user);
}
```

## 事务

>在使用 `Mybatis`·的时候, **自带事务**，而且事务默认情况下是**不会自动提交**的。

### 解决方案一

执行完 `SQL`语句之后, 使用`sqlSession` 提交事务

```JAVA
// 解决办法一:  执行完SQL语句之后, 使用sqlSession提交事务
sqlSession.commit();
```

### 解决方案二

执行完`SQL`语句之后, 使用`sqlSession` 内部封装的`Connection` 提交事务

```JAVA
// 解决办法二:  执行完SQL语句之后, 使用sqlSession内部封装的Connection 提交事务
Connection conn  = sqlSession.getConnection();
conn.commit();
```

### 解决方案三

(自动提交) 在获得`SqlSession` 的时候, 给`sqlSessionFactory.openSession` 设置为真

```JAVA
// 解决办法三:(自动提交) 在获得SqlSession的时候, 给sqlSessionFactory.openSession设置为真
// 获取到的SqlSession，里面的connection不会自动提交
SqlSession session = sqlSessionFactory.openSession();
// 获取自动提交的SqlSession
SqlSession session = sqlSessionFactory.openSession(true);  
```

# 搭建开发环境(MyBatis)

**是个`Maven`项目**

>第一步: 在`pom.xml`中导包
>
>```xml
><dependencies>
>    <!--mybatis-->
>    <dependency>
>        <groupId>org.mybatis</groupId>
>        <artifactId>mybatis</artifactId>
>        <version>3.5.9</version>
>    </dependency>
>
>    <!-- 数据库驱动包 -->
>    <dependency>
>        <groupId>mysql</groupId>
>        <artifactId>mysql-connector-java</artifactId>
>        <version>5.1.47</version>
>        <scope>runtime</scope>
>    </dependency>
>
>    <!-- 测试包 -->
>    <dependency>
>        <groupId>junit</groupId>
>        <artifactId>junit</artifactId>
>        <version>4.12</version>
>        <scope>test</scope>
>    </dependency>
></dependencies>
>```
>
>第二步: 配置MyBatis的主配置文件(`mybatis-config.xml`)
>
>```xml
><?xml version="1.0" encoding="UTF-8" ?>
><!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
>        "https://mybatis.org/dtd/mybatis-3-config.dtd">
><configuration>
>
>    <!-- 环境的配置，其实就是去配置数据库连接-->
>    <environments default="development">
>        <environment id="development">
>            <transactionManager type="JDBC"/>
>            <dataSource type="POOLED">
>                <property name="driver" value="com.mysql.jdbc.Driver"/>
>                <property name="url"
>                          value="jdbc:mysql://localhost:3306/test_52th?useSSL=false&amp;characterEncoding=utf8"/>
>                <property name="username" value="root"/>
>                <property name="password" value="123456"/>
>            </dataSource>
>        </environment>
>    </environments>
>
>    <!-- 去查找的Mapper文件 -->
>    <mappers>
>        <mapper resource="com/cskaoyan/mapper/UserMapper.xml"/>
>    </mappers>
>
></configuration>
>```
>
>第三步: 创建一个Java接口Mapper接口文件 (注意路径)
>
>第四步: 创建一个与Java接口文件对应的 `Mapper.xml` 配置文件
>
>```Java
>// 在第三/四步骤中: 
>1, 注意路径保持, 最终经过编译和对应接口文件编译到同一包下   --》 可以让开发者
>2, 文件的名字和接口的文件的名字保持一致
>3, xml中的namespace(命名空间)的值要和Java接口的全限定名称保持一致
>```
>
>第五步: 把mapper.xml配置文件引入到主配置文件中(`mybatis-config.xml`)
>
>```xml
><!-- 去查找的Mapper文件 -->
><mappers>
><mapper resource="com/snow/www/mapper/AccountMapper.xml"/>
></mappers>
>
>```
>
>第六步: 加载主配置文件(`mybatis-config.xml`)  
>
>```Java
>// 1. 读取配置文件
>InputStream inputStream = null;
>try {
>	inputStream = Resources.getResourceAsStream("mybatis-config.xml");
>} catch (IOException e) {
>	e.printStackTrace();
>}
>
>// 2. 获取SqlSessionFactory
>SqlSessionFactoryBuilder sqlSessionFactoryBuilder = 
>					new SqlSessionFactoryBuilder();
>sqlSessionFactory = sqlSessionFactoryBuilder.build(inputStream);
>```
>
>第七步: 在对应的Mapper文件和对应的Java接口中, 声明SQL和声明方法
>
>````Java
>// 注意:
>1, 方法名和对应xml的SQL的id保持一致
>2, 参数和返回值设置正确
>3, 注意SQL返回值类型parameterType(结果集的解析是Mybatis自动完成的，不用我们自己解析)
>4, 注意SQL语句书写正确
>````
>
>```Java
>// 添加
>public int insertAccount(Account account);
>// 查找
>public Account selectAccountById(Integer id);
>```
>
>```xml
><insert id="insertAccount" >
>	insert into account set id=#{id}, name=#{name}, money=#{money}
></insert>
><select id="selectAccountById"  parameterType="java.lang.Integer" resultType="com.snow.www.bean.Account">
>	select * from account where id = #{id}
></select>
>```
>
>第八步: 获取SqlSession  和  代理的Mapper对象
>
>```java
>// 1. 获取SqlSession
>sqlSession = sqlSessionFactory.openSession(true);
>
>// 2. 获取接口的代理对象
>studentMapper = sqlSession.getMapper(AccountMapper.class);
>```
>
>第九步: 通过代理对象调用方法执行SQL语句
>
>```Java
>Account account = new Account();
>account.setId(10);
>account.setName("snow");
>account.setMoney(200);
>int rows  = accountMapper.insertAccount(account);
>```

# 配置(MyBatis)

> 主要是介绍Mybatis的核心配置文件。
>
> 都在`mybatis-config.xml`的`configuration`里。
>
> ![image-20230901135148824](.\assets\image-20230901135148824.png)

注意配置放的位置，Mybatis要求放在`resources`里

## `properties`

>`properties`表示可以外部配置的属性，并可以进行动态替换。(作为典型的是JDBC配置)
>
>```properties
>driver=com.mysql.jdbc.Driver
>url=jdbc:mysql://localhost:3306/db47?useSSL=false&characterEncoding=utf8
>username=root
>password=123456
>```
>
>```xml
><configuration>
>        <!-- 引入外部配置文件 -->
>         <properties resource="com/cskaoyan/mapper/jdbc.properties"/>
></configuration>
>```

![image-20230901135234355](.\assets\image-20230901135234355.png)

## `settings`

>`settings`是MyBatis的**行为配置**(类似于idea和settings的关系)
>
>eg: 日志配置
>
>```XML
><configuration>
>        <settings>
>             <!-- 添加日志的配置-->
>             <setting name="logImpl" value="STDOUT_LOGGING"/>
>    </settings>
></configuration>
>```
>
>一个完整的`settings`配置 (暂时没用)
>
>```xml
><settings>
> <setting name="cacheEnabled" value="true"/>
> <setting name="lazyLoadingEnabled" value="true"/>
>      <setting name="aggressiveLazyLoading" value="true"/>
>      <setting name="multipleResultSetsEnabled" value="true"/>
>      <setting name="useColumnLabel" value="true"/>
>      <setting name="useGeneratedKeys" value="false"/>
>      <setting name="autoMappingBehavior" value="PARTIAL"/>
>      <setting name="autoMappingUnknownColumnBehavior" value="WARNING"/>
>      <setting name="defaultExecutorType" value="SIMPLE"/>
>      <setting name="defaultStatementTimeout" value="25"/>
>      <setting name="defaultFetchSize" value="100"/>
>      <setting name="safeRowBoundsEnabled" value="false"/>
>      <setting name="safeResultHandlerEnabled" value="true"/>
>      <setting name="mapUnderscoreToCamelCase" value="false"/>
>      <setting name="localCacheScope" value="SESSION"/>
>      <setting name="jdbcTypeForNull" value="OTHER"/>
>      <setting name="lazyLoadTriggerMethods" value="equals,clone,hashCode,toString"/>
>      <setting name="defaultScriptingLanguage" value="org.apache.ibatis.scripting.xmltags.XMLLanguageDriver"/>
>      <setting name="defaultEnumTypeHandler" value="org.apache.ibatis.type.EnumTypeHandler"/>
>      <setting name="callSettersOnNulls" value="false"/>
>      <setting name="returnInstanceForEmptyRow" value="false"/>
>      <setting name="logPrefix" value="exampleLogPreFix_"/>
>      <setting name="logImpl" value="SLF4J | LOG4J | LOG4J2 | JDK_LOGGING | COMMONS_LOGGING | STDOUT_LOGGING | NO_LOGGING"/>
>      <setting name="proxyFactory" value="CGLIB | JAVASSIST"/>
>      <setting name="vfsImpl" value="org.mybatis.example.YourselfVfsImpl"/>
>      <setting name="useActualParamName" value="true"/>
>      <setting name="configurationFactory" value="org.mybatis.example.ConfigurationFactory"/>
>     </settings>
>     ```

## `typeAliases`

> `typeAlies`类型别名。(也就是我们可以对 类 起别名，简化操作)  (暂时不建议使用)
>
> ```xml
> <configuration>
>     
>     <!-- 类型别名 -->
>     <typeAliases>
>         <!-- alias别名 type全限定名 -->
>         <typeAlias alias="account" type="com.snow.bean.Account"/>
>         <typeAlias alias="user" type="com.snow.bean.User"/>
>     </typeAliases>
> </configuration>
> ```
>
> ```xml
> <select id="selectAccountById"  resultType="account">
>     select * from account where id = #{id}
> </select>
> ```

![image-20230901135340259](.\assets\image-20230901135340259.png)

> 注意: Mybatis对于一些基本类型和包装类型，以及集合类型，<span style='color:red;background:yellow;font-size:文字大小;font-family:字体;'>**有内置的别名。**</span>
>
> ```java
> // 值得注意的是下面是一些为常见的 Java 类型内建的类型别名。它们都是不区分大小写的，而且为了应对原始类型的命名重复，采取了特殊的命名风格。
> // 注意: 除了内置别名,  不要乱起别名
> ```
>
> ```xml
>  <select id="selectNameById"
>             parameterType="java.lang.Integer"
>             resultType="java.lang.String">
>         select name from account where id = #{id}
> </select>
> <select id="selectNameById"
>         parameterType="Integer"
>         resultType="String">
>     select name from account where id = #{id}
> </select>
> <select id="selectNameById"
>         parameterType="integer"
>         resultType="string">
>     select name from account where id = #{id}
> </select>
> <select id="selectNameById"
>             parameterType="_int"
>             resultType="String">
>      select name from account where id = #{id}
> </select>
> ```
>
> | 别名       | 映射的类型 |
> | :--------- | :--------- |
> | _byte      | byte       |
> | _long      | long       |
> | _short     | short      |
> | _int       | int        |
> | _integer   | int        |
> | _double    | double     |
> | _float     | float      |
> | _boolean   | boolean    |
> | string     | String     |
> | byte       | Byte       |
> | long       | Long       |
> | short      | Short      |
> | int        | Integer    |
> | integer    | Integer    |
> | double     | Double     |
> | float      | Float      |
> | boolean    | Boolean    |
> | date       | Date       |
> | decimal    | BigDecimal |
> | bigdecimal | BigDecimal |
> | object     | Object     |
> | map        | Map        |
> | hashmap    | HashMap    |
> | list       | List       |
> | arraylist  | ArrayList  |
> | collection | Collection |
> | iterator   | Iterator   |

>注意: 
>
>1, `typeHandlers`: MyBatis 对我们SQL参数或从结果集中取出一个值时， 都会用**类型处理器**将获取到的值以合适的方式转换成 Java 类型。(而在我们使用的时候是无法感知这个问题的, 属于MyBatis的底层处理).
>
>2, `ObjectFactory`: MyBatis 使用一个对象工厂实例来完成实例化工作。 默认的对象工厂要么通过默认无参构造方法，要么通过有参数的构造方法实例化对象。如果想覆盖对象工厂的默认行为，可以通过创建自己的对象工厂来实现。(不要使用)

## `environments`

>`environments`: 可以配置成适应多种环境.比如开发环境、测试环境和生产环境等可能需要有不同的配置.

```XML
<!-- 环境的配置，其实就是去配置数据库连接-->
<environments default="development">

<!-- 环境的id，是唯一的-->
<environment id="development">

   <!-- 事务管理器
       JDBC:   使用JDBC连接来管理事务
       MANAGED: 把事务的管理交给外部的容器 -->
   <!-- 如果你正在使用 Spring + MyBatis，则没有必要配置事务管理器，
				因为 Spring 模块会使用自带的管理器来覆盖前面的配置。-->
   <transactionManager type="JDBC"/>

   <!--
       POOLED： 使用Mybatis自带的连接池
       UNPOOLED：不使用连接池
       JNDI：使用外部的连接池  -->
   <dataSource type="POOLED">
       <property name="driver" value="${driver}"/>
       <property name="url" value="${url}"/>
       <property name="username" value="${username}"/>
       <property name="password" value="${password}"/>
   </dataSource>
</environment>

<environment id="test">
   <transactionManager type="JDBC"/>
   <dataSource type="POOLED">
       <property name="driver" value="${driver}"/>
       <property name="url" value="${url}"/>
       <property name="username" value="${username}"/>
       <property name="password" value="${password}"/>
   </dataSource>
</environment>

<environment id="prod">
   <transactionManager type="JDBC"/>
   <dataSource type="POOLED">
       <property name="driver" value="${driver}"/>
       <property name="url" value="${url}"/>
       <property name="username" value="${username}"/>
       <property name="password" value="${password}"/>
   </dataSource>
</environment>
</environments>
```

## `mappers`

> 这个是映射器的配置。配置`mapper.xml` 配置文件。

- 配置方式一: 直接以对应mapper文件的相对路径(**相对`target/classess`路径**)
  - 如果xml找不到，怎么办？
    - 1.去`target/classes`里面去找， `build > rebuild project` 或者手动copy
    - 2.最易错的点是路径多级目录写成了`.`应该用`/`


```xml
<configuration>    
	<mappers>
      <mapper resource="com/snow/mapper/AccountMapper.xml"/>
      <mapper resource="com/snow/mapper/User.xml"/>
       
        <!-- mapper中，
        可以写resource。（就是相对target/classes的目录）
        可以写url，里面就是写的绝对路径. file:/// ${绝对路径}
        可以写class，写的是类名的全限定类名，但是要注意类和映射文件要在相同路径下。类名和映射文件名字相同。-->
      <mapper url="file:///D:\ideaProjects\java52-course-materials\mapper\UserMapper.xml"/>
      <mapper class="com.cskaoyan.mapper.UserMapper"/>
 	</mappers>
</configuration>
```

- 配置方式二: 配置某个包下的所有的配置文件
  - 后续建议使用`package`这种方式


```XML
<configuration>    
	<mappers>
       <package name="com.cskaoyan.demo5.mapper"/>
    </mappers>
</configuration>
```

# 输入映射

写了一个方法` int login(User user);` 最后在xml中怎么用这些参数，就叫输入映射。

表中有一个`user_id`但是`bean`里叫`uId`，将这两个关联起来叫输出映射。

`selct * from user where id=10;`

> 输入映射其实就是在说Mybatis是如何传值的。

```JAVA
// 只有一个参数
// 传递多个参数
// ....
```

## 一个参数

建议使用`@Param注解`，注解怎么写，xml中就怎么写。

1. <span style='color:red;background:yellow;'>#{任意值}</span> 来取值:  不建议使用(显得不标准), 建议使用注解写法

 ```java
 // 参数不写注解。 -->  xml中随意写。
 // 虽然一个参数的时候, 可以在#{}内部任意书写参数名, 这种乱写行为不好, 不要这么写
 // 虽然在xml中，可以随意写。但是不建议大家随意写
 User queryUserById(Integer id);
 ```

 ```xml
 <select id="queryUserById" resultType="com.cskaoyan.demo3.bean.User">
     <!-- 在接口中，只写了一个参数，在xml中，可以随便写  #{id}, 但是不建议大家随便写-->
     select * from user where id = #{iddfa}
 </select>
 ```

2. 如果在方法中的一个参数 加了`@Param()注解`，那么 后面就只能通过 `#{注解值}` 来取值

```JAVA
// 参数加了 @Param()注解  -->   注解里面怎么写，xml里面就怎么写。
User queryUserById2(@Param("id") Integer id);
```

```XML
<select id="queryUserById2" resultType="com.cskaoyan.demo3.bean.User">
    select * from user where id = #{id}
</select>
```

## 多个参数

建议使用注解写，注解中怎么写，xml就怎么写。

<span style=color:red;background:yellow>**注意：**</span>

- 直接写多个值, 用参数名简单匹配是不识别的
-  如果参数名简单匹配是不识别, 又不想加注解, 也是有别的解决手段(按位传值: 不建议), 但是建议加注解(最标准的写法)

```JAVA
// 需求： 根据名字 或者 邮箱。 如果任意一个匹配上，都可以
// 可以加上注解  --> @Param 注解。 注解里面写什么。xml中就怎么写。 #{注解值}
List<User> queryUsrByNameOrEmail2(@Param("name") String name, @Param("email") String email);
```

```XML
<select id="queryUsrByNameOrEmail2" resultType="com.cskaoyan.demo3.bean.User">
    select *
    from user
    where name =  #{name} or email = #{email}
</select>
```

## 对象传值

常用。建议使用方式一。

方式一: SQL使用的参数命名要和**对象内部属性**保持一致 (<span style='color:red;background:yellow;'>#{成员变量名}</span> 来取值)

```java
// 使用对象传值。且没有注解。  在xml中，要使用成员变量名即可  #{成员变量名}
// 比如User中有  name。 email。  #{name}  #{email}
int insertUser2(User user);
```

```xml
<insert id="insertUser2">
    insert into user (name, email, password)
    values (#{name}, #{email}, #{password});
</insert>
```

方式二: 对象有注解, 必须通过 <span style='color:red;background:yellow;'>#{注解值 . 成员变量名} </span>来取值

```JAVA
// 使用对象传值，有注解。  --》 使用 #{注解值.成员变量名}
int insertUser3(@Param("user") User user);
```

```XML
<insert id="insertUser3">
    insert into user (name, email, password)
    values (#{user.name}, #{user.email}, #{user.password})
</insert>
```

## 使用`Map`传值

`Map`传值易于使用但是不易维护。代码不跑起来根本不知道`key`和`valu`e分别代表什么。

Map传值: 不建议使用

```java
比如这里有一个Map, 里面有
{"name":"zhangsan","age":18}
```

方式一: SQL使用的参数命名要和Map中存储数据的key保持一致 (<span style='color:red;background:yellow;'>#{key}</span> 来取值)

```java
// 使用map传值， --》 在xml中，使用 #{key}
int insertUser4(Map<String, String> map);
```

```xml
<insert id="insertUser4">
    insert into user(name, email, password)
    value (#{name}, #{email}, #{password});
</insert>
```

方式二: Map对象有注解, 必须通过 <span style='color:red;background:yellow;'>#{注解值 . key} </span>来取值

```JAVA
// 使用map传值， 加上注解之后。  --> 在xml中，应该怎样写？
int insertUser5(@Param("map") Map<String, String> map);
```

```XML
<insert id="insertUser5">
    insert into user(name, email, password)
    value (#{map.name}, #{map.email}, #{map.password});
</insert>
```

## 按位置传值

按位传值: 完全不建议(容易因为程序员的记忆和修改导致bug产生, 除非除了按位传值没办法了)

方式一: arg0、arg1、arg2...

```java
List<User> queryUsrByNameOrEmail(String name, String email);
```

```xml
<!-- 在xml中，我们可以使用 arg0  arg1 arg2 这些来代表第一个参数，第二个参数，第三个参数-->
<!-- 我们也可以使用param1 param2 来代表第一个参数，第二个参数-->
<select id="queryUsrByNameOrEmail" resultType="com.cskaoyan.demo3.bean.User">
    select *
    from user
    where name = #{arg0}
    or email = #{arg1};
</select>
```

方式二: param1、param2、param3...

```java
List<User> queryUsrByNameOrEmail(String name, String email);
```

```xml
<select id="queryUsrByNameOrEmail" resultType="com.cskaoyan.demo3.bean.User">
    select *
    from user
    where name = #{param1}
    or email = #{param2};
</select>
```

在Mybatis的输入映射中，我们经常使用前面三种方式（传入一个参数、传入多个参数、传递对象），后面通过`Map`传值和按照位置来传值 一般不使用，也不建议使用。

推荐大家使用的写法

- 一个参数时，带注解。`User queryUserById2(@Param("id") Integer id);`

- 多个参数，带注解。`List<User> queryUsrByNameOrEmail2(@Param("name") String name, @Param("email") String email);`

- 对象。`int insertUser2(User user);`

## `#`和`$`的区别

两者主要区别在于**预编译**时。

>`#{参数}`使用:  **预编译占位** (尽量使用 `#{} `) `PreparedStatement`
>
>```JAVA
>int insertUser6(@Param("name") String name, @Param("email") String email);
>
>mapper.insertUser6("zhangsan", "aaaaa");
>```
>
>```XML
><insert id="insertUser6">
>    insert into user(name, email)
>    values (#{name}, #{email})
></insert>
>```
>
>![image-20230901135943881](.\assets\image-20230901135943881.png)
>
>`${参数}`使用: **字符串拼接**, `Statement`  (存在**SQL注入问题**)
>
>```java
>int insertUser7(@Param("name") String name, @Param("email") String email);
>
>mapper.insertUser7("zhangsan", "aaaaa");
>```
>
>```xml
><insert id="insertUser7">
>    insert into user(name, email)
>    values ('${name}', '${email}')
></insert>
>```
>
>![image-20230901140052850](.\assets\image-20230901140052850.png)

 ⚡面试可能会问到。 `#{}`和`${}`的区别。

`#{}`是使用的 `prapareStatement`。预编译SQL，首先写SQL，然后使用`?`来进行占位，最后再把参数设置进去，可以**防止SQL注入**。

`${}`是使用的`Statement`。它是使用的字符串拼接。

### 注意

>````java
>//1, 我们以后开发的时候，应该尽量使用 #{} 去接收传递过来的参数值
>//2, 当我们传递给SQL语句 表名或者是列名的时候，就必须得使用 ${} 来取值。
>````
>
>**分表问题: 动态表名** 
>
>```java
>// userMapper.dynamicTableName("user2");
>userMapper.dynamicTableName("user");
>```
>
>```java
>List<User> dynamicTableNameList(String user);
>```
>
>```xml
><select id="dynamicTableNameList" resultType="com.snow.www.bean.User">
>	select * from ${user}
></select>
>
>比如我的用户量非常大，有2个亿。全部放在一个表，不合适。 可以存10个表。 如果身份证尾号是0 user_0  ； 尾号是1  user_1
>现在用户想找 421302199207080611.
>我拿到这个id之后，需要怎么做？  尾号是1，所以去user_1 
>我们的这个表名是一个动态的。 
>```
>
>**分列问题: 动态列名**
>
>`order by`不参与预编译所以要使用`${}`
>
>想要根据一个字段进行排序但是排序字段不固定
>
>```java
>//  List<User> list = userMapper.dynamicColumnName("id");
>List<User> list = userMapper.dynamicColumnName("age");
>```
>
>```java
>List<User> dynamicColumnName(String age);
>```
>
>```xml
><select id="dynamicColumnName" resultType="com.snow.www.bean.User">
>	select * from user order by ${column}
></select>
>```

# 输出映射

> 输出映射是指Mybatis是如何把SQL语句执行结果映射为 Java对象的。
>
> ```java
> // 一个参数
> // 多个参数
> // 单个对象
> // 多个对象
> // resultMap: 比较重要(很常用)
> ```

## 一条结果

一行一列的结果。返回一个参数。比如根据`id`找名字。

>一个参数: 必须要有`resultType` (写简单参数的 `全限定类名` 或者是 `别名` )
>
>```java
>String name = userMapper.selectNameById(5);
>```
>
>```java
>String queryNameById1(Integer id);
>String queryNameById2(Integer id);
>String queryNameById3(Integer id);
>```
>
>```xml
><!-- 我们必须要写一个resultType。标识查询的结果的类型-->
><!-- 对于java.lang.String 我们既可以写 全限定类名，也可以写string。（别名不区分大小写）-->
><!-- 方式一： 全限定类名-->
><select id="queryNameById1" resultType="java.lang.String">
>        select name
>        from user
>        where id = #{id};
></select>
>
><!-- 方式二： 内置的别名-->
><select id="queryNameById2" resultType="string">
>        select name
>        from user
>        where id = #{id};
></select>
>
><!-- 方式三： 别名不区分大小写-->
><select id="queryNameById3" resultType="String">
>        select name
>        from user
>        where id = #{id};
></select>
>```

## 多条结果

多行一列。比如我们返回的是一个班级的名称列表。

> <span style="color:red">指: 多个结果构成的 `数组` / `List` / `Set`</span>
>
> ```java
> // 当我们返回多个简单结果的时候，在方法中定义的是数组就会返回数组，定义的是集合就会返回集合。
> // xml中的标签配置不需要改变。并且, resultType的值是单个元素的类型。
> ```
>
> ```java
> List<String> nameList = mapper.queryAllNameList();
> String[] strings = mapper.queryAllNameArray();
> Set<String> set = mapper.queryAllNameSet();
> ```
>
> ```java
> List<String> queryAllNameList();
> String[] queryAllNameArray();
> Set<String> queryAllNameSet();
> ```
>
> ````xml
> <select id="queryAllNameList" resultType="string">
>      select name from user;
> </select>
> ````

## 单个对象

一行多列。

>单个对象: 
>
>```java
>// 1. Mybatis在去映射的时候，会把`成员变量名` 和`查询结果的列名`去一一映射，假如原始表中的列名和成员变量名不一致的话，我们可以通过取别名的方式来解决(也可以通过resultMap来解决)
>// 2. 在声明JavaBean的成员变量的时候，尽量的使用包装类型
>```
>
>```java
>@Test
>public void test3(){
>	User user = mapper.queryUserById(1);
>	System.out.println(user);
>}
>```
>
>```java
>User queryUserById(@Param("id") Integer id);
>```
>
>````xml
><!-- resultType写的是bean的全限定类名。或者是别名-->
><!-- 需要注意。返回的列，需要和bean的成员变量名一致，如果不一致，可以使用取别名的方式解决-->
><select id="queryUserById" resultType="com.cskaoyan.demo4.bean.User">
>        select *
>        from user
>        where id = #{id};
></select>
>````

## 多个对象

多行多列。

>多个对象: `数组` / `List` / `Set`
>
>```java
>//1,  resultType的值是单个元素的类型。
>```
>
>```java
>@Test
>public void testQueryAllUserList(){
>        List<User> users = mapper.queryAllUserList();
>        System.out.println(users);
>}
>```
>
>````java
>// 多行多列，
>// 比如查询一个班级里面的所有学生，在接口中可以使用 List 数组 Set来接。
>// 在mapper.xml的标签中，resultType写单个元素的类型即可
>List<User> queryAllUserList();
>````
>
>```xml
><!-- resultType中是单个元素的类型-->
><select id="queryAllUserList" resultType="com.cskaoyan.demo4.bean.User">
>        select * from user;
>    </select>
>```

##  ⚡`resultMap`

<span style=background:yellow;color:red>强制使用</span>。配置映射关系，使字段与DO解耦。

>`resultMap`: 是用来做参数映射的。把数据库中的字段与实体类中的字段用来一一对应的。

如果数据库里的字段，和 `bean` 中的对象，名字不一致，有两种解决方法。

- 使用别名

- 使用`resultMap`。更灵活

>```java
>@Data
>@AllArgsConstructor
>@NoArgsConstructor
>public class StudentDO {
>	private Integer studentId;
>	private String studentName;
>	private Integer studentAge;
>	private String address;
>}
>
>drop table if exists mybatis_student;
>CREATE TABLE `mybatis_student`  (
>	`id` int(11) PRIMARY KEY AUTO_INCREMENT,
>	`name` varchar(255)  ,
>	`age` int(11)  ,
>	`address` varchar(255)
>);
>
>insert into mybatis_student(id,name,age,address) values (1, 'zhangsan', 18, 'hubei'),(2, 'lisi', 19, 'hunan'),(3, 'wangwu', 21, 'hubei'),(4, 'zhaoliu', 22, 'beijing');
>```
>
>```java
>List<StudentDO> selectStudentUseAlias();
>```
>
>```java
>List<StudentDO> selectStudentUseResultMap();
>```
>
>```xml
><!-- 方式一: 别名 --> 
><!-- 使用别名的方式来解决， 数据库中的字段和bean中的名称不一致问题。
>名称不一致会有什么问题： 会查得出来属性，但是数据封装不进去。
>-->
><select id="queryStudentUseAlias1" resultType="com.cskaoyan.demo4.bean.StudentDO">
>	select * from mybatis_student;
></select>
>
><!-- 取别名可以解决这个问题。-->
><select id="queryStudentUseAlias2" resultType="com.cskaoyan.demo4.bean.StudentDO">
>	select id as studentId, name as studentName, age as studentAge, address from mybatis_student;
></select>
>```
>
>⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡
>
>```xml
><!-- 方式二: resultMap --> 
><!--resultMap的id属性 和 对应的映射的SQL标签的 resultMap对应-->
><!--resultMap的type属性 指代最终的对象类型-->
><resultMap id="studentResultMap1" type="com.cskaoyan.demo7.bean.StudentDO">
>	<!-- id主键映射， result： 普通列映射-->
>	<!-- 在result标签中。  column是数据库的列名， property是成员变量名（bean里面的变量名）-->
>	<id column="id" property="studentId"/>
>	<result column="name" property="studentName"/>
>	<result column="age" property="studentAge"/>
>	<result column="address" property="address"/>
></resultMap>
>
><!-- 标签需要写resultMap 后面是id值-->
><select id="selectStudentUseResultMap" resultMap="studentResultMap1">
>	select id, name, age, address from mybatis_student;	
></select>
>```

# 插件

## Lombok

lombok的作用：简化书写

>Lombok: 可以帮助代码在编译的时候生成对应的方法。
>
>```java
>// getter
>// setter
>// toString
>// hashCode
>// equals
>```

>第一步: 安装插件
>
>![image-20230901140731963](.\assets\image-20230901140731963.png)
>
>第二步:  导包
>
>```xml
><dependency>
><groupId>org.projectlombok</groupId>
><artifactId>lombok</artifactId>
><version>1.18.12</version>
></dependency>
>```
>
>注意设置开启：` Annotation Pro`
>
>第三步: 使用
>
>```java
>//@Getter@Setter@ToString@EqualsAndHashCode
>//@NoArgsConstructor
>//@AllArgsConstructor
>
>// @Data  -->  getter、setter、toString、equals、hashCode
>
>@Data
>@AllArgsConstructor
>@NoArgsConstructor
>public class StudentDO {
>	private Integer studentId;
>	private String studentName;
>	private Integer studentAge;
>	private String address;
>}
>```

>Lombok: 好处
>
>```java
>// 1. 优势
>在去修改（增删改）成员变量的时候，不用我们自己再去生成getter、setter等，效率比较高
>
>// 2. 缺点
> Lombok在项目中，只要有一个人用了，那么其他的组员也都要使用
>```

使用`@Builder` 好处在于当实体类对象中增减字段时，不必改变构造器的结构

```JAVA
Order order = Order.builer().id(1).name("name").build();
```

## MybatisCodeHelperPro

> MybatisCodeHelperPro: 这个是Mybatis的一个插件(提高开发Mybatis应用程序的效率)。
>
> ```java
> // 帮助我们在mapper和mapper.xml 之前来回跳转
> // 可以帮助我们生成mapper.xml文件中的标签
> // 可以做一定的代码提示
> // ...
> ```

>步骤一: 插件安装
>
>![image-20230901140834514](.\assets\image-20230901140834514.png)

# 动态`SQL`

什么是动态`SQL`：根据传入条件动态地改变`SQL`，利用标签完成。

> 动态`SQL`是`Mybatis`给我们提供的又一个强大的功能。可以帮助我们根据传入的条件，**动态的去改变`SQL`语句。**

比如现在要去jd搜索一个手机。下方有大量的条件，比如机身内存，CPU型号，运行内存。等等......

假设有一张手机表，里面存放的全部是手机。 

```SQL
create table phone(
	id int primary key auto_increment,
    name varchar(255),
    brand varchar(255),
    memory int,
    disk int
);

insert into phone values (1, "小米10", "小米", "8", "128"), (2, "OPPO k9x", "OPPO", "8", "128"), (3, "OPPO K10x", "OPPO", "8", "256"), (4, "Redmi Note11", "Redmi", "8", "128"), (5, "荣耀90", "荣耀", "12", "128"), (6, "Redmi Note12", "Redmi", "12", "256");
```

比如筛选框可以随意组合，现在传入了一个品牌：小米。

- 筛选荣耀的手机。 
  - Mapper接口：
  
    ```JAVA
    List<Phone> quryByBrand(String brand);
    ```
  - Mapper.xml里面 要写一条SQL
- 筛选小米手机， 机身存储 512.
  - ```JAVA
    List<Phone> quryByBrand(String brand, Integer disk);
    ```
- 小米手机，存储12.
  - ```java
    List<Phone> quryByBrand(String brand, Integer memory);
    ```

如果为每一种情况，都写一个接口，写一条`SQL`。`SQL`数量会急剧增加。所以需要使用动态`SQL`，有些情况下增加这种条件，有些条件下增加另外一种条件。

假设有10个筛选条件。 如果我们要用`Mybatis`来完成，要写多少方法，多少`SQL`。

- 单独选一个条件，我们要写多少方法。要写$C_{10}^{1} = 10$个  。

  ```JAVA
   List<Phone> quryByBrand(String brand);
  ```

- 单独选两个条件，我们要写多少方法。要写

  $C_{10}^{2}$ =  $10\times9\div2$  =  $45$个  。
  
  ```JAVA
   List<Phone> quryByBrand(String brand, String memory);
  ```

动态SQL，就是根据你传入的条件，比如你传入了品牌，我就给它拼接上去。 没传，就不拼。

## `where`

> `where`这个标签可以帮助我们在最终执行的SQL中自动生成`where`关键字
>
> ```java
> //1, 可以自动拼接where关键字 (一般和if配合使用)
> //2, 去除直接跟着的and或者是or关键字  
> //3, 如果where标签中没有条件满足的时候（如果SQL片段需要拼接），那么where标签不会给我们拼接where关键字
> 
> // 注意一般if(工作用到更多一些),choose when otherwise(也会用, 用到相对if少一些),尽量写在where标签内部, 因为, 如果根据条件做处理的时候, 没有任何一个条件满足, 如果又使用的where标签(而不是写死的where关键字), 那么最终执行的sql上不会生成where(避免出错)
> ```
>
> ```xml
> <select id="queryAllPhone" resultType="com.cskaoyan.demo5.bean.Phone">
>  select * from phone
>  <where>
>      and id = 1
>  </where>
>  ;
> </select>
> ```
>
> ```xml
> <!-- if标签，只有条件满足，才会拼接进SQL-->
> <select id="queryPhoneByBrandOrDisk" resultType="com.cskaoyan.demo5.bean.Phone">
>  select * from phone
>  <where>
>      <!-- 在if的test中，可以直接使用 输入映射中的参数。比如 brand disk-->
>      <!-- 输入映射可以写什么，在test中就可以写什么。比如有注解  @Param("id") 则可以直接写id。 不用外面的#{}-->
>      <if test="brand != null">
>          brand = #{brand}
>      </if>
> 
>      <!-- 在if中，在test中可以写 ognl。 gt lt gte lte-->
>      <if test="disk != null">
>          and disk = #{disk}
>      </if>
>  </where>
> </select>
> 
> <!-- 如果传入的brand是null，disk是null，则where这个关键字不会被拼接上去-->
> select * from phone;
> 
> ```
>
> > OGNL 是 `Object-Graph Navigation Language`（**对象导航图语言**）的缩写，它是一种功能强大的表达式语言，通过它简单一致的表达式语法，可以存取对象的任意属性，调用对象的方法，遍历整个对象的结构图，实现字段类型转化等功能。它使用相同的表达式去存取对象的属性。这样可以更好的取得数据。
> >
> > ### Ognl 语言介绍
> >
> > OGNL 表达式官方指南：https://commons.apache.org/proper/commons-ognl/language-guide.html

## `if`

> `if` 标签可以帮助我们去做判断是否满足某个条件。如果符合条件，则拼接标签里面的内容；否则，不拼接。
>
> 在 `if`的条件中，输入映射中可以写什么，`if` 就可以写什么。
>
> ```java
> 		  转义字符     OGNL表达式
> // >      &gt;           gt
> // <      &lt;           lt
> // >=     &gt;=          gte
> // <=     &lt;=          lte
> // !=
> // ==      
> // and
> // or
> 
> ```
>
> ```java
> // 在<if test="">,引号中，我们可以不使用转义字符，可以使用OGNL表达式的写法
> // 在if中，可以使用 > >= ， 但是 < <=这种符号不能使用。所以不推荐大家使用这个
> ```

>代码示例
>
>```xml
><select id="queryPhoneByMemory" resultType="com.cskaoyan.demo5.bean.Phone">
>    select * from phone
>    <where>
>            <!-- memory 小于 8 。就拼接这个if-->
>           <if test="memory &lt; 8">
>                 memory = 8
>           </if>
>           <!-- memory 大于 8，就拼接这个if-->
>             <if test="memory gt 8">
>               and memory = 12
>           </if>
>         </where>
>       ;
></select>
>```

## `choose when otherwise`

> `choose when otherwise`就相当于Java中的` if .... else....`
>
> 和where一起使用
>
> ```java
> //  如果传入的id大于5，就按传入的id查询； 否则判断传入的memory 是否等于8，等于8，就按照memory查询；
> //  否则根据disk来进行匹配
> List<Phone> queryByChooseWhenOtherwise(@Param("id") Integer id, @Param("memory") Integer memory, @Param("disk") Integer disk);
> ```
>
> 
>
> ```xml
> <select id="queryByChooseWhenOtherwise" resultType="com.cskaoyan.demo5.bean.Phone">
>  <!--        //  如果传入的id大于5，就按传入的id查询； 否则判断传入的memory 是否等于8，等于8，就按照memory查询；-->
>  <!--    //  否则根据disk来进行匹配-->
>  select *
>  from phone
>  <where>
>      <choose>
>          <when test="id &gt; 5">
>              id = #{id}
>          </when>
>          <when test="memory == 8">
>              memory = #{memory}
>          </when>
>          <otherwise>
>              disk =#{disk}
>          </otherwise>
>      </choose>
>  </where>
>  ;
> </select>
> 
> ```

## `sql-include`

将一些公用的`SQL`，抽取出来。在其他需要使用的地方，可以直接引入这个公用`SQL`

> 这是两个标签，配合起来一起使用的。
>
> ```java
> // sql标签可以帮助我们把公共的sql提取出来
> // include可以帮助我们引入公共的sql片段。
> ```
>
> 提取
>
> ```xml
> <!-- 相当于定义了一个变量，叫做 base_sql  内容是标签内的内容-->
> <sql id="base_sql">
>     select id, name, brand, memory, disk
>     from phone
> </sql>
> ```
>
> 引入
>
> ```xml
> <select id="queryPhoneById" resultType="com.cskaoyan.demo5.bean.Phone">
>     <!-- 可以使用include标签，将定义好的引入进来-->
>     <include refid="base_sql"/>
>     where id = #{id}
> </select>
> ```
>
> ```xml
> <select id="queryAllPhone" resultType="com.cskaoyan.demo5.bean.Phone">
>     <include refid="base_sql"/>
>     <where>
>         and id = 1
>     </where>;
> </select>
> ```
>
> ```java
> // 优点：可以提取公共的sql片段，减少编码量。 防止数据库增加字段后，全部SQL需要修改
> // 缺点：用了sql-include 之后，SQL语句的可读性变差了
> ```

<span style='color:red;background:yellow;'>**sql-include 标签我们一般用来提取 列名。**</span>

**推荐只抽取列名，防止可读性降低。**

> 提取
>
> ```xml
> <sql id="base_column">
>      id, name, brand, memory, disk
> </sql>
> ```
>
> 引入
>
> ```xml
> <select id="queryPhoneById" resultType="com.cskaoyan.demo5.bean.Phone">
>      <!-- 可以使用include标签，将定义好的引入进来-->    
>      select 
>      <include refid="base_column" />
>      from phone 
>        where id = #{id}
>  </select>
> ```
> 
>好处分析
> 
>- 避免写`select *`。因为不要在`SQL`语句中写`select * `
> - 不破坏SQL语句的可读性
> -  防止数据库增加字段后，全部SQL需要修改

## `trim`

>`trim` 标签可以帮助我们**动态的去增删指定的字符**。
>
>```xml
><!--
>prefix: 增加指定的前缀
>suffix: 增加指定的后缀
>prefixOverrides: 删除指定的前缀
>suffixOverrides: 删除指定的后缀
>-->
>```
>
>```java
>@Test
>public void testUpdatePhone(){
>Phone phone = new Phone();
>phone.setId(22);
>phone.setMemory(16);
>
>int i = mapper.updatePhone(phone);
>System.out.println(i);
>}
>```
>
>````java
>int updatePhone(Phone phone);
>````
>
>````xml
><update id="updateByPhone">
>update phone set
><!-- 会把包裹着的块，prefix/suffix prefixOverrides/suffixOverrides -->
><trim suffixOverrides="," >
><if test="brand != null">
>  brand = #{brand},
></if>
><if test="memory != null">
>  memory = #{memory},
></if>
><if test="disk != null">
>  disk = #{disk}
></if>
></trim>
>where id = #{id}
></update>
>````
>

## `set`

> `<set> ` 就相当于 ` <trim prefix="SET" suffixOverrides=","> ` 
>
> - 去除 `set `标签中的最后一个` ","`
> -  拼接 `set` 关键字
> 
> ```java
>@Test
> public void testTrim() {
>  Phone phone = new Phone();
>  phone.setId(5);
>     phone.setBrand("honor");
>     phone.setMemory(12);
>     phone.setDisk(256);
>    
>     int i = mapper.updateByPhone(phone);
>  System.out.println(i);
>    }
> ```
> 
> ```java
>int updateByPhone(Phone phone);
> ```
> 
> ```xml
><update id="updateByPhone">
>  update phone
> 
>     <set>
>      <if test="brand != null">
>             brand = #{brand},
>         </if>
>         <if test="memory != null">
>             memory = #{memory},
>         </if>
>         <if test="disk != null">
>             disk = #{disk}
>         </if>
>     </set>
>     where id = #{id}
>    </update>
> ```

## `foreach`

> `foreach `可以帮助我们去循环处理SQL语句。

## 批量插入

> `foreach` 在插入的使用
>
> - 当个方法中传入的参数没有注解的时候，假如传入的`List`，那么就可以使用 `list`，假如传入的是`数组`，那么就可以使用`array`
> - 当方法中传入的参数有**注解**的时候，`collection`里面必须写注解的值
> 
> **List类型参数**
>
> 没有注解,  `foreach` 的循环从插入的时候,  要求`foreach` 标签的 `collection` 参数, 是 `collection`   (如果`List` 对象建议写 `list` )。
>
> ```java
>List<Order> orders = new ArrayList<>();
> orders.add(new Order(null, "aa", 100));
> orders.add(new Order(null, "bb", 100));
> 
> int rows = orderSQLMapper.insertListOrder(orders);
> System.out.println(rows);
> ```
> 
> ```java
>int insertListOrder( List<Order> orders);
> ```
> 
> ```XML
><insert id="insertPhoneList">
>  <!-- insert into phone(id, name, brand, memory, disk) values (?, ?, ?, ?, ?) , (?, ?, ?, ?, ?) -->
> 
>     insert into phone(id, name, brand, memory, disk) values
>  <!-- foreach遍历传入的集合；
>         separator：循环的时候，以什么字符分割开
>         open：在循环开始的时候，添加指定的字符
>         close：在循环结束的时候，添加指定的字符
>         item：循环中的元素名 相当于 for(int i=0;i<100;i++) {}  中的 i
>         index: 元素的下标. index=“index1”代表使用一个叫做index1的变量将它存起来，在循环内部，就可以使用这个index1
>         -->
>     <foreach collection="list" item="phone" separator=","
>              open="" close="" index="index1">
>         (#{phone.id}, #{phone.name}, #{phone.brand},
>         #{phone.memory}, #{index1})
>     </foreach>
>    </insert>
> ```
> 
> **数组类型参数**
>
> 没有注解,  foreach的循环从插入的时候,  要求foreach标签的 collection参数, 必须是array
>
> ```java
>@Test
> public void testInsertArray() {
>  Phone[] phones = new Phone[2];
>  phones[0] = new Phone(null, "huawei mate50", "huawei", 8, 128);
>     phones[1] = new Phone(null, "huawei mate40", "huawei", 8, 256);
>    
>     int i = mapper.insertPhoneArray(phones);
>  System.out.println(i);
>    }
> ```
> 
> ```java
>int insertPhoneArray(Phone[] phones);
> ```
> 
> ```xml
><insert id="insertPhoneArray">
>  insert into phone(id, name, brand, memory, disk) values
>  <foreach collection="array" item="phone" separator=","
>              open="" close="" index="index1">
>         (#{phone.id}, #{phone.name}, #{phone.brand},
>         #{phone.memory}, #{index1})
>     </foreach>
>    </insert>
> ```
> 
> **添加注解**
>
> 如果在使用foreach的循环从插入的时候,  要求foreach标签的 collection参数, 必须是`注解名`
>
> ```java
>@Test
> public void testInsertArray() {
>  Phone[] phones = new Phone[2];
> 
>     phones[0] = new Phone(null, "huawei mate50", "huawei", 8, 128);
>  phones[1] = new Phone(null, "huawei mate40", "huawei", 8, 256);
>    
>     int i = mapper.insertPhoneArray(phones);
>  System.out.println(i);
>    }
>    
> @Test
> public void testInsertArrayParam() {
>  List<Phone> phones = new ArrayList<>();
> 
>     phones.add(new Phone(null, "huawei mate50 ListParam", "huawei", 8, 128));
>  phones.add(new Phone(null, "huawei mate40 ListParam", "huawei", 8, 256));
>    
>     int i = mapper.insertPhoneListParam(phones);
>  System.out.println(i);
>    }
> ```
> 
> ```java
>int insertPhoneArrayParam(@Param("phones") Phone[] phones);
> int insertPhoneListParam(@Param("phones") List<Phone> phones);
> ```
> 
> ```xml
><insert id="insertPhoneArrayParam">
>  insert into phone (id,name,brand,memory,disk) values
>  <foreach collection="phones" open=""
>              close="" separator="," item="phone">
>         (#{phone.id}, #{phone.name}, #{phone.brand},
>         #{phone.memory}, #{phone.disk})
>     </foreach>
>    </insert>
>    
> <insert id="insertPhoneListParam">
>  insert into phone (id,name,brand,memory,disk) values
>  <foreach collection="phones" open=""
>              close="" separator="," item="phone">
>         (#{phone.id}, #{phone.name}, #{phone.brand},
>         #{phone.memory}, #{phone.disk})
>     </foreach>
>    </insert>
> ```

## 使用`in`查询

>`foreach` 在查询时候的使用: 
>
>注意: `foreach collection`在不使用注解情况下, 默认集合类使用`collection `(`List` 建议使用 `List` ),  数组使用 `array`
>
>如果参数使用了注解,`foreach`  标签的`collection` 属性使用注解名
>
>```java
>@Test
>public void testQueryByIdList(){
>    List<Phone> phones = mapper.queryPhoneByIdList(Arrays.asList(1,2,3));
>    System.out.println(phones);
>}
>```
>
>```java
>List<Phone> queryPhoneByIdList(@Param("list") List<Integer> list);
>```
>
>```xml
><select id="queryPhoneByIdList" resultType="com.cskaoyan.demo5.bean.Phone">
>    select *
>    from phone
>    <where>
>           id in
>             <foreach collection="list" separator="," open="(" close=")" item="id">
>               #{id}
>           </foreach>
>         </where>
>     </select>
>     ```

## `selectKey`

> 这个标签可以帮助我们在执行目标`SQL` 语句之前或者是之后执行一条额外的`SQL` 语句。**有自动生成`id` 的场景下，我们需要知道自动生成的`id`是多少。**
>
> **`AFTER操作`**
>
> ```java
> @Test
> public void testInsertPhone(){
>     Phone phone = new Phone();
>     phone.setName("iphone13");
>     phone.setBrand("Apple");
>     int i = mapper.insertPhone(phone);
>
>     System.out.println(phone);
> }
> ```
>
> ```java
>  int insertPhone(@Param("phone") Phone phone);
> ```
>    
>    ```xml
>    <insert id="insertPhone">
>        <!--order: 表示在目标SQL执行之前或者是之后执行 AFTER | BEFORE
>              keyProperty： 表示执行的结果映射到哪个参数中
>              resultType: SQL语句返回的类型 -->
>        <selectKey order="AFTER" keyProperty="phone.id" resultType="Integer">
>            select LAST_INSERT_ID();
>        </selectKey>
>    
>        insert into phone(id, name, brand, memory, disk) values(#{phone.id}, #{phone.name},
>        #{phone.brand}, #{phone.memory}, #{phone.disk})
>      </insert>
>    ```
>    

## `useGeneratedKeys`

>`useGeneratedKeys` :  获取`insert`/`update` 操作数据的主键
>
>```java
>开启配置：useGeneratedKeys="true" 
>映射到对应的参数中：keyProperty="order.id"
>```
>
>```java
>@Test
>public void testInsertPhone2(){
>    	Phone phone = new Phone();
>    	phone.setName("iphone14");
>    	phone.setBrand("Apple");
>
>    	// 手机的id，会被存到原对象的id中
>    	int affectedRows = mapper.insertPhone2(phone);
>    	System.out.println(phone);
>}
>```
>
>```java
>int insertPhone2(@Param("phone") Phone phone);
>    ```
>    
>     ```xml
>     <insert id="insertPhone2" useGeneratedKeys="true" keyProperty="phone.id">
>         insert into phone(id, name, brand, memory, disk)
>         values (#{phone.id}, #{phone.name},
>         #{phone.brand}, #{phone.memory}, #{phone.disk})
>     </insert>
>     ```



# 多表查询⚡ 

有多张表需要关联起来就用到多表查询。

## 一对一结构

>结构示例
>
>![image-20230901154607934](.\assets\image-20230901154607934.png)
>
>```sql
>drop table if exists user;
>create table user(
>	id int primary key auto_increment,
>	name varchar(255),
>	email varchar(255),
>	password varchar(255),
>    user_detail_id int
>);
>
>drop table if exists user_detail;
>create table user_detail(
>	id int primary key auto_increment,
>	address varchar(255),
>	pic varchar(255)
>);
>
>insert into user values (1, "猪八戒","zhubajie@qq.com", "zhubajie",1);
>insert into user values (2, "孙悟空","sunwukon@qq.com", "sunwukong",2);
>insert into user values (3, "白骨精","baigujin@qq.com" ,"baigujing",3);
>insert into user values (4, "唐僧",  "tangsen@qq.com" , "tangseng",4);
>insert into user values (5, "沙僧", "shaseng@qq.com", "shaseng",5);
>
>select * from user;
>
>insert into user_detail values(1, "高老庄", "猪八戒.jpg");
>insert into user_detail values(2, "花果山", "孙悟空.jpg");
>insert into user_detail values(3, "白虎岭", "白骨精.jpg");
>insert into user_detail values(4, "东土大唐", "唐僧.jpg");
>
>select * from user_detail;
>```
>
>```java
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class User {
>    	private Integer id;
>    	private String name;
>    	private String email;
>    	private String password;
>
>    	private UserDetail userDetail;
>}
>
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class UserDetail {
>    	private Integer id;
>    	private Integer userId;
>    	private String address;
>    	private String pic;
>}
>```

### 方式一: 分次查询

在Mybatis里如何唯一确定一条SQL?

namespace + 标签的id

>测试
>
>```java
>@Test
>public void testQueryOne2One() {
>        List<User> users = mapper.queryAllUser();
>    	for (User user : users) {
>     	   System.out.println(user);
>    	}
>}
>```
>
>`TableMapper` 接口
>
>```java
>List<User> queryAllUser();
>```
>
>`UserMapper.xml` 文件
>
>```xml
>    <mapper namespace="com.cskaoyan.demo9.mapper.UserMapper">
>       <resultMap id="baseUserMap" type="com.cskaoyan.demo9.bean.User">
>             <id column="id" property="id"/>
>             <result column="name" property="name"/>
>             <result column="email" property="email"/>
>             <result column="password" property="password"/>
>     
>         <!-- association: 关联单个bean的时候，使用
>        property: 成员变量的名字
>             javaType: 成员变量的类型
>             select: 第二条SQL执行时，SQL的坐标.
>             如果两条SQL在一个mapper.xml中，可以不写namespace。
>             如果不在一个mapper.xml中，需要写namespace
>             column: 第二条SQL，传递的参数
>        -->
>   
>             <association property="userDetail" javaType="com.cskaoyan.demo9.bean.UserDetail"
>                          column="id"
>                          select="com.cskaoyan.demo9.mapper.UserDetailMapper.queryUserDetailByUserId"/>
>         </resultMap>
>     
>    
>    <select id="queryAllUser" resultMap="baseUserMap">
>             select * from user;
>         </select>
>    </mapper>
>```
>
>`UserDetailMapper.xml` 文件
>
>```xml
><mapper namespace="com.cskaoyan.demo9.mapper.UserDetailMapper">
>    <select id="queryUserDetailByUserId" resultType="com.cskaoyan.demo9.bean.UserDetail">
>        select *
>             from user_detail
>             where user_id = #{userId};
>         </select>
>     </mapper>
>     ```

### 方式二: 连接查询

>测试
>
>```java
>@Test
>public void testQueryOne2One2(){
>    List<User> users = mapper.queryAllUser2();
>    for (User user : users) {
>        System.out.println(user);
>    }
>}
>```
>
>`UserMapper` 接口
>
>```java
>List<User> queryAllUser2();
>```
>
>UserMapper.xml
>
>```xml
><resultMap id="baseUserMap2" type="com.cskaoyan.demo9.bean.User">
>    <id column="id" property="id"/>
>    <result column="name" property="name"/>
>    <result column="email" property="email"/>
>    <result column="password" property="password"/>
>
>    <association property="userDetail"
>                 javaType="com.cskaoyan.demo9.bean.UserDetail">
>        <id column="ud_id" property="id"/>
>        <result column="pic" property="pic"/>
>        <result column="user_id" property="userId"/>
>        <result column="address" property="address"/>
>    </association>
></resultMap>
>
><select id="queryAllUser2" resultMap="baseUserMap2">
>    select u.id       as id
>    , u.name     as name
>    , u.email    as email
>    , u.password as password
>    , ud.id      as ud_id
>    , ud.pic     as pic
>    , ud.user_id as user_id
>    , ud.address as address
>    from user u
>    left join user_detail ud on u.id =
>    ud.user_id;
></select>
>
>```

## 一对多结构

学生和班级

省份和城市

>结构示例
>
>![image-20230901155057087](.\assets\image-20230901155057087.png)
>
>```sql
>drop table if exists student;
>drop table if exists class;
>
>create table class(
>	id int primary key auto_increment,
>    name varchar(200)
>);
>
>create table student(
>	id int primary key auto_increment,
>    name varchar(200),
>    age int,
>    class_id int
>);
>
>insert into class values(1,"一班");
>insert into class values(2,"二班");
>insert into class values(3,"三班");
>
>insert into student values(1, "张飞", 30, 1);
>insert into student values(2, "关羽", 40, 1);
>insert into student values(3, "李云龙", 35, 2);
>insert into student values(4, "楚云飞", 33, 2);
>insert into student values(5, "王有胜", 30, 2);
>insert into student values(6, "林冲", 30, 3);
>insert into student values(7, "孙二娘", 35, 4);
>```
>
>```java
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class StudentsClass {
>private Integer id;
>private String className;
>
>private List<Student> studentList;
>}
>```

### 方式一: 分次查询

property就是最终封装到哪里去

>测试
>
>```java
>@Test
>public void test1() {
>    List<Clazz> clazzes = mapper.queryAllClazz();
>    for (Clazz clazz : clazzes) {
>        System.out.println(clazz);
>    }
>}
>```
>
>`ClazzMapper` 接口
>
>```xml
>List<Clazz> queryAllClazz();
>```
>
>`ClazzMapper.xml` 
>
>```xml
><resultMap id="baseClazzMap" type="com.cskaoyan.demo9.bean.Clazz">
>    <id column="id" property="id"/>
>    <result column="name" property="name"/>
>    <!--collection: 关联的是集合，用collection
>           property：成员变量的名字
>           ofType：集合中单个元素的类型
>           select: 关联的SQL语句坐标
>           column: 列名 -->
>
>    <collection property="studentList"
>                ofType="com.cskaoyan.demo9.bean.Student"
>                select="com.cskaoyan.demo9.mapper.StudentMapper.queryStudentListByClassId"
>                column="id">
>    </collection>
></resultMap>
>
><select id="queryAllClazz" resultMap="baseClazzMap">
>    select *
>    from class;
></select>
>```
>
>`StudentMapper.xml` 文件
>
>```xml
><resultMap id="baseResultMap" type="com.cskaoyan.demo9.bean.Student">
>    <id column="id" property="id"/>
>    <result column="name" property="name"/>
>    <result column="age" property="age"/>
>    <result column="class_id" property="classId"/>
></resultMap>
>
><select id="queryStudentListByClassId" resultMap="baseResultMap">
>    select *
>    from student
>    where class_id = #{classId};
></select>
>```

### 方式二: 连接查询

>测试
>
>```java
>@Test
>public void test2(){
>    List<Clazz> clazzes = mapper.queryAllClazz2();
>    for (Clazz clazz : clazzes) {
>        System.out.println(clazz);
>    }
>}
>```
>
>ClazzMapper接口
>
>```java
>List<Clazz> queryAllClazz2();
>```
>
>TableMapper.xml
>
>```xml
><resultMap id="baseResultMap2" type="com.cskaoyan.demo9.bean.Clazz">
>    <id column="id" property="id"/>
>    <result column="name" property="name"/>
>    <collection property="studentList" ofType="com.cskaoyan.demo9.bean.Student">
>        <id column="s_id" property="id"/>
>        <result column="s_name" property="name"/>
>        <result column="s_age" property="age"/>
>        <result column="s_class_id" property="classId"/>
>    </collection>
></resultMap>
>
><select id="queryAllClazz2" resultMap="baseResultMap2">
>    select c.id,
>    c.name,
>    s.id       as s_id,
>    s.name     as s_name,
>    s.age      as s_age,
>    s.class_id as s_class_id
>    from class c
>    left join student s on c.id = s.class_id;
></select>
>```

## 多对多结构

>结构示例
>
>![image-20230901160125923](.\assets\image-20230901160125923.png)
>
>```sql
>drop table if exists tec_stu;
>drop table if exists tec_course;
>drop table if exists tec_sele_course;
>
>create table tec_stu(
>	id int primary key auto_increment,
>    name varchar(200)
>);
>
>create table tec_course(
>	id int primary key auto_increment,
>    name varchar(200)
>);
>
>-- 选课表
>create table tec_sele_course(
>	id int primary key auto_increment,
>    student_id int,
>    course_id int
>);
>
>insert into tec_stu values (1, "李云龙");
>insert into tec_stu values (2, "楚云飞");
>insert into tec_stu values (3, "赵刚");
>insert into tec_stu values (4, "王有胜");
>insert into tec_stu values (5, "孙悟空");
>
>insert into tec_course values (1, "Java");
>insert into tec_course values (2, "C++");
>insert into tec_course values (3, "Python");
>
>insert into tec_sele_course(student_id, course_id) values (1,1);
>insert into tec_sele_course(student_id, course_id) values (1,2);
>insert into tec_sele_course(student_id, course_id) values (2,2);
>insert into tec_sele_course(student_id, course_id) values (2,3);
>insert into tec_sele_course(student_id, course_id) values (3,1);
>insert into tec_sele_course(student_id, course_id) values (4,2);
>insert into tec_sele_course(student_id, course_id) values (5,3);
>
>select * from tec_stu;
>select * from tec_cource;
>select * from tec_sele_course;
>```
>
>````java
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class User {
>    private Integer id;
>    private String userName;
>    private List<Goods> goodsList;
>}
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class Goods {
>    private Integer id;
>    private String goodsName;
>}
>@Data
>@NoArgsConstructor
>@AllArgsConstructor
>public class Order {
>    private Integer id;
>    private Integer goodsId;
>    private Integer userId;
>}
>````

### 方式一: 分次查询

> 根据用户的名字查询出用户信息以及用户对应购买的商品信息。
>
> 测试
>
> ```java
> @Test
> public void testQueryAllCourses1() {
>     List<TecCourse> tecCourses = mapper.queryAllCourses2();
> 
>     for (TecCourse tecCours : tecCourses) {
>         System.out.println(tecCours);
>     }
> }
> ```
>
> `Mapper` 接口
>
> ```java
> List<TecCourse> queryAllCourses1();
> ```
>
> `Mapper.xml`
>
> ```xml
> <select id="queryByCourseId" resultType="com.cskaoyan.demo11.bean.TecStudent">
>     select s.id,s.name from tec_sele_course sc left join tec_stu s on sc.student_id = s.id
>     where sc.course_id = #{courseId}
> </select>
> 
> 
> <resultMap id="baseCourseResultMap1" type="com.cskaoyan.demo11.bean.TecCourse">
>     <id column="id" property="id"/>
>     <result column="name" property="name"/>
>     <collection property="students" ofType="com.cskaoyan.demo11.bean.TecStudent"
>                 column="id"
>                 select="com.cskaoyan.demo11.mapper.TecStudentMapper.queryByCourseId">
>     </collection>
> </resultMap>
> 
> <select id="queryAllCourses1" resultMap="baseCourseResultMap1">
>     select id, name
>     from tec_course;
> </select>
> ```

### 方式二: 连接查询

>测试
>
>```java
>@Test
>public void testQueryAllCourses2() {
>    List<TecCourse> tecCourses = mapper.queryAllCourses2();
>
>    for (TecCourse tecCours : tecCourses) {
>        System.out.println(tecCours);
>    }
>}
>```
>
>`Mapper` 接口
>
>```java
>List<TecCourse> queryAllCourses2();
>```
>
>`Mapper.xml`
>
>```xml
><resultMap id="baseCourseResultMap2" type="com.cskaoyan.demo11.bean.TecCourse">
>    <id column="c_id" property="id"/>
>    <result column="c_name" property="name"/>
>    <collection property="students" ofType="com.cskaoyan.demo11.bean.TecStudent">
>        <id column="s_id" property="id"/>
>        <result column="s_name" property="name"/>
>    </collection>
></resultMap>
>
><select id="queryAllCourses2" resultMap="baseCourseResultMap2">
>    select c.id as c_id, c.name as c_name, s.id as s_id, s.name as s_name
>    from tec_course c
>    left join tec_sele_course sc on c.id = sc.course_id
>    left join tec_stu s on sc.student_id = s.id;
></select>
>```

# 懒加载

> 懒加载和MyBatis缓存作为了解, 知道是怎么回事, 面试的时候可以谈一谈思想即可, 因为工作中并不会使用(基本不会使用)

懒加载又叫做延迟加载。

是指在`Mybatis` 进行**分次查询**的时候，假如第二次查询的内容没有被使用到的话，那么就不去执行第二次查询的SQL语句，等到用到第二次查询的内容的时候再去执行第二条SQL语句。

注意:

1. 当局部开关配置的时候，以局部开关的配置为准

2. 当局部开关没有配置的时候，以总开关的配置为准

3. 当总开关也没有配置的时候，以默认配置为准（默认配置是关闭懒加载）

>总开关配置: `Mybatis`的主配置文件里面的`settings`里面
>
>```xml
><settings>
>    <!-- 懒加载 true: 表示开启  false:默认值，表示关闭 --> 
>    <setting name="lazyLoadingEnabled" value="true"/>
></settings>
>```
>
>案例
>
>```java
>// 测试
>List<User> list = mapper.selectUserGoodsListByName("天明");
>```
>
>```java
>// Mapper接口
>List<User> selectUserGoodsListByName(String name);
>```
>
>`Mapper.xml`
>
>```xml
><select id="selectUserGoodsListByName" resultMap="baseMap5">
>    select id,  user_name  from user where user_name = #{name}
></select>
><resultMap id="baseMap5" type="bean.User">
>    <id column="id" property="id"/>
>    <result column="user_name" property="userName"/>
>    <collection property="goodsList"
>                ofType="bean.Goods"
>                select="selectGoodsListByUserId"
>                column="id"/>
></resultMap>
>
><select id="selectGoodsListByUserId" resultType="bean.Goods">
>    select g.id , g.goods_name as goodsName
>    from `order` o left join goods g on g.id = o.goods_id
>    where o.user_id = #{id}
></select>  
>```

>局部开关
>
>```xml
> <!-- fetchType: eager关闭/lazy开启 -->
><resultMap id="baseMap5" type="bean.User">
>    <id column="id" property="id"/>
>    <result column="user_name" property="userName"/>
>    <collection property="goodsList"
>                ofType="bean.Goods"
>                select="selectGoodsListByUserId"
>                fetchType="lazy"
>                column="id"/>
></resultMap>
>```
>
>注意：idea的Debug模式下**不能复现懒加载**，因为debug模式会显示出对象中的所有的信息，相当于已经用到了第二次SQL语句查询的内容，所以第二次SQL语句就会立马执行

# 缓存

> 缓存是指在`Mybatis`中，单独开辟一块内存空间（`map`），来存储查询的信息。后续假如再次调用到了同样的查询，那么就直接查询缓存。
>
> **`MyBatis`默认开启了缓存**
>
> ```java
> MyBatis是怎么存储缓存的: 在MyBatis中缓存是以Map(集合类容器)接口存储的
> // map：
> //  	key：SQL语句和查询的条件(注意: SQL语句是依赖于坐标的)				
> //							 (MapperID+Sql+所有的入参)
> // 		value：查询的结果
> ```

### 一级缓存

> <span style='color:red;background:yellow;'>**一级缓存是一个以SqlSession管理的Mapper级别的缓存**</span>。缓存的内容存储在SQLSession中管理。
>
> ![image-20230901160159914](.\assets\image-20230901160159914.png)

> 配置：一级缓存默认是开启的，并且没有提供开关给用户关闭(不可以关闭)。
>
> 一级缓存什么时候失效呢？
> //SqlSession关闭的时候
> //SqlSession调用增删改的时候,会清空当前SqlSession缓存
> //SqlSession调用commit方法

#### 测试

> 同一个`SqlSession` 获取的同一个`mapper`: 走缓存
>
> ```java
> @Test
> public void testQueryByOneMapper1() {
>     SqlSession sqlSession = MybatisUtil.getSqlSession(true);
>     StudentMapper mapper = sqlSession.getMapper(StudentMapper.class);
> 
>     Student student = mapper.queryStudentByPrimaryKey(1);
> 
>     // 根据同一个Mapper。会走缓存
>     Student student1 = mapper.queryStudentByPrimaryKey(1);
>     Student student2 = mapper.queryStudentByPrimaryKey(1);
> 
>     System.out.println(student);
>     // 参数不同，不会走缓存
>     Student student5 = mapper.queryStudentByPrimaryKey(2);
>     System.out.println(student5);
> }
> ```
>
> 同一个`SqlSession`获取不同的`mapper`: 走缓存
>
> ```java
> @Test
> public void testQueryByTwoMapper1() {
>     SqlSession sqlSession = MybatisUtil.getSqlSession(true);
> 
>     // 同一个SqlSession获取的不同Mapper。会走缓存
>     StudentMapper mapper = sqlSession.getMapper(StudentMapper.class);
>     Student student = mapper.queryStudentByPrimaryKey(1);
> 
>     StudentMapper mapper2 = sqlSession.getMapper(StudentMapper.class);
>     Student student1 = mapper2.queryStudentByPrimaryKey(1);
> }
> ```
>
> 不同`SqlSession`获取不同的`mapper`: 不走缓存
>
> ```java
> @Test
> public void testQueryByTwoSqlSession() {
>     SqlSession sqlSession = MybatisUtil.getSqlSession(true);
>     SqlSession sqlSession2 = MybatisUtil.getSqlSession(true);
> 
>     // 不同SqlSession获取的Mapper。不会走缓存
>     StudentMapper mapper = sqlSession.getMapper(StudentMapper.class);
>     StudentMapper mapper2= sqlSession2.getMapper(StudentMapper.class);
> 
> 
>     Student student = mapper.queryStudentByPrimaryKey(1);
>     Student student2 = mapper2.queryStudentByPrimaryKey(1);
> }
> ```

### 二级缓存

> <span style='color:red;background:yellow;'>**二级缓存是一个NameSpace级别（mapper.xml）的缓存**</span>，每一个NameSpace都有自己的单独的缓存空间。(要通过两级配置开启)

> 配置1：总开关
>
> ```xml
> <!-- 二级缓存开关配置 -->
> <setting name="cacheEnabled" value="true"/>
> ```
>
> 配置2: 局部开关
>
> ![image-20230901160218918](.\assets\image-20230901160218918.png)

><span style="color:red">需要对二级缓存的所有相关对象实现序列化接口</span>
>
>开启自动生成序列化id
>
>![image-20230901160232783](.\assets\image-20230901160232783.png)
>
>实现序列化接口，生成序列化id
>
>![image-20230901160246151](.\assets\image-20230901160246151.png)

>```java
>// 1, 二级缓存是 namespace级别/Mapper级别 的缓存
>// 2, 多个SqlSession可以共用二级缓存(同一个Mapper)
>// 3, 在关闭sqlsession后(close);  才会把该sqlsession一级缓存中的数据添加到对应namespace的二级缓存中。
>// 4, 当Mybatis默认先查询二级缓存，二级缓存中无对应数据，再去查询一级缓存，一级缓存中也没有，最后去数据库查找。
>```
>
>![image-20230901160301915](.\assets\image-20230901160301915.png)

#### 测试

>测试
>
>```java
>@Test
>public void testQueryTwoLevelCache() {
>    SqlSession sqlSession = MybatisUtil.getSqlSession(true);
>    SqlSession sqlSession2 = MybatisUtil.getSqlSession(true);
>
>    // 不同SqlSession获取的Mapper。不会走缓存
>    StudentMapper mapper = sqlSession.getMapper(StudentMapper.class);
>    StudentMapper mapper2 = sqlSession2.getMapper(StudentMapper.class);
>
>    Student student = mapper.queryStudentByPrimaryKey(1);
>    Student student2 = mapper2.queryStudentByPrimaryKey(1);
>
>    // 二级缓存是在namespace级别下的缓存
>    // 只有close后，才会把数据添加进二级缓存
>    sqlSession.close();
>
>    Student student1 = mapper2.queryStudentByPrimaryKey(1);
>    System.out.println(student1);
>
>}
>```

> 二级缓存有没有用呢？
>
> - 其实有一定的作用，但是也有一定的缺陷
>
>   - 确实能够提高Mybatis的性能
>   - 不能完美的解决脏数据的问题
>   - 二级缓存空间对于用户来说是完全透明的，我们用户不能够直接的去操作它，也不能够让用户指定去查询数据库还是查询缓存，所以其实使用起来不太方便
>
>   在以后的工作中，有一些需要使用缓存的场景，那么这个时候我们不会考虑使用Mybatis给我们提供的缓存，取而代之的是使用我们的NoSQL数据库（Redis）。

# MyBatis-Plus

##  简介

MyBatis-Plus（简称 MP）是一个 MyBatis的增强工具，在MyBatis 的基础上**只做增强不做改变**，为简化开发、提高效率而生（[官方网址](http://mp.baomidou.com))，它具有如下特性：

+ 增强在单表访问。不考虑逆向工程时，使用Mybatis需要定义mapper接口，mapper.xml文件中写sql语句,配置数据库
+ 效率的提高指的是开发效率不是运行效率

> 愿景
>
> 我们的愿景是成为 MyBatis 最好的搭档，就像魂斗罗中的 1P、2P，基友搭配，效率翻倍。

![](.\assets\relationship-with-mybatis.png)

- **无侵入**：只做增强不做改变，引入它不会对现有工程产生影响，如丝般顺滑
- **损耗小**：启动即会自动注入基本 CURD，性能基本无损耗，直接面向对象操作
- **强大的** **CRUD** **操作**：内置通用 Mapper、通用 Service，仅仅通过少量配置即可实现单表大部分，CRUD 操作，更有强大的条件构造器，满足各类使用需求
- **支持** **Lambda** **形式调用**：使用Lambda表达式指定列名，避免字符串写列名写错。通过 Lambda 表达式，方便的编写各类查询条件，无需再担心字段写错
- **支持主键自动生成**：支持多达 4 种主键策略（内含分布式唯一 ID 生成器 - Sequence），可自由配置，完美解决主键问题
- **内置分页插件**：基于 MyBatis 物理分页，开发者无需关心具体操作，配置好插件之后，写分页等同于普通 List 查询
- **分页插件支持多种数据库**：支持 MySQL、MariaDB、Oracle、DB2、H2、HSQL、SQLite、Postgre、SQLServer 等多种数据库

## 环境准备

要是用MyBatis-Plus我们得准备好数据库中的表数据，所需的依赖，以及部分相关代码。

#### 数据准备

以一张简单的单表User表为例，其结构如下

| id   | name   | age  | email              |
| ---- | ------ | ---- | ------------------ |
| 1    | Jone   | 18   | test1@baomidou.com |
| 2    | Jack   | 20   | test2@baomidou.com |
| 3    | Tom    | 28   | test3@baomidou.com |
| 4    | Sandy  | 21   | test4@baomidou.com |
| 5    | Billie | 24   | test5@baomidou.com |

对应建表语句如下

```mysql
DROP TABLE IF EXISTS user;

CREATE TABLE user
(
    id BIGINT(20)  auto_increment NOT NULL COMMENT '主键ID',
    name VARCHAR(30) NULL DEFAULT NULL COMMENT '姓名',
    age INT(11) NULL DEFAULT NULL COMMENT '年龄',
    email VARCHAR(50) NULL DEFAULT NULL COMMENT '邮箱',
    PRIMARY KEY (id)
);
```

对应数据如下

```mysql
DELETE FROM user;

INSERT INTO user (id, name, age, email) VALUES
(1, 'Jone', 18, 'test1@baomidou.com'),
(2, 'Jack', 20, 'test2@baomidou.com'),
(3, 'Tom', 28, 'test3@baomidou.com'),
(4, 'Sandy', 21, 'test4@baomidou.com'),
(5, 'Billie', 24, 'test5@baomidou.com');
```

### 工程依赖准备

创建一个SpringBoot工程(可以使用Spring Initializer)，引入如下依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>3.5.3.1</version>
    </dependency>
     <dependency>
         <groupId>mysql</groupId>
         <artifactId>mysql-connector-java</artifactId>
         <scope>runtime</scope>
     </dependency>
      <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
</dependencies>
```

在`application.yml`中添加如下配置

```yml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/test?characterEncoding=utf8&serverTimezone=GMT%2B8&useSSL=false
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: 1234
# 在日志中显示实际执行的sql语句
logging:
  level:
    com.cskaoyan.mybatis.plus.mapper: debug
```

### 代码准备

步骤一： 在启动类上加`@MapperScan`注解

```java
@SpringBootApplication
@MapperScan("com.cskaoyan.mybatisplus.mapper")
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

因为访问的是单表，所以要有一个**单表映射的实体类**。

步骤二： 定义user表对应的映射实体类User

```java
@Data //lombok注解
public class User {
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

步骤三： 定义Mapper继承`BaseMapper`

`BaseMapper`是MyBatis-Plus提供的模板mapper，其中包含了基本的CRUD方法，**泛型为操作的实体类型**。

通过泛型就可以将Mapper和实体类关联起来，通过注解(`@TableName`)将Mapper和数据库表关联起来，从而能够实现实体类与数据库表的映射关系。

```java
public interface UserMapper extends BaseMapper<User> {}
```

> 补充一个IDEA的BUG，报错内容是`Erro:Kotlin...`时，点击build选项下的rebuild即可。

## 基本CRUD

定义一个用于测试的测试类，其中包含基本CRUD的代码

SpringBoot测试类不可以随便放，要保证测试类所在包目录下有启动类

测试类注解`@SpringBootTest`，为了和Spring容器整合，要加注解`@RunWith(SpringRunner.class)`。测试方法上加`@Test`

```java
@SpringBootTest
@RunWith(SpringRunner.class)
public class TestBasic {
    @Autowired
    private UserMapper userMapper;
}
```

###  新增数据

```java
@Test
public void testInsert() {
    User user = new User();
    user.setName("zs");
    user.setEmail("abcd@xxx.com");
    user.setAge(100);

    int effectiveRow = userMapper.insert(user);
    // 输出受影响的行数
    System.out.println("受影响行数：" + effectiveRow);
    // 输出自动生成的id
    System.out.println(user.getId());
}
```

MyBatis-Plus 会为我们生成不依赖于自增主键的主键值。

> 之前使用Mybatis时要获得自增主键，需要在sql语句标签里添加`useGeneratedKey = "true"`，`keyProperty = "id"`。

注意： MyBatis-Plus在实现插入数据时，会默认基于**雪花算法**(SnowFlake)的策略生成id

### 删除数据

##### 根据id删除

> 如果id过长，记得后面加`L`表示是长整型。

```java
@Test
public void testDeleteById() {
    int effectiveRow = userMapper.deleteById(1630492821798178818L);
    System.out.println("受影响行数: " + effectiveRow);
}
```

##### 根据id批量删除

```java
@Test
public void testDeleteBatchByIds() {
    List<Long> ids = Arrays.asList(1L, 2L);
    int effectiveRow = userMapper.deleteBatchIds(ids);
    System.out.println("受影响行数: " + effectiveRow);
}
```

##### 根据Map等值条件删除

注意Map中放的是where条件中包含的多个条件字段，以及条件字段对应的值(比较的关系是相等关系)

 🏷️多个条件之间的关系是并且关系。

```java
@Test
public void testDeleteByMap(){
    //根据map集合中所设置的条件删除记录
    //DELETE FROM user WHERE name = ? AND age = ?
    Map<String, Object> param = new HashMap<>();
    // age = 21
    param.put("age", 21);
    // name=sandy
    param.put("name", "Sandy");
    int effectiveRow = userMapper.deleteByMap(map);
    System.out.println("受影响行数：" + effectiveRow);
}
```

### 修改数据

修改只会使用非`null`字段更新数据库。`updateById()`。

```java
@Test
public void testUpdateById(){
    User user = new User();
    user.setId(6L);
    user.setName("changfeng");
    user.setAge(20);
    //UPDATE user SET name=?, age=? WHERE id=?
    int effectiveRow = userMapper.updateById(user);
    System.out.println("受影响行数：" + effectiveRow);
}
```

### 查询数据

##### 根据id查询

```java
@Test
public void testSelectById(){
    User user = userMapper.selectById(4L);
    System.out.println(user);
}
```

##### 根据id批量查询

```java
@Test
public void testSelectBatchByIds(){
    //SELECT id,name,age,email FROM user WHERE id IN ( ? , ? )
    List<Long> ids = Arrays.asList(3L, 4L， 5L);
    List<User> result = userMapper.selectBatchIds(ids);
    result.forEach(System.out::println);
}
```

##### 根据Map等值条件查询

```java
@Test
public void testSelectByMap(){
    //SELECT id,name,age,email FROM user WHERE name = ? AND age = ?
    Map<String, Object> map = new HashMap<>();
    map.put("age", 24);
    map.put("name", "Billie");
    List<User> result = userMapper.selectByMap(map);
    result.forEach(System.out::println);
}
```

##### 查询全表数据

```java
@Test
public void testSelectAll(){
    // 这里null代表没有where条件
    //SELECT id,name,age,email FROM user
    List<User> result = userMapper.selectList(null);
    result.forEach(System.out::println);
}
```

`selectList()`的参数应该是表示复杂参数的条件构造器，为`null`时表示没有`where`条件。

> Mybatis的逆向工程使用前，要生成对应的实体类和mapper，重点在于生成代码。
>
> 而MybatisPlus定义一个UserMapper可以调用增删改查所有的方法

## 常用注解

#### `@TableName`注解

刚才我们已经，学习了MyBatis-Plus基本的CRUD，但是其实还有一个遗留问题。我们知道，在数据库中是同时存在多张表的，我们怎么控制使用Mapper，操作某一张表的呢？这其实就和`@TableName`注解有关系了。

可以使用`@TableName`注解，定义数据库表和实体类的关系。

(**默认情况下**，会根据实体类的类名访问数据库中的表，所以如果当表名和类名相同时，不加`@TableName`注解，也不会报错)

```java
@Data
@TableName(value = "user")
public class User {
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

#### `@TableId`注解

> 在我们单表中，可以同时定义多个字段，在我们的映射实体类中，也可以同时定义多个属性。在单表中，我们通常都会定义主键字段，**那么主键字段是如何和实体类中的某个属性对应起来的呢？**这就和`@TableId`注解有关系了。

可以使用`@TableId`注解，定义数据库中的主键字段和实体类中的主键属性之间的映射关系。

(**默认情况下**，MyBatis-Plus会根据主键名来映射，映射到同名实体类属性)

作用：

+ 指定主键映射
+ 主键生成策略

```java
@Data
@TableName(value = "user")
public class User implements Serializable {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

其中，`value`属性指的是数据库主键字段的名称，`type`表示主键的类型（值是枚举类型`IdType`）。在MyBatis-Plus中主键类型有以下几种

> `AUTO`：MybatisPlus不生成主键，**数据库生成**，MybatisPlus可以拿到生成后的主键。
>
> `ASSIGN_ID`：即雪花算法，生成一个长整型值。（雪花算法与当前时间和机房数据库有关）

| 值            | 描述                                                         |
| :------------ | :----------------------------------------------------------- |
| `AUTO`        | 数据库 ID 自增                                               |
| NONE          | 无状态，该类型为未设置主键类型（注解里等于跟随全局，全局里约等于 INPUT） |
| `INPUT`       | insert 前自行 set 主键值                                     |
| `ASSIGN_ID`   | 分配 ID(主键类型为 Number(Long 和 Integer)或 String)(since 3.3.0)，使用接口`IdentifierGenerator`的方法`nextId()`(默认实现类为`DefaultIdentifierGenerator`雪花算法) |
| `ASSIGN_UUID` | 分配 UUID，主键类型为 String(since 3.3.0)，使用接口`IdentifierGenerator`的方法`nextUUID()`(默认 default 方法) |

#### `@TableField`注解

两个作用：

+ 定义映射关系
+ 让某个属性不参与映射

类似于`@TableId`注解，`@TableField`注解在实体类中用来定义实体类中的普通属性和数据库字段的映射

(**默认情况下**，MyBatis-Plus会根据字段名来映射，映射到同名实体类属性)

```java
@Data
@TableName(value = "user")
public class User implements Serializable {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;
    @TableField(value = "name")
    private String name;
    @TableField(value = "age")
    private Integer age;
    @TableField(value = "email")
    private String email;
}
```

`@TableField(exist = false)`表示该属性不映射数据库中的字段。默认情况下，`exist`属性是`true`。

`@TableField`注解需要注意：

- 若实体类中的属性使用的是驼峰命名风格，而表中的字段使用的是下划线命名风格（例如实体类属性userName，表中字段user_name），此时MyBatis-Plus会自动将驼峰命名风格转化为下划线命名风格
- 若实体类中的属性和表中的字段不满足上述情况，例如实体类属性name，表中字段username，此时需要在实体类属性上使用`@TableField("username")`设置属性所对应的字段名

#### `@TableLogic`

为了实现**逻辑删除**，我们可以在表示删除状态的实体类属性上添加`@TableLogic`注解，从而实现逻辑删除的功能。当然，在使用之前，我们要先给数据库user表增加is_deleted属性并给该字段赋默认初值0表示未删除，以及在实体类中添加isDeleted属性。

![image-20230301005215922](E:\0.王道训练营\3.我的Daily笔记\FS复习笔记\assets\image-20230301005215922.png)

```java
@Data
@TableName(value = "user")
public class User implements Serializable {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;
    @TableField(value = "name")
    private String name;
    @TableField(value = "age")
    private Integer age;
    @TableField(value = "email")
    private String email;
    @TableLogic
    private Integer isDeleted;
}

```

+ 删除是更新`is_deleted`字段
+ 查询会过滤`is_deleted`字段

这样一来，**当我们执行删除语句的时候，实际执行的就是一条set语句**，比如当我们根据id删除一条记录时，实际执行的是

```sql
update user set is_deleted=1 where id=? and is_deleted=0
```

**当我们执行查询语句的时候，会自动附带逻辑删除状态的判断**，查询结果中不会包含已经被逻辑删除的记录

```sql
select id,name,age,email,is_deleted from user where is_deleted=0
```

## ⭐条件构造器`Wrapper`

> 类似于逆向工程的`Example`对象

在我们对数据库做增删改查操作的时候需要条件即`where`条件，这些条件就是用条件构造器`Wrapper`来构造和表示的。

![](.\assets\wrapper.png)

`Wrapper` ： 条件构造抽象类，最顶端父类

`AbstractWrapper` ： 用于查询条件的封装，生成 sql 的 where 条件

`QueryWrapper` ： 查询条件的封装

`UpdateWrapper` ： Update 条件封装(除了包含更新条件，还可以指定更新的字段和对应的新值)

`AbstractLambdaWrapper` ： Lambda 语法使用的Wrapper，统一处理解析 lambda 获取 column

`LambdaQueryWrapper` ：用于Lambda语法使用的查询Wrapper

`LambdaUpdateWrapper` ： 用于Lambda语法使用的更新Wrapper(除了包含更新条件，还可以指定更新的字段和对应的新值)

#### `QueryWrapper`

`QueryWrapper`中提供了多个方法，每个方法都代表了一种条件。可以在`Wrapper`对象上调用多个方法，从而组装多个具体的查询条件，这些条件可以`AND`关系，也可以是`OR`关系。默认构造条件是与关系。

 🍃调用多个方法，这些方法表示的条件默认是`AND`关系

```java
	@Test
    public void testAnd(){
        //查询用户名包含a，年龄在20到30之间，邮箱不为null的用户信息，并且按照年龄的降序排序
        //SELECT id,name,age,email,is_deleted FROM user WHERE is_deleted=0 AND (name LIKE ? AND age BETWEEN ? AND ? AND email IS NOT NULL) ORDER BY age DESC
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name", "a")
                .between("age", 20, 30)
                .isNotNull("email")
                .orderByDesc("age");
        List<User> result = userMapper.selectList(queryWrapper);
        result.forEach(System.out::println);
    }
```

 🍃如果要想表示条件之间的`OR`关系，必须调用`or()`方法来表示`OR`运算符

```java
    @Test
    public void testOr(){
        //查询用户名包含a 或者 年龄大于20，并且按照年龄的升序排序
        // SELECT id,name,age,email,is_deleted FROM user WHERE is_deleted=0 AND (name LIKE ? OR age > ?) ORDER BY age DESC
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name", "a")
                .or()
                .gt("age", 20)
                .orderByDesc("age");
        List<User> result = userMapper.selectList(queryWrapper);
        result.forEach(System.out::println);
    }
```

🍃 我们还可以在`AND`条件中嵌套`OR`条件

```java
    @Test
    public void testInnerOr() {
        //查询用户名包含a 且 (年龄大于20 或者 id > 3)的用户
        // SELECT id,name,age,email,is_deleted FROM user WHERE is_deleted=0 AND (name LIKE ? AND (age > ? OR id > ?))
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name", "a")
                .and(wrapper -> wrapper
                        .gt("age", 20)
                        .or()
                        .gt("id", 3)
                );
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

 🍃同理，我们也可以实现`OR`条件中嵌套`AND`条件

```java
    @Test
    public void testInnerAnd() {
        //查询用户id > 3 或者 (name以j打头 且 年龄在18-30之间)的用户
        // SELECT id,name,age,email,is_deleted FROM user WHERE name LIKE ? OR (name LIKE ? AND id > ?)
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name", "a")
                .or(wrapper -> wrapper
                        .likeRight("name", "J")
                        .gt("id", 3)
                );
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

 🍃除了针对`where`中的条件，我们还可以指定`select`中查询的字段，`select(String... column)`参数是可变个数的。

```java
    @Test
    public void testSelect() {
        //查询用户id > 3 且 年龄在18-30之间的用户的名字
        // SELECT name FROM user WHERE is_deleted=0 AND (id > ? AND age BETWEEN ? AND ?)
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.gt("id", 3)
                .between("age", 18, 30)
                .select("name");
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

 🍃当然`QueryWrapper`还可以使用在删除语句中，表示删除条件。

```java
    @Test
    public void testWrapperWithDelete() {
        // 删除age < 20的用户
        // Delete from user WHERE age < ?
        // update user set is_deleted = 1 where is_deleted = 0 and (age < ?)
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.lt("age", 20);
        int deleteRow = userMapper.delete(queryWrapper);
        System.out.println("影响行数： " + deleteRow);
    }
```

#### `UpdateWrapper`

我们可以使用`UpdateWrapper`来实现数据的修改，在使用`UpdateWrapper`修改的时候，我们可以使用User对象的**非空属性值**，表示通过`set` 语句修改的目标字段及其新值 `set` 字段1 = 新值1，...

 🍃使用方式一：更新的值是一个对象传参，条件是`UpdateWrapper`传参

```java
    @Test
    public void updateWrapperWithUserObj() {

        // 将Jone的年龄改为29，邮箱改为 Jone@cskaoyan.com
        // UPDATE user SET age=?, email=? WHERE name = ?
        UpdateWrapper<User> userUpdateWrapper = new UpdateWrapper<>();
        userUpdateWrapper.eq("name", "Jone");
        // 创建User对象，该对象的非空属性，对应着set语句修改的数据库字段，以及对应的字段值
        User user = new User();
        // 设置email属性为待修改的新值
        user.setEmail("Jone@cskaoyan.com");
        // 设置age属性为待修改的新值
        user.setAge(29);
        // update
        userMapper.update(user, userUpdateWrapper);
    }
```

 🍃使用方式二：条件和更新的值都在`UpdateWrapper`中。在使用`UpdateWrapper`的时候，我们也可以直接使用`UpdateWrapper`的`set`方法，设置`set`语句修改的目标字段及其新值。update传参时，对象传值为`null`。

```java
    @Test
    public void updateWrapperWithoutObj() {
        // 将Jone的年龄改为29，邮箱改为 Jone@cskaoyan.com
        // UPDATE user SET age=?, email=? WHERE name = ?
        UpdateWrapper<User> userUpdateWrapper = new UpdateWrapper<>();
        userUpdateWrapper.eq("name", "Jone");
        // 设置email属性为待修改的新值
        userUpdateWrapper.set("email","Jone@cskaoyan.com");
        // 设置age属性为待修改的新值
        userUpdateWrapper.set("age", 29);

        // update, 不需要传递user对象，因为使用UpdateWrapper的set方法来设置值
        userMapper.update(null, userUpdateWrapper);
        
    }
```

#### `Condition`

所有的条件参数都有一个包含`condition`的重载方法。

在实际开发中，有时需要根据条件来决定是否在SQL语句中添加条件，即需要**实现动态SQL的功能**，此时我们可以使用带`condition`参数的重载方法来实现。

该`condition`参数是一个`boolean`值，表示是否在SQL语句中拼接条件。只有为`true`时，条件才会出现在最终的SQL语句当中。

```java
    @Test
    public void testCondition () {
        String name = null;
        Integer minAge = null;
        Integer maxAge = 25;

        // 查询指定name，年龄在指定范围的用户
        // Preparing: SELECT id,name,age,email FROM user WHERE age <= ?
        QueryWrapper<User> userQueryWrapper = new QueryWrapper<>();
        // 每一个条件，都可以调用其有condition参数的重载方法(都是第一个参数)
        userQueryWrapper.eq(null != name && !name.isEmpty(), "name", name)
                .ge(minAge != null, "age", minAge)
                .le(maxAge != null, "age", maxAge);

        List<User> users = userMapper.selectList(userQueryWrapper);
    }
```

#### `LambdaQueryWrapper`

`LambdaQueryWrapper` 的本质和`QueryWrapper`是相同的，都主要表示`where`中的条件。

唯一不同的是，在**指定条件字段**的时候，不是直接指定字段的名称，而是通过`Lambda`表达式(实体类中对应属性的`getXxx`方法或者`isXxx`方法)来指定。

好处在于，避免写错列名。

```java
    @Test
    public void testLambdaQueryWrapper() {
        String name = null;
        Integer minAge = null;
        Integer maxAge = 25;

        // 查询name为zs，年龄在18-25岁的用户
        // Preparing: SELECT id,name,age,email FROM user WHERE age <= ? AND name=?
        LambdaQueryWrapper<User> userQueryWrapper = new LambdaQueryWrapper<>();
        // 和QueryWrapper的不同之处就在于，列名使用一个Lambda表达式来表示的(属性对应的get方法)
        userQueryWrapper.eq(null != name && !name.isEmpty(), User::getName, "zs")
                .ge(minAge != null, User::getAge, minAge)
                .le(maxAge != null, User::getAge, maxAge);

        List<User> users = userMapper.selectList(userQueryWrapper);
    }
```

#### `LambdaUpdateWrapper`

```java
    @Test
    public void testLambdaUpdateWrapper() {
        // 将Jone的年龄改为29，邮箱改为 Jone@cskaoyan.com
        // UPDATE user SET age=?, email=? WHERE name = ?
        LambdaUpdateWrapper<User> userUpdateWrapper = new LambdaUpdateWrapper<>();
        // 列名使用一个Lambda表达式来表示的(属性对应的get方法)
        userUpdateWrapper.eq(User::getName, "Jone");
        // 设置email属性为待修改的新值（列名使用一个Lambda表达式来表示的(属性对应的get方法)）
        userUpdateWrapper.set(User::getEmail,"Jone@cskaoyan.com");
        // 设置age属性为待修改的新值(列名使用一个Lambda表达式来表示的(属性对应的get方法))
        userUpdateWrapper.set(User::getAge, 29);

        // update, 不需要传递user对象，因为使用UpdateWrapper的set方法来设置值
        userMapper.update(null, userUpdateWrapper);

    }
```

## 分页插件

MyBatis Plus自带分页插件，只要简单的配置即可实现分页功能。

添加配置类

```java
@Configuration
//@MapperScan("com.cskaoyan.mybatisplus.mapper") //可以将启动类中的注解移到此处
public class MybatisPlusConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
	}
}
```

```java
@Test
public void testPage(){
    // 设置分页参数:当前页，每页几条记录
    // MybatisPlus注意页数从1开始
    // 泛型仍然是映射的实体类
    Page<User> page = new Page<>(1, 2);
    userMapper.selectPage(page, null);
    //获取分页中的每一条记录
    List<User> list = page.getRecords();
    list.forEach(System.out::println);
    System.out.println("当前页：" + page.getCurrent());
    System.out.println("每页显示的条数：" + page.getSize());
    System.out.println("总记录数：" + page.getTotal());
    System.out.println("总页数：" + page.getPages());
    System.out.println("是否有上一页：" + page.hasPrevious());
    System.out.println("是否有下一页：" + page.hasNext());
}
```


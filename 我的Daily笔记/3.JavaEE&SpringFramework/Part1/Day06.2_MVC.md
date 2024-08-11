# 前言

## 学习目标

1. 熟悉使用`JSON`工具完成，Java对象（Map）和Json字符串之间的相互转换（注意提供构造器和`getter/setter`方法）
2. 理解MVC设计模式
3. 理解三层架构思想
4. 掌握MVC设计模式和三层架构的代码风格

## 前置知识准备

- JSON格式
- Servlet开发（接收参数、响应数据等）


# `JSON`

**JSON**（JavaScript Object Notation）是一种轻量级的数据交换格式，是存储和交换文本信息的一种语法，它和`XML`有相同的特性，是一种**数据存储格式**，却比 `XML`  更小、更快、 更易于人编写和阅读、更易于生成和解析。

> 小是为了传输快。

数据交换：就是数据交互，比如网站前台和后台之间的交互，我们可以在请求报文的请求体中使用 `JSON` 字符串携带信息，在响应报文的响应体中使用 `JSON` 字符串响应信息给客户端。

同时，对之前`key=value` 传输类型数据格式的一个补充，`key=value` 最大的弊端是无法表示出数据和数据之间的关系。

## 和 `XML` 比较

这样的一个层级信息

> - 中国
>   - 黑龙江
>     - 哈尔滨
>     - 大庆
>   - 广东
>     - 广州
>     - 深圳
>     - 珠海
>   - 台湾
>     - 台北
>     - 高雄
>   - 新疆
>     - 乌鲁木齐

`xml`文件提供的信息

```xml
<?xml version="1.0"encoding="utf-8"?>
<country>
    <name>中国</name>
    <province>
        <name>黑龙江</name>
        <cities>
            <city>哈尔滨</city>
            <city>大庆</city>
        </cities>
    </province>
    <province>
        <name>广东</name>
        <cities>
            <city>广州</city>
            <city>深圳</city>
            <city>珠海</city>
        </cities>
    </province>
    <province>
        <name>台湾</name>
        <cities>
            <city>台北</city>
            <city>高雄</city>
        </cities>
    </province>
    <province>
        <name>新疆</name>
        <cities>
            <city>乌鲁木齐</city>
        </cities>
    </province>
</country>
```

使用 `JSON` 来提供信息

> - 前端中的JS对象
>
>   > ```js
>     > var country = {name:"中国",province:[{name:"黑龙江", cities:["哈尔滨","大庆"]}]}
>     > ```
>
> - `JSON` 字符串
>
>    ```json
>     {
>         "name":"中国",
>         "province":[{"name":"黑龙江",”cities”:["哈尔滨","大庆"]},
>                     {"name":"广东","cities":["广州","深圳","珠海"]},
>                     {"name":"台湾","cities":["台北","高雄"]},
>                     {"name":"新疆","cities":["乌鲁木齐"]}
>                    ]
>     }
>    ```

我们在开发过程中主要使用的就是**JSON字符串**

相较于xml → 更小、更快、可读性更高、更易解析

## 常用Json解析

- fastjson是阿里巴巴的开源JSON解析库
- Gson是Google提供的JSON解析库
- Jackson是SpringBoot默认序列化JSON解析库



性能方面，Jackson和FastJson差距很小，Jackson是SpringBoot默认的序列化库，也是最稳定的一个，FastJson由于频繁被曝出漏洞且作者没有那么多精力维护，所以默认序列方式还是选择Jackson最好。

对应的依赖

```xml
<!--Gson-->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.9</version>
</dependency>
<!--fastjson-->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.73</version>
</dependency>
<!--jackson-->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.13.3</version>
</dependency>
```

我们使用一下Jackson来完成JSON转换

## Jackson常规使用

首先实例化一个Jackson中用来做ObjectMapper

```java
ObjectMapper objectMapper = new ObjectMapper();
```

然后使用ObjectMapper提供的方法完成转换

| 方法名                                         | 参数                                                         | 返回值                              | 说明                     |
| ---------------------------------------------- | ------------------------------------------------------------ | ----------------------------------- | ------------------------ |
| `writeValueAsString(Object object)`            | `Object`：被转换的对象                                       | `String`：转换的结果                | 将Object转换为JSONString |
| `readValue(String content,Class<T> valueType)` | `String content`:被转换的字符串；`Class<T> valueType`:指定接收返回值的类型 | `<T>`泛型：在第二个参数被指定的类型 | 将JSONString转换为Object |

接着构建一个场景：提供一个User对象，体现出这几项信息

> 姓名，密码，年龄，爱好（多个），房产（多个）

我们定义的User类如下

```java
/**
 * @Data提供getter/setter方法
 */
@Data
public class User {
    String username;
    String password;
    Integer age;
    String[] hobbies;
    List<House> houseList; 
}
/**
 * @AllArgsConstructor 提供有参构造方法的同时提供无参构造方法
 * @NoArgsConstructor 提供无参构造方法
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class House {
    String location;
    Double price;
}
```

接收初始化一个User实例，用来做接下来的转换

```java
private static User user = new User();
static {
    user.setUsername("李雷");
    user.setPassword("123456");
    user.setAge(25);
    user.setHobbies(new String[]{"唱","跳","RAP","篮球"});
    List<House> houses = new ArrayList<>();
    houses.add(new House("软件新城C13二楼", 1_000_000.0));
    houses.add(new House("软件新城C13四楼", 1_250_000.0));
    user.setHouseList(houses);
}
```

接着使用的转换代码如下

```java
public static void main(String[] args) throws JsonProcessingException {
    // 将user实例转换为JSON字符串
    String userJsonString = objectMapper.writeValueAsString(user);
    System.out.println("JSON:" + userJsonString);
		// 将JSON字符串转换为user实例
    User user = objectMapper.readValue(userJsonString, User.class);
    System.out.println("toString:" + user);
}
```

打印结果如下

```
JSON:{"username":"李雷","password":"123456","age":25,"hobbies":["唱","跳","RAP","篮球"],"houseList":[{"location":"软件新城C13二楼","price":1000000.0},{"location":"软件新城C13四楼","price":1250000.0}]}
toString:User(username=李雷, password=123456, age=25, hobbies=[唱, 跳, RAP, 篮球], houseList=[House(location=软件新城C13二楼, price=1000000.0), House(location=软件新城C13四楼, price=1250000.0)])
```

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**注意：一定要增加上无参构造和getter/setter方法**</span>

## 指定日期格式

比如我们在`User`中增加一个成员变量`Date birthday`，我们重新完成转换

```java
@Data
public class User {
    String username;
    String password;
    Integer age;
    String[] hobbies;
    List<House> houseList;
    Date birthday;
}
```

```java
user.setBirthday(new Date());
```

转换

```java
String userJsonString = objectMapper.writeValueAsString(user);
System.out.println("JSON:" + userJsonString);
```

```json
{
    "username":"李雷",
    "password":"123456",
    "age":25,
    "hobbies":["唱","跳","RAP","篮球"],
    "houseList":[
        {"location":"软件新城C13二楼","price":1000000.0},
        {"location":"软件新城C13四楼","price":1250000.0}
    ],
    "birthday":1678762314011
}
```

此时`birthday`的值是时间戳，我们希望设置成为`“2015-09-27”`，`“2009-03-26 15:26:32”`之类格式的日期。对于`Date类型`的成员变量，我们在值转换过程中可以**指定格式**。

然后在初始化的时候增加以下代码

```java
objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
```

```json
{"username":"李雷","password":"123456","age":25,"hobbies":["唱","跳","RAP","篮球"],"houseList":[{"location":"软件新城C13二楼","price":1000000.0},{"location":"软件新城C13四楼","price":1250000.0}],"birthday":"2022-03-14"}
```

> `ObjectMapper`也是线程安全的，对其优化。
>
> 方法一：放在一个类里用静态成员变量；
>
> 方法二：放在`ServletContext`里。



# MVC设计模式

## 场景分析

先抛开MVC不谈，我们给大家来看一下这样一个`jsp`（里面的内容和`html`有些像）

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    hello,来自${student.clazz}的${student.name}
</body>
</html>
```

当我们访问的时候，http://localhost:8080/student.jsp，然后我们看到的是这样的一个页面

![image-20230314212537970](.\assets\image-20230314212537970.png)

出现`${}`位置的内容都是空白的，然后我们开发了如下`Servlet`

```java
@WebServlet("/student")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        Student student = StudentHolder.getStudentMap().get(name);

        req.setAttribute("student",student);
        req.getRequestDispatcher("/student.jsp").forward(req,resp);
    }
}
```

同时也提供了StudentHolder存储了一些学生数据

```java
public class StudentHolder {

    private static Map<String, Student> studentMap = new HashMap<>();
    static {
        studentMap.put("lilei",new Student("李雷","三年二班"));
        studentMap.put("hanmeimei",new Student("韩梅梅","三年二班"));
        studentMap.put("liziming",new Student("李子明","三年六班"));
    }

    public static Map<String, Student> getStudentMap() {
        return studentMap;
    }
}
```

访问的请求：

- http://localhost:8080/student?name=lilei
- http://localhost:8080/student?name=hanmeimei
- http://localhost:8080/student?name=liziming

![image-20230314214251542](.\assets\image-20230314214251542.png)

分析上面的流程：

1. 当我们发送的请求的URI为 `/student` 的时候，我们进入到StudentServlet中处理全部的业务
2. 在Servlet的方法中，查询了student学生信息 
3. 将student信息放在Request域中，和转发的请求共享
4. 在student.jsp中渲染Request域中的student信息

继续分析（和上面的1234对应来看）：

1. 这个`Servlet` 可以称之为控制器 → `Controller`

   > 所有的业务都在`Servlet`中展开
2. 查询student信息就是处理数据逻辑 → Model ；另外这部分工作是在Servlet（Controller）中进行的
3. 将数据和jsp共享 → 在Controller中将Model封装的数据准备就绪
4. Servlet（Controller）设置转发的`jsp`（视图View），并且在`jsp`（视图）中渲染出Model提供的信息

## MVC介绍

三个核心部件：

- 模型（`Model`）应用程序中用于处理应用程序**数据逻辑**的部分
- 视图（`View`）应用程序中处理**数据显示**的部分，就是页面的展示，采集用户数据
- 控制器（`Controller`）应用程序中处理用户交互的部分。接收用户端的请求，指的是Servlet的功能，根据界面传递过来不同的值进行不同的增删改查操作之后再跳转到不同的界面显示。做一个承上启下的作用。

强制性地使应用程序的输入、处理和输出分开。它们各自处理自己的任务。最典型的MVC就是JSP + Servlet + JavaBean的模式。

MVC其实说的就是一个事情：解耦。

可以这样子理解，当我们通过客户端向服务器发送请求，

1. 我们请求的所有处理都是在控制器`Controller`中，在控制器中完成全部的请求处理
2. 控制器 `Controller` 中，首先通过 模型Model 的处理获取我们最终要呈现的数据。举个例子，如果是学生信息查询，那么Model做的就是查询学生信息；如果做的是订单查询，Model查询的就是订单数据
3. 控制器 `Controller` 中，做视图页面View 和 模型Model查询出来的数据的连接，最终在View中加载Model中封装的信息



**饭店模型**：Client相当于点餐的顾客，Controller相当于饭店里的服务员，Model相当于饭店的厨房（后厨），View相当于餐桌，餐桌了给顾客呈现了菜品。

完成一道完整的流程：顾客点餐，找到了服务员，服务员通知后厨做菜，比如油爆双脆，后厨做完了菜由服务员将菜品布置到餐桌上，顾客桌上呈现了一道油爆双脆

- 其中顾客只管向服务员提出要求，这就是客户端向Controller发起请求

- 其中服务员就是起到了协调的作用，这也就是Controller的功能，所有的事务都要通过控制器

- 其中后厨只管做菜，这就是Model只管协调数据
- 服务员布置好餐桌，由服务员将菜品是给顾客，就是Model加工的数据最终在View上通过Controller呈现给客户端
- 同时餐桌和后厨是彼此隔离的



对应流程图

![MVC](.\assets\MVC.png)

## 前后端分离

我们前面的前端学习，前端技能3要素：HTML、CSS、JS

通过js向后端发起**`Ajax`异步请求**，然后请求到Server服务器，找到对应的控制器，由控制器和Model层和View做交互，最终服务器处理的结果以Json的形式交给JS，JS可以直接解析这个Json对象，在前端页面上呈现最终的效果

![front-end-seperate](.\assets\front-end-seperate.png)



这时候大家可能会有疑问，这还是MVC吗？

是，服务器中承担的 MC + 0.5V ，还有前端也承担了一部分V，这样子前后端可以同步开发了，而前后端之间通信的载体是JSON

**也就是我们在Servlet中完成开发之后，响应体中响应的是Json字符串**



## 案例

### 需求

我们来开发一个这样的接口

请求相关信息

> 请求URL：http://localhost:8084/auth/account/check
>
> 请求方法：POST
>
> 请求参数：请求参数是JSON字符串
>
> ```json
> {"userAccount":"admin123"}
> ```

业务：传入的用户名信息，然后完成一些业务，需要在数据库**user_t**表中根据用户名查询id信息

- 如果用户名长度小于6，响应一段JSON数据

- ```json
  {
      "data":null,
      "errmsg":"字符串长度至少6位",
      "errno":400
  }
  ```

- 如果用户不存在，响应一段JSON数据

- ```json
  {
      "data":null,
      "errmsg":"用户不存在",
      "errno":502
  }
  ```

- 如果用户存在，响应一段JSON数据

- ```json
  {
      "data":null,
      "errmsg":"用户存在",
      "errno":200
  }
  ```

  

```sql
DROP TABLE IF EXISTS `user_t`;
CREATE TABLE `user_t`  (
  `id` int(11) NOT NULL,
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_t
-- ----------------------------
INSERT INTO `user_t` VALUES (3342, 'admin123', '123');
INSERT INTO `user_t` VALUES (3343, 'lilei123', '123456');
INSERT INTO `user_t` VALUES (3344, 'hanmeimei', '667890');
```



### 分析操作

获得请求`URI`，根据最后一个`/`的位置做截取，获得`*`位置的值，根据值的不同，调用`Servlet`中的不同方法

```java
@WebServlet("/auth/account/*")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //首先获得请求URL中的*的部分，也就是resource（operation）
        String operation = getOperation(request);
        switch (operation) {
            case "/check":
                check(request, response);
                break;
        }
    }

    private void check(HttpServletRequest request, HttpServletResponse response) {
        
    }

    /**
     * 分析Request获得resource
     * @param request
     * @return
     */
    private String getOperation(HttpServletRequest request) {
        String uri = request.getRequestURI();
        //最后一个/
        int index = uri.lastIndexOf("/");
        String operation = uri.substring(index);
        return operation;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

}
```

### 解析请求参数

由于我们提交的是Json字符串请求参数，要获得字符流获得Json字符串，然后解析

引入jackson依赖，用来做Json序列化和反序列化

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.13.3</version>
</dependency>
```

定义Json解析的方法如下

```java
/**
 * 解析Json字符串为Map
 */
private Map parseJson(HttpServletRequest request) throws IOException {
    // 首先获得Json字符串
    String jsonStr = request.getReader().readLine();
    ObjectMapper objectMapper = new ObjectMapper();
    return objectMapper.readValue(jsonStr,Map.class);
}
```

那么就可以在`doGet(/doPost)`分发的`check`方法中，获得map，然后获得其中的userAccount

```java
private void check(HttpServletRequest request, HttpServletResponse response) throws IOException {
    Map parameterMap = parseJson(request);
    String userAccount = (String) parameterMap.get("userAccount");
}
```

### 用户名长度

判断用户名长度是否小于6位，如果小于6位，则响应对应的Json字符串

我们可以定义一下响应的Json数据对应的Vo类

```java
@Data
public class BaseRespVo<T> {
    T data;
    String errmsg;
    int errno;
    public static BaseRespVo ok(){
        BaseRespVo<Object> respVo = new BaseRespVo<>();
        respVo.setErrmsg("成功");
        respVo.setErrno(0);
        return respVo;
    }
    
    public static <T> BaseRespVo<T> ok(T data){
        BaseRespVo<T> respVo = new BaseRespVo<>();
        respVo.setData(data);
        respVo.setErrmsg("成功");
        respVo.setErrno(0);
        return respVo;
    }
    public static BaseRespVo accountExist() {
        BaseRespVo vo = new BaseRespVo();
        vo.setErrno(200);
        vo.setErrmsg("用户存在");
        return vo;
    }
    
    public static BaseRespVo fail(){
        BaseRespVo<Object> respVo = new BaseRespVo<>();
        respVo.setErrmsg("失败");
        respVo.setErrno(500);
        return respVo;
    }
    
    public static BaseRespVo fail(String msg){
        BaseRespVo<Object> respVo = new BaseRespVo<>();
        respVo.setErrmsg(msg);
        respVo.setErrno(500);
        return respVo;
    }
    public static BaseRespVo fail(String msg,int number){
        BaseRespVo<Object> respVo = new BaseRespVo<>();
        respVo.setErrmsg(msg);
        respVo.setErrno(number);
        return respVo;
    }
}
```

那么我们根据字符串长度判断之后，进行Json的响应

```java
private void check(HttpServletRequest request, HttpServletResponse response) throws IOException {
    ObjectMapper objectMapper = new ObjectMapper();
    Map parameterMap = parseJson(request);
    String userAccount = (String) parameterMap.get("userAccount");
    if (userAccount == null || userAccount.length() < 6) {
        BaseRespVo vo = BaseRespVo.fail("字符串长度至少6位", 400);
        String respJsonStr = objectMapper.writeValueAsString(vo);
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().println(respJsonStr);
        return;
    }
}
```

![image-20230320173535603](.\assets\image-20230320173535603.png)

### 查询信息

继续查询根据user_t中的account列的值，查询信息，如果信息不为空，则说明存在该账户；

查询，则需要整合MyBatis，提供工具类，可以获得会话或Mapper

```java
public class MyBatisUtil {
    private static SqlSessionFactory sqlSessionFactory;
    static {
        try {
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("mybatis.xml"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }
    public static SqlSession getSqlSession(boolean autoCommit) {
        return sqlSessionFactory.openSession(autoCommit);
    }

    public static <T> T getMapper(Class<T> clazz) {
        T mapper = getSqlSession(true).getMapper(clazz);
        return mapper;
    }
}
```

在Mapper接口和映射文件中分别定义查询方法和sql语句

```java
public interface UserMapper {
    UserPo selectByAccount(@Param("account") String account);
}
```

```xml
<mapper namespace="com.cskaoyan.mapper.UserMapper">
    <select id="selectByAccount" resultType="com.cskaoyan.model.UserPo">
        select id, account, password
        from user_t
        where account = #{account}
    </select>
</mapper>
```

那么在check方法中做查询如下

```java
private void check(HttpServletRequest request, HttpServletResponse response) throws IOException {
    ObjectMapper objectMapper = new ObjectMapper();
    Map parameterMap = parseJson(request);
    String userAccount = (String) parameterMap.get("userAccount");
    if (userAccount == null || userAccount.length() < 6) {
        BaseRespVo vo = BaseRespVo.fail("字符串长度至少6位", 400);
        String respJsonStr = objectMapper.writeValueAsString(vo);
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().println(respJsonStr);
        return;
    }

    UserMapper userMapper = MyBatisUtil.getMapper(UserMapper.class);
    UserPo userPo = userMapper.selectByAccount(userAccount);
    BaseRespVo vo;
    if (userPo == null) {
        vo = BaseRespVo.fail("用户不存在", 502);
    }else {
        vo = BaseRespVo.accountExist();
    }
    String respJsonStr = objectMapper.writeValueAsString(vo);
    response.getWriter().println(respJsonStr);
}
```

### 小结

通过这个案例我们已经完整的完成业务了，但是大家可以看到，除了UserMapper之外，其他的所有的代码都是写在UserServlet中的check方法里的，也就是所有的内容都耦合在check方法里。

M：这里的Model指使用UserMapper完成对应的查询（或增删改）

V：这里的View主要是响应Json数据

C：这里的Controller主要是check方法中，组织Model的获取和View的响应

我们开发应用程序不符合“高内聚，低耦合”的特点

为了让程序开发人员分工更明确，更专注于应用系统核心业务逻辑的分析、设计和开发，提高了开发效率，增加项目的可维护性，我们提出了三层架构



# 三层架构

三层架构这里和MVC并不是冲突的概念，而是在MVC的基础上进一步解耦，之前在Controller控制层直接调用了Model，为了后续业务上的解耦，在中间增加增加了一层业务逻辑层，在业务逻辑层中处理大部分业务

![三层架构](.\assets\三层架构.png)

## 介绍

三层架构：表示层、业务逻辑层、数据访问层

- 避免了表示层直接访问数据访问层，表示层只和业务逻辑层有联系，提高了数据安全性
- 如果切换B/S、C/S架构，直接替换表示层即可，比如替换Servlet
- 项目结构更清楚，分工明确，增加可维护性

实际在开发过程中的体现，就是控制层（Servlet）中直接调用Service，在Service中调用Dao(Data Access Object)

## 案例修改

那我们把前面的案例修改为三层架构

### 表示层

```java
@WebServlet("/auth/account/*")
public class AuthServlet extends HttpServlet {
    
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //首先获得请求URL中的*的部分，也就是resource（operation）
        String operation = getOperation(request);
        switch (operation) {
            case "/check":
                check(request, response);
                break;
        }

    }

    /**
     * 解析Json字符串为Map
     */
    private Map parseJson(HttpServletRequest request) throws IOException {
        // 首先获得Json字符串
        String jsonStr = request.getReader().readLine();
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(jsonStr,Map.class);
    }

    private void check(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        Map parameterMap = parseJson(request);
        String userAccount = (String) parameterMap.get("userAccount");
        
        BaseRespVo vo = userService.check(userAccount);
        
        String respJsonStr = objectMapper.writeValueAsString(vo);
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().println(respJsonStr);
    }

    /**
     * 分析Request获得resource
     * @param request
     * @return
     */
    private String getOperation(HttpServletRequest request) {
        String uri = request.getRequestURI();
        //最后一个/
        int index = uri.lastIndexOf("/");
        String operation = uri.substring(index);
        return operation;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

}
```

在表示层中，引入Service层的实例（第4行）

在check方法中，可以获得参数

然后使用Service层的方法获得实例

然后在后面将其转换为 视图对象的Json字符串，响应给客户端

### 业务逻辑层

```java
public class UserServiceImpl implements UserService {
    @Override
    public BaseRespVo check(String userAccount) {
        BaseRespVo vo;
        if (userAccount == null || userAccount.length() < 6) {
            vo = BaseRespVo.fail("字符串长度至少6位", 400);
            return vo;
        }

        UserMapper userMapper = MyBatisUtil.getMapper(UserMapper.class);
        UserPo userPo = userMapper.selectByAccount(userAccount);
        if (userPo == null) {
            vo = BaseRespVo.fail("用户不存在", 502);
        }else {
            vo = BaseRespVo.accountExist();
        }

        return vo;
    }
}
```

业务逻辑层和数据访问层交互

### 数据访问层

和MVC讲的没有变化

采用分层架构的好处：解耦。

# 案例

## 品牌制造商的添加

1. 根据`url`，确定`Servlet` 的`URL-Pattern` ，以及增加对应的处理请求的方法

2. 根据请求参数的格式，选择对应的方式，来接收请求参数
   1. 有没有出现在`queryString`这里
   2. 请求体里是`key=value`形式还是`json`
   3. 请求体里有没有 `multipart/form-data`

3. 增加 `Service` 的接口和实现类，在其中定义处理业务的方法（包含我们前面接收的参数），`service`提供一个`Model` 层的结果
4. 根据`Service` 返回的数据，封装`json`对象并且转换为`Json`字符串，响应回去
   1. 转换的`json`字符串的格式，根据响应报文做分析


> 当tiniyInt(1)时可以使用布尔值接收

> Mybatis 如何获得自增主键
>
> 动态SQL里`selectKey`
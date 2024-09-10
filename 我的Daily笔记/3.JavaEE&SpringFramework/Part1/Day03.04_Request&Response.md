###### 注意看思维导图

![Day03-Request](.\assets\Day03-Request-1694605247152-1.jpg)

![Day04-Response](.\assets\Day04-Response.jpg)

# 前言

## 学习目标

> 1. 理解Request、Response和HTTP报文之间的关系
> 2. 掌握通过Request能够获得的信息
>    - 请求URL、URI、请求协议
>    - 请求头、客户机和主机
>    - 请求参数
> 3. 掌握通过Response能够完成的设置
>    - 响应中文乱码问题
>    - 响应（Json）字符串、图片（文件）
>    - 了解特殊的响应头
> 4. 逐步通过反射能够解决一些通用问题

## 前置知识准备

> - HTTP 请求报文和响应报文
>   - 请求报文和响应报文分别包含哪些部分
> - 反射reflect
>   - 获得Class对象
>   - 获得成员变量并给成员变量赋值
>   - 获得方法并且能够调用指定方法
> - MyBatis的基本使用
> - 通过form表单分别构造get请求和post请求，能构造文件上传的请求
> - 解析字符串获得其中的信息

## 请求报文

请求报文的组成部分

- 请求行

  格式：方法  + `URL` `?` `queryString `  +  协议

  - **请求方法**
  - 请求的URL http://localhost:8080/hello
  - 请求协议

- 请求头
  - 格式是`key：value`
  - 比较特殊的请求头：
    - `Content-Type`  由浏览器提供给服务器的正文类型
    - `Accept`  浏览器**期望**从服务器获得正文的类型（ 服务器提供给浏览器的正文类型）
    - `Host`  主机ip
  
- （空行）

- 请求正文
  - 普通的`Get`请求和 `form`表单提供的`Get/Post`请求 如果携带了参数它的格式是`key1=value1&key2=value2&key3=value3`等
  - 携带`Json`数据的`Post`请求  ` {}或[]`

```http
POST http://101.43.69.31:8083/admin/auth/login HTTP/1.1
Host: 101.43.69.31:8083
Connection: keep-alive
Content-Length: 45
Accept: application/json, text/plain, */*
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.78
Content-Type: application/json;charset=UTF-8
Origin: http://101.43.69.31:8080
Referer: http://101.43.69.31:8080/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6

{"username":"admin123","password":"admin123"}
```

分析一个请求体的表单信息。

## 响应报文

响应报文的组成

- 响应行
  - 协议
  - 状态码
- 响应头
  - 格式是`key=value`
  - `Content-Type` 服务器提供给浏览器的正文类型，后面通常会跟`charset`（因为绝大部分内容都是字符串信息），比如`application/json;charset=utf-8`
- （空行）
- 响应正文
  - 通常提供`json`字符串
  - 如果是`json`，`Content-Type`中通常是`application/json`


```http
HTTP/1.1 200
Vary: accept-encoding,origin,access-control-request-headers,access-control-request-method,accept-encoding
Set-Cookie: rememberMe=deleteMe; Path=/; Max-Age=0; Expires=Sun, 12-Feb-2023 06:51:56 GMT
Set-Cookie: JSESSIONID=24287278-5ebb-407d-a3f7-56b74782c4c7; Path=/; HttpOnly
Access-Control-Allow-Origin: *
Content-Type: application/json;charset=UTF-8
Date: Mon, 13 Feb 2023 06:51:56 GMT
Content-Length: 200

{"errno":0,"data":{"adminInfo":{"nickName":"admin123","avatar":"https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif"},"token":"24287278-5ebb-407d-a3f7-56b74782c4c7"},"errmsg":"成功"}
```

## 反射

### 获得Class对象

获得Class对象的方式                

定义了一个类，这个类，处于com.cskaoyan.service包下，类名为UserServiceImpl，我们想要获得这个Class对象，如何获得呢？

- `类.class` UserServiceImpl.class

- `对象.getclss()`
  
  > UserServiceImpl userService = new UserServiceImpl();
  >
  > useService.getClass();
  
- `Class.forName`("com.cskaoyan.service.UserServiceImpl")

```java
Class<UserServiceImpl> clazz1 = UserServiceImpl.class;

UserServiceImpl userService = new UserServiceImpl();
Class<? extends UserServiceImpl> clazz2 = userService.getClass();

Class<?> clazz3 = Class.forName("com.cskaoyan.service.UserServiceImpl");
```

如果我们想要使用一些通用性的代码，我们用哪种方式？

`Class.forName`

所谓通用是因为传参是一个字符串，可以把全限定类名写在配置文件中。

```java
public static void main(String[] args) throws IOException, ClassNotFoundException, IllegalAccessException, InstantiationException {
    InputStream inputStream = DriverDemo.class.getClassLoader().getResourceAsStream("parameter.properties");
    Properties properties = new Properties();
    properties.load(inputStream);

    String driver = (String) properties.get("driver");

    Class<?> driverClass = Class.forName(driver);

    Object instance = driverClass.newInstance();
}
```

```properties
# parameter.properties
# driver=com.cskaoyan.service.UserServiceImpl
driver=com.mysql.jdbc.Driver
```

我们使用的mysql版本是5.7，对应的驱动是`com.mysql.jdbc.Driver`

如果使用mysql版本8，对应的驱动`com.mysql.cj.jdbc.Driver`

### 获得成员变量并给成员变量赋值

给某一个对象的某一个成员变量赋值。

```java
// 通过class能够获得实例
// 可以直接使用newInstance方法
Object instance1 = clazz3.newInstance();
// 可以先获得构造器（构造方法），通过构造方法实例化
Constructor<?> constructor = clazz3.getDeclaredConstructor();
Object instance2 = constructor.newInstance();

// 利用反射方式获得Field，通过反射的方式赋值
Field usernameField = clazz3.getDeclaredField("username");
usernameField.setAccessible(true);
usernameField.set(instance2,"zhangsan");
```

不建议直接通过反射的方式给成员变量赋值，**建议使用set方法做赋值**。

### 获得方法并且能够调用方法

```java
//UserServiceImpl userServiceImpl = (UserServiceImpl) instance1;
//userServiceImpl.setUsername("lisi");
// 通过反射的方式实现通用性的设置

Properties properties = new Properties();
properties.load(ReflectExecution.class.getClassLoader().getResourceAsStream("parameter.properties"));
String className = (String) properties.get("className");
String method = (String)properties.get("method");
String value = (String)properties.get("value");

Class<?> clazz = Class.forName(className);
Object instance = clazz.newInstance();//instance的username成员变量是否是lisi
Method declaredMethod = clazz.getDeclaredMethod(method, String.class);
Object invoke = declaredMethod.invoke(instance, value);
```

`Object invoke = method.invoke(instance,args)`

| 变量名     | 类型                                                         | 含义                           |
| ---------- | ------------------------------------------------------------ | ------------------------------ |
| `method`   | `Method `→ clazz.getDeclaredMethod                           | 通过反射获得的Method           |
| `instance` | `Object` (两种方式：1.  new XXX ; 2. 反射,比如clazz.newInstance) | 就是实例（对象）               |
| `args`     | `Object[]`                                                   | 参数，把所有的参数封装为数组   |
| `invoke`   | `Object`                                                     | instance对象执行method的返回值 |

```java
/**
 * 通过反射的方式执行UserServiceImpl中的sayHello
 */
public static void main(String[] args) throws Exception{
    Properties properties = new Properties();
    properties.load(ReflectExecution.class.getClassLoader().getResourceAsStream("parameter.properties"));
    String className = (String) properties.get("className");
    String method = (String)properties.get("method");
    String value = (String)properties.get("value");
    //String parameter1 = (String)properties.get("parameter1");
    //String parameter2 = (String)properties.get("parameter2");
    Object parameter1 = properties.get("parameter1");
    Object parameter2 = properties.get("parameter2");

    Class<?> clazz = Class.forName(className);
    Object instance = clazz.newInstance();

    Method setUsername = clazz.getDeclaredMethod("setUsername", String.class);
    setUsername.invoke(instance, value);

    //Method declaredMethod = clazz.getDeclaredMethod(method, String.class,String.class);
    Method declaredMethod = clazz.getDeclaredMethod(method, parameter1.getClass(),parameter2.getClass());
    //执行sayHello方法
    Object result = declaredMethod.invoke(instance, new Object[]{parameter1, parameter2});
}
```

## `MyBatis`

```java
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("mybatis.xml"));
// 在整个应用程序中维护这个对象，想要在多个Servlet中共享这个对象
// ServletContext
// 提供一个Servlet，loadOnStartup为正数，且数值比较小，这个Servlet在应用程序启动过程中就会率先开始初始化，我们就可以利用生命周期的init方法去初始化SqlSessionFactory实例，并且将其放入到ServletContext中
```

# 概述

**`Request `请求**

**`Response` 响应**

先看我们之前开发的`Servlet`，在`Servlet`中的`service`以及`HttpServlet`的`doGet`、`doPost`方法中的形参:

```java
public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

}
```

在使用Tomcat的时候就会产生Request，同时也会产生Response

可以这样子理解，当我们通过浏览器（或客户端）发送请求，在服务器应用中整个过程中的信息流通都是通过Request、Response流通的。

**`Request`：获得提供的信息，主要使用的是其`getXXX`方法**

**`Response`：设置信息提供给客户端（浏览器），主要使用的是其`setXXX`方法**

![image-20221031112258094](.\assets\image-20221031112258094.png)

![image-20230313104005727](.\assets\image-20230313104005727.png)

![image-20230213172659060](.\assets\image-20230213172659060.png)

每次发起请求，其实产生一组新的`Request` 和`Response` 对象

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**记住一个点：使用Request主要为了输入，使用Response主要为了输出**</span>

<font color='red'>**服务器将请求报文封装为`Request`对象，方便我们通过`Request`提供的方法来直接获得请求报文中的信息；服务器将响应的信息封装为`Response`对象，当我们通过`Response`对象来完成各种设置之后，服务器响应给浏览器的时候将`Response`对象转换为响应报文**</font>。

为了提供统一的规范，需要提供统一的规范接口`ServletRequest`和`ServletResponse`。

# Request

1. 请求报文有什么样的信息，我们怎样获得；

2. 请求报文中的特殊信息该如何获得

`HttpServletRequest` 获得HTTP请求报文中携带的信息

```http
POST http://101.43.69.31:8083/admin/auth/login HTTP/1.1
Host: 101.43.69.31:8083
Connection: keep-alive
Content-Length: 45
Accept: application/json, text/plain, */*
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.78
Content-Type: application/json;charset=UTF-8
Origin: http://101.43.69.31:8080
Referer: http://101.43.69.31:8080/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6

{"username":"admin123","password":"admin123"}
```

请求报文的组成

- 请求行
- 请求头
- （空行）
- 请求体

## 请求行

```http
POST http://101.43.69.31:8083/admin/auth/login HTTP/1.1
```

```http
GET http://localhost:8080/demo3/hello?username=zhangsan HTTP/1.1
```

得到方法，得到协议，得到URL，以及得到URL的具体信息。

| 信息          | 内容                                      | 方法               | 返回值         | 说明                    |
| ------------- | ----------------------------------------- | ------------------ | -------------- | ----------------------- |
| 请求方法      | `POST`、`GET`                             | `getMethod()`      | `String`       | 获得请求方法            |
| URL           | http://101.43.69.31:8083/admin/auth/login | `getRequestURL()`  | `StringBuffer` | 获得请求URL             |
| URI           | /admin/auth/login、/demo3/hello           | `getRequestURI()`  | `String`       | 获得请求URI             |
| context-path  | /demo3                                    | `getContextPath()` | `String`       | 获得上下文🏷️             |
| 服务器ip      | 101.43.69.31、localhost                   | `getLocalAddr()`   | `String`       | 获得ip                  |
| 端口号        | 8083、8080                                | `getLocalPort()`   | `int`          | 获得端口号              |
| `QueryString` | username=zhangsan                         | `getQueryString()` | `String`       | 获得Get请求的查询字符串 |
| 协议          | HTTP/1.1                                  | `getProtocol()`    | `String`       | 获得通讯协议            |

> `getRequestURL()`的返回值是`StringBuffer`，通过`toString()`转换成`String`
>
> `context-path` : 配置上下文路径,Tomcat中的`applicationContext`
>
> `QueryString` :在URL中通过`?`拼接的信息
>
> `local`指的是服务器
>
> `remote`指的是浏览器（客户端）

代码

```java
@WebServlet("/line")
public class LineServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        // http://localhost:8080/demo3/line?username=zhangsan
        // http://192.168.0.180:8080/demo3/line?username=zhangsan
        // 192.168.0.180可以修改为自己的ip
        
        // 请求方法
        String method = request.getMethod();
        // 请求URL和URI
        String url = request.getRequestURL().toString();
        String uri = request.getRequestURI();

        // 服务器本地的IP和端口号
        String localAddr = request.getLocalAddr();
        int localPort = request.getLocalPort();

        // 应用的上下文路径
        String contextPath = request.getContextPath();

        // 请求协议
        String protocol = request.getProtocol();
    }
}
```

## 请求头

```http
Host: 101.43.69.31:8083
Connection: keep-alive
Content-Length: 45
Accept: application/json, text/plain, */*
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.78
Content-Type: application/json;charset=UTF-8
Origin: http://101.43.69.31:8080
Referer: http://101.43.69.31:8080/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
```

请求头中的信息，都是`key：value` 的形式

- 可以知道有哪一些请求头 `key` → 获得所有的请求头
- 也可以知道这些请求头当中的值是什么 `value` → 获得特定`key`对应的`value`

| 方法                | 返回值                | 说明                                                         |
| ------------------- | --------------------- | ------------------------------------------------------------ |
| `getHeaderNames()`  | `Enumeration<String>` | 获得所有的请求头，可以通过遍历的方式来使用，使用方式类似于`Iterator` |
| `getHeader(String)` | `String`              | 传入的是请求头的`key`，返回的是请求头的`value`               |

构造一个请求，请求报文

```http
GET http://192.168.0.180:8080/demo4/header HTTP/1.1
Host: 192.168.0.180:8080
Connection: keep-alive
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.41
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
```

代码

```java
@WebServlet("/header")
public class HeaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        Enumeration<String> headerNames = request.getHeaderNames();
        System.out.println("所有的请求头");
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            System.out.println(headerName);
        }

        // 想要获得Host请求头的值
        String hostValue = request.getHeader("Host");
        System.out.println("hostValue = " + hostValue);
    }
}
```

控制台输出的结果

```java
所有的请求头
host
connection
cache-control
upgrade-insecure-requests
user-agent
accept
accept-encoding
accept-language
hostValue = 192.168.0.180:8080
```

可以直接输入对应的key-value

```java
Enumeration<String> headerNames = request.getHeaderNames();
System.out.println("所有的请求头");
while (headerNames.hasMoreElements()) {
    String headerName = headerNames.nextElement();
    String headerValue = request.getHeader(headerName);
    System.out.println(headerName + ":" + headerValue);
}
```

> 小练习：能够判断，是否包含某个请求头呢?如果包含，请把对应值打印出来

注意事项：请求头大小写不敏感

```java
// 想要获得Host请求头的值
String hostValue = request.getHeader("Host");
String hostValue2 = request.getHeader("host");
String hostValue3 = request.getHeader("HOST");
```

## 请求体

**请求体里的信息通过`IO`获取。**

请求报文是

```http
POST http://localhost:8080/demo5/body HTTP/1.1
User-Agent: PostmanRuntime/7.29.2
Accept: */*
Host: localhost:8080
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 17

username=zhangsan
```

请求体的部分

> username=zhangsan

字节流`InputStream`、字符流`Reader`

| 内容   | 方法               | 返回值               | 描述       |
| ------ | ------------------ | -------------------- | ---------- |
| 字节流 | `getInputStream()` | `ServletInputStream` | 获得字节流 |
| 字符流 | `getReader()`      | `BufferedReader`     | 获得字符流 |

字节流

```java
@WebServlet("/body1")
public class BodyServlet1 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        ServletInputStream inputStream = request.getInputStream();
        File file = new File("D:\\tmp", "1.txt");
        FileOutputStream outputStream = new FileOutputStream(file);
        
        int length;
        byte[] buff = new byte[1024];
        while ((length = inputStream.read(buff)) != -1) {
            outputStream.write(bytes,0,length);
        }
        outputStream.close();
        inputStream.close();
    }
}
```

字符流

```java
@WebServlet("/body2")
public class BodyServlet2 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        BufferedReader reader = request.getReader();
        File file = new File("D:\\tmp", "2.txt");
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(file));
        String str = null;
        while ((str = reader.readLine()) != null) {
            bufferedWriter.write(str);
        }
        bufferedWriter.flush();
        bufferedWriter.close();
        reader.close();
    }
}
```

## 特殊信息

### 客户机和服务器主机信息(了解)

请求是从客户机发到服务器的，在服务器中处理信息的获得，那么**对于服务器**，本地local是服务器，远程remote是客户机

我们在`Servlet`中可以获得本地的IP和Port，也可以获得远程IP和Port

| 信息                 | 方法              | 返回值   |
| -------------------- | ----------------- | -------- |
| 本地（服务器）IP     | `getLocalAddr()`  | `String` |
| 本地（服务器）端口号 | `getLocalPort()`  | `int`    |
| 远程（客户机）IP     | `getRemoteAddr()` | `String` |
| 远程（客户机）端口号 | `getRemotePort()` | `int`    |

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // 获得服务器端的信息
    String localAddr = req.getLocalAddr();
    int localPort = req.getLocalPort();

    // 获得客户机端的信息
    String remoteAddr = req.getRemoteAddr();
    int remotePort = req.getRemotePort();

    System.out.println("由" + remoteAddr + ":" + remotePort + "发送到" + localAddr + ":" + localPort);
}
```



## 请求参数  ⚡

发起一个请求的最核心内容就是请求参数。

`Servlet`提供了更直接的方式获得请求参数，避免从请求行和请求体中获得时的繁琐过程。

### 请求参数分类

请求参数的场景：

- 请求参数 在请求行中
  
  - > 使用`?`连接
  
  - `getQueryString()`
  
- 请求参数 在请求体中

  - > a. 构建`form`表单，指的是`key=value&key=value`
    >
    > b. 使用`json`格式传入请求参数
    
  - `getInputStream()/getReader()`




```java
@WebServlet("/origin")
public class OriginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        String parameterString = null;
        if ("GET".equals(request.getMethod())) {
            parameterString = request.getQueryString();
        }else {
            //ServletInputStream inputStream = request.getInputStream();
            //byte[] bytes = new byte[1024];
            //inputStream.read(bytes);
            //parameterString = new String(bytes);
            BufferedReader reader = request.getReader();
            parameterString = reader.readLine();
        }
        Map<String,String> parameterMap = executeMap(parameterString);
        String username = parameterMap.get("username");

        System.out.println(username);
    }

    private Map<String, String> executeMap(String parameterString) {
        HashMap<String, String> map = new HashMap<>();
        if (parameterString == null || "".equals(parameterString)) {
            return map;
        }
        //parameterArray[0] = "username=zhangsan"
        //parameterArray[1] = "password=lisi"
        String[] parameterArray = parameterString.split("\\&");
        for (String parameter : parameterArray) {
            int index = parameter.indexOf("=");
            String key = parameter.substring(0,index);
            String value = parameter.substring(index + 1, parameter.length());
            map.put(key, value);

        }
        return map;
    }
}
```

### 使用方法

分为`getParameter`相关，`Json`相关，`getPart`相关

#### 直接封装 `getParameter`相关

但是实际开发中并不需要我们自己这么做，因为`Request` 已经帮我们封装了可以直接使用的方法了

`.getParameterXXX` 这样的一些方法。也就是`key=value&key=value`的形式可以用方法`.getParameterXXX`。

| 方法                         | 返回值                 | 说明               |
| ---------------------------- | ---------------------- | ------------------ |
| `getParameterNames()`        | `Enumeration<String>`  | 获得所有的key      |
| `getParameterMap()`          | `Map<String,String[]>` | 获得所有的请求参数 |
| `getParameter(String)`       | `String`               | 获得第一个值       |
| `getParameterValues(String)` | `String[]`             | 获得所有值         |

`request` 对于**请求参数**的封装实际上，封装为一个`Map<String,String[]>`

![getParameter相关](.\assets\getParameter相关.png)

```java
/**
 * GET http://localhost:8080/demo7/parameter?key1=a1&key1=a2&key1=a3&key2=b1&key2=b2&key2=b3&key3=c1&key3=c2&key3=c3
 * key1: a1,a2,a3
 * key2: b1,b2,b3
 * key3: c1,c2,c3
 * @author stone
 * @date 2023/02/14 16:49
 */
@WebServlet("/parameter")
public class ParameterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String[]> parameterMap = request.getParameterMap();
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String parameterName = parameterNames.nextElement();
            System.out.println("parameterName = " + parameterName);
        }

        String key1 = request.getParameter("key1");
        System.out.println("key1 = " + key1);

        String[] key1s = request.getParameterValues("key1");
        System.out.println("key1s = " + Arrays.asList(key1s));
    }
}
```



### 引用类型 `getParameter`相关

```http
GET http://localhost:8080/demo7/register?username=root&password=123456&age=20&birthday=2000-10-15 HTTP/1.1
```

将请求参数封装为一个引用类型的对象，比如User

- 个性化

  - ```java
    User user = new User();
    user.setUsername(request.getParameter("username"));
    user.setPassword(request.getParameter("password"));
    ```

- 反射

  - ```java
    //通过自己写的工具类，进行转换
    BeanUtils.transfer(instance,parameterMap);
    ```
    
  - ```java
    public class MyBeanUtils {
     @SneakyThrows
     public static <T> T transfer(Class<T> clazz, Map<String, String[]> parameterMap) {
         // 先创建clazz对应的实例
         T instance = clazz.newInstance();
    
         // 给成员变量赋值的两种方式 →
         // 1. 反射直接给成员变量赋值 field.set(instance,value)
         // 2. 反射通过set方法间接给成员变量赋值 setMethod.invoke(instance,value)
    
         Iterator<String> iterator = parameterMap.keySet().iterator();
         // 反射直接给field赋值
         // giveFieldValue(clazz, parameterMap, instance, iterator);
    
         // 反射直接调用set方法，给set方法传入形参，通过形参给field赋值
         giveMethodValue(clazz, parameterMap, instance, iterator);
    
         // 赋值完成之后给其返回去
         return instance;
     }
    
     private static <T> void giveMethodValue(Class<T> clazz, Map<String, String[]> parameterMap, T instance, Iterator<String> iterator) throws NoSuchFieldException, NoSuchMethodException, IllegalAccessException, InvocationTargetException {
         while (iterator.hasNext()) {
             String fieldName = iterator.next();
             // 拼接set方法名
             // username → setUsername
             // password → setPassword
             // fieldName 首字母大写
             char[] chars = fieldName.toCharArray();
             chars[0] -= 32;
             String upperFirst = new String(chars);
             String setMethodName = "set" + upperFirst;
    
             // 获得形参的类型 → 成员变量的类型
             Field field = clazz.getDeclaredField(fieldName);
             Class<?> type = field.getType();
           	 // set方法
             Method method = clazz.getDeclaredMethod(setMethodName, type);
    
             String[] value = parameterMap.get(fieldName);
    
             if (field.getType().isArray()) {
                 method.invoke(instance, (Object) value);
             } else {
                 //method.invoke(instance, value);
                 method.invoke(instance, value[0]);
             }
         }
     }
    
     private static <T> void giveFieldValue(Class<T> clazz, Map<String, String[]> parameterMap, T instance, Iterator<String> iterator) throws NoSuchFieldException, IllegalAccessException {
         while (iterator.hasNext()) {
             // 请求参数名 → 成员变量名
             String fieldName = iterator.next();
             Field field = clazz.getDeclaredField(fieldName);
             field.setAccessible(true);
             // 判断field对应的成员变量的类型是否是数组，
             // 如果是数组，给其的值是value
             // 如果不是数组，给其的值是value[0]
             String[] value = parameterMap.get(fieldName);
             if (field.getType().isArray()) {
                 field.set(instance, value);
             } else {
                 field.set(instance, value[0]);
             }
         }
     }
    }
    ```

- 使用工具`BeanUtils` （本质是上面反射的代码）

  - 引入依赖`commons-beanutils`

  - 直接使用其提供的`copyProperties`方法
  
  - ```java
    BeanUtils.copyProperties(instance, parameterMap);
    ```

通常在需要封装很多参数的请求时，我们构造的请求参数是`json`。



#### `Json`封装  `Json`相关

 🚀`json` 是有结构的字符串，我们可以按照特定格式来解析，只不过`Servlet`没有提供这种方法，需要自己写。

请求参数携带`json`时有一定要求：

1. 请求头中的`Context -Type` : `application/json` 或 `application/json;charset=utf-8`
2. 请求体中的内容是一个`json`字符串
3. 请求方法是`POST`

>  `VUE`的时候`axios`可以构造`json`请求，但是比较麻烦。

##### 处理步骤

###### 首先，使用`req.getReader().readLine()`得到一个字符串作为`json`字符串。

###### 然后，处理`JSON`字符串：将接收到的`json`字符串转换成`java`中的对象

使用工具：借助工具将`Json`字符串转换为`Java`对象或者将`Java`对象转换为`Json`字符串。

1. `Jackson` 导入依赖：`pom.xml`文件中导入` Jackson - databind(core.annotation)`

   ```xml
   <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.13.5</version>
   </dependency>
   <!--mvnrepository.com-->
   <dependency>
      <groupId>commons-beanutils</groupId>
      <artifactId>commons-beanutils</artifactId>
      <version>1.9.4</version>
   </dependency>
   ```

2. 创建`ObjectMapper`对象

   ```java
   ObjectMapper objectMapper = new ObjectMapper();
   ```

   

3. 调用`ObjectMapper`的相关方法

   1. 将字符串转换为`java`对象

      > ```java
      > T t = objectMapper.readValue(String, Class<T>);
      > ```

   2. `java`对象转换为字符串

      > ```JAVA
      > String s = objectMapper.writeValueAsString(Object);
      > ```



### `Post`请求参数乱码

**乱码问题的原因：编解码集不一致**

构造一个`form`表单，一个`Get`请求，一个是`Post`请求，分别去获得请求参数，查看通过`Get`和`Post`请求获得的请求参数。

```html
<h1>GET请求</h1>
<form action="/demo8/parameter" method="get">
    <input name="username"><input type="submit">
</form>
<h1>POST请求</h1>
<form action="/demo8/parameter" method="post">
    <input name="username"><input type="submit">
</form>
```

```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    String username = request.getParameter("username");
    System.out.println("username = " + username);
}
```

在获取请求参数之前，设置一下编码

```JAVA
req.setCharacterEncoding("utf-8");
```

### 文件上传 `getPart`相关

在实际的开发过程中，有些场景需要做文件上传，比如**上传头像**，**上传商品的描述图片**等。

>  我们首先来看文件上传的请求的**`form`表单如何构造**
>
>  然后来看其对应的**请求报文是什么样子**的，然后我们在做进一步的分析

创建了一个form表单如下

```html
<form action="/demo9/upload" enctype="multipart/form-data" method="post">
    用户：<input type="text" name="username"><br>
    头像：<input type="file" name="avatar"><br>
    <input type="submit" name="提交">
</form>
```

显示效果如下

![image-20230310101121087](.\assets\image-20230310101121087.png)

然后构造请求数据

![image-20230310101252663](.\assets\image-20230310101252663.png)

接下来发送请求，并且通过fiddler来抓取请求报文

```http
POST http://localhost:8080/demo9/upload HTTP/1.1
Host: localhost:8080
Connection: keep-alive
Content-Length: 1148487
Cache-Control: max-age=0
sec-ch-ua: "Chromium";v="110", "Not A(Brand";v="24", "Microsoft Edge";v="110"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
Upgrade-Insecure-Requests: 1
Origin: http://localhost:8080
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary1pgACDbBGFGBPZYi
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.63
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Sec-Fetch-Site: same-origin
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Referer: http://localhost:8080/demo15/upload.html
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
Cookie: Idea-dcbc35b9=2a0b80c2-0c01-4b8f-846d-d0915e770aa6

------WebKitFormBoundary1pgACDbBGFGBPZYi
Content-Disposition: form-data; name="username"

wangdao
------WebKitFormBoundary1pgACDbBGFGBPZYi
Content-Disposition: form-data; name="avatar"; filename="logo.png"
Content-Type: image/png

 PNG

   
IHDR             v    	pHYs  .#  .#x ?v  _iCCPPhotoshop ICC profile  xڭ ?( q   ?]  n0 ʟ 3  (ud  L   z _  7)  A   20$ 后面省略了很多很多内容
```

我们来分析一下上面的请求报文，首先能够进入眼帘的是，响应报文中出现了一堆未知的字符

这些内容其实包含了图片的字节数据

![image-20230310105852598](.\assets\image-20230310105852598.png)

另外在请求信息之间出现了这样的一块内容,出现了两次

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**------WebKitFormBoundary1pgACDbBGFGBPZYi**</span>

这块内容其实就是**分隔符**，用来分割普通的请求数据和文件的请求数据的，在上面的请求头`Content-Type`的值中也可以看到。如果我们拿到请求体中的内容，通过分隔符，也就可以拿到图片的字节数据，拿到字节数据的话就可以通过`OutputStream` 做写出了。

但是呢，这个过程如果我们自己来完成的话，非常的复杂。在`Servlet3.0`之前，我们可以借助第三方工具来封装，比如`commons-fileupload`（[FileUpload – Using FileUpload (apache.org)](https://commons.apache.org/proper/commons-fileupload/using.html)），但是这个过程仍然是非常繁琐。

#### 🚀 `@MultipartConfig`和`getPart`

`Servlet3.0 `提供了对文件上传的支持，通过`@MultipartConfig`标注和`HttpServletRequest`提供的方法可以**完成文件部分的获取**，我们当前可以使用`Request` 中的**`getPart`**方法直接拿到其图片部分

```java
Part getPart(String var1) throws IOException, ServletException;
```

该方法的参数需要传入一个字符串值，该值是请求参数名，如果拿的是上面请求中图片文件的信息，则需要传入 **`avatar`**

```html
<!--intput标签中的name属性值其实就是请求参数名，分隔符中name对应的值也是这个-->
头像：<input type="file" name="avatar"><br>
```

**获得`Part对象`，通过Part中提供的方法可以获得其他具体的信息**

| 方法                     | 返回值        | 说明                                         |
| ------------------------ | ------------- | -------------------------------------------- |
| `getInputStream()`  ⚡    | `InputStream` | 获得字节输入流，可以读取字节数据将其保存下来 |
| `getContentType()`       | `String`      | 获得正文类型，比如png图片，其值为image/png   |
| `getSize()`              | `long`        | 获得文件字节大小                             |
| `getName()`              | `String`      | 获得请求参数名（这里就是`avatar`）           |
| `getSubmittedFileName()` | `String`      | 获得上传的原始文件名（这里是logo.png）       |

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Part avatar = req.getPart("avatar");
    InputStream inputStream = avatar.getInputStream();
    String contentType = avatar.getContentType();
    long size = avatar.getSize();
    String name = avatar.getName();
    String submittedFileName = avatar.getSubmittedFileName();
}
```

如果要将图片以原始文件名保存在web资源根目录，我们可以写这样的代码

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Part avatar = req.getPart("avatar");
    InputStream inputStream = avatar.getInputStream();
    String submittedFileName = avatar.getSubmittedFileName();

    byte[] bytes = new byte[1024];
    int length = 0;
    FileOutputStream outputStream = new FileOutputStream(new File(getServletContext().getRealPath(submittedFileName)));
    while ((length = inputStream.read(bytes)) != -1) {
        outputStream.write(bytes, 0, length);
    }
    inputStream.close();
}
```

### 思维导图复习

![Day03-Request](.\assets\Day03-Request.jpg)

## `Request`做请求转发（了解）

实际开发过程中，基本不会再涉及到，当前基本上不再使用JSP技术，JSP技术使用过程中会做**请求转发**。

`JSP:JavaServer Pages`,用来提供一个前端相关的内容。用起来和`html`类似，不过在里面可以写`JAVA`代码。`html`是一种静态资源。而`JSP`是一种特殊的`Servlet`，在编译时先成为`java`文件后成为字节码文件。之前使用该技术开发**单体应用**（前后端写在一起）。

但是jsp目前已经没有什么使用场景了。目前架构主要是前后端分离。所以关于转发了解即可。

![image-20221103150745249](.\assets\image-20221103150745249.png)

如果是jsp的话，jsp其实也是一个servlet

![image-20221103150836330](.\assets\image-20221103150836330.png)



可以通过IDEA中的Tomcat的**CATALINA_BASE**看一下其生成的`jsp `相关的java文件

![image-20221103152321797](.\assets\image-20221103152321797.png)

请求转发，其实就是在一个`Servlet`处理业务，处理完业务，继续由另外一个`Servlet`处理业务。

其中一个关注点，转发的两个请求之间的数据共享

**Request域**，转发的请求之间数据共享

- `request.setAttribute`
- `request.getAttribute`

# Response

响应报文的封装，设置响应报文

```http
HTTP/1.1 

Vary: accept-encoding,origin,access-control-request-headers,access-control-request-method,accept-encoding
Set-Cookie: rememberMe=deleteMe; Path=/; Max-Age=0; Expires=Sun, 12-Feb-2023 06:51:56 GMT
Set-Cookie: JSESSIONID=24287278-5ebb-407d-a3f7-56b74782c4c7; Path=/; HttpOnly
Access-Control-Allow-Origin: *
Content-Type: application/json;charset=UTF-8
Date: Mon, 13 Feb 2023 06:51:56 GMT
Content-Length: 200

{"errno":0,"data":{"adminInfo":{"nickName":"admin123","avatar":"https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif"},"token":"24287278-5ebb-407d-a3f7-56b74782c4c7"},"errmsg":"成功"}
```

响应报文的组成

- 响应行
- 响应头
- (空行)
- 响应体（正文）

## 响应行

协议就不设置了，设置一下响应状态码

| 方法名           | 参数           | 说明           |
| ---------------- | -------------- | -------------- |
| `setStatus(int)` | 参数就是状态码 | 设置响应状态码 |

```java
@WebServlet("/line")
public class LineServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {
        response.setStatus(302);
    }
}
```

发送请求后接收到的响应报文

```http
HTTP/1.1 302
Content-Length: 0
Date: Wed, 15 Feb 2023 03:20:18 GMT
Keep-Alive: timeout=20
Connection: keep-alive

```



## 响应头

响应头是键值对的信息。

响应头也是 `key：value` 的格式，提供了通用的方法，可以设置响应头的`key` 和 `value`；也提供了一些特定的方法，特定的方法做的事情，就是设置特定响应头的值

| 方法                       | 参数                             | 说明       |
| -------------------------- | -------------------------------- | ---------- |
| `setHeader(String,String)` | 参数1提供`key`，参数2提供`value` | 通用的方法 |

特殊的响应头

`ContentType`:设置方法`setContentType(String)`，相当于`setHeader(contentType,String)`

解决乱码问题

`response.setContentType("application/json;charset=utf-8")`

```java
@WebServlet("/header")
public class HeaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {
        // 第一个参数是key，第二个参数是value
        response.setHeader("custom-header","abcdef");
    }
}
```

```http
HTTP/1.1 200
custom-header: abcdef
Content-Length: 0
Date: Wed, 15 Feb 2023 03:28:04 GMT
Keep-Alive: timeout=20
Connection: keep-alive
```

`Mime -Type` :先写大类型再写小类型

举例：image/jpeg,application/json,application/xml,txt/css...

## 响应体

字符流和字节流。

响应体里大部分都是字符串，可以用`JSON`。

响应体（正文）

可以使用字符流，也可以使用字节流。

| 方法                | 返回值                | 描述   |
| ------------------- | --------------------- | ------ |
| `getWriter()`       | `PrintWriter`         | 字符流 |
| `getOutputStream()` | `ServletOutputStream` | 字节流 |

```Java
// 响应json
response.getWriter().println();
```

字符流

```java
@WebServlet("/body1")
public class BodyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //resp.getWriter().println("hello world");
        //resp.getWriter().append("hello world");
        resp.getWriter().write("hello world");
    }
}
```

字节流

```java
@WebServlet("/body2")
public class BodyServlet2 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletOutputStream outputStream = resp.getOutputStream();
        InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("dlrb.jpg");
        byte[] bytes = new byte[1024];
        int length = 0;
        while ((length = inputStream.read(bytes)) != -1) {
            outputStream.write(bytes,0,length);
        }
        inputStream.close();
    }
}
```

**场景：**

> **字符流**：响应文本数据，最主要的场景就是前后端分离之后，通过字符流响应Json数据
>
> **字节流**：响应图片、文件，也通常在文件下载的场景下使用

## 特殊响应头

特殊的几个响应头

> 1. `refresh` → 定时刷新、跳转
> 2. `content-type` → 限定响应的正文（也可以解决中文乱码问题） ⚡
> 3. `content-disposition` → 文件下载
> 4. `location` → 重定向
>

### `refresh`

```java
private void refreshAndForward(HttpServletResponse resp) {
    resp.setHeader("refresh","3;url=/demo12/hello");
}

private void refreshPerSecond(HttpServletResponse resp) throws IOException {
  // 数字单位是秒，表示隔一秒刷新 
  resp.setHeader("refresh","1");
    Date date = new Date();
    String dateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    resp.getWriter().write(dateStr);
}
```

### `Content-Type`

通常不需要设置。

比如我们响应Json数据给前端，我们可以设置Content-Type：application/json

我们要在这里做字符集的设置，如果没有做有可能出现中文乱码。

比如我们响应Json，想要设置字符集为utf-8

`Content-Type:application/json;charset=utf-8`

```java
@WebServlet("/contenttype")
public class ContentTypeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 这里不是json而是普通字符，就设置了text/html了
        resp.setHeader("content-type","text/html;charset=utf-8");
        resp.getWriter().write("你好");
    }
}
```

也可以直接使用Response来调用其`setContentType`方法

### `content-disposition`

下载的场景会使用

`content-disposition: attachment;filename=1.jpg`

以1.jpg来下载正文

```java
@WebServlet("/disposition")
public class ContentDispositionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("content-disposition","attachment;filename=1.jpg");
        ServletOutputStream outputStream = resp.getOutputStream();
        InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("dlrb.jpg");
        byte[] bytes = new byte[1024];
        int length = 0;
        while ((length = inputStream.read(bytes)) != -1) {
            outputStream.write(bytes,0,length);
        }
        inputStream.close();
        outputStream.close();
    }
}
```

### `location`

重定向

```java
@WebServlet("/location")
public class LocationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("访问到LocationServlet");
        resp.setStatus(302);
        resp.setHeader("location","http://localhost:8080/demo12/hello");
    }
}
```

注意事项

1. 关闭流，如果是通过request和response获得流，不手动关闭也可以。如果是自己创建的流，需要关闭。
2. 不能既获得字节流又获得字符流，因为字节流和字符流共享同一个标记位。

# 案例

## 请求分发案例

分发：dispatch

> 场景：有多个请求
>
> Http://localhost:8080/user/login → 登录
>
> http://localhost:8080/user/create → 注册
>
> http://localhost:8080/user/info → 查看用户信息

按照我们之前的写法，我们需要写3个Servlet，如果不想写3个Servlet，只写一个UserServlet可以不？

Servlet的url-pattern的合法写法 `/xxx/*`,我们在这个UserServlet上可否写一个`/user/*`

```java
@WebServlet("/user/*")
public class UserServlet extends HttpServlet{
    
}
```

获得请求的URI，根据URI的user后面的值的不同做不同的处理。

（也可以基于反射优化方法的调用。截取得到后缀名和调用的方法名一致，通过方法名获得反射方法然后invoke）

```java
@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestURI = req.getRequestURI();
        // 截取URI字符串，举例 /demo13/user/login
        int index = requestURI.lastIndexOf("/");
        String operation = requestURI.substring(index + 1, requestURI.length());

        resp.setHeader("content-type","text/html;charset=utf-8");
        // 请求URI的最后一级
        if ("login".equals(operation)) {
            method1(req,resp);
        } else if ("create".equals(operation)) {
            method2(req,resp);
        } else if ("info".equals(operation)) {
            method3(req,resp);
        }
        //resp.getWriter().write(requestURI);
    }

    private void method1(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.getWriter().write("访问登录");
    }
    private void method2(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.getWriter().write("访问注册");
    }
    private void method3(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.getWriter().write("访问查看信息");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
```



## 登录案例

请求：先访问登录请求，登录如果成功，那么接着 先提示登录成功，**然后过两秒访问到info请求**

这个请求由登录页面提供，我们可以通过html提供一个登录表单，该表单会发出请求

http://localhost:8080/user/login    → Servlet → 检查用户名和密码是否正确（使用一下MyBatis） → 

- 如果正确，那么就提示登录成功
- 如果错误，那么刷新登录页面

> 任务拆解：
>
> 1. 包含登录表单的 login.html文件，放在webapp目录下
> 2. 开发UserServlet
>    1. /user/login对应的处理方法，使用MyBatis做查询
>    2. /user/info对应的处理方法
> 3. 整合MyBatis，在应用程序中维护SqlSessionFactory实例



```java
/**
 * Servlet如果它的loadOnStartup为正数，则应用程序启动的时候初始化；
 * 如果为负数，则访问其URL-Pattern时才初始化
 * 想让其应用程序启动的时候就初始化 → 提供一个SqlSessionFactory的实例，然后共享该实例
 * @author stone
 * @date 2023/02/16 16:16
 */
@WebServlet(value = "/mybatis/init",loadOnStartup = 1)
public class MyBatisInitializationServlet extends HttpServlet {
    @SneakyThrows
    @Override
    public void init() throws ServletException {
        ServletContext servletContext = getServletContext();
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("mybatis.xml"));
        servletContext.setAttribute("sqlSessionFactory",sqlSessionFactory);
    }
}
```

```java
@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    SqlSessionFactory sqlSessionFactory;
    @Override
    public void init() throws ServletException {
        sqlSessionFactory = (SqlSessionFactory) getServletContext().getAttribute("sqlSessionFactory");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String operation = URIUtil.fetchOperation(req);
        switch (operation) {
            case "login":
                login(req, resp);
                break;
            case "info":
                info(req, resp);
                break;
            default:
                resp.setHeader("content-type","text/html;charset=utf-8");
                resp.getWriter().write("请求有误，请联系管理员");
        }

    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws UnsupportedEncodingException {
        // 判断用户名和密码是否符合要求
        //Object sqlSessionFactory = getServletContext().getAttribute("sqlSessionFactory");
        SqlSession sqlSession = sqlSessionFactory.openSession(true);
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        req.setCharacterEncoding("utf-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        CskaoyanUser cskaoyanUser = userMapper.selectByUsernameAndPassword(username, password);
        if (cskaoyanUser == null) {
            resp.setStatus(302);
            resp.setHeader("location","/demo14/login.html");
        }else {
            //先把user信息暂存一下
            getServletContext().setAttribute("user",cskaoyanUser);
            resp.setHeader("refresh","2;/demo14/user/info");
        }
    }
    private void info(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        CskaoyanUser user = (CskaoyanUser) getServletContext().getAttribute("user");
        System.out.println("user = " + user);
        resp.setHeader("content-type","text/html;charset= utf-8");
        resp.getWriter().write("欢迎你，" + user.getUsername());
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
```

## （项目）会员管理

SQL语句，`order by`不进行预编译，不能使用`#{}`，要使用`${}`。

`Vo`: view object 能看到的页面叫做视图，Vo即填充视图的对象



查询会员信息

```http
GET http://101.43.69.31:8083/admin/user/list?page=1&limit=20&sort=add_time&order=desc HTTP/1.1
Host: 101.43.69.31:8083
Connection: keep-alive
Accept: application/json, text/plain, */*
X-CskaoyanMarket-Admin-Token: 85b7dffc-f6c6-4cf6-bc20-3c280f28f1bf
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.62
Origin: http://101.43.69.31:8080
Referer: http://101.43.69.31:8080/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
```

> 1. 请求URL是什么？
>
> http://101.43.69.31:8083/admin/user/list
>
> uri的部分 /admin/user/list 
>
>  a.  配置tomcat的话，要考虑虚拟映射的path  → /
>
>  b. 开发的Servlet的url-pattern，`@WebServlet`的`value`属性值 →` /admin/user/*`
>
>  c. 最后一级是list，如果集成`BaseServlet`的话，需要`UserServlet`中有一个名称为list的方法

![image-20230829150425075](.\assets\image-20230829150425075.png)

```java
@WebServlet("/admin/user/*")
public class UserServlet extends BaseServlet {

    public void list(HttpServletRequest request, HttpServletResponse response) {
        
    }
}
```

> 2. 请求参数
>
>    a. ` request.getParameter`相关的方法
>
>    ​	(1). 在queryString里面出现了key=value形式的请求参数
>
>    ​    (2). 请求体里出现key=value
>
>    b.  `request.getReader().readLine()  `返回字符串信息
>
>    ​    (1).请求体里出现字符串 → 使用使用这个方法获得的是Json
>
>    c.  `request.getPart() `获得Part对象
>
>    ​    (1).`multipart/form-data`请求，通常会携带文件(字节数据) → `Part`中的`getInputStream`做处理
>
> 当前这个场景，我们的请求参数属于上面的哪种请求？  a1

```java
@WebServlet("/admin/user/*")
public class UserServlet extends BaseServlet {

    //queryString的值 page=1&limit=20&sort=add_time&order=desc
    @SneakyThrows
    public void list(HttpServletRequest request, HttpServletResponse response) {
        //Integer page = Integer.valueOf(request.getParameter("page"));
        //Integer limit = Integer.valueOf(request.getParameter("limit"));
        //String sort = request.getParameter("sort");
        //String order = request.getParameter("order");
        BaseParam baseParam = new BaseParam();
        BeanUtils.copyProperties(baseParam,request.getParameterMap());
    }
}
```

> 3. 在这里已经接收到请求参数，我们需要完成的业务？
>
> 增删改查中的哪一个或哪一些？
>
> 这里应该做查询 → 根据add_time做降序查询user表中的page和limit对应的user信息
>
> -- limit 第一个值  (page -1) * limit
> -- limit 第二个值  limit
> SELECT * FROM `market_user` order by add_time desc limit 0,20

整合MyBatis完成上面的业务

```java
@WebServlet("/admin/user/*")
public class UserServlet extends BaseServlet {

    SqlSessionFactory sqlSessionFactory = null;

    @Override
    public void init() throws ServletException {
        sqlSessionFactory = (SqlSessionFactory) getServletContext().getAttribute("sqlSessionFactory");
    }

    //queryString的值 page=1&limit=20&sort=add_time&order=desc
    @SneakyThrows
    public void list(HttpServletRequest request, HttpServletResponse response) {
        //Integer page = Integer.valueOf(request.getParameter("page"));
        //Integer limit = Integer.valueOf(request.getParameter("limit"));
        //String sort = request.getParameter("sort");
        //String order = request.getParameter("order");
        BaseParam baseParam = new BaseParam();
        BeanUtils.copyProperties(baseParam,request.getParameterMap());

        UserMapper mapper = sqlSessionFactory.openSession(true).getMapper(UserMapper.class);
        baseParam.initOffset();
        List<MarketUser> userList = mapper.selectUserList(baseParam);
    }
}
```

> 4. 返回值什么样子？
>
>    我们刚刚只复制了请求报文，并不知道响应报文的响应体需要我们提供什么样的数据
>
>    应该找到响应报文，找到其中的响应体
>
>    ```http
>    HTTP/1.1 200
>    Vary: accept-encoding,origin,access-control-request-headers,access-control-request-method,accept-encoding
>    Access-Control-Allow-Origin: *
>    Content-Type: application/json;charset=UTF-8
>    Date: Tue, 29 Aug 2023 06:58:59 GMT
>    Content-Length: 9805
>                                  
>    {"errno":0,"data":{"total":79,"pages":4,"limit":20,"page":1,"list":[{"id":80,"username":"user456","password":"$2a$10$KairBY9XjiT0IqTj10Fz3uUumKqlbSX0oVVhTpfhkis1eJV9VSjm2","gender":0,"lastLoginTime":"2023-08-14 21:09:29","lastLoginIp":"171.113.245.233","userLevel":0,"nickname":"user456","mobile":"15310888954","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-14 21:09:29","updateTime":"2023-08-29 11:42:24","deleted":false},{"id":79,"username":"wangshuai","password":"$2a$10$wpa0FmHqaE6aNWrGDtmh.O3/NiNhR3pxig38/WWDeuiQJbZL8teyy","gender":0,"lastLoginTime":"2023-08-13 21:43:30","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"wangshuai","mobile":"18839219012","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-13 21:43:30","updateTime":"2023-08-13 21:43:30","deleted":false},{"id":78,"username":"dsfnjdnc","password":"$2a$10$z1DC5UXeljtOECGST5Ht5un2UXYdHUY.zUoFVEuoU0Foqmg9KiET6","gender":0,"lastLoginTime":"2023-08-12 09:59:36","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"dsfnjdnc","mobile":"17889948070","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-12 09:59:36","updateTime":"2023-08-12 09:59:36","deleted":false},{"id":77,"username":"lipanl","password":"$2a$10$2e3ZiDI6yU/d9jDGh3ow2ubtBxAyVTaNUr5NrA2rw2coo/thKhkJO","gender":0,"lastLoginTime":"2023-08-12 09:26:55","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"lipanl","mobile":"15605215755","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-12 09:13:41","updateTime":"2023-08-12 09:26:55","deleted":false},{"id":76,"username":"abc123","password":"$2a$10$zJXzS2hqfwrwH9qBpEWf6reIaBOoBRsDON4aSAyVTaX3f.a7PXl18G","gender":1,"lastLoginTime":"2023-08-12 09:05:24","lastLoginIp":"171.43.248.95","userLevel":1,"nickname":"abc1232","mobile":"189649576691","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":1,"addTime":"2023-08-12 09:03:46","updateTime":"2023-08-19 20:41:06","deleted":false},{"id":75,"username":"userhhh","password":"$2a$10$EuMQSEIACrpFiXKX9D8CC./1tjqZZA7gcz7ruKc2D58n0gblIw2yq","gender":0,"lastLoginTime":"2023-08-12 08:52:56","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"userhhh","mobile":"18338708454","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-12 08:52:56","updateTime":"2023-08-12 08:52:56","deleted":false},{"id":74,"username":"11tong","password":"$2a$10$xiufPksECD4y7WudNGleae6MDNabNUSDiEH4xz63V94PANvVCvjsG","gender":0,"lastLoginTime":"2023-08-11 23:41:56","lastLoginIp":"37.128.243.180","userLevel":0,"nickname":"11tong","mobile":"18193408088","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 23:04:45","updateTime":"2023-08-11 23:41:56","deleted":false},{"id":73,"username":"6666666","password":"$2a$10$4DGAP3HtGGf9fiJAR5FsUe580LglFuc8AlkwbQRhiofVz.2cfu1hu","gender":0,"lastLoginTime":"2023-08-11 22:28:46","lastLoginIp":"171.113.246.131","userLevel":0,"nickname":"6666666","mobile":"19149355","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 22:28:46","updateTime":"2023-08-11 22:53:53","deleted":false},{"id":72,"username":"shibowen","password":"$2a$10$xDgPrbO8hR1XhQf4bXxrP.Ly/vwWjXGtDtnShDUWB2DsTodOV/HWe","gender":0,"lastLoginTime":"2023-08-11 22:20:15","lastLoginIp":"171.113.246.131","userLevel":0,"nickname":"shibowen","mobile":"15364314469","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 22:20:15","updateTime":"2023-08-11 22:21:27","deleted":false},{"id":71,"username":"cpj123","password":"$2a$10$1ilmyiwiIIE3mIW9HZPYfenJRaEWDUZzj7u0sYYL1fLcTW58tf5Vi","gender":0,"lastLoginTime":"2023-08-12 10:59:52","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"cpj123","mobile":"15213480588","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 16:54:45","updateTime":"2023-08-12 10:59:52","deleted":false},{"id":70,"username":"qianqian","password":"$2a$10$9lZkUEdw1GVcBwk03L47JOetj8SRZDOun74fQ25gSJCXbuDUpXT6q","gender":0,"lastLoginTime":"2023-08-11 15:55:18","lastLoginIp":"38.181.73.70","userLevel":0,"nickname":"qianqian","mobile":"17302213266","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 15:55:18","updateTime":"2023-08-11 17:09:03","deleted":false},{"id":69,"username":"13428689333","password":"$2a$10$Fl3B9m6dRAJ42.ZJw5Vbsucgd8a7WE7YEJbGq2NMrrDejqfeM6vVC","gender":0,"lastLoginTime":"2023-08-11 14:39:58","lastLoginIp":"171.113.246.131","userLevel":0,"nickname":"13428689333","mobile":"13428689333","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 14:39:58","updateTime":"2023-08-11 14:41:19","deleted":false},{"id":68,"username":"141d54","password":"$2a$10$39XcI1ZFVlZ./Q4/hk9U2.t/2XvwfWZWlqhuhxtAzPCpICO7DS9Ku","gender":0,"lastLoginTime":"2023-08-11 12:52:49","lastLoginIp":"171.113.246.131","userLevel":0,"nickname":"141d54","mobile":"18571475083","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 12:52:49","updateTime":"2023-08-11 12:52:49","deleted":false},{"id":67,"username":"haodene","password":"$2a$10$3wUuWJgmJrswpf7vMjyNKu2QaS7OcIWMoJIoZqeA.j2QxZX0hc3Gq","gender":0,"lastLoginTime":"2023-08-11 12:38:06","lastLoginIp":"210.3.159.237","userLevel":0,"nickname":"haodene","mobile":"17332885067","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 12:38:06","updateTime":"2023-08-11 12:38:54","deleted":false},{"id":66,"username":"xn1111","password":"$2a$10$6NYttr6pchyPDRN776peiuMqI.P.tk2Nexu/ExPF2zLrpdsw91.UW","gender":0,"lastLoginTime":"2023-08-12 13:01:41","lastLoginIp":"171.43.247.130","userLevel":0,"nickname":"xn1111","mobile":"15543400379","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 12:17:09","updateTime":"2023-08-12 13:01:41","deleted":false},{"id":65,"username":"999999","password":"$2a$10$IVMS2c3U94iwOiu9gRpM...zuO9AEmjvz3q7hqIqtcog..nKp4d06","gender":0,"lastLoginTime":"2023-08-11 12:01:34","lastLoginIp":"171.113.246.131","userLevel":0,"nickname":"999999","mobile":"17863013913","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 12:01:34","updateTime":"2023-08-11 17:54:15","deleted":false},{"id":64,"username":"uer123","password":"$2a$10$8iSnFilcnMLl0SxgCnnniuxsTCwSJB/toW9QTK3L7Z6/NMggZpzFS","gender":0,"lastLoginTime":"2023-08-11 11:44:41","lastLoginIp":"38.181.73.70","userLevel":0,"nickname":"uer123","mobile":"17353291393","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-11 11:44:41","updateTime":"2023-08-11 11:44:41","deleted":false},{"id":63,"username":"aaaaaa","password":"$2a$10$xz7HJbKtqb0r4eFTXZHZrufncjSL8TLypxrQf1RtY30O6J4NFDF.O","gender":0,"lastLoginTime":"2023-08-11 10:37:50","lastLoginIp":"210.3.159.237","userLevel":1,"nickname":"aaaaaa","mobile":"17332855555","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":2,"addTime":"2023-08-11 10:37:50","updateTime":"2023-08-11 11:38:32","deleted":false},{"id":62,"username":"czc123","password":"$2a$10$CDVT5W1oGx7VpmVbR/y3jeSuul3cK2fKHYgXO0RSoJEOIwLRl6NKy","gender":0,"lastLoginTime":"2023-08-12 09:04:19","lastLoginIp":"171.43.248.189","userLevel":0,"nickname":"czc123","mobile":"15374579055","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-10 21:36:07","updateTime":"2023-08-12 09:04:19","deleted":false},{"id":61,"username":"wangao4","password":"$2a$10$SNfWiy4zIB9EZx39y5aaHuWgI32gC7.6V67l1OlreBPpWQHim0exe","gender":0,"lastLoginTime":"2023-08-10 19:59:31","lastLoginIp":"171.113.241.66","userLevel":0,"nickname":"wangao4","mobile":"13593956279","avatar":"https://yanxuan.nosdn.127.net/80841d741d7fa3073e0ae27bf487339f.jpg?imageView&quality=90&thumbnail=64x64","weixinOpenid":"","sessionKey":"","status":0,"addTime":"2023-08-10 19:59:31","updateTime":"2023-08-10 19:59:31","deleted":false}]},"errmsg":"成功"}
>    ```
>
>    在浏览器中看到的json
>
>    ![image-20230829160911344](.\assets\image-20230829160911344.png)
>
>    ```java
>     @Data
>    public class UserListVo{
>     Object data; // 跟着{ 可以Object或Map
>     String errmsg;// 跟着 "
>     int errno; // 跟着数据
>              // 如果跟着[ 就是数组或List等集合类型
>    }
>    ```
> 
>    ![image-20230829161523950](.\assets\image-20230829161523950.png)
>
>    ```java
>     @Data
>    public class ListVo {
>       Integer limit;
>        List list;
>        Integer page;
>        Integer total;
>        Integer pages;
>    }
>                            
>    ```
> 
>  ![image-20230829161617787](.\assets\image-20230829161617787.png)
> 
>    ```java
>@Data
> public class ListVo {
>    Integer limit;
>     List<MarketUser> list;
>    Integer page;
>     Integer total;
>     Integer pages;
> }
>    ```
> 
> 介绍一个工具 GsonFormat（或GsonFormatPlus） 安装之后，在类中使用alt+s快捷键
> 
> ```java
> @NoArgsConstructor
> @Data
>public class GsonFormatVo {
>     private Integer errno;
>    private DataDTO data;
>     private String errmsg;
> 
>     @NoArgsConstructor
>     @Data
>     public static class DataDTO {
>         private Integer total;
>         private Integer pages;
>         private Integer limit;
>         private Integer page;
>         private List<MarketUser> list;
>     }
> 
>     // alt + s
> 
> }
> ```
> 

> 5. 响应对应的`JSON`数据
>
>    令`Servlet`中的方法返回值为`Object`，`BaseServlet`就会将这个`Object`转换为Json字符串，然后使用字符输出流写出
>
>    ```java
>    @SneakyThrows
>    public UserListVo list(HttpServletRequest request, HttpServletResponse response) {
>      //Integer page = Integer.valueOf(request.getParameter("page"));
>      //Integer limit = Integer.valueOf(request.getParameter("limit"));
>      //String sort = request.getParameter("sort");
>      //String order = request.getParameter("order");
>      BaseParam baseParam = new BaseParam();
>      BeanUtils.copyProperties(baseParam,request.getParameterMap());
>                                  
>      UserMapper mapper = sqlSessionFactory.openSession(true).getMapper(UserMapper.class);
>      baseParam.initOffset();
>      List<MarketUser> userList = mapper.selectUserList(baseParam);
>                                  
>      UserListVo userListVo = new UserListVo();
>      userListVo.setErrno(0);
>      userListVo.setErrmsg("成功");
>      ListVo data = new ListVo();
>                                  
>      data.setList(userList);
>      data.setPage(baseParam.getPage());
>      data.setLimit(baseParam.getLimit());
>                                  
>      //data.setPages();
>      //data.setTotal();
>                                  
>      userListVo.setData(data);
>      return userListVo;
>    }
>    ```
>

### 任务小结

步骤：

1. 找Servlet
2. 处理请求参数
   1. 有哪些方式接收请求参数
      1. queryString相关的用`request.getParameter`
      2. json相关`request.getReader().readline()`
      3. `request.getPart(name)`

3. **在Servlet中根据参数完成对应的业务处理（增删改查）**⚡ 
4. 返回对应的json数据

### 练习题

[market](http://101.43.69.31:8080/#/mall/region)

http://101.43.69.31:8080

开发对应的请求 → 行政区域

- MyBatis的多表查询
- 查询出来使用Stream来做封装也可以



```xml
SELECT t1.id,
       t1.pid,
       t1.name,
       t1.type,
       t1.code,
       t2.id   AS city_id,
       t2.pid  AS leader_province_id,
       t2.name AS city_name,
       t2.type AS city_type,
       t2.code AS city_code,
       t3.id   AS region_id,
       t3.pid  AS leader_city_id,
       t3.name AS region_name,
       t3.type AS region_type,
       t3.code AS region_code
FROM market_region AS t1
        JOIN market_region AS t2 ON t1.id = t2.pid
        JOIN market_region AS t3 ON t3.pid = t2.id;
```


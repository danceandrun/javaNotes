[toc]

# 前言

## 学习目标

> 1. 理解`HTTP`协议和`HTTP`请求报文和响应报文
> 2. 掌握`Tomcat`的使用，以及`IDEA`中使用`Tomcat`应用的方式
> 3. 掌握`Web`应用的目录结构
>
>    - 标准目录结构（应用部署、编译）
>    - `Maven`开发的目录结构
>    - 使用`IDEA`来开发`Web`应用
> 4. 熟悉`Servlet`的执行流程和生命周期
>
>    - 掌握`service`方法
>    - 掌握`init`、`destroy`方法执行时机和次数
> 5. 熟悉`Servlet`使用和相关配置
> 6. 熟悉`ServletContext`的功能
> 7. 了解`XML`配置方式

## 前置知识准备

> - 面向对象编程（对象、类）
> - Tomcat 的应用程序和启动、`docBase`配置(虚拟映射)→ 要在IDEA中直接使用Tomcat
> - 开发工具：Postman 用来构造请求，提供一个请求报文

# 介绍

## JavaEE介绍

Java SE  Standard Edition

Java EE Enterprise Edition 企业开发 → 服务器开发

服务器：服务器硬件、服务器应用（软件）

`B/S` → `Browser`/`Server`

`C/S` →` Client`/`Server`

JSP

`Servlet`

JDBC

JavaSE（Java Platform, Standard Edition）是Java平台的标准版，它提供了Java语言的核心库和运行环境，用于开发和部署独立的Java应用程序。JavaSE包含了Java的基本功能和特性，如面向对象编程、异常处理、集合框架、多线程、输入输出等。它是Java开发的基础，所有其他的Java技术都是建立在JavaSE之上的。

JavaEE（Java Platform, Enterprise Edition）是Java平台的企业版，它是建立在JavaSE之上的一组扩展和标准，专注于开发和部署企业级的分布式应用程序。**Web服务器。**JavaEE提供了一系列的API和规范，用于实现企业级应用所需的各种功能，如Web应用开发、数据库访问、消息传递、事务处理、安全性等。JavaEE还包括一些服务器端的技术和组件，如Java Servlet、JavaServer Pages（JSP）、Enterprise JavaBeans（EJB）、Java Message Service（JMS）等。

JavaSE和JavaEE可以看作是Java平台的两个不同的版本，它们的关系是JavaEE是建立在JavaSE之上的扩展和增强。JavaSE提供了Java语言的基本功能和**库**，而JavaEE在此基础上提供了更多面向企业级应用的功能和**组件**，用于开发大型、复杂的分布式系统。因此，如果你只是开发简单的独立应用程序，使用JavaSE就足够了；**而如果你需要开发企业级的应用程序，特别是涉及到Web开发、事务处理等方面，那么JavaEE会更适合。**

服务器：服务器硬件、服务器应用（软件）

> B/S和C/S是指不同的客户端/服务器架构模型。
>
> B/S代表浏览器/服务器（Browser/Server），它是一种网络应用程序的架构模型。在B/S模型中，用户通过浏览器作为客户端向服务器发送请求，服务器处理请求并返回响应。这种模型常见于Web应用程序，其中浏览器负责展示用户界面，而服务器处理逻辑和数据处理。
>
> C/S代表客户端/服务器（Client/Server），这是另一种常见的架构模型。在C/S模型中，客户端和服务器之间有直接的通信，客户端发送请求给服务器，服务器处理请求并返回响应。这种模型通常用于桌面应用程序或本地网络环境中。

## `Servlet` 介绍

> - 浏览器如何找到我们需要的`Servlet`
> - 找`Servlet`它带来了什么
> - 回去的时候带走了什么

`Servlet` 是`Server Applet`  的缩写，运行在**JavaEE容器**（Tomcat）下的小程序。

> `Server Applet`和Tomcat的关系

`Servlet` 是一种JAVA编程语言的服务器端组件，主要用于扩展Web服务器功能。`Servlet` 运行在服务器上，**接收请求，生成响应。**它是Java企业版（Java Enterprise Edition，简称Java EE）的一部分，用于构建基于Web的应用程序。

`Servlet` 通过Java编写，遵循Servlet API规范。可以被**部署**到支持`Servlet` 规范的Web容器（Apache Tomcat 、Jetty等）中运行。通过Servlet，开发人员可以**处理HTTP请求**、**执行业务逻辑**、**访问数据库**、**生成动态内容**并**将响应发送回客户端**。

> 遵循Servlet API 规范该如何实现？
>
> 首先什么是规范？在编程语言中指的是，一个方法头的规定，什么样的名字，参数，返回值。
>
> 方法一：提供接口
>
> 方法二：实现抽象类中的抽象方法
>
> 为什么要遵循规范？
>
> 调用什么方法就做什么事。

通过Tomcat可以访问**静态资源**和**动态资源**，静态资源就是我们前端学的内容，比如HTML、JS、CSS、xml、字体文件、图片等内容，而**Servlet提供的是动态资源的访问**。

`Servlet`的开发规范：`Servlet`的开发其实就是`Servlet`中的`service`方法的开发。

我们接下来的需求：访问`http://localhost:8080/ee/user/login`,页面上出现 LOGIN SUCCESS

```java
import javax.servlet.GenericServlet;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/user/login")
public class UserServlet extends GenericServlet {
    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        servletResponse.getWriter().write("LOGIN SUCCESS");
    }
}
```

`@WebServlet("/user/login")` 注解里面的**相当于一个索引**

# IDEA中开发Web应用

## `pom.xml`

```xml
<packaging>war</packaging>

<dependencies>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>3.1.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

### 打包方式

设置打包方式是`war`

`<packaging = war/>`

默认打包方式是`jar`

这样做提供了`artifactid`

> `pom` 父工程，提供子工程通用的内容，只有一个`pom.xml`，没有代码和文件
>
> `war `:**web应用，要满足web应用的目录结构，要放在JavaEE容器下运行**
>
> `jar`: 默认的打包方式，如果想要运行jar，里面要包含main方法

### `scope` 作用域

默认的作用域是`compile`

`javax.servlet-api` 的作用域是**provided**，编译的时候需要，而打包、运行的时候都不需要

之所以不需要这个依赖是因为`Tomcat` 中已经有了这个依赖，在`Tomcat` 的`lib` 目录中有一个 `jar`  包 `servlet-api.jar`

![image-20230824170722846](.\assets\image-20230824170722846.png)

如果硬是要打包进去，有可能会发生冲突，导致未知的错误

## `Servlet` 开发

开发好的`Servlet` 和资源文件 编译后（`target/{artifactId}-{version}`目录） 放入到`Tomcat` 下的`webapp`目录里是可以访问的

![image-20230202164950511](.\assets\image-20230202164950511.png)

## `docBase `设置访问资源

![image-20230202165526995](.\assets\image-20230202165526995.png)

`demo2.xml`文件中的内容，指定`docBase`，其实访问的这个指定的这个路径下的资源

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context docBase="D:\WorkSpace\cskaoyan2023\02-备课\JavaEE\prepare_talk2\resources_new\codes\servlet2\demo1-first-servlet\target\demo1-first-servlet-1.0-SNAPSHOT"/>
```

## ⭐ `IDEA` 中使用`Tomcat`

`pom.xml`中`packaging`标签的值为`war`时会新增两个artifact

`war exploded`：指定编译的文件夹 → `target/{artifactId}-{version}`

`war` ：会打包成`war`包，将`war exploded`这个文件夹里的内容打包成`war`

在IDEA中如果要使用Tomcat的话，我们使用的`artifact` 是 `war exploded`

![image-20230202170140154](.\assets\image-20230202170140154.png)

![image-20230202170604997](.\assets\image-20230202170604997.png)

![image-20230202171744609](.\assets\image-20230202171744609.png)

JavaEE阶段都会在IDEA中使用Tomcat

SpringMVC阶段也会在IDEA中使用Tomcat

>使用IDEA来集成Tomcat
>
>1. 打包方式：`<packaging=war>`
>2. 增加`Tomcat server `
>3. 提供`deployment`的配置（`docBase`）
>4. `artifact `→ `war exploded``
>5.  ``application context `→ 路径

需要建立Tomcat和我们当前项目之间的联系。虚拟映射就是部署`artifact` 。

`target/{artifactid}-{version}`

虚拟映射 1. path 2. docBase

> #### 虚拟映射🚀🚀 
>
> 正常情况下来说，需要部署资源，是要在`webapps`目录下操作的。但是如果希望不在`webapps` 目录下，可不可以部署呢？可以。
>
> 不在`webapps` 目录这种方式叫做<font color=red>**虚拟映射**</font>。虚拟地映射到Tomcat的`webapps` 目录下。
>
> ##### `conf/Catalina/localhost`(掌握)⚡
>
> 新建一个`xml`文件，`xml`文件的名称（`user1.xml`）里面配置`Context`节点信息
>
> ```xml
> <?xml version="1.0" encoding="UTF-8"?>
> <Context docBase="D:\app1"/>
> ```
>
> 比如，我们现在新建了一个`xml`文件，名字叫做`user1.xml`
>
> `http://localhost:8080/{xml的名称}` →  其实相当于找到 `{docBase}`路径
>
> 我想访问这个`{docBase}`路径下：` 222/1.png`的图片，现在需要怎么写？
>
> http://localhost:8080/user1/222/1.png
>
> ##### `conf/server.xml`(了解)
>
> 需要在`Host节点`下配置`Context`节点
>
> 现在我们需要找 `D:/app2`。这时候怎么写 ？
>
> ```xml
> <Context path="/app452" docBase="D:\app2" />
> ```
>
> `http://localhost:8080/{path的值}` 其实就相当于找到`docBase`。
>
>  🌰`http://localhost:8080/app452`就相当于找到  `D:\app2`
>
>  🌰`http://localhost:8080/app452/2.txt`相当于找到了 `D:\app2、2.txt`
>
> 这个作为了解即可，因为修改配置文件比较危险。

#  `Servlet` 开发⭐⭐⭐

## `GenericServlet` 和`HttpServlet`

两者都可以进行`Servlet` 的开发

**通过继承，来实现其方法**

> 1. `GenericServlet` 实现其抽象方法 `service`
> 2. `HttpServlet`  重写`doGet`、`doPost`方法

这两种方式其实都是执行的是 `service` 方法，`HttpServlet` 是 `GenericServlet` 的子类，只不过是`HttpServlet` 里的 `service` 方法给你实现好了

![image-20230202172514996](.\assets\image-20230202172514996.png)

它会根据你的请求方法不同，去执行`HttpServlet` 中的不同方法

```java
public abstract class HttpServlet extends GenericServlet {
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getMethod();
        if (method.equals("GET")) {
            this.doGet(req, resp);
        }  else if (method.equals("POST")) {
            this.doPost(req, resp);
        }
    }
}
```

```java
/**
 *  继承GenericServlet
 *  实现其抽象方法service
 *  localhost:8080/demo1/servlet1
 *  控制台里打印hello servlet1
 */
@WebServlet("/servlet1")
public class Servlet1 extends GenericServlet {
    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("hello servlet1");
    }
}

/**
 *  继承HttpServlet
 *  重写其doGet、doPost方法
 *  localhost:8080/demo1/servlet2
 *  控制台里打印hello servlet2
 */
@WebServlet("/servlet2")
public class Servlet2 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 接下来会使用浏览器方法，通过浏览器的地址栏发送的请求是GET请求
        System.out.println("hello servlet2");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 自己写业务
    }
}
```

## `@WebServlet` 注解

```java
// 该注解可以写在类上
@Target({ElementType.TYPE}) 
// 该注解运行时生效
@Retention(RetentionPolicy.RUNTIME) 
@Documented
public @interface WebServlet {
    String name() default "";
  
// 该Servlet的路径，通过该路径可以访问到这个servlet的service或doGet、doPost方法
    String[] value() default {};
  
// 和value属性的功能是一致的
    String[] urlPatterns() default {}; 
  
// 默认值是负数；如果为负数的话，意味着放访问该servlet路径的时候，该Servlet才初始化；如果不为负数，则Tomcat启动的时候就初始化，可以指定一个整数值，表示Servlet的加载顺序，较小的数字表示较早加载。
    int loadOnStartup() default -1; 
  
// 提供初始化参数，当前基本不用
    WebInitParam[] initParams() default {}; 

    boolean asyncSupported() default false;

    String smallIcon() default "";

    String largeIcon() default "";

    String description() default "";

    String displayName() default "";
}
```

> 补充：关于注解
>
> 1. 注解中的属性能够定义的数据类型必须是：
>    1. 基本数据类型
>    2. java.lang.String
>    3. java.lang.Class
>    4. 枚举enum
>    5. 注解
>    6. 以及上述类型的数组
> 2. 注解使用时的一些语法
>    1. 定义注解属性时也可以通过关键字`default`设定该属性的默认值，这样在实例化注解时就不需要给定取值，可以直接去掉"`()`"。当然即便有默认值的注解属性，也仍然可以赋值，覆盖默认值。
>    2. **如果注解体当中的属性只有1个，并且它就叫`value`的话，那么可以进行简化赋值。简化赋值可以直接给定取值，无需写"`属性名 = `"了。**
>    3. **如果注解属性是一个引用数据类型，那么在给定默认值或者赋值时不能等于`null`，也不能`new`赋值，只能以给定常量的方式进行赋值。**
>
> 3. `@Documented`是一个元注解（注解的注解），它的作用是用来指示其他自定义注解是否应该包含在Java文档中。具体来说，当一个注解被`@Documented`修饰时，如果某个类或方法使用了被`@Documented`修饰的自定义注解，那么这些注解将包含在生成的Java文档中，通常是通过工具如Javadoc生成的文档。
>
>    举个例子，假设你创建了一个自定义注解`@MyAnnotation`，然后在某个类或方法上使用了这个注解，并且你希望`@MyAnnotation`的描述和用法信息出现在生成的Java文档中，那么你可以在`@MyAnnotation`上加上`@Documented`注解，像这样：
>
>    ```java
>    import java.lang.annotation.Documented;
>          
>    @Documented
>    public @interface MyAnnotation {
>        // 注解的属性和方法
>    }
>    ```
>
>    现在，如果你在某个类或方法上使用了`@MyAnnotation`，并使用Javadoc工具生成文档，那么`@MyAnnotation`的信息将包含在生成的文档中，帮助其他开发者了解如何使用这个自定义注解。
>
>    总之，`@Documented`注解的作用是影响其他注解是否出现在生成的Java文档中，它有助于文档化自定义注解，提供更好的文档和使用说明。

### `value` 属性（或`urlPatterns`）

指的是注解`@WebServlet`的`value`属性

> 
> ```java
> // 该Servlet的路径，通过该路径可以访问到这个servlet的service或doGet、doPost方法
>     String[] value() default {};
>   
> // 和value属性的功能是一致的
>     String[] urlPatterns() default {}; 
> ```
>
> `value` 属性实际上是一个`String[]`。

我们通常使用的是其`value` 属性，`value` 是一个数组可以写多个属性。

功能上和`urlPatterns`其实是一样的，但是`value` 属性有一个好处: 

如果该注解只使用了`value` 属性的话,`value= ` 可以省略不写。

> 使用注解的目的是什么？
>
> 为了提供一些额外信息，为了耦合。
>
> 将注解里的信息和类之间进行结合。做的工作是一种信息的耦合。

### 一个`Servlet`可以对应多个`URL-Pattern`

一个`URL-Pattern`不能对应多个`Servlet`

`@WebServlet`注解的时候，`value`属性和`url-pattern` 属性，接收的值的类型`String[]`

```java
@WebServlet({"/hello1","/hello2","/hello3"})
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("hello servlet");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
```

## `URL-Pattern`⚡

使用`@WebServlet`的`value`属性或`url-pattern`属性来维护，简述`url-pattern`和`Servlet`之间的映射关系

**只能按照下面三种写法，因为解析的写法已经写好了**

### 合法写法

> 1.  路径匹配
>
> 语法：`/xxx`或`/xxx/*`
>
> 注意事项：
>
> - 以`/` 作为开头（不能省略开头的 `/`），可以写多级的 `url`
> - 可以使用通配符`*`
>   - 举个例子`/hello/*`, 这里的`*`可以代表多级的任意URL；

> 2. 类型匹配
>
> 语法：`*.xxx`
>
> 注意事项：
>
> - `*.do`、`*.action`这样的一些写法，比如 `hello.do`就可以找到`*.do`对应的Servlet来处理请求
> - **当前基本上不再使用**，这是使用Spring框架遗留的。
> - 比如一些特殊的资源，可以使用特殊的Servlet来处理，比如jpg、css等这些资源

> 3. 缺省匹配(⭐)
>
> 语法：`/`
>
> 路径匹配和类型匹配都没匹配上，只能找缺省匹配。
>
> `Tomcat` 有一个`DefaultServlet`，它是一个`Servlet`，它的`url-pattern`是`/`
>
> 在web资源根路径下去找**静态资源**，如果我们提供了自定义缺省`Servlet`，那么`Tomcat`就不会使用自己的`DefaultServlet`了
>
> 注意事项：非常特殊的写法

### 优先级

1. 路径匹配 > 类型匹配

2. 使用的是**匹配度更高**的`Servlet`，例如有`/abc/d` ，现在存在两个`Servlet`，分别`url-pattern`是`/abc/* `和`/`

通常是我们访问某一个请求，只会对应一个`Servlet`

### 缺省`Servlet`

提供了一个页面 `hello.html`，也提供一个`Servlet`，这个`Servlet`映射的`url-pattern`也是`hello.html`



![image-20230207155457330](.\assets\image-20230207155457330.png)



`Tomcat` 会提供缺省的`Servlet`，本身是用来做静态资源访问的。如果你想要提供缺省的`Servlet`，可以将自定义的这个`Servlet` 它的`URL-Pattern` 设置为`/` 即可，但是会导致原有的缺省`Servlet` 失效 `/`。

“如果你没有提供，我给你提供一个默认的；如果你提供了，则以你提供的为准”，后面`SpringMVC` 就是在此基础上做了设计的。

## `Servlet` 的生命周期

`LifeCycle`

生命周期：在一些特定的时间会去执行一些方法，而时间通常指某个东西从初始化到结束在整个阶段中会遇到的一些时间点。

> `Servlet`核心作用：
>
> 当我们输入`url`时，调用注解`@WebServlet`修饰的类中的`service`方法

| 方法名    | 时间                 | 次数 | 说明                                              |
| --------- | -------------------- | ---- | ------------------------------------------------- |
| `init`    | Servlet初始化        | 1    | 只执行一次，在`service`之前，用来用来做一些初始化 |
| `service` | 访问Servlet对应的URL | n    | 执行多次，用来处理业务                            |
| `destroy` | Servlet销毁          | 1    | 只执行一次，通常用来做资源的释放                  |

**`Servlet` 是何时初始化的**：`@WebServlet`注解的有一个属性`load-on-startup` 

- 默认值是负数`-1`；
- 如果为负数的话：懒加载，意味着访问该`Servlet`路径的时候，该`Servlet`才初始化；
- 如果不为负数，则`Tomcat` 启动的时候就初始化，并且会**按照数字的顺序**（较小的数字较早加载）来初始化不同的`Servlet` 

`Servlet` 是何时销毁的：

- `Tomcat` 关闭的时候



增加几个`Servlet`

```java
@WebServlet(value = "/hello",loadOnStartup = -2)
public class HelloServlet extends HttpServlet {}

@WebServlet(value = "/first",loadOnStartup = 1)
public class FirstServlet extends HttpServlet {}

@WebServlet(value = "/second",loadOnStartup = 2)
public class SecondServlet extends HttpServlet {}
```

想要看到他们的`init`、`service（doGet）`、`destroy`

- 应用程序启动 → first init 、second init
- 分别访问 （不分先后顺序）
  - /first   → first service
  - /second → second service  
  - /hello → hello init 、hello service
  - 再次访问/hello → hello service
- 应用程序关闭
  - `destroy`



# `ServletConfig`（了解）

键值对配置

- 放入配置
- 获取配置

要通过`ServletConfig`实例（对象）来进行操作，每一个`Servlet`都有与之对应的`ServletConfig`

## 放入配置

场景，将`username=root`这样的键值对放入到`ServletConfig`

```java
@WebServlet(value = "/hello",
        initParams = {@WebInitParam(name = "username",value = "root"),
                @WebInitParam(name = "password",value = "123456")})
public class HelloServlet extends HttpServlet {
}
```

在`HelloServlet`的父类`GenericServlet`中有一个成员变量 `config` 是 `ServletConfig` 类型的，而在 `init` 方法中给这个成员变量做赋值，也就是这个成员变量在初始化阶段，已经获得了这些值。

意味着在`service`方法（`doGet`、`doPost`）中，可以获得这个成员变量，并且从中获取值。

## 取出配置

在`Servlet`中已经提供了一个方法`getServletConfig` 方法，就是获得 `GenericServlet` 中的`ServletConfig` 类型的成员变量 `config` 

```java
public ServletConfig getServletConfig() {
    return this.config;
}
```

因为子类中可以使用父类的方法，所以在自己开发的`Servlet` 中可以直接调用方法来获得

```java
@WebServlet(value = "/hello",
        initParams = {@WebInitParam(name = "username",value = "root"),
                @WebInitParam(name = "password",value = "123456")})
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletConfig servletConfig = getServletConfig();
        String username = servletConfig.getInitParameter("username");
        String password = servletConfig.getInitParameter("password");
        System.out.println(username + ":" + password);
    }
}
```

# `ServletContext`   ⭐

应用在**共享数据**的场景：`ServletContext` 是整个Web应用共享的。

**<span style=color:red>整个Web应用</span> 提供的共享空间，应用程序启动的时候会初始化，可以通过键值对的方式存储和取出数据**。

`Servlet`上下文，开发过程中使用`ServletContext`实例（对象），使用这个实例其实维护的也是键值对。

> 补充说明，`context` 是上下文，通常都是`key-value` 形式。**上下文本质是对`Map`做的封装。**

前面的`ServletConfig` 是每一个`Servlet` 使用的单独的一个`ServletConfig`，

而`ServletContext` 是所有的`Servlet` 共享的，在所有的`Servlet`中都可以通过方法直接获得`ServletContext`，并且获得的是同一个`ServletContext`。这样在`ServletContext`中提供的数据其实就是被所有的`servlet`共享了。

## 获得方式

> 1. 在`Servlet`中直接使用`getServletContext()`
> 2. 通过`ServletConfig`提供的`getServletContext()` 方法来获得

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext servletContext1 = getServletContext();
        ServletContext servletContext2 = getServletConfig().getServletContext();
        System.out.println("servletContext1 = " + servletContext1);
        System.out.println("servletContext2 = " + servletContext2);
    }
}
```

```java
@WebServlet("/bye")
public class GoodbyeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext servletContext = getServletContext();
        System.out.println("servletContext = " + servletContext);
    }
}
```

想要在所有的`Servlet` 中共享数据

`username=root`

`password=123456`

可以将`init`做立即加载，利用生命周期完成。这样做避免使用时还没有赋值。

存和取：

`setAttribute(String, Object)`

`getAttribute(String)`

```java
// 写正数，意味着应用程序启动的时候初始化，初始化会开始生命周期的init方法
@WebServlet(value = "/parameter",loadOnStartup = 1)
public class ParameterServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        ServletContext servletContext = getServletContext();
        servletContext.setAttribute("username","root");
        servletContext.setAttribute("password","123456");
    }
}
```

## 获得真实路径 （了解）

```java
// 获得web资源的真实路径 → docBase里的真实路径
String realPath = servletContext1.getRealPath("");
System.out.println("realPath = " + realPath);

String realPath1 = servletContext1.getRealPath("hello.html");
System.out.println("realPath1 = " + realPath1);
```

# xml配置（了解项）

> `@WebServlet`注解是Java Servlet规范中引入的一种注解，它用于声明一个Servlet类，并配置Servlet的相关信息，以替代传统的在`web.xml`文件中进行Servlet配置。

配置文件`web.xml`放在哪里？

放置的路径是：`src/main/webapp/WEB-INF/web.xml`。原因是放在`webapp`路径下的文件，使用Maven进行编译，会存在`target/{artifactId}--{version}`。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
   
   <!--value属性（或url-pattern属性）：映射的url-pattern
   initParams属性：提供的初始化参数，可以通过ServletConfig来获得
   load-on-startup属性
    @WebServlet(value = "/HelloServlet",
    initParams = @WebInitParam(name = "username",value = "root"),
    loadOnStartup = 1)-->
    <servlet>
        <servlet-name>hello</servlet-name>
        <servlet-class>com.cskaoyan.service.HelloServlet</servlet-class>
        <init-param>
            <param-name>username</param-name>
            <param-value>root</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>hello</servlet-name>
        <url-pattern>/HelloServlet</url-pattern>
    </servlet-mapping>
</web-app>
```

# 小结

`Servlet` 处理请求的入口

`@WebServlet`的`value属性`

`ServletContext` 对象 伴随着应用程序启动创建的一个全局共享的对象



# ⭐ Web应用和Maven工程

编译为`Tomcat`所支持的`web`应用

指的是**虚拟映射**下放了哪些文件。

## Web应用的目录结构

> - Web应用的根目录（IDEA → target/artifact/version）
>   - 可以直接访问的资源（主要是静态资源，比如html、js、css、图片等）
>   - WEB-INF文件夹 （受保护的资源的文件）
>     - classes文件夹（字节码文件、配置文件）
>     - lib文件夹(第三方的依赖)
>     - web.xml(web应用的描述文件 → 基本上可以不使用了，可以用注解替代)
>     - 其他的文件（其他不想被直接访问的资源）

![image-20230202151408305](.\assets\image-20230202151408305.png)

## Maven工程的目录结构

有`src`和`pom.xml`就可以构成Maven工程的根目录

> - Maven工程的根目录
>   - **src文件夹**
>     - main文件夹（开发）
>       - java文件夹（java代码）
>       - resources文件夹（配置文件）
>       - webapp文件夹（web资源-对应的是web资源目录）
>     - test文件夹（测试）
>   - **pom.xml文件**
>   - target文件夹
>     - classes文件夹
>     - {artifactid}-{version}文件夹——tomcat虚拟映射的docBase

## 对应关系图（核心）

![image-20230202152234992](.\assets\Web目录结构和Maven工程目录结构-1678348341736.jpg)

非常重要：贯穿整个阶段

遇到一些问题：

- `ClassNotFound` ：编译后的内容里没有这个类 → `target/artifactid-version/WEB-INF/ `里的classes、lib目录
  - classes里没有 → `src/main/java`
  - lib里没有 →` pom.xml`
- `FileNotFound`  →` target/artifactid-version/`


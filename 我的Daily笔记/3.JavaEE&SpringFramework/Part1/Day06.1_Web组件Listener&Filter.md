# 前言

## 学习目标

1. 掌握`ServletContextListener`的使用，并且理解其执行时机
2. 掌握`Filter`的使用，并且理解其执行时机
3. 能够使用`Filter`解决一些实际的问题

## 前置知识准备

- `Servlet` 的执行

- `ServletContext` 的功能和使用

# Web组件

JavaEE的 三大Web组件

1. `Servlet ` → 处理请求对应的业务
2. `Listener`  → 监听器
3. `Filter`  → 过滤器

执行顺序

`listener`（共享的是`servletContext`） ➡️ `filter`（共享的是`request` `response`） ➡️`servlet`中的`init` ➡️`servlet`中的 `service`



# `Listener`监听器

**事件触发。**

顾名思义就是监听东西的，其实和命名有关系，我们提供的是什么监听器就是监听什么的。

监听器在监听到主体做了XX事情，就会触发对应的事件。

> 🌰：国家反诈中心app

## `ServletContextListener`

监听的主体就是`ServletContext`，当发现`ServletContext`做了事情，监听器就会执行该事件特定的方法

- `ServletContext`如果初始化，则会执行监听器的初始化方法
- `ServletContext`如果销毁，则会执行监听器的销毁方法

## 执行过程

当**应用程序**启动的过程中，逐步加载`Web`组件

- 首先会加载`ServletContext`和`Listener`组件
  - `ServletContext`伴随着应用程序初始化，它开始初始化，然后`ServletContextListener`监听到`ServletContext`初始化，会执行`Listener`的`Initialized`方法
- 然后初始化`loadOnStartup`为正数的`Servlet`

![image-20230220175957723](.\assets\image-20230220175957723.png)

改造之前的业务代码，之前整合MyBatis时，`SqlSessionFactory`的初始化是通过`Servlet`的生命周期`init`方法，当前可以通过`ServletContextListener`，在应用程序启动的时候，执行`contextInitialized`方法，在该方法中进行`SqlSessionFactory`初始化过程，并将其放到`ServletContext`中

```java
@WebListener
public class CustomServletContextListener implements ServletContextListener {
    // 当ServletContext初始化的时候执行
    // 应用程序启动的时候向ServletContext中塞入一些数据
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext servletContext = servletContextEvent.getServletContext();
        SqlSessionFactory sqlSessionFactory = null;
        try {
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("mybatis.xml"));
            System.out.println("ServletContext初始化");
            System.out.println("sqlSessionFactory = " + sqlSessionFactory);
        } catch (IOException e) {
            e.printStackTrace();
        }
        servletContext.setAttribute("SqlSessionFactory",sqlSessionFactory);
    }

    // 当ServletContext销毁的时候执行
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("ServletContext销毁");

    }
}
```

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    SqlSessionFactory sqlSessionFactory;

    @Override
    public void init() throws ServletException {
        ServletContext servletContext = getServletContext();
        sqlSessionFactory = (SqlSessionFactory) servletContext.getAttribute("SqlSessionFactory");
        System.out.println("Servlet初始化");
        System.out.println("sqlSessionFactory = " + sqlSessionFactory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doGet(request, response);
    }
}
```



![image-20230220180052194](.\assets\image-20230220180052194.png)

提供`Listener`，其实主要就是去初始化这个`ServletContext`，后面的`SpringMVC`就是基于这样的特点去实现的

# `Filter`

`Filter`是一个执行过滤任务的一个对象。它既可以作用于`Request`对象，也可以作用于`Response`对象，或者两者均作用。也就是`Servlet`中获取请求之前，`Servlet`处理响应之后。

![image-20230313175734907](.\assets\image-20230313175734907.png)

使用`Filter`做通用性的`request`，`response`设置。

比如每个`servlet`都需要设置解决乱码问题的代码：

+ `request.setCharacterEncoding("utf-8")`

+ `response.setContentType("application/json;charset=utf-8")`

是否经过`Filter`，取决于`Filter`的作用范围。

`Filter`有一行放行代码

```JAVA
filterChain.doFilter(servletRequest,servletResponse);
```

> 1. `doFilter`方法的参数`ServletRequest` \ `ServletResponse`是`HttpServletRequest` \ `HttpServletResponse`共享的，是同一个对象。
>
>    （`ServletRequest` \ `ServletResponse`是`HttpServletRequest` \ `HttpServletResponse`的父类）
> 2. `@WebFilter`注解决定作用范围
> 3. 版本兼容性问题，手写的`Filter`里要加上`init` `destory`

## `Filter` 和 `Servlet` 的执行

`URL-Pattern` 和 `Servlet` 之间存在着**映射关系**，`URL-Pattern` 和 `Filter` 之间也存在着映射关系。

- 一个 `URL-Pattern` 只能对应一个`Servlet`，但是可以对应多个 `Filter`。

  - > 描述一："一个`URL-Pattern`只能对应一个`Servlet`"
    >
    > 是对的，因为还有缺省的`Servlet`。
    >
    > 描述二："一个`Servlet`可以对应多个`URL-Pattern`"
    >
    > 是对的，因为有`"/user/*"`这种形式

- `Servlet` 和 `URL-Pattern` 之间是一对多的关系，但是`URL-Pattern`和`Servlet`之间是一对一

其实就意味着一件事，当我们发起一个请求的时候，其实就是一个`URL-Pattern` 对应的请求

- 对应一个`Servlet`
- 对应多个`Filter`

![image-20230222103201276](.\assets\image-20230222103201276.png)

如果只有一个过滤器那么执行流程如下

![image-20230313220043752](.\assets\image-20230313220043752.png)

多个过滤器，就是就组成了一个过滤器的链，依次执行过滤器

![image-20230222103412350](.\assets\image-20230222103412350.png)

如果增加上对应的方法

![image-20230313222518316](.\assets\image-20230313222518316.png)

有一个问题：是否每一次都会继续执行到下一个拦截器，或`Servlet`？

不一定，去界定是否是**放行状态**

> `doFilter`这个方法中，提供了一个形参，形参叫`filterChain`，`filterChain`中提供了一个`doFilter`方法，如果执行这个方法就是放行，如果不执行，则中断流程

![image-20230222103923204](.\assets\image-20230222103923204.png)

## 使用

```java
/**
 * localhost:8080/demo5/hello
 * localhost:8080/demo5/bye
 * URL-Pattern对于上面两个请求都能起作用，那么我们的URL-Pattern可以设置为 /*
 */
@WebFilter("/*")
public class URLPrintFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String url = request.getRequestURL().toString();
        System.out.println("url = " + url);
        System.out.println("Filter的前半部分");
        //放行
        filterChain.doFilter(servletRequest,servletResponse);
        System.out.println("Filter的后半部分");
    }

    @Override
    public void destroy() {

    }
}
```

就算没有`Servlet`，仍然是可以执行到`Filter`的

![image-20230222113435528](.\assets\image-20230222113435528.png)

![image-20230222113349934](.\assets\image-20230222113349934.png)

`Filter` 能否继续执行，取决于 `FilterChain` 的 `doFilter` 方法是否执行

## 案例

### 给请求和响应设置字符集

Post请求中文乱码

`request.setCharacterEncoding("utf-8")`

响应的时候，响应的字符中文乱码

`response.setContentType("text/html;charset=utf-8")`

```java
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        request.setCharacterEncoding("utf-8");
        //response.setContentType("text/html;charset=utf-8");
        response.setContentType("application/json;charset=utf-8");
        filterChain.doFilter(request,response);
    }

    @Override
    public void destroy() {

    }
}
```

### 登录案例

Http://localhost:8080/demo6/user/login

Http://localhost:8080/demo6/user/info

在 `Session` 中是否有存储用户的信息

> login登录实现的什么事情
>
> 	1. 验证用户名和密码
> 	1. 验证成功，将用户信息存到`Session`里
>
> info查看用户信息实现的什么事情
>
> 	1. 尝试从`Session`中取出信息，分析是否取出信息
> 	1. 如果取出了信息，说明登录成功了，根据取出的信息查询用户的具体信息
> 	1. 如果没有取出信息，提示未登录的`json` 数据
>
> order/list查询当前用户的订单信息
>
>  	1.  从`Session`取出信息，分析是否能取出了信息
>  	1.  如果取出了信息，说明登录成功了，根据取出的信息查询用户的订单信息
>  	1.  如果没有取出信息，提示未登录的`json` 数据

两个业务的第二步和第三步是相同的事情，可以用`Filter` 实现。

# 小结

## Web组件

- 核心是`Servlet`，处理核心业务
- `Listener`，用来做资源的初始化
- `Filter`，在`Servlet`处理前后增加**通用的处理**

![image-20230222102757909](.\assets\image-20230222102757909.png)


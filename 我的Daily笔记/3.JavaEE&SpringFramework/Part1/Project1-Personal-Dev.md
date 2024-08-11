# 项目1个人接口开发指导

`101.43.69.31`

该文档用来指导大家开发个人接口

![开发](.\assets\开发.png)

## 依赖

javax.servlet-api、lombok、mysql-connector-java、mybatis、jackson、.pagehelper

```xml
<dependencies>
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
    <scope>provided</scope>
  </dependency>
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.24</version>
  </dependency>
  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.47</version>
  </dependency>
  <dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.10</version>
  </dependency>
  <!--json响应-->
  <dependency>
    <groupId>com.fasterxml.jackson.datatype</groupId>
    <artifactId>jackson-datatype-jsr310</artifactId>
    <version>2.13.0</version>
  </dependency>
  <dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.2.0</version>
  </dependency>
</dependencies>
```

## 通用部分

### 跨域

IP,端口号发生变化时就会发起跨域请求。

跨域问题，需要在响应报文中增加一些响应头，这个是通用的部分，这时候我们要考虑使用`Filter`来完成

```java
@WebFilter("/*")
public class CorsFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) servletResponse;
      // 原始IP 全部
        response.addHeader("Access-Control-Allow-Origin", "*");
      // GET POST等全部方法
        response.addHeader("Access-Control-Allow-Methods", "*");
      // 
        response.addHeader("Access-Control-Allow-Headers", "*");
        filterChain.doFilter(servletRequest,servletResponse);
    }

    @Override
    public void destroy() {

    }
}
```

### 初始化（选做）

利用Listener做初始化。

初始化MyBatis的`SqlSessionFactory`，并且放入到`ServletContext`中

```java
@WebListener
public class MyBatisInitializationListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext servletContext = servletContextEvent.getServletContext();
        try {
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsStream("mybatis.xml"));
            servletContext.setAttribute(WdConstant.SQL_SESSION_FACTORY,sqlSessionFactory);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
```

### 个人信息

> 自定义`Session`

背景： 跨域请求的话`SessionID`每次都会变化，其实意味着每一次请求的时候`Session` 会变化，也就意味着就算是同一个用户，放入到`Session` 中的信息仍然也是拿不到的，这时候就会有一些问题，比如登录，之前是将用户信息放在 `Session` 中，现在这块无法运行了。

解决这个问题：要携带自定义的钥匙，通过这把钥匙拿到对应的信息。

我们可以在应用程序中维护一个这样的一块空间，用户登录成功之后可以开辟一块空间放该用户的信息，并且放在其中的信息是有时间限制（可以设置默认 `30min`）的。

`钥匙=信息（包含过期时间）`

> 我们提供一个 `Map`，`key` 为不可重复的随机值，`value` 中可以放用户的信息，同时包含时间信息，超过这个时间会移除到 `Map` 中的这组信息

| 方法                           | 说明                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `getInfo(String key)`:`Object` | 根据`key`获得没有过期的信息，如果已经过期则去掉该信息        |
| `genKey(Object info)`:`String` | 传入信息，创建`key`，生成过期时间，放入到`map`中，返回生成的`key` |

利用UUID生成随机值

```JAVA
UUID.randomUUID().toString
```



```java
@Data
public class WdTokenHolder {

  // 线程安全的哈希map
    private static Map<String,InfoWithExpiredTime> map = new ConcurrentHashMap<>();

    public static Object getInfo(String key) throws NoInfoException, InfoExpiredException {
        InfoWithExpiredTime info = map.get(key);
        if (info == null) {
            throw new NoInfoException();
        }
        Date expiredTime = info.getExpiredTime();
        if (new Date().after(expiredTime)) {
            map.remove(key);
            throw new InfoExpiredException();
        }
        Object validInfo = info.getInfo();
        return validInfo;
    }

    public static String genKey(Object validInfo) {
        String uuid = UUID.randomUUID().toString();
        Date now = new Date();
        Date afterDate = getAfterDate(now, 0, 0, 0, 0, 30, 0);
        InfoWithExpiredTime info = new InfoWithExpiredTime(validInfo,afterDate);
        map.put(uuid,info);
        return uuid;
    }

    private static Date getAfterDate(Date date, int year, int month, int day, int hour, int minute, int second){
        if(date == null){
            date = new Date();
        }

        Calendar cal = new GregorianCalendar();

        cal.setTime(date);
        if(year != 0){
            cal.add(Calendar.YEAR, year);
        }
        if(month != 0){
            cal.add(Calendar.MONTH, month);
        }
        if(day != 0){
            cal.add(Calendar.DATE, day);
        }
        if(hour != 0){
            cal.add(Calendar.HOUR_OF_DAY, hour);
        }
        if(minute != 0){
            cal.add(Calendar.MINUTE, minute);
        }
        if(second != 0){
            cal.add(Calendar.SECOND, second);
        }
        return cal.getTime();
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class InfoWithExpiredTime{
        Object info;
        Date expiredTime;
    }
}
```

![image-20230405112212542](.\assets\image-20230405112212542.png)

接下来就可以这样子做，当我们登录成功的时候，将我们需要存储的信息，通过`WdTokenHolder` 的 `genKey` 来生成并存储信息，然后返回这个 `key` 给到前端。

前端会以请求头的方式把`key =value`带回

前端发起这个请求的时候再把这个 `key`携带过来，可以使用特定的请求头携带过来，这时候我们就可以通过`key` 来获得这个信息

![image-20230405113102136](.\assets\image-20230405113102136.png)

### 全局的`Json`转换

全局使用一个`ObjectMapper`即可，同时设置其日期格式

| 方法                         | 说明                                                      |
| ---------------------------- | --------------------------------------------------------- |
| `read(String ,Class<T>)`:`T` | 传入Json字符串和需要转换的实例对应的Class，转换为实例返回 |
| `write(Object)`:`String`     | 将传入的实例转为对应的Json字符串                          |

```java
public class JacksonUtil {

    private static ObjectMapper objectMapper = new ObjectMapper();
    private static final String DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    private static final String DEFAULT_DATE_FORMAT = "yyyy-MM-dd";
    private static final String DEFAULT_TIME_FORMAT = "HH:mm:ss";
    static {
        JavaTimeModule javaTimeModule = new JavaTimeModule();
        // 增加LocalDate和LocalTime和LocalDateTime的解析格式的支持
        javaTimeModule.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_TIME_FORMAT)));
        javaTimeModule.addSerializer(LocalDate.class, new LocalDateSerializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_FORMAT)));
        javaTimeModule.addSerializer(LocalTime.class, new LocalTimeSerializer(DateTimeFormatter.ofPattern(DEFAULT_TIME_FORMAT)));
        javaTimeModule.addDeserializer(LocalDateTime.class, new LocalDateTimeDeserializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_TIME_FORMAT)));
        javaTimeModule.addDeserializer(LocalDate.class, new LocalDateDeserializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_FORMAT)));
        javaTimeModule.addDeserializer(LocalTime.class, new LocalTimeDeserializer(DateTimeFormatter.ofPattern(DEFAULT_TIME_FORMAT)));
        objectMapper.registerModule(javaTimeModule);
    }
    public static ObjectMapper getObjectMapper() {
        return objectMapper;
    }

    public static <T> T read(String jsonStr,Class<T> clazz) {
        T instance = null;
        try {
            instance = objectMapper.readValue(jsonStr, clazz);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return instance;
    }

    public static String write(Object instance) {
        String jsonStr = null;
        try {
            jsonStr = objectMapper.writeValueAsString(instance);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return jsonStr;
    }

}
```

### Json响应字符串工具（选用）

```java
public class ResponseUtil {

    public static void responseJson(HttpServletResponse response, Object instance) throws IOException {
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().println(JacksonUtil.write(instance));
    }
}
```

### 常量管理（选用）

创建WdConstant类，在其中管理实例

```java
public class WdConstant {

    public static final String SQL_SESSION_FACTORY = "sqlSessionFactory";

}
```

### URI分析后缀（选用）

比如`@WebServlet注解` 中的`value属性`写的是   `/admin/user/*`，当我们发起请求的时候，可以获得最后一级URI，比如发起`/admin/user/list`可以获得后缀 → `list`

```java
public class URIUtil {

    public static String getOperation(Class<?> servletClass,HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String appUri = uri.replaceAll(contextPath, "");
        WebServlet webServlet = servletClass.getDeclaredAnnotation(WebServlet.class);
        String urlPattern = webServlet.value()[0];
        String operation = appUri.substring(urlPattern.length() - 2);
        return operation;
    }
}
```

### 分页配置

`MyBatis` 的分页插件 `PageHelper`

`mybatis.xml`中增加分页的配置

标签顺序： `<plugins/>`在`<environment/>`之前,`<settings/>`之后。

```xml
<plugins>
    <plugin interceptor="com.github.pagehelper.PageInterceptor">
        <property name="helperDialect" value="mysql"/>
        <property name="reasonable" value="true"/>
    </plugin>
</plugins>
```

分页插件起到的功能，**在预编译的过程中提供分页语句**。

开启分页：

```java
.startPage
```

分页信息：

```java
PageInfo pageInfo = new PageInfo()
```

之后可以根据前端`JSON`的格式再封装一下。

## 具体部分

### 登录 (`/admin/auth/login`)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：存储登录信息**</span>

验证用户名和密码，如果没有问题，WdTokenHolder中生成对应的key，存储用户的信息，并且响应`Json`数据

```java
private void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String jsonStr = request.getReader().readLine();
    Map<String, String> map = JacksonUtil.read(jsonStr, Map.class);
    String username = map.get("username");
    String password = map.get("password");

    MarketAdmin admin = adminService.query(username, password);
    // 找不到当前用户
    if (admin == null) {
        BaseRespVo baseRespVo = BaseRespVo.unAuthc();
        ResponseUtil.responseJson(response, baseRespVo);
        return;
    }
    // 能够找到当前用户
    String token = WdTokenHolder.genKey(admin);
    // todo：更新log中的日志信息
    AdminInfoBean adminInfoBean = new AdminInfoBean(username, admin.getAvatar());
    LoginUserData data = new LoginUserData(adminInfoBean, token);
    ResponseUtil.responseJson(response,BaseRespVo.ok(data));
}
```

上面第15行，就是登陆成功后，将信息在本地存储起来，通过返回值token后面可以取出该信息

### 个人信息 (`/admin/auth/info`)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：拿到登录的时候存储的个人信息**</span>

查看个人具体信息，其中权限的信息为*

- 首先拿到请求头中的token值
- 然后根据token在WdTokenHolder中获取对应的用户信息

```java
String token = request.getHeader(WdConstant.MARKET_TOKEN);
MarketAdmin info = WdTokenHolder.getInfo(token);
```

也可以通过工具类封装，让我们在全局都能够获取信息

```java
MarketAdmin admin = (MarketAdmin) AuthenticationUtil.getPrincipal();
```

这时候有一个问题，为何在工具类中，就可以直接拿到用户信息

- 增加一个Filter，在Filter中根据请求头拿到Token，并且将Token保存起来
- 在AuthenticationUtil中getPrincipal的时候，先拿到token，然后根据token调用WdTokenHolder的getInfo方法

```java
@WebFilter("/*")
public class AuthenticationInfoFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        if (request.getMethod().equals("OPTIONS") || request.getRequestURI().endsWith("/login")) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        String token = request.getHeader(WdConstant.MARKET_TOKEN);
        AuthenticationUtil.setToken(token);
        filterChain.doFilter(servletRequest, servletResponse);

    }

    @Override
    public void destroy() {

    }
}
```

```java
public class AuthenticationUtil {
    private static ThreadLocal<String> localVar = new ThreadLocal<String>();

    public static Object getPrincipal() throws NoInfoException, InfoExpiredException {
        String token = localVar.get();
        Object info = WdTokenHolder.getInfo(token);
        return info;
    }

    public static void setToken(String token) {
        localVar.set(token);
    }
}
```



### 行政区域(/admin/region/list)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：三层嵌套如何封装：可以多表查询，也可以通过流全部查出，然后拼接**</span>

行政区域的省、市、区县 逐级封装

可以先把所有的Region表信息都查出来

- 把type为1的全部筛选出来  → 所有的省的list
- 把type为2的全部筛选出来  → 所有的市的list
- 把type为3的全部筛选出来  → 所有的区的list

同时获得Pid和RegionList的对应Map，比如根据山东省的id，就可以获得山东省的市的List，再比如根据武汉市的id可以获得武汉市的区的List

然后省市区 三层遍历，分别进行封装

```java
private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
    List<RegionVo> regionVoList = new ArrayList<>();

    List<MarketRegion> marketRegions = regionService.getAll();
    Map<Byte, List<MarketRegion>> collect = marketRegions.stream().collect(Collectors.groupingBy(MarketRegion::getType));
    byte provinceType = 1;
    List<MarketRegion> provinceList = collect.get(provinceType);
    byte cityType = 2;
    List<MarketRegion> city = collect.get(cityType);
    Map<Integer, List<MarketRegion>> cityListMap = city.stream().collect(Collectors.groupingBy(MarketRegion::getPid));
    byte areaType = 3;
    List<MarketRegion> areas = collect.get(areaType);
    Map<Integer, List<MarketRegion>> areaListMap = areas.stream().collect(Collectors.groupingBy(MarketRegion::getPid));

    for (MarketRegion province : provinceList) {
        RegionVo provinceVO = new RegionVo();
        provinceVO.setId(province.getId());
        provinceVO.setName(province.getName());
        provinceVO.setCode(province.getCode());
        provinceVO.setType(province.getType());

        List<MarketRegion> cityList = cityListMap.get(province.getId());
        List<RegionVo> cityVOList = new ArrayList<>();
        for (MarketRegion cityVo : cityList) {
            RegionVo cityVO = new RegionVo();
            cityVO.setId(cityVo.getId());
            cityVO.setName(cityVo.getName());
            cityVO.setCode(cityVo.getCode());
            cityVO.setType(cityVo.getType());

            List<MarketRegion> areaList = areaListMap.get(cityVo.getId());
            List<RegionVo> areaVOList = new ArrayList<>();
            for (MarketRegion area : areaList) {
                RegionVo areaVO = new RegionVo();
                areaVO.setId(area.getId());
                areaVO.setName(area.getName());
                areaVO.setCode(area.getCode());
                areaVO.setType(area.getType());
                areaVOList.add(areaVO);
            }

            cityVO.setChildren(areaVOList);
            cityVOList.add(cityVO);
        }
        provinceVO.setChildren(cityVOList);
        regionVoList.add(provinceVO);
    }
    ResponseUtil.responseJson(response, BaseRespVo.ok(CommonData.data(regionVoList)));
}
```



### 订单列表(/admin/order/list)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：这里涉及到很多不同类型的请求参数的接收，并且要关注空值的判断，还需要关注条件查询和分页查询**</span>

market_order表

```java
@SneakyThrows
private void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Integer userId = request.getParameter("userId") == null ? null : Integer.parseInt(request.getParameter("userId"));
    String orderSn = request.getParameter("orderSn");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern(WdConstant.DEFAULT_DATETIME_PATTERN);
    //LocalDateTime start = LocalDateTime.parse(request.getParameter("start"), formatter);
    //LocalDateTime end = LocalDateTime.parse(request.getParameter("end"), formatter);
    SimpleDateFormat df = new SimpleDateFormat();
    Date start = StringUtil.isEmpty(request.getParameter("start")) ? null : df.parse(request.getParameter("start"));
    Date end = StringUtil.isEmpty(request.getParameter("end")) ? null : df.parse(request.getParameter("end"));
    List<Short> orderStatusArray = new ArrayList<>();
    String[] orderStatusArrays = request.getParameterValues("orderStatusArray");
    if (!ArrayUtil.isEmpty(orderStatusArrays)) {
        orderStatusArray = Arrays.asList(orderStatusArrays).stream().map(Short::valueOf).collect(Collectors.toList());
    }
    Integer page = Integer.parseInt(request.getParameter("page"));
    Integer limit = Integer.parseInt(request.getParameter("limit"));
    String sort = request.getParameter("sort");
    String order = request.getParameter("order");
    CommonData<MarketOrder> commonData = orderService.list(userId, orderSn, start, end, orderStatusArray, page, limit, sort, order);
    ResponseUtil.responseJson(response, BaseRespVo.ok(commonData));
}
```

OrderServiceImpl中的list方法

```java
@Override
public CommonData list(Integer userId, String orderSn, Date start, Date end, List<Short> orderStatusArray, Integer page, Integer limit, String sort, String order) {
    MarketOrderExample example = new MarketOrderExample();
    MarketOrderExample.Criteria criteria = example.createCriteria();

    if (userId != null) {
        criteria.andUserIdEqualTo(userId);
    }
    if (!StringUtil.isEmpty(orderSn)) {
        criteria.andOrderSnEqualTo(orderSn);
    }
    if(start != null){
        criteria.andAddTimeGreaterThanOrEqualTo(start);
    }
    if(end != null){
        criteria.andAddTimeLessThanOrEqualTo(end);
    }
    if (orderStatusArray != null && orderStatusArray.size() != 0) {
        criteria.andOrderStatusIn(orderStatusArray);
    }
    criteria.andDeletedEqualTo(false);

    if (!StringUtil.isEmpty(sort) && !StringUtil.isEmpty(order)) {
        example.setOrderByClause(sort + " " + order);
    }

    MarketOrderMapper orderMapper = sqlSessionFactory.openSession().getMapper(MarketOrderMapper.class);
    PageHelper.startPage(page, limit);
    List<MarketOrder> marketOrders = orderMapper.selectByExample(example);
    return CommonData.data(new PageInfo(marketOrders));
}
```



### 订单详情(/admin/order/detail)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：根据order、order_goods和user之间的关系来做查询**</span>

查询market_order\market_order_goods\market_user

（直接参考代码文件AdminOrderServlet、OrderService和实现类、OrderGoodsService和实现类、UserService和实现类）

### 订单退款(/admin/order/refund)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**核心点：修改订单状态、商品货品增加、返还优惠券，需要增加事务（![img](image/personal-dev/08BF73BE.png)）**</span>

保证当前这个请求过程，执行的增删改操作使用的都是同一个`SqlSession`，那么使用`ThreadLocal`来管理`SqlSession`

我们可以创建一个工具类，

- 开启事务的方法，创建`SqlSession`并且保存起来
- 获取`SqlSession`（或先获取`SqlSession`，然后进一步获得`Mapper`实例）
- 提交事务方法

```java
public class TransactionUtil {
    private static ThreadLocal<SqlSession> localVar = new ThreadLocal<SqlSession>();

    public static void startTransaction() {
        setSqlSession();
    }

    public static void commit() {
        SqlSession sqlSession = localVar.get();
        System.out.println("sqlSession = " + sqlSession);
        if (sqlSession != null) {
            sqlSession.commit();
            sqlSession.close();
        }
    }

    private static void setSqlSession() {
        SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession();
        System.out.println("存入sqlSession = " + sqlSession);
        localVar.set(sqlSession);
    }

    public static SqlSession getSqlSession() {
        return localVar.get();
    }

    public static <T> T getMapper(Class<T> mapperClass) {
        T mapper = getSqlSession().getMapper(mapperClass);
        return mapper;
    }
}
```

其他代码参考：OrderServiceImpl、CouponUserServiceImpl、LogServiceImpl、orderGoodsServiceImpl



### 订单物流(/admin/order/channel)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：可以将这个物流信息放在配置文件中加载</span>

查询物流信息

```java
public class VendorsProperties {
    private static List<Map<String, String>> vendors=new ArrayList<>();
    static {
        InputStream inputStream = VendorsProperties.class.getClassLoader().getResourceAsStream("express_vendors.properties");
        Properties properties = new Properties();
        try {
            properties.load(new InputStreamReader(inputStream,"utf-8"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        Enumeration<?> enumeration = properties.propertyNames();
        while (enumeration.hasMoreElements()) {
            String key = (String) enumeration.nextElement();
            String value = properties.getProperty(key);
            HashMap<String, String> map = new HashMap<>();
            map.put("code", key);
            map.put("name",value);
            vendors.add(map);
        }
    }

    public static List<Map<String, String>> getVendors() {
        return vendors;
    }
}
```

配置文件express_vendors.properties

```properties
ZTO=中通快递
YTO=圆通速递
YD=韵达速递
YZPY=邮政快递包裹
EMS=EMS
DBL=德邦快递
FAST=快捷快递
ZJS=宅急送
TNT=TNT快递
UPS=UPS
DHL=DHL
FEDEX=FEDEX联邦(国内件)
FEDEX_GJ=FEDEX联邦(国际件)
```

### 订单发货(/admin/order/ship)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：和退款一样,修改订单状态，同时完成日志的记录，需要增加事务</span>

修改订单状态

参考OrderServiceImpl、LogServiceImpl

### 订单删除(/admin/order/delete)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：和退款一样,修改订单的deleted字段，同时修改orderGoods中的deleted字段，同时完成日志的记录，需要增加事务</span>

去掉该订单信息，可以物理删除，也可以逻辑删除

参考OrderServiceImpl、LogServiceImpl

### 图片上传(/admin/storage/create)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：使用getPart方法获得文件部分，然后获得InputStream，然后通过工具方法做保存</span>

使用InputStream存储到指定位置，同时生成storage记录存储到market_storage表中

```java
private void create(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    Part filePart = request.getPart("file");
    InputStream inputStream = filePart.getInputStream();
    String originFileName = filePart.getSubmittedFileName();
    MarketStorage marketStorage = storageService.store(inputStream, filePart.getSize(),
            filePart.getContentType(), originFileName);
    ResponseUtil.responseOkJsonVo(response,marketStorage);
}
```

```java
public class StorageServiceImpl implements StorageService {
    private LocalStorage storage = new LocalStorage();
    @Override
    public MarketStorage store(InputStream inputStream, long size, String contentType, String fileName) {
        String key = generateKey(fileName);
        storage.store(inputStream, size, contentType, key);

        String url = generateUrl(key);
        MarketStorage storageInfo = new MarketStorage();
        storageInfo.setName(fileName);
        storageInfo.setSize((int) size);
        storageInfo.setType(contentType);
        storageInfo.setKey(key);
        storageInfo.setUrl(url);
        this.add(storageInfo);

        return storageInfo;
    }

    @Override
    public int add(MarketStorage storageInfo) {
        Date now = new Date();
        storageInfo.setAddTime(now);
        storageInfo.setUpdateTime(now);
        MarketStorageMapper storageMapper = TransactionUtil.getMapper(MarketStorageMapper.class);
        int insert = storageMapper.insert(storageInfo);
        TransactionUtil.commit();
        return insert;
    }

    private String generateUrl(String key) {
		// 这个前缀也可以写在配置文件中
        return "http://localhost:8083/wx/storage/fetch/" + key;
    }

    private String generateKey(String originalFilename) {
        int index = originalFilename.lastIndexOf('.');
        String suffix = originalFilename.substring(index);

        String key = UUID.randomUUID().toString().replaceAll("-","") + suffix;

        return key;
    }
}
```



### 商品创建(/admin/goods/create)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：需要增加market_goods、market_goods_product、market_goods_attribute、market_goods_specification，同时需要关注brand和category的校验；JSON字符串对应的Java实体类，可以借助GsonFormat(Plus)工具来辅助生成；数据库的JDBC类型和Java中的类型不一致，可以使用MyBatis的TypeHandler</span>

创建商品涉及多张表，要使用事务

参考GoodsServiceImpl、GoodsAttributeServiceImpl、GoodsProductServiceImpl、GoodsSpecificationServiceImpl、BrandServiceImpl、CategoryServiceImpl

```java
public BaseRespVo create(GoodsVo goodsVo) {
    TransactionUtil.startTransaction();
    try {
        BaseRespVo error = validate(goodsVo);
        if (error != null) {
            return error;
        }

        MarketGoods goods = goodsVo.getGoods();
        MarketGoodsAttribute[] attributes = goodsVo.getAttributes();
        MarketGoodsSpecification[] specifications = goodsVo.getSpecifications();
        MarketGoodsProduct[] products = goodsVo.getProducts();

        String name = goods.getName();
        if (this.checkExistByName(name)) {
            return BaseRespVo.fail(611, "商品名已经存在");
        }

        // 商品表里面有一个字段retailPrice记录当前商品的最低价
        BigDecimal retailPrice = new BigDecimal(Integer.MAX_VALUE);
        for (MarketGoodsProduct product : products) {
            BigDecimal productPrice = product.getPrice();
            if(retailPrice.compareTo(productPrice) == 1){
                retailPrice = productPrice;
            }
        }
        goods.setRetailPrice(retailPrice);

        // 商品基本信息表market_goods
        this.add(goods);


        // 商品规格表market_goods_specification
        for (MarketGoodsSpecification specification : specifications) {
            specification.setGoodsId(goods.getId());
            specification.setId(null);
            specificationService.add(specification);
        }

        // 商品参数表market_goods_attribute
        for (MarketGoodsAttribute attribute : attributes) {
            attribute.setGoodsId(goods.getId());
            attribute.setId(null);
            attributeService.add(attribute);
        }

        // 商品货品表market_product
        for (MarketGoodsProduct product : products) {
            product.setId(null);
            product.setGoodsId(goods.getId());
            productService.add(product);
        }
    } catch (Exception exception) {
        exception.printStackTrace();
        TransactionUtil.rollback();
    }
    TransactionUtil.commit();
    return BaseRespVo.ok();
}
```

### 优惠券列表(/admin/coupon/list)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：做优惠券信息的条件查询</span>

```java
private void list(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String name = request.getParameter("name");
    String typeStr = request.getParameter("type");
    Short type = StringUtil.isNotEmpty(typeStr)?Short.parseShort(typeStr):null;
    Short status = StringUtil.isNotEmpty(request.getParameter("status"))?Short.parseShort(request.getParameter("status")):null;
    Integer page = StringUtil.isNotEmpty(request.getParameter("page"))?Integer.parseInt(request.getParameter("page")):null;
    Integer limit = StringUtil.isNotEmpty(request.getParameter("limit"))?Integer.parseInt(request.getParameter("limit")):null;
    String sort = request.getParameter("sort");
    String order = request.getParameter("order");
    CommonData<MarketCoupon> data = couponService.querySelective(name, type, status, page, limit, sort, order);
    ResponseUtil.responseJson(response, BaseRespVo.ok(data));
}
```

```java
public class CouponServiceImpl implements CouponService {
    @Override
    public CommonData<MarketCoupon> querySelective(String name, Short type, Short status, Integer page, Integer limit, String sort, String order) {
        MarketCouponExample example = new MarketCouponExample();
        MarketCouponExample.Criteria criteria = example.createCriteria();

        if (!StringUtil.isEmpty(name)) {
            criteria.andNameLike("%" + name + "%");
        }
        if (type != null) {
            criteria.andTypeEqualTo(type);
        }
        if (status != null) {
            criteria.andStatusEqualTo(status);
        }
        criteria.andDeletedEqualTo(false);

        if (!StringUtil.isEmpty(sort) && !StringUtil.isEmpty(order)) {
            example.setOrderByClause(sort + " " + order);
        }

        PageHelper.startPage(page, limit);
        MarketCouponMapper couponMapper = MyBatisUtil.getMapper(MarketCouponMapper.class);
        List<MarketCoupon> marketCoupons = couponMapper.selectByExample(example);
        return CommonData.data(marketCoupons);
    }
}
```

### 优惠券创建(/admin/coupon/create)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：提前做好Jackson的日期序列化和反序列化的配置</span>

创建过程中涉及到日期的Json字符串参数

```java
@Override
public BaseRespVo create(MarketCoupon coupon) {
    BaseRespVo error = validate(coupon);
    if (error != null) {
        return error;
    }

    // 如果是兑换码类型，则这里需要生存一个兑换码
    if (coupon.getType().equals(2)) {
        String code = this.generateCode();
        coupon.setCode(code);
    }
    TransactionUtil.startTransaction();
    coupon.setId(null);
    this.add(coupon);
    TransactionUtil.commit();
    return BaseRespVo.ok(coupon);
}
```

### 商场配置(/admin/mall/config)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：请求方法不同，业务处理的方式不同</span>

GET请求做查询

POST请求做更新

```java
@WebServlet("/admin/config/*")
public class AdminConfigServlet extends WdBaseServlet{
    private SystemConfigService systemConfigService = new SystemConfigServiceImpl();
    @Override
    protected void handle(String operation, HttpServletRequest request, HttpServletResponse response) throws IOException {
        switch (operation) {
            case "/mall":
                mall(request, response);
                break;
        }
    }

    private void mall(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String method = request.getMethod();
        if ("GET".equals(method)) {
            //GET方法做查询
            mallQuery(request, response);
        }else {
            //POST方法做更新
            mallModify(request, response);
        }
    }

    private void mallModify(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String jsonStr = request.getReader().readLine();
        Map<String, String> data = JacksonUtil.read(jsonStr, Map.class);
        systemConfigService.updateConfig(data);
        ResponseUtil.responseOkJsonVo(response,null);
    }

    private void mallQuery(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map<String, String> data = systemConfigService.listMall();
        ResponseUtil.responseOkJsonVo(response,data);
    }
}
```

### 用户统计(/admin/stat/user)

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>核心点：使用groupby语句来统计，需要关注封装的格式，因为前端的图表中接收固定格式的数据才能正确的显示</span>

```java
private void user(HttpServletRequest request, HttpServletResponse response) throws IOException {
    List<Map> rows = statService.statUser();
    String[] columns = new String[]{"day", "users"};
    StatVo statVo = new StatVo();
    statVo.setColumns(columns);
    statVo.setRows(rows);
    ResponseUtil.responseOkJsonVo(response,statVo);
}
```

```sql
select
        substr(add_time,1,10) as day,
        count(distinct id) as users
        from market_user
        group by substr(add_time,1,10)
```



# 常见异常

Syntax 语法 → 检查sql语句 → 控制台 sql

SAXParse → xml语法错误 mybatis.xml、mybatis的映射文件 → columnNumber 行号

使用JSON的过程中 → 要提供getter/setter方法

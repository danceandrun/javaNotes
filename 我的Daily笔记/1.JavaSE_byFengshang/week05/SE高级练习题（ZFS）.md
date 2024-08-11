

# 练习题(答案都是上课讲的知识点)

## IO

### 填空

1. IO当中4个父类分别是( OutputStream) ( InputStream)  (Writer )  ( Reader)

2. IO当中分类

   1. 按照数据流向分,可以分为( 输出 )流, ( 输入)流,  以(  内存)为参照物
   2. 按照数据类型分, 可以分为(字节  )流,  ( 字符 )流.

3. 可以通过("\r\n"),  (System.lineSeparator().getBytes)  方式实现换行功能

4. 实现文件追加功能,应该使用FileOutputStream的哪个构造方法( 利用带append参数的构造方法，将append参数取值设为true)

5. 使用FileInputStream,    用while循环读取数据的时候,   我们判断读取到末尾的判断依据是( read方法的返回值为-1  )

6. 使用InputStream中的read() 方法的返回值代表什么意思? ( 读取到的一个字节数据的字节值，如果没有数据可读，则返回-1 )

7. 使用InputStream中的read(byte[] b) 方法的返回值代表什么意思? ( 实际读取到数据的字节数量 ，如果没有数据可读，则返回-1 )

8. ```java 
   // 假设a.txt当中有一个字符串    "abcdef" 
   // 代码片段
   FileInputStream in = new FileInputStream("a.txt");
   byte[] bytes = new byte[4];
   readCount1 = in.read(bytes);
   // 请问 此时 bytes数组中的值是什么??  readCount1的值是几??
   此时byte数组中存放的数据是abcd，count的值是4
   readCount2 = in.read(bytes);
   //  请问 此时 bytes数组中的值是什么??  readCount2的值是几??
   此时byte数组中efcd，count的值是2
   ```

9. ```java
   //有个a.txt文件,里面有一行字符串abcdef
   FlieOutputStream out = new FileOutputStream("a.txt");
   // 此时a.txt文件中是什么?
   程序运行到这里时，输入流会清空这个文件，此时a.txt啥内容也没有
   out.write(97);
   // 此时a.txt文件中是什么?
   写入了一个a字符
   out.close()
   ```

9. ```` java
   // a.txt中有字符串   "五五开卢本伟white"
   public static void main(String[] args) throws IOException {
           FileInputStream in = new FileInputStream("a.txt");
           FileOutputStream out1 = new FileOutputStream("b.txt");
           FileOutputStream out2 = new FileOutputStream("c.txt");
           copyFile(in, out1);
           copyFile(in, out2);
           in.close();
           out1.close();
           out2.close();
       }
   
       public static void copyFile(InputStream in, OutputStream out) throws IOException {
           int readCount;
           byte[] bytes = new byte[1024];
           while ((readCount = in.read(bytes)) != -1) {
               out.write(bytes, 0, readCount);
           }
       }
   // 请问,b.txt文件的内容是什么??
   内容就是文件复制的结果
   // 请问, c.txt文件中内容是什么??
   无内容 同一个输入流读文件，只能读一次
   
   ````
   
11. BufferedInputStream与BufferedOutputStream中默认缓冲区大小是( 8kb )

12. BufferedWriter与BufferedReader中默认缓冲区大小是( 16kb )

13. BufferedWriter中特有的方法是(  newLine 写一个换行 )

14. BufferedReader中特有的方法是( readLine(), 读取一整行的文本，读完后会换行。**注意如果已经读到了末尾，会返回null**)

15. 使用BufferedReader中特有的方法,使用while循环读取的时候,我们判断读取结束的依据是什么( readLine方法会返回读到的一行字符串，如果已经读到末尾无数据可读了，会返回null )

16. ```java
    FileWriter out = new FileWriter("a.txt");
    out.write("哈哈哈");
    // 执行到这里 请问此时a.txt文件中的内容是什么??
    无任何内容，因为缓冲流需要刷新才会写入。
    out.flush();
    // 执行到这里 请问此时a.txt文件中的内容是什么??
    这时写入成功
    ```

17. 采用DataOutputStream先writeByte, 再writeInt, 读取的时候采用DataInputStream, 先使用( readByte )方法, 再使用( readInt )

18. System.out的默认输出设备是( 显示器 ), System.out是( PrintStream打印流  )类型

19. System.in的默认输入设备是( 键盘 ), System.in的是( InputStream字节输入流   )类型

20. 序列化反序列化对象使用(ObjectOutputStream对象输出流 ) ,  (ObjectInputStream对象输入流 ) 类, 对象所在的类必须实现(java.io.Serializable) 接口,才可以自动序列化所有的内容

21. ( `transient `)关键字可以让类中的属性不被序列化

22. | 类型     | 字节输出流           | 字节输入流          | 字符输出流         | 字符输入流        |
    | -------- | -------------------- | ------------------- | ------------------ | ----------------- |
    | 抽象基类 | OutputStream         | InputStream         | Writer             | Reader            |
    | 文件相关 | FileOutputStream     | FileOutputStream    | FileWriter         | FileReader        |
    | 缓冲相关 | BufferedOutputStream | BufferedInputStream | BufferedWriter     | BufferedReader    |
    | 转换相关 | 无                   | 无                  | OutputStreamWriter | InputStreamReader |
    | 数据相关 | DataOutputStream     | DataInputStream     | 无                 | 无                |
    | 打印相关 | PrintStream          | 无                  | PrintWriter        | 无                |
    | 对象相关 | ObjectOutputStream   | ObjectInputStream   | 无                 | 无                |

    

### 选择

- 提供println()方法和print()方法的类是( A 打印流才有这两个方法)

> A. PrintStream		B. System		C. InputStream		D. DataOutputStream

- 下列说法不正确的是( D 非常明显的错误 )
  - A.  InputStream与OutputStream类通常用来处理字节流
  - B. Reader与Writer通常来处理字符流
  - C. Java中IO流的处理通常分为输入流和输出流2个部分
  - D. File类是输入/输出流的子类
- 与InputStream相对应的Java系统中的标准输入对象是( A)

> A. System.in		B. System.out		C. System.error		D. System.exit()

- InputStreamReader 类提供的功能是( D 转换流) 

> A. 数据校验		B.文本行计数		C. 压缩		D.将字节流变为字符流

- 如果打印流PrintWriter开启了自动刷新功能,下列使用哪个方法不会启动自动刷新( A )

> A . print()		B . println()		C. format()		D. printf()

### 简答

1. 为什么要close? 关闭流，释放额外资源

2. ```java
   try-with-resources 语法结构怎么写?有什么特点?
   跟传统try-catch有啥不一样?
     
   自动的流资源释放，少写一些代码，语法格式更简单。但底层实现依然是try-catch
   ```
   
3. 字符流的本质是什么? 实现功能仍然要依赖于字节流，相当于字节流+编码表

4. 常见编码表有哪些? 分别几个字节代表一个字符?  UTF-8 ASCII GBK等

5. 对于字符输出流, 为什么可以直接close文件中就有数据? **关闭流的同时也会强制刷新流**

6. 序列化流主要有什么作用? 持久化存储Java对象

8. serialVersionUID有啥作用? 避免序列化在不同机器、平台下出现环境问题导致的错误。



## 多线程

### 填空

1. java多线程可以依靠( 实现`Runable`接口 ) , ( 继承`Thread`类重写`run`方法 ) , ( 实现`Callable`接口) 三种方式实现
2. java程序运行时,至少启动(2 ) 个线程, 分别是( 主线程) , ( GC垃圾回收线程).
3. java采用( 抢占式 )线程的调度方式, 所以线程的执行是( 随机 )的.
4. 对于join方法
   - 谁等待?  ( 被执行join方法的线程等待 )
   - 等待谁? ( 等待调用join方法的线程执行完毕 )
5. 通过( `setDaemon(true)` )API 把一个线程设置为守护线程.
6. 线程的优先级范围是( 1 ) - ( 10  )
7. 获取当前线程对象的引用,使用哪个API ( Thread.currentThread() 静态方法)
8. 线程的生命周期要经历5种状态 , 分别是( 新建 ) , ( 就绪 ) , ( 运行) , ( 阻塞), ( 死亡)状态
9. 多线程产生数据安全问题的原因有3个,分别是
   - ( 多线程下的程序运行特点导致。 )
   - ( 多线程下的线程共享数据需求导致。 )
   - ( 某个线程在执行一个需要访问共享数据任务的任意过程中，都有可能发生线程切换，其余线程也会执行这个任务。 )
10. 什么是原子操作? ( 一个不可分割的、要么全部执行，要么全部不执行的操作称之为“原子操作” )
11. Object中提供的( wait ), ( notify) , ( notifyAll) 三个方法可以控制线程
12. 当前有3个线程处于阻塞状态, 此时执行notify方法将会唤醒其中 ( 随机一个 ) 线程
13. Executors中产生3种线程池,分别是
    - 带缓存的线程池(  `newCachedThreadPool()`  )
    - 固定数量的线程池( `newFixedThreadPool(int)`  )
    - 固定1个数量的线程池(  `newSingleThreadExecutor()` )
14. 关闭线程池可以采用哪两种方式?
    - (  `shutdown()`)API,  特点是( 等待已提交的任务执行完毕，关闭线程池 ) 
    - (  `shutdownNow()` )API, 特点是( 立刻停止所有正在执行的活动任务，返回等待执行的任务列表 )

### 选择

- 线程的启动方法是( B )

> A. run()		B. start()		C. begin()		D. accept() 

- 设置优先级的方法是( A)

> A. setPriority()		B. gerPriority()		C. getName()		D.setName()

- 下列( C) 关键字用来对对象加锁

> A. serialize		B. transient		C. synchronized		D. static

- 下面(A )父类或父类接口是无法实现多线程子类定义的?

> A. Serializable		B. Thread		C. Runnable		D. Callable

### 简答题

1. 什么是线程?什么是进程?两者什么关系?  

   1. 进程就是运行中的程序，线程是进程中的一个子任务，一条执行路径。

      线程不能脱离进程存在，一个进程至少有一个线程。

2. 什么是串行,并行,并发? 

   1. 串行即排队一个接一个执行。

   2. 并行是同一时刻一起执行。

   3. 并发指在一个很短的时间段内，多个线程切换执行，虽然严格来说，在某个确定时刻只有一个线程执行，但由于切换非常快，时间段也很短暂，人肉眼不可察觉这个切换，所以并发从人肉眼出发，也是“一起”执行。

3. 什么是同步,异步? 

   1. 同步就是有多个任务需要执行时，必须一个接一个的执行，类似于过独木桥。异步：允许同时执行多个任务，各自执行各自的，互不干扰。

4. 启动线程是start方法不是run方法,这2个有什么区别? 

   1. start是向操作系统申请资源，启动一个线程。而run方法调用不过是调用一个成员方法罢了

5. 守护线程的特点是什么? 

   1.  当一个Java进程中，所有的工作线程都执行完毕，只有守护线程时，进程就会结束。所以守护线程会等待进程中所有工作线程结束，进而结束。

6. 为什么Runnable中的run方法会运行在子线程中? 

   1. 有赖于Threa类的设计。

7. 简述3种多线程实现方式的区别? 

   1. 继承Threa类最朴实无华，但这种方式将线程和任务绑定，不推荐。

   2. 基于Runable和Callable接口创建实现类对象，都是表示一个任务，这样就把线程和任务解绑了，使用起来更加灵活。

   3. 这两个接口分别代表两种不同的任务，Runable任务表示无返回值的任务，Callable表示有返回值的任务。

8. 什么是死锁?怎么解决? 

   1. 多个线程间，如果互相等待对方的锁资源就会造成互相等待、互相阻塞的现象。

   2. 注意加锁的嵌套顺序即可。

9. wait方法与sleep方法有什么区别? 

   <font color=red>**所属的不同：**</font>

   1. wait：属于Object类的成员方法。
   2. sleep：属于Thread类的静态成员方法。

   <font color=red>**使用条件的不同：**</font>

   1. wait：**必须是锁对象调用该方法。**
   2. sleep：在任何线程中都可以使用，无附加条件。

   <font color=red>**唤醒条件不同：**</font>

   1. wait：需要在其他线程中，在同一个锁对象上，调用notify或notifyAll方法。
   2. sleep：休眠的时间到了，线程主动苏醒。

   <font color=red>**休眠时的表现不同（最核心区别）：**</font>

   1. wait：该方法导致的线程休眠，会使得一个线程主动释放锁对象，将锁对象让给别的线程。
   2. sleep：线程因该方法导致休眠阻塞时，该线程不会放弃锁对象，会一直持有锁对象。

10. `synchronized` 同步代码块中的锁对象是谁?同步方法中锁对象是谁?静态方法?

    1. 同步代码块中的锁可以使用任意对象，但要保证不同线程使用同一把锁，这样才能实现线程同步。

    2. 同步方法的锁对象是当前对象，也就是this

    3. 静态同步方法的锁对象是当前类的运行时类对象（Class对象）

11. 为什么`wait ` `notify`方法是定义在Object中 而不是在Thread中?

    因为锁对象可以是任意对象，那么唤醒等待的方法自然要定义在Object类当中，这样不同类型的锁对象才能调用这些方法实现等待唤醒机制。

## 网络编程

### UDP

#### 填空

- UDP以( 数据报包) 方式进行传输.

- UDP发送端步骤( B), (C ), ( A), ( E)

  - > A. 发送数据报包到目的IP的目的端口(send方法)
    >
    > B. 创建UDP的socket对象
    >
    > C. 将要发送的数据封装到数据报包
    >
    > E. 释放资源
  
- UDP接收端步骤( B), ( C) , ( A), ( D)，E 

  - > A . 接收数据报包(receive方法)
    >
    > B. 创建接收端的Socket对象
    >
    > C. 创建用于接收端的数据报包
    >
    > D. 解析数据报包中的数据
    >
    > E. 释放资源

- 通过( getAddress()  )API获取InetAddress对象

- 通过( DatagramPacket(byte[] buf, int length, InetAddress address, int port)  )构造方法创建用于发送的数据报包对象DatagramPacket对象

- 通过(  DatagramPacket(byte[] buf, int length)  )构造方法创建用于接收的数据报包对象

- 通过( byte[] getData()   )API获取数据报包中的信息 

#### 简答题

1. UDP协议什么特点?   
   1. 面向无连接，通过数据报包传递数据，效率较高但不稳定不安全。

2. 端口号可用范围?
   1.  端口号是一个[0,65535]内的整数,可以随便填但是尽量不要用[0,1023] 这些端口号是系统使用或保留的端口号

3. 先启动接收端还是发送端? 如果先启动发送端会报错吗? 
   1. UDP是无连接的传输协议，所以谁先启动都无所谓，都不会出现错误。

   2. 但如果发送端先启动，发送端直接发送数据，然后再启动接收端接收，肯定是接收不到数据的。所以为了能够正常接收数据，应该先启动接收端，再启动发送端。

4. 端口号被占用会有什么异常? 
   1. BindException: Address already in use: Cannot bind


### TCP

#### 填空题

- TCP以( IO流 ) 方式进行传输

- TCP客户端的步骤是(B  )   (C  )    (  A)  ( D )   

  - > A. 从流中读写数据
    >
    > B. 创建客户端Socket对象
    >
    > C. 从Socket对象中获取输入输出流
    >
    > D .释放资源

- TCP服务端的步骤是(B )  ( C )   ( D )  ( E )   （A）

  - > A. 释放资源
    >
    > B. 创建服务端Socket对象(ServerSocket)
    >
    > C. 建立连接(accept)
    >
    > D. 从socket中获取输入输出流
    >
    > E. 从流中读取写入数据

#### 简答题

- TCP协议什么特点? 
  - 面向连接的，以IO流的形式传输数据，安全稳定可靠但相对效率较低（因为要耗费性能建立稳定连接）

- 有1个服务端,多个客户端的时候怎么办?
  -  多线程，一个服务端线程处理一个客户端连接。服务端还可以使用线程池技术提升性能


## 反射

### 选择题

- 编译java源文件产生的字节码文件的扩展名是什么( B)?

> A. java 		B. class 		C. html 		D. exe

- 下面关于Class类对象的实例化对象取得,错误的是( B 显然Class类没有对外提供这种途径获取Class对象)

> A. 利用Object类中的getClass方法
>
> B.利用Class类的构造方法取得
>
> C.利用类.class方法取得
>
> D.通过Class.forName() 取得

- 下面的Class类中的方法.( A  ) 可以取得指定类型中全部public方法的定义

> A. public Method \[] getMethods()
>
> B. public Field [] getFields()
>
> C. public Field [] getDeclaredFields()
>
> D. public Constructor [] getConstructors()

### 填空

1. 忽略java语法检查使用哪个API ( `setAccessible(true)` )
2. 从.properties文件中获取相应Key对应的value,应该用哪个API ( `getProperty(key)`)
3. 使用字节码文件对象(Class对象)可以直接实例化对象, 有一个前提条件是( 这个类有默认无参构造器 )

### 简答题

1. 类加载过程是什么? 

   1. 加载 --> 连接 --> 初始化

2. jvm规范中的类加载时机是哪些? 

   1. 启动main方法，new对象，访问静态成员，触发子类类加载优先类加载父类，反射获取Class对象

3. 类加载器都有哪些? 

   1. 根类加载器`Bootstrap ClassLoader` 
   2. 扩展类加载器`Extension ClassLoader `
   3. 系统类加载器`System ClassLoader `
4. 双亲委派模型是什么? 无需了解

5. 什么是反射技术? 

   1. 反射是提供获取运行时类信息的一种技术，或者更通俗一点反射技术就是操作一个类的Class对象。

6. 带declared跟不带的API有什么区别? 带s跟不带s的API有什么区别? 

   1. 带declared可以获取非public，否则只能获取public。

   2. 带s则表示获取所有，方法会是一个无参方法，返回值类型是一个数组。不带s则表示获取某一个，方法需要传入一定的参数。

7. 获取字节码文件对象的方式有哪三种? 

   1. 依赖于Object类的成员方法——getClass方法。这是比较少用到的一种获取Class对象的方式。

   2. 通过<font color=red>**类名/接口名.class**</font>获取到该类型对象（任意数据类型都具备一个class静态属性获取Class对象）

   3. 通过Class类的静态方法：

      ```` java
      Class<?> forName(String className)
      ````

      该方法需要传入某个类型的全限定类名。

## 注解

### 选择题

- 下面哪个不属于java语言? B

> A. // 注释		B. -- 注释 		C. /** 注释 */ 		D. / * 注释*/

### 填空

- 定义注解的关键字是什么( `@interface `)

- 使用value作为注解的属性时,有一个前提条件是( 注解的属性只有一个 )
- 给注解设置默认值的关键字是( `default`  )
- 注解的默认保留级别是( `RetentionPolicy`会进入class文件，但类加载时被忽略，不影响代码执行  )
- 想要把注解加到成员变量上, 应该使用( `@Target` )注解的( `ElementType.FIELD` )属性
- 判断是否使用了注解使用哪个API( `isAnnotationPresent` )
- 获取注解实例使用哪个API( `getAnnotation` )

### 简单题

1. `@Target`注解作用是啥? 
   1. 作用是定义注解可以修饰的目标

2. `@Retention`注解作用是啥? 
   1. 设置注解的保留级别，即该注解生效的范围。

3. 注解的属性可以是哪些数据类型?
   1. 基本数据类型
   2. `java.lang.String`
   3. `java.lang.Class`
   4. 枚举`enum`
   5. 注解
   6. 以及上述类型的数组


## GC

### 简答题

1. jvm运行时数据区怎样划分的?

   1. 哪些是线程私有的? 私有 JVM栈，本地方法栈，程序计数器
   2. 哪些是共享的? 共享的 方法区 堆

2. 显式内存管理与隐式内存管理的特点?

   1. 显式的优点?  效率高 可控性强
   2. 显式的缺点? 程序容易因内存管理不当出现各种问题
   3. 隐式的优点? 程序可靠性更强，简单
   4. 隐式的缺点? 耗费性能，不可控，效率较低

3. 什么是内存泄漏? 某一片内存空间申请使用后已经应该释放掉，但迟迟没有释放，导致该片区域无法再次被使用

4. 引用计数法思想是什么? “GC Roots”对象或者“GC Roots”对象引用的对象都不是垃圾，否则就是

   - 弊端是什么?  循环引用的问题解决不了

5. 根搜索算法思想是什么?  

   1. 哪些可以作为GC Roots?  虚拟机栈(JVM栈)中引用指向的对象，静态成员变量引用指向的对象

6. 标记清除算法思想是什么? 直接回收标记为垃圾的对象内存区域

   - 弊端是什么 这样简单粗暴的垃圾回收会导致大量不连续的内存空间出现

7. 标记复制算法思想是什么? 将内存区域划分成两个部分A和B，一次垃圾回收直接清空A区域，然后将A区域中需要保留的对象复制到B区域中。优点是解决了回收后内存空间不连续的问题。

   - 弊端是什么? 当出现大量对象需要保留，需要进行复制时，效率会非常低。反之需要复制保留的对象很少或者几乎没有时，效率很高。

8. 标记整理算法思想是什么? 将内存中需要保留的对象前移，回收后面所有的内存空间。这样也解决了回收后内存空间不连续的问题

   - 弊端是什么? 当需要整理移动的对象非常多时，效率很低。理想情况下，所有对象都保留，都不需要回收时，就几乎不用移动对象，这样效率会很高。

9. 分代收集理论

   - 2个假说是什么?
   
     弱分代假说（Weak Generational Hypothesis）: 绝大多数对象都是朝生夕灭的.
   
     强分代假说（Strong Generational Hypothesis）：熬过越多次垃圾收集过程的对象就越难以消亡。(简单理解就是越老的对象就具有”老而不死”的特性)
   
   - 分代收集算法分为哪两个代?  新生代和老年代
   
   - 新生代分为哪些区域? eden和两个survivor区域
   
   - 什么时候新生代的对象被移动到老年代? 熬过15次垃圾回收的对象都会成为老年代对象
   
   - 新生代采用什么算法回收垃圾? 标记复制
   
   - 老年代采用什么算法回收垃圾? 标记整理
   
   


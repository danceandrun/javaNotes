# 网络编程

Java网络编程就是实现**两个Java进程之间的数据交换**。这两个进程只需要在同一个网络上就行，不需要在同一台计算机上。

> 请描述一下HTTP协议。（问Java EE 的入口题目）

## 注意事项

### 本地IP地址的获取

在Java程序中，用`java.net.InetAddress`类的对象来表示一个IP地址

> 注意IP地址不是用字符串来表示的

InetAddress

```Java
// 打印本地主机名 + ip地址
System.out.println(InetAddress.getLocalHost());
// 打印本地主机名
System.out.println(InetAddress.getLocalHost().getHostName());
// 打印本地主机ip地址
System.out.println(InetAddress.getLocalHost().getHostAddress());
```

```java
InetAddress targetIp = InetAddress.getByName("Ip地址");
```

### 有关端口号

是一个在[0,65535]范围内的整数，其中[0,1023]是操作系统保留的端口号，一般不建议写。比如80常用作web服务器端口号。

🟡 **端口号是网络通信中进程的唯一编号。**一旦重复，Java程序会抛出异常。

### UDP协议

> 面向无连接的、不可靠的。但效率更高的传输方式

🟡 最大特点：*要求传输的过程中将数据封装成**数据报包**然后进行传输。*

# Java网络编程

## Socket的概念

所谓的Java网络编程就是基于`Socket`对象的通信来实现的。网络通信就是`Socket`间的通信。

套接字的特点是屏蔽了协议的具体特点。

简单来说 `Socket`就是`IP+port`

## UDP编程

### API

#### 发送端思路

1. 创建发送端的`Socket`对象，此时要创建的是`java.net.DatagramSocket`对象。

   🟡 创建发送端`Socket`对象需要哪些参数呢？

   **什么都不需要**

   > `Datagram`就是数据报的意思

2. 把要发送的消息封装成数据报包的形式。此时要创建的是`java.net.DatagramPacket`对象。

   🟡创建发送端要发送的数据报包需要哪些参数呢？

   需要发送的数据，接收端的IP地址和端口号

3. 发送端将数据报包发送给接收端，依赖于`DatagramSocket`对象的成员方法`send(DatagramPacket)`

4. 酌情关闭`Socket`，释放资源

#### 接收端思路：

1. 创建发送端的`Socket`对象，此时要创建的是`java.net.DatagramSocket`对象。

   🟡创建接收端`Socket`对象需要哪些参数呢？

   必须指明IP地址和端口号，要和发送端发送的数据报包指出的一致

2. 接收端准备接收数据包数据。需要创建一个新的、空的数据报包。此时要创建的是`java.net.DatagramPacket`对象。

   🟡 创建接收端要发送的数据报包需要哪些参数呢？只需要一个接收数据的容器就可以了

3. 接收端将数据报包发送给接收端，依赖于`DatagramSocket`对象的成员方法`receive(DatagramPacket)`

   `receive`方法需要一个空的、接收数据的数据报包

4. 处理收到的数据报包，依赖于`DatagramPacket`对象的成员方法。

> 有很多方法。
>
> // 返回数据缓冲区，即数据包封装的字节数据
> byte[] getData()
> // 返回将要发送或接收到的数据的长度。
> int getLength()         
> // 返回将要发送或接收到的数据的偏移量。
> int getOffset()        
> // 获取数据包（要发送到的或者发送者）的IP地址
> InetAddress getAddress() 
> // 获取数据包（要发送到的或者发送者）的端口号
> int getPort() 
> // 获取数据包（要发送到的或者发送者）的IP地址和端口号
> SocketAddress getSocketAddress()

要注意上述发送端和接收端的过程中需要的参数和构造器。

5. 酌情关闭`Socket`，释放网络资源。

🟡 注意事项

1. 面向无连接的，先启动哪一端都不会报错。但是要正常运行得先启动接收端。

2. ⭐⭐ 接收端有个阻塞状态。`Socket`下的`receive`方法是一个典型的阻塞方法，接收端调用此方法，会一直阻塞等待发送端发送数据报包。只有接收到发送端的数据报包后，

3. 如果端口号是自己手动给出的,是有概率被占用的,此时程序会抛出异常
   *      `java.net.BindException: Address already in use: Cannot bind`


## 使用工具类优化

因为有代码的重复所以可以提取出方法

1. 发送端构建传输数据的数据包时，基本的代码形式是一致的。
2. 接收端接收传输的数据包时，基本的代码形式也是一致的。
3. 接收端解析接收到的消息时，基本的代码形式也是一致的。

## 单线程环境下相互发送字符串消息

在单线程环境下：

1.作为发送端，为了能够多次发送消息，需要键盘录入

2.作为接收端，为了能够接收消息，需要使用DatagramScoket的成员方法receive。

> 这两个方法都是阻塞方法。
>
> 在单线程环境下，最多只能被一个阻塞方法阻塞，不可能同时出现两个阻塞方法调用。
>
> 那么：
>
> 同一个进程，假如一个开始作为发送端，那么它就只能是发送端，当然发送完毕后，它就又可以作为接收端了...
>
> 同一个进程，假如一个开始作为接收端，那么它就只能是接收端，当然接收完毕后，它就又可以作为发送端了...
>
> FisrtSender
>
> FirstReceiver

在单线程环境下，巧妙地利用阻塞方法实现互为接收端和发送端。

该方法有个缺点，只能发一次之后就阻塞了。

## 多线程优化

在一个进程中，启动两个线程，其中一个线程用于执行接收端的任务，另一个线程用于执行发送端的任务。多线程下，并发执行，一个进程就同时具备了接收端和发送端的功能。

## TCP编程

TCP（Transmission Control Protocol，传输控制协议）编程的实现，首先和UDP一样，都需要创建相应的Socket对象然后基于Socket对象来进行通信。

但是注意TCP协议的特点是面向连接的、可靠的、**基于字节流**的通信协议。

> 面向连接就是需要区分客机和主机
>
> C/S：客户端和小程序 （Client/Server）
>
> B/S：网站 (Browser/Server)
>
> 两个架构之间界限逐渐模糊

**所以TCP需要先建立连接再进行传输，并且传输的过程通过IO流的形式出现（TCP网络编程需要使用Java IO）。**

**TCP通信是严格区分客户端与服务端的，在通信时，必须先由客户端去连接服务端才能实现通信，服务端不可以主动连接客户端，并且服务端程序需要事先启动，等待客户端的连接。**

在Java代码中，java.net.Socket类和java.net.ServerSocket类分别表示客户端和服务端的套接字，创建它们的对象就表示创建客户端套接字和服务端套接字。

> 和UDP通信的不同：
>
> java.net.DatagramSocket类
>
> java.net.DatagramPacket类
>
> UDP发送端和接收端启动顺序不会报错，但是为了正常通信应该先启动接收端。

通信时，首先创建代表服务端的ServerSocket对象，然后开启服务端的服务等待客户端的连接；随后创建代表客户端的Socket对象向服务端发出连接请求，服务端响应请求，**两者开始建立连接，形成稳定的数据通道**，然后开始通信。

最后仍然需要关闭资源，客户端一般用完就会关闭，服务端可酌情考虑是否关闭。

### 服务端的思路

1.创建一个服务端的Socket对象。java.net.ServerSocket。

🟡 需要的参数：

此服务端的IP地址和端口号

> 此时要一直等待客户端连接，需要一个阻塞方法

2.调用SeverSocket对象的成员方法accept，持续监听端口，等待客户端的连接

在TCP编程中，通过Socket对象在客户端和服务端之间建立了一个可靠稳定的、基于字节流的连接。

3.客户端已经成功连接服务端

（重点）

 ⭐accept方法的返回值是一个java.net.Socket类型，也就是一个Socket对象。

这个对象就是建立在客户端和服务端之间的数据通道。

一个代表客户端和服务端之间的一个稳定的数据通过

> 此时站在服务端的视角，把自身服务端当成内存，把网络连接的另外一端当成外存
>
> 如果服务端想要获取客户端发送的消息，这相当于从外存将数据读取到内存，需要从Socket对象当中获取输入流

只有从Socket对象这个稳定的数据通道中获取的IO流才能用于进行数据通信。如果是自己创建的IO流是不能进行网络通信的

4.通信完毕，酌情关闭服务端

### 客户端思路

1.创建一个客户端的Socket对象。java.net.Socket。

创建客户端对象就直接表示连接目标服务端，所以需要知名服务端的IP地址和端口号。

🟡 需要的参数：

服务端的IP地址和端口号

>  🟡创建对象就表示连接服务端了，不需要再调用额外的方法。
>
> 服务端没有启动时创建对象的语句会报错（Connection Refused），所以某种程度上，创建过程也是一个阻塞方法

2.创建客户端

于是客户端就已经和服务端建立起了稳定的数据通道

3.同样的，此Socket对象本身就是一个稳定的数据通道。下面的代码中，可以通过Socekt对象当中的IO流进行和服务端的数据通信

（重点）

>  🟡重点搞清楚Socket输入输出是什么
>
> 此时站在客户端的视角，把自身客户端当成内存，把网络连接的另外一端（服务端）当成外存
>
> 如果客户端端想要获取服务端发送的消息，这相当于从外存将数据读取到内存，需要从Socket对象当中获取输入流

只有从Socket对象这个稳定的数据通道中获取的IO流才能用于进行数据通信。如果是自己创建的IO流是不能进行网络通信的

4.通信完毕，酌情关闭客户端

## V1 TCP实现

> 一个客户端连接一个服务端，客户端向服务端发送一条消息

因为是字节流所以可以进行包装

注意包装的过程

```Java
InputStream in = socket.getInputStream;
new BufferedReader(new InputStreamReader(in));
```

## V2 TCP实现

> 单个客户端多次发送，服务端也要多次接收

🟡 IO流当中有个阻塞方法

read（）：在输入数据可用、检测到流末尾或者抛出异常前，此方法一直阻塞

 🟡在网络IO中，它什么时候结束阻塞呢？

1.异常

read方法自己产生了异常，导致代码终止执行，或者catch捕获做异常处理，这些都会导致read方法执行完毕，不再阻塞；最常见的是ScoketExeption.

2.明确从对方发送的数据中读取到了数据，此时方法会返回一个结果，比如read()会返回读取到的字节值

3.对方的Socket资源已经关闭，此时read方法会返回-1，会结束阻塞

## V3 TCP实现

> 多个客户端多次发送，服务端接收（多线程处理）

多线程场景的特点：

客户端连接数量不确定，客户端连接后可能很快就结束，也可能进行一些数据通信再结束。

该场景符合线程池应用场景。

服务端的连接任务，每一个任务让一个线程执行，处理一个客户端任务

需要传参：Socket

## V4 TCP实现

客户端发送对象（序列化），服务端来接收

>序列化步骤
>
>1.实现Serializable接口
>
>2.明确生成一个序列化UID

将一个对象写到服务端去，要用对象流-序列化流，此时需要进行包装.

## V5 TCP实现  ⭐FileUpload

> V1
>
> 文件上传，客户端向服务端发送一个文件，服务端收到文件后，要把这个文件存在本机的一个文件中

分析客户端当中数据的流向：

客户端外存--->客户端内存---->通过Socket发送给服务端（外存）

分析服务端当中数据的流向：

通过Socket将客户端发送的文件数据---->服务端内存---->服务端本机内存

>V2
>
>服务端接收后存在本机文件中，并且向客户端响应，发一个消息”我已接收成功“

V1中Client写完数据后立刻关闭了资源

 🟡此时TCP两个进程都由于read方法阻塞了，客户端的read方法，需要read服务端的反馈

>V3
>
>服务端接收文件上传的过程中，可以发送反馈

### **read方法中结束阻塞的条件**⭐⭐ 

​	1. 异常

read方法自己产生了异常，导致代码终止执行，或者catch捕获做异常处理，这些都会导致read方法执行完毕，不再阻塞；最常见的是ScoketExeption.

​	2. 明确从对方发送的数据中读取到了数据，此时方法会返回一个结果，比如read()会返回读取到的字节值

​	3. 对方的Socket资源已经关闭，此时read方法会返回-1，会结束阻塞

Socket流的半关闭。此时read方法会返回-1，会结束阻塞。⭐⭐⭐ 

>Socket流分为输入流和输出流

```java
socket.shutdownInputStream
```



> V4
>
> 如果不想进行半关闭，在文件上传后，还希望继续进行输出操作，那该怎么办？
>
> 在上传结束后给标记
>
> 可行的方法：
>
> 1.客户端事先告诉服务端上传文件的大小，在服务端控制循环次数
>
> ​	利用数据输出流直接操作基本数据类型
>
> 2.告诉一个结束字符，服务器进行判断



> **三次握手和四次挥手**
>
>  🏷️三次握手
>
> 建立TCP连接时需要进行三次握手，这是为了确保通信双方的状态同步和可靠性。以下是每一次握手的目的：
>
> 1. **第一次握手（SYN）：**
>    - 客户端发送一个TCP报文，其中包含SYN（同步序列号）标志位。
>    - 客户端进入SYN_SENT状态，表示客户端已经请求建立连接。
>
> 2. **第二次握手（SYN + ACK）：**
>    - 服务器收到客户端的SYN报文后，会回复一个带有SYN和ACK标志位的TCP报文。
>    - 服务器进入SYN_RCVD状态，表示服务器已经收到客户端的连接请求，并同意建立连接。
>    - 客户端收到服务器的响应后，进入ESTABLISHED状态。此时，客户端和服务器都已经完成了一次握手。
>
> 3. **第三次握手（ACK）：**
>    - 客户端收到服务器的带有SYN和ACK标志位的响应后，向服务器发送一个带有ACK标志位的TCP报文。
>    - 服务器收到客户端的ACK后，进入ESTABLISHED状态，表示服务器和客户端都已经完成了握手。
>    - 客户端和服务器之间的TCP连接建立完成，可以开始进行数据传输。
>
> **目的解释：**
>
> - **第一次握手（SYN）：** 客户端告诉服务器它想建立连接，并指明初始序列号，客户端进入SYN_SENT状态。
>
> - **第二次握手（SYN + ACK）：** 服务器收到客户端的请求后，表示同意建立连接，回复一个带有确认号和自己的初始序列号的报文，服务器进入SYN_RCVD状态。
>
> - **第三次握手（ACK）：** 客户端收到服务器的响应后，向服务器发送确认号，服务器收到后进入ESTABLISHED状态，客户端也进入ESTABLISHED状态。此时，连接建立完成，双方可以开始进行数据传输。
>
> 通过三次握手，通信双方可以确保彼此都能够发送和接收数据。如果只有两次握手，可能会导致一些问题，例如在客户端发送连接请求后，由于网络延迟或其他原因，服务器可能收到连接请求并响应，但客户端却未收到服务器的响应，这样就无法建立可靠的连接。通过三次握手，可以避免这类问题。
>
> 🏷️ 四次挥手
>
> 断开TCP连接时需要四次挥手是为了确保双方都能够安全、可靠地关闭连接。每一次挥手的目的如下：
>
> 1. **第一次挥手（FIN）：**
>    - 主动关闭连接的一方（通常是客户端）发送一个带有FIN（Finish）标志位的TCP报文。
>    - 客户端进入FIN_WAIT_1状态，表示客户端已经没有数据要发送，但仍能接收数据。
>
> 2. **第二次挥手（ACK）：**
>    - 被动关闭连接的一方（通常是服务器）收到带有FIN标志位的TCP报文后，向客户端发送一个带有ACK标志位的TCP报文，确认收到了关闭请求。
>    - 服务器进入CLOSE_WAIT状态，表示服务器已经准备好关闭连接，但仍然可以接收数据。
>
> 3. **第三次挥手（FIN）：**
>    - 被动关闭连接的一方（服务器）也决定关闭连接，发送一个带有FIN标志位的TCP报文。
>    - 服务器进入LAST_ACK状态，表示服务器已经没有数据要发送，但仍能接收数据。
>
> 4. **第四次挥手（ACK）：**
>    - 主动关闭连接的一方（客户端）收到服务器的FIN后，向服务器发送一个带有ACK标志位的TCP报文，确认收到了关闭请求。
>    - 客户端进入TIME_WAIT状态，等待一段时间（两倍的报文最大生存时间，以确保服务器收到了确认），然后关闭连接。
>
> **目的解释：**
>
> - **第一次挥手（FIN）：** 客户端告诉服务器，它已经没有数据要发送了，希望关闭连接。
>
> - **第二次挥手（ACK）：** 服务器收到客户端的关闭请求后，向客户端发送一个确认，表示已经收到关闭请求，并告诉客户端，服务器还有一些数据需要发送。
>
> - **第三次挥手（FIN）：** 服务器告诉客户端，它已经没有数据要发送了，希望关闭连接。
>
> - **第四次挥手（ACK）：** 客户端收到服务器的关闭请求后，向服务器发送一个确认，表示已经收到关闭请求。这时客户端进入TIME_WAIT状态，等待一段时间以确保服务器收到了确认，然后关闭连接。这个等待时间是为了确保在网络中的所有数据都被完全传输。


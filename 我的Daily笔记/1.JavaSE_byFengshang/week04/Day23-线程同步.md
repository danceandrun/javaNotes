# 线程同步

> 多线程的异步特点，导致了多个线程在处理共享数据时会出现数据安全问题。让多个线程在访问共享数据时，同步执行，以解决数据安全问题，这就是**“线程同步”**。

在解决引入Redis导致的缓存穿透，缓存雪崩，缓存击穿问题的过程中，使用到了加锁的知识。虽然最后使用了商业上的Redisson的成熟实现API，但是背后的原理要学习了解。

## Synchronized

🟡 `synchronized`关键字

> 线程的数据安全问题的引入
>
> > 现在开发一个软件，模拟影院售票窗口售票服务，要求如下：
> >
> > 1. 一共只卖100张
> >
> > 2. 影院有三个售票窗口，同时卖，互不影响
>
> 出现“一票多卖”“超卖”的现象：
>
> 一票多卖：
>
> + 如果三个线程并行执行，一定会卖同一张票
>
> + 如果某个线程在ticketNum++之前发生了切换，也会导致已售卖的票并没有及时被扣除
>
> 超卖：
>
> + 最极端的情况：假如三个线程都进入了while循环（且此时ticketNum = 100），A线程打印输出卖了第100张票，然后ticketNum++,ticketNum = 101;但是此时B和C线程都已经进入了while循环，while不能限制它们
>
> B线程输出打印101，ticketNum++,ticketNum = 102;
>
> C线程输出打印102，ticketNum++,ticketNum = 103;
>
> 归根结底，之所以出现售票数据混乱情况的出现，

之所以产生数据安全问题，有如下三点原因：

1. 多线程下的程序运行特点导致。
2. 多线程下的线程共享数据需求导致。
3. **某个线程在执行一个需要访问共享数据任务的<u>任意过程中，都有可能发生线程切换</u>，其余线程也会执行这个任务。**

> 原子操作：数据库事务也会提到该问题

同时卖就要求数据共享。

在JVM中，方法栈都是线程私有的，而堆和方法区都是线程共享的。

> 方法区存静态成员变量

使用关键字`synchronized`实现原子操作。

### 同步和异步

同步：有多个任务需要执行时，必须一个接一个的执行，类似于过独木桥。

异步：允许同时执行多个任务，各自执行各自的，互不干扰。

同步和异步的最大区别是需不需要等待，同步必然带来等待，而异步不需要等待。**多线程天生就是异步的，多个线程可以同时执行任务，互不影响。**

多线程的异步特点，导致了多个线程在处理共享数据时会出现数据安全问题。让多个线程在访问共享数据时，同步执行，以解决数据安全问题，这就是**“线程同步”**。

实现线程同步，在Java中比较常见的做法就是`synchronized`关键字。

![线程同步](.\assets\线程同步.png)

线程切换是操作系统线程调度方案决定的，Java本身是改变不了的，**线程同步也不是通过禁止线程切换来实现的**。

所谓的线程同步更像是**加锁**，使用“锁”将一些关键性的操作“锁定”成为“原子操作”。当某个线程正在执行“原子操作”且没有执行完毕时，即便线程切换到其它线程，其它线程也只会进行等待，而不会执行被锁定的“关键操作”。

比如上图的案例中，我们将一整个“打印售票信息，扣除票数库存，睡眠等操作“，锁定成一个原子操作后，A线程率先执行该原子操作，在A线程执行的过程中，CPU执行权即便切换到B和C线程，也必须等待A线程执行完一次原子操作。当A线程执行完一次原子操作后，ABC再进行新的一轮争抢。

### 同步代码块

代码块有3个静态代码块、成员代码块，同步代码块

使用synchronized关键字修饰的局部代码块

```java
synchronized(锁对象){
    //同步区域
}
```

解释：

1.  “锁对象”是用于给多个线程来共同竞争的锁资源

2.  🟡**为了实现线程同步，一个进程中的多个线程使用同一个“锁对象”。**一般写`Object`类，使用`private final static`修饰。
3.  同步代码块中的同步区域，就是一个原子操作，要么都不执行，要么全部执行
4.  `synchronized`关键字实现的加锁，是一把**“可重入锁”**。也即是释放该锁之后可以再次参与锁的竞争。

> 可重入锁：
>
> 一个线程获取、释放锁后，还可以立刻马上再次获取这个锁。

代码实例

```java
private static final synchronized o = new Object;
public void run(){
    while(true){
        synchronized(o){
            if(ticket <= 100){
                try{
                    TimeUnit.SECONDES.sleep((long)(Math.random()*50));
                }catch(InteruptedException e){e.printStack()}
            }
        }
    }
}
```

注意： 线程切换是多线程固有特点，线程同步不是禁止线程切换。

### 同步（成员）方法和静态同步方法

#### 同步方法中有`this`

同步方法，指的是**用`synchronized`关键字修饰成员方法**。同步方法的目标也是为了实现线程同步，它的原理和同步代码块也是一样的。区别是：

1. **同步方法的锁对象是`this`指向的当前对象。**
2. **一整个成员方法就是一个原子操作。**

语法

```Java
[访问权限修饰] synchronized 返回值类型 方法名（形参列表）{
   //方法体 
}
```

一个类当中，如果所有的修改自身成员变量的成员方法，都是`synchronized`修饰的同步方法

> 🟡 `StringBuffer`，`StringBuilder`以及`String`的区别？
>
> 首先，`String`是不可变字符串，它的状态是不可变的，所以它是线程安全的；
>
> 而`StringBuffer`和`StringBuilder`都是可变字符串，所以在多线程环境下，它们存在修改共享数据的安全问题。
>
> 其中`StringBuffer`是线程安全的，**因为类中所有的成员方法修改`value`取值都是同步方法**，而StringBuilder是线程不安全的，其中所有方法都不是同步方法。
>
> 总结：使用可变字符串，如果单线程下，那么用`StringBuilder`因为它效率高。
>

#### 静态同步方法没有`this`，用`Class`对象

静态同步方法，指的是**用`synchronized`关键字修饰的静态成员方法**，类比于同步代码块：

1. **静态同步方法的锁对象是该类型的字节码`Class`对象。**

2. **一整个静态成员方法就是一个原子操作。**

```java
[访问权限修饰符列表] static synchronized 返回值类型 方法名（形参列表）{
//方法体
}
```

获取类的对象：

*      静态同步方法的锁对象是该类型的字节码`Class`对象。
*      一整个静态成员方法就是一个原子操作。

#### 线程同步的执行

1. `sleep()`方法在线程同步过程中的用途？

2. 线程同步过程中，出现异常怎么办？

>1. `sleep()`方法在线程同步过程中的用途？某个线程由于`sleep()`方法进入阻塞等待的状态，那么它会在这个过程中释放锁吗？
>
>   不会释放锁（这是`sleep()`方法最重要的特点）。`sleep()`方法会让线程进入等待阻塞状态，并且此线程拿到的锁对象并不会释放，等到阻塞时间结束，此线程会继续执行，直到执行完毕同步区域后，才会释放锁对象。
>
>2. 线程同步过程中，出现异常怎么办？
>
>   某个线程在获取锁执行同步区域的过程中，如果由于异常抛出线程终止，那么此线程会**释放锁对象！**（释放锁对象之后会再抢而不是放弃锁对象）
>


```java
public class Demo {
    // 定义一把锁
    public static final Object OBJECT = new Object();
    public static void main(String[] args) {
        // 创建并启动A线程
        new Thread(() -> {
            System.out.println("A线程开始执行!");
            for (int i = 0; i < 30; i++) {
                // 使用同步代码块,定义一个原子操作
                synchronized (OBJECT) {
                    System.out.println("A线程第" + (i + 1) + "次拿到了锁对象!");
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println("A线程第" + (i + 1) + "次释放锁对象!");
                }
            }
            System.out.println("A线程执行完毕!");
        }).start();    
// 主线程休眠1秒钟,这样可以大概率保证A线程先执行
    try {
        Thread.sleep(1000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    // 创建并启动B线程
    new Thread(() -> {
        System.out.println("B线程开始执行!");
        // 注意要使用同一把锁
        synchronized (OBJECT) {
            System.out.println("B线程拿到锁对象!");
            try {
                // 休眠一秒钟
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("B线程释放锁对象!");
        }
        System.out.println("B线程执行完毕!");
    }).start();
}
}
```
> （面试常考⭐⭐ ）`sleep()`和`wait()`的区别？
>
> `sleep()`和`wait()`方法在Java多线程中都用于暂停线程的执行，都会让线程处于阻塞状态，但它们之间有一些关键区别：
>
> 1. **所属类不同：** `sleep()`方法是`java.lang.Thread`类的静态方法，而`wait()`方法是`java.lang.Object`类的方法。
> 2. **调用位置不同：**`sleep()`方法可以在任何地方调用，而`wait()`方法必须在**同步方法或同步代码块**中调用。
> 3. **锁释放（最重要的区别）：** 调用`sleep()`方法时，它不会释放任何已持有的锁。线程在休眠期间仍然保持对锁的控制，其他线程无法访问被锁定的资源。而当线程调用`wait()`方法时，它会释放当前对象上的锁，允许其他线程进入同步代码块并获取锁。
> 4. **唤醒机制：**当线程的`sleep()`方法的休眠时间到达时，线程会自动唤醒并继续执行。而`wait()`方法需要等待其他线程调用同一个对象上的`notify()`或`notifyAll()`方法才能唤醒。
>
> 总结：`sleep()`方法主要用于暂停线程一段时间，让出CPU资源，但不释放已持有的锁；而`wait()`方法则**用于线程间的通信**，让线程等待某个条件满足后才继续执行，并在等待时释放已持有的锁。`sleep()`方法由`Thread`类提供，而`wait()`方法由`Object`类提供。`sleep()`方法会在指定时间后自动唤醒，而`wait()`方法需要其他线程调用`notify()`或`notifyAll()`方法才能唤醒。

## `Lock`锁

+ 所在包是`java.util.concurrent.locks` 

+ `Lock`是一个接口

+ 使用其实现类`java.util.concurrent.ReentrantLock`

使用成员方法：

```Java
lock():实现加锁
unLock()：实现解锁
```

注意事项

 `Lock`锁不会因为线程产生异常而释放锁，`Lock`锁的释放锁必须依赖于`unLock()`方法
*      所以为了安全释放锁，必须把`unLock()`解锁的方法放入`finally`代码块。

### 两种锁的比较

**`synchronized` VS `Lock`**

`synchronized`是一把隐式的锁，程序员看不到加锁和释放锁的过程，是JVM自动完成的。

`Lock`锁则是一把真正的锁，程序员能从API代码层面看到加锁释放锁的过程。

相同点在于它们都是可重入锁，某个线程获取/释放锁后，还可以再次立刻获取锁。

知道区别后，那我们应该用什么锁？

普遍来说，`synchronized`更简单也更不容易出错，`Lock`更灵活也更容易出错，推荐优先选择使用`synchronized`。

**`Lock`解决的是`synchronized`格式比较固定的缺点，并没有解决`synchronized`效率低下的问题，它们的效率是差不多的。**

## 死锁问题

多个线程间，如果互相等待对方的资源就会造成互相等待、互相阻塞的现象。

**锁也是一种资源，如果出现两个线程都同时在等待对方的锁，这样两个线程都会停滞，这就是死锁现象。**

> 如何解决死锁问题？
>
> 1. 改变嵌套同时竞争相同锁对象
>
> 2. 套一把更大的锁对象

## 线程通信

在多线程的环境下，多个线程间虽然是并发的，互不干扰的。但也总有一些场景，需要线程间共同协助完成一项任务。对于共同协作而言，沟通与交流是必不可少的，对于线程间的协作也是如此。

这种需求，我们称之为**“线程间通信”**，本大节的所有内容都围绕着线程通信展开。

## 生产者消费者模型

生产者线程和消费者线程

```Java
public class Demo {
private static int goodsNum = 0;
private static final Object LOCK = new Object();


public static void main(String[] args) {
  System.out.println("目前商品数是" + goodsNum);
  long start = System.currentTimeMillis();
  new Thread(() -> {
      while (System.currentTimeMillis() - start <= 50) {
          synchronized (LOCK) {
              goodsNum++;
              System.out.println("生产者生产了商品,目前商品数是" + goodsNum);
          }
      }
  }).start();


  new Thread(() -> {
      while (System.currentTimeMillis() - start <= 50) {
          if (goodsNum > 0) {
              synchronized (LOCK) {
                  goodsNum--;
                  System.out.println("消费者消费了商品,目前商品数是" + goodsNum);
              }
          }
      }
  }).start();
}
}
```

生产者-消费者模型，简单版本，只使用

现在有如下新的需求：

1. 需求一：生产一个消费一个，消费之后再生产。进行轮流生产。

2. **需要更精细的控制多个线程按照一定顺序轮流执行**

> ⭐ 线程间如何实现通信呢？

> 简单来说，Java在Object类中提供了**`wait()`、`notify()`、`notifyAll()`**等方法就是用于解决**线程间通信**问题的。

但是我们不着急立刻知道这些API的功能，我们先来探讨学习一下Java多线程的**等待唤醒机制**。实际上这些方法的使用，就是这个机制的体现罢了，学会了这个机制，也就学会了这些方法。

> ⭐ 面试题:描述一下Java多线程的等待唤醒机制

> 1. A线程调用wait方法阻塞自己，立刻释放锁，等待同一把锁调用`notify()`方法来唤醒它
>
> 2. B线程获取锁后，调用`notify()`方法就会唤醒此时锁上处于等待状态的A线程
>
> 3. B同步区域执行完毕释放锁，A线程就获取了锁，A就继续执行`wait()`之后的代码，而不是从头开始执行。

看这三个方法的源代码

1. `wait()`有3个重载的方法
2. 5个方法全是本地方法，所以它们的具体实现和重写不需要考虑

3. ⭐⭐ 这三个方法的**<u>调用者对象</u>**都必须是`synchronized`同步锁对象，否则就会抛出异常——*`IllegalMonitorStateException`*。

- 这就意味着等待唤醒机制，必须配合同步代码块，同步方法以及静态同步方法使用

4. 为了能够实现“等待唤醒机制”，这三个方法的调用者应该是同一把锁对象。

## `wait()`方法使用

#### `wait()`**作用**：

使等待，暂停执行并释放锁，会无休止地等待阻塞直到被唤醒

#### `wait()`使用：

1. 使用方式：

2. **执行的特点**⭐ 

​	a. 立刻让线程阻塞，处于无限等待状态

​	b. 🟡 **立刻释放锁**

> `sleep()`方法不会释放锁

## `notify()`方法

某个锁对象调用`wait()`方法，使得某个线程进行无限等待阻塞状态，可以认为此线程在这个锁对象上处于阻塞状态。那么要想唤醒它，就必须用同一把锁对象调用`notify()`方法

**如果有多个线程等待，则唤醒其中<u>随机</u>一个线程并使该线程重新获取锁。**

执行特点：

1.立刻随机唤醒

2.不释放锁，等到执行完毕同步区域再释放锁

`notifyAll()`方法

### 一道面试题：🟡 `wait()` VS `sleep()`

> 这两个方法的作用大体上看起来差不多，都是让线程等待，最终的结果都会导致线程阻塞。但区别还是有的
>
> **休眠时的表现不同（最核心区别）：**
>
> 1. `wait()`：该方法导致的线程休眠，会使得一个线程主动释放锁对象，将锁对象让给别的线程。
> 2. `sleep()`：线程因该方法导致休眠阻塞时，该线程不会放弃锁对象，会一直持有锁对象。
>
> **所属的不同：**
>
> 1. `wait()`：属于`Object`类的成员方法。
> 2. `sleep()`：属于`Thread`类的静态成员方法。
>
> **使用条件的不同：**
>
> 1. `wait()`：**必须是锁对象调用该方法。**
> 2. `sleep()`：在任何线程中都可以使用，无附加条件。
>
> **唤醒条件不同：**
>
> 1. `wait()`：需要在其他线程中，在同一个锁对象上，调用`notify()`或`notifyAll()`方法。
> 2. `sleep()`：休眠的时间到了，线程主动苏醒。
>

### 生产者消费者模型举例

情景一：一个生产一个消费

> 多线程重点在于逻辑，想清楚为什么阻塞

情景二：两个生产两个消费

> 此时需要注意`notify()`和`notifyAll()`的区别

## 面试常问的问题

⭐**有哪些方式来实现线程同步？**

>1. 同步方法：被`synchronized`关键字修饰的成员方法，锁对象是`this`，将一整个方法视为原子操作。当一个线程执行同步方法时，其他线程必须等待此方法执行完成后才能执行该同步方法。（前提是共用同一个锁对象`this`）。
>
>    如果一个类当中的所有成员方法都是同步方法，那么该类在多线程环境下就实现了数据安全。这个类就是线程安全的类。
>
>2. 同步静态方法：被`synchronized`关键字修饰的静态成员方法，锁对象是当前类型的Class对象。
>
>3. 同步代码块：使用`synchronized`关键字和一个对象作为锁，将一整个代码块视为原子操作。当一个线程进入同步代码块时，其他线程必须等待此代码块执行完成后才能进入同步代码块。（前提是共用同一个锁对象）
>
>4. 可重入锁：Java中的`ReentrantLock`类提供了一种可重入的同步锁。相比于`synchronized`关键字，`ReentrantLock`提供了更灵活的锁定和解锁方法。多个线程也必须使用同一把锁，才能实现线程同步。

⭐**`sleep`方法和`wait`方法的区别（重点）**

>`sleep()`和`wait()`方法在Java多线程中都用于暂停线程的执行，都会让线程处于阻塞状态，但它们之间有一些关键区别：
>
>1. **所属类不同：** `sleep()`方法是`java.lang.Thread`类的静态方法，而`wait()`方法是`java.lang.Object`类的方法。
>2. **调用位置不同：**`sleep()`方法可以在任何地方调用，而`wait()`方法必须在同步方法或同步代码块中调用。
>3. **锁释放（最重要的区别）🟡：**`sleep()`方法时，它不会释放任何已持有的锁。线程在休眠期间仍然保持对锁的控制，其他线程无法访问被锁定的资源。而当线程调用`wait()`方法时，它会释放当前对象上的锁，允许其他线程进入同步代码块并获取锁。
>4. **唤醒机制：**当线程的`sleep()`方法的休眠时间到达时，线程会自动唤醒并继续执行。而`wait()`方法需要等待其他线程调用同一个对象上的`notify()`或`notifyAll()`方法才能唤醒。
>
>总结：`sleep()`方法主要用于暂停线程一段时间，让出CPU资源，但不释放已持有的锁；而`wait()`方法则用于线程间的通信，让线程等待某个条件满足后才继续执行，并在等待时释放已持有的锁。`sleep()`方法由`Thread`类提供，而`wait()`方法由`Object`类提供。`sleep()`方法会在指定时间后自动唤醒，而`wait()`方法需要其他线程调用`notify()`或n`otifyAll()`方法才能唤醒。

⭐**为什么`wait()`、`notify()`、`notifyAll()`等方法都定义在`Object`类中而不是定义在`Thread`类中？**

> 这些方法的调用对象是锁对象。因为锁对象可以是任何类型，所以必须处在Object类当中。

## 练习题

**练习题一：**

> 利用`StringBuffer`，实现三个线程轮流向缓冲区append数据。也就是线程1追加一次，线程2追加一次，线程3再追加一次....
>
> 三个线程总记共追加30次数据。
>
> **提示：可以将这些线程命名为“线程1”、“线程2”、“线程3”**

**练习题二：**

>编写两个线程,一个线程打印1-10的整数，另一个线程打印字母A-E。打印结果为12A34B56C78D910E 即按照整数和字母的顺序从小到大打印，并且每打印两个整数后，打印一个字母，交替循环打印 如何实现呢? 提示:
>
>1. 定义一个Printer类,然后定义两个方法用于打印数字和字母(用一个计数器从1开始,每打印一次就++,3的倍数次就打印字母,其余打印数字)
>2. 创建两个Task类型,然后循环中调用Printer类的两个方法用于打印数字和字母。
>3. 启动线程,执行任务
>
>**思考这个过程中需要做哪些线程同步和通信？**

## 完整的生命周期状态

> 对阻塞进行分类

1. 因没有获取sync锁而导致的线程阻塞，称之为**同步阻塞。**
2. 因执行wait方法而导致的线程阻塞，称之为**等待阻塞。**
3. 因被执行join方法以及执行sleep方法导致的线程阻塞，称之为**其它阻塞**。

> **BLOCKED**、**WAITING**、**TIMED_WAITING**都对应理论状态的**“阻塞”**。

**BLOCKED**：其中因没有获取锁对象而导致的阻塞

**WAITING**：因执行了wait方法，以及被执行join方法而导致的线程阻塞

**TIMED_WAITING**：因执行了sleep方法而导致的阻塞

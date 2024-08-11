## 线程池

### 引入

数据库、中间件中有应用，偏向底层原理。

> 线程不能重复创建，执行完当前任务之后会被`GC`。每次销毁和重新创建会浪费资源，为了重复使用，引入线程池概念

### 概念

**线程池，其实就是一个容纳多个线程的*容器*，其中的线程可以反复使用，除去了频繁创建/销毁线程对象的操作，无需反复创建线程而损耗不必要的资源。**

也就是说：

如果需要**频繁创建线程**来使用，这种情况下使用线程池可以更好的提高性能。尤其在当前程序需要创建大量的**生存周期很短的线程**时，更应该考虑使用线程池。

> 比如网络登录连接时创建的线程

### 组成

一张图

1. 装线程对象的容器

>作为一个对象容器，一般设置两个参数：
>
>🟡 核心线程数
>
>🟡 最大线程数

2. 装线程池需要执行的任务的容器

> 任务队列是一个“阻塞队列”
>
> > 阻塞队列：计组概念查一下。简单来说是有数据就读数据，没有数据就不读。队列中数据满了就不接收数据了
>
> 设置参数： 🟡队列的最大长度

### 线程池使用步骤

1. 创建线程池（对象）。
2. 向线程池提交任务。先提交的任务先执行，后提交的任务后执行。
3. 任务调度和执行。不同的线程池会采取不同任务调度方案和执行策略。但*大体上*还是会采取以下策略：
   1. 如果任务比较少，当前线程池中的线程够用，则按照提交任务的顺序执行，先提交先执行。（队列的特点）
   2. 任务比较多时，线程池有时会选择创建更多的线程来执行任务。
   3. 当线程池的线程已达到最大值时，还有多余的任务需要执行，这些任务就会去任务队列中排队。
4. 线程池关闭。（线程池不一定要关闭，要看具体情况）

### 如何创建线程池的对象

在JDK5以后，Java提供了线程池的实现，用以下两个类来描述：

1. **`java.util.concurrent.Executors`**工具类，用于生成线程池对象。
2. **`java.util.concurrent.ExecutorService`**一个接口，是全体线程池类型的父类，它用于指代线程池对象。

所以我们可以通过***调用`Executors`工具类的方法来得到线程池对象，然后用`ExecutorService`父类引用接收***，进而操作线程池对象。

> 工具类中所有方法都是静态方法。方法调用直接类名点。

#### 创建线程池对象的三个静态方法

##### `newCachedThreadPool()`

```Java
ExecutorService newCachedThreadPool()
ExecutorService es = Executoors.newCachedThreadPool();
```

1. 维护了一个可自动扩容的线程容器，每当需要执行一个新任务时，有活跃的线程就使用该线程，否则就新建一条线程。

> 不需要任务队列

2. 线程池的最大线程数为`Integer.MAX_VALUE`，基本上不受限制。
3. 使用完毕后的线程会回归线程池，如果这个线程在60秒之后依旧空闲，那么就会被移除

> 60秒是**空闲线程存活时间**

4. 线程池初始线程个数为0

##### `newFixedThreadPool(int nThreads)`

```java
ExecutorService newFixedThreadPool(int nThreads)
```

1. 创建一个固定线程数量的线程池，在整个线程池的生命周期中，线程池中的数量不会变化

> 核心线程数等于最大线程数，需要一个任务队列

2. 维护一个无界队列（暂存已提交的来不及执行的任务）按照任务的提交顺序，将任务执行完毕 

> 这种类型的线程池适用于执行长时任务或需要限制并发数量的场景。

##### `newSingleThreadExecutor()`

```java
ExecutorService newSingleThreadExecutor()
```

特点:

1. 线程数量固定为1个，在整个线程池的生命周期中，线程池中的数量不会变化
2. 维护了一个无界队列（暂存已提交的来不及执行的任务）按照任务的提交顺序，将任务执行完毕  

这种类型的线程池适用于需要保证任务顺序执行，不需要同时执行的场景

```java
// 特点:
// 1.维护了一个可自动扩容的线程容器，每当需要执行一个新任务时，有活跃的线程就使用该线程，否则就新建一条线程。
// 2.线程池的最大线程数为Integer.MAX_VALUE，基本上不受限制。
// 3.使用完毕后的线程会回归线程池，如果这个线程在60秒之后依旧空闲，那么就会被移除
// 4.线程池初始线程个数为0
// 适用于线程生命周期短且频繁创建的场景
ExecutorService newCachedThreadPool()


// 特点:
// 1.创建一个固定线程数量的线程池，在整个线程池的生命周期中，线程池中的数量不会变化
// 2.维护一个无界队列（暂存已提交的来不及执行的任务）按照任务的提交顺序，将任务执行完毕  
// 这种类型的线程池适用于执行长时任务或需要限制并发数量的场景。
ExecutorService newFixedThreadPool(int nThreads)


// 特点:
// 1.线程数量固定为1个，在整个线程池的生命周期中，线程池中的数量不会变化
// 2.维护了一个无界队列（暂存已提交的来不及执行的任务）按照任务的提交顺序，将任务执行完毕  
// 这种类型的线程池适用于需要保证任务顺序执行，不需要同时执行的场景
ExecutorService newSingleThreadExecutor()
```

### 提交任务

为了让线程池生效，需要向线程池提交任务

向线程池提交方法主要依赖于接口**`java.util.concurrent.ExecutorService`**当中的两个submit方法：

```java
Future<?> submit(Runnable task)
Future<T> submit(Callable<T> task)
```

分两种提交

1. `Runnable`任务

​	不需要参数也没有返回值

```Java
es.submit(new RunnableTask());
```

2. 🟡` Callable`任务

**创建线程的方式三**

`run()`方法没有返回没有形参；

`call()`方法也不需要参数但是可以有返回值。注意泛型传参`<>`中写入什么引用数据类型就返回什么类型。

> 关于泛型传参：
>
> 1. 不能用基本数据类型但是可以写它的包装类型
>
> 2. 泛型传参，如果泛型用于方法的返回值类型，那可以写Void，表示此方法没有返回值的

**重点在如何接收返回值**

使用`juc`包下的接口`Future`,使用它提供的成员方法：

`V get()`

`V`是泛型，它和`Callable`任务当中使用的泛型传参是一致的。

⭐ 注意事项

1. `Future`接口下的`get()`方法具有延迟等待的特点，不管在哪个线程中调用此方法，都会等待线程池中线程执行完毕任务,然后提交返回值。此方法才会执行完毕。

2. 如果用`Future`接口来获取`Runnable`执行结果，返回值是`null`

### 关闭线程池

两个关闭线程池的方法

```Java
//平稳地关闭，会把所有提交的任务都执行完
voi shutdown();

//立刻关闭，正在执行的任务也不执行了。stop()也是立刻中断    
List<Runnable> shutdownNow()
```

调用`shutdownNow()`方法会立刻打断某个线程执行的任务，此刻会立刻抛出异常`InterruptedException`，注意如果代码中有相应的异常处理(`catch` 了  `InterruptedException`),那么此任务还会继续执行,直到完成。

## 多线程实现方式三

基于`Callable`接口

`Thread(Runnable target)`

`Thread(Runnable target, String name)`

方式三和方式二使用同一个构造器创建`Thread`对象，但是传的参数不同。

不同点在于：

方式二的任务是`Runnable`任务，此任务没有返回值；

方式三的任务是`Callable`任务，此任务有返回值

⭐⭐ 构造器要求传参类型是`Runnable`但是`Callble`如何传进去呢？

> 桥梁：查看继承层次图，`juc`包下的`FutureTask`。该类同时实现了`Runnable`接口和`Future`接口，所以创建它的对象，就是创建`Runnable`接口的子类对象，可以传入`Thread`类的构造器。该类同时实现`Future`接口，表示执行`Callable`任务的返回值。`FutureTask` = `Future` + `Runnable`。
>
>  `Future`任务就表示有返回值的任务。创建该类型的对象，需要传参传入一个`Callable`接口的子类对象，这个子类对象中重写`call()`方法作为一个有返回值的任务。
>
> ```
> * FutureTask = Future + Runnable
>  * 创建该类型的对象,需要传参传入一个Callable接口的子类对象,这个子类对象中重写的call方法作为一个有返回值的任务
>  * 利用 FutureTask(Callable)
> ```

```Java
FutureTask<Integer> futureTask = new FutureTask<>(callableTask); 
```

🟡🟡**（重点）方式三的使用步骤**

1. 定义一个类实现`Callable`接口，重写`call()`方法，用来定义一个带有返回值的任务（当然也可以用`Lambda`表达式），然后创建此类的对象

2. 创建`FutureTask`类型的对象，并且将上述对象作为参数传递

   使用构造器 `FutureTask(Callable)`

3. 创建`Thread`类的对象

   利用构造器`Thread(Runnable)`

   并将`FutureTask`类型的对象作为参数传递

4. 如果希望获取任务执行的结果，利用`FutureTask`类型的对象调用`get`方法。注意此方法具有延迟性，会等待线程执行完毕任务给出返回值。

```Java
public class Demo {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        CallableTask callableTask = new CallableTask();
        FutureTask<Integer> futureTask = new FutureTask<>(callableTask);
        new Thread(futureTask).start();
        // 具有延迟性
        Integer num = futureTask.get();
        System.out.println(num);
    }
}

class CallableTask implements Callable<Integer> {
    @Override
    public Integer call() throws Exception {
        Thread.sleep(3000);
        return 666;
    }
}
```

> `Runnable`和`Callable`区别
>
> 它们两都表示需要线程执行的任务，但区别是：
>
> 1. `Runnable`实现的是`run()`方法，`Callable`里面实现的是`call()`方法
> 2. `run()`方法没有返回值，`call()`方法有返回值

> 扩展
>
> 无界队列可能导致堆溢出(`OutofMemoryError` : GC overhead limit exceeded)
>
> 对于生产环境而言，禁止直接使用`Executors`工具类提供的方法创建线程池。
>
> 那该如何办？
>
> 🟡⭐**`java.util.concurrent.ThreadPoolExecutor`**类
>
> 面试问金融计算使用什么类型？`BigDecimal`。不能说`double`。
>
> **面试问用的线程池怎么生成的？Spring里封装的线程池或者`ThreadPoolExecutor`类。不能说`Executors`工具类**

## 定时任务

> Spring里提供的是常用的，这里仅作提前了解

定时任务大体上也可以看成一个线程池来使用，定时任务会自主创建一个线程和主线程分属不同的线程，可以和主线程同时执行。可以看成是一个挂后台执行任务的线程。定时任务容器中任务会按照执行时间的先后进行**排列**，到了一定时机或触发一个条件，这个线程就是自动执行任务容器中时间最靠前的任务，并且可以**反复定时循环执行**。所以就叫定时任务。

一个定时任务可以看成一个线程 + 定时任务容器组成。

步骤：

1. 创建定时器对象(`java.util.Timer`)

2. 创建一个定时任务`TimerTask`对象

​	区别在于它不是接口，而是抽象类，所以不能用`Lambda`表达式

3. 进行任务执行的调用（决定这个任务什么时候执行，执行几次等）

> `void schedule(TimerTask task,long delay)`

4. 关闭定时器结束定时任务

`timer.cancel();`注意该关闭时在主线程中关闭的，定时器中的后台线程还没有来得及执行定时任务，定时器就被关闭了。一般来说，定时器和线程池一样，循环执行任务，不需要关闭。

> 多线程更多知识见：《Java并发编程》


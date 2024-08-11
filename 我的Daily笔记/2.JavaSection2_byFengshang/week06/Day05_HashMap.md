## `LinkedList`

双向链表。

Queue 队列

Deque 双端队列



LinkedList是Javapp集合框架中的一种，它实现了List和Deque接口，是一个双向链表。与ArrayList不同的是，LinkedList在内部并不使用数组来存储元素，<span style=color:red;background:yellow>**而是使用一个链表来存储元素，因此可以高效地进行插入和删除操作。**</span>

<span style=color:red;background:yellow>**LinkedList的每个节点都包含了一个指向前一个节点和后一个节点的指针，因此可以方便地进行双向遍历。**</span>在向LinkedList中添加元素时，只需要创建一个新的节点，并将其插入到链表中即可。同样，在删除元素时，只需要将该元素的前后节点的指针重新指向即可，不需要像ArrayList一样将其后面的元素全部向前移动。

LinkedList提供了一系列方法，可以方便地操作其中的元素。例如add()方法可以在指定位置添加元素，remove()方法可以删除指定位置的元素，get()方法可以获取指定位置的元素，set()方法可以修改指定位置的元素等等。除此之外，LinkedList还提供了一些特殊的方法，例如offer()和poll()方法用于在链表的首尾添加和删除元素，push()和pop()方法用于在链表的首部添加和删除元素等等。

### 特点

1. LinkedList是List的子实现
2. LinkedList数据结构表现为线性表
3. LinkedList底层结构是双向链表
4. 存储元素有序
5. 可以存储null
6. 可以存储重复元素

### `LinkedList`的构造方法

```JAVA
//构造一个空列表。 
LinkedList();
  
//构造一个包含指定 collection 中的元素的列表，这些元素按其 collection 的迭代器返回的顺序排列。
LinkedList(Collection<? extends E> c);
```

### `LinkedList`的`API`

队列：先进先出，从队尾进，队头出。

双端队列：队头和队尾都可以进出。

栈：先进后出。



```java
//        来自Collection
//        来自List的

//    ----------------------------来自普通队列
//将指定元素添加到此列表的末尾（最后一个元素）。
boolean offer (E e)

//获取但不移除此列表的头（第一个元素）。
E peek () 
//获取并移除此列表的头（第一个元素）
E poll () 
  
//    ---------------------------- 作为Stack的
//从此列表所表示的堆栈处弹出一个元素。
  E pop(); 
// 将元素推入此列表所表示的堆栈。
  void push(E e);

//    ---------------------------- 作为双端队列
//    在此列表的开头插入指定的元素。
	boolean offerFirst (E e)
//    在此列表末尾插入指定的元素。
  boolean offerLast (E e)
//    获取但不移除此列表的第一个元素；如果此列表为空，则返回 null。
  E peekFirst () 
//    获取但不移除此列表的最后一个元素；如果此列表为空，则返回 null。
  E peekLast () 
//    获取并移除此列表的第一个元素；如果此列表为空，则返回 null。
  E pollFirst () 
//    获取并移除此列表的最后一个元素；如果此列表为空，则返回 null。
  E pollLast () 

//    ----------------------------以下的API了解即可
//将指定元素插入此列表的开头。
    void addFirst (E e)
//将指定元素添加到此列表的结尾。
    void addLast (E e)
//移除并返回此列表的第一个元素。
    E removeFirst () 
//移除并返回此列表的最后一个元素
    E removeLast () 
//返回此列表的第一个元素。
    E getFirst () 
//返回此列表的最后一个元素。
    E getLast () 
//从此列表中移除第一次出现的指定元素（从头部到尾部遍历列表时）。
    boolean removeFirstOccurrence (Object o) 
//从此列表中移除最后一次出现的指定元素（从头部到尾部遍历列表时）。
    boolean removeLastOccurrence (Object o)
//返回以逆向顺序在此双端队列的元素上进行迭代的迭代器。
    Iterator<E> descendingIterator () 
//获取但不移除此列表的头（第一个元素）。
    E element () 
```



<font color=red>**链表特点：**</font>插入和删除快。真的吗？

查找也需要时间，所以算起来和`ArrayList`类似。一般需要使用，直接使用`ArrayList`.除非在极个别情况下，才会用LinkedList.`List<V>() list = new ArraryList<>();`

## `Vector`

1. Vector是List的子实现
2. Vector的数据结构表现是线性表
3. 底层结构是数组
4. 存储的数据有序，可重复，可存储null
5. 线程安全



JDK1.0的时候出现。底层是数组。

JDK1.2 出现了ArrayList。  用它取代Vector。

为什么不把它干掉？--》 向前兼容。

Vector为啥被替代。 效率差，因为它所有的方法为了线程安全都有锁。



<span style=color:yellow;background:red>**在工作中，禁止使用Vector**</span>

**面试专用**

> 了不了解Vector?是否了解ArrayList和Vector的区别？    
>
> 答：不能只说了解，后面要继续讲Vector相关点：
>
> 正确的去引导面试官。先答Vector的特点。顺手再说一下ArrayList。再答最明显的特征 线程安全。
>
> 
>
> Vector和ArrayList的区别？
>
> 
>
> **什么叫线程安全问题？**
>
> 指的是多线程环境下数据安全的问题。当多个线程同时对一个变量进行操作时，结果的预期与单线程下是一致的。这就是线程安全的。
>
> 比如多个线程对i进行操作，i初始值是0，有5个线程，每个线程累加10000次。最终结果应该是50000。 但真实情况不是这样的，这就是线程安全问题。
>
> <span style=color:red;background:yellow>**为什么被弃用 **</span>
>
> <span style=color:red;background:yellow>**效率低，**</span>在所有的接口上都加了`synchronized`关键字。线程安全是没问题了，但是效率却有问题。因为绝大部分都不涉及到多线程情况，所以`jdk1.2`采用了`ArrayList`来替代`Vector`



## `Stack`

1. Stack是Vector的子实现。继承自Vector也是线程安全但效率低。
2. 栈，是先进后出的数据容器。但是不建议使用这个来完成，效率是大问题。使用Deque来替代Stack --》 见jdk源码



<span style=color:red;background:yellow>在Java中，要用栈，能不能使用Stack？ 不要用。</span>

源码中写到：

```JAVA
/* * <p>A more complete and consistent set of LIFO stack operations is
 * provided by the {@link Deque} interface and its implementations, which
 * should be used in preference to this class.  For example:
 * <pre>   {@code
 *   Deque<Integer> stack = new ArrayDeque<Integer>();}</pre>
*/
```



# Queue

学习目标

- 掌握Queue的结构，以及Queue是什么
  - （操作受限的线性表）

- 了解Queue两组增删查API及区别
  - （add remove  element  |  offer poll peek  极端情况下表现不一致）

- 了解Deque的结构
  - （offerFirst offerLast  addFirst addLast .使用API成组使用）

- ArrayDeque的循环数组，是什么，以及为什么使用这种形式。
  - 底层是一个数组，使用两个int值来代表头和尾，避免从队列中获取数据的时候，频繁挪动数据。使用int值，就可以只操作int值，来模拟头和尾，提高了效率。

- 了解ArrayDeque的初始化容量及扩容策略。 如果传入一个非2的幂次方，它是怎么把它变成2的幂次方的
- 了解BlockingQueue是什么



<span style=color:red;background:yellow>**Queue：**</span>在Java中，队列（Queue）是一种数据结构，用于存储元素并支持在队列的末尾添加元素和从队列的头部移除元素。队列的工作方式类似于排队等待服务的过程。

Java中的队列通常是先进先出（FIFO）的数据结构，这意味着最先添加的元素将最先被移除。Java中的队列接口（java.util.Queue）定义了队列的基本操作，如添加元素、移除元素、获取队列头部元素等。



只能从队头出队列，从队尾进队列。



## 特点

1. Queue是Collection的子接口
2. 数据结构表现为：队列
3. 存储元素有序
4. 存储元素可重复
5. 不能存储null（除了LinkedList子实现）

## API

```java
// 将指定的元素插入此队列（如果立即可行且不会违反容量限制），在成功时返回 true，如果当前没有可用的空间，则抛出 IllegalStateException。
	boolean add(E e)；
//获取并移除此队列的头。NoSuchElementExecption
  E remove()；
//获取，但是不移除此队列的头。
  E element()；

//将指定的元素插入此队列（如果立即可行且不会违反容量限制），当使用有容量限制的队列时，此方法通常要优于 add(E)，后者可能无法插入元素，而只是抛出一个异常。
    boolean offer(E e)
//获取并移除此队列的头，如果此队列为空，则返回 null。
    E poll()
//获取但不移除此队列的头；如果此队列为空，则返回 null。
    E peek()
```

极端情况下两组`API`的表现不一致

|          | *抛出异常*                                          | *返回特殊值*                                      |
| -------- | --------------------------------------------------- | ------------------------------------------------- |
| **插入** | [`add(e)`](../../java/util/Queue.html#add(E))       | [`offer(e)`](../../java/util/Queue.html#offer(E)) |
| **移除** | [`remove()`](../../java/util/Queue.html#remove())   | [`poll()`](../../java/util/Queue.html#poll())     |
| **检查** | [`element()`](../../java/util/Queue.html#element()) | [`peek()`](../../java/util/Queue.html#peek())     |

Queue不允许存储null的原因：<u>**使用null作为特殊标识**</u>，标识没有元素了，使用poll peek方法会返回null

只有使用`LinkedBlockingQueue`才会出现队列满

## Deque

双端队列（Deque），是一种可以在队列的两端添加或删除元素的数据结构。

双端队列支持在队列的头部和尾部进行插入、删除和获取元素的操作，因此它可以同时用作栈和队列，是一种比较灵活的数据结构。在Java中，Deque接口提供了双端队列的实现，具有以下特点：

1. 可以在队列的头部或尾部添加或删除元素。
2. 可以获取队列头部或尾部的元素。
3. 可以用作栈或队列来进行数据操作。



<span style=color:red;background:yellow>**从队头可以进出，从队尾也可以进出。**</span>

### 特点

1. Deque是Queue的子接口
2. 数据结构表现：队列，栈，双端队列
3. 存储元素有序
4. 可存储重复元素
5. 不能存储null（LinkedList除外）

### API

注意API不要混用



```JAVA
// ------------- 作为Queue的
//获取队头元素，但不移除它
	E peek()
//从队头移除元素
  E poll()
//        boolean offer(E e)： 添加一个元素到队尾

// ------------- 作为Stack的
//        E pop()： 从此列表所表示的堆栈处弹出一个元素。
//        void push(E e): 将元素推入此列表所表示的堆栈。

// ------------- 作为双端队列
//        boolean offerFirst(E e)：  从第一个位置插入指定元素
//        boolean offerLast(E e)： 从最后一个位置插入指定元素
//        E peekFirst()： 获取但是不移除第一个元素，如果列表为空，返回null
//        E peekLast()： 获取但是不移除最后一个元素，如果列表为空，返回null
//        E pollFirst()： 从第一个位置移除元素
//        E pollLast()： 从最后一个位置移除元素，如果列表为空，返回null

// -------------- 作为普通List的
//将指定元素添加到此列表的结尾。
	boolean add(E e);
//获取并移除此列表的头（第一个元素）。
	E remove();

//将指定元素插入此列表的开头。
	void addFirst(E e);
//将指定元素添加到此列表的结尾。
	void addLast(E e);
//返回此列表的第一个元素。
	E getFirst();
//返回此列表的最后一个元素。
	E getLast()
//移除并返回此列表的第一个元素。
	E removeFirst()
//移除并返回此列表的最后一个元素。
	E removeLast()
     🟡注意下面两个方法不符合Deque定义
//从此列表中移除第一次出现的指定元素
	boolean removeFirstOccurrence(Object o)
//从列表中移除最后一次出现的指定元素
  boolean removeLastOccurrence(Object o)
    
//获取一个倒序的迭代器
  Iterator<E> descendingIterator();
//获取元素
	E element();
```

|          | **第一个元素（头部）**                                      | **第一个元素（头部）**                                      | **最后一个元素（尾部）**                                  | **最后一个元素（尾部）**                                  |
| -------- | ----------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------- |
|          | *抛出异常*                                                  | *特殊值*                                                    | *抛出异常*                                                | *特殊值*                                                  |
| **插入** | [`addFirst(e)`](../../java/util/Deque.html#addFirst(E))     | [`offerFirst(e)`](../../java/util/Deque.html#offerFirst(E)) | [`addLast(e)`](../../java/util/Deque.html#addLast(E))     | [`offerLast(e)`](../../java/util/Deque.html#offerLast(E)) |
| **移除** | [`removeFirst()`](../../java/util/Deque.html#removeFirst()) | [`pollFirst()`](../../java/util/Deque.html#pollFirst())     | [`removeLast()`](../../java/util/Deque.html#removeLast()) | [`pollLast()`](../../java/util/Deque.html#pollLast())     |
| **获取** | [`getFirst()`](../../java/util/Deque.html#getFirst())       | [`peekFirst()`](../../java/util/Deque.html#peekFirst())     | [`getLast()`](../../java/util/Deque.html#getLast())       | [`peekLast()`](../../java/util/Deque.html#peekLast())     |

## ArrayDeque

循环数组（Cyclic Array），也称为环形数组，是一种数据结构，是数组的一种特殊形式。在循环数组中，数组的最后一个元素与第一个元素相邻，形成了一个环，因此可以通过数组下标进行循环遍历。

在循环数组中，每次增加数组下标时，需要考虑到下标越界的情况。一般来说，可以将下标对数组长度取模，实现在下标增加到数组最后一个元素时，返回到数组的第一个元素。同样地，当下标减小到数组的第一个元素时，可以通过将下标加上数组长度来返回到最后一个元素。

循环数组在实际应用中具有一定的优势，例如在*循环队列*、*循环缓冲区*等场景中，循环数组可以有效地实现元素的循环存储和遍历。同时，循环数组的空间利用率也相对较高，因为数组的最后一个元素可以直接连接到第一个元素，不需要额外的空间进行维护。

tail = (tail + 1) % length;

二进制中，当length是2的整数幂时，计算等式有

tail = (tail + 1) % length = (tail + 1) & (length -1);

### 特点

1. ArrayDeque是Deque的子实现
2. 数据结构表现：队列，栈，双端队列
3. 底层实现： <font color=red>**循环数组**</font>。要理解一下循环数组的好处。
4. 存储元素有序
5. 存储元素可重复
6. 不可存储null

### 构造方法



```JAVA
//构造一个初始容量能够容纳 16 个元素的空数组双端队列。  扩容机制 *2 
ArrayDeque(); 

//构造一个包含指定 collection 的元素的双端队列，这些元素按 collection 的迭代器返回的顺序排列。    
ArrayDeque(Collection<? extends E> c); 

//构造一个初始容量能够容纳指定数量的元素的空数组双端队列。          
ArrayDeque(int numElements); 
          
```

>容量问题。如果传入的初始化容量小于8，则直接分配8个空间，如果传入的数字大于等于8，则直接找到(大于)数字的最近一个2的幂次方。
>24 --> 32
>32 --> 64
>为什么要分配2的幂次方？方便进行取模操作。

<font color=red>**注意**</font>：即使是整数幂，会找大于该整数幂的下一个整数幂。输入8会变为16，输入64会变为128.



```JAVA
初始容量：16  2的幂次方。扩容策略是2倍
int tail=(tail + 1) % length
    tail = （tail + 1） & (length - 1)
    
ArrayDeque里面有一个构造方法，允许你传入int大小的值，  但是我们通过推算得知，只有2的幂次方，才满足上述公式。
    所以JDK里面有把非2的幂次方，转成2的幂次方的方式。
```

> JAVA中的移位运算有三种：左移（<<）、右移（>>）和无符号右移（>>>）。
>
> 1. 左移（<<）：将操作数的所有位向左移动指定的位数，右边的空位用0填充。例如，对于表达式a << b，a的二进制表示向左移动b位。
> 2. 右移（>>）：将操作数的所有位向右移动指定的位数，并根据最左边的位（即符号位）进行填充。对于正数，用0填充；对于负数，用1填充。例如，对于表达式a >> b，a的二进制表示向右移动b位。
> 3. 无符号右移（>>>）：将操作数的所有位向右移动指定的位数，并用0填充空位，不考虑符号位。无符号右移运算符在操作无符号值时非常有用。例如，对于表达式a >>> b，a的二进制表示向右移动b位。



```JAVA
// 经过看源码得知，传入一个numElements(10)。最终是通过这个方法，得到一个int值，作为数组长度的。
// numElements = 10
// 1010
// 只要记得，它会把非2的幂次方的值，转成2的幂次方。
private static int calculateSize(int numElements) {
    // initialCapacity = 8
    // private static final int MIN_INITIAL_CAPACITY = 8;
    int initialCapacity = MIN_INITIAL_CAPACITY;
    // 如果你传入的初始容量，小于8，直接返回8
    // 如果传入的初始容量，大于等于8，进 代码块
    
    if (numElements >= initialCapacity) {
        initialCapacity = numElements;
        initialCapacity |= (initialCapacity >>>  1);
        
        initialCapacity |= (initialCapacity >>>  2);
        initialCapacity |= (initialCapacity >>>  4);
        initialCapacity |= (initialCapacity >>>  8);
        initialCapacity |= (initialCapacity >>> 16);
        
        // 1 0000
        initialCapacity++;

        if (initialCapacity < 0)   // Too many elements, must back off
            initialCapacity >>>= 1;// Good luck allocating 2 ^ 30 elements
    }
    return initialCapacity;
}
```

其中的核心代码段是通过对二进制取或运算将每一位都变成1，最后增一运算成为2的整次幂

```JAVA
    if (numElements >= initialCapacity) {
        initialCapacity = numElements;
        initialCapacity |= (initialCapacity >>>  1);
        
        initialCapacity |= (initialCapacity >>>  2);
        initialCapacity |= (initialCapacity >>>  4);
        initialCapacity |= (initialCapacity >>>  8);
        initialCapacity |= (initialCapacity >>> 16);
        
        // 1 0000
        initialCapacity++;
```

<font color=red>**准备知识：**</font>

<font color=red>**当除数为2的幂次方，可以用& 运算代替取余,即 **</font>

```JAVA
   b是2的幂次方。 a % b = a & (b-1)
```



<span style=color:red;background:yellow>**比如：**</span>

24=0001 1000

32=0010 0000



```JAVA
24  --》 32（0010 0000）
32  --》64（0100 0000）

if (numElements >= initialCapacity) {
    // initialCapacity = 24
    //                 11000
    initialCapacity = numElements;
    
    // initialCapacity >>>  1   01100
    // initialCapacity 			11000   -->11100
    
    initialCapacity |= (initialCapacity >>>  1);
    
    
    // initialCapacity        11100
    // initialCapacity >>> 2  00111
    // initialCapacity = 11111
    
    initialCapacity |= (initialCapacity >>>  2);
    initialCapacity |= (initialCapacity >>>  4);
    initialCapacity |= (initialCapacity >>>  8);
    initialCapacity |= (initialCapacity >>> 16);
    
    // 100000
    initialCapacity++;

    if (initialCapacity < 0)   // Too many elements, must back off
        initialCapacity >>>= 1;// Good luck allocating 2 ^ 30 elements
}

```

## BlockingQueue

阻塞队列

什么叫阻塞队列。一个<span style=color:red;background:yellow>**大小有限**</span>的队列。

- 插入时，<font color=red>**当队列满了，插入线程阻塞住**</font>。

- 从队列中获取元素时，<font color=red>**当队列空了，获取线程阻塞住**</font>

|          | *抛出异常*                                          | *返回特殊值*                                      | 阻塞     | 超时                 |
| -------- | --------------------------------------------------- | ------------------------------------------------- | -------- | -------------------- |
| **插入** | [`add(e)`](../../java/util/Queue.html#add(E))       | [`offer(e)`](../../java/util/Queue.html#offer(E)) | `put(e)` | `offer(e,time,unit)` |
| **移除** | [`remove()`](../../java/util/Queue.html#remove())   | [`poll()`](../../java/util/Queue.html#poll())     | `take()` | `poll(time,unit)`    |
| **检查** | [`element()`](../../java/util/Queue.html#element()) | [`peek()`](../../java/util/Queue.html#peek())     | 不可用   | 不可用               |



> 注意多线程是很重要的，虽然实际开发时不会去写该方法，但是许多框架内部会封装使用多线程。入职后再多学学 多线程 JVM JUC。

> 实际应用：
>
> 生产者消费者共用一个BlockingQueue





学习目标：

- 会使用Map的增删改查API，遍历Map的方式
- ==学会HashMap存储数据的特点==
- ==熟练掌握对常见的场景进行Map的使用==

# 前置准备

## Map是什么



什么是Map呢？*Map就是用来存储键值对的接口*，注意，它与Collection的区别。Collection存储的是单列数据，Map存储的键值对。

> 键值对的特点：自描述性
>
> 普通的bean（普通对象）其实也是存储的键值对数据，但是它存储的数据特点是键是固定的。但在map中没有固定。

什么叫键值对。就是一个key，一个value。我们举一个生活中的例子，我们把一些常见的公共电话与它的功能做一个对应。

比如 110 是警察局

120 是医院

119 是火警

122 是车辆救援

12345 是消费者权益保护。用一个键，可以快速获取一个值。



比如，如果我们想在1-20中间随机生成10000个数，需要记录每个数生成了多少次，怎么存呢？



<font color=red>**生成1-20之间的随机数，10000个数字。**</font>



那如果是 1-10_000_000中间生成1000次呢？

使用数组实现不现实。 如果是int范围内生成呢？

需要使用Map。

等学完了Map的API，实现一下。



# Map

## 特点

1. Map是Map体系的顶级接口，用来存储键值对数据
2. Map存储的数据，有一些子接口有序，有一些无序
3. Map存储的数据，不能重复（指的是key）
4. Map存储的数据，有一些允许为null，有一些不允许。（指的key）（TreeMap不允许存）

## API

```JAVA
//---------------------------新增，删除，查找数据接口
//添加键值对。 如果键存在，是更新数据
V put(K key, V value)
//将一个map的所有键值对都放入这个map
  void putAll(Map<? extends K,? extends V> m)
//根据一个key，获取value，如果key不存在，返回null
  V get(Object key)
//删除map中所包含的这个key
  V remove(Object key)
//判断map中是否包含这个key
  boolean containsKey(Object key)
//判断map中是否包含这个value
  boolean containsValue(Object value)

//---------------------------辅助接口
//清空map
  void clear() 
//判断两个map是否相等
  boolean equals(Object o)
//返回此映射的哈希码值。
  int hashCode()
//map中是否有元素
  boolean isEmpty()
//返回键-值映射关系数。
  int size()

```

什么是视图方法

操作获取出来的key或者值会影响原本的Map

```JAVA
//---------------------------视图方法
// 在Map里面 Entry 代表存储了key和value的一个接口体
//返回此映射中包含的映射关系的 Set 视图。
Set<Map.Entry<K,V>> entrySet()
//返回此映射中包含的键的 Set 视图。
  Set<K> keySet()
//返回此映射中包含的值的 Collection 视图。
  Collection<V> values()
```



> 如何遍历一个Map
>
> 方式一：先获取keySet,遍历keySet,map.get(key)拿到value
>
> 方式二：直接获取entrySet.从entry获取key 获取value



使用Map完成存储

关键在于明确键值对中键是什么，值是什么

<span style=color:red;background:yellow>**实现一下这个**</span>

如果我们想在1-20中间随机生成10000个数。怎么存？



```JAVA
for(int i = 0; i < 10000; i++){
	int randomNumber = random.nextInt(20) + 1;
  if()
}
```



1-10_000_000中间生成1000次？



班级里有一些学生，我想根据省份进行分组，应该怎么做？

```JAVA
    private static List<Student> generateStudents() {
        List<Student> students = new ArrayList<>();

        List<String> provinceList = Arrays.asList("hubei", "hunan", "guangdong");

        for (int i = 0; i < 50; i++) {
            Student student = new Student();
            student.setName("student" + i);
            student.setAge(15);
            // 从省份的list中，获取出一个省份，设置到学生上
            String province = provinceList.get(i % provinceList.siz());
            student.setProvince(province);

            students.add(student);
        }

        return students;
    }

class Student {
    String name;
    int age;
    String province;
}
```



<span style=color:yellow;background:red>**要学会完成抽象化的任务**</span>

- 比如你想统计一个班上每个省份的学生人数。应该怎么设计这个Map？
- 想统计一个班上，男生和女生的人数
- 一个班级的，语文分按照 [0,60), [60,80), [80,100]分三个层级 差，良，优秀。怎么统计每个层级的人数？(抽方法有什好处)



Map进行增删改查的API

遍历Map的key-value数据的方式




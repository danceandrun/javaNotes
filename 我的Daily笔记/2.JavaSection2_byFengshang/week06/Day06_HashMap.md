[TOC]

# HashMap

## 准备知识

### 什么是Hash

映射（函数）的概念：

> 设A和B是两个非空集合，并存在某种对应关系f
>
> 按照这种对应关系f，对于集合A中的任何一个元素a，在集合B中都存在<font color=red>**唯一的**</font>一个元素b与之对应
>
> 那么，这样的对应（包括集合A，B，以及集合A到集合B的对应关系f）叫做集合A到集合B的映射
>
> y=f(x)。 一个x对应一个y。 一个对应多少个x。
>
> 对于一个x，只能有一个y与之对应
>
> 对于一个y，可以有多个x与之对应。

<img src="https://hixiaodong123.oss-cn-hangzhou.aliyuncs.com/typora/202201121211877.png?align=center" alt="映射图解" style="zoom:33%;" />

注意：

1. <span style=color:red;background:yellow>**映射不要求元素一一对应，允许出现多对一，但绝不允许一（x）对多(y)。**</span>

---

明白映射的概念后，哈希映射(hash)就不难理解了。哈希映射也是一种特殊的映射，要求：

1. 集合A必须是一个无限大小，具有无穷多元素的集合。
2. 集合B必须是一个元素有限的集合。

`化无限为有限`，这就是哈希映射。将**任意长度的输入**通过散列算法变换成**固定长度的输出**。

在哈希映射当中，集合A和B之间的对应关系f，就是一种映射的规则，称之为`哈希函数`、`哈希方法`或者`哈希算法`等。

而通过哈希算法，求得的集合B中的元素，称之为`哈希值`。

将无限，映射为有限。一定会存在一个问题？

冲突。  y=f(x) 不同的x。可能会得到相同的y。

### 好的Hash算法希望的特点

因为输入是无限数目的。而hash算法的结果(hash值)是有限的。所以肯定会遇到碰撞(hash值相同)。

<span style="font-size:20px;color:red;">好的hash算法希望对于不同的输入，得到不同的输出结果。</span>

### 2的幂取余问题

```JAVA
// 先说一个结论 
// 1.当 b 是2的幂次。则  a % b =  a & (b-1)

// 2.当b是2的幂次， a%b 相当于是取a的低位。
```

## HashMap的底层结构

HashMap底层结构是数组+链表+红黑树。

**HashMap的底层结构是一个数组。** 想往HashMap中添加一个键值对。要经过哪些流程呢？

- 首先，会对键，计算得到一个int类型的值<font color=red>**(其实就是hash的过程)**</font>

- 然后与数组长度取余，得到键在数组上的位置

- 如果数组位置上没有元素，则直接插入

- 如果数组位置上有元素，<font color=red>**这个时候怎么操作呢？**</font>我们采用的链表，存储落在同一个位置上的元素。挨个比较，比较完成后，如果没有就插入到链表的最后一个位置

  

  - ![HashMap底层结构](E:\0.王道训练营\3.我的Daily笔记\img\HashMap底层结构.png)


<span style="font-size:20px;color:red;">链表太长了有什么问题？</span>

效率太低，因为比如链表有1w个节点，那就要比较1w次。效率差。所以链表太长了时会转化为<span style="font-size:20px;color:red;">红黑树。</span>

## 特点

1. HashMap是Map接口的子实现。用来存储key-value数据
2. 底层结构，是数组+链表+红黑树
3. 数组默认长度16，扩容机制是2倍。
4. 存储元素是无序的。对于key来说的
5. 不允许存储重复元素， <span style=color:red;background:yellow>**重复是指的它的键**</span>
6. 允许存储null。对于key来说的



> 怎么计算得到int值的？利用hashcode
>
> 存储的元素是什么类型的？一个map

>  面试⭐为什么HashMap的底层是数组+链表+红黑树。
>
> 错误答法：不知道。写JDK那帮人写得。
>
> 把添加的流程答出来，然后分析，链表是·必不可少的（因为存在多个key落在同一个数组位置）。如果链表长度太长，这时候效率太差，采用红黑树提高效率



红黑树的查找效率O(logn)

## HashMap的一些注意事项(面试题)

### ==初始化容量及扩容==

 数组默认长度是16。 扩容机制2倍

这样就保证了：

数组长度一直都是2的幂次。计算可以简化  a%b=a&(b-1)



### 加载因子

HashMap底层是数组+链表+红黑树。如果不限制，其实可以存无限的数据，但是这样**效率较低**
 🟡在HashMap底层维护的了一个***加载因子***（loadFactor），用来表示存储到多少就会扩容.
// 比如默认的数组长度是16。 加载因子是0.75f
// 阈值 = 16 * 0.75 = 12
// HashMap存储的key-value数据数目超过 阈值, 就要引发数组扩容

> 加载因子是控制什么事情？主要是控制数组上存储的数据。加载因子，是结合工程实践对很多场景进行测试得到的，所以不要改。



```JAVA
 if (++size > threshold){resize();}

															0.75*16
  threshold = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);

// 思考一下，添加数据的效率，查找数据的效率，删除数据的效率。 大概是多少？
```

### HashMap底层数组结构

```JAVA
// HashMap底层数组存储的key-value 是以Node结点存储的
// 里面存储了四个东西， key值 value值 hash 下一个节点
class Node{
    K key,
    V value,
    int hash,
    Node next
}

Node[] 
```



### hash的计算

为什么计算hash的时候这么麻烦，直接计算hashCode不可以吗？

> 为了让计算得到下标的时候，高位和地位同时生效。



```JAVA
// hash() 就是为了计算给定的key的int值
static final int hash(Object key) {
    int h;
    // key == null
    // 如果key为null的时候，返回0
    // 如果key不为null。 (h = key.hashCode()) ^ (h >>> 16)
    
    // 计算hashCode. h=hashCode 
    // (h) ^ (h >>> 16)
    // 就是为了让计算 得到下标的时候。高位和低位同时生效。
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}

// a % b = a & (b-1)
//  0010 0111 0110 0110(10086)
//& 0000 0000 0000 1111 
// a和b取余的时候。 谁生效  低位生效

(hashCode) ^ (hashCode >>> 8)
// 0010 0111 0110 0110
// 0000 0000 0010 0111
// 0010 0111 0100 0001 
// 让hashCode的高位和低位都参与了  计算得到index这个过程

// 现在我们假设 hashCode 是以下的两种情况
// 1001 0101   --》 对zhangsan
// 0110 0101   --> 对lisi计算
    
// hashCode ^ (hashCode >>> 4)
// 1001 0101   --》 对zhangsan
// 0000 1001 
// 1001 1100   --> zhangsan
    
// 0110 0101   --> 对lisi计算
// 0000 0110
// 0110 0011  --> lisi 
```



```JAVA
// (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16)

// 对于任意一个输入，我们需要得到一个数字与之对应
// 如果key为null，则直接返回0
// 如果key不为null。首先计算hashCode。然后hashCode无符号右移动16位，然后与原数取异或。

// 是为了充分混合，让key落得位置更加均匀。
//  数组长度是2的幂次。   对这个2的幂次取余，最终起效果的就是数字的 后面位置。

// 例如，计算得到的hash值是77。 
// 当数组底层长度是n的时候。计算得到的下标： 
// 16:  77(0100 1101) % 16(0001 0000) 
//      77(0100 1101) & (0000 1111)
// 	=  0100 1101 & 0000 1111 = 1101    (就是最后四位，取的低位)

// 这时候，高位和低位取个异或，会让高位和低位对在数组上的下标起作用
```


### ==（重要）<span style="color:red;">HashMap对重复的key的定义</span>==

```JAVA
// p指的是原本存在的元素
// hash 是我们传入的hash值（int）  key
(p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k))))

// 1.hash值相同，才往下判断
// 2.如果地址相同。  ||  如果equals返回相同，
                
// 为什么需要重写？ 
// 比如，现在使用自定义的类 User(name, age)作为key。
// 为什么必须要重写hashCode和equals方法？
// 1.计算int值。计算int  hashCode。
// 2.代码这里，怎么判断相等的？ new User("zs", 18);  new User("zs", 18)
```

-  这就要求我们，使用一些类作为key时。<span style=color:red;background:yellow>**必须同时重写hashCode和equals方法。**</span>
-  <span style=color:red;background:yellow>**不建议大家使用自定义的类当做key。一般使用字符串或者Integer。**</span>

### 存储重复元素

HashMap不允许存储重复的key, 当我们存储一份重复的key-value数据时,   是直接用新value是替代旧value，**然后，返回了旧值。**



### 链表什么时候转化为红黑树

 当某个下标位置, 链表长度, **超过8达到9**个时候(算上新加的结点), 就要由链表转化为红黑树

> 面试官问⭐ 当链表数目从8达到9，一定会转化为红黑树吗？
>
> 因为数组长度太小时，长度小于64（数组长度不能是63而是2的幂次方就是32），会直接扩容数组。

### 当链表数目从8到达9，一定会转化为红黑树吗？



不一定会。

 如果数组长度, 小于64,  即使某个下标位置,链表长度已经超过8, 达到9了, 不会转化为红黑树, 而是扩容, 扩容会导致原本存在于这个位置的数据, 拆成两部分。

<span style="font-size:20px;color:red;">思考一下，为什么这么设计？</span>

当链表的长度，到达9的时候，会转化为红黑树。

数组长度是32，是最大的情况。

当前位置，有9个元素，其它31个位置，假设已经有12个元素，阈值是32*0.75 = 24.当前元素有 9+ 12=21个。所以再来3个元素就会自动扩容



### 扩容后位置问题 

扩容后原来位置的元素去向有两种情况 原来的位置或者原来的位置+旧数组的长度。

```JAVA
// 现在，假设位置在x位置上的元素，会落到新数组的什么位置
// 旧数组长度: 16
// 新数组长度： 16 * 2 = 32

// x = hash % Oldlen = hash % 16
// 用x把hash表示出来。    hash = x + 16 * n
// 现在落在新数组什么位置： hash % 32 = (x + 16 * n) % 32 = x + 16 ; x 
// 所以说，就只能落在两种位置： 要么原index位置，要么index + oldCapacity

// 在HashMap中, 存储的数据量大于HashMap的阈值(加载因子*数组长度), 会产生扩容,  当扩容之后一个原本在旧数组x位置的key-value数据,   要和新数组长度取模,得到一个新的下标, 这个新的下标只有两个选择:  x位置, 旧数组长度+x的位置

// 扩2倍。

// 数组长度16.
// x --> hash=16*n + x
// 32    --> hash % 32  = (16 * n + x) % 32  = x,16+x
```

### 红黑树转化为链表

 有两个情况:

- 第一个情况, 删除数据的时候;   要删除的数据在红黑树上,  删除数据导致红黑树上数据量变少,  由红黑树转化为链表

- 第二个情况: 扩容的时候, 一个红黑树再扩容之后, 被拆成两部分, 任一部分数据量过少, 也会由红黑树转化为链表
  红黑树拆成低位(旧位置)和高位(旧位置+旧数组长度: 新位置)两部分, 这两部分, 任何一部分分配的数据量小于等于6个, 就要由红黑树转化为链表



### 如果我们在HashMap已经添加了一份key-value数据,  建议尽量不要再通过key的引用直接修改key,  有可能会无法 再操作这个数据 (了解)

 重写了hashCode和equals。则两个对象的hashCode是一样的。落在了数组上的同一个位置。

如果这时候通过了原对象的引用去修改了变量值。则会导致一个现象。hashCode会改变。不会落在同一个位置。则操作不会生效，比如remove。

建议： Map里面的key, 直接用String。

### ==（重要）<span style="color:red;">HashMap的添加流程</span>==

```JAVA
// 1.当我们想往一个HashMap中添加一个数据。 key=zs,value=20
// 2.对key计算它的hash。 也就是对zs取hash。
// 		计算hash的方法：(key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16)
// 3.使用计算得到的hash。与数组长度取余，得到这个key在数组上的位置
// 		a%b=a&(b-1)
// 4.检查数组位置上是否有键值对。
//   4.1 如果数组上没有元素，则直接新建节点，然后插入到数组。
//  				Node   key,value,hash,next(Node)
//   4.2 如果数组位置有元素，比较是否相等。
//  			怎么判断相等：p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k)))
//    1)如果相等，则直接使用新的value替代旧的value。结束
//	  2)如果不相等，则挨个进行比较。   链表直接调用next，树就是左小右大。一直比较到没有元素。
//	  		一直到最后一个。
// 5.如果是链表，插入后的长度超过阈值(8)。则会转化为红黑树
//		如果数组长度小于64。不会转化为红黑树，会直接进行扩容。
// 6.如果没有重复，插入后，map中节点数超过阈值。 默认为数组长度的0.75。则会进行扩容，扩容2倍。
// 		扩容后的位置： x或x+len 。len为数组的长度。  
// 7.上述所有的扩容, 都有可能导致原本数组某个位置如果有红黑树, 红黑树被拆成两部分(低位和高位), 任一位置结点数变少, 又有可能导致红黑树转化为链表
```



> 如何判断相等？
>
> hashCode相等 && (key的引用相等 || key equals()为true)

HashMap的添加流程：

```JAVA
1.我们要添加一个键值对进入 HashMap   zs,18
2.对key计算得到一个int值。  --》 hash  
    (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16)
2.使用int值对数组长度进行取余。  a%b=a&(b-1)  得到在数组上的下标位置 index
      hash & (length) - 1  
3.判断数组指定位置是否有元素。
    3.1如果没元素。 直接把键值对添加到数组位置 
     K key, V value,int hash,Node next
    3.2如果有元素。 进行挨个比较
        3.2.1 key 如果相等。(p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k))))
            （hash相同） && （（地址相同） || equals(内容)）
            使用新值替换旧值； 返回旧值
        3.2.2 接着往下比较。链表就一个一个往下走；红黑树按照左小右大的顺序走。

4.比较完成。没有相同的，相等的。
    把元素插入到末尾、
5.如果是链表，插入元素可能会导致 链表转换为红黑树
长度超过8到达9的时候，转为红黑树
       是不是长度超过8到达9，一定会由链表转成红黑树 --》 不一定，如果数组的长度 小于64

6.如果插入之后，可能会导致扩容。HashMap上的键值对，超过阈值(0.75 * 数组长度)，会扩容。扩容按照2倍扩的，扩容之后： x , x+oldCapacity 
```



## HashMap的构造方法

在空构造里没有看到对底层数组的赋值，所以在添加方法中，一定有这个过程。

单参构造器：会自动转为2的幂次方。和ArrayDeque的区别是传入16时，HashMap会是16，ArrayDeque会是32.



```JAVA
HashMap() 
          构造一个具有默认初始容量 (16) 和默认加载因子 (0.75) 的空 HashMap。 
HashMap(int initialCapacity) 
          构造一个带指定初始容量和默认加载因子 (0.75) 的空 HashMap。 会找到大于等于当前值的一个2的幂次方
HashMap(int initialCapacity, float loadFactor) 
          构造一个带指定初始容量和加载因子的空 HashMap。 
HashMap(Map<? extends K,? extends V> m) 
          构造一个映射关系与指定 Map 相同的新 HashMap。
```

## HashMap的API

```JAVA
//---------------------------新增，删除，查找数据接口
//添加键值对
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

//---------------------------视图方法
//返回此映射中包含的映射关系的 Set 视图。
    Set<Map.Entry<K,V>> entrySet()
//返回此映射中包含的键的 Set 视图。
    Set<K> keySet()
//返回此映射中包含的值的 Collection 视图。
    Collection<V> values()
```

## 组装数据

集合的操作非常重要，基本上业务代码都是完成各种各样数据的组装。

有三个类，其中一个存着学生的一些信息

```JAVA
// 一组学生数据，学生信息里有以下信息。
// (id, name, age, teacher_id)

// 一组班主任数据，有以下信息
// (id, name, age)

// 我们这样认为：一个老师对应n个学生，一个学生只对应一个老师。
// 现在需求方需要一个数据，需要返回 班主任的信息，然后和对应班级同学的信息。
// 提供两份数据：
//        List<Teacher> teachers = new ArrayList<>();
//        List<Student> students = new ArrayList<>();

class Grade{
   Teacher teacher;  
   List<Student> students;
}

```



# HashMap的源码

如果实在听不懂建议把琢磨源码的时间放给刷Leetcode.

看源码的方向

- 初始化
  - 长度是16
- 扩容策略
  - 2倍
- 添加数据和查找数据的流程



``` JAVA
class HashMap{
  //加载因子
  final float loadFactor;
  //阈值
  int threshold;
  //底层数组
  Node<K,V>[] table;
  
  static final float DEFUALT_LOAD_FACTOR = 0.75f;
  

}
```



> 看源码先梳理主流程，然后再仔细看细节。

# Hashtable

## 特点

1. Hashtable是Map接口的一个子实现
2. Hashtable底层结构是数组+链表 (和HashMap在jdk1.8之前是一样的)
3. 底层数组默认的初始长度11 ; 默认的扩容机制 2倍+1 
4. 存储元素无序
5. 不允许存储重复的key:   (对key的重复的定义和HashMap一样)
6. 不允许存储null作为key,   也不允许存储null作为value
7. 线程安全
8. jdk1.0时候出现,  (HashMap是jdk1.2时候出现, HashMap的出现就是为了取代Hashtable的)



ArrayList （1.2） vector （1.0）

Hashtable  仅限面试使用。

HashMap的红黑树，在1.8的时候才加上去。所以在1.8之前，两个的结构是一致的



一般面试官问，了解HashMap和Hashtable吗？ 

说一下HashMap和Hashtable的区别？



> 首先先说一下共同点
>
> 1.两个都是Map的子实现。都用来存储key-value数据
> 2.在1.8之前，两者底层结构都是数组+链表。但在1.8之后，HashMap变成了数组+链表+红黑树
> 3.存储元素无序，都不能存储重复元素。HashMap允许存储null。Hashtable不允许存储null
> // 如果记得，你就答一下。如果不记得。可以直接跳过。
> 4.HashMap线程不安全，Hashtable线程安全。
> 5.HashMap在1.2出现，就是为了替代Hashtable的。新写代码不使用Hashtable



面试答问题，要往自己熟悉的上面引。不要瞎引。

面试官问你一个问题，<span style="font-size:20px;color:red;">你要把自己熟悉的都答出来，不要面试官问你什么你就答什么，这样会很被动。</span>



```
不能面试官问你，了解这个吗。你说了解。
面试官问你使用过这个吗。你说使用过。

面试官问你这个，是想让你说你的认识。不是想听你回答了解，使用过这些的。大家要注意。
```



1.掌握先大后小顺序。先把整体的印象答出来。比如是谁的接口，用来干什么。

答好了之后，再答细节。切记上来就开始答细节。

2.要有逻辑。不要左答一点，右答一点。面试是向面试官展示你思考方式的机会。

不是说面试官提了10个题，你答了9个。就通过了。

面试官是试图通过这10个题，了解你的基础，了解你解问题的思路。

> 了解基础，了解思路，了解潜力

<span style=color:yellow;background:red>**切记。。。**</span>
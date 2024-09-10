[TOC]

# `Collection`

学习目标：

- 了解Collection接口的作用
- 掌握Collection的增、删、查方法
- 掌握Collection的遍历方法
- 掌握Collection遍历方法的特点及迭代器方法需要小心的bug
- <span style=color:yellow;background:red>**熟练掌握什么场景下使用Collection及其子类**</span>

> 单列数据时使用Collection

*一张集合框架的图在这里*



我们在学习任何一个接口之前，会讲接口的特点。接口的特点，<span style=color:red;background:yellow>**是重点。**</span>大家了解了这个特点，基本对这个接口的一些基本行为有一个认知。

## 特点

1. 体系结构中的位置：Collection是顶级接口，**描述数据存储**的接口.
2. Collection的一些子实现有序，一些无序(指的是**存取顺序**)
3. 一些子实现允许存储重复的数据，一些不允许
4. 一些子实现允许存储null，一些不允许

> 不能直接new Collection 这样只会得到一个匿名内部类
>
> ```Java
> Collection<Integer> collection = new ArrayList<>();
> ```

> 对于一个数据存储来说，有哪些方法是必要的？
>
> 增删改查。

传统的三件套。 数据存储是否有序，是否可以存重复的数据，是否可以存储null。 

> - 什么叫有序，什么叫无序？
>
> 集合类中指的是存储和读取的顺序，比如存入进去的是 `1 2 3 4 9`。读取出来的是`1 2 3 4 9`。或者 `9 4 3 2 1 `均称为有序。
>
> 其中有序的：ArrayList , LinkedList
>
> 无序的:HashSet
>
> - 什么可以存储重复，哪些不允许重复？
>
> 允许重复：ArrayList
>
> 不允许重复：HashSet
>
> - 哪些允许存储null？
>
> 允许存储null：ArrayList，HashSet
>
> 不允许存储null：TreeSet

## `API`

> Collection作为顶级容器没有提供修改方法，因为有些子类容器不允许修改

增

```Java
//添加一个元素进入Collection
boolean add(E e): 
//添加一个Collection进目标Collection；谁调用方法就向谁里面添加
boolean addAll(Collection<? extends E> c): 
```

删

​	如果存在多个只会删除第一个

​	如果删除一个不存在的元素，不会报错，会返回false；成功返回true

```Java
// 删除元素， 只删除第一个出现的(如果存在多个)
boolean remove(Object o)：
//删除Collection中的所有存在的元素,会全部删除；相当于差集。
boolean removeAll(Collection<?> c)： 
```

查

```Java
//判断是否存在指定元素
boolean contains(Object o)： 
//判断给定的collection中是否全部存在于目标Collection；也就是判断是否为子集
boolean containsAll(Collection<?> c)： 
//将原有collection只保留传入的collection。也就是取交集
boolean retainAll(Collection<?> c)： 
```

特殊方法

​	`Collection<String>` 清空返回的不是null而是空字符

```java
//清空collection
void clear()：
// 判断是否相等
boolean equals(Object o) ：
// 计算hashCode
int hashCode()：
// 是否为空
boolean isEmpty():
// collection里面的元素个数
int size()：
```

方便遍历方法

```Java
//将collection转成一个数组，方便遍历
Object[] toArray():
//类似，只是传入了一个数组
<T> T[] toArray(T[] a)：
//返回一个迭代器
Iterator<E> iterator()：
```

遍历：对一个集合中的元素，按照一定的顺序，访问且仅访问一遍。对集合的元素，挨个访问

### `toArray`方法

<font color=red>**无参方法**</font>

就是直接拷贝一份数据，创建一个新的数组。

*一张图片*

```java
// 底层是数组的实现
class ArrayList{
    //elementData: 存储数据的数组 
    Object[] elementData;

    // 数组列表的大小（它包含的元素数）
    int size;
}

```



<font color=red>**有参方法**</font>

使用有参时只需要传一个类型就可以，长度可以是0.



```JAVA
// a是传入的数组，用于接收这个
public <T> T[] toArray(T[] a) {
    if (a.length < size)
        // 当传入的数组长度 小于 原有集合的长度时候。使用一个类型，不使用这个数组
        // Make a new array of a's runtime type, but my contents:
        return (T[]) Arrays.copyOf(elementData, size, a.getClass());
    // 走到这一行，说明传入的数组 大于或者等于 原有集合的长度。
    // 直接将 elementData(原有数组) 拷贝到a(传入的数组) 
    System.arraycopy(elementData, 0, a, 0, size);

    // 如果数组长度大于集合长度。直接把a[size] = null。 直接把最后一个元素的后面置为null。
    if (a.length > size)
        a[size] = null;
    return a;
}
```



```Java
// 这是系统提供的一个数组拷贝方法。  --》 把一个数组复制到另外一个数组
// src 源数组
// srcPos 从什么地址开始复制（starting position in the source array.）
// dest 目标数组
// destPos 粘贴到的下标位置
// length 复制的长度（the number of array elements to be copied.）
public static native void arraycopy(Object src, int  srcPos, Object dest, int destPos, int length);
```

<font color=red>**有参构造方法**</font>

传入的数组长度与集合长度的对比。

1.如果数组长度<font color=red>**小于**</font>集合长度。只会使用传入的数组的类型，不会使用这个数组
2.如果数组长度<font color=red>**等于**</font>集合长度，会直接使用这个数组
3.如果数组长度<font color=red>**大于**</font>集合长度，也会使用这个数组，并且将数组的index=length位置的元素设置为null



<span style=color:red;background:yellow>**直接使用`toArray`这个有什么弊端？**</span>

`toArray`是将原Collection直接copy了一份。

- 耗费时间，需要将原有collection全部拷贝一遍
- 耗费空间，两倍的collection占有空间
- 后续使用完毕，还需要gc

我们一般遍历一个集合，有时候是想统计个数，有时候是想找出符合条件的，如果每次都复制一次，不仅耗费时间，而且使用完后，还需要`gc`。



在处理大量数据时，使用`toArray`方法需要谨慎考虑，因为它会将集合中的所有元素都复制到新的数组中，占用大量的内存空间。如果数据量非常大，可能会导致内存溢出的风险。

在处理大量数据时，建议使用迭代器进行遍历，而不是将集合转换为数组。迭代器可以逐个访问集合中的元素，并且不需要将所有元素都复制到新的数组中，从而减少内存的占用。



### `iterator`方法

**迭代器**（iterator），有时又称**光标**（cursor）是程序设计的软件设计模式，可在容器对象（container，例如链表或数组）上遍历的接口，设计人员无需关心容器对象的内存分配的实现细节。

<span style=color:red;background:yellow>**是用来遍历这个容器对象所有数据的接口。**</span>

迭代器相当于只保留了一个标识，标识我可以怎么拿到这个数据，不copy数据。所有操作的数据都是针对的原有的Collection。

对于一个集合（底层实现：数组）来说，我想遍历这个集合，只需要下标；对于底层实现是链表来说，只需要指针。

好处是什么？

`Iterator`是个接口，接口只定义规范，我们获取到了iterator，就可以使用这个对象对数据进行遍历。把接口与实现隔离。

如何使用

```JAVA
//  是否有下一个元素   
boolean hasNext():
//获取下一个元素    
E next()： 
// 删除刚刚遍历过的元素    
void remove()：
```



> .next光标往后挪返回刚刚经过的元素。
>
> 
>
> void remove（）----->  删除刚刚遍历过的元素
>
> 也就是只能遍历一下删除一下，不能连续删除。
>
> iterator是否保存集合中的数据 ----> 不保存
>
> 删除的是哪里的数据？ ---->  集合中的数据



比如Collection底层有的是数组，有的是链表。

数组的Iterator里面维护的是下标

链表的Iterator里面维护的是指针。

所有的具体实现都交给具体的子类。接口只定义一个规范。



**迭代器是个游标，它遍历的时候，被别的线程，把原集合中加了几个元素，减了几个元素，那这时候这次遍历的意义大吗？**

`JDK`采用了存储一个值的方式，去保证在迭代器使用过程中，原有的集合不被修改（当前线程、其他线程）。

在Collection内部，有一个`modCount`,用来<span style=color:green;background:white>**标识结构变化**</span>的次数(get/contains 这种查询不叫结构变化)

生成迭代器的时候，存储这个`expectedModCount=modCount`,在调用 next remove时候，会检查。使用迭代器过程中，如果原结构发生了变化，会报**并发修改异常**<span style=color:yellow;background:red>**（ConcurrentModificationException）**</span>。

如果见到了，需要检查，是不是在迭代器使用过程中，修改了原有集合。



迭代器怎样使用

```JAVA
//    boolean hasNext(): 是否有下一个元素
//    E next()： 获取下一个元素
//    void remove()： 删除刚刚遍历过的元素

    @Test
    public void iteratorDemo1() {
        Collection<String> collection = new ArrayList<>();
        collection.add("zs");
        collection.add("ls");
        collection.add("wu");

        // 现有collection里面有 三个元素。 [zs, ls, wu]
        System.out.println(collection);

        // 调用iterator()方法，生成一个迭代器。迭代器本身不存储数据。所以它操作的数据都是原有集合的
        Iterator<String> iterator = collection.iterator();

        // 现在的迭代器和数据 示意图：
        //  数据：   [     zs           ls           wu   ]
        //  迭代器位置： |

        // 迭代器后是否有元素。
        System.out.println(iterator.hasNext());

        // 将指针往后挪动，并返回刚刚经过的元素
        String next = iterator.next();
        System.out.println(next);
        
        // 现在的迭代器和数据 示意图：
        //  数据：   [     zs           ls           wu   ]
        //  迭代器位置： ------- |
    }

```





<font color=red>**怎么解决会出现并发修改异常问题？**</font>

不要在迭代器迭代过程中，去修改原集合。要不就是在迭代器生成之前，要不就在迭代器使用完成之后。



```JAVA
    Collection<String> collection = new ArrayList<>();

    collection.add("zs");
    collection.add("ls");
    collection.add("wu");

	// ========================= 这个位置之前叫做迭代器生成之前 =========================
    Iterator<String> iterator = collection.iterator();

    while (iterator.hasNext()) {
       // 不能边使用，边修改原有集合。
      // collection.remove("zs");

      String next = iterator.next();
      System.out.println(next);
    }

	// ========================= 这个位置之前叫做迭代器生成之后 =========================
```



## `foreach`

<u>工作中一般使用`foreach`居多</u>。底层也是iterator。

所以需要注意，在`foreach`中，不要去改变Collection的结构。

```JAVA
Collection<String> collection = new ArrayList<>();

collection.add("zs");
collection.add("ls");
for (String s : collection) {
    System.out.println(s);
}
```



<font color=red>**案例1**</font>

```JAVA
// 1.存储一组学生。包括 姓名 年龄，总分，入学日期
// 2.找出总分最高的学生？
// 3.找出总分最低的学生
// 4.求平均分
// 5.删除低于平均分的学生
// 6.找出2年内入学的学生。
// 7.需要删除叫张三的学生
// 8.删除年龄小于18的学生
```

<font color=red>**案例2**</font>

```JAVA
// 存储一组订单数据。订单的信息包括，订单号，订单金额，订单时间，订单状态(未付款、已付款、已发货、已评价)，订单更新时间
// 新建5条订单放入 
// 2.找出下单时间最早的订单，并打印
// 3.找出订单状态是已付款的
// 4.找出订单金额超过200的，并且订单状态是已发货

// 思考一下，这些条件怎么传？
```



获取到一段描述后，需要掌握以下能力。将描述转化为代码的能力。



<span style=color:red;background:yellow>**总结**</span>

🟡 怎样去遍历Collection接口

```JAVA
// 使用 iterator  
Collection<String> collection = new ArrayList<>();

collection.add("zs");
collection.add("ls");
collection.add("wu");

// 使用的时候，先生成一个迭代器
Iterator<String> iterator = collection.iterator();

while (iterator.hasNext()) {
    String next = iterator.next();
    System.out.println(next);
}


// 使用foreach
for (String next : collection) {
    System.out.println(next);
}

// 三种 迭代器，foreach，toArray
```



 🟡如何删除Collection中所有的zs和ls数据？

```JAVA
// 遍历，删除
// 1.方式1  
// 创建一个新的集合；
// 遍历原有集合。
//		判断。是否 zs  ls ; 是的话，添加到新集合
// removeAll()
// 遍历新集合 --》  remove()

// 2.方式2
// 迭代器
// 创建一个迭代器。遍历这个迭代器(while hasNext() next() )
// 判断， 是不是zs  或者 ls 。 是的话，remove  iterator.remove()
// 切记，不能通过原有集合的remove()


// 使用一个集合类，把所有的zs 和ls 都存起来。然后遍历集合类，再调用原有集合类的remove方法

// 使用一个集合类，存储 zs  ls  调用removeAll方法

// 使用迭代器的删除方法

// Collection<String>  
// Collection<Student> 
```



遍历Collection接口的时候，有什么需要注意的事项

<span style=color:yellow;background:red>**注意并发修改异常。出现的原因，以及解决的办法。**</span>

# `List`接口

学习目标

- <span style=color:red;background:yellow>**重点掌握List接口的特点，及其使用场景**</span>
- 掌握List接口特殊的方法（带有下标的方法 add addAll remove get set ）
- 掌握List接口的特有遍历方式（get(index)）
- ArrayList的底层结构。初始化容量，扩容策略。（数组。10。*1.5）
- LinkedList的底层结构(双向链表)
- <span style=color:red;background:yellow>**（面试）Vector和ArrayList的区别？为什么被替换掉**</span>
- Stack是什么？在Java中想使用栈，应该怎么创建



## 特点(重点)

1. List是Collection的子接口。（父子继承关系，想对原有接口进行增强。）
2. 数据结构表现为线性表。
3. 存储数据有序。（存储进去的顺序和读取出来的顺序。 完全一致或者完全相反）
4. 可以存储重复元素
5. 可以存储null



<font color=red>**线性表**</font>

线性表，全名为线性存储结构。使用线性表存储数据的方式可以这样理解，即“把所有数据用一根线儿串起来，再存储到物理空间中”。



就是一对一的数据结构。一个数据元素，除了第一个元素和最后一个元素，都只有一个前驱一个后继。



<span style=color:yellow;background:red>**一定要掌握。**</span>数组的插入数据，删除数据流程；链表的插入数据，删除数据流程。


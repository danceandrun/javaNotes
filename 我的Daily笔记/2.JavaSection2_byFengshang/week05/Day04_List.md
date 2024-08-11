# `List`接口

学习目标

- <span style=color:red;background:yellow>**重点掌握List接口的特点，及其使用场景**</span>

  - （能用数组的地方）

- 掌握List接口特殊的方法

  - （带有下标的方法 add addAll remove get set ）

- 掌握List接口的特有遍历方式

  - 增加了一个fori循环（get(index)）

- ArrayList的底层结构。初始化容量，扩容策略。

  - （数组。10。*1.5）

- LinkedList的底层结构

  - (双向链表)

- <span style=color:red;background:yellow>**（面试）Vector和ArrayList的区别？为什么被替换掉**</span>

- Stack是什么？在Java中想使用栈，应该怎么创建

  - Deque


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



## `List`的`API`

`List`是`Collection`的子接口。所有肯定有`Collection`的所有方法。

`Collection`的API我们已经学习过，所以直接学习`List`所特有的。

// 线性表。 和Collection里面的API，最大的区别，就是**增加了很多下标操作**。



```java
//在指定位置添加元素。list添加的位置，只能在[0,length之间]  
void add(int index, E element)；
  
//在指定位置添加一个Collection的所有元素    
boolean addAll(int index, Collection<? extends E> c)；
  
//删除指定下标的元素，只能删除下标的位置[0, lenth-1]。返回的是删除的元素
  注意这里remove方法可以传参Obeject所以如果index是Integer需要index.intValue() 🟡
E remove(int index)；

// 设置指定下标的元素为element
（类似于数组的array[index] = element）
E set(int index, E element)；
  
//获取指定下标元素
  (类似于arrary[index])
E get(int index)
  
	//获取元素的首个index；如果该元素不存在则返回值是-1.   
int indexOf(Object o)
	//获取元素的最后一个index；如果该元素不存在则返回值是-1.       
int lastIndexOf(Object o)

  //截取  
List<E> subList(int fromIndex, int toIndex)；

```



```JAVA
ListIterator<E> listIterator()；
ListIterator<E> listIterator(int index)；
```

<span style=color:red;background:yellow>**需要注意的东西**</span>

- 画图，理清操作的是哪个位置。
  - add（1， “666”）
  - add(5,"888")
  - add(6，“777”)

### `listIterator`方法

返回一个`ListIterator`的对象。这个与迭代器类似，只是可以前后移动，可以返回index。

- 有参构造，返回的迭代器对象，调用next返回的是指定下标的元素。<font color=red>**所以传入的index应该在什么范围？**</font>

[0,length]

```java
ListIterator<String> listIterator = list.listIterator(index);
```

> 利用这一点可以实现倒序遍历，即先设置光标在length位置，然后previous向前遍历。
>
> 同样的，还可以使用get方法得到下标实现倒序遍历。

 🟡要注意指针的位置

```java
public interface ListIterator<E> extends Iterator<E>

// 判断后面是否还有元素可以遍历
	boolean hasNext；
//向后遍历
	E next()
//删除刚刚遍历的数据
	void remove()

//向前是否可以遍历
	boolean hasPrevious()
//向前遍历
  E previous()
  
//向后遍历的数据的下标
  int nextIndex()
//向前遍历的下标
  int previousIndex()
  
//添加一个数据到当前遍历位置,并且把指针往后挪一下
  注意指针会往后挪
  void add(E e)
//修改刚刚遍历过的元素位置
  该方法和remove一样不能直接用要使用next或者previous遍历一个；但是可以连续set不同于remove的不可以连续.
  void set(E e)
```



### `subList`方法

返回列表中指定的 `fromIndex`（包括 ）和 `toIndex`（不包括）之间的部分**视图**。

<span style=color:red;background:yellow>**视图：**</span>只是原表的一个映射，并没有把数据复制一份。它和`iterator`很相似，只是维护了几个标记。操作`subList`产生的对象，会影响原来的对象。

相当于，只是一个看起来和原有数组一致，可以把它理解为镜子。

🟡 操作subList也会影响原本的集合

 📣在使用subList的过程中，千万不要认为subList里面有多少数据，底层就存储多少数据。

> 注意：它也会存在并发修改的问题。当生成了`subList`之后，如果再修改原集合。再访问`subList`的对象，会报错。

注意一些坑：

- 注意`oom`，因为`subList`只是一个视图，它保留了原始的数组。所以如果错误估计，可能会`oom`

  

```JAVA
怎么出现oom，设置小堆内存。切记不要直接跑，可能会导致电脑死机
IDEA中，可以针对当前代码，设置最大的运行内存
Edit Configurations --> Add VM options -->
-Xmx500m -Xms500m
    
  -Xmx500m 最大堆内存 500m
  -Xms500m 初始堆内存 
```

- <span style=color:red;background:yellow>**注意并发修改异常**</span>

## <span style=color:yellow;background:red>**ArrayList**</span>

ArrayList是Java集合框架中的一种，它实现了List接口，可以动态地添加、删除和修改元素。<span style=color:red;background:yellow>**与传统的数组不同，ArrayList的大小可以根据需要自动增长和缩小，因此非常适用于需要频繁添加或删除元素的场景。**</span>

<span style=color:yellow;background:red>**ArrayList内部实际上是一个动态数组，它可以存储任意类型的对象。**</span>当创建一个ArrayList时，它的初始容量是10个元素，当元素数量超过容量时，ArrayList会自动增加容量，以便能够容纳更多的元素。

ArrayList提供了一系列方法，可以方便地操作其中的元素，例如add()方法可以在末尾添加元素，remove()方法可以删除指定位置的元素，get()方法可以获取指定位置的元素，set()方法可以修改指定位置的元素等等。

### 特点

1. ArrayList是List的实现。
2. ArrayList数据结构表现为线性表
3. <span style=color:red;background:yellow>**底层结构是数组**</span>
4. 存储元素，有序
5. 可以存储重复元素
6. 可以存储null

### 构造方法

```java
//构造一个初始容量为 10 的空数组。
	ArrayList()；
//构造一个包含指定 collection 的元素的列表，这些元素是按照该 collection 的迭代器返回它们的顺序排列的。
  ArrayList(Collection<? extends E> c)；
//构造一个具有指定初始容量的空列表。    
  ArrayList(int initialCapacity)

// List接口。 接口没有构造方法
```

### `ArrayList`的`API`

```java
//    返回此 ArrayList 实例的浅表副本。
//浅拷贝和深拷贝
Object clone()
//    如有必要，增加此 ArrayList 实例的容量，以确保它至少能够容纳最小容量参数所指定的元素数。
void ensureCapacity(int minCapacity)
//    将此 ArrayList 实例的容量调整为列表的当前大小。
void trimToSize()

```

怎么写集合

推荐一般情况用List引用指向ArrayList对象。

原因在于面向接口编程，这样如果以后发现数组效率不行，可以便于在不改变引用的情况下，改对象new LinkedList<>().

```JAVA
List<String> list = new ArrayList<>();
```



## `ArrayList`的源码

关心两点：1.在哪里进行初始化的；2.怎么扩容的

### 初始化

```JAVA
class ArrayList{
  //底层存数据的数组
  Object[] elementData;
  //实际存储的数据大小
  int size;
  
      public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }
  
      public boolean add(E e) {
        ensureCapacityInternal(size + 1);  // Increments modCount!!
        elementData[size++] = e;
        return true;
    }
  
  		//ensureCapacityInternal方法
      private void ensureCapacityInternal(int minCapacity) {
        ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
    }
  
		// ensureExplicitCapacity方法
    private void ensureExplicitCapacity(int minCapacity) {
        modCount++;

        // overflow-conscious code
        if (minCapacity - elementData.length > 0)
            grow(minCapacity);
    }
  
  
  		//grow方法
      private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
  
  
}

```

### 扩容

```JAVA
class ArrayList{
    //底层存数据的数组
  Object[] elementData;
  //实际存储的数据大小
  int size;
  
        public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }
  
      public boolean add(E e) {
        ensureCapacityInternal(size + 1);  // Increments modCount!!
        elementData[size++] = e;
        return true;
    }
  
}
```

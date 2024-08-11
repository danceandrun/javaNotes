[TOC]

# LinkedHashMap

## LinkedHashMap的特点

1. LinkedHashMap是HashMap的一个子类
2. LinkedHashMap底层基本上完全复用了父类HashMap的结构/参数/方法
3. LinkedHashMap在HashMap的基础上, <span style=color:red;background:yellow>**额外的维护了一个双向链表, 以保证迭代顺序**</span>
4. LinkedHashMap存储<span style=color:red;background:yellow>**元素有序**</span>
5. LinkedHashMap不允许存储重复数据
6. LinkedHashMap允许存储null

## LinkedHashMap的构造方法

```JAVA
LinkedHashMap() 
          构造一个带默认初始容量 (16) 和加载因子 (0.75) 的空插入顺序 LinkedHashMap 实例。 
LinkedHashMap(int initialCapacity) 
          构造一个带指定初始容量和默认加载因子 (0.75) 的空插入顺序 LinkedHashMap 实例。 
LinkedHashMap(int initialCapacity, float loadFactor) 
          构造一个带指定初始容量和加载因子的空插入顺序 LinkedHashMap 实例。 
LinkedHashMap(int initialCapacity, float loadFactor, boolean accessOrder) 
          构造一个带指定初始容量、加载因子和排序模式的空 LinkedHashMap 实例。 
LinkedHashMap(Map<? extends K,? extends V> m) 
          构造一个映射关系与指定映射相同的插入顺序 LinkedHashMap 实例。 
```

## LinkedHashMap的api

```JAVA
//---------------------------新增，删除，查找数据接口
//添加键值对
		V put(K key, V value);
//将一个map的所有键值对都放入这个map
    void putAll(Map<? extends K,? extends V> m);
//根据一个key，获取value，如果key不存在，返回null
    V get(Object key);
//删除map中所包含的这个key
    V remove(Object key);

//判断map中是否包含这个key
    boolean containsKey(Object key);
//判断map中是否包含这个value
    boolean containsValue(Object value);

//---------------------------辅助接口
//清空map
void clear();
//判断两个map是否相等
boolean equals(Object o);
//返回此映射的哈希码值。
int hashCode();
//map中是否有元素
boolean isEmpty();
//返回键-值映射关系数。
int size();

//---------------------------视图方法
//返回此映射中包含的映射关系的 Set 视图。
Set<Map.Entry<K,V>> entrySet();
//返回此映射中包含的键的 Set 视图。
Set<K> keySet();
//返回此映射中包含的值的 Collection 视图。
Collection<V> values();
```

# TreeMap

## TreeMap的特点

1. TreeMap是Map接口的子实现
2. TreeMap的数据结构红黑树。
   1. 红黑树特点：（左小右大）

3. TreeMap存储数据大小有序。(前面的有序都是存取有序)
4. TreeMap不允许存储重复的key 
   1. 什么叫重复: key的大小一样，compareTo结果返回值是0.
   2. 使用自定义的类作为TreeMap的key的两种方法：要么实现Comparable接口，要么在构造方法传入Comparator

5. TreeMap不允许存储null作为key:   null没有办法比较大小

## TreeMap的构造方法

```JAVA
构造方法摘要 
TreeMap() 
          使用键的自然顺序构造一个新的、空的树映射。 
TreeMap(Comparator<? super K> comparator) 
          构造一个新的、空的树映射，该映射根据给定比较器进行排序。 
TreeMap(Map<? extends K,? extends V> m) 
          构造一个与给定映射具有相同映射关系的新的树映射，该映射根据其键的自然顺序 进行排序。 
TreeMap(SortedMap<K,? extends V> m) 
          构造一个与指定有序映射具有相同映射关系和相同排序顺序的新的树映射。 
```

//Comparable接口：在JAVA中要实现两个对象的比较，该类需要实现Comparable接口。

## TreeMap的api



```JAVA
// ----------------------从Map接口继承来的----------------------------
//如果此映射包含指定键的映射关系，则返回 true。
boolean containsKey(Object key)
     
//如果此映射为指定值映射一个或多个键，则返回 true。
  boolean containsValue(Object value)
       
//将指定值与此映射中的指定键进行关联。
  V put(K key, V value)
     
// 将指定映射中的所有映射关系复制到此映射中。
  void putAll(Map<? extends K,? extends V> map)
   
// 如果此 TreeMap 中存在该键的映射关系，则将其删除。
  V remove(Object key)
//       
//返回指定键所映射的值，如果对于该键而言，此映射不包含任何映射关系，则返回 null。
  V get(Object key)


//        void clear()
//        从此映射中移除所有映射关系。
//        Object clone()
//        返回此 TreeMap 实例的浅表副本。
//        int size()
//        返回此映射中的键-值映射关系数。


//        Collection<V> values()
//        返回此映射包含的值的 Collection 视图。
//        Set<K> keySet()
//        返回此映射包含的键的 Set 视图。
//        Set<Map.Entry<K,V>> entrySet()
//        返回此映射中包含的映射关系的 Set 视图。      
        
// ------------------------TreeMap定义大小操作相关的api------------------------
//大于等于给定key的最小键值对
  Map.Entry<K,V> ceilingEntry(K key)
//大于等于给定key的最小key
  K ceilingKey(K key)
//小于等于key的最大的键值对
  Map.Entry<K,V> floorEntry(K key)
//小于等于key最大的key
  K floorKey(K key)
  
//大于给定key的最小键值对
  Map.Entry<K,V> higherEntry(K key)
//大于给定key的最小key
  K higherKey(K key)
//小于key的最大的键值对
  Map.Entry<K,V> lowerEntry(K key)
//小于key最大的key
  K lowerKey(K key)

//返回最小的键值对
  Map.Entry<K,V> firstEntry()
//返回最小的key
  K firstKey()
//返回最大的键值对
  Map.Entry<K,V> lastEntry()
//返回最大的key
  K lastKey()

//删除最小的键值对Map.Entry<K,V>
  pollFirstEntry()
//删除最大的键值对
  Map.Entry<K,V> pollLastEntry()


// ---------------------视图方法-----------------------------
//返回此映射的部分视图，其键的范围从 fromKey 到 toKey。
  NavigableMap<K,V> subMap(K fromKey, boolean fromInclusive, K toKey, boolean toInclusive)
   
//返回此映射的部分视图，其键值的范围从 fromKey（包括）到 toKey（不包括）。
  SortedMap<K,V> subMap(K fromKey, K toKey)
  
//返回此映射的部分视图，其键大于等于 fromKey。
  SortedMap<K,V> tailMap(K fromKey)

//返回此映射的部分视图，其键大于（或等于，如果 inclusive 为 true）fromKey。
  NavigableMap<K,V> tailMap(K fromKey, boolean inclusive)
 
//返回此映射的部分视图，其键值严格小于 toKey。
  SortedMap<K,V> headMap(K toKey)

//返回此映射的部分视图，其键小于（或等于，如果 inclusive 为 true）toKey。
  NavigableMap<K,V> headMap(K toKey, boolean inclusive)
  

// -------------------------一些特殊的api: 了解-------------------------------
//返回此映射中所包含键的逆序 NavigableSet 视图。
  NavigableSet<K> descendingKeySet()

//返回此映射中所包含映射关系的逆序视图。
  NavigableMap<K,V> descendingMap()

// 返回此映射中所包含键的 NavigableSet 视图。
  NavigableSet<K> navigableKeySet()
   
//返回对此映射中的键进行排序的比较器；如果此映射使用键的自然顺序，则返回 null。
  Comparator<? super K> comparator()   
```



TreeMap的应用：

假设我们需要实现一个功能，即存储某个城市的天气预报，并且需要按照时间排序。在这种情况下，我们可以使用TreeMap来存储天气预报信息。

具体来说，我们可以将预报时间作为key，将天气预报信息（如温度[temperature](javascript:;)、湿度[humidity](javascript:;)、气压[air_pressure](javascript:;)等）作为value存储在TreeMap中。由于TreeMap是有序的，因此我们可以方便地按照时间顺序遍历元素，从而实现预报信息的展示和查询功能。



想根据 2023-04-24这天的天气。

想获取  17-23号的天气。



如果需要Map中的key，有序的时候，可以使用这个TreeMap。



map.subMap(new Date("2023-04-17"), true,new Date("2023-04-24"), false)



// HashMap   + ArrayList  

# Properties

在工作中，会用到。需要掌握。一般都是使用它来从properties配置文件中读写。

继承自HashTable，HashTable不会使用。

Hashtable的子类

当做配置文件使用，只能存入String类型的。



```JAVA
// 注意，只能存入String类型的key，value。否则在存储为properties文件的时候，会报错
// 新增key,value 使用的方法
setProperty()
    
// 根据key查询value的方法，使用
getProperty()
```



properties文件(1.properties)

```properties
# key=value 格式去写
username=zhangsan
password=admin
```



读取properties文件

```JAVA
Properties properties1 = new Properties();
properties1.load(new FileInputStream("1.properties"));
```



为什么一般把配置放在配置文件里，它和我们直接写在代码里，有什么区别？

> 情况一：修改了代码之后，上线前需要测试。写在配置文件上之后，修改配置文件这时候不需要测试。
>
> 情况二：有很多环境，如果配置在代码里就需要维护很多套代码，开发环境、测试环境、联调环境、模拟上线环境

# Set

学习目标：

- 掌握Set接口存储数据的特点
- 掌握Set的子类。HashSet，LinkedHashSet，TreeSet存储数据的特点
  - 是否有序
  - 对重复的定义
  - 是否允许存储null
- 了解Set子类的实现方式
- <span style=color:yellow;background:red>**熟练掌握Set的使用场景**</span>

## 特点

1.  Set是Collection的子接口
2.  Set数据结构是: 集合（不能存储重复元素）
3.  有些子实现无序(HashSet),  有些子实现是有序的(LinkedHashSet存储有序, TreeSet大小有序)
4.  所有子实现都不允许存储重复元素（什么叫重复。 HashSet或者LinkedHashSet  hashCode相同& equals 为true   TreeSet是Comparable接口返回0，叫重复。）
5.  有些子实现允许存储null(HashSet, LinkedHashSet), 有些子实现不允许存储null(TreeSet)

## Set的API

```JAVA
// -------------------------set接口, 没有在Collection的基础上额外定义什么api---------

//    ---------------------------------增删改查方法---------------------------------
//添加一个元素进入Collection
	boolean add(E e);
//添加一个Collection进指定的Collection
  boolean addAll(Collection<? extends E> c);
//删除元素， 只删除第一个出现的(如果存在多个)
    boolean remove(Object o);
//删除Collection中的所有存在的元素,会全部删除，如果存在多个
    boolean removeAll(Collection<?> c);
//判断是否存在指定元素
    boolean contains(Object o);
//判断给定的collection中是否全部存在于目标Collection
    boolean containsAll(Collection<?> c);
//将原有collection只保留传入的collection。
    boolean retainAll(Collection<?> c);

//    ---------------------------------特殊方法---------------------------------
//清空collection
    void clear();
//判断是否相等
    boolean equals(Object o);
//计算hashCode
    int hashCode();
//是否为空
    boolean isEmpty();
//collection里面的元素个数
    int size();
//
//    ---------------------------------方便遍历方法---------------------------------
//将collection转成一个数组，方便遍历，
Object[] toArray();
//类似，只是传入了一个数组
<T> T[] toArray(T[] a);
//返回一个迭代器
Iterator<E> iterator();
```

## HashSet

### HashSet的特点

1.  HashSet是Set接口的子实现
2.  HashSet底层持有了一个HashMap对象
    1. 我们存储到HashSet中的数据, 实际上都存储到底层持有的HashMap的key上
    2. HashSet的特点和HashMap对key的特点保持一致
3.  HashSet存储数据无序
4.  HashSet不允许存储重复数据。<span style=color:red;background:yellow>**注意这个重复的定义。**</span>
5.  HashSet允许存储null元素

### HashSet的构造方法

```java
HashSet() 
          构造一个新的空 set，其底层 HashMap 实例的默认初始容量是 16，加载因子是 0.75。 
HashSet(Collection<? extends E> c) 
          构造一个包含指定 collection 中的元素的新 set。 
HashSet(int initialCapacity) 
          构造一个新的空 set，其底层 HashMap 实例具有指定的初始容量和默认的加载因子（0.75）。 
HashSet(int initialCapacity, float loadFactor) 
          构造一个新的空 set，其底层 HashMap 实例具有指定的初始容量和指定的加载因子。 
```

### HashSet的API

```JAVA
// ----------HashSet ,    set接口, 没有在Collection的基础上额外定义什么api---------
```

## LinkedHashSet

### LinkedHashSet的特点



1.  LinkedHashSet是HashSet一个子类
2.  LinkedHashSet底层持有一个LinkedHashMap对象
    1. LinkedHashSet的特点和LinkedHashMap的key保持一致
3.  LinkedHashSet存储数据有序
4.  LinkedHashSet 不允许存储重复数据
5.  LinekdHashSet允许存储null
6.  线程不安全

与HashSet唯一的不同：

<span style=color:red;background:yellow>**存储数据有序**</span>



线程安全的Vector,HashTable已经不再使用。

### LinkedHashSet的构造方法

```java
LinkedHashSet() 
  构造一个带默认初始容量 (16) 和加载因子 (0.75) 的新空链接哈希 set。 
LinkedHashSet(Collection<? extends E> c) 
  构造一个与指定 collection 中的元素相同的新链接哈希 set。 
LinkedHashSet(int initialCapacity) 
  构造一个带指定初始容量和默认加载因子 (0.75) 的新空链接哈希 set。 
LinkedHashSet(int initialCapacity, float loadFactor) 
  构造一个带有指定初始容量和加载因子的新空链接哈希 set。 
```

### LinkedHashSet的api

```java
// --LinkedHashSet, HashSet ,    set接口, 没有在Collection的基础上额外定义什么api---------
```

## TreeSet

### TreeSet的特点

1. TreeSet是Set接口的子实现
2. TreeSet底层持有了一个TreeMap对象
   1. TreeSet存储数据的特点和TreeMap的key保持一致
3. TreeSet存储数据大小有序（大小有序  不是存储的顺序）
4. TreeSet不允许存储重复数据: (重复指的是 Comparable接口返回的 是0 ；大小重复)
5. TreeSet不允许存储null
6. 线程不安全

### TreeSet的构造方法

```java
TreeSet();
  构造一个新的空 set，该 set 根据其元素的自然顺序进行排序。 
TreeSet(Collection<? extends E> c);
  构造一个包含指定 collection 元素的新 TreeSet，它按照其元素的自然顺序进行排序。 
TreeSet(Comparator<? super E> comparator); 
  构造一个新的空 TreeSet，它根据指定比较器进行排序。 
TreeSet(SortedSet<E> s); 
  构造一个与指定有序 set 具有相同映射关系和相同排序的新 TreeSet。 
```

### TreeSet的API

```java
// --TreeSet ,    set接口, 没有在Collection的基础上额外定义什么api---------

NavigableSet<E> subSet(E fromElement, boolean fromInclusive, E toElement, boolean toInclusive) 
  返回此 set 的部分视图，其元素范围从 fromElement 到 toElement。
  
SortedSet<E> subSet(E fromElement, E toElement) 
  返回此 set 的部分视图，其元素从 fromElement（包括）到 toElement（不包括）。 
  
SortedSet<E> tailSet(E fromElement) 
  返回此 set 的部分视图，其元素大于等于 fromElement。 
  
NavigableSet<E> tailSet(E fromElement, boolean inclusive) 
  返回此 set 的部分视图，其元素大于（或等于，如果 inclusive 为 true）fromElement。 
```

<span style=color:red;background:yellow>**有序 **</span>

LinkedHashSet （有序的）--》 它的有序，指的是  add 顺序。添加进去的顺序

TreeSet (有序的)-->是根据 Comparable  返回的结果。

<span style=color:red;background:yellow>**重复**</span>

LinkedHashSet  HashSet ：  hashCode  && （equals）

TreeSet：   Comparable 返回0



# 集合类的总结

老师的那个思维导图

允许存储null： List HashSet LinkedHashSet

不允许存储null: Queue(除了LinkedList)



API ：增删改查 /其他API /遍历API






[TOC]

# Stream

学习目标

- 掌握流的使用
- 掌握流的几个重要中间操作。（filter，map）
- 掌握流的几个重要终止操作（collect）
- <span style=color:red;background:yellow>**会使用流进行数据的处理工作**</span>

## 引言

就是一个普通的bean（普通的对象）

VO  和前端打交道的对象。后端完成数据处理之后将数据封装到一个对象里面(VO USERVO) , 序列化传递给前端。

DO  和数据库打交道的对象。

```JAVA
public class Student {
    public enum Address {
        BJ, SH, WH, SZ
    }

    public Student(String name, int age, int height, Address address) {
        this.name = name;
        this.age = age;
        this.height = height;
        this.address = address;
    }

    private String name;
    private int age;
    private int height;
    private Address address;
  
  // todo getter & setter
  // hashcode & equals
}
```

```JAVA
public class StudentList {
  public List<Student> studentList;

  public StudentList() {
    this.studentList = new ArrayList<>();

    studentList.add(new Student("aa", 18, 170, Student.Address.BJ));
    studentList.add(new Student("bb", 20, 163, Student.Address.SH));
    studentList.add(new Student("cc", 30, 182, Student.Address.WH));
    studentList.add(new Student("dd", 16, 190, Student.Address.BJ));
    studentList.add(new Student("ee", 15, 210, Student.Address.SH));
    studentList.add(new Student("ff", 17, 160, Student.Address.WH));
    studentList.add(new Student("gg", 18, 169, Student.Address.BJ));
    studentList.add(new Student("hh", 20, 173, Student.Address.WH));
    studentList.add(new Student("ii", 22, 192, Student.Address.SH));
    studentList.add(new Student("jj", 25, 172, Student.Address.SH));
    studentList.add(new Student("kk", 24, 188, Student.Address.BJ));
    // 重复元素 kk
    // studentList.add(new Student("kk", 24, 188, Student.Address.BJ));
    studentList.add(new Student("ll", 17, 161, Student.Address.WH));
    studentList.add(new Student("mm", 18, 169, Student.Address.SH));
    studentList.add(new Student("nn", 20, 162, Student.Address.BJ));
    studentList.add(new Student("oo", 22, 166, Student.Address.SH));
    studentList.add(new Student("pp", 24, 176, Student.Address.WH));
    studentList.add(new Student("qq", 22, 173, Student.Address.BJ));
    // 重复元素 qq
    // studentList.add(new Student("qq", 22, 173, Student.Address.BJ));
    studentList.add(new Student("rr", 24, 177, Student.Address.BJ));
    studentList.add(new Student("ss", 17, 169, Student.Address.SH));
    studentList.add(new Student("tt", 18, 170, Student.Address.SH));
    studentList.add(new Student("uu", 20, 171, Student.Address.WH));
    studentList.add(new Student("vv", 22, 172, Student.Address.WH));
    studentList.add(new Student("ww", 24, 181, Student.Address.BJ));
    studentList.add(new Student("xx", 18, 188, Student.Address.SH));
    studentList.add(new Student("yy", 20, 183, Student.Address.BJ));
    studentList.add(new Student("zz", 22, 191, Student.Address.WH));
  }
}

```

 ⭐问题

我们要对这个学生列表进行处理:  <span style="color:red">得到来自北京, 并且高度最高的三个同学</span>

<span style="font-size:20px;color:red;">应该怎么做？</span>

```JAVA
public static void main(String[] args) {
    StudentList studentList = new StudentList();
    List<Student> students = studentList.studentList;

  TreeSet<Student> treeSet = new TreeSet<>(new Comparator<Student>() {
    @Override
    public int compare(Student o1, Student o2) {

      int com = o2.getHeight() - o1.getHeight();

      if (com != 0) {
        return com;
      }

      com = com == 0 ? o2.getName().compareTo(o1.getName()) : com;
      com = com == 0 ? o2.getAge() - o1.getAge() : com;
      com = com == 0 ? o2.getAddress().compareTo(o1.getAddress()) : com;

      return com;
    }
  });


    for (Student student : students) {
      if (student.getAddress() == Student.Address.BJ) {
        studentTreeSet.add(student);
      }
    }

    System.out.println(studentTreeSet.first());
    studentTreeSet.pollFirst();
    System.out.println(studentTreeSet.first());
    studentTreeSet.pollFirst();
    System.out.println(studentTreeSet.first());
    studentTreeSet.pollFirst();
  }
```

## 使用流解决上述问题

```JAVA
public void testWithStream() {
    List<Student> studentList = new StudentList().studentList;

    List<Student> students = studentList.stream().filter(p -> p.getAddress() == Student.Address.BJ).sorted(new Comparator<Student>() {
      @Override
      public int compare(Student s1, Student s2) {
        return s2.getHeight() - s1.getHeight();
      }
    }).limit(3).collect(Collectors.toList());

    System.out.println(students);
  }
```

## 流的概述

### 什么是流

筛选、排序、聚合

> `Java 8 API`添加了一个**新的抽象**称为流Stream，可以让你以一种声明的方式处理数据。
>
> 这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， *比如筛选， 排序，聚合等。*

通俗的讲: 也就是说, `Stream`流是Java在`JDK1.8`提供的对<span style="font-size:20px;color:red;">集合数据进行优化/简化操作</span>的一种数据处理方式。

> 面试官问：熟不熟悉流？
>
> 首先要向面试官确认是IO流还是集合流。

### 流用来解决什么问题

Stream流一般用来**处理Java中的集合类数据**, 进以避免在日常代码书写中的对集合数据操作的性能以及代码冗长问题。

### 怎么使用流

```JAVA
使用一个流的时候，通常包括三个基本步：
1. 一个数据源, 创建一个流
2. 多个/0个 中间操作, 形成一条流水线
3. 一个终止/终端操作, 执行流水线,并生成结果
```

## 创建流

1. <span style="color:red"> 调用集合类的stream方法,生成一个流</span>(最常用/常见)

   ```JAVA
   Collection collection = new ArrayList();
   Stream stream = collection.stream();
   ```

2. 由值创建

   ```JAVA
   Stream<String> zs = Stream.of("zs", "ls", "wu", "zl");
   ```

3. 由数组创建

   ```JAVA
   String [] strs = {"zs", "ls", "wu"};
   Stream<String> stream = Arrays.stream(strs);
   ```

## 中间操作

为了看到效果，先看两个终止操作：

`count()`： 流里面有多少元素，最终会返回Long类型。

`collect(Collectors.toList())`： 将流里面的元素，存储为一个List;

注意：经过终止操作，流就变成了集合或者数字或者布尔值不再是流。

### `filter`(过滤操作)

<span style=color:red;background:yellow>**filter方法**</span>用于通过设置的条件过滤出元素。

<span style="font-size:20px;color:red;">使用场景：</span>

- 对元素进行过滤。比如想要某个地区的学生，比如想要年龄大于20的学生。

```JAVA
List<Student> studentList = new StudentList().studentList;
// 获取所有北京地区的同学
List<Student> collect = studentList.stream()
  .filter(s -> s.getAddress().equals(Student.Address.BJ))
  .collect(Collectors.toList());
System.out.println(collect);
```

注意: 每次中间操作会返回一个 Stream (可以有多次中间操作),这就允许对其操作可以像链条一样排列,变成一个管道。

一个流不允许收集两次，写流的代码都是按照链式编程的代码写，中间一般不提取变量出来。

```JAVA
// Stream<T> filter(Predicate<? super T> predicate); 
// public interface Predicate{}

// filter方法参数----  需要传入的是一个 Predicate类型的实例。
// Predicate 是功能接口。里面只有一个方法。
//输入参数根据流里的数据确定，
//输出参数是个boolean，意味着返回值是true可以通过filter，是false不可以通过
```

### `distinct`(去重)

`distinct` 方法用于筛选元素(相当于去除重复元素)

<span style="font-size:20px;color:red;">使用场景：</span>

- 对元素进行去重处理。底层是`LinkedHashSet`

所以需要注意：如果使用自定义的类，调用distinct，**需要重写hashCode和equals方法**

```JAVA
//  Stream<T> distinct();
//  distinct方法----筛选元素, 筛选的机制是根据元素的hashCode和equals判断重复
List<Student> studentList = new StudentList().studentList;

// 北京的人
long beijingCount = studentList.stream()
  // 过滤 只取出北京的
  .filter(s -> Student.Address.BJ.equals(s.getAddress())).count();

// 去重后北京的人
long distinctBeijingCount = studentList.stream()
  .filter(s -> Student.Address.BJ.equals(s.getAddress())).distinct().count();

System.out.println(beijingCount);
System.out.println(distinctBeijingCount);
```

### `limit`(截取)

`limit` 方法用于获取指定数量(最大)的流。

如果没有对流进行排序或者其他操作，`limit`输出都是按照原本集合顺序。

```JAVA
// Stream<T> limit(long maxSize);
// limit(n)方法, 返回前n个元素.
// 如果流中有10个元素，limit(3) 则只返回3个元素。
// 如果流中有1个元素，limit(3) 则只返回1个元素。

  List<Student> studentList = new StudentList().studentList;

  // 获取身高高于210的
  List<Student> superHighPeople = studentList.stream().filter(s -> s.getHeight() > 210)
      .limit(3).collect(Collectors.toList());
  System.out.println(superHighPeople);

  // 获取身高高于180的
  List<Student> highPeople = studentList.stream().filter(s -> s.getHeight() > 180)
      .limit(3).collect(Collectors.toList());
  System.out.println(highPeople);

  // 获取高于160的
  List<Student> normalPeople = studentList.stream().filter(s -> s.getHeight() > 160)
      .limit(3).collect(Collectors.toList());

  System.out.println(normalPeople);
```

### `skip`(跳过)

`skip(n)`方法, 跳过前n个元素

如果一共有6个元素，skip(9)的时候不会报错

```java
  List<Person> personList = StudentList.personList;
// Stream<T> skip(long n);
// skip(n)方法, 跳过前n个元素, 返回之后的元素.  (如果整体不够n个, 返回空流)

  List<Student> studentList = new StudentList().studentList;

  // 总共五个元素
  List<Student> collect1 = studentList.stream().filter(s -> s.getAge() > 22 && s.getAge() < 25)
      .collect(Collectors.toList());

  System.out.println(collect1);

  // 跳过1个元素，只剩下4个
  List<Student> collect2 = studentList.stream().filter(s -> s.getAge() > 22 && s.getAge() < 25)
      .skip(1).collect(Collectors.toList());
  System.out.println(collect2);
```

###  🏷️`map`(转换)

`map `方法用于映射每个元素到对应的结果。

从一个类型转换到另外一种类型。或者不变化类型

<span style="font-size:20px;color:red;">使用场景：</span>

- <span style=color:yellow;background:red>**输入的是一个类型，希望以另外一个类型输出。**</span>
  - 比如我想将一批人的年龄，转化为 青年（0-29），中青年（30-39），中年（40-49），中老年（50岁以上）。 
  - 比如我想将身高，映射为 超高人，高人，普通人。[190, +无穷), [175, 190) , (-无穷, 175]

```JAVA
// <R> Stream<R> map(Function<? super T, ? extends R> mapper);
// TODO: map映射返回新的数据,  map的参数是一个方法

// 获取所有学生姓名
List<Student> studentList = new StudentList().studentList;

List<String> collect = studentList.stream().map(student -> student.getName())
    .collect(Collectors.toList());
System.out.println(collect);
```

```java
// 获取所有学生姓名的首字母
List<String> collect1 = studentList.stream().map(s -> s.getName().substring(0, 1))
    .collect(Collectors.toList());
System.out.println(collect1);
```

```JAVA
// 获取非常高的学生(超过190) 返回高人这个类
	List<SuperPerson> collect2 = studentList.stream().filter(s -> s.getHeight() > 190)
    .map(s -> new SuperPerson(s.getName(), s.getHeight()))
    .collect(Collectors.toList());
	System.out.println(collect2);

class SuperPerson{
	String name;
	int height;
}
```

```JAVA
// 只需要人是什么类型的  
// 超高人，高人，普通人
// [190, +无穷), [175, 190) , (-无穷, 175]

List<Student> studentList = new StudentList().studentList;
List<String> collect = studentList.stream()
  .filter(s -> Student.Address.BJ.equals(s.getAddress())).map(s -> {
  int height = s.getHeight();

  if (height >= 190) {
    return "超高人";
  } else if (height >= 175) {
    return "高人";
  } else {
    return "普通人";
  }
}).collect(Collectors.toList());
System.out.println(collect);
```

### `sorted`(排序)

`sorted` 方法用于对流进行排序

```java
//     Stream<T> sorted();: 自然顺序排序
//     Stream<T> sorted(Comparator<? super T> comparator);: 提供一个比较器

	// 对高于180的同学根据身高进行排序
    List<Student> studentList = new StudentList().studentList;
    List<Student> collect = studentList.stream().
        filter(s -> s.getHeight() > 180)
        .sorted((s1, s2) -> s1.getHeight() - s2.getHeight())
        .collect(Collectors.toList());

    System.out.println(collect);
```

```java
// 对高于180的同学根据身高进行排序(从高到低)
List<Student> studentList = new StudentList().studentList;
List<Student> collect = studentList.stream().
    filter(s -> s.getHeight() > 180)
    .sorted((s1, s2) -> s2.getHeight() - s1.getHeight())
    .collect(Collectors.toList());

System.out.println(collect);
```

## 终止操作

### `anyMatch`(是否有任意一个匹配)

`anyMatch`：检查流到最后的数据,  是否有一个/多个数据匹配某种情况

```JAVA
//  boolean anyMatch(Predicate<? super T> predicate);
//  anyMatch: 判断该stream中的所有元素, 是否存在某个/某些元素,可以根据某个条件处理之后, 满足true

    //  判断是否存在北京的同学
    List<Student> studentList = new StudentList().studentList;
    boolean b1 = studentList.stream()
        .anyMatch(a -> {
          return a.getAddress() == Student.Address.BJ;
        });
    System.out.println(b1);

    //  判断高于190的是否存在北京的同学
		boolean b2 = studentList.stream()
        .filter(s -> s.getHeight() > 190)
        .anyMatch(a -> {
          return a.getAddress() == Student.Address.BJ;
        });
    System.out.println(b2);
```

### `allMatch`(是否所有的全匹配)

`allMatch`：检查是否所有元素都匹配

```java
// boolean allMatch(Predicate<? super T> predicate);
// allMatch: 判断该stream中的所有元素, 是否所有元素 可以根据某个条件处理之后, 满足true
    //  判断是否都是北京的同学
    List<Student> studentList = new StudentList().studentList;
    boolean b1 = studentList.stream()
        .allMatch(a -> {
          return a.getAddress() == Student.Address.BJ;
        });
    System.out.println(b1);
    //  判断高于200的是否都是上海的同学
    boolean b2 = studentList.stream().filter(s -> s.getHeight() >= 200)
        .allMatch(s -> s.getAddress() == Student.Address.SH);
    System.out.println(b2);
```

### `noneMatch`(没有匹配)

该方法语义不好解释，不建议用。

`noneMatch`：检查是否没有匹配元素

```JAVA
// boolean noneMatch(Predicate<? super T> predicate);
// noneMatch: 判断该stream中的所有元素, 是否所有元素 可以根据某个条件处理之后, 满足false

    List<Student> studentList = new StudentList().studentList;

    // 判断是否不存在深圳的同学
    boolean b1 = studentList.stream().noneMatch(s -> Student.Address.SZ.equals(s.getAddress()));

    System.out.println(b1);
```

### `findAny`(找到任意一个)

`findAny`：返回流中任意元素，默认第一个

返回的是一个`Optional`对象，这个主要是因为不确定流里面是否有元素。

> `Optional`作为一个容器代表一个值存在或者不存在。
> `Optional`中存在几个方法, 可以让使用者显式的检查值存在或者不存在：
>
> 1. `isPresent()`方法：如果 `Optional`包含值返回`true`，否则返回`false`
> 2. `ifPresent(代码块)`方法: 会将`Optional`包含的值，传给指定的代码块
> 3. `get()`方法：如果`Optional`包含值，返回包含的值，否则抛出异常。如果里面没有数据就会报错。这样设计方便区别`null`值，如果`get()`获取一个元素返回值是`null`不代表没有元素而是指该元素本身是`null`。
> 4. `orElse(默认值)`:  如果`Optional`包含值，返回包含的值，否则返回默认值

```JAVA
// Optional<T> findAny();
// findAny: 返回任意元素(默认第一个)

        //  返回任意一个同学
    List<Student> studentList = new StudentList().studentList;

    Optional<Student> any = studentList.stream()
        .findAny();


    any.isPresent();
    any.ifPresent(a -> System.out.println(a));
    any.get();

    any.orElse(new Student("默认值", 18, 140, Student.Address.SH));

    System.out.println(any);

// 一般的用法
if (any.isPresent()){
  Student student = any.get();
  System.out.println(student);
}
```

```JAVA
 		// 返回任意一个身高小于170同学
    List<Student> studentList = new StudentList().studentList;

    // 找到任意一个小于170的
    Optional<Student> any = studentList.stream().filter(s -> s.getHeight() < 170).findAny();

    if (any.isPresent()) {
      Student student = any.get();
      System.out.println("这里有一个170以下的学生" + student);
    } else {
      System.out.println("没有170以下的学生");
    }
```

### `findFirst`(找到第一个)

`findFirst`：返回第一个元素

```java
//  Optional<T> findFirst();
//  findFirst: 返回第一个元素

    //  获得年龄最小的同学
    Optional<Student> any = studentList.parallelStream()
        .sorted((o1, o2) -> o1.getAge() - o2.getAge()).findAny();
    System.out.println(any.get());
```

`findFirst`& `findAny`的区别：

使用并行流时，在多线程的情况下处理，`findAny`就是哪个线程先处理完就先返回哪个数据。而`findFirst`不管哪个线程先处理完，一定等到处理完第一批数据才返回。

### `forEach`

`forEach`：遍历流

```JAVA
  //  void forEach(Consumer<? super T> action);
  //  forEach: 遍历元素(void方法)

  //  遍历列表
  List<Student> studentList = new StudentList().studentList;
  studentList.stream()
      .sorted((o1, o2) -> o1.getAge() - o2.getAge())
      .forEach(a -> System.out.println(a));
```

### `count`

`count`：返回集合中元素的数量

```java
//  long count();
//  count: 计算元素个数

    //  北京同学的数量
    List<Student> studentList = new StudentList().studentList;

    long count = studentList.stream()
        .filter(a -> a.getAddress() == Student.Address.BJ)
        .count();
    System.out.println(count);
```

### `reduce`

`reduce`：计算元素

`reduce`：将参加计算的元素**按照某种方式**减少。

- 比如，两个元素比较，返回大的； 按照这个方式，最终会拿到最大的。

- 两个元素，返回和； 按照这个方式，最终会拿到所有的和。

> 大数据里有个名词`"MapReduce"`。

```JAVA
 List<Person> personList = StudentList.personList;
//  规约 reduce
//  <1>一参情况: Optional<T> reduce(BinaryOperator<T> accumulator)
//  <2>二参情况: T reduce(T identity, BinaryOperator<T> accumulator);

//  1参数:
//  返回值类型为Optional, 是应对如果流中没有任何元素情况(这种情况没有初始值就无法返回结果)
//  所以1参是把结果包裹在一个Optional对象里(可以通过get方法获取)，用以表明处理结果可能不存在情况

//  2参数:
//  BinaryOperator: 将两个元素合起来产生一个新值
//  identity: 计算的初始值/起始值(用来和第一个元素计算结果)

    //  TODO:班级同学年龄总和
    Optional<Integer> optional = studentList.stream()
        .map(a -> a.getAge())
        .reduce((a, b) -> a + b);

    Integer sum = optional.get();
    System.out.println(sum);

```

```JAVA
List<Student> studentList = new StudentList().studentList;

    // 年龄最大的学生
    Optional<Integer> reduce2 = studentList.stream().map(a -> a.getAge()).reduce((a, b) -> {
      if (a > b) {
        return a;
      }
      return b;
    });

    Optional<Integer> reduce3 = studentList.stream().map(a -> a.getAge()).reduce(Integer::max);

    // 年龄最小的学生
    Optional<Integer> reduce4 = studentList.stream().map(a -> a.getAge()).reduce((a, b) -> {
      if (a > b) {
        return b;
      } else {
        return a;
      }
    });
    Optional<Integer> reduce5 = studentList.stream().map(a -> a.getAge()).reduce(Integer::min);


    System.out.println(reduce2 + "==" + reduce3);
    System.out.println(reduce4 + "==" + reduce5);
```

### <span style="color:red;">`collect`</span>

`collect`：收集器，用于收集数据经过流计算的结果。

作用是将元素分别归纳进可变容器 `List`、`Map`、`Set`、`Collection` 或者`ConcurrentMap`。

```JAVA
// Collectors.toList()
// Collectors.toCollection()
// Collectors.toSet()
// Collectors.toMap()
```

```JAVA
    List<Student> studentList = new StudentList().studentList;
// 获取武汉同学的集合 toList
    List<Student> collect = studentList.stream().filter(a -> a.getAddress() == Student.Address.WH)
        .collect(Collectors.toList());

    System.out.println(collect);
```

```JAVA
// 获得武汉同学集合: toCollection
    LinkedList<Student> collect = studentList.stream()
      	.filter(a -> a.getAddress() == Student.Address.WH)
        .collect(Collectors.toCollection(() -> new LinkedList<>()));
```

```JAVA
// 获得武汉同学集合: toSet
    Set<Student> studentSet = studentList.stream()
      	.filter(a -> a.getAddress() == Student.Address.WH)
        .collect(Collectors.toSet());
```

>  对于Map来说，重复的键必须告诉它，如何合并value。

```JAVA
// 获得武汉同学集合(姓名和年龄): toMap
    Map<String, Integer> collect1 = studentList.stream()
      	.filter(a -> a.getAddress() == Student.Address.WH)
        .collect(Collectors.toMap(Student::getName, student -> student.getAge()));

    System.out.println(collect1);
// 获得武汉同学集合(姓名和对象本身)
    Map<String, Student> collect2 =
        studentList.stream().filter(a -> a.getAddress() == Student.Address.WH)
        .collect(Collectors.toMap(Student::getName, student -> student));

    System.out.println(collect2);
```

## 使用案例

```JAVA
// 1.找出一个集合中来自北京的人
// filter 

// 2.找出来自武汉，年龄大于20的人数
// filter  filter count()

// 3.给一个集合，需要一个根据名字到对应对象的Map
// toMap()需要告诉键值分别是什么，键重复的话值如何合并
```

注意：

 🟡 在使用Map的时候，首先要确定就是你的key代表什么东西，value代表什么东西。 

 可读性怎么样？   可读性很差
 流，自己学习的时候，可以用。
🟡  在工作过程中，你的同事用，你再用。用的时候注意一些保命妙招，注释拉满 。

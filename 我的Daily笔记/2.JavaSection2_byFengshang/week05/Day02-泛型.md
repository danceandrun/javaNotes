[TOC]

# 基础概念

**学习目标：**

- 理解泛型的概念及掌握泛型的好处

- 泛型类、泛型接口的定义
- 理解泛型在父子继承关系上的表现（难）
- 理解泛型的擦除

## 引入

**背景条件**

- 汽车类
- 汽车的车库(主要用于存放车)。还提供一个方法获取汽车。 

```JAVA
/**
 * 类： 希望被持有的小汽车类
 * 功能： 里面只有一个run方法，打印。
 */
public class AutoCar {
    public void run() {
        System.out.println("小汽车跑跑跑......");
    }
}


/**
 * 类：车库类
 * 功能：
 * 1.持有小汽车。
 * 2.对外提供获取小汽车方法
 */
public class HolderAutoCar {
    private AutoCar autoCar;

    public HolderAutoCar(AutoCar autoCar) {
        this.autoCar = autoCar;
    }

    public AutoCar get() {
        return this.autoCar;
    }
}

public class HolderAutoCarDemo1 {
    public static void main(String[] args) {
        // 使用方式
        HolderAutoCar holderAutoCar = getHolderAutoCar();

        AutoCar autoCar = holderAutoCar.get();
        autoCar.run();
    }

    private static HolderAutoCar getHolderAutoCar() {

        AutoCar autoCar = new AutoCar();

        // 这里的步骤可能很繁琐。
        // 比如这个autoCar需要进行十几个步骤，才能得到
        // 我们使用这个方法来屏蔽这十几个步骤。因为这个AutoCar我们可能只使用，创建是其他程序员创建好。

        HolderAutoCar holderAutoCar = new HolderAutoCar(autoCar);

        return holderAutoCar;
    }
}
```

如果现在又有一个卡车类，也想拥有持有类

```JAVA
// 卡车类
public class Truck {
    public void run() {
        System.out.println("大卡车跑跑跑......");
    }
}

// 持有卡车类的类
public class HolderTruck {
    private Truck truck;

    public HolderTruck(Truck truck) {
        this.truck = truck;
    }

    public Truck get() {
        return this.truck;
    }
}

// 使用方式
HolderTruck holderTruck = new HolderTruck(new Truck());
holderTruck.get().run();
```

会发现，小汽车持有类和卡车持有类，非常相似，就隔了一个类型。

<span style=color:red;background:yellow>**问题：如果我还有其他的类呢？比如皮卡类，摩托车类？**</span>

如果继续这样写下去（一个车写一个车库类），有哪些优点和缺点？

优点：简单。这样可以一直写下去。

缺点：持有类的功能很固定，其实就是类型不一样。为每一个都单独写一个类，<font color=red>**类数目会急剧增多。**</font>

<span style=color:red;background:yellow>**解决方案1：**</span>

使用Object持有这些类。

```java
public class Holder1 {
  private Object object;

  public Holder1(Object object) {
    this.object = object;
  }

  public Object get() {
    return this.object;
  }
}

// 正确使用。存AutoCar
Holder1 holder11 = new Holder1(new AutoCar());
((AutoCar) holder11.get()).run();

// 正确使用。存Truck
Holder1 holder12 = new Holder1(new Truck());
Object o = holder12.get();
((Truck) o).run();

// 错误使用。 o是一个Truck对象，但是却把它转成了AutoCar
((AutoCar) o).run();
```

<font color=red>**问题：**</font>

存在类型强转问题，如果类型转换错误，会导致报错。

![image-20231012172833332](.\assets\image-20231012172833332.png)

<span style=color:red;background:yellow>**解决方案2：**</span>

抽取公共接口，持有类持有接口。运用多态特性。

```JAVA
public interface Car {
  void run();
}

public class AutoCar implements Car{
  public void run() {
    System.out.println("小汽车跑跑跑......");
  }
}

public class Truck implements Car {
  public void run() {
    System.out.println("卡车跑跑跑......");
  }
  
  public void truckMethod() {
    System.out.println("我是truck特有的方法");
  }
}

public class Holder2 {
  private Car car;

  public Holder2(Car car) {
    this.car = car;
  }

  public Car get() {
    return car;
  }
}

// 具体使用
Holder2 holder2 = new Holder2(new AutoCar());
holder2.get().run();

Holder2 holder21 = new Holder2(new Truck());
holder21.get().run();

// 如果向下转型
Truck truck = (Truck) holder21.get();
truck.truckMethod();

// 如果转错了类型。
AutoCar autoCar = (AutoCar) holder21.get();
```

<font color=red>**问题：**</font>

- 需要修改代码，如果这个`AutoCar`是别人提供的，我们就无法添加继承关系。
- 只能调用接口所特有的方法，如果想调用子类单独的方法，需要强转

<span style=color:red;background:yellow>**解决方案3： **</span>

使用泛型

```JAVA
// 持有类的定义
public class Holder3<T> {
  private T data;

  public Holder3(T data) {
    this.data = data;
  }

  public T get() {
    return data;
  }
}

// 使用
// 尖括号的指定的类型。先有一个印象
Holder3<AutoCar> holder3 = new Holder3<>(new AutoCar());
holder3.get().run();

Holder3<Truck> holder31 = new Holder3<>(new Truck());
holder31.get().run();
```

## 泛型概念

**什么是泛型？**

<span style="color:red;">参数化类型。</span>我们在写代码的时候, 可能很多时候我们并不能确定某一个参数的具体类型, 或者, 我们希望代码某个参数类型是灵活可变的,  我们可以先假定一种不存在的类型来代指这个参数类型, 当我们真正使用的时候再传入具体的类型。

![image-20231012172916525](.\assets\image-20231012172916525.png)

**相当于什么呢？**

```java
// 举例来说：比如我们之前定义一个变量
// int i ;
// 我们假设i = 1  --> 那i就是1
// 我们假设i = 2  --> 那i就是2

// 现在泛型来说
// 我们使用了一个符号来代替类型。比如我们使用这样一个定义  T data;
// 当我们传 T = String   那data就是String类型的
// 当我们传 T = Integer   那data就是Integer类型的
```

## 泛型好处

1.  🟡**省去了类型强转的麻烦**

   不用使用强制类型转换。就避免了类型强转问题。
   
2. ⭐ **将运行期遇到的问题转移到了编译期**

   没有泛型之前，编译器是不会检测集合容器中元素的数据类型的，因为它们全部都是`Object`。使用泛型后，能让编译器在编译的时候借助传入的类型参数（实参）检查对集合容器的插入，获取等操作是否合法。

为什么问题早发现比较好？

- 自己开发 → 自测 →  联调 →  测试测试  →  客户使用
- 航天中，前期准备阶段 → 组装调试阶段  →  发射阶段 →  运行阶段

问题越往后才发现，造成的问题也越难以解决，或者说影响越大。

# 泛型

- 泛型类： 泛型定义在类上。<span style=color:red;background:yellow>**需要重点掌握**</span>
- 泛型接口：泛型定义在接口上，<span style=color:red;background:yellow>**需要重点掌握**</span>
- 泛型方法：泛型定义在方法上，了解即可
- 泛型通配： 了解即可
- 泛型擦除：重要，要记住⭐⭐ 

泛型是在Java 5中被引入的。在Java 5之前，Java的类和方法只能**通过Object来实现泛化**(就是方式一，有类型转换的风险)，这样的代码存在许多问题，如类型转换错误、编译时类型检查缺失等等，限制了代码的可读性、可维护性和安全性。

引入泛型机制后，Java可以在编译时进行更严格的类型检查，使得代码更加健壮、可读性更强，并且避免了许多运行时类型转换错误的问题。

##  泛型类

泛型类是一种可以**在定义类时**使用类型参数来表示类中使用的类型的类。在Java中，泛型类可以用于定义一些通用的数据结构或算法，以便能够适应不同类型的数据。

```JAVA
// 泛型类:  所谓泛型类,就是把泛型'定义在'类上
// 定义的方法  类名<泛型类型1, 泛型类型2， ...>
 class 类名<泛型类型1,…>{
}
```



**注意1：泛型使用时的写法**


泛型的写法1 ：前面写类型，后面直接写`<>`

```java
User1<String> user1 = new User1<>();
String data = user1.data;
```

（了解写法）

```JAVA
// JDK1.5 的时候，泛型刚刚出来时候的写法：
// 泛型的写法2 User2<类型> 变量名 = new User2<类型>();
User1<Integer> user11 = new User1<Integer>();
Integer data1 = user11.data;
```



**注意2：默认类型**

定义了泛型但是使用时未指定。

定义了泛型，但是未写在`<>`中，会将其直接当做`Object`使用。

```JAVA
User1 user1 = new User1();

// 如果不使用 <> 来指定类型，这时候T是个什么类型呢？
// 是默认类型，Object
Object data = user1.data;
```



**注意3：泛型类可以定义多个泛型**

- <font color=red>**可以定义多个泛型，但不建议超过两个。**</font>
- <font color=red>**定义多个泛型，使用时，要么全部指定，要么全部不指定。**</font>全不指明默认`Object`。

```java
User2<String, Integer> user2 = new User2<>("zs", 18);
```

````java
// User2<String> user3 = new User2<>("zs", 18); // 报错，必须全部指定泛型的类型，或者全部不指定。

class User2 <T, E>{
    T name;
    E age;
}
````

泛型符号起到占位符的作用。多个泛型，**按位置传递按符号使用**。



**注意4：允许定义了泛型但不使用**

```java
// 定义了一个K, 但是我们没有使用
class User3 <T, E, K> {
    T name;
    E age;
}
```



**注意5: 泛型标识符**

 🟡用单个大写字母

我们会假定一种不存在的类型来代替这个参数类型，等我们真正使用的时候再传入具体的类型。

```JAVA
// int i; 这个i是变量。变量名
// T data; 这个T就是标识符。
// 使用单个大写字母。比如 E T K V
// E element; T type; K key; V value

// 这是一些规范。如果不按照这个规范，写代码也可以跑，但是出问题的风险比较大。
```



**注意6：泛型必须使用引用类型**

```java
   User4<int> user1 = new User4<>(); // 报错: 泛型必须使用引用类型
   User4<Integer> user2 = new User4<>();
```



**注意7:  泛型类，定义了泛型之后，泛型的作用域**

在父类中不能使用子类定义的泛型。

- 泛型类定义泛型的作用域:  在<span style=color:red;background:yellow>**自己的**</span>类上，或者类中。
- 类上：类的定义这行，可以使用泛型。`class Son<T> extends Father`
- 类中：代表类体包含内容，包括**内部类**，可以使用泛型



```java
class Father1{
    // 用不了T, 因为子类定义 
}

class Son<T> extends Father1{ 
    T t;
    class SonInner{     
        T aInnerT;   
    }
}

class GrandSon extends Son{
   // 用不了T, 因为父类定义 
}
```

###  泛型在父子继承关系上的表现⭐⭐

📣 重点在于**区分是在泛型定义还是泛型使用**

```java
class Father <T> {
    T ft;
}
// 父类未指定泛型
class Son1 extends Father{}

// 此时是父类使用泛型，不是定义泛型
class Son2 extends Father<String>{}
// 此时是子类定义泛型
class Son3<E> extends Father<Integer>{}

class Son4<E> extends Father<E>{}

class Son5<T> extends Father<T>{}
```

在继承时，没有指定泛型，此时是默认类型；

```java
public class Demo1 {
  public static void main(String[] args) {
    Father<Integer> f = new Father<>();
    Integer ft = f.ft;

    // Son1 定义时没有指定Father泛型的类型，所以默认为Object
    Son1 son1 = new Son1();
    Object ft1 = son1.ft;

    // Son2 定义时，未指定泛型，指定了 Father泛型为String，所以ft为String
    Son2 son2 = new Son2();
    String ft2 = son2.ft;

    //Son3 定义时，指定泛型E，指定了 Father泛型为Integer，所以ft为Integer
    Son3<String> son3 = new Son3<>();
    Integer ft3 = son3.ft;

    // Son4 定义时，指定泛型E，指定了Father泛型为E，所以ft类型和子类一致
    Son4<Integer> son4 = new Son4<>();
    Integer ft4 = son4.ft;
    Son4<String> son41 = new Son4<>();
    String ft41 = son41.ft;

    // Son5 指定T。 与符号无关
    Son5<String> son5 = new Son5<>();
    String ft5 = son5.ft;
  }
}

```

背景： 如果父类有泛型，子类情况如下：

- 如果继承时，<font color=red>**未指定父类泛型，未传入子类指定的泛型**</font>，则为默认类型。Object

  - ```JAVA
    class Son1 extends Father{}
    ```

- 如果继承时，<font color=red>**指定了父类泛型**</font>，则为指定类型，无论子类定义泛型与否。

  - ```JAVA
    class Son2 extends Father<String>{}  --》 父类变量类型为String
    class Son3<E> extends Father<Integer>{} --》 父类变量类型为Integer
    ```

- 如果继承时，<font color=red>**传入了子类指定的泛型**</font>，则父类与子类变量类型一致

  - ```JAVA
    //此时是子类定义使用符号E，父类使用这个E，将这个E传给父类定义时使用的泛型符号
    class Son4<E> extends Father<E>{}
    class Son5<T> extends Father<T>{}
    ```

## 泛型接口

泛型接口是指在<span style=color:red;background:yellow>**声明接口的时候使用泛型参数**</span>，以便在实现接口时指定具体的类型。这样可以使接口更加灵活和通用，可以适应不同类型的数据结构或对象。

在泛型接口中，泛型参数可以用在接口中的方法、常量、嵌套类等地方。例如：

```java
public interface List<T> {
    void add(T element);
    T get(int index);
    int size();
}
```

在上面的例子中，泛型参数`T`可以用于`add`方法的参数类型和`get`方法的返回类型。

泛型接口使得Java中的容器类更加通用和灵活，可以适应不同类型的数据结构和对象。

```java
// 所谓泛型接口, 就是把泛型定义在接口上
格式:  interface 接口名<泛型类型1…>
```

```java
// 格式: interface 接口名<泛型类型1…>
interface Player<T> {
    T play(T t);
}

// 如果实现时候，不指定类型，默认为Object
class ChildrenPlayer implements Player {
  
    @Override
    public Object play(Object o) {
        return null;
    }
}

// 如果实现时，指定为什么类型，则为什么类型
class YoungPlayer implements Player<String> {
  
    @Override
    public String play(String s) {
        return null;
    }
}

// 如果子类也有泛型，则与子类一致
class OldPlayer<E> implements Player<E>{

    @Override
    public E play(E e) {
        return null;
    }
}
```

**泛型接口类型在什么时候确定？**

<font color=red>**子类实现该接口时候，或者子接口继承该接口时。需要指定类型**</font>

```JAVA
interface Player<T> {
    T play(T t);
} 
  
// 1.子类实现该接口，没有指定泛型。		--> 接口中泛型为Object
class ChildrenPlayer implements Player {}
public Object play(Object o) {}
  
// 2.子类实现该接口，指定了泛型，给接口指定了类型  --> 接口中泛型为指定的类型
class YoungPlayer implements Player<String> {
  public String play(String s) {}
}

// 3.子类实现该接口，指定了泛型，且符号一致  --> 接口中为指定的泛型
	//当子类创建对象时，泛型被确定下来
class OldPlayer<E> implements Player<E>{}
public E play(E e) {}

// 4.子接口继承该接口时候
与以上行为一致。
```

### 案例

```JAVA
// 转换器接口，从一个类型转化到另一个类型，需要两个泛型
public interface Converter<T, R> {
    R convert(T t);
}

// 从字符串转化为时间类型 我们约定字符串的格式为 yyyy-MM-dd。即这种类型 2022-11-01
public class String2DateConverter implements Converter<String, Date> {
    @Override
    public Date convert(String s) {

        Date parse = null;
        try {
            parse = new SimpleDateFormat("yyyy-MM-dd").parse(s);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        return parse;
    }
}

// 还可以写从String类型的转化为Integer
// 从Long 类型转化为 Date类型。
```

## 泛型方法

```java
// 所谓泛型方法, 把泛型定义在方法上
格式:  <泛型类型> 返回类型 方法名(泛型类型)
```

```java
public class Demo1 {
    public static void main(String[] args) {

        A a = new A();
        Integer t = a.getT(18);
        String zs = a.getT("zs");
        
    }
}
//格式:  <泛型类型> 返回类型 方法名(泛型类型 变量名)
class A{
    public <T> T getT(T t){
        return t;
    }
}
```

**注意事项：**

```JAVA
// 1.方法上没有定义泛型，只是使用了泛型，不叫泛型方法。
//比如
class Player<T>{
  T play(T t){
      System.out.println(t);
      return t;
  }
}
```

## 泛型的通配: 了解

<font color=red>**以后看源码，能明白含义即可。**</font>

![image-20231012175221498](.\assets\image-20231012175221498.png)

泛型不允许协变,  又想产生类似协变的效果，又不想引入协变带来的问题(类型不匹配问题)

**0.协变和逆变**

```JAVA
Integer是Number的子类。
所以我们可以使用这种形式。 Number number = new Integer(10);			父类引用指向子类对象
那这个有父子继承关系吗  User<Number>  User<Integer>
可以这样使用吗？		User<Integer> user1 = new User<>("zs", 18);
 		 User<Number> user2 = user1;
 结论： 不行。因为  User<Number> 和 User<Integer> 不是父子继承关系。
 这个操作叫做协变。
```

协变就是，允许接收该类及该类的子类。

逆变就是，允许接收该类及该类的父类。

```JAVA
// 数组是允许协变的。协变的问题。类型不匹配问题
Animal[] animals = new Cat[10];

animals[0] = new Cat();
animals[1] = new Cat();
animals[2] = new Dog();
```

<span style=color:red;background:yellow>**泛型的通配**</span>

> 通配符：wildcard。

① 泛型通配符`<?>`
任意类型，如果没有明确，那么就是`Object`以及任意的Java类了
② `? extends E`
向下限定，`E`及其子类
③ `? super E`
向上限定，`E`及其父类

**1.任意类型**

```JAVA
class User<T> {
  String name;
  T data;
  // getter & setter & conctructor
}
```

```JAVA
// 我们想提供一个方法，打印User对象，方法的签名如下
// 如果是打印Integer的，可以是以下的
public void print(User<Integer> user) {
  System.out.println(user.getName() + "--" + user.getData());
}
  
// 如果是String类型的，则以上方法用不了

// 可以使用这个类型吗? 也不允许，因为泛型不允许协变
public void print(User<Object> user) {}
  
// 可以使用以下类型来接收。？代表任意类型
public void print(User<?> user) {}
```

**2.向下限定**

`<? extends E>`

只允许接收该类及该类子类。

```JAVA
// 允许接收 Number 及Number的子类
public double compute(User<? extends Number> user) {
  Number data = user.getData();
  return data.doubleValue() + 1;
}

User<Integer> user = new User<>("zs", 18);
User<Double> user2 = new User<>("zs", 18.0);

double val = genericsExtends2.compute(user);
double val2 = genericsExtends2.compute(user2);
System.out.println(val);
System.out.println(val2);

```

**3.向上限定**

`<? super E>`

只允许接收该类及其父类。

## 泛型的擦除: 重要:需要记住

面试最有可能问的关于泛型的知识。

> 面试题：Java中泛型会不会效率更高？

泛型和我们写的强转从效率上来说没有区别但是会更安全。

Java中的泛型<span style=color:red;background:yellow>**并不是真的泛型,**</span>  Java的泛型只存在于编译之前, 当Java中的泛型编译之后, 会把泛型编译成Object以及类型强转。

# 准备部分

## 数据结构

```JAVA
// 数据结构:  什么是数据结构
//         数据的组织方式,  数据+结构

// 有哪些常见的数据结构:
     集合:  一堆无序的数据
     线性表:  描述的是一个有序序列, 在这有序序列中除了头和尾数据以外, 每一个数据有唯一的前驱和后继  
           操作受限的线性表: 栈和队列
               
     树:  一对多的关系
         一个节点，连接多个节点。二叉树： 一个节点，最多连接两个节点
     图:  多对多的关系        
```

![image-20231012194043620](.\assets\image-20231012194043620.png)

本节课只会讲线性表，因为后面会用到，其他的如果大家感兴趣可以自己去学习一下。

### 数组

数组就是一片连续的内存空间，且存储的类型都是一致的。这就说明什么？

<span style=color:red;background:yellow>**说明每一个格子的大小是固定的。**</span>我们只要知道头一个地址，后方的地址都可以算出来

```
Q1: 数组我们都很熟悉，那你理解的数组是什么样的呢？它的最主要特点是什么呢？
    // 数组是在内存上连续存储,  所以可以随机访问
    // 对应数组下标的物理地址 = 数组首地址 + 下标 * 每一个内存单元大小
    
// 有一个数组长度是1000的。 现在想访问 index=500。是否可以直接访问到
// 可以。 数组的首地址 + 下标 * 每一个单元格的大小。

// 如果链表的长度是1000。 想访问 第 501个数据。  
// 用一个计数器。0 
    
Q2: 为什么数组的效率比链表高？
    // 因为数组是连续存储可以做到随机访问, 但是链表是非连续存储不能做到随机访问
```

![image-20231012194117108](.\assets\image-20231012194117108.png)

数组的插入数据流程

数组的删除数据流程

数组的查找数据流程

### 链表

<span style=color:red;background:yellow>**链表是一个线型的。**</span>

基础的结构是这样的。

```JAVA
public class Node {
    String data;

    Node next;
}
```

![image-20231012194155844](.\assets\image-20231012194155844.png)

链表的插入数据流程

链表的删除数据流程

链表的查找数据流程

## 集合是什么

> 集合是具有某种特定性质的事物的总体。 这里的“事物”可以是人，物品，也可以是数学元素。

在Java中，指的就是存放数据的<span style=color:red;background:yellow>**容器**</span>，是一个<span style=color:red;background:yellow>**载体**</span>，可以一次容纳多个对象。

和数组比较像。 为什么要提供一套集合类。 就是因为数组操作起来麻烦，非常容易出bug。

数组也可以存储多个对象，那集合和数组比，好在哪里呢？

```JAVA
// 1.班上有5个同学。  学生有名字，年龄等信息
// 2.现在转学走了一个同学(第三个同学)。  怎么表示
// 3.新学期，又来了三个学生  怎么表示

// 使用数组完成一下这些功能

//有啥问题？

// 1.操作起来非常的麻烦，容易出bug。添加一个学生，删除一个学生不好操作
// 2.使用数组，需要手动进行扩容，非常麻烦。
```

先使用集合实现一下。

![image-20231012194257717](.\assets\image-20231012194257717.png)

Java中的集合类分为两大类：一类是实现了`Collection`接口的类，另一类是实现了`Map`接口的类。

**`Collection`：**先理解为一个袋子，往里面装数据。有各种各样的子实现。

在Java中，`Collection`是一个接口，它是所有集合类的顶层接口。它定义了一组通用的方法，用于操作集合中的元素。

Java中的`Collection`接口定义了一些常用的方法，例如`add()`、`remove()`、`contains()`等，还有用于获取集合大小、判断集合是否为空、清空集合等方法。Java中的集合类包括`List`、`Set`和`Queue`等，它们都是实现了`Collection`接口的子接口。

>  `Collection`是最基本的集合接口，一个 `Collection` 代表<font color=red>**一组**</font> `Object`，即 `Collection` 的元素，Java不提供直接继承自`Collection`的类，只提供继承于的子接口(如`List`和`Set`)。

> - 比如存储一组学生
> - 比如存储一组手机号码

主要存储的就是单列数据。比如一个学生，一个老师。这种都叫单列数据。

**`Map`：**存储key-value结构的数据。key-value结构：就是可以根据一个key，找到一个对应的value。

> `Map` 接口存储一组键值对象，提供`key`（键）到`value`（值）的映射。

> - 比如根据手机号，快速获取到姓名
>
> - 比如根据身份证号，快速获取到人的信息

## 工作中的作用

**开发的大致流程：**

- <span style=color:red;background:yellow>**产品**</span>：提出需求，并给出需求文档，如果有不清楚的，需要与产品沟通，确认清楚需求，不清楚一定要尽快提；
- <span style=color:red;background:yellow>**研发（前端+后端）**</span>：需求返讲，给产品讲你对这个需求的理解，以及有哪些功能点，以及大致技术方案，产品如果确认没问题，进入下一步；
- 研发出排期；
- 如果产品确认时间无误，开始开发。与此同时，测试同学会出一个测试方案。→ 主要是测试的功能点；
- 测试会与研发，产品开会。讨论列出的所有测试点以及测试大致流程。这时候如果有问题要提，这基本上是最终的测试方案。最终会按照这个方案验收
- 前端 后端开发完成后，会先联调，功能点不多的情况下，大概几天。联调完成后。基本一些bug会清一些
- 最终给产品和测试演示。如果演示没问题，就进入测试阶段。
- <span style=color:red;background:yellow>**测试**</span>同学进入后，有bug修bug。最终测试完成后上线。

学完之后，<font color=red>**要多对比**</font>，对比各个容器的不同。整理不同容器的结构思维导图。

# `Collection`

学习目标：

- 了解`Collection`接口的作用
- 掌握`Collection`的增、删、查方法
- 掌握`Collection`的遍历方法
- 掌握`Collection`遍历方法的特点及迭代器方法需要小心的bug
- <span style=color:yellow;background:red>**熟练掌握什么场景下使用`Collection`及其子类**</span>



![image-20231012195506866](.\assets\image-20231012195506866.png)



> 面试官问：我有一组学生，需要用什么来存？

我们在学习任何一个接口之前，会给大家讲 接口的特点。

这个接口的特点，<span style=color:red;background:yellow>**是重点。**</span>大家了解了这个特点，基本对这个接口的一些基本行为有一个认知。

## 特点

1. `Collection`是顶级接口，描述数据存储的接口.
2. `Collection`的一些子实现有序，一些无序
3. 一些子实现允许存储重复的数据，一些不允许
4. 一些子实现允许存储`null`，一些不允许

传统的三件套：数据存储是否有序，是否允许存储重复的数据，是否允许存储`null`。 

> - 什么叫有序，什么叫无序？
>
> 这里的有序无序不是指是否按大小排序，而是<u>存储和读取的顺序</u>，比如存入进去的是 `1 2 3 4 9`。读取出来的是`1 2 3 4 9`。或者 `9 4 3 2 1 `均称为有序。

## `API`

```java
//    ---------------------------------增删改查方法---------------------------------
//    boolean add(E e): 添加一个元素进入Collection
//    boolean addAll(Collection<? extends E> c): 添加一个Collection进目标Collection
//    boolean remove(Object o)： 删除元素， 只删除第一个出现的(如果存在多个)
//    boolean removeAll(Collection<?> c)： 删除Collection中的所有存在的元素,会全部删除，如果存在多个
//    boolean contains(Object o)： 判断是否存在指定元素
//    boolean containsAll(Collection<?> c)： 判断给定的collection中是否全部存在于目标Collection
//    boolean retainAll(Collection<?> c)： 将原有collection只保留传入的collection。

//    ---------------------------------特殊方法---------------------------------
//    void clear()： 清空collection
//    boolean equals(Object o) ： 判断是否相等
//    int hashCode()： 计算hashCode
//    boolean isEmpty(): 是否为空
//    int size()： collection里面的元素个数
//
//    ---------------------------------方便遍历方法---------------------------------
//    Object[] toArray(): 将collection转成一个数组，方便遍历
//    <T> T[] toArray(T[] a)：类似，只是传入了一个数组
//    Iterator<E> iterator()：返回一个迭代器
```

遍历：对一个集合中的元素，按照一定的顺序，访问且仅访问一遍。




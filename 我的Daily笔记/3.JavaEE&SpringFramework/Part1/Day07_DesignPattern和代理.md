设计模式思维导图

![Day12设计模式思维导图](.\assets\Day12设计模式思维导图.jpg)

# 前言

## 学习目标

> 1. 理解使用设计模式的目的
> 2. 掌握软件设计的SOLID原则
> 3. 理解单例的思想，并且能够设计一个单例
> 4. 理解工厂设计模式的思想，能够设计简单工厂，理解工厂方法
> 5. 了解建造者模式的思想，掌握其代码风格
> 6. 理解代理设计模式的思想，理解动态代理类和委托类（目标类）之间的关系，⚡熟悉**代理**对象调用方法的执行过程，熟练使用动态代理完成代码设计
> 7. 了解责任链设计模式的思想

**代理**可以起到很大作用，小型核武器

## 前置准备

> - 理解抽象部分：为什么使用接口或抽象类，在什么情况下使用接口，什么情况下使用抽象类 （接口和抽象类主要定义方法的规范）
>
> - 静态内部类的类加载过程
>
> - 匿名内部类的定义和使用 
>
> - 反射：反射过程中的常用名词Class、Field、Method、Parameter、Constructor。反射过程中的常用方法
>   - 获得class、field、method、parameter、constructor  → getDeclaredXXX
>   - 通过反射获得实例 class和constructor
>   - 通过反射调用方法 method.invoke(instance,args)
>
> - Lombok使用
>

# 设计模式简介

## 什么是设计模式

设计模式是一套被反复使用的、多数人知晓的、经过分类编目的、代码设计经验的总结。设计模式代表了最佳的实践，通常被有经验的软件开发人员所使用。

## 为什么学习设计模式

- 可以面对面试中的关于设计模式的问题，比如**单例模式**的几种实现方式；比如**懒汉式和饿汉式**你如何理解（**懒加载和立即加载**）
- 借助于设计模式可以编写出非常高效的代码，可复用性以及稳健性都会比较强。
- 有助于阅读源码框架，后续进阶提升所必须要掌握的技能
  - 看源码的能力：
    - 找到源码：ctrl + n
    - 类的继承关系: ctrl + h
    - debug执行

> 🏷️ 一些问题：
>
> 1. 设计模式分为哪几种类型？
>    1. 创建型
>    2. 结构型
>    3. 行为型
>
> 2. SOLID分别指的是哪几种原则，分别简单介绍一下
>
>    1. 单一职责原则：尽量使每一个类只负责一个功能
>
>    2. 开闭原则：权限对新增开放，对修改封闭
>
>    3. 里氏替换原则：**如果S是T的子类型，对于S类型的任意对象，如果将他们看作是T类型的对象，则它的行为也理应和预期的行为一致**。
>
>       > 这里的预期行为指的是T类型的行为，因为用父类引用指向子类对象时，会有多态的出现。如果方法调用和引用定义之间隔了很长，在使用这个引用时，预期是出现父类的行为。**所以里氏原则的意思是不使用方法重写。**
>
>    4. 迪米特法则：尽量不依赖，非得依赖的话就依赖接口。也叫做最少知道原则。
>
>    5. 接口隔离原则：一个类对另外一个类的依赖应当建立在**最小的接口**上。接口中的抽象方法写的应尽量的少。
>
>    6. 依赖倒置原则：指的是垂直关系上的依赖关系，高层不应该依赖底层，抽象不应该依赖具体。
>
> 3. 单例实现里有一个double check，请思考为什么要做第一次空值判断？
>
>    1. 外部的空值判断是为了减少争夺锁的次数，非空值表示已经创建了对象，不需要执行创建的原子操作，无法通过判断自然就不会进入争夺锁的过程
>    2. 内部的空值判断是为了避免这样一种情况，A线程通过了外部判断此时被B线程争夺了锁，当B完成对象创建之后，如果不加判断A会再次执行创建对象。
>
> 4. 请描述委托类和代理类之间的联系
>
>    1.
>
>    如果是JDK动态代理，代理类实现了和委托类相同的接口
>
>    如果是CGlib动态代理，代理类继承委托类
>
>    2.
>
>    代理类中一定会包含和委托类外观一致的方法，该方法中一定会有委托类方法的调用
>
>    > 委托类和代理类是两种在软件开发中常见的设计模式，它们之间有一些联系，但又有不同的用途和实现方式。
>    >
>    > 1. 委托类（Delegator Class）：
>    >   - 委托类是一个包含某个对象或功能的类，它通常具有一些公共接口或方法，允许其他对象将任务委托给它来执行。
>    >    - 委托类通常用于分离责任，将复杂的功能拆分成多个小的部分，然后将这些部分委托给其他类来处理。
>    >    - 委托类的主要作用是管理任务的分发和委托给其他对象，它通常不直接处理任务的具体实现。
>    > 
>    > 2. 代理类（Proxy Class）：
>    >   - 代理类是一种结构型设计模式，充当另一个对象的接口，以控制对这个对象的访问。
>    >    - 代理类的主要目的是在不改变原始对象的情况下，为其添加额外的功能，例如延迟加载、权限控制、缓存等。
>    >    - 代理类和原始对象通常都实现相同的接口，以保证对客户端代码的透明性。
>    > 
>    > 联系：
>    >
>    > - 委托类和代理类都涉及到将任务委托给其他对象。委托类通常是为了分离复杂功能的不同部分，而代理类通常是为了在访问一个对象时增加控制或附加功能。
>    >- 委托类可以被视为一种更通用的模式，它不仅可以用于代理，还可以用于其他目的，如策略模式、观察者模式等。
>    > - 代理类通常包含对委托类的引用，以便在必要时将任务委托给委托类。代理类可以根据需要选择性地调用委托类的方法。
>    > 
>    > 总之，委托类和代理类都有一个共同的目标，即将任务委托给其他对象来执行，但它们的实现方式和主要用途略有不同。委托类通常更加通用，而代理类通常用于控制对某个对象的访问或为其添加额外的功能。


## 设计模式的发展历史

> 要接触新概念
>
> 比如ChatGpt中`GPT`
>
>
> The acronym(首字母缩略词) "GPT" stands for "Generative Pre-trained Transformer." Let's break down what each part of the acronym means:
>
> 1. **Generative**: This refers to the model's ability to generate text or other types of data. In the case of GPT models, they are primarily used for generating human-like text, but they can also generate code, images, and more.
> 2. **Pre-trained**: Before being fine-tuned for specific tasks, GPT models are trained on a massive amount of text data from the internet. This pre-training helps the model learn grammar, facts, and some level of reasoning.
> 3. **Transformer**: The Transformer is a type of deep learning architecture that was introduced in a paper titled "Attention is All You Need" by Vaswani et al. in 2017. It revolutionized natural language processing tasks by introducing a mechanism called "self-attention" that allows the model to weigh the importance of different parts of the input data when making predictions.
>
> So, when you put it all together, "GPT" signifies a type of AI model that is capable of generating text and has been pre-trained on a large corpus of data using the Transformer architecture. GPT models are known for their versatility in various natural language understanding and generation tasks.

设计模式是由谁来发明的呢？其实最早提出设计模式概念的人并不是来自于软件领域，而是来自于建筑方向。由克里斯托佛·亚历山大在其著作 《建筑模式语言》 中首次提出的。比如包含对窗户应该在多高、 一座建筑应该有多少层以及一片街区应该有多大面积的植被等信息的描述。

后来埃里希·伽玛、 约翰·弗利赛德斯、 拉尔夫·约翰逊和理查德·赫尔姆这四位作者接受了模式的概念。 1994 年， 他们出版了 《设计模式： 可复用面向对象软件的基础》一书， 将设计模式的概念应用到程序开发领域中。 该书提供了 23 个模式来解决面向对象程序设计中的各种问题， 很快便成为了畅销书。 由于书名太长， 人们将其简称为 “四人组 （Gang of Four， GoF） 的书”， 并且很快进一步简化为 “GoF 的书”。

![image-20230226161500631](.\assets\image-20230226161500631.png)

## 设计模式的分类

GoF（4人组）设计模式共有23种，根据用途的不同，设计模式可以分为：**创建型、结构型、行为型**三种。

- **创建型模式**

  这类模式提供**创建对象**的机制， 能够提升已有代码的灵活性和可复用性。常见的有单例、工厂、建造者(生成器)模式。

  ![image-20230226210728330](.\assets\image-20230226210728330.png)
  
  <img src=".\assets\image-20230226210825852.png" alt="image-20230226210825852" style="zoom: 50%;" /><img src=".\assets\image-20230226210902155.png" alt="image-20230226210902155" style="zoom:50%;" />

​      <img src=".\assets\image-20230226211039002.png" alt="image-20230226211039002" style="zoom:50%;" />

- **结构型模式**

  这类模式介绍如何将对象和类**组装成较大的结构**， 并同时保持结构的灵活和高效。常用的有代理、桥接、装饰者、适配器模式。

  <img src=".\assets\image-20230226211324405.png" alt="image-20230226211324405" style="zoom:50%;" />

  <img src=".\assets\image-20230226211343900.png" alt="image-20230226211343900" style="zoom:50%;" />

  <img src=".\assets\image-20230226211547825.png" alt="image-20230226211547825" style="zoom:50%;" />

  <img src=".\assets\image-20230226211436160.png" alt="image-20230226211436160" style="zoom:50%;" />

  <img src=".\assets\image-20230226211510513.png" alt="image-20230226211510513" style="zoom:50%;" />

  <img src=".\assets\image-20230226211529699.png" alt="image-20230226211529699" style="zoom:50%;" />

  <img src=".\assets\image-20230226211411774.png" alt="image-20230226211411774" style="zoom:50%;" />

- **行为型模式**

  这类模式负责对象间的**高效沟通和职责委派**。常见的有观察者、模板、策略、责任链、迭代器、状态模式。

  <img src="F:/projectforme/java-53-course-materials/03-JavaEE&SpringFramework/02-笔记/image/Content06-DesignPattern/image-20230226212028023.png" alt="image-20230226212028023" style="zoom:33%;" /><img src="F:/projectforme/java-53-course-materials/03-JavaEE&SpringFramework/02-笔记/image/Content06-DesignPattern/image-20230226212106641.png" alt="image-20230226212106641" style="zoom:33%;" /><img src="F:/projectforme/java-53-course-materials/03-JavaEE&SpringFramework/02-笔记/image/Content06-DesignPattern/image-20230226212047381.png" alt="image-20230226212047381" style="zoom:33%;" /><img src="F:/projectforme/java-53-course-materials/03-JavaEE&SpringFramework/02-笔记/image/Content06-DesignPattern/image-20230226212130009.png" alt="image-20230226212130009" style="zoom:33%;" /><img src=".\assets\image-20230226212221808.png" alt="image-20230226212221808" style="zoom:33%;" />

  <img src=".\assets\image-20230226212530214.png" alt="image-20230226212530214" style="zoom:33%;" /><img src="F:/projectforme/java-53-course-materials/03-JavaEE&SpringFramework/02-笔记/image/Content06-DesignPattern/image-20230226212545672.png" alt="image-20230226212545672" style="zoom:33%;" /><img src=".\assets\image-20230226212601769-1694047584734-18.png" alt="image-20230226212601769" style="zoom:33%;" /><img src=".\assets\image-20230907084637424.png" alt="image-20230907084637424" style="zoom:33%;" />



## 🏷️ 设计模式原则

设计模式需要有设计的原则作为**指导纲领**，设计模式是在设计原则的指引下设计出来的。因为我们需要对设计原则有一个清晰的认识。

设计原则按照首字母简写可以概括为`SOLID`原则。

单一职责原则（**S**ingle Responsibility Principle）

开放封闭原则（**O**pen Close Principle）

里氏替换原则（**L**iskov Substitution Principle）

迪米特法则（**L**east Knowledge Principle）

接口分离原则（**I**nterface Segregation Principle）

依赖倒置原则（**D**ependency Inversion Principle）

### 单一职责原则

尽量使得**每个类只负责**整个软件的功能模块中的**一个**。当程序不断壮大之后，类也会变得非常的庞杂，查找某部分代码也会变得非常的吃力；如果此时需要做任何一处的修改，那么整个类的代码都会受到影响。

如下图所示，是一个雇员类。假设我们需要对雇员表进行修改。**但是出于两方面原因，我们需要对这个类进行修改**：

1. 和当前类主要功能相关的，比如管理雇员的信息等；
2. 打印雇员的信息，打印的信息随着时间的不同，对于格式要求也不太相同。

![image-20230907084927063](.\assets\image-20230907084927063.png)

出于上述两方面原因，我们需要对雇员类进行修改，但是修改该类的原因却不是一个，而是有多个原因。那么此时，雇员类的设计就不符合单一职责原则。我们可以尝试按照如下方式来进行修改：

![image-20230907084940783](.\assets\image-20230907084940783.png)

将打印相关的代码全部移动到一个新的类中，该类需要依赖于`Employee`类。

> 1. **如何理解单一职责原则（SRP）？**一个类只负责完成一个职责或者功能。不要设计大而全的类，要设计粒度小、功能单一的类。单一职责原则是为了实现代码高内聚、低耦合，提高代码的复用性、可读性、可维护性。
> 2. **如何判断类的职责是否足够单一？**不同的应用场景、不同阶段的需求背景、不同的业务层面，对同一个类的职责是否单一，可能会有不同的判定结果。实际上，一些侧面的判断指标更具有指导意义和可执行性，比如，出现下面这些情况就有可能说明这类的设计不满足单一职责原则：类中的代码行数、函数或者属性过多；类依赖的其他类过多，或者依赖类的其他类过多；私有方法过多；比较难给类起一个合适的名字；类中大量的方法都是集中操作类中的某几个属性。
> 3. **类的职责是否设计得越单一越好？**单一职责原则通过避免设计大而全的类，避免将不相关的功能耦合在一起，来提高类的内聚性。同时，类职责单一，类依赖的和被依赖的其他类也会变少，减少了代码的耦合性，以此来实现代码的高内聚、低耦合。但是，如果拆分得过细，实际上会适得其反，反倒会降低内聚性，也会影响代码的可维护性。

### 开放封闭原则

**对新增开放，对修改封闭**

开闭原则规定软件设计中的对象、类、模块以及函数等对于扩展是开放的，但是对于修改是封闭的。如果一个功能模块已经开发、测试完毕，那么对其代码直接进行修改便是有很大风险的。如果有新的业务功能，那么应当做的事情是对于现有代码进一步**扩展**，而不是修改现有代码。

比如可以创建一个子类来重写这部分业务逻辑以达到目的等。也就是说，我们应该选择使用抽象来定义结构，用具体实现来扩展细节。

> 上述讨论的前提是代码中没有缺陷等问题，如果代码中存在缺陷、bug等，那么直接对其进行修复即可。

比如，我们在学习数据库时，使用`Java`语言连接数据库，这种方式我们称之为`JDBC`。使用`Java`语言连接数据库，可以连接`Mysql`数据库，也可以连接`Oracle`数据库。如果我们之前使用`Mysql`数据库，如何扩展到对于`Oracle`数据库的支持呢？相信大家应该都不会陌生的。

设计一个`Connection`接口，不同的数据库厂商针对该接口，设计自己的`Connection`实现类。

![image-20230907084956955](.\assets\image-20230907084956955.png)



### 里氏替换原则

它由芭芭拉·利斯科夫（Barbara Liskov）在1987年在一次会议上名为《数据的抽象与层次》的演说中首先提出。主要内容如下：

**如果S是T的子类型，对于S类型的任意对象，如果将他们看作是T类型的对象，则它的行为也理应和预期的行为一致**。

> 这里的预期行为指的是T类型的行为，因为用父类引用指向子类对象时，会有多态的出现。如果方法调用和定义之间隔了很长，在使用这个对象时，预期是出现父类的行为。**所以里氏原则的意思是不使用方法重写。**

这意味着**子类必须保持与父类行为的兼容**。*在重写一个方法时，你要对基类行为进行扩展，而不是将其完全替换。* **在使用父类的程序中，替换为使用子类，那么程序的运行结果应该是一致的，不会发生任何异常**。下面的一个案例便是违反了里氏替换原则。

![image-20230907085040109](.\assets\image-20230907085040109.png)

上述案例如何改进呢？**子类的行为应当和父类保持一致**，但是**子类可以在父类的基础上做进一步的扩展**。修改为如下：

![image-20230907085053003](.\assets\image-20230907085053003.png)

### 迪米特法则

> 尽量不依赖，非得依赖的话，依赖接口

又叫作**最少知道原则**，指的是一个类/模块对于其他的类/模块有越少的了解越好。简单来说就是不应该有**依赖关系**的类之间，不要存在依赖关系；有依赖关系的类之间，尽量只依赖于接口。

迪米特法则还有一个更简单的定义：**只与直接的朋友通信**。什么是直接的朋友呢？我们称出现成员变量、方法参数、方法返回值中的类为直接的朋友，而出现在局部变量中的类则不是直接的朋友。**也就是说，陌生的类最好不要作为局部变量的形式出现在类的内部。**不要和"陌生人"说话。比如明星和经纪人之间的关系，明星处理各种事项，比如粉丝见面会、商业合作、剧邀约等事项，如果全部都亲力亲为，显然没有那么多的精力；可以将这些事项全部委托给经纪人代为办理。

如下图所示，全部的事情都由自己亲力亲为。此时一个类中有过多的依赖。

![image-20230907085137742](.\assets\image-20230907085137742.png)

可以按照如下方式来进行修改，在本案例中，经纪人是明星的朋友，其他均是陌生人，尽量不要和陌生人之间产生依赖。

![image-20230907085151959](.\assets\image-20230907085151959.png)

还比如，老师让班长点名，统计当天到的学生的人数。如果老师除了依赖班长，还依赖学生，那么就不满足迪米特法则，不应该有依赖关系的类之间尽量不要有依赖关系；相反，老师只需要依赖班长即可。

错误代码：

```java
public class Teacher {
    public void command(){
        //耦合了student类
        List<Student> students = new ArrayList<Student>();
        for(int i=0; i<20; i++){
            students.add(new Student());
        }
        
        //耦合了studentleader类
        StudentLeader leader = new StudentLeader();
        System.out.println("清点人数完毕，总共有:"+leader.counts(students)+"人");
        
    }
}

public class Student {

}

//班干部负责清点人数
public class StudentLeader {
    public int counts(List<Student> lists){
        return lists.size();
    }
}
public class Client{
    public static void main(String[] args){
        System.out.println("周末收假，学校领导命令老师去点名.....");
        Teacher teacher = new Teacher();
        teacher.command();
    }
}
```

正确代码

```java
public class LODTeacher {
    //仅仅耦合了LODStudentLeader类
    public void command(LODStudentLeader leader){
        System.out.println("清点人数完毕，总共有:"+leader.counts()+"人");
    }
}

public class LODStudentLeader {
    //仅仅耦合了student类
    private List<Student> students;
    
    public LODStudentLeader(List<Student> students){
        this.students = students;
    }
    public int counts(){
        return students.size();
    }
}

public class TaskTest {
    public static void main(String[] args) {
        System.out.println("周末收假，学校领导命令老师去点名.....");
        List<Student> students = new ArrayList<Student>();
        for(int i = 0; i < 20; i++ ){
              students.add(new Student());
        }
        LODTeacher teacher = new LODTeacher();
        teacher.command(new LODStudentLeader(students));
    }
}
```

### 接口隔离原则

一个类对另外一个类的依赖应当建立在**最小的接口**上。这句话的含义其实是要为各个类建立它们需要的**专用接口**，而不要试图去建立一个很庞大的接口供所有依赖它的类去调用。

> 将接口里的抽象方法写的尽量少

假设目前我们正在开发一套程序，该程序可以很方便地和目前市面上的云服务器进行整合。虽然最初版本是以阿里云服务器来进行开发对接，但是希望后期可以延展到所有的云服务器之上。所以，我们开发设计了一套接口包含了各个阶段的功能。

![image-20230907085213239](.\assets\image-20230907085213239.png)

通过上图，我们可以发现，后续整合腾讯云服务器时，我们发现，有几个功能暂未实现。遵循接口隔离原则，我们此时设计的接口就不符合最小接口的要求。我们应当将上述复杂、庞大的接口拆分为一组**颗粒度**更小的接口。

![image-20230907085229339](.\assets\image-20230907085229339.png)



### 依赖倒置原则

指的是设计代码架构时，**高层模块不应该依赖于底层模块，二者都应该依赖于抽象**。**抽象不应该依赖于细节，细节应该依赖于抽象。**其所表达的含义是指在软件设计过程中，细节具有多变性，而抽象则相对稳定，因此以抽象为基础搭建起来的架构要比以细节为基础搭建起来的架构稳定的多。

假设，我们正在组装一台电脑，`CPU`模块，我们可以选择`Intel`或者`AMD`;内存模块，我们可以选择`Kingston`或者`ADATA`;硬盘模块，我们可以选择`SEAGATE`或者`SanDisk`.我们可以按照如下方式来进行组织：

![image-20230907085250272](.\assets\image-20230907085250272.png)

上图的设计架构，初看没觉得有何不妥。但是如果我们需要更换不同的品牌型号，那么此时，我们的`Computer`类需要进行大幅的修改。

遵循依赖倒置原则，高层模块代码应该依赖于抽象。

![image-20230907085313563](.\assets\image-20230907085313563.png)



# 常用设计模式

## 创建型模式

创建型模式提供了创建对象的机制，能够提升已有代码的灵活性和可复用性。

### 单例模式（Singleton）

> 单例：单个实例
>
> ⚡⚡ 要会手写单例
>
> ```java
> public class SingletonUltra{
> 	private SingletonUltra instance;
> 	private SingletonUltra(){}
> 	public static getSingletonUltra(){
> 		if(instance == null){
> 			synchronized(Singlton.class){
> 				if(instance == null){
> 					instance = new SingletonUltra();
> 				}
> 			}
> 		}
> 		return instance;
> 	}
> }
> ```
>
> `Servlet`和`ServletContext`就是单例模式
>
> 注意单例有线程不安全的风险。

单例是一种创建型设计模式，让你保证一个类只有一个实例对象，并提供了一个访问该实例对象的**全局节点**。

> 在任意位置，可以通过方法获得该单例对象。也就是说，应该是**调用静态方法**

![image-20230907085353236](.\assets\image-20230907085353236.png)

> 满足的条件：
>
> 1. 私有化构造器
> 2. 提供一个静态方法返回这个单例
> 3. 定义一个全局的静态成员变量，来放置这个单例

对应的UML类图如下

![image-20230907085414178](.\assets\image-20230907085414178.png)

#### 饿汉模式

立即加载

在类加载的过程中初始化了私有的静态实例对象，保证了该实例对象的线程安全性。因为该实例对象先于使用前提供，所以称之为饿汉模式。

```java
package com.cskaoyan.pattern.singleton;

public class Singleton1 {

    //创建私有静态实例对象
    private static final Singleton1 instance = new Singleton1();

    //私有化构造函数
    private Singleton1(){}

    public static Singleton1 getInstance(){
        return instance;
    }
}
```

饿汉式特点：不支持延时加载（懒加载），获取对象速度比较快；但是如果对象比较大，或者一直没有去使用，那么比较浪费内存空间。

#### 懒汉模式(线程不安全)

> 1. 使用的时候才加载
> 2. 只加载一次
>
> 也就是，第一次使用的时候实例化。
>
>  ⚡如何判断出是第一次使用呢,判断该实例对象是非为`null`
>
> 线程不安全的原因，多个线程抢占`if`判断。想要保证线程安全，就需要使用`sychronized`进行上锁。进一步地，`double check`，在锁外面再加一个`if`判断，**减少锁的争抢次数**，如果是空才会继续抢锁，否则直接返回。

```java
package com.cskaoyan.pattern.singleton;

public class Singleton2 {

    private static Singleton2 instance;

    //私有化构造函数
    private Singleton2(){}

    //判断当前对象是否已经被创建
    public static Singleton2 getInstance(){
        if(instance == null){
            instance = new Singleton2();
        }
        return instance;
    }
}
```

编写测试用例，我们使用`1000`个线程来创建`Singleton2`对象，发现对象的地址不同。**产生上述问题的主要原因在于我们执行的代码其实都不是原子性，在多线程操作的过程中，会进行线程切换。比如线程A执行到` if(instance == null)`，继续执行代码便会创建instance实例对象， 但是此时进行了线程切换；切换到了线程B，线程B创建了instance对象；随后再次线程切换给线程A，因为线程A已经执行过判断，所以便会直接执行`instance = new Singleton2();`，便又会创建一个对象**。

![image-20230907085438018](.\assets\image-20230907085438018.png)

#### 懒汉模式(线程安全)

如何保证线程安全呢？使用`synchronized`关键字即可。

```java
package com.cskaoyan.pattern.singleton;

public class Singleton3 {

    private static Singleton3 instance;

    //私有化构造函数
    private Singleton3(){}

    //引入synchronized，保证多线程模式下实例对象的唯一性
    public static synchronized Singleton3 getInstance(){
        if(instance == null){
            instance = new Singleton3();
        }
        return instance;
    }
}
```

使用`synchronized`锁住对象创建的方法，防止该方法被多个线程同时调用。

但是这种方式最合适吗？

**因为我们对`getInstance()`添加了锁，降低了该方法的并发量；实际上，我们只需要针对最开始抢先创建实例对象的线程加锁即可，后续的线程在执行时，因为`if(instance == null)`条件已经不满足，所以直接执行返回实例对象即可，此时不需要加锁**。

#### 双重检查(`Double Check`)

针对上述存在的问题，我们做了进一步修改。这种方式最明显的特征是`synchronized`关键字不是修饰整个方法，而是仅修饰创建对象的代码块，可以**提高并发**；此外，存在两个`if`条件判断语句。这也是双重检查的由来。

**为什么需要双重检查呢？**

线程A可能先执行到了外层的`if`条件判断，执行通过之后并没有进一步执行，而是进行了线程的切换，切换成了线程B；线程B也执行了外层的`if`条件判断，并且顺利地获取到了锁，执行完了内部的`if`条件判断，创建了实例对象；如果此时线程再次切换给线程A，线程A因为刚刚已经执行完外层的`if`条件判断，此时顺利的获取到了锁，如果没有内部的`if`条件判断，则会再次创建一个实例对象。这也是为何一定要双重检查的原因。

 ```java
package com.cskaoyan.pattern.singleton;

public class Singleton4 {

    private static Singleton4 instance;

    //私有化构造函数
    private Singleton4(){}
    
    public static Singleton4 getInstance(){
        if(instance == null){
            synchronized (Singleton4.class){
                if(instance == null){
                    instance = new Singleton4();
                }
            }
        }
        return instance;
    }
}
 ```

#### 静态内部类

> 静态内部类类加载的时候执行，并且只执行一次.

利用**静态内部类来解决延迟加载、线程安全的问题**；并且可以使得代码更加简洁。由`JVM`来保障线程安全性。

```java
public class Singleton5 {

    private static Singleton5 instance;

    //私有化构造函数
    private Singleton5(){}
	
    //静态内部类
    private static class SingletonHolder{
        private static Singleton5 instance = new Singleton5();
    }

    public static Singleton5 getInstance(){

        return SingletonHolder.instance;
    }
}
```

#### 枚举(不建议写)

```java
public enum Singleton6 {

    INSTANCE;

    public static Singleton6 getInstance(){
        return INSTANCE;
    }
}
```

#### 总结

- 饿汉式：在类加载时期，便已经将instance实例对象创建了；所以这种方式是线程安全的方式，但是不支持懒加载。
- 懒汉式：该种方式支持懒加载，但是要么不是线程安全，要么虽然是线程安全，但是需要频繁释放锁、抢夺锁，并发量较低。
- 双重检查：既可以实现懒加载，又可以实现高并发的需求。这种方式比较完美，但是代码有一些复杂。
- 静态内部类：使用该种方式也可以解决懒加载以及高并发的问题，代码实现起来比双重检查也是比较简洁。
- 枚举：最简单、最完美的实现方式。

### 工厂模式（Factory）

工厂顾名思义就是生产产品的地方。我们通常会定义工厂（类、接口），通过该工厂类（或其工厂实例）提供的方法能够获得返回值，该返回值就是通过工厂生产的实例。

也就是说，<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**工厂中一定会提供一个返回实例的方法。其中核心的好处是封装（隐藏）生产的具体细节**</span>

<font color='red'>**工厂类或接口的命名方式，通常为XxxFactory**</font>

#### 简单工厂模式

之所以叫简单工厂是因为真的非常简单，只要一个工厂（函数）就可以了，**那么只需要传入不同的参数，就可以返回不同的产品（实例**），这种模式就叫**简单工厂模式**。

比如，我们要生产Tesla汽车，Tesla下又有不同的产品，比如Model3、ModelY、ModelS等，我们其实可以通过给简单工厂传入不同的参数，来生产不同的产品

首先定义不同的产品

```java
public abstract class Tesla {
    String name;
    public Tesla(String name) {
        this.name = name;
    }
    public void run(){
        System.out.println(name + "在路上跑");
    }    
}
public class Model3 extends Tesla{
    public Model3() {
        super("model 3");
    }
}
public class ModelS extends Tesla{
    public ModelS() {
        super("model S");
    }
}
public class ModelY extends Tesla{
    public ModelY() {
        super("model Y");
    }
}
```

我们在上面定义了抽象类Tesla，通过不同的子类定义不同的车型

接下来，**先不使用工厂**

```java
Scanner scanner = new Scanner(System.in);
String keyword = scanner.nextLine();
Tesla tesla = null;
switch (keyword) {
    case "model3":
        tesla = new Model3();
        break;
    case "modely":
        tesla = new ModelY();
        break;
    case "models":
        tesla = new ModelS();
        break;
    default:
        tesla = new Tesla("未知车辆") {
            @Override
            public void run() {
                System.out.println(name + "路上请注意，道路千万条，安全第一条");
            }
        };
        break;
}
tesla.run();
```

然后再**使用工厂**

将获得tesla对象的过程放入到工厂的生产方法中，故定义一个这样的工厂

```java
public class SimpleTeslaFactory {
    
    public static Tesla create(String keyword) {
        Tesla tesla = null;
        switch (keyword) {
            case "model3":
                tesla = new Model3();
                break;
            case "modely":
                tesla = new ModelY();
                break;
            case "models":
                tesla = new ModelS();
                break;
            default:
                tesla = new Tesla("未知车辆") {
                    @Override
                    public void run() {
                        System.out.println(name + "路上请注意，道路千万条，安全第一条");
                    }
                };
                break;
        }
        return tesla;
    }
}
```

其中的create方法可以定义为**静态**

我们通过工厂提供的create方法可以直接获得tesla对象

```java
Scanner scanner = new Scanner(System.in);
String keyword = scanner.nextLine();
Tesla tesla = SimpleTeslaFactory.create(keyword);
tesla.run();
```

#### 工厂方法模式

![image-20230907085615765](.\assets\image-20230907085615765.png)

工厂方法模式，是一种创建型设计模式，其在父类中提供一个创建对象的方法，允许子类决定实例化对象的类型。
它的主要意图是定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式**使其创建过程延迟到子类进行**。

我们通过模拟客户下单一辆特斯拉电动车，特斯拉生产车间需要交付一辆该型号汽车来讲述该设计模式。首先不借助于任何设计模式，我们先完成该功能。

```java
import java.util.Scanner;

public class OrderCar {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String keyword = scanner.nextLine();
        Tesla tesla = SimpleTeslaFactory.create(keyword);
        tesla.run();
    }
}
```

上述的案例，我们便实现了根据订购的车型不同，生产不同的车辆。但是面临最大的问题便是在于扩展车型时非常的麻烦。当我们需要重构代码时，代码中涉及到的地方千丝万缕、错综复杂会使得开发人员望而却步。接下来，我们尝试使用工厂方法来重构上述代码。

对应的类关系如下

![image-20230907085639694](.\assets\image-20230907085639694.png)

```java
public interface TeslaFactory {

    public Tesla getTesla();
}
```

```java
public class ModelYFactory implements TeslaFactory{
    @Override
    public Tesla getTesla() {
        return new ModelY();
    }
}
public class Model3Factory implements TeslaFactory{
    @Override
    public Tesla getTesla() {
        return new Model3();
    }
}
//其他工厂类似，就不全部列举了
```

```java
public class OrderTesla {

    private static Map<String, TeslaFactory> factoryMap = new HashMap<>();

    static {
        factoryMap.put("modelx", new ModelXFactory());
        factoryMap.put("modely", new ModelYFactory());
        factoryMap.put("models", new ModelSFactory());
        factoryMap.put("model3", new Model3Factory());
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String keywords = scanner.nextLine();
        TeslaFactory teslaFactory = factoryMap.get(keywords.toLowerCase());
        Tesla tesla = teslaFactory.getTesla();
        tesla.run();
    }
}
```

通过`OrderTesla`类的代码和`OrderCar`代码进行比较，我们发现代码明显变得更加简洁了。



#### 抽象工厂模式

![image-20230907085653958](.\assets\image-20230907085653958.png)

是所有工厂模式中抽象程度最高的一种模式。抽象工厂模式可以向客户端提供一个接口，使得客户端可以在不必指定具体类型的情况下，能够创建多个一系列或者相关联的对象。

工厂方法和抽象工厂，首先都是要将工厂抽象为接口或抽象类。工厂方法主要是生产的是单个产品，抽象工厂主要是生产是一系列的产品。

工厂方法：单品

抽象工厂：产品矩阵

我们以下面这个案例来进行讲述。随着智能家居的兴起，许多家庭在选择家居电器时，会倾向于选择同一厂家的产品。比如目前市面上有`Haier`以及`Mi`的家居产品。不同的厂家产品线都非常丰富，涵盖`TV`、`Freezer`等。设计一套代码程序，根据用户选择的厂家，提供对应的配套产品。

对应的类关系如下：

![image-20230907085712058](.\assets\image-20230907085712058.png)

```java
public abstract class AbstractFurnitureFactory {

    public abstract TV createTV();
    public abstract Freezer createFreezer();
}
```

```java
public class MiFurnitureFactory extends AbstractFurnitureFactory{
    @Override
    public TV createTV() {
        return new MiTV();
    }

    @Override
    public Freezer createFreezer() {
        return new MiFreezer();
    }
}
```

```java
public class HaierFurnitureFactory extends AbstractFurnitureFactory{
    @Override
    public TV createTV() {
        return new HaierTV();
    }

    @Override
    public Freezer createFreezer() {
        return new HaierFreezer();
    }
}
```

```java
public class OrderFurniture {
    public static void main(String[] args) {
        MiFurnitureFactory miFactory = new MiFurnitureFactory();
        TV tv = miFactory.createTV();
        Freezer freezer = miFactory.createFreezer();
        System.out.println("tv instanceof MiTV = " + (tv instanceof MiTV));
        System.out.println("freezer instanceof MiFreezer = " + (freezer instanceof MiFreezer));
    }
}
```

### 建造者模式（Builder）

![image-20230907085740047](.\assets\image-20230907085740047.png)

建造者模式也叫作生成器模式，就是分步骤创建复杂对象，该模式允许使用相同的创建代码生成不同类型和形式的对象。

> 1. Lombok的`@Builder`会创建一个`XxxBuilder`的内部类,使用Lombok的时候会自动生成全参构造,这时就会覆盖掉默认的无参构造,所以为了防止其他方法中通过反射调用无参构造报错,需要同时加无参构造的注解和全参构造注解
> 2. `StringBuffer`也是建造者模式,方法`append()`返回值仍是一个`StringBuffer`

在开发中，有时候我们需要创建出一个很复杂的对象，这个对象的创建有一个固定的步骤，并且每个步骤中会涉及到多个组件对象，这个时候就可以考虑使用建造者模式。使用建造者模式将原本复杂的对象创建过程按照规律将其分解成多个小步骤，这样在构建对象时可以灵活的选择或修改步骤。建造者模式将对象的创建和表示过程进行分离，这样我们可以使用同样的过程，只需修改这个过程中的小步骤，便能够构建出不同的对象。而对于调用方来说，我们只需要传入需要构建的类型，便能够得到需要的对象，并不需要关系创建的过程，从而实现解耦。

比如我们要制造手机，手机里包含屏幕、颜色、电池、摄像头、系统等组成，那么我们定义一个Phone如下

```java
@Data
public class Phone {
    private String battery;
    private String screen;
    private String os;
    private String camera;
    private String color;
    // 通过@Data提供了getter/setter方法，以及我们打印的时候用的toString方法
}
```

然后我们要提供一个PhoneBuilder类

> 1. 通过Builder类提供的build方法能够获得Phone实例
> 2. 同时提供一些方法，通过这些方法能够设置build方法获得的该phone实例的属性值
> 3. 要保证这些方法操作的是同一个phone实例，要在Builder中提供phone成员变量

基于以上，我们定义的PhoneBuilder如下

```java
public class PhoneBuilder {
    private Phone phone = new Phone();

    public PhoneBuilder color(String color) {
        this.phone.setColor(color);
        return this;
    }

    public PhoneBuilder battery(String battery) {
        this.phone.setBattery(battery);
        return this;
    }

    public PhoneBuilder screen(String screen) {
        this.phone.setScreen(screen);
        return this;
    }

    public PhoneBuilder os(String os) {
        this.phone.setOs(os);
        return this;
    }

    public PhoneBuilder camera(String camera) {
        this.phone.setCamera(camera);
        return this;
    }

    public Phone build() {
        return this.phone;
    }
}
```

使用如下

```java
public class UseBuilder {
    public static void main(String[] args) {
        PhoneBuilder builder = new PhoneBuilder();
        Phone phone = builder.battery("4000毫安大容量")
                .camera("徕卡顶级镜头")
                .color("尊贵黑")
                .screen("2K高清分辨率")
                .os("Android")
                .build();
        System.out.println("phone = " + phone);
    }
}
```

上述代码是建造者模式最经典的使用方式。

建造者模式的优点如下：

- 可以构造出复杂的对象。这个模式适用于：某个对象的构建过程复杂的情况。
- **不同的构建器，相同的装配，也可以做出不同的对象**，实现了更好的复用。
- 建造者模式可以将部件和其组装过程分开，一步一步创建一个复杂的对象。用户只需要指定复杂对象的类型就可以得到该对象，而无须知道其内部的具体构造细节。

采用链式调用，一步一步把一个完整的对象构建出来。使用该模式是一次性将一个完整的对象构建出来，更加的紧凑，同时也避免了对象在其他处调用了set方法导致属性赋值错误。



建造者设计模式和工厂设计模式都是为了创建具体的实例：工厂模式更关注通过什么工厂生产什么实例，建造者模式主要是通过组装零配件而产生一个新产品

## 结构型模式

### ⚡🐟 代理

> 需要增加额外的内容,把额外内容放在代理里.比如"开启事务" "提交事务" "操作日志"

![image-20230907085827998](.\assets\image-20230907085827998.png)

代理是一种结构型设计模式，可以允许我们生成对象的替代品。代理控制着对于原对象的访问，同时也允许在原对象的方法之前后做一些处理，便可以实现在原方法执行前后都会执行某段代码逻辑的功能。这个也是**面向切面编程**的指导思想。
代理模式在我们日常生活中用处还是相当广泛的，比如**海外购网站**就是一个代理。海外购网站负责代理用户到国外的电商网站去下单购买商品，也可以在商品送达到海外购网站时，再执行进一步加固操作，再次转送给用户。
代理模式在软件开发过程中的应用场景也非常常见。在客户端以及客户端访问的目标类对象中间，额外再引入一个第三方代理类对象。如果直接访问目标类对象，就是执行对应的方法；如果客户端访问的是代理类对象，那么不仅可以访问对应的方法，还会在方法的执行前后执行对应的**前置、后置通知**。

![image-20230907085851936](.\assets\image-20230907085851936.png)

#### 静态代理

```java
public interface UserService {
    void insert();
}
```

```java
public class UserServiceImpl implements UserService {
    @Override
    public void insert() {
        System.out.println("目标类执行了insert方法");
    }
}
```

```java
public class UserServiceProxy implements UserService {

    UserService target;

    public UserServiceProxy(UserService target) {
        //注入委托类对象
        this.target = target;
    }

    @Override
    public void insert() {
        System.out.println("代理之前打印一个日志");
        target.insert();
        System.out.println("代理之后打印一个日志");
    }
}
```

```java
@Test
    public void test1(){
        UserServiceProxy proxy = new UserServiceProxy(new UserServiceImpl());
        proxy.insert();
    }
```

注意回顾静态代理的优化过程

![Day12-代理梳理](.\assets\Day12-代理梳理.jpg)

代理模式最大的优点在于可以不更改目标类代码的前提下，扩展目标类代码的功能。

静态代理最大的缺点在于代码较为冗余，每代理一个类，便要手动编写一个代理类；代理对象和目标类对象均实现了接口，如果接口发生了修改，不仅目标类需要更改，代理类也需要同步发生修改，维护成本变高了很多。



#### JDK动态代理

![image-20230908093348453](.\assets\image-20230908093348453.png)

代理类实现和委托类相同的接口。
委托类和代理类是兄弟关系。使用相同的接口来接收。

> 静态代理，顾名思义，便是在编译时，就已经实际存在了该`class`文件；而动态代理，在编译时期，实际上并不存在该`class`文件，而是程序在运行阶段动态生成了字节码。
> `JDK`动态代理，即`JDK`给我们提供的动态生成代理类的方式，无需引入第三方`jar`包。但是使用`JDK`动态代理有一个**先决条件**，那就是目标类对象必须实现了某个接口；如果目标类对象没有实现任何接口，则`JDK`动态代理无法使用。

如果使用`JDK`提供的动态代理，那么需要借助如下几个类

- `java.lang.reflect.Proxy`

  | API                                                          | 参数                                                         | 返回值                                                       |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | public `static`  Object `newProxyInstance`(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h) | `loader`表示目标类使用的类加载器；`interfaces`表示目标类所实现的接口类型；`h`表示处理器，用来规定代理的内部细节 | 返回一个实现指定接口的代理类实例对象；代理类对象和目标类对象实现相同的接口类型 |

- `java.lang.reflect.InvocationHandler`

  | API                                                          | 参数                                                         | 返回值                             |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------- |
  | public Object invoke(Object proxy, Method method, Object[] args) | `proxy`表示JDK帮助开发者生成的代理类对象，这个参数一般不用理会；`method`表示的是目标类中的方法；`args`表示执行目标类方法时传递的参数；三个参数合在一起表示的含义表示代理类如何来代理、增强目标类里面的方法 | 代理类执行完对应的方法时它的返回值 |

```java
public class ProxyFactory {

    Object target;

    public ProxyFactory(Object target) {
        this.target = target;
    }

    public Object newProxyInstance(){
        return Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                new InvocationHandler() {
                    
                    //代理类如何代理
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        System.out.println("代理之前签订合约");
                        Object invoke = method.invoke(target, args);
                        System.out.println("代理完毕转账确认");
                        return invoke;
                    }
                });
    }
}
```

```java
@Test
    public void test2(){
        UserService userService = new UserServiceImpl();
        //对哪个目标类进行代理，我们对UserServiceImpl进行代理
        //生成代理类对象
        UserService userServiceProxy = Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                new InvocationHandler() {
                    
                    //代理类如何代理
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        System.out.println("代理之前签订合约");
                        Object invoke = method.invoke(userService, args);
                        System.out.println("代理完毕转账确认");
                        return invoke;
                    }
                });
        //代理类对象执行insert方法，什么逻辑呢？主要是invoke里面的代码逻辑
        userServiceProxy.insert();
    }
```



利用线上监测工具以及反编译工具，可以看到生成的代理类对象源码

```java
public final class $Proxy0
extends Proxy
implements UserService {
    private static Method m1;
    private static Method m3;
    private static Method m2;
    private static Method m0;

    public $Proxy0(InvocationHandler invocationHandler) {
        super(invocationHandler);
    }

    static {
        try {
            m1 = Class.forName("java.lang.Object").getMethod("equals", Class.forName("java.lang.Object"));
            m3 = Class.forName("com.cskaoyan.pattern.proxy.UserService").getMethod("insert", new Class[0]);
            m2 = Class.forName("java.lang.Object").getMethod("toString", new Class[0]);
            m0 = Class.forName("java.lang.Object").getMethod("hashCode", new Class[0]);
            return;
        }
        catch (NoSuchMethodException noSuchMethodException) {
            throw new NoSuchMethodError(noSuchMethodException.getMessage());
        }
        catch (ClassNotFoundException classNotFoundException) {
            throw new NoClassDefFoundError(classNotFoundException.getMessage());
        }
    }

    public final boolean equals(Object object) {
        try {
            return (Boolean)this.h.invoke(this, m1, new Object[]{object});
        }
        catch (Error | RuntimeException throwable) {
            throw throwable;
        }
        catch (Throwable throwable) {
            throw new UndeclaredThrowableException(throwable);
        }
    }

    public final String toString() {
        try {
            return (String)this.h.invoke(this, m2, null);
        }
        catch (Error | RuntimeException throwable) {
            throw throwable;
        }
        catch (Throwable throwable) {
            throw new UndeclaredThrowableException(throwable);
        }
    }

    public final int hashCode() {
        try {
            return (Integer)this.h.invoke(this, m0, null);
        }
        catch (Error | RuntimeException throwable) {
            throw throwable;
        }
        catch (Throwable throwable) {
            throw new UndeclaredThrowableException(throwable);
        }
    }
	//主要关注insert方法
    public final void insert() {
        try {
            this.h.invoke(this, m3, null);
            return;
        }
        catch (Error | RuntimeException throwable) {
            throw throwable;
        }
        catch (Throwable throwable) {
            throw new UndeclaredThrowableException(throwable);
        }
    }
}
```

#### CGlib动态代理

委托类是代理类的父类，也可以让代理类和委托类的“外观一致”。

![image-20230908093640850](.\assets\image-20230908093640850.png)

`Cglib`(`Code Generation Library`)是一个开源项目，是一个强大的，高性能，高质量的`Code`生成类库，它可以在**运行期**扩展`Java`类与实现`Java`接口。我们可以借助于`Cglib`来帮助我们动态地生成代理类对象。`Cglib`可以弥补`JDK`动态代理的不足，`JDK`要求目标类必须实现了某个接口，才可以执行代理功能；而`Cglib`对此无任何要求，**主要原因在于`Cglib`扩展的代理类会继承自目标类**。**所以这也要求我们的目标类不能是`final`修饰**。

使用`Cglib`涉及到的相关类如下

- `net.sf.cglib.proxy.Enhancer`

  | API                                  | 参数                                                         | 返回值/说明                                                  |
  | ------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | enhancer.`setSuperclass(superClass)` | 父类的字节码对象，也就是我们的目标类                         | 无返回值;Cglib产生的代理类会继承目标类，所以此处设置的父类也就是目标类 |
  | enhancer.`setCallBack(callback)`     | 设置一个回调函数，代理类对象如何代理目标对象需要在回调函数中制定策略 | CallBack是一个接口，MethodInterceptor是一个子接口。我们选用该类来设置回调策略 |
  | enhancer.`create()`                  | -                                                            | 生成代理类对象                                               |

- `net.sf.cglib.proxy.MethodInterceptor`

  | API                                                          | 参数                                                         | 返回值/说明                                    |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------- |
  | public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) | 第一个参数obj为代理类对象；第二个参数为目标类对应中对应的方法；第三个参数为目标类对象中对应的方法执行时传递的参数；第四个参数是代理类对象中的对应方法 | 返回值一般便将代理类对象对应方法的执行结果返回 |



使用Cglib需要导包

```xml
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.3.0</version>
</dependency>
```

创建一个目标类，在这里为了体现Cglib的效果，目标类没有实现任何接口

```java
public class UserServiceImpl {

    public String getName(){
        System.out.println("目标方法执行");
        return "zhangsan";
    }
}
```

编写测试代码

```java
public class ProxyTest {

    public static void main(String[] args) {
        UserServiceImpl userService = new UserServiceImpl();

        UserServiceImpl userServiceProxy = Enhancer.create(UserServiceImpl.class,new InvocationHandler() {

            //代理类如何代理
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                System.out.println("目标方法执行之前");
                Object invoke = method.invoke(userService, args);
                System.out.println("目标方法执行之后");
                return invoke;
            }
        });
        String name = userServiceProxy.getName();
        System.out.println(name);
    }
}
```

动态代理和注解结合。

## 行为型模式

### 责任链(Respnsibility Chain)

![image-20230907085940494](.\assets\image-20230907085940494.png)

责任链是一种行为设计模式，允许请求沿着链进行发送。收到请求后，每个处理者均可对请求进行处理或者将其传递给链上的下一个处理者。

对应的类关系如下

![image-20230907085957403](.\assets\image-20230907085957403.png)

我们先举一个简单的例子，提供三个处理器，并处理好其先后关系，然后分别依次处理，那么我们要做的事情拆解如下

> 1. 定义三个不同的处理器
> 2. 这三个处理器做的是类似的事情，那么可以抽象一个接口或抽象类，接下来就是关于抽象类中的方法
> 3. 要处理先后关系，可以提供一个方法来处理处理器的顺序关系
> 4. 要做处理器的核心方法完成业务的处理，每个处理器的处理方法的业务不同

将一些共性的部分放置在一个基类中，其中提供的成员变量next能够维护顺序关系，通过调用其提供的setNext方法完成顺序关系的维护，handle方法能够提供不同的

```java
public abstract class AbstractHandler {
    AbstractHandler next;
    public void setNext(AbstractHandler next){
        System.out.println("已经设置" + this.getClass().getSimpleName() + "的下一级为" + next.getClass().getSimpleName());
        this.next = next;
    }
    public abstract void handle();
}
```

三个处理器

```java
public class Level1Handler extends AbstractHandler{
    @Override
    public void handle() {
        System.out.println("一级处理器正在处理");
        if (next != null) {
            next.handle();
        }
    }
}
```

```java
public class Level2Handler extends AbstractHandler{
    @Override
    public void handle() {
        System.out.println("二级处理器正在处理");
        if (next != null) {
            next.handle();
        }
    }
}
```

```java
public class Level3Handler extends AbstractHandler{
    @Override
    public void handle() {
        System.out.println("三级处理器正在处理");
        if (next != null) {
            next.handle();
        }
    }
}
```



最终的测试

```java
public class ChainExecution {

    public static void main(String[] args) {
        Level1Handler level1Handler = new Level1Handler();
        Level2Handler level2Handler = new Level2Handler();
        Level3Handler level3Handler = new Level3Handler();

        level2Handler.setNext(level3Handler);
        level1Handler.setNext(level2Handler);

        level1Handler.handle();
    }
}
```

责任链模式降低了系统之间的耦合性，提升了系统的可扩展性。在很多中间件、框架的内部大量地使用了该种设计模式，比如Filter的执行过程等。
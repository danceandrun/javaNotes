1. **父类中定义的哪些方法不能发生多态现象？为什么？**

   1. >考虑到多态发生的条件是:
      >
      >1）继承
      >
      >2）方法覆盖
      >
      >3）父类引用指向子类实例
      >
      >所以哪些方法(行为)，实现不了多态效果呢？不能在子类中被覆盖的方法
      >
      >1. 父类中的`private`方法(不能被子类覆盖)
      >2. 父类中的构造方法(不能被子类继承)
      >3. 父类中的静态方法(不能被子类覆盖)
      >4. 父类中被final修饰的方法(不能被子类覆盖)
      >
   
2. **方法重载和方法重写的区别?**

   1. >方法重载是指在同一个类中定义同名方法，而这些方法名称相同，但方法签名不同，也就是方法的形参列表不同。而其余方法中的因素，比如修饰符列表，返回值类型等是不影响方法重载的。 方法重写，是指在子类中重写父类中定义的方法的实现。因此方法重写必然发生在父子类两个类当中，而且方法重写对语法的要求也更严苛： 1. 子类中重写的方法，访问权限等级，必须至少保持一致，可以更为宽松，但一定不能更严格。 2. 子类中重写的方法，返回值类型必须和原先父类方法的返回值类型，保持兼容。 3. 子类中重写的方法，方法名必须严格保持一致，不能做任何修改。 4. 子类中重写的方法，形参列表必须保持严格一致，不能做任何修改。

3. **`==`和`equals`方法有何异同？（`==`可以从基本数据类型和引用数据类型两个角度分析）**

   1. > `== `对于基本数据类型的数据而言，比较的是内容，也就是数值。对于引用数据类型的数据而言，比较的地址，比较的是两个引用是否指向同一个对象。 equals方法是Object类的方法，Java所有类都继承了该方法。其默认实现是比较两个对象的内存地址是否相同，若想要比较量对象的内容（成员变量）是否相同，则需要在子类中覆盖Object的equals方法。

4. **Java多线程中调用`wait() `和 `sleep()`方法有什么不同？**

   1. > sleep方法的唤醒条件是时间，而wait()方法的唤醒条件是，必须被在同一个锁对象上调用notify()或notifyAll()方法。 sleep方法是Thread类的静态方法，而wait()方法是Object类的方法 sleep方法在导致当前线程休眠时，当前线程不会释放所有有的锁，而wait()方法导致当前线程休眠时，当前线程会释放锁对象

5. **`String`，`StringBuffer`，`StringBuilder`有什么区别？**

   1. >三者都是用来进行字符串处理的，
      >
      >但是有以下不同
      >
      >1.String是对象不可变的，不能改变长度；StringBuffer，StringBuilder可以通过append方法动态增加字符串长度；
      >
      >2.StringBuffer和StringBuilder的区别在于StringBuilder不是线程安全的，但效率高，StringBuffer线程安全

6. **如何理解静态上下文无法访问非静态的成员变量和成员方法？原因是什么？**

   1. > 这句话的意思实际上就是说，在static中不能访问非static，具体来说就是在静态方法，静态代码块中不能访问非静态成员变量和成员方法，也不能使用this，super等语法。 原因也很简单，static的存在依赖于类加载的过程，不依赖于对象。所以从内存的角度考虑，静态成员内完全可能没有对象存在，也就自然无法访问.

7. **字符流和字节流的主要区别是什么？如何理解字符流=字节流+编码表？**

   1. >字节流和字符流都是Java中进行IO操作处理的方式，它们之间主要区别在于：
      >
      >1. 处理数据的逻辑单位不同：字节流以字节（8位）为基本处理单位，而字符流固定以字符为单位处理数据。
      >2. 能够处理的文件类型不同：字节流是万能流可以处理任何文件，但字符流只能用于处理文本文件。
      >
      >关于“字符流 = 字节流 + 编码表”这句话，首先应该清楚所有的字符流实际上都是字节流的包装流，它们底层实现IO功能的流仍然是字节流，其次，字符流对象在内部还封装了一个基于编码表的进行编解码的缓冲区。
      >
      >比如：当我们使用字符流读取文本数据时，实际上是先通过字节流读取字节数据，然后通过编码表将这些字节转换为字符。
      >
      >相反，当我们使用字符流写出文本数据时，实际上是先通过编码表将字符转换为字节，然后通过字节流将这些字节写出。
      >
      >所以对于字符流，可以通俗的认为，它就是一个基于编码表，扩展了编解码功能的字节流。

8. 运行时异常，编译时异常有什么区别？

   列举几个常见的运行时异常和编译时异常（每个列举三个即可）

   1. > 运行时异常 ，指的是在程序运行期间，发生的一般问题。对于运行时异常，即便程序本身不做任何处理程序也能正常编译和启动。 在编译过程中，不要求必须进行显示捕捉编译时异常，在编译过程中，必须进行处理，要么捕捉，要么通过throws 抛出去.

9. 匿名内部类的语法，`Lambda`表达式的语法，它们整体分别表示什么呢？

   （比如它们的语法结构究竟是表示类还是表示对象呢？表示什么类或者什么对象？）

   1. > 匿名内部类的语法整体表示语法结构中类名/接口名的子类（实现类）对象 Lambda表达式语法整体则表示某个功能接口的实现类对象，至于具体表示哪个功能接口的子类对象，则需要进行类型推断。单靠Lambda表达式本身是无法确定的

10. 在new对象的过程中，成员变量的赋值顺序是什么样的？

    （需要考虑显式赋值，构造代码块赋值，构造器赋值等）

    （需要考虑继承）

    1. > 首先大的原则就是“先父后子”，也就是说父类成员变量的任何赋值手段，都要先于子类执行。 （默认初始化永远最先执行，无论父类还是子类的成员变量皆具有这个原则，所以以下我们不考虑默认初始化） 然后在父子类各自的类中，成员变量的赋值： 1.显式赋值和构造代码块赋值按照代码书写顺序从上往下执行。 2.构造器赋值总是最后执行

11. 请描述一下普通类、接口的抽象类的`extends`、`implements`关系。

    （比如普通类可以实现接口，可以继承抽象类等）

    建议从extends和implements两个角度回答这道题

    1. > 我们分成两个角度来解释这个问题： 1.extends，继承是不能跨越种族的，类和类继承，接口和接口继承，类和接口之间不存在继承。 具体来说： 普通类继承抽象类，必须实现抽象类中的抽象方法，但抽象类继承抽象类，则无需强制，可以有选择性的实现抽象方法。 接口继承接口，会继承接口中的抽象方法，但无需强制实现。 2.implements，实现只发生在接口和类之间，而且必须是类实现接口。 普通类实现接口，需要实现抽象方法。但抽象类实现接口，则无需实现。 3.接口和类没有直接的继承和实现关系
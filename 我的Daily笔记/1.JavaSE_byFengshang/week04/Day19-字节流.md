## 异常的处理

### `throw`关键字

> `throws`后面跟多个，但是`throw`不行

#### **语法**

```Java
throw 异常对象
```

#### **解释**

1. 该语法必须在一个方法中使用，不能直接写在类体中

2. *一定的，确定的抛出一个异常对象*🟡 

3. 语法中的异常对象，一般使用"`new`"关键字创建相应的异常对象。异常类的构造方法普遍都可以传入一个字符串，表示对异常产生的说明。异常类型普遍还有一个无参构造器。

#### **注意事项**

1. （重点⭐最重要）

   在方法体中用`throw`关键字明确抛出一个异常，那么代码执行到该行就不会继续执行了，所以该行`throw`语句相当于方法体当中的`return`，可以替代`return`的作用，后面就不能再写代码了。

2. `throw`后面可以抛出一个异常，此时不要`try...catch`它，而是让它向上层抛出，抛给方法调用者
   1. 可以抛出运行时异常，不需要方法使用`throws`关键字，运行时异常会自己向上抛出，方法调用者可以不显示处理运行时异常
   2. 可以抛出编译时异常，此时需要方法配合使用`throws`关键字明确向上层抛出编译时异常，方法调用者需要显示处理编译时异常。

### `throw`关键字在方法中的经典使用（非常常用，重点⭐⭐）

抛异常代替`return`是常见的手段。

### 异常的处理体系

#### `finally`

是一个关键字，使用和`try..catch`结构密不可分。

*`finally`代码块不论`try..catch`如何执行，最终一定会执行。*只有退出虚拟机才可以不执行。

#### **语法**

```Java
try{
} catch(){
} finally{
}

// 中间的catch代码块可灵活增减。
try{
}catch(){
}catch(){
}finally{
}

```

#### `finally`代码块的用途

特点：正常来说一定会执行。

用途：如果一行或一段代码无论`try...catch`如何执行，它都要执行，这时就可以使用`finally`代码块。

> 比如对象占用额外系统资源的释放。调用`.close()`
>
> 比如在做*Java IO操作*、*网络操作*以及*数据库操作*等，需要占用系统额外资源的操作时，一旦发生异常程序终止，就会导致对象所占用额外资源无法正常释放，这很明显是不合理的。这时就需要请出`finally`代码块来实现安全的释放资源了。

#### 小细节

`try...catch...finally`结构的变形：`try...finally`

假如有一段代码必须执行，需要用到`finally`代码块，但是又不希望`catch`处理异常，而是希望抛出异常。那么就可以使用`try...finally`

> 问题：关键字`final`，`finally`和`finalize`分别的作用？
>
> 1. `final`关键字可以修饰类、变量、成员方法。
>   1. 修饰类，表示该类不能被继承
>    2. 修饰变量，表示它成为一个常量
>   3. 修饰成员方法，表示无法被重写的方法
> 2. `finally`代码块，和`try...catch`一起使用，具有必然执行的特点，在异常处理体系当中，一般用于资源释放。
> 3. `finalize`方法，`Object()`类中的成员方法，用于做对象销毁的善后工作，释放额外的系统资源。**由于GC垃圾回收机制的自动回收不确定性**，该方法实际上是无效的。



### 自定义异常（了解）

1. 为什么一定要自定义异常，用源码中的异常不好吗？

   - 更好定位。因为自定义异常所以更清楚在哪里产生异常，而不是JDK源码中。

   - 而且可以针对性地做出专属处理，这也是源码中地异常所达不到的


2. 如何自定义异常？
   1. 自定义运行时异常，自定义一个类，让它直接继承`RuntimeException`
   2. 自定义编译时异常，自定义一个类，让它直接继承`Exception`
   3. 要声明两个构造器：

​			a.`()`无参构造

​			b.`(String)`单参构造

```Java
public class Demo {
    public static void main(String[] args) {
        test();
        try {
            test2();
        } catch (MyCheckedException e) {
            e.printStackTrace();
        }
    }

    public static void test() {
        throw new MyRuntimeException("我自己定义的运行时异常,它被抛出了!");
    }

    public static void test2() throws MyCheckedException {
        throw new MyCheckedException("我自己定义的编译时异常,它被抛出了!");
    }
}

class MyRuntimeException extends RuntimeException {
    public MyRuntimeException() {
    }

    public MyRuntimeException(String message) {
        super(message);
    }
}

class MyCheckedException extends Exception {
    public MyCheckedException() {
    }

    public MyCheckedException(String message) {
        super(message);
    }
}
```

-----



## `File`类

`java.io.Flie`

IO过程受限于外存，特点是和CPU相比速度较慢。

(重点)`File`类是文件和目录（文件夹）路径名的抽象表达形式。“这个路径到底合不合法”，“这个路径下是否存在相应文件”等问题`File`类不关心。**`File`类对象就是存储了一个文件路径字符串的对象。**

在创建File类对象时，不管如何创建，都不会产生任何异常，任何问题，只有在用这个File对象操作文件时，才可能出现问题。

（重点，重中之重，写框架时常用此概念）(**服务器文件等配置文件的路径名该怎么写**？)

⭐路径名的概念：**用于表示文件位置的一个字符串。**

文件的路径名的作用就相当于“全限定类名”。

>路径分隔符
>
>Windows：在java中一个反斜杠要用转义字符表示，也就是写成两个`"\\"`
>
>类Unix操作系统：`"/"`
>
>开发过程中使用正斜杠`"/"`，因为Windows可以识别

为了简洁化书写，将绝对路径改成相对路径。

在实际开发中，如果确定文件的路径，且文件路径不会轻易改变，建议优先使用绝对路径（场景很少，因为在服务器端，绝对路径的权限不开放给普通员工）

在IDEA中使用相对路径写名，最需要解决的一个问题是：相对路径是相对于谁？

```java
System.getProperty("user.dir")
```

1. 默认情况下，相对于当前project的根目录，一般而言不要改动（更改的方式：Tempates->appliction->working directory）

2. 注意Junit的相对路径是相对于当前module根目录，而不是project

相对路径更灵活的使用：在路径名中，用`".."`表示上级目录

### `File`类的构造器

```java
// 创建一个File对象，输入的字符串是路径名，可以用绝对路径也可以使用相对路径
File (String pathname)


// 和第一种方式类似，只不过把一个路径名劈成了两半
File (String parent, Sting child)

// 和第二种方式一样，只不过，其中一个路径用File对象进行表示
File (File parent, String child)
```

本质上就一个构造器

```java
File（String path）;
```

成员方法`exists()`返回`true`表示文件存在，如果文件不存在或者路径名不合法就会返回`false`

### `File`类的方法调用

看文档

细节：文件和文件夹不能通过后缀名有无判断

`File`类API的练习

```java
//两个常量
File.seperator
//三个创建功能
    //只负责创建文件，路径名如果不存在，会报错而不是帮你创建
public boolean creatNewFile()
    //开发中，普遍先判断再使用
    if(!f.exists()){
        f.createNewFile();
    }
	//只创建目录
public boolean mkdirs()
    if(!f.exists()){
        f.mkdirs();
    }
//删除文件
public boolean delete()
	//删除失败不会报错，只会返回false
	//如果删除的是一个空目录才会删除成功;如果想要	删除一个非空目录，需要自己写遍历递归
//移动且重命名文件
public boolean renameTo(File dest)
//判断功能
    //要么是文件要么是文件夹
public boolean isFile()
//获取功能
	//获取路径
    //一定返回绝对路径
    public String getAbsolutePath()
    //怎样创建的返回怎样的路径
    public String getPath()
    //获取File对象表示的文件或者目录的名字
    public String getName()
	//获取文件大小，单位是字节
    public long length()
	//获取文件最后修改时间的一个时间戳
    public long lastModified()
```

### `File`类的成员方法

带有过滤器的`lisFiles(FileFilter filter)`

`FileFilter` 对象表示过滤器`filter.accept()`;

> ⭐方法回调：通过接口的对象，把规则传进来
>

## IO流

### IO的相关概念

`File`类无法操作文件内容。

1. 什么是I/O

   内存和外存需要频繁交互，交互的过程叫做IO。站在内存的角度，I表示输入即数据从外存read进内存。O表示输出即数据从内存write进外存。

2. 什么是IO流

   IO流可以看成是操作系统的API，操作系统以“IO流”的形式对外开放IO功能。IO流从方向上进行分类，分为两大类：输出流和输入流。只要创建了输入流输出流对象，就意味着输入输出的通道打通了。

3. **IO流的分类**（重点）

   按照数据流的方向不同分两大类：

   - 输出流，将数据从内存写到(write)外存中，是一个输出的过程，需要使用输出流

   *      输入流，将数据从外层读到(read)内存中，是一个输入的过程，需要使用输入流

   按照处理数据逻辑单位的不同将IO流分为两大类：

   - 字节流
   - 字符流

按照两个类别，排列组合得到4个JavaIO的四个基类（抽象父类）：

1. 字节输入：`java.io.InputSream`

2. 字节输出：`java.io.OutputStream`

3. 字符输入：`java.io.Reader`

4. 字符输出：`java.io.Writer`

四个抽象父类都只是抽象类，是不能直接使用完成IO功能，需要具体的实现类来完成功能。

### 字节流

固定一次操作处理8位，**计算机存储的最小单位是bit，计算机寻址计算的最小单位是byte**

> 既然字节流是万能的，为什么需要字符流？
>
> 字符流Java IO处理字符数据（也就是**文本文件**），这种特殊情况的补充，在处理字符数据时，字符流更好用，更简单。
>
> 但字节流肯定也可以处理文本文件，只是不方便。

#### 字节输出流

```java
close()
write(byte[] b)
write(byte[] b,int off,int len)
write(int b)
```

常用的实现类：`java.io.FileOutputStream`

它是一个和文件操作相关的字节输出流，可以向文件中写(write)数据。

> 使用API的步骤
>
> 1. 创建对象
>
> 2. 调用方法
>
> 3. ⭐用完IO后要及时释放资源

```java
FileOutputStream(String fileName)
FileOutputStream(String fileName,boolean append)    
```

##### (⭐**重点区别3个方法**⭐⭐)

1. `void write(int b)` 

把该方法当成写byte数据类型的编码值字符写到文件中

但是这个方法很少用，如果要用，也是用来写英文字符

2. `void write(byte[] b)` 

   > (⭐)String API 
   >
   > `String`类的成员方法：`getBytes()` 无参方法 ，该方法可以获取此字符串的字节数据，也就是字符串的字节编码

```java
out.write("Hello".getBytes());
```

3. `void write(byte[] b,int off,int len)` 

**注意事项**

1. 创建`FileOutputStream`对象时，发生了什么？📣

    创建该对象之前，JVM会向操作系统询问查看文件是否存在。

   1. 如果文件不存在，那么就会创建一个空的指定文件。

   2. 如果路径名当中，有不存在的文件夹没有创建，那么不会创建此文件夹，而是抛出异常`FileNotFoundException`

   3. 如果文件存在（⭐）：**实际上仍然会创建一个新的，空的文件来覆盖原文件。**此时写数据就是从空白数据开始写。

   4. 此时有一个非常重要的问题即**如何向文件追加数据呢？**利用另一个构造器：将追加布尔值设置为`true`

      ```java
      FileOutputStream(String name,boolean append)
      ```

2. 如何向文件中，写一个**换行 **📣

   使用转义字符：（不同操作系统换行符不同）Windows：`\r\n`，类Unix：`\n`

   如果跨平台使用代码，为避免错误，应使用：

   ```java
   String System.linSeparator()
   ```

##### **输出流处理异常**

在JavaIO过程中，两种`try...catch`处理异常，并且安全释放资源的方式

要求：

​	1. 可以直接处理异常，那么就`try...catch...finally`格式

​	2. 不可以直接处理异常，需要抛出异常，那么就用`try...finally`格式

**总之一定要用`finally`代码块安全释放资源。**

格式一：`try...catch...finally` 注意`.close()`本身也是有异常的。

格式二：基于`AutoCloseable`接口的自动资源释放，`try- with-resources`

JavaIO中的所有流资源都可以采取这种方式来进行释放资源。

```java
try(需要释放资源的类对象，该类必须实现AutoCloseable){

//可能出现异常的代码

}catch(){

}
```

解释：

1. `try`中的代码块执行完，自动调用"`try()`"当中流对象的`close()`方法释放资源，无论`try`代码如何执行

2. "`try(`)"这个小括号当中，在Java8当中，必须创建对象的语句，不能写一个引用。创建实现`AutoCloseable`类的对象的语句，必须写在小括号里

注意：不管异常是抛还是catch，重要的是执行`close()`。实际开发中一定要把释放资源的代码写进`finally`代码块。

#### 字节输入流

`java.io.FileInputStream`文件字节输入流

使用文件字节输入流，就可以实现将数据从外存中的文件中读取到Java程序中（内存）

> 步骤
>
> 1. 创建对象
>
> 2. 调用read方法读数据
>
> 3. 关闭资源

##### （⭐⭐重点⭐⭐）

`read`方法有返回值，3个方法都是返回`int`，但是`int`的含义不同

1. （了解）无参方法就是读取文件中*下一个字节*的数据，返回这个字节数据的*字节值*

   ```java
   int read()
   ```

   1. 字节值：（不管什么数据，都会强制转换成`byte`，只会读一位数据，但是注意字节值没有负数，所以返回值取值范围是$[0,255]$）

   2. **如果读到末尾就返回-1**

      **重点**⭐在使用输入流读取文件数据时，读取的过程中，存在一个看不见的文件指针来指示读取的下一个字节数据，直到读完整个文件，文件指针就会到默认，再次`read`就会返回-1。

2. 将数据从文件中读取该byte数组长度数据出来，并且**将数据存储在b数组中**。然后该方法返回此次读到的字节数量。

```java
int read(byte[] b)
```

> **如何把`byte`数组转换成`String`?**
>
> 用`String`带`byte`数组参数的构造器
>
> ```java
> String str = new String(byte[] b)
> ```
>

3. 控制读取的数据长度

```java
int read(byte[] b, int off, int len )
```

从输入流中读取len个字节数据，然后从下标off开始存入b数组。返回值是实际读取的字节数量。

**注意事项**

1. 创建对象时如果文件路径指向的文件不存在，会直接抛出异常`FileNotFoundException`

2. (⭐重点)

> String另一个带byte数组的构造器
>
> ```java
> int readCount = in.read(bytes);
> String(byte[] b,int off, readCount)
> ```

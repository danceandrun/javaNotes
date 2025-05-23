# 数组的操作

## 求最值

//如果现实中开发，数据量比较大，应该先排序然后求最值。

## 数组的逆序/逆置(reverse)

数组的长度不可变意味着什么？

1. 一旦某个数组创建完场，除非销毁它，否则它的长度永远不变；

2. 数组中元素的取值仍然可以任意修改

3. （细节）数组对象的引用并不是不可变的，引用仍然可以随意指向一个新的数组对象

```Java
int[] arr = {1,2,3,4};
arr = new int[3];
```

==引用就是功能弱化的安全的指针。==

在内存中交换两个元素

```Java
//遍历数组，然后在内存中交换两个元素
for(int i = 0;i<arr.length/2; i++){
    int temp = arr[i];
    arr[i] = arr[(arr.length)-i-1];
    arr[(arr.length)-i-1];
}
```

## CRUD

## 数据库是持久化存储，存储在外存当中

create

retrieve

update

delete

一个Java程序要想操作这些数据，首先要把数据读到内存中，那么内存中这些数据如何存储呢？

用容器，基础的容器就是数组，高级的容器是集合。

```Java
/*需求：
	1.建立1个String数组
	2.要求向人名数组中新增一个人名，保证人名不能重复
	3.删除人名数组中的目标人名
	4.给定一个目标人名以及修改后的人名，在人名数组中修改它
	5.查找目标人名，找到了返回目标人名在数组中的下标
*/	
```

## String类的equals方法

```Java
字符串常量/字符串变量.equals(字符串常量/字符串变量)
```

equals方法的特点：

​	对称性:A.equals(B)和B.equals(A)一样

避免空指针异常：

如果比较的字符串两者中，有一者是字符串常量，则必须把它放在左边。

## 数组元素的拷贝

```Java
/*
	1.明确新数组的长度，初始化这个新数组
	2.遍历原先的数组
*/
```

魔法值magic number ：

直接写在代码中，没有编辑含义的常量或变量。时间久了，导致代码可读性下降。

## 数组元素的删除

遍历老数组，但是跳过目标元素的赋值就相当于删除它。

```Java
//计数
int count = 0;
count ++;
```

# 可变参数

variable parameter

在方法调用时，如果希望该方法的调用允许传入不确定个数的实际参数，此时需要在定义方法时，在形参的位置使用可变参数。

**可变参数实际上是形参的一种特殊形式**

//使用场景:

//需求：求不确定个数的int数值之和。

//需求：希望在调用方法时可以自由地传入参数

```Java
[修饰符列表] 返回值类型 方法名（形式参数列表，数据类型... 变量名）{
    //方法体
}
```

可变参数写在方法的形参当中，就是一个数组

在方法体当中，就可以直接把可变参数当成一个数组来处理

可变参数做形参vs直接用数组做形参

可变参数实际上仍然是数组

但却可以在调用方法时传入不确定个数的对应实参

# ==方法的传值问题==

什么是方法的传值问题?

方法得到的变量的拷贝，而不是变量的地址。

在程序设计中的两种传值的方式:

值传递(call by value)

引用传递(call by reference)

###### 注意:不要认为Java既有值传递也有引用传递,只有值传递.

> Java的方法究竟可以对实参变量做什么操作?

> **(重点)==Java方法可以修改对象的状态,==因为方法得到的是引用的拷贝,<u>拷贝引用仍然指向原先引用指向的对象</u>.**

# 递归

recursion

如何来定义一个递归:

1.对于任何递归而言,都存在自身调用自身的语句,称为"递归体"

2.为了避免栈溢出,需要给递归一个终止的条件,称为"递归的出口".

3.有递归体,有递归的出口,不一定正常运行.

程序最终报错终止:java.lang.StackOverflowError(栈溢出错误)

```Java
内存相关概念:

溢出(overflow):当内存不够时仍继续申请内存,开辟空间.

内存泄漏:指的是对象本身已成为垃圾,但仍占用内存,迟迟不被回收的情况.


```

Error:是严重错误,不是普通异常,一般都是指JVM内部错误,比如JVM的资源耗尽.

递归的思想,以及递归的优缺点:

递归的思想:就是"分解的思想".

循环的思想是"重复".

递归过程中会耗费大量资源(栈内存资源和可能用到对象时的堆内存资源),但时间复杂度和空间复杂度仍不优越.

写递归,先写递归的出口,再写递归体.

# 面向对象

分三个部分的知识点

1.面向对象的语法基础(2天左右,知识杂)

2.面向对象的三大特征:封装,==**继承**==与多态(继承最核心,1天半时间)

3.面向对象的设计(抽象类,接口,内部类)

把面向对象学清楚!!!后面课程的基础:EE,框架,微服务

概念多,细节多,语法多,很杂.

## 对象与类

回答什么是对象,什么是类

### 对象的概念

**对象就是程序世界的个体**,编写程序就是以对象为核心编写.

3个特点:

1,对象独立存在,具有属性和行为.

​	a.属性:个体的状态信息(**数据**)

​	b.行为:个体能够做什么(**操作**)

2,对象的状态(属性)可以改变.

3,对象有类别之分,不同类别的对象是不同的.

### 类的概念

创建对象需要模板,类就是创建对象的模板.

定义类是为了创建对象的.

类和对象的关系:

理论上一个类的对象是无限的,实际受内存的限制

对象和对象的关系:

1,不同类创建的对象,无可比性

2,相同类创建的对象,有相似性,但取值可能完全不同

### 如何定义一个类?(语法)

```Java
[类修饰符列表] class 类名{
    //类体
}
```

1.一个类可用的修饰符

a.public class 特点是类名必须和文件名保持一致,而且一个Java文件只有一个

b.非public class 特点是类名可以随意,而且一个Java文件中可以定义多个

一个Java文件中的所有类是同包的关系,同包下没有同名类.

2.类名:大驼峰,见名知意.

注意事项:

"嵌套":方法定义时不可以嵌套,但类的定义可以嵌套.这就是=="内部类"==.但是未学习该语法前,不要定义内部类.

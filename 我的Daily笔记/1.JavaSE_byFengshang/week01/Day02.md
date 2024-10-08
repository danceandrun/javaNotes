## 字符串

#### 1，求字符串长度：

语法：

字符串字面值常量/一个String类型变量.length()

#### 2，比较两个String字符串

有两种方式：

a.直接"=="

b.字符串字面值常量/一个String类型.equals

equals比较内容，而==不是比较内容。<u>如果要比较两个字符串内容是否一致，必须使用equals</u>

## 浮点数

#### 浮点数的优点可以表示很大很小的数，缺点是精度问题，float 7-8位而double 16-17位

##### 十进制小数0.1转换为二进制是无限循环小数。浮点数做近似计算，占用内存少

##### 面试题==：公司货币运算用什么类型呢？==答：用double，因为double更精确。==就凉了。应该是一个类，BigDecimal.当使用double float时意味着不再关注精度。==

## 自动类型转换

#### 整数的字面值常量当int,要是long a=100;其实有一个自动类型转换即不需要手动写代码进行类型转换，小数的字面值常量当double，要是float b = 0.1;会报错，因为0.1当作了double,赋值给float，取值范围变小，需要强制类型转换。

##### 注意：由于char存储的是编码值，编码值范围是[0,65535],而byte,short有负数部分，所以不会转char

##### 基本数据类型的自动类型转换不是绝对安全的，原因在于float有效数字只有7-8位，而int最大值有21亿左右可以超过8位数字，所以int到float可能失真，同理long到float,double可能失真，而double的有效位数16-17位多于int最大的值具有的位数所以int到double不失真。

#### 表达式的类型提升

byte,char,short三个之间运算最后是int类型

byte+byte也是int ！！！

```
public class Demo{
	public static void main(String[] args){
	byte a = 10;
	byte b = 20;
	}
}
```

#### 整数**<u>常量</u>**的特殊性：编译器的特殊设计

编译器可以识别在表示范围内的整数，比如[-128,127]赋值给byte，[0,65535]赋值给char

```
// int --> byte
byte a = 100;
// int --> char
char b = 97;
```

注意：1.如果有变量参与运算，要遵循类型转换；2.小数常量没有特殊性。

```
float a = 0.123f
```



## 写表达式快捷键

#### 写表达式尽量从右边开始写

##### 有快捷键：1.".var"回车 2.CTRL+alt+v

## 运算符

#### 扩展的运算符包含了强制的类型转换

```
byte a=10;
a +=10; // 10被默认为是int型，byte与int运算会自动类型转换成int型
```

最后a成为了int型；

#### 运算符%和/

1.注意运算符%不是数学中的百分比，而是取余运算，经典题目 100*10%-7 结果不是3而是-6 (注：在Java中，对负数取余，结果是负数)

2./：整型除以整型结果仍是整型，小数点要舍掉，3/2结果是1而非1.5

###### 赋值运算符的赋值表达式运算一般是有结果的

###### 逻辑运算符要用<u>短路运算符</u>:&& ||

###### 三目运算符的表达式是有结果的，要接收值 ctrl+alt+v

## Scanner

#### Scanner当中的键盘录入方法没比如nextLine,nextInt等方法的调用会持续性的等待用户从键盘录入数据，如果不进行键盘录入就会持续等待，这种方法叫做阻塞方法（可应用于网络编程，多线程）

三步走：

1，导包

2，创建对象

3，调方法

```
import java.util.Scanner;
Scanner sc = new Scanner(System.in);
System.out.println("请输入一个int数据：");
int x = sc.nextInt();
```



##### 混合使用多种方法时，会导致无法录入，只使用一种nextLine，然后将String转换成int等类型

## 循环

##### for循环的快捷键：fori+enter

##### 循环的控制变量，不要乱写，应该选择i,j,k

##### 用return减少if的层级

## 方法

冗余就是可以被复用

方法的本质就是代码复用

方法的语法

```
[修饰符列表] 返回值类型 方法名 (形式参数列表){
  // 方法体
}
```

在Java当中，不论什么方法，不调用一律不可能执行。main时入口方法。所以要直接或间接在main方法中调用。

在同一个类当中，在main方法当中，如果想要调用同类中的"static"修饰的方法，那么调用方法时：

方法名（实参列表）；

##### ==操作方法调用就是操作方法的返回值。返回值能够进行的操作那么方法调用也能够进行。==

#### 方法的重载
[TOC]

# JS

## JS的概念

> JS，全称JavaScript。和Java没关系
>
> - JavaScript 是一种轻量级的编程语言
>   - 轻量级: js
>   - 重量级: Java, C++, C#
>   - 对量级的理解：语言支持的特性多少
> - JavaScript 是可插入 HTML 页面的编程代码
> - JavaScript是一种<font color=red>**弱类型**</font>语言
>   - 编程语言的值的变量类型
>   - 比如Java就是强类型，所有变量定义都需要明确的类型定义
>   - JS定义变量时，不需要明确类型定义
> - 它的解释器被称为JavaScript引擎，为浏览器的一部分
> - <font color=red>**主要用来向HTML页面添加交互行为**</font>
> - 跨平台特性，在绝大多数浏览器的支持下。 JS跨平台特性是浏览器支持的，Java的跨平台是JVM支持的。

<span style=color:red;background:yellow>**学习JS目的：**</span>

> 在HTML页面中，使用JS来完成交互行为

<span style=color:red;background:yellow>**HTML，CSS，JS的关系：**</span>

> - HTML主要负责页面的搭建
>   - 比如页面上文字的展示，图片，输入框等元素
> - CSS主要负责页面的美化
>   - 比如文字的大小调整，图片大小，各种样式
> - JS主要负责页面的交互
>   - 比如点击一个按钮后弹框等

## 怎么在HTML中引入js

### 方式一：内部引入

> - 在html页面中, 用一个script标签包裹,直接写js代码
> - 可以在head标签内部，也可以在body内部，也可以在body后

<span style=color:red;background:yellow>**示例：**</span>

```java
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

    <script>
      alert(123)
    </script>
</body>
</html>
```

### 方式二：外部引入

> 创建js文件，在html页面上引入js文件
>
> - 在head标签内部，添加script标签

<span style=color:red;background:yellow>**示例：**</span>

```java
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <script src="./01_js.js"></script>
</head>
<body>

</body>
</html>
```

## js的变量

### 变量声明

> JavaScript在声明时统一使用无类型（untyped）的"var"关键字
>
> - 举例：`var pi=3.14`
> - var来声明一个变量,这是一个<font color=red>**固定的写法**</font>，是js的语法
> - JavaScript并没有避开数据类型，它的数据类型是根据所赋值的类型来确定的
> - JavaScript 对大小写敏感

命名规范：

> 只能由英语字母、数字、下划线、美元符号$构成，且不能以数字开头，并且不能是JavaScript保留字

与Java类似，直接写Java中的变量名即可

### 变量类型

> - String
> - Number
> - Boolean
> - 数组
>   - `var cars=["Audi","BMW","Volvo"];`
> - 对象
>   - `var person={firstname:"Bill", lastname:"Gates", id:5566};`

## js中的方法

> js方法的定义:   `function 方法名(){// 方法体}`

<span style=color:red;background:yellow>**示例：**</span>

```java
function f(){
  console.log(123)
}

function f1(para1){
    console.log(para1);
}

f()// 调用上述方法
```

## 运算符

#### 算术运算符

> ```
> +,-,*,/,%,++,--
> =, +=, -=, *=, /=, %=
> ```
>
> - 与Java差异点：
>
>   - 对待减法，如果是字符串-数字，会返回NaN。但是如果字符串是 123这类的数字
>
>   - ```javascript
>     var str = "str"
>     var num = 10;
>     console.log(str + num)
>     console.log(str - num) //NaN: not a number
>     ```
>
>   - ```javascript
>     var num1 = "10"
>     var num2 = 5
>     console.log(num1 - num2) // 5
>     console.log(num1 * num2) // 50
>     console.log(num1 / num2) // 2
>     ```



#### 逻辑运算符

> ```
>  > , <, >=, <=, ? : 三元
> && , ||, !
> ==, ===, !=, !==
> 
> var a = "10"
> var b = 10
> 
> a == b   -->  true 
> a === b  --> false
> ```
>
> `==   : 只判断值是否相等`
>
> `===  : 不仅仅判断值,  还要判断类型`



> `!=   : 只判断值是否不相等`
>
> `!==  :  不仅仅判断值,  还要判断类型`

## 逻辑分支语句

> - `if`
>   - 在js中很多东西都可以充当if-else的条件
>   - 但是有些东西<span style=color:red;background:yellow>**默认表现为假: 0, 空字符串, null, NaN, false, undefined**</span>

```java
// switch
// while

break 语句用于跳出循环。
continue 用于跳过循环中的一个迭代。
    
```



> - `for`
>   - 一般我们使用普通的fori循环用来遍历数组,  一般我们使用foreach循环遍历对象

```JAVA
var obj = {name: "zs", age: 18, address: "hubei"};

for (var objKey in obj) {
  console.log(objKey + "---" + obj[objKey]);
}

var array = [1, 2, "hello", "java", true];
for (let i = 0; i < array.length; i++) {
  console.log(array[i])
}
```

## 核心对象/类型

### Number

> - `toString()` 以字符串返回数值
>
> - `toFixed()` 返回字符串值，它包含了指定位数小数的数字(四舍五入)
> - `toPrecision()` 返回字符串值，它包含了指定长度的数字
> - `parseInt()` 允许空格。只返回首个数字
>   - "1000"  返回的是1000
>   - "100str" 返回的是100
>   - "str1000" 返回的是`NaN`
>   - "    100str" 返回的是100



```java
// toString() 以字符串返回数值
var ii = 123
console.log(typeof  ii)
console.log(typeof ii.toString())
  
// toFixed() 返回字符串值，它包含了指定位数小数的数字(四舍五入)：
var x = 9.6544;
x.toFixed(2);           // 返回 9.65

// toPrecision() 返回字符串值，它包含了指定长度的数字(四舍五入)：
var x = 9.656;
x.toPrecision();        // 返回 9.656
x.toPrecision(2);       // 返回 9.7
// parseInt() 允许空格。只返回首个数字：
parseInt("10");         // 返回 10
parseFloat()  允许空格。只返回首个数字：
parseFloat("10.33"); // 返回 10.33
```



### String

> - `length` 属性返回字符串的长度
>
> - `indexOf()` 返回字符串中指定文本首次出现的索引（位置）
>
>   - 不存在返回-1
>
>   - ```
>     // 头一个China返回的下标
>     str.indexOf("China");
>         
>     // 从28开始，找往后的China的下标
>     str.indexOf("China", 28);
>     ```
>
> - `slice()` 提取字符串的某个部分并在新字符串中返回被提取的部分
>
> - `split()` 将字符串转换为数组

```java
length 属性返回字符串的长度
var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var sln = txt.length;

indexOf()方法返回字符串中指定文本首次出现的索引（位置）：
var str = "The full name of China is the People's Republic of China.";
var pos = str.indexOf("China");
var pos = str.indexOf("China", 28);
indexOf() 不存在返回 -1。

slice() 提取字符串的某个部分,并以新字符串中返回被提取的部分。
var str = "Apple, Banana, Mango";
var res = str.slice(7,13);//裁剪字符串中位置 7 到位置 13 的片段。包左不包右

split() 将字符串转换为数组
var txt = "a,b,c,d,e";   // 字符串
txt.split(",");          // 用逗号分隔
txt.split(" ");          // 用空格分隔
txt.split("|");          // 用竖线分隔
如果分隔符是 ""，被返回的数组将是间隔单个字符的数组：
```

### Array

> - toString() 返回数组转换的数组值（逗号分隔）的字符串。
> - pop() 方法从数组中删除最后一个元素,返回删除的元素
> - push() 方法（在数组结尾处）向数组添加一个新的元素,返回数组长度
> - splice() 
>   - 删除指定位置开始的指定个元素。`fruits.splice(2, 2);`
>   - 方法可用于向数组添加新项, 返回([])。`fruits.splice(2, 0, "Lemon", "Kiwi");`
> - sort() 方法以字母顺序对数组进行排序,返回值和原数组是经过排序的数组
> - reverse() 方法反转数组中的元素。返回值和原数组都变为经过反转数组

```java
toString() 返回数组转换的数组值（逗号分隔）的字符串。
var fruits = ["Banana", "Orange", "Apple", "Mango"];
console.log(fruits.toString()); //Banana,Orange,Apple,Mango

pop() 方法从数组中删除最后一个元素,返回删除的元素
fruits.pop();              // 从 fruits 删除最后一个元素（"Mango"）
var x = fruits.pop();      // x 的值是 "Mango"

push() 方法（在数组结尾处）向数组添加一个新的元素,返回数组长度
fruits.push("Kiwi");       //  向 fruits 添加一个新元素

splice() 方法可用于向数组添加新项, 返回([])
  
fruits.splice(2, 0, "Lemon", "Kiwi");
// 第一个参数:添加新元素的起始位置。第二个参数:定义应删除多少元素。
// 其余参数（“Lemon”，“Kiwi”）定义要添加的新元素。

sort() 方法以字母顺序对数组进行排序,返回值和原数组是经过排序的数组
fruits.sort();            // 对 fruits 中的元素进行排序

reverse() 方法反转数组中的元素。返回值和原数组都变为经过反转数组
fruits. reverse();            // 对 fruits 中的元素进行排序

```

### Math

```java
Math.ceil(x)返回大于等于x的最小整数
Math.floor(x)返回小于等于x的最大整数
Math.random() 返回 0 ~ 1 之间的随机数 
Math.round(x) 把一个数四舍五入为最接近的整数
Math.max(x,y,z,...,n)	返回最高值
Math.min(x,y,z,...,n)	返回最低值
```

# DOM

## DOM的加载顺序

> - DOM:文档对象模型（Document Object Model，简称DOM）
>
> - DOM的加载顺序: 指的就是浏览器获得了一份html代码之后, 从获得代码到显示的过程

> - 解析HTML结构(<span style=color:red;background:yellow>**从上向下的过程**</span>)， 一边解析, 一边构建dom树结点/节点
>   - 加载外部脚本和样式表文件，异步加载外部的css和js文件
>   - 解析并执行脚本代码
> - 构造HTML DOM模型完成。         DOM构建完毕  -->  立即显示页面
> - 加载图片等外部文件
> - 页面加载完毕



浏览器，解析完网页之后，在内存上生成了一棵树（DOM）对今后修改网页有什么好处？

就是浏览器会生成一份内存上的映射。



一份HTML代码，最终在chrome上的内存映射。 是一个树状结构。

我们今后需要修改HTML页面，就只用操作这个内存映射就可以了。

也就是学习对DOM树的增删改查。

## 在DOM树中获取结点

> - getElementById():  根据id获取一个结点
> - getElementsByName():  根据name属性, 获取所有对应name结点的集合
> - getElementsByTagName():  根据标签名, 获取所有对应标签结点的集合



> <span style=color:red;background:yellow>**注意：**</span>
>
> - `getElementById()` 返回的是一个节点
> - `getElementsByName()`,`getElementsByTagName()` 返回的是一个集合

## 添加结点

> - `appendChild`: 给某个结点添加一个孩子(孩子也应该是一个结点。<font color=red>**注意类型**</font> )
> - 比如要添加一个li类型的节点，需要使用以下方式: `document.createElement("li")`
> - 要添加文本类型的节点： `document.createTextNode("zs")`

```java
  <ul id="ul1">
    <li>zs</li>
    <li>ls</li>
    <li>wu</li>
    <li>zl</li>
  </ul>
  <input id="inputstr">
  <button onclick="addli()">添加</button>

  <script>

    function addli(){
      var inputNode = document.getElementById("inputstr")
      var inputStr = inputNode.value


      var ulNode = document.getElementById("ul1")

      // 创建一个文本结点
      var textNode = document.createTextNode(inputStr)

      // 创建一个li类型的结点对象
      // document.createElement创建一个指定类型的结点
      var liNode = document.createElement("li")

      liNode.appendChild(textNode)

      // appendChild 给某个结点添加孩子
      // 参数是一个孩子'结点'
      ulNode.appendChild(liNode)

      inputNode.value = ""
    }
  </script>
```

## 删除结点

> `removeChild`:  给某个结点删除其一个孩子(注意,参数是要删除的孩子 )
>
> 注意输入的参数，是一个children类型的



```java
 <ul id="ul1"><li>zs</li><li>ls</li><li>wu</li><li>zl</li></ul>
    
    下标: <input id="inputstr">
    <button onclick="deleteli()">删除</button>

    <script>

      function deleteli(){
        var index = document.getElementById("inputstr").value
        var ulNode = document.getElementById("ul1")

        // childNodes: 专门用来获得一个结点的所有孩子
        var childNodes = ulNode.childNodes;
        

        // removeChild: 给某个结点删除其一个孩子
        //  参数要删除的孩子
        ulNode.removeChild(childNodes[index])
      }
    </script>
```

## 修改结点

> - replaceChild: 给某个结点替换孩子结点
>
>   第一个参数:  新孩子；第二个参数:  旧孩子

```java
 <ul id="ul1"><li>zs</li><li>ls</li><li>wu</li><li>zl</li></ul>

    下标: <input id="inputtag">
    替换内容: <input id="inputstr">
    <button onclick="changeli()">替换</button>

    <script>

      function changeli(){
        var inputTag = document.getElementById("inputtag").value
        var inputStr = document.getElementById("inputstr").value

        var ulNode = document.getElementById("ul1")

        var childNodes = ulNode.childNodes;

        var changeNode = childNodes[inputTag]

        // console.log(changeNode)

        // replaceChild: 给某个结点替换孩子结点
        // 第一个参数:  新孩子
        // 第二个参数:  旧孩子
        changeNode.replaceChild( document.createTextNode(inputStr), changeNode.childNodes[0])

      }
```

## inner

> - `innerText`: 会按照text全部放入
>
> - `innerHTML`: 会按照html解析。比如一些标签等

```java
 divNode.innerText = "<b>hello world</b>"
// divNode.innerHTML =  "<b>hello world</b>"
```


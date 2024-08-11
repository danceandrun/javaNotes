[toc]

# Vue

## 一些问题

使用js编程的逻辑：需要对标签写一个id，然后用document的get方法传入该标签的id再进行一些操作。

> **前端是什么？**
>
> 写网页的技术，就是负责网站的前台部分的。

> **后端是什么？**
>
> 一直运行在服务器上的一些代码。负责接收请求，然后返回数据。
>
> 根据请求的啥数据，就返回什么数据

```
 *  下载文件接口：
 *      http://localhost:8080/file?name=1.txt  --> 返回1.txt
 *      http://localhost:8080/file?name=2.png  --> 返回2.png
 *
 * 登录接口：
 *    (登录成功的)http://localhost:8080/login?username=admin&password=admin
 *    (登录成功的)http://localhost:8080/login?username=root&password=root
```



> <span style=color:red;background:yellow>**后端是什么：**</span>
>
> - 背景：我们想完成一个注册的功能
>
> - 准备知识：电脑ip和端口,`192.168.8.100:8000`,请求地址(服务器内部路径)：`/user/register` 
>
> - 流程：
>
>   - 我们先准备好注册的参数，用户名，密码，姓名，年龄。。。。。。前端传来的
>     - 怎么传的？通过form表单
>   
>   - 去接口请求，带上参数
>   - 接口帮我们注册
>   - 告诉我们注册接口。成功，失败：用户名已存在？
>
>    <span style=color:red;background:yellow>后端需要注意的事情</span>：请求的参数（username, password,gender），处理的逻辑，返回的数据。
>   
>   现阶段，可以将它理解为方法。

http://192.168.8.100:8080/user/register?username=admin&password=admin&age=18

## Vue的概念

> Vue.js------ <span style=color:red;background:yellow>**渐进式框架**</span>。其实就是一个js库。与其他重量级框架不同的是，Vue 采用自底向上增量开发的设计。Vue 的核心库只关注视图层，并且非常容易学习(前端)，非常容易与其它库或已有项目整合。另一方面，Vue 完全有能力驱动采用单文件组件和Vue生态系统支持开发复杂单页应用。
>
> - 渐进式:从核心到完备的全家桶。
> - 增量:从少到多,从一页到多页,从简单到复杂
> - 单文件组件: 一个文件描述一个组件
> - 单页应用: 经过打包生成一个单页的html文件和一些js文件
>
> <span style=color:red;background:yellow>**js库。**</span>让我们不用操作dom，也可以修改页面上的数据。



vue2 。 vue3  。

有一些软件，不必要追求最新。  Java8  最新Java20。

企业追求 --》  稳定。

## 快速入门

### 准备工作

> 1. 创建一个html页面
>
> 2. 引入外部js文件
>
>    1. 相对路径引入。`<script src="./js/vue.js"></script>`
>    2. 外部路径引入。`<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>`
>
> 3. 创建一个div。id是app
>
>    1. ```HTML
>       <div id="app">{{ message }}</div>
>       ```
>
> 4. 写一个js块。新建一个Vue对象。
>
>    1. ```HTML
>       <script>
>           new Vue({
>               el: "#app",
>               data: {
>                   message: "hello vue"
>               }
>           })
>       </script>
>       ```



<font color=red>**完整代码：**</font>

```HTml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
</head>
<body>

<div id="root">{{ message }}</div>

<script>
    new Vue({
        el: "#root",
        data: {
            message: "hello vue"
        }
    })
</script>

</body>
</html>
```



### 解释

1.引入vue.js，因为我们要用vue的一些写法，所以需要一些框架代码的支持

2.一旦创建一个vue对象，vue会去检测el属性，el属性是#root 这个时候，vue会直接去dom树上，找一个id是root的块。然后将这个块摘下来，会按照vue框架进行解析。

> - 首先引入js文件
>   - 这个是引入Vue官方给我们写的一些方法，我们才能使用它的特性，与<span style=color:red;background:yellow>**引包**</span>类似
> - div上写得 `id=app`,<span style=color:red;background:yellow>**固定写法**</span>。与`new Vue({})`中el属性对应。 是仿照的id选择器的写法
>   - 仿照的id选择器的写法，其实类选择器(class)可以用，但是不建议用
>   - 不要在一个html里写多个Vue对象，后续写项目不在html文件里写
> - 当我们使用了 new Vue({el:"#app"})的写法，就代表了，vue块会替换掉这个div(id=app)，并进行重新渲染
>   - 重新按照vue的语法来进行解析
> - div内部，使用了 `{{message}}`。这是一个插值表达式，我们先这样理解，它可以使用变量，使用来自vue对象中定义的变量

    // new Vue: 创建了一个vue对象
    //          一个Vue对象一旦创建, 会立即检测自己的el属性
    //          根据自己的el属性, 到dom树上找到对应结点 (根据id)
    // 如果找到对应dom结点, 把这个结点要重新生成(按照vue语法重新生成)

## Vue的指令

### Vue的插值表达式

> - 可以用于插入文本
>
>   - ```html
>     <span>{{ msg }}</span>
>     // 会去 vue对象中去寻找这个变量。
>     // vue对象的data属性, 是vue对象专门用来自定义数据的地方
>     ```
>
> - JS表达式
>
>   - ```javascript
>     {{ number + 1 }}
>             
>     {{ ok ? 'YES' : 'NO' }}
>             
>     {{ message.split('').reverse().join('') }} 
>     ```
>
>   - <span style=color:red;background:yellow>**注意事项**</span>:这些表达式会在所属 Vue 实例的数据作用域下作为 JavaScript 被解析。有个限制就是，每个绑定都只能包含**单个表达式**，所以下面的例子都**不会**生效。
>
>     ```javascript
>         <!-- 这是语句，不是表达式 -->
>     {{ var a = 1 }}
>             
>     <!-- 流控制也不会生效，请使用三元表达式 -->
>      {{ if (ok) { return message } }}
>     ```

<font color=red>**示例：**</font>

```java
   <div id="root">
        <div>
            {{text}}
        </div>
<!--        {{}}: 按照html语法, 没有任何特殊含义, 就是普通字符串  -->
<!--         {{}}: 按照Vue语法, 叫"插值表达式"  -->
<!--         插值表达式, 里面是个表达式, 这个表达式用到的数据, 要去对应的vue对象中获取  -->
        {{num + num2}}
    </div>

    <script>
        new Vue({
            el: "#root",
            data: { // vue对象的data属性, 是vue对象专门用来自定义数据的地方
                text: "zs",
                num: 10,
                num2: 20
            }
        })

    </script>
```

插值表达式只能在标签内部使用。

### V指令

#### <font color=red>**v-bind: 单向绑定**</font>

> v-bind:<font color=red>**单向绑定**</font>,  可以把vue对象中的属性<font color=red>**, 绑定到一个对应html代码的属性**</font>上
>
> <span style=color:red;background:yellow>**注意使用场景。**</span> 

````java
 <div id="root">

<!--        v-bind:单向绑定,  可以把vue对象中的属性, 绑定到一个对应html代码的属性上-->
        {{text}}

        <img src="../dom/img/btn_reg.gif">

        <img v-bind:src="url">

        <div title="1111111">
          div
        </div>
        <div  v-bind:title="text">
          div2
        </div>

      </div>
      <script>

        new Vue({
          el: "#root",
          data: {
            text: "123",
            url: "../dom/img/btn_reg.gif"
          }
        })

      </script>
````

#### <font color=red>**v-model: 双向绑定, 只能用在表单元素的value**</font> 

> v-model: <font color=red>**双向绑定**</font>, 可以把一个vue对象中的数据, 通过v-model双向绑定, 关联到对应html代码的表单元素的value上,  让两者相互影响, 相互改变。
>
> input textarea select



```java
  <div id="root">

    <input v-model="text">
    <input v-model:value="message">
    <textarea  v-model="text"></textarea>
    <select v-model="text">
      <option value="0">学习</option>
      <option value="1">上课</option>
      <option value="2">吃饭</option>
      <option value="3">睡觉</option>
    </select>

  </div>
  <script>
    new Vue({
      el: "#root",
      data: {
        text: "1"
      }
    })
  </script>
```

#### v-on: 事件监听

> v-on: 监听一个事件, 把这个事件触发到vue对象中

vue使我们不用操作dom就可以操作数据



```java
 <div id="root">
        <div id="div1">
            {{text}}
        </div>
        <div id="div2">
          <button v-on:click="f">点名</button>
        </div>
    </div>
    <script>
        // V-on: 监听一个事件, 把这个事件触发到vue对象中
        new Vue({
            el: "#root",
            data: { // data是给vue对象专门定义数据的地方
                text: "点名1"
            },
            methods: { //  methods是给vue对象专门定义方法的地方
               f: function (){
                   this.text = "ls"
               }
            }
        })

    </script>
```

#### v-for: 循环

> v-for: 循环渲染/遍历一份数组
>
> - 注意1:  v-for用在那个html标签上, 他就会根据for遍历的数据量渲染出对应数量个html标签
>
>
> - 注意2:  语法上, 我们要求每一个被v-for所渲染出的标签, 都应该有一个唯一的不变的key属性, 用来表示这个被渲染出的标签
>
> - 注意3:  使用v-for遍历的时候 可以用in  也可以用 of
>
> ```vue
>     //       内容   下标
>      v-for="(aaaa, bbb) of list"
>      v-for="(aaaa, bbb) in list"
> ```

```java
<div id="root">

    <ul>
      <li v-for="(aaaa, bbb) of list" v-bind:key="bbb" v-on:click="deleteli(bbb)">
          {{aaaa}}---{{bbb}}
      </li>
    </ul>
    <input v-model="inputstr">
    <button v-on:click="addli">添加</button>

  </div>


  <script>
    new Vue({
      el: "#root",
      data: {
        list: ["zs", "ls", "wu", "zl"],
        inputstr: ''
      },
      methods: {
        addli: function (){
          this.list.push(this.inputstr)

          this.inputstr = ""
        },
          deleteli: function (index){
            this.list.splice(index, 1)
          }
      }
    })
  </script>

```

#### v-text, v-html 等价于innerText和innerHTML

```java
v-text
v-html
// 用来向某个标签内部插入内容
```

```java
 <div id="root">

    <div v-text="text">zs</div>
    <div v-html="text">zs</div>
    <hr>
    <div v-text="text2">zs</div>
    <div v-html="text2">zs</div>

  </div>

  <script>
    new Vue({
      el: "#root",
      data: {
          text: "ls",
          text2: "<b>1111</b>"
      }
    })
  </script>
```



#### v-show: 隐藏和显示

> v-show: 根据布尔值隐藏和显示某些内容 

```java
<div id="root">
    <div  v-show="1==2">
      zs
    </div>
    <hr>
    <div  v-show="bool1">
      zs
    </div>
    <button v-on:click="changebool">点击</button>
  </div>
  <script>

    new Vue({
      el: "#root",
      data: {
        bool1: false
      },
      methods: {
        changebool: function (){
          this.bool1 = !this.bool1
        }
      }
    })

  </script>
```

#### v-if: 分支语句

```java
v-if
v-else
v-else-if
    就按照if else的逻辑来理解就行。
```

```java
 <div id="root">
      <div v-if="1==2">
        v-if
      </div>
      <div v-else-if="bool1">
        v-else-if1
      </div>
      <div v-else-if="bool2">
        v-else-if2
      </div>
      <div v-else>
        v-else
      </div>
  </div>
  <script>

    new Vue({
      el: "#root",
      data: {
        bool1: false,
        bool2: false
      }
    })

  </script>
```

#### v-once: 只加载一次

```java
 <div id="root">

    <div v-once>
      {{msg}}
    </div>

    {{msg}}
    <input v-model="msg">

  </div>
  <script>
    new Vue({
      el: "#root",
      data: {
        msg: "123"
      }
    })

  </script>
```

#### v-pre: 阻止预编译

> `v-pre`: 阻止预编译。让它不作为vue被解析。
>
> >  <font color=red>**里面写得vue语法，会当做普通的html语法**</font>，比如一些插值表达式，v指令

```java
    <div id="root">

      <div v-pre>
        {{aaa}}
      </div>
      <div>
        {{msg}}
      </div>

    </div>
    <script>
      new Vue({
        el: "#root",
        data: {
          msg: "zs"
        }
      })
    </script>
```

#### v-cloak 延迟加载

> v-cloak: 延迟加载
>
> js的文件有时候很大。
>
> html拿到后是这样一个过程，从上往下，依次去进行解析，如果解析好了，但是js文件还是没有拿回来，所以会导致我们在页面上写的一些插值表达式无法获得值。最终会导致页面闪烁。
>
> vue提供了一个 `v-cloak`。我们可以设置一个单独的样式，比如不显示，当vue对象生成后，会将页面上所有的v-cloak去掉，这样就会让显示效果变为正常。

```java
 <style>
      [v-cloak]{
        /*display: none;*/
        font-size: 100px;
      }
    </style>
</head>
<body>

<!--V-cloak 延迟加载-->
    <div id="root">

        <div v-cloak>
          {{msg}}
        </div>

    </div>
    <script>
      function f(){
        new Vue({
          el: "#root",
          data: {
            msg: "zs"
          }
        })
      }

      setTimeout('f()', 5000)
    </script>
```

## 模板和组件

### 模板

> `template`:一个字符串模板作为 Vue 实例的标识使用。模板将会 替换 挂载的元素。挂载元素的内容都将被忽略.
>
> <span style=color:red;background:yellow>**template中，可以使用vue的所有语法，v指令，插值表达式**</span>

```java
  <div id="root"></div>

  <script>
    new Vue({
      el: "#root",
      data: {
        msg: "zs"
      },
      template: "<div class='xxxx'>1231231--<span v-on:click='f'>{{msg}}</span></div>",
      methods: {
          f: function (){
              alert(123)
          }
      }
    })
  </script>
```



### 组件



>`component`：组件 一个vue对象就是一个vue组件
>
>组件系统让我们可以用独立可复用的小组件来构建大型应用，几乎任意类型的应用的界面都可以抽象为一个组件树
>
><font color=red>**组件的目的是什么**</font>
>
>>  可以仿照div嵌套构建页面的思想, 让大vue组件/对象持有小vue对象, 小vue对象持有管控更小区域的vue对象这种思路, 构建一个大的页面 
>
><div align=center><img src='./img/components.png' width='1000px'></div> 

```java
   <div id="root"></div>

    <script>
      var son1 = {
        template: "<div class='son1'><div v-on:click='f'>{{msg}}</div></div>",
        data(){
          return{
            msg: "zs"
          }
        },
        methods: {
          f: function (){
            alert('son1')
          }
        }

      }
      var son2 = {
        template: "<div class='son2'>son2</div>"
      }
      var son3 = {
        template: "<div class='son3'>son3</div>"
      }
      var son4 = {
        template: "<div class='son4'>son4</div>"
      }

      new Vue({
        el: "#root",
        template: "<div class='root1'><aaaa></aaaa><son2></son2><son3></son3><son4></son4></div>",
        components: {
          // 别名: 原对象
          aaaa: son1,
          son2: son2,
          son3: son3,
          son4: son4
        }

      })
    </script>
```

## 生命周期

生命周期：finalize()

从一个对象被创建，到销毁，有一些特定过程，这个就是生命周期。

生命周期方法，一般用来初始化一些数据。



> <font color=red>**什么是生命周期:**</font>  一个Vue对象从创建到销毁的过程，就是vue的生命周期
>
> > 与Java类似，Java对象从初始化，到被调用，到最终被销毁，这也是一个生命周期
>
> <font color=red>**生命周期函数(钩子)**</font>
>
> >  vue提供给我们，当它在完成这些步骤的时候，它会调用这些方法，可以允许我们方便的操作一些元素
>
> - beforeCreate:在vue对象创建之前
>
> - created:在vue对象创建之后。比较常用
> - beforeMount：挂载之前
> - mounted：挂载之后。比较常用
> - beforeUpdtae：更新前
> - updated：更新后
> - beforeDestroy：销毁前
> - destoryed：销毁后

```java
 <div id="root">
    {{msg}}
    <input v-model="msg">
  </div>
  <script>

   var root = new Vue({
      el: "#root",
      data: {
        msg: "zs"
      },
      beforeCreate:function () {
        console.log("控制台打印:beforeCreate")
      },
      created:function () {
        console.log("控制台打印:created")
      },
      beforeMount:function () {
        //页面还未被渲染
        console.log(this.$el),
                console.log("控制台打印:beforeMount")
      },
      mounted:function () {
        //页面渲染完成
        console.log(this.$el),
                console.log("控制台打印：mounted")
      },
      beforeUpdate:function () {
        console.log("控制台打印：beforeUpdate")
      },
      updated:function () {
        console.log("控制台打印：updated")
      },
      beforeDestroy:function () {
        console.log("控制台打印：beforeDestory")
      },
      destroyed:function () {
        console.log("控制台打印：destroyed")
      }
    })
        
    // root.$destroy()
  </script>
```

## 创建和实现Vue项目

### 创建一个前端服务器

#### 后端流程

> <span style=color:red;background:yellow>**后端服务开发流程**</span>
>
> - <font color=red>**环境准备阶段**</font>
>
>   - 安装jdk
>     - 编译代码的工具
>   - 安装idea
>     - 提升编码效率的
>   - 给idea安装插件
>     - 特异化功能，需要插件
>
> - 通过idea创建java项目
>
> - 在这个项目中写代码(也要引用别人的代码)
>
>   - > 手动下jar包
>     > 1.麻烦
>     > 2.包冲突。比如两个包都要用到一个版本的junit。但是使用到的版本却不一致
>     > 如何解决
>     > 使用maven插件。  配置文件，只需要提供包名和版本，由maven帮我们下载，和管理包冲突
>
> - 编译打包, 给用户使用

#### 前端流程

> <span style=color:red;background:yellow>**前端服务器: 写vue代码  (用js实现一个前端服务器)**</span>
>
> <span style=color:red;>**1.环境准备工作，不用重复进行。每台电脑只用进行一次**</span>
>
> - 安装node （运行js的环境）
>
>   > 编译运行代码的环境，是一个浏览器的内核
>   >
>   > 相当于 Java和JDK的关系。
>   >
>   > js ---> 浏览器(node本身就是一个浏览器)
>
> - 安装node 自带  npm(包管理工具)
>
>   - > npm就是一个下载前端包的插件。
>     >
>     > 只要告诉它你要下载什么包和版本，它会帮你下载
>
> - 安装cnpm:  cnpm是npm服务器的镜像。是淘宝每小时去同步npm到国内的一个镜像。
>       ```java
>       // 使用npm去安装包
>       // -g 全局
>       // cnpm@6.0.0  包 + 版本。
>       // --registry=https://registry.npm.taobao.org 这条命令使用什么源。指定本次命令是从哪里下包
>       npm install -g cnpm@6.0.0 --registry=https://registry.npm.taobao.org
>       ```
>
> - 安装 vue-cli 
>
>   > vue-cli:  vue的脚手架工具
>   >
>   > 用来等一会帮我们构建一个前端服务器
>   >
>   > ```JAVA
>   > cnpm install -g @vue/cli 
>   > cnpm install -g @vue/cli-init  
>   > ```
>   >
>   > 判断是否安装完成： `vue -V`
>
> - 安装webpack: 模块打包机
>
>   ```
>   cnpm install -g webpack   
>   ```

上述步骤都属于环境配置, 不要重复进行: 除非安装失败, 或者某个东西崩溃了   

```JAVA
项目的路径下，不要有中文，不要有特殊字符。比如空格  & * . 
test file/
    
test" file
```

> <span style=color:red;>**2.初始化项目**</span>
>
> - 通过`vue-cli`创建一个vue项目: 
>
>   ```JAVA
>   // 需要翻墙
>   vue init webpack 项目名
>   // vue init webpack vue1
>   // 在当前目录下，安装一个叫做vue1 的项目
>   
>      // 1.------------------注意，不要在中文目录。
>   ```
>
>   >  <span style=color:red>**注意路径，不要带中文**</span>
>   >
>   >  <font color=red>**选择的时候，不要使用npm去安装包。**</font>
>
> - 安装依赖
>
>   > 切换路径 ---> 到项目里面
>   >
>   > 执行 cnpm install ---> 结束, 意味着项目创建完毕
>
> - 启动这个项目: 作为前端服务器       
>
>   ```JAVA
>   npm run  dev
>   ```

![image-20221125153414251](E:\wangdao\java-53-course-materials\02-DSDB\02-笔记\img\image-20221125153414251.png)

如果无法创建一个前端服务，没有问题。因为本质上是创建一个架子。可以直接使用提供好的架子

### <span style=color:red;background:yellow>**如何启动一个项目**</span>

<span style=color:red;background:yellow>**后续拿到一个前端项目，怎么启动？**</span>

node_modules里面是所有的依赖，文件太多太散，所以一般不建议大家拷贝的时候带上它，建议直接删掉，移动到指定目录后，<font color=red>**再重新下载依赖。**</font>

> - 将前端目录放到一个文件夹，<span style=color:yellow;background:red>**不要有中文.不要有特殊字符 比如空格 星号 引号**</span>
>
> - 进入前端文件夹，安装依赖
>
>   - ```JAVA
>     cd vue1
>     cnpm install
>     ```
>
> - 启动项目
>
>   - ```JAVA
>     npm run dev
>     ```

可以装一个 vue.js的插件。就可以进行一些语法高亮。

<font color=red>**最重要的几个文件。**</font>

- package.json -->依赖的文件   依赖，启动的脚本


- config/index.js  --> port


- main.js  --> 怎么由index.html最终展示出来里层App.vue文件的。

```JAVA
package.json中的东西
// 这个是启动命令。如果底下写得是aaa。 那启动命令就是  npm run aaa
    // 如果你作为一个后端，进了一个公司，你不知道怎么启动前端项目。
    // 第一种方式。看package.json里面的文件  scripts
    // 第二种方式。问前端。
"scripts": {
    "aaa": "webpack-dev-server --inline --progress --config build/webpack.dev.conf.js",
    "start": "npm run dev",
    "build": "node build/build.js"
  }
 依赖。依赖的包，包的版本

config/index.js里面的东西
    port: 8080, 

注意一些诡异现象。有一些端口，被chrome给禁止了。不要瞎写端口。
    从8080往上写，不要往下写
```



怎么从 index.html到这个页面的。

怎么去写一个页面的布局。

大组件套小组件的思想。

## axios

```java
axios: 是vue的一个插件,  可以在vue中, 写发起请求代码

// 1, 导包。必须要进入项目的主目录
    
    // cnpm install axios  安装axios这个插件   
    // --save 是让这个安装的依赖，保存到package.json
    cnpm install axios --save
 
// 2, 在main.js配置
   // 导入axios语法: 从node_modules
    import axios from "axios"
    // Vue.prototype: 等价于给整个项目中所有的vue对象配置一个属性: $axios
    Vue.prototype.$axios = axios 

// 3, 具体使用
```

```JAVA
怎么在一个vue项目中引入第三方工具

1, 导包或者配置文件

2, 在main.js配置

3, 使用
```

前后端分离。

前端主要负责页面的展示。

后端负责提供数据。

```JSON
JSON数据  


JavaScript Object 

使用字符串来表示对象。key是字符串，value可以是布尔值，数字，字符串，对象，数组。

{
    "name": "zhangsan",
    "age": 18,
    "account":{
        "id": "111",
        "price": "100"
    }
}


Map  比较像

类   

class User{
    String  name;
    int age;
    Account account;
}
```


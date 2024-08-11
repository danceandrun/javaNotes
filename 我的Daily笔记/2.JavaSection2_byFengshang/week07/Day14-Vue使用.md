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

如果用v-if，为false时，页面直接不挂载元素。

#### v-once: 只加载一次

只有在第一次进来的时候加载。后续对改值进行了改变，不会影响这个块。

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

为了复用代码：引用对象，注册组件

>`component`：组件 。一个vue对象就是一个vue组件
>
>组件系统让我们可以用独立可复用的小组件来构建大型应用，几乎任意类型的应用的界面都可以抽象为一个组件树
>
><font color=red>**组件的目的是什么**</font>
>
>>  可以仿照div嵌套构建页面的思想, 让大vue组件/对象持有小vue对象, 小vue对象持有管控更小区域的vue对象这种思路, 构建一个大的页面 
>
><div align=center><img src='./img/components.png' width='1000px'></div> 

之前html写代码的思路是大的div套小div，现在vue写代码是大对象套用小对象。



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



如果无法创建一个前端服务，没有问题。因为本质上是创建一个架子。可以直接使用提供好的架子

node_modules最大，后续老师发的文件中不会包含modules

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

IDEA中可以装一个 vue.js的插件。就可以进行一些语法高亮。

<font color=red>**最重要的几个文件。**</font>`npm`

- `package.json` -->依赖的文件   依赖，启动的脚本


- `config/index.js`  --> port


- `main.js`  --> 怎么由index.html最终展示出来里层App.vue文件的。



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


和Map比较像

类   

class User{
    String  name;
    int age;
    Account account;
}
```



windows中cmd命令补充

```shell
#进入一个文件夹的方式：
//1.直接在文件夹位置打开控制台

//2.从C盘切D盘
直接D：
#想看文件夹下有哪些文件
输入dir
#进入上级目录
cd ..

```

# HTTP

学习目标：

- 掌握HTTP报文格式，请求报文格式，响应报文格式
- 掌握状态码
- 了解Tomcat是什么
- Tomcat的安装及使用
- 掌握直接部署&虚拟部署



**整体流程图**

![image-20230116095331886](F:/projectforme/java-53-course-materials/02-DSDB/02-笔记/img-http&tomcat/image-20230116095331886.png)

- 前端：负责获取数据，展示数据
- 程序：负责监听端口，并对请求作出响应，这中间需要从数据库获取数据
- 数据库：数据仓库。通过标准化语言SQL进行操作，在Java代码中，是通过JDBC进行操作。

## 协议

三方协议、租房协议、购房协议

用来规定双方的权利以及义务



网络传输中提及的协议：通讯双方传递信息时，传递的信息应当具有的格式。只有共同遵循一致的格式，那么双方才可以正常进行通讯。

比如大家来之前，我们要根据学生的性别，给学生分宿舍。

A   手上有学生的数据。B负责分宿舍。

A和B老师规定格式 ： 有四列   分别是  姓名 年龄 籍贯 性别。

A老师把数据发给B老师， 首先拆，拆完再拆。



*姓名 年龄 籍贯 性别*

甲方：

长风 25 河南 男

景天 28 河南 女

天明 29 河南 男

......

经过网络传输学生的信息



乙方：需求：接收到学生的信息，根据学生的性别去安排宿舍

1.根据换行符来分割出每一个学生的信息

2.每个学生信息又按照空格来进行分割，其中最后一部分为性别



上述过程中，甲乙双方可以正常进行通讯的前提是双方都遵循同样的规则。这个就是协议。

## HTTP协议

HTTP:Hyper Text Transfer Protocol。超文本传输协议。

超文本：超越了普通的文本，资源类型是丰富的，比如文本、音视频、图片等资源。

传输：通讯的双方。客户端、服务器

协议：通讯双方应该在传递时遵循的规则

HTML: Hyper Text Markup Language

### 网络模型

只是逻辑上面的概念，分层。并不是物理上面的层次。分层的目的主要是为了解耦、提升代码的可复用性、系统的可维护性。



### HTTP协议工作流程

1.域名解析

域名：jd.com  cskaoyan.com  taobao.com.可以用来指代网络中的一台计算机主机，对应ip地址。

jd.com----------解析   xxx.xxx.xxx.xxx

- 浏览器缓存
- 操作系统缓存
- hosts文件（127.0.0.1  localhost指的是本机）
- DNS服务器解析



C:\Windows\System32\drivers\etc



2.建立TCP连接

3.浏览器发送HTTP请求

4.HTTP请求经过中转到达服务器之后，被服务器接收到，服务器解析HTTP请求，并且做出HTTP响应。

5.HTTP响应经过中转再次返回给客户端，客户端接收到HTTP响应，并且加以解析、渲染

6.如果解析的过程中，发现需要去加载其他的css、js、img等资源，那么会自行再次发送请求，整个过程同上

7.最终浏览器渲染出来页面，呈现页面给用户。



### HTTP请求

发送的HTTP请求一般称之为HTTP请求报文，分为<span style=color:red;background:yellow>**请求行、请求头、空行、请求体**</span>四部分.其中的一些消息头和正文都是可选的，消息头和正文内容之间要用空行(CRLF即\r\n)隔开.·

客户端发送的HTTP请求信息，一般情况下也称作HTTP请求报文。

![image-20230116120235895](F:/projectforme/java-53-course-materials/02-DSDB/02-笔记/img-http&tomcat/image-20230116120235895.png)

#### 请求行

又可以进一步分为三个部分。

`GET /forum-280-1.html HTTP/1.1`



- 请求方法（GET  POST ）
- 请求资源（服务器内部路径）
- 协议版本（HTTP协议的版本）





<span style=color:red;background:yellow>**GET 请求  POST请求。区别。**</span>

1.语义不同。get请求是获取数据，post请求一般是提交数据

2.参数放的位置不同。get请求的参数放在url上面，使用？进行拼接， post请求请求的参数放在请求体里。 url长度有限制，所以使用get请求发送的数据长度有限制。

3.post请求安全一点。 因为它提交数据的时候，不能直接看到。



- <font color=red>**请求方法**</font>：使用何种方法向当前的请求资源地址发起请求。常见的请求方法 GET  POST

  **GET和POST区别？**

  本质的区别在于语义的不同。

  - **GET的语义是用来进行查询、获取数据。99%的情况下通过浏览器访问网站都是get请求。比如查询商品信息。**

  - **POST的语义是用来进行提交数据。注册、登录、文件上传（微信更换头像）等**

  **如何发送GET或者POST请求？**

  - get请求： 使用浏览器，在地址栏直接输入url，直接发送的就是get请求；使用form表单
  - post请求：使用form表单

  ```html
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <title>Title</title>
  </head>
  <body>
  以post请求方法访问cskaoyan.com,不可以直接在浏览器地址栏直接输入网址
  如果希望使用post方法访问cskaoyan.com，需要：
  1.先访问1.html（当前页面），将form表单加载出来
  2.点击form表单的提交按钮
      <form action="http://www.cskaoyan.com" method="post">
          <input type="text" name="username"><br>
          <input type="submit">
      </form>
  </body>
  </html>
  ```

  <span style=color:red;background:yellow>**验证：**</span>fiddler软件

  安装完毕之后，打开软件。只需要操作浏览器即可，浏览器发送请求时，fiddler软件便会记录下来

  注意，如果是以下情况，fiddler软件无法抓包：

  - 浏览器设置了代理
  - https

  

  <span style=color:red;background:yellow>**学会怎样发get请求和post请求。**</span>

  

  

- <font color=red>**请求资源**</font>:指的是访问服务器上面的哪个资源(访问不同页面时，区别主要在于请求资源的不同)

  http://www.cskaoyan.com/forum-280-1.html

  http://www.cskaoyan.com/forum-279-1.html

  上述两个不同的请求，在HTTP请求报文层面的区别是啥？

  

  

  ```
  GET http://www.cskaoyan.com/forum-280-1.html HTTP/1.1
  
  GET http://www.cskaoyan.com/thread-664595-1-1.html HTTP/1.1
  
  GET /thread-664595-1-1.html HTTP/1.1
  
  请求资源 或者 服务器内部路径不同。就相当于告诉服务器，我需要请求不同的资源
   
  /login   
  /search 
  
  Fiddler抓包，请求资源有点问题。它自己把url拼接上去了。 真实请求是没有这个url的。
  ```

  

  服务器内部路径

  

- <font color=red>**版本协议**</font>

  HTTP/1.1：当前使用的是HTTP 1.1的版本

  在1.1之前的上一个版本是1.0.他们两者之间的区别主要在于是否支持长连接。

  长连接：在一个TCP连接内，是否允许发送多个HTTP请求。如果支持就是长连接。

  1.0版本不支持长连接

  1.1默认支持长连接

#### 请求头

请求头可以理解为是对于请求信息的额外补充，类似于合同的附加合同、补充条款。

```
Accept:浏览器可接受的    MIME类型 */*   (大类型)/(小类型)。浏览器可以接收的类型，言外之意是服务器做出响应时，应当优先响应我可以接收处理的类型。
	MIME:使用一种大类型/小类型的方式将互联网上面的资源加以分类。比如text/html、text/txt、audio/mp3、video/mkv、image/jpeg、image/png
 Accept作为一个补充条款，浏览器告诉服务器，我优先能处理的类型。 服务器在响应的时候，会优先响应这几种指定的类型。
	
Accept-Charset: 浏览器通过这个头告诉服务器，它支持哪种字符集
Accept-Encoding:浏览器能够进行解码的数据编码方式，比如gzip。浏览器利用该头告诉服务器，如果返回的资源需要进行压缩，那么应该使用浏览器可以支持的压缩算法。

Accept-Language: 浏览器所希望的语言种类，当服务器能够提供一种以上的语言版本时要用到,
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
zh-CN,zh;q=0.9,en;q=0.8   ---->    zh-CN         zh;q=0.9          en;q=0.8  

浏览器告诉服务器，我这边希望的语言种类有三种。 q代表权重。 

国际化  

如果有中文简体，就发中文简体； 没有的话，就发中文繁体；
再没有的话，就发英文。

可以在浏览器中进行设置。twitter.com
Host:初始URL中的主机和端口 
Referer:包含一个URL，用户从该URL代表的页面出发访问当前请求的页面 （防盗链）
Content-Type:内容类型。发送的时候的内容类型。比如我现在要上传一张图片。
If-Modified-Since: Wed, 02 Feb 2011 12:04:56 GMT 服务器利用这个头与服务器的文件进行比对，如果一致，则告诉浏览器从缓存中直接读取文件。
User-Agent:浏览器类型.是从什么浏览器发起的请求
Content-Length:表示请求消息正文的长度。表示的是体的长度。
Connection:表示是否需要持久连接。如果服务器看到这里的值为“Keep-Alive”，或者看到请求使用的是HTTP 1.1（HTTP 1.1默认进行持久连接 
Cookie:这是最重要的请求头信息之一 

Date: Mon, 22 Aug 2011 01:55:39 GMT请求时间GMT 
```

**1.直接访问A页面**

![image-20230220173311923](F:/projectforme/java-53-course-materials/02-DSDB/02-笔记/img-http&tomcat/image-20230220173311923.png)

**2.先访问B页面，通过B页面跳转到A页面**

![image-20230220173210187](F:/projectforme/java-53-course-materials/02-DSDB/02-笔记/img-http&tomcat/image-20230220173210187.png)



有没有技术手段可以区分这两种方式？利用**referer请求头**。

使用场景？带货引流

图片防盗链

谷歌广告联盟



防盗链

https://img-blog.csdnimg.cn/img_convert/0e449547f8e5354646f76af0d1b4800a.png



我现在要做一个图片网站，我自己不存储图片，我去各大图片网站，复制Url。

别人存储图片的网站，就不乐意了。

通过refer来判断，是从什么网站进入的。



直播带货。我是一个主播，我贴了一个商品在这。店铺怎么确定，哪些人是通过这个主播进入的店铺。

通过refer



```JAVA
请求头，响应头。不要背。大致知道意思（英语单词。）
如果有一些你想懂得更深一点，上网google一下。chatgpt一下。 
```





#### 空行

#### 请求体（存储提交的请求数据）

可以用来大量放置数据的地方。客户端希望提交大量的数据到服务器，那么就把数据放置在请求体里面。微信更换头像。

上传一个文件，上传word txt。

### HTTP响应

服务器发送的HTTP响应信息，一般情况下也称作HTTP响应报文。

服务器发送的HTTP响应一般称之为HTTP请求报文，分为<span style=color:red;background:yellow>**响应行、响应头、空行、响应体**</span>四部分.其中的一些消息头（响应）和正文都是可选的，消息头和正文内容之间要用空行(CRLF即\r\n)隔开.

![image-20230116143613352](F:/projectforme/java-53-course-materials/02-DSDB/02-笔记/img-http&tomcat/image-20230116143613352.png)



#### 响应行

响应行主要是三部分组成

- 版本协议（HTTP/1.1 HTTP1.0）
- 状态码
- 原因短语



- 版本协议

- <span style=color:yellow;background:red>**状态码**</span>

  200：OK  一切访问过程是正常的

  301、302、307：重定向。当前的地址不可用，服务器需要将请求重新定向到一个新的地址。**重定向一定会搭配着Location响应头**一起来发挥作用。

  http://www.bing.com 

  

  ```JAVA
  http://www.bing.com/      307      Location: https://www.bing.com/
  https://www.bing.com/     302      Location: https://cn.bing.com/
  https://cn.bing.com/      200
  ```

  

  304:未修改。使用缓存。

  

  

  404：没有找到。Not Found。 

  500：服务器异常。有bug。如果出现500状态码，那么一定有bug，但是200状态码不一定没有bug。

出现 500。一定有bug。   200一定没bug？   有可能有bug。

找所有学生中分数最高的学生。（需求）

找了一个分数最低的学生出来。 （实际）



- 原因短语

#### 响应头

```
Location: http://www.cskaoyan.com/指示新的资源的位置.需要搭配着重定向状态码一起来使用。

// 301 302 307  一定要返回一个location。告诉我新的地址。

Server: apache tomcat 指示服务器的类型
Content-Encoding: gzip ； 服务器发送的数据采用的编码格式。

Content-Length: 80 告诉浏览器正文的长度
Content-Language: zh-cn; 服务发送的文本的语言
Content-Type: text/html;  服务器发送的内容的MIME类型

// 写这个Content-Type有什么作用。  图片按照什么发的？
// 必须要把这个图片进行  编码  转成二进制。 写到响应体里面
// 浏览器这边。 对数据进行解析。尤其是响应体里面的图片。 
// 如果不写Content-Type， 可能会导致乱码。
// 如果写错了，会发生什么。 乱码。     乱码的本质： 编解码不一致。

Last-Modified: Tue, 11 Jul 2000 18:23:51 GMT; 文件的最后修改时间
Refresh: 1;url=http://www.cskaoyan.com; 指示客户端刷新频率。单位是秒
相当于告诉浏览器，这边 1s后对页面进行刷新。 刷新的网址是 url=http://www.cskaoyan.com;

Content-Disposition: attachment; filename=aaa.zip; 指示客户端保存文件,直接下载文件
Set-Cookie: SS=Q0=5Lb_nQ; path=/search; 服务器端发送的Cookie
Expires: 0
Cache-Control: no-cache (1.1)  
Connection: close/Keep-Alive   
Date: Tue, 11 Jul 2000 18:23:51 GMT


// 有一些情况是不希望进行缓存。 
// 就可以通过这两个响应头进行控制。 
```

#### 空行

#### 响应体(是存放返回数据的地方)

用来存放服务器返回给客户端大量的数据。响应体里面的数据会最终出现在浏览器的窗口界面中。

可以响应文本类型，也可以响应二进制类型；如果响应二进制类型，那么需要返回特定的Content-Type



比如，现在写回了一张图片。但是content-type写的是text/html



浏览器得到的信息： 我现在拿到了一个网页。所以拿响应体，会按照网页来进行解析。就会乱码

乱码的本质： 编解码不一致。



比如返回html，浏览器会把这个东西显示在页面上。

返回图片，会显示到页面上。

html和图片 都是放在 响应体里面的。

### 请求完整的处理流程

以访问http://www.cskaoyan.com为例

1.域名解析。首先尝试使用浏览器缓存查找，再次通过操作系统缓存查找，借助于hosts文件，最终利用DNS服务器来进行解析。

​						cskaoyan.com------58.211.2.79（中国 江苏省 苏州市）

2.建立TCP连接。

3.浏览器会代理用户发送HTTP请求报文(GET /1.html HTTP/1.1...........)，请求报文在网络中中转传输到达服务器之后，会服务器接收到，进行解析

4.服务器产生HTTP响应报文（HTTP/1.1 200 OK...........）,响应报文在网络中中转传输返回给客户端之后，客户端会将响应报文进行解析、渲染

5.如果发现需要再次加载新的资源文件，那么浏览器会自行再次发起请求，过程同上

6.加载获取到所有的资源文件之后，最终渲染（显示），将页面呈现在用户面前。

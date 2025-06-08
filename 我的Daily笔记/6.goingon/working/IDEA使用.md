# IDEA使用

## 快捷键

| 快捷键                 | 说明                           |
| ---------------------- | ------------------------------ |
| ctrl + F12             | 查看一个类中所有的方法         |
| ctrl + alt + shift + j | 选中相同名称的变量同时进行修改 |
| Alt + F8               | 评估表达式的窗口               |
| ctrl + alt + shift + u | 打开类图分析                   |

> 1. 打开 IntelliJ IDEA，并打开您的项目。
> 2. 在项目中选择要查看类图的 Java 类。
> 3. 使用快捷键 `Ctrl + Shift + Alt + U`（或者在主菜单中选择 "Diagrams" -> "Show Diagram..."）打开类图分析界面。
> 4. 类图分析界面将显示选定类及其相关的类和接口。您可以通过缩放、拖动和导航工具栏来浏览类图。
> 5. 在类图中，您可以点击类或接口来查看其详细信息，包括成员变量、方法和关联关系。
> 6. 还可以通过右键单击类图中的类或接口，选择 "Navigate" -> "Declaration"（或者使用快捷键 `Ctrl + B`）来跳转到对应的源代码。
> 7. 如果需要重新生成类图，可以右键单击类图界面，选择 "Generate Diagram"，然后选择 "Update Diagram" 或 "Generate Diagram"。

## Debug技巧

### 评估表达式使用

使用`deGroup<>()`

评估表达式允许你在调试过程中计算和查看变量、表达式和方法的值，以便更好地理解程序的执行状态。以下是一些使用评估表达式的技巧：

1. 在调试会话期间，你可以在IDEA的调试窗口中使用评估表达式。在你希望评估表达式的位置设置一个断点，然后在调试时，右键单击表达式并选择"Evaluate Expression"（评估表达式）或使用快捷键（默认为Alt+F8）来评估当前的表达式。

2. 评估单个变量：你可以评估单个变量的值，以检查其当前状态。例如，如果你想查看一个名为`myVariable`的变量的值，可以在评估表达式中输入`myVariable`并查看其值。

3. 评估表达式：除了变量之外，你还可以评估任意的表达式。这对于计算复杂表达式或检查条件的值非常有用。例如，你可以输入`x + y`来评估`x`和`y`的和。

4. 调用方法：你可以在评估表达式中调用方法，并查看返回的结果。这在快速测试方法的行为或调用对象的方法时非常有用。例如，如果你有一个名为`myObject`的对象，并且想调用它的一个方法`myMethod()`，你可以在评估表达式中输入`myObject.myMethod()`。

5. 使用临时变量：如果你希望在评估表达式中使用某个值多次，你可以在表达式之前创建一个临时变量并将其赋值。这样，你可以在评估表达式中引用该临时变量，而无需多次重复输入相同的值。

6. 使用代码片段：IDEA还允许你在评估表达式中使用代码片段。你可以在表达式中编写一小段代码，并在调试时执行它。这对于在调试期间进行一些复杂的操作或模拟特定的情况非常有用。

## 查看代码行数

要统计整个项目的代码行数，你可以使用以下方法：

1. 使用IDEA的内置功能：在IDEA中，你可以使用"Analyze"菜单下的"Calculate Code Metrics"选项来统计代码行数。这将生成一个报告，其中包括代码行数、注释行数、空行数等信息。

   - 在IDEA中，点击顶部菜单栏的"Analyze"。
   - 选择"Calculate Code Metrics"。
   - 在弹出的对话框中，选择你要统计的模块或整个项目。
   - 点击"OK"，IDEA将计算并显示代码行数统计信息。

2. 使用命令行工具：另一种方法是使用命令行工具来统计代码行数。Gradle构建工具提供了一个名为"Gradle Code Quality Plugin"的插件，它可以帮助你统计代码行数。

   - 首先，在你的Gradle项目的根目录下的`build.gradle`文件中，添加以下插件依赖：
     ```groovy
     plugins {
         id 'org.gradle.code-quality' version '7.3.3'
     }
     ```

   - 保存`build.gradle`文件并刷新Gradle项目，让插件生效。

   - 打开命令行终端，并导航到你的项目目录。

   - 运行以下命令来执行代码行数统计：
     ```
     ./gradlew codeQualityMain
     ```

   - 统计完成后，你将在终端中看到代码行数的汇总信息。

这些方法可以帮助你统计整个项目的代码行数。根据你的需求，你可以选择使用IDEA的内置功能或通过Gradle插件来完成统计。

## 操作多行

在 IntelliJ IDEA 中，你可以使用正则表达式的替换功能来快速给多行的行尾添加相同的字符串。请按照以下步骤操作：

1. 打开你的项目或文件，在编辑器中选中需要添加字符串的多行文本。
2. 使用快捷键 `Ctrl + Shift + R`（Windows/Linux）或 `Command + Shift + R`（Mac）来打开替换窗口。
3. 在替换窗口中，确保 "Regex"（正则表达式）选项被选中。你可以在替换窗口的左上角找到这个选项。
4. 在 "Find"（查找）输入框中输入 `$`，这个符号代表行尾位置。
5. 在 "Replace with"（替换为）输入框中输入 `= ""`，这是你想要添加到行尾的字符串。
6. 确认光标在替换窗口中的文本字段中，然后点击 "Replace"（替换）按钮来替换第一个匹配项，或者点击 "Replace All"（全部替换）按钮来替换所有匹配项。

这样，所有选中的行尾都会被添加上 `= ""` 字符串。

请注意，这个方法会将每一行的行尾替换为 `= ""`，无论行的长度如何。如果你想要根据行的长度来添加字符串，你可能需要使用其他的自动化方法，比如编写一个自定义的插件或脚本来实现。

## 镜像

### distributionUrl

将 `distributionUrl` 替换为国内镜像网站的 URL 来加速 Gradle 的下载。以下是一些常用的国内镜像源，你可以根据自己的位置和网络条件选择一个合适的镜像源：

1. **阿里云**：
   ```properties
   distributionUrl=https://maven.aliyun.com/repository/gradle/dists/gradle-7.6.4-bin.zip
   ```

2. **华为云**：
   ```properties
   distributionUrl=https://repo.huaweicloud.com/gradle/gradle-7.6.4-bin.zip
   ```

3. **腾讯云**：
   ```properties
   distributionUrl=https://mirrors.cloud.tencent.com/gradle/gradle-7.6.4-bin.zip
   ```

4. **清华大学开源软件镜像站（TUNA）**：
   ```properties
   distributionUrl=https://mirrors.tuna.tsinghua.edu.cn/gradle/gradle-7.6.4-bin.zip
   ```

5. **中国科学技术大学（USTC）**：
   
   ```properties
   distributionUrl=https://mirrors.ustc.edu.cn/gradle/gradle-7.6.4-bin.zip
   ```
   
6. **京东**：
   ```properties
   distributionUrl=https://maven.jd.com/nexus/content/repositories/gradle-dist/gradle/gradle-7.6.4-bin.zip
   ```

请注意，你需要将 `gradle-7.6.4-bin.zip` 中的版本号替换为你实际需要的 Gradle 版本。这些镜像源通常会同步官方 Gradle 仓库的最新版本，因此你可以在这些镜像源中找到你需要的任何 Gradle 版本。

将 `gradle-wrapper.properties` 文件中的 `distributionUrl` 修改为上述任一镜像源的 URL，可以显著提高 Gradle 在中国大陆地区的下载速度。

### 全局配置

在Gradle中设置镜像URL通常有两种方式：

1. **全局配置**：
   - 对于全局配置，你可以在Gradle用户主目录下的`gradle.properties`文件中设置镜像。Gradle用户主目录通常位于用户的home目录下的`.gradle`文件夹中。例如，在Windows系统上，路径可能是`C:\Users\你的用户名\.gradle\gradle.properties`，在Linux或macOS上，路径可能是`/home/你的用户名/.gradle/gradle.properties`或`/Users/你的用户名/.gradle/gradle.properties`。

   - 在`gradle.properties`文件中，你可以设置如下属性来指定镜像源：
     ```
     systemProp.https.proxyHost=yourProxyHost
     systemProp.https.proxyPort=yourProxyPort
     systemProp.http.proxyHost=yourProxyHost
     systemProp.http.proxyPort=yourProxyPort
     
     org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
     org.gradle.parallel=true
     org.gradle.caching=true
     org.gradle.daemon=true
     org.gradle.configureondemand=true
     
     # Maven Central 镜像
     repository.maven.central.url=https://repo.maven.apache.org/maven2/
     ```
   
   - 如果你想替换为国内的镜像源，比如阿里云，可以修改为：
     ```
     repository.maven.central.url=https://maven.aliyun.com/repository/public
     ```

2. **项目配置**：
   
   - 对于单个项目的配置，你可以在项目的`build.gradle`文件中设置镜像。通常，这是通过配置项目的`repositories`来实现的。例如：
     ```groovy
     allprojects {
         repositories {
             // 使用阿里云镜像
             maven { url 'https://maven.aliyun.com/repository/public' }
             // 其他仓库...
         }
     }
     ```
   - 或者，如果你使用的是Kotlin DSL，配置方式如下：
     ```kotlin
     allprojects {
         repositories {
             // 使用阿里云镜像
             maven("https://maven.aliyun.com/repository/public")
             // 其他仓库...
         }
     }
     ```

选择哪种方式取决于你是否希望对所有项目应用相同的镜像设置（全局配置），还是只对特定项目进行设置（项目配置）。

构建项目时遇到的 `Connection reset` 错误通常是由于网络问题导致的依赖下载失败。以下是解决此问题的建议：

------

### 1. **检查网络连接**

确保你的网络环境稳定，尤其是访问 `https://plugins.gradle.org` 和 `https://repo.maven.apache.org` 的权限。如果你在国内环境，访问这些仓库可能会受到限制。

------

### 2. **配置国内镜像仓库**

国内用户可以通过配置镜像来解决依赖下载缓慢或失败的问题。以下是推荐的镜像仓库以及如何配置：

#### 修改 `build.gradle` 或 `settings.gradle` 文件

在项目的 `build.gradle` 或 `settings.gradle` 文件中，添加以下内容：

```gradle
repositories {
    maven {
        url 'https://maven.aliyun.com/repository/public'
    }
    maven {
        url 'https://maven.aliyun.com/repository/gradle-plugin'
    }
    mavenCentral()
    gradlePluginPortal()
}
```

- **阿里云 Maven 镜像**：`https://maven.aliyun.com/repository/public`

- **阿里云 Gradle 插件镜像**：`https://maven.aliyun.com/repository/gradle-plugin`

  **阿里云 Maven 中央仓库镜像：**

  ```groovy
  maven { url 'https://maven.aliyun.com/repository/central' }
  ```

  **阿里云 Gradle 插件仓库镜像：**

  ```groovy
  maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
  ```

------

### 3. **配置全局 Gradle 镜像**

如果需要为整个 Gradle 环境配置镜像，可以修改 `~/.gradle/init.gradle` 文件，添加以下内容：

```gradle
allprojects {
    repositories {
        maven {
            url 'https://maven.aliyun.com/repository/public'
        }
        maven {
            url 'https://maven.aliyun.com/repository/gradle-plugin'
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
```

------

### 4. **更换 JDK 或调整 JVM 参数**

有时，JDK 的版本可能会影响网络请求。如果你使用的是 JDK 8，可以尝试升级到 JDK 11 或更高版本。

同时，增加 JVM 的网络超时时间可能也会有帮助。在 `gradle.properties` 文件中添加以下配置：

```properties
org.gradle.jvmargs=-Dsun.net.client.defaultConnectTimeout=10000 -Dsun.net.client.defaultReadTimeout=30000
```

------

### 5. **使用离线模式**

如果镜像配置后依然没有效果，可以尝试手动下载依赖并开启 Gradle 的离线模式：

1. 访问以下链接手动下载依赖：

   - [SonarQube Gradle 插件](https://plugins.gradle.org/m2/org/sonarsource/scanner/api/sonar-scanner-api/2.16.2.588/)

2. 将下载的依赖手动放入 Gradle 本地缓存目录，一般路径为：

   ```
   ~/.gradle/caches/modules-2/files-2.1/
   ```

3. 启用离线模式运行构建：

   ```bash
   gradle build --offline
   ```

------

### 6. **调试与 Gradle Build Scan™**

如果问题仍然存在，可以使用 Gradle 提供的 Build Scan 功能来分析问题：

```bash
gradle build --scan
```

生成的链接会提供详细的诊断信息，帮助进一步排查问题。

------

### 7. **参考官方文档和社区资源**

可以访问以下资源获取更多帮助：

- [Gradle 官方帮助文档](https://gradle.org/help/)
- [Gradle Community Slack](https://gradle.org/slack)
- [Gradle Troubleshooting 文档](https://docs.gradle.org/current/userguide/troubleshooting.html)


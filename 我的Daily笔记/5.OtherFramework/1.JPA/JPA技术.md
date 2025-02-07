

# JPA

> 在学习[Getting Started | Building REST services with Spring](https://spring.io/guides/tutorials/rest)和日常项目中，一些简单场景下不使用mybatis进行ORM，而是用JPA，所以这里记录一些遇到的问题。

## 自定义查询

在 Spring Data JPA 中，定义自定义查询的方法主要有三种：方法名称查询（Query Methods）、参数设置查询（Query Creation from Method Names）、使用 `@Query` 注解查询。以下是对这三种查询方式的详细介绍：

### 1. **方法名称查询（Query Methods）**

Spring Data JPA 提供了一种非常方便的方式来定义查询方法，即通过方法名称的命名约定来定义查询逻辑。Spring Data JPA 会根据方法名称的命名规则自动生成查询。

#### 命名规则

- **基本规则**：方法名称通常以 `find`、`read`、`query`、`get` 等动词开头，后面跟着实体类的属性名，属性名的首字母大写。
- **逻辑操作符**：
  - `By`：表示“根据……”。
  - `And`、`Or`：表示逻辑与、逻辑或。
  - `Is`、`Equals`：表示等于。
  - `Not`、`NotEquals`：表示不等于。
  - `GreaterThan`、`LessThan`：表示大于、小于。
  - `Like`、`NotLike`：表示模糊匹配。
  - `IsNull`、`IsNotNull`：表示是否为 `null`。
  - `OrderBy`：表示排序。

#### 示例

假设有一个 `User` 实体类，包含 `username` 和 `email` 属性：

java复制

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String email;

    // Getters and Setters
}
```

定义一个 `UserRepository` 接口：

java复制

```java
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByUsername(String username);

    List<User> findByEmail(String email);

    List<User> findByUsernameAndEmail(String username, String email);

    List<User> findByUsernameOrEmail(String username, String email);

    List<User> findByUsernameLike(String username);

    List<User> findByEmailIsNull();
}
```

### 2. **参数设置查询（Query Creation from Method Names）**

这种方法与方法名称查询类似，但可以通过方法参数的注解来进一步细化查询条件。Spring Data JPA 会根据方法参数的值动态生成查询。

#### 示例

假设有一个 `User` 实体类，包含 `username` 和 `email` 属性：

java复制

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String email;

    // Getters and Setters
}
```

定义一个 `UserRepository` 接口：

java复制

```java
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByUsername(@Param("username") String username);

    List<User> findByEmail(@Param("email") String email);

    List<User> findByUsernameAndEmail(@Param("username") String username, @Param("email") String email);

    List<User> findByUsernameOrEmail(@Param("username") String username, @Param("email") String email);

    List<User> findByUsernameLike(@Param("username") String username);

    List<User> findByEmailIsNull();
}
```

### 3. **使用 `@Query` 注解查询**

`@Query` 注解允许你直接编写 JPQL（Java Persistence Query Language）或原生 SQL 查询。这种方式提供了最大的灵活性，可以实现复杂的查询逻辑。

#### 示例

假设有一个 `User` 实体类，包含 `username` 和 `email` 属性：

java复制

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String email;

    // Getters and Setters
}
```

定义一个 `UserRepository` 接口：

java复制

```java
public interface UserRepository extends JpaRepository<User, Long> {
    // 使用 JPQL 查询
    @Query("SELECT u FROM User u WHERE u.username = :username")
    List<User> findByUsername(@Param("username") String username);

    // 使用原生 SQL 查询
    @Query(value = "SELECT * FROM users u WHERE u.username = :username", nativeQuery = true)
    List<User> findByUsernameNative(@Param("username") String username);

    // 使用 JPQL 查询多个条件
    @Query("SELECT u FROM User u WHERE u.username = :username AND u.email = :email")
    List<User> findByUsernameAndEmail(@Param("username") String username, @Param("email") String email);

    // 使用原生 SQL 查询多个条件
    @Query(value = "SELECT * FROM users u WHERE u.username = :username AND u.email = :email", nativeQuery = true)
    List<User> findByUsernameAndEmailNative(@Param("username") String username, @Param("email") String email);
}
```

### 总结

- **方法名称查询**：通过方法名称的命名规则自动生成查询，适合简单的查询逻辑。
- **参数设置查询**：通过方法参数的注解细化查询条件，适合需要动态参数的查询。
- **使用 `@Query` 注解查询**：直接编写 JPQL 或原生 SQL 查询，适合复杂的查询逻辑。

根据你的需求选择合适的查询方式。对于简单的查询，推荐使用方法名称查询；对于复杂的查询，推荐使用 `@Query` 注解查询。

## JPA总览

###  Spring Data JPA的优点和缺点

####  优点

- 简单易用：Spring Data JPA 简化了[数据访问层](https://zhida.zhihu.com/search?content_id=226844004&content_type=Article&match_order=1&q=数据访问层&zhida_source=entity)的开发，大大减少了代码量。
- 减少重复工作：通过继承 `JpaRepository` 接口，可以自动获得增删改查等基本操作，减少了开发人员的重复工作。
- 更好的[可读性](https://zhida.zhihu.com/search?content_id=226844004&content_type=Article&match_order=1&q=可读性&zhida_source=entity)：通过使用 Spring Data JPA 提供的方法命名规范，可以使代码更具可读性，提高了代码的可维护性。
- 集成方便：Spring Data JPA 可以很方便地与其他 Spring 框架集成，如 Spring Boot、Spring Cloud 等。
- 规范化：Spring Data JPA 实现了 JPA 规范，支持多种数据库，并且提供了很多扩展接口，可以方便地进行定制。

####  缺点

- 性能问题：在大数据量、[高并发](https://zhida.zhihu.com/search?content_id=226844004&content_type=Article&match_order=1&q=高并发&zhida_source=entity)情况下，性能可能不如原生的 SQL 查询，需要进行调优。
- 学习成本：学习 JPA 规范以及 Spring Data JPA 的相关知识需要一定的时间和精力。
- 灵活性差：由于 Spring Data JPA 主要是为了简化 CRUD 操作的开发，因此对于复杂查询等场景可能不太适合。

### 与其他 ORM 框架的比较

#### 与 MyBatis 比较

- Spring Data JPA：优点是代码简单、易于维护，集成 Spring 框架更方便；缺点是灵活性不如 MyBatis，性能也可能不如 MyBatis。
- MyBatis：优点是灵活性强，可以执行复杂的 SQL 语句；缺点是需要手动编写 SQL 语句，难以维护。

#### 与 Hibernate 比较

- Spring Data JPA：基于 JPA 标准，规范化强，使用简单，支持多种数据库；缺点是性能可能不如原生 SQL，不太适合复杂查询场景。
- Hibernate：性能好，支持丰富的 ORM 功能，适合复杂查询场景；缺点是学习成本高，文档相对较少，适用范围相对狭窄。

### 适合使用 Spring Data JPA 的项目类型

Spring Data JPA 适用于需求较为简单的 CRUD 操作的项目，特别是对于初学者来说，使用 Spring Data JPA 可以很快速的上手。对于一些需要进行关联操作的复杂查询场景，或者需要特定的 SQL 语句实现的场景，可以考虑使用 MyBatis 或者直接使用 Hibernate。但对于大多数项目而言，使用 Spring Data JPA 已经能够很好地满足需求。

## 参考文章

1. [SpringData JPA：一文带你搞懂 - 知乎](https://zhuanlan.zhihu.com/p/624207419)
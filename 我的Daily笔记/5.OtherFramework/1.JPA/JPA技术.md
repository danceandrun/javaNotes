

# JPA

> 在学习[Getting Started | Building REST services with Spring](https://spring.io/guides/tutorials/rest)和日常项目中，一些简单场景下不使用mybatis进行ORM，而是用JPA，所以这里记录一些遇到的问题。

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

Spring Data JPA 是一个非常强大的框架，它通过提供声明式的方法简化了 JPA 的使用。在 Spring Data JPA 中，你可以通过定义接口来生成实现类，而无需手动编写具体的实现代码。这些接口通常继承自 `JpaRepository` 或 `CrudRepository`，并通过方法名约定来实现查询功能。

## 常见接口定义和使用方法

---

### **`CrudRepository`**

`CrudRepository` 是 Spring Data 的基础接口，提供了基本的 CRUD 操作（创建、读取、更新、删除）。它是最基础的接口，适用于简单的数据访问需求。

#### **接口定义**
```java
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Long> {
    // 无需定义方法实现，Spring Data JPA 会自动实现
}
```

#### **方法示例**
- **保存实体**：
  ```java
  User user = new User("John Doe", "john@example.com");
  userRepository.save(user);
  ```

- **根据 ID 查询实体**：
  ```java
  Optional<User> user = userRepository.findById(1L);
  ```

- **删除实体**：
  ```java
  userRepository.deleteById(1L);
  ```

- **查询所有实体**：
  ```java
  Iterable<User> users = userRepository.findAll();
  ```

---

### **`JpaRepository`**
`JpaRepository` 是 `CrudRepository` 的扩展，提供了更多与 JPA 相关的功能，例如分页和排序。

#### **接口定义**
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    // 无需定义方法实现，Spring Data JPA 会自动实现
}
```

#### **方法示例**
- **分页查询**：
  ```java
  Pageable pageable = PageRequest.of(0, 10); // 第一页，每页10条
  Page<User> users = userRepository.findAll(pageable);
  ```

- **排序查询**：
  ```java
  Sort sort = Sort.by(Sort.Direction.ASC, "username");
  List<User> users = userRepository.findAll(sort);
  ```

---

###  **自定义查询方法**
Spring Data JPA 允许通过方法名约定来定义查询方法。这些方法不需要实现代码，Spring Data JPA 会根据方法名生成相应的查询。

#### **示例：**
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    // 根据用户名查询用户
    User findByUsername(String username);

    // 根据用户名或邮箱查询用户
    List<User> findByUsernameOrEmail(String username, String email);

    // 根据用户名模糊查询用户
    List<User> findByUsernameContaining(String username);

    // 根据用户名查询用户，并分页
    Page<User> findByUsername(String username, Pageable pageable);
}
```

#### **方法名约定**
- **`findBy<字段名>`**：根据字段值查询。
- **`findBy<字段名>And<字段名>`**：组合条件查询。
- **`findBy<字段名>Containing`**：模糊查询（`LIKE`）。
- **`findBy<字段名>StartingWith`**：前缀匹配。
- **`findBy<字段名>EndingWith`**：后缀匹配。
- **`findBy<字段名>In`**：集合匹配。
- **`findBy<字段名>Between`**：范围查询。

---

### **使用 `@Query` 注解**
如果默认的方法名约定无法满足需求，可以使用 `@Query` 注解自定义查询。

#### **示例：**
```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Long> {
    // 使用 JPQL 查询
    @Query("SELECT u FROM User u WHERE u.username = ?1")
    User findByUsername(String username);

    // 使用原生 SQL 查询
    @Query(value = "SELECT * FROM users WHERE username = ?1", nativeQuery = true)
    User findByUsernameNative(String username);
}
```

#### **参数绑定**
- `?1`：位置参数。
- `:username`：命名参数。

---

### **自定义方法实现**
如果需要更复杂的逻辑，可以通过自定义方法实现来扩展接口。

#### **示例：**
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long>, CustomUserRepository {
    // 自定义方法
}

public interface CustomUserRepository {
    User findUserWithCustomLogic(String username);
}

public class CustomUserRepositoryImpl implements CustomUserRepository {
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public User findUserWithCustomLogic(String username) {
        // 自定义逻辑
        return entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                             .setParameter("username", username)
                             .getSingleResult();
    }
}
```

---

### **使用 `Specification`**
对于复杂的动态查询，可以使用 `JpaSpecificationExecutor` 接口。

#### **接口定义**
```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    // ...
}
```

#### **使用示例**
```java
import org.springframework.data.jpa.domain.Specification;

public class UserService {
    @Autowired
    private UserRepository userRepository;

    public List<User> searchUsers(String username, String email) {
        Specification<User> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (username != null) {
                predicates.add(criteriaBuilder.equal(root.get("username"), username));
            }
            if (email != null) {
                predicates.add(criteriaBuilder.equal(root.get("email"), email));
            }
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        return userRepository.findAll(spec);
    }
}
```

---

### 使用总结
Spring Data JPA 提供了多种接口定义方式，从简单的 CRUD 操作到复杂的动态查询，都能满足不同的需求。以下是常见接口的总结：
- **`CrudRepository`**：基础 CRUD 操作。
- **`JpaRepository`**：扩展了分页和排序功能。
- **自定义方法名**：通过方法名约定生成查询。
- **`@Query` 注解**：自定义 JPQL 或原生 SQL 查询。
- **自定义方法实现**：扩展接口，实现复杂逻辑。
- **`JpaSpecificationExecutor`**：动态查询。

## 与其他 ORM 框架的比较

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
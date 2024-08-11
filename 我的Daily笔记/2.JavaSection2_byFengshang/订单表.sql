-- 创建一个订单表，练习内容如下
--  
-- 0. int insertOrder(Order order)
-- 1. int selectIdByOrderName(String orderName);
-- 2. List<Integer> selectIdList();
-- 3. List<String> selectNameList();
-- 4. Order selectOrderById(Integer id);
-- 5. List<Order> selectOrderList();
-- 6, int updateOrderById(Order order)
-- 7, int deleteOrderById(int id)
-- 8, int deleteOrderByName(String orderName)

-- 创建订单表

create table `order` (id int primary key auto_increment, name varchar(255), create_time timestamp default current_timestamp, 
update_time timestamp default current_timestamp on update current_timestamp );

-- 插入数据
insert into `order` (id, name) values (1,'苹果'),(2,'香蕉'),(3,'小米'),(4,'大米');

-- 通过Mybatis的SqlSession的方式实现用户注册和登录的相关接口
-- 
-- 注册
-- 登录
-- 修改密码
-- 注销账户

-- 创建用户信息表
create table `user` (id int primary key auto_increment, username varchar(255),password varchar(255), create_time timestamp default current_timestamp, 
update_time timestamp default current_timestamp on update current_timestamp );
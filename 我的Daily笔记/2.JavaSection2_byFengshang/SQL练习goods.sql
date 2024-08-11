
-- 创建good和good_detail
drop table if exists `goods`;
create table `goods` (id int primary key auto_increment, name varchar(255), price decimal(15,2), create_time timestamp default current_timestamp, 
update_time timestamp default current_timestamp on update current_timestamp );
insert into goods (id,name,price) values(1,'iphone',8000);
insert into goods (id,name,price) values(2,'小米',1999);
insert into goods (id,name,price) values(3,'华为',6888);
insert into goods (id,name,price) values(4,'MacBook',18000);

drop table if exists `goods_detail`;
create table `goods_detail` (id int primary key auto_increment,goods_id int, name varchar(255), price decimal(15,2),stock int, pic varchar(255),create_time timestamp default current_timestamp, 
update_time timestamp default current_timestamp on update current_timestamp );
insert into goods_detail (id,goods_id,name,price,stock,pic) values(1,1,'iphone',8000,80,'iphone.jpg');
insert into goods_detail (id,goods_id,name,price,stock,pic) values(2,2,'小米',1999,5,'小米.jpg');
insert into goods_detail (id,goods_id,name,price,stock,pic) values(3,3,'华为',6888,6,'华为.jpg');
insert into goods_detail (id,goods_id,name,price,stock,pic) values(4,4,'MacBook',18000,15,'MacBook.jpg');
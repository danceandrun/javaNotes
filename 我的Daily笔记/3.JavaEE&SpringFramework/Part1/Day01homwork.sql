-- 提供cskaoyan_user和cskaoyan_user_detail表的sql脚本，在数据库里执行这些sql语句

DROP TABLE IF EXISTS `cskaoyan_user_detail`;
CREATE TABLE `cskaoyan_user_detail`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

INSERT INTO `cskaoyan_user_detail` VALUES (1, '110', 'xiaowu@cskaoyan.com', 1);
INSERT INTO `cskaoyan_user_detail` VALUES (2, '120', 'xiaofang@cskaoyan.com', 2);

DROP TABLE IF EXISTS `cskaoyan_user`;
CREATE TABLE `cskaoyan_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `age` int(11) NULL DEFAULT NULL,
  `birthday` datetime(0) NULL DEFAULT NULL,
  `create_date` datetime(0) NULL DEFAULT NULL,
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

INSERT INTO `cskaoyan_user` VALUES (1, '小吴', '小吴爱小芳', 22, '1998-05-13 00:00:00', '2022-03-29 15:43:00', '110');
INSERT INTO `cskaoyan_user` VALUES (2, '小芳', '小芳爱奶茶', 18, '1999-06-20 00:00:00', '2023-03-21 14:19:18', '120');
INSERT INTO `cskaoyan_user` VALUES (3, '刘星', 'liuxing', 12, '2023-02-16 16:30:29', '2023-02-16 16:30:34', '666');
INSERT INTO `cskaoyan_user` VALUES (4, '小雨', 'xiaoyu', 10, NULL, NULL, '666');
INSERT INTO `cskaoyan_user` VALUES (5, '小雪', 'xiaoxue', 15, NULL, NULL, '999');
INSERT INTO `cskaoyan_user` VALUES (23, 'songge', 'niupi', 20, '2021-10-08 16:21:28', NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (25, 'songge', 'yuanzhi', NULL, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (28, '远志', '松哥', 25, '2022-03-28 17:43:50', '2022-03-29 15:43:06', '110');
INSERT INTO `cskaoyan_user` VALUES (29, '天明', 'tianming', 25, '2022-03-29 10:41:52', '2022-03-29 15:43:09', '1866387743');
INSERT INTO `cskaoyan_user` VALUES (30, '雪茄', 'qiezi', 25, '2022-03-29 10:41:52', '2022-03-29 15:43:14', '1866387744');
INSERT INTO `cskaoyan_user` VALUES (31, 'zhangsong', 'yuanzhi', 30, '2022-03-29 10:42:36', NULL, '1234567');
INSERT INTO `cskaoyan_user` VALUES (32, '景天', 'jingtian', 28, '2022-03-29 17:40:06', '2022-03-29 17:24:25', '87654321');
INSERT INTO `cskaoyan_user` VALUES (33, 'songge1', '远志1', 281, '2022-03-30 10:48:07', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (34, 'songge2', '远志2', 282, '2022-03-30 10:48:07', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (35, 'songge3', '远志3', 283, '2022-03-30 10:48:07', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (36, 'songge4', '远志4', 284, '2022-03-30 10:48:07', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (37, 'songge5', '远志5', 285, '2022-03-30 10:55:42', NULL, '123456');
INSERT INTO `cskaoyan_user` VALUES (38, 'songge6', '远志6', 286, '2022-03-30 10:57:19', NULL, '123456');
INSERT INTO `cskaoyan_user` VALUES (39, 'songge1', '远志1', 281, '2022-03-30 11:09:40', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (40, 'songge1', '远志1', 281, '2022-03-30 11:19:03', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (41, 'songge1', '远志1', 281, '2022-03-30 11:23:17', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (42, 'songge2', '远志2', 282, '2022-03-30 11:23:17', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (43, 'songge3', '远志3', 283, '2022-03-30 11:23:17', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (44, 'songge4', '远志4', 284, '2022-03-30 11:23:17', NULL, '11111221');
INSERT INTO `cskaoyan_user` VALUES (45, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (46, 'songge', 'ligenli', 30, '2022-04-29 00:00:00', '2022-04-30 10:27:28', '110');
INSERT INTO `cskaoyan_user` VALUES (47, 'songge', 'niupi', 25, '2022-05-02 00:00:00', NULL, '110');
INSERT INTO `cskaoyan_user` VALUES (48, 'songge', 'niupi', 25, '2022-05-02 00:00:00', '2022-05-02 22:08:06', '110');
INSERT INTO `cskaoyan_user` VALUES (49, 'songge2', 'niupi2', 25, NULL, '2022-05-02 22:52:10', '110');
INSERT INTO `cskaoyan_user` VALUES (50, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (51, 'songge', 'niupi', 25, '2022-06-22 08:00:00', NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (52, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (53, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (54, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (55, '雪茄', 'xuejia', 25, '2022-10-04 16:29:58', '2022-10-04 16:29:58', '110');
INSERT INTO `cskaoyan_user` VALUES (56, '雪茄', 'xuejia', 25, '2022-10-04 16:34:25', '2022-10-04 16:34:25', '110');
INSERT INTO `cskaoyan_user` VALUES (58, 'songge', 'ligenli', NULL, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (59, '松哥', '李艮隶', NULL, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (60, '北海', '长风', 25, NULL, NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (61, 'songge', 'ligenli', 25, '2022-12-22 09:13:17', NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (62, 'songge', 'ligenli', 25, '2022-12-22 09:14:15', NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (63, 'songge', 'ligenli', 25, '2022-12-22 09:46:35', NULL, NULL);
INSERT INTO `cskaoyan_user` VALUES (64, 'songge', 'ligenli', 25, '2022-12-22 09:48:06', NULL, NULL);
 
 
 -- 1.在一次查询中，同时查询出user和user_detail的信息，查询条件为id为1或2
 select * from cskaoyan_user u inner join cskaoyan_user_detail ud on u.id=ud.id;
 -- 2.根据create_date中的年月日为基础统计，每一天的新增用户数量
 select date(`create_date`) as day, count(*) from cskaoyan_user group by date(`create_date`) having day is not null;
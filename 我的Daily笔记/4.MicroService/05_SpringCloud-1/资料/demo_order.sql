/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80030
 Source Host           : localhost:3306
 Source Schema         : demo_order

 Target Server Type    : MySQL
 Target Server Version : 80030
 File Encoding         : 65001

 Date: 02/10/2023 08:44:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_order
-- ----------------------------
DROP TABLE IF EXISTS `tb_order`;
CREATE TABLE `tb_order`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `price` bigint(0) NOT NULL COMMENT '商品价格',
  `num` int(0) NULL DEFAULT 0 COMMENT '商品数量',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_order
-- ----------------------------
INSERT INTO `tb_order` VALUES (1, 1, '双口 & 快充车载充电器', 55, 1);
INSERT INTO `tb_order` VALUES (2, 2, '漫步者砖式蓝牙小音箱', 200, 1);
INSERT INTO `tb_order` VALUES (3, 3, '地平线 8 号旅行箱', 399, 1);

SET FOREIGN_KEY_CHECKS = 1;

/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80030
 Source Host           : localhost:3306
 Source Schema         : test

 Target Server Type    : MySQL
 Target Server Version : 80030
 File Encoding         : 65001

 Date: 13/10/2023 17:41:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_item`;
CREATE TABLE `tb_item`  (
  `id` bigint(0) NOT NULL COMMENT '商品id，同时也是商品编号',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `tm_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '品牌名称',
  `sell_point` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '商品卖点',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商品价格',
  `num` int(0) NULL DEFAULT NULL COMMENT '库存数量',
  `limit_num` int(0) NULL DEFAULT NULL COMMENT '售卖数量限制',
  `image` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `cid` bigint(0) NULL DEFAULT NULL COMMENT '所属分类',
  `status` int(0) NULL DEFAULT 1 COMMENT '商品状态 1正常 0下架',
  `created` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cid`(`cid`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `updated`(`updated`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_item
-- ----------------------------
INSERT INTO `tb_item` VALUES (100023501, '双口 & 快充车载充电器', '绿联', '铝合金机身、双口 & 快充、智能调节', 79.00, 100, 100, 'https://resource.smartisan.com/resource/d4480234a2f24b0ff5acd98288fd902d.jpg,https://resource.smartisan.com/resource/69ebf4ca620e6d5a1bb7cb54741e24d3.jpg,https://resource.smartisan.com/resource/214a422b7d250333bec4398d47eac601.jpg,https://resource.smartisan.com/resource/f512a3c4b97d204555f864d4aa17e7e9.jpg,https://resource.smartisan.com/resource/fc8a5d50ed260d9798cfba39ff5234d0.jpg', 221, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100026701, '原装快充充电器 18W', '苹果', '18W 安全快充、支持主流 QC3.0, MTK PE+2.0 快充协议', 49.00, 100, 100, 'https://resource.smartisan.com/resource/dc53bd870ee64d2053ecc51750ece43a.jpg,https://resource.smartisan.com/resource/83ab82fa6d9637d29d6af79d912ee572.jpg,https://resource.smartisan.com/resource/47461596fad00d37cb7a032a03d79286.jpg,https://resource.smartisan.com/resource/f4f6346bea727862087b4761fc8b01d2.jpg,https://resource.smartisan.com/resource/0286c84dba36577f37591f1af2b97402.jpg', 215, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100026801, 'Smartisan 耳机转接头', '锤子', '即插即用、全面兼容', 19.00, 100, 100, 'https://resource.smartisan.com/resource/45312fb748d54aa2e58a8f4d637e9e65.jpg,https://resource.smartisan.com/resource/1dddddf6488ba89d592a37e9db93ffa2.jpg,https://resource.smartisan.com/resource/31b291594192c568b9fff9190a0d8f44.jpg,https://resource.smartisan.com/resource/561c002e74f6a5982dfaf3b4a44c9af4.jpg', 214, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100036501, '畅呼吸除霾除甲醛高效复合滤芯', '小米', '精选双层防护材质，过滤更精细，去味更有效', 699.00, 100, 100, 'https://resource.smartisan.com/resource/00eee903962f17d75950397843117e6e.jpg,https://resource.smartisan.com/resource/7a1f7380f2f2851fe133bd84115c42fe.jpg,https://resource.smartisan.com/resource/e2cd33328fe96214c2bff3ef0652350a.jpg', 228, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100039702, 'Converse 帆布鞋', '匡威', '用于支付测试使用', 1.00, 100, 100, 'https://resource.smartisan.com/resource/578116bddf1d170c89e9af7ba5073fb6.jpg,https://resource.smartisan.com/resource/ebb01298315bf2ebdb6b21ee2c8e4237.jpg,https://resource.smartisan.com/resource/bd634d820859032b4c0f7a521eda486d.jpg,https://resource.smartisan.com/resource/51958a0a771f24e405f1b5de98108528.jpg,https://resource.smartisan.com/resource/e8791dd06c1e964d89436407f8827fe4.jpg', 236, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100040501, '畅呼吸智能空气净化器 · 超级除甲醛版', '小米', '800CADR 超强空气净化能力，400CADR超强除甲醛能力，app远程操控，多种专业滤芯可供选择', 2999.00, 100, 100, 'https://resource.smartisan.com/resource/71432ad30288fb860a4389881069b874.png,https://resource.smartisan.com/resource/6ff92d05a3bfab4fad489ca04d3eea5a.png', 226, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100040607, '坚果 3', '坚果', '坚果 3 意外碎屏保修服务（碎屏险）', 2999.00, 100, 100, 'https://resource.smartisan.com/resource/13e91511f6ba3227ca5378fd2e93c54b.png,https://resource.smartisan.com/resource/fac4130efc39ed4db697cc8d137890e9.png,https://resource.smartisan.com/resource/91dc3f577960e30ca11b632e7b6ebd0f.png,https://resource.smartisan.com/resource/61586b59793ac16bd973010aecad2ca9.png', 210, 1, '2019-08-12 13:06:26', '2019-08-12 13:06:28');
INSERT INTO `tb_item` VALUES (100042203, '坚果“电池形电池”移动电源', '坚果', 'Type-C 接口、轻巧便携、多重电路保护', 49.00, 100, 100, 'https://resource.smartisan.com/resource/33954b3f6a2f1614c5482ef130af9cc8.jpg,https://resource.smartisan.com/resource/1910dba5f999debab84c97c55845c74d.jpg,https://resource.smartisan.com/resource/3e62068911a78fb4b7c4ac20520a5216.jpg,https://resource.smartisan.com/resource/0329e3f7d4fd64659b36a9f3726ccf37.jpg', 218, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100042801, 'Smartisan 半入耳式耳机', '锤子', '经典配色、专业调音、高品质麦克风', 59.00, 100, 100, 'https://resource.smartisan.com/resource/ce632bd67465027861707ec221b37c2d.jpg,https://resource.smartisan.com/resource/10525c4b21f039fc8ccb42cd1586f5cd.jpg,https://resource.smartisan.com/resource/d14645b66ff52c2e5958cd866a7d91e5.jpg,https://resource.smartisan.com/resource/7a4257950f953d6a7048d72de374530f.jpg,https://resource.smartisan.com/resource/dbe085a6f133b944e4e23bbb515c31ff.jpg', 217, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100046401, '坚果 R1', '坚果', '骁龙 845 处理器 · 光学防抖双摄像头 · 6.17 英寸压力感应屏幕 · 10W快速无线充电功能', 2999.00, 100, 100, 'https://resource.smartisan.com/resource/06c2253354096f5e9ebf0616f1af2086.png', 210, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100047001, 'OPPO QuickCharge 4+ 快速充电器', 'OPPO', '全面兼容的 18W 快速充电', 1.00, 100, 100, 'https://resource.smartisan.com/resource/a668d1a5f41b04ece82d76ded1e94d3a.jpg,https://resource.smartisan.com/resource/c2375861762d557f65cf880b00161a41.jpg,https://resource.smartisan.com/resource/630dc5c945e78c0613d872cb83222b9e.jpg', 215, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100047101, '华为 Type-C To Type-C 数据线', '华为', 'TPE 环保材质，PTC 过温保护', 39.00, 100, 100, 'https://resource.smartisan.com/resource/8635cb91f2cdbbc5576e069c52b99412.jpg,https://resource.smartisan.com/resource/a9a02318cb09ab38562092a556d0dedc.jpg', 214, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100051701, '坚果 Pro 2S', '坚果', '双系统，无限屏，骁龙 ™ 710 处理器 · 前置 1600 万像素摄像头 · 6.01 英寸全高清全面屏 · AI 通话降噪 · 人脸解锁 + 指纹解锁 ', 1798.00, 100, 100, 'https://resource.smartisan.com/resource/b07b9765e272f866da6acda4ee107d88.png', 210, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100052801, '漫步者砖式蓝牙小音箱', '漫步者', '一款设计出色、音质出众的随身音箱', 149.00, 100, 100, 'https://resource.smartisan.com/resource/6e96ccea3bd56bdd2243eb20330cec30.jpg,https://resource.smartisan.com/resource/a99de61d502b2f29b4a6d847751cf478.jpg,https://resource.smartisan.com/resource/3f6594f3537db91a3a4d6196111429df.jpg,https://resource.smartisan.com/resource/9e45ff0ce5d60627f0b07b1df4c56ed6.jpg,https://resource.smartisan.com/resource/830389bcd0e66569acd5ce05a304a3ea.jpg', 223, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100053001, '三星彩虹数据线', '三星', '七彩配色随机发货，为生活增添一份小小惊喜', 19.00, 100, 100, 'https://resource.smartisan.com/resource/82aab62886740f165a3631ce6cffe895.jpg', 214, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100053202, '地平线 8 号商务旅行箱', '迪柯文', '为了野心和远方', 999.00, 100, 100, 'https://resource.smartisan.com/resource/d1dcca9144e8d13ffb33026148599d0a.png', 238, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100053312, '地平线 8 号旅行箱', '迪柯文', '简约设计、德国拜耳 PC 箱体', 299.00, 100, 100, 'https://resource.smartisan.com/resource/db4895e45ee6f3339037dbf7200e63f2.png', 238, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100055301, 'Smartisan 快充移动电源 10000mAh', '锤子', '10000mAh 双向快充、轻盈便携、高标准安全保护', 129.00, 100, 100, 'https://resource.smartisan.com/resource/b7105b0d819e610a9c38d7ca2a813e58.jpg,https://resource.smartisan.com/resource/e47687c8288b324fb997c5bd7b709e80.jpg,https://resource.smartisan.com/resource/c933dd520c84c32edd9f50f664ec53ff.jpg,https://resource.smartisan.com/resource/1ae4fda7154eb92196f78fe9efb0c25f.jpg,https://resource.smartisan.com/resource/422ec86b9924bd5e45d5caa3ba1eaf7d.jpg', 218, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100055601, '各色DNA检测套装', '华大基因', '国内唯一聚焦于行为-基因关联性分析的基因检测解读', 499.00, 100, 100, 'https://resource.smartisan.com/resource/9bffe702b1f0aea221b1f18ddf886958.jpg,https://resource.smartisan.com/resource/30a1fce6a4280847eebf1b412fca39b0.jpg,https://resource.smartisan.com/resource/6681f43f88b9d867a0f33639cbeb47bf.jpg,https://resource.smartisan.com/resource/4fa597703a83cf326713faf2648744ac.jpg,https://resource.smartisan.com/resource/760637b38ba5ec5792e1e99c0d893462.jpg', 263, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100057401, '太平鸟T恤 迪特拉姆斯', '太平鸟', 'nice买吧', 149.00, 100, 100, 'https://resource.smartisan.com/resource/005c65324724692f7c9ba2fc7738db13.png,https://resource.smartisan.com/resource/5068afef4f8866fae065d8c0d450e244.png,https://resource.smartisan.com/resource/a8dfe8f52dfb15c17e2e5c504c7ae2c6.png,https://resource.smartisan.com/resource/d6a6c06e5b51f0c18d8bfc45318163ea.png,https://resource.smartisan.com/resource/46724a81b037d1eca31d665c223b77a1.png', 231, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100057501, '李宁 T恤 毕加索', '李宁', 'nice买吧', 149.00, 100, 100, 'https://resource.smartisan.com/resource/e9cd634b62470713f6b9c5a6065f4a10.jpg,https://resource.smartisan.com/resource/2ea973de25dffab6373dbe5e343f76c8.jpg,https://resource.smartisan.com/resource/57c12d9b6788d005341fe4aefd209fab.jpg,https://resource.smartisan.com/resource/25fb00a88fe6ababcd580a2cf0a14032.jpg,https://resource.smartisan.com/resource/bab385bd6811378389a12d7b7254ed7e.jpg', 231, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100057601, '中国李宁T恤 皇帝的新装', '中国李宁', 'nice买吧', 149.00, 100, 100, 'https://resource.smartisan.com/resource/d9586f7c5bb4578e3128de77a13e4d85.png,https://resource.smartisan.com/resource/07f77245d0f5f78f8ea580e181ec3dce.jpg,https://resource.smartisan.com/resource/0c9c397c8ac68a2ad327e1da8a5cb7d0.jpg,https://resource.smartisan.com/resource/154b35897ed3c1cb8dc1c7aae7b88f1f.jpg,https://resource.smartisan.com/resource/4a1686f2fde86e0aaac49c92395d4b32.jpg', 231, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');
INSERT INTO `tb_item` VALUES (100057701, '361度 T恤 丑小鸭', '361度', 'nice买吧', 149.00, 100, 100, 'https://resource.smartisan.com/resource/c23837ddfa3de0103be11bcbbb744066.png,https://resource.smartisan.com/resource/dad3d8d5ed151ad235ca9215815bc38b.png,https://resource.smartisan.com/resource/95f78a96e20b8e697e9df1c221d585c4.png,https://resource.smartisan.com/resource/33b0c45b3036d2a4267a05d192ccc45f.png,https://resource.smartisan.com/resource/b8bb658cf5cc22f23fb81a4c2ea028ac.png', 231, 1, '2019-07-29 14:37:02', '2019-07-29 14:37:02');

SET FOREIGN_KEY_CHECKS = 1;

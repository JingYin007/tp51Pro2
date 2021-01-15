/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : tp5_pro

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2021-01-15 10:16:18
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tp5_xactivitys
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xactivitys`;
CREATE TABLE `tp5_xactivitys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '活动推荐标题 ，可用于产品详情页广告位',
  `act_img` varchar(500) NOT NULL DEFAULT '0' COMMENT '活动图片',
  `act_tag` varchar(100) NOT NULL DEFAULT '' COMMENT '唯一标识字符串 建议大写',
  `act_type` smallint(6) NOT NULL DEFAULT '1' COMMENT '活动类型,1：为首页活动  2:其他活动',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，数字越小 越靠前',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在 app 首页显示  0：不显示  1：显示',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'app前端显示状态 0：正常，-1已删除',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '文章更新时间',
  `start_time` varchar(20) NOT NULL COMMENT '广告开始投放时间',
  `end_time` varchar(20) NOT NULL COMMENT '广告结束时间',
  PRIMARY KEY (`id`,`act_tag`),
  UNIQUE KEY `act_tag` (`act_tag`) USING BTREE COMMENT '唯一标识索引',
  KEY `select` (`id`,`title`) USING BTREE COMMENT '便于查询'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='活动表\r\n\r\n一般用于显示app首页上的活动专栏，注意status的规定';

-- ----------------------------
-- Records of tp5_xactivitys
-- ----------------------------
INSERT INTO `tp5_xactivitys` VALUES ('1', '特价商品推荐', 'cms/images/imgOne.jpg', 'TJSPTJ', '2', '1', '1', '0', '2020-12-12 12:47:57', '1574125637', '1575090450');
INSERT INTO `tp5_xactivitys` VALUES ('2', '春季特惠商品', 'cms/images/imgTwo.jpg', 'CJTHSPA', '1', '2', '0', '0', '2020-12-12 12:47:58', '1574910600', '1575083403');
INSERT INTO `tp5_xactivitys` VALUES ('3', '生活专区推荐', 'cms/images/imgThree.jpg', 'SHZQTJA', '1', '3', '1', '0', '2020-06-02 19:50:24', '1574910498', '1575083303');

-- ----------------------------
-- Table structure for tp5_xact_goods
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xact_goods`;
CREATE TABLE `tp5_xact_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `act_id` int(11) DEFAULT '0' COMMENT '活动id，对应 表 tp5_xactivitys',
  `goods_id` int(11) DEFAULT '0' COMMENT '参加该活动的商品ID',
  `status` tinyint(2) DEFAULT '0' COMMENT '0 ：正常 -1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COMMENT='活动商品关联表\r\n\r\n';

-- ----------------------------
-- Records of tp5_xact_goods
-- ----------------------------
INSERT INTO `tp5_xact_goods` VALUES ('25', '3', '1', '0');
INSERT INTO `tp5_xact_goods` VALUES ('26', '2', '4', '0');
INSERT INTO `tp5_xact_goods` VALUES ('27', '1', '6', '-1');
INSERT INTO `tp5_xact_goods` VALUES ('28', '1', '3', '-1');
INSERT INTO `tp5_xact_goods` VALUES ('29', '1', '4', '0');
INSERT INTO `tp5_xact_goods` VALUES ('30', '1', '5', '0');

-- ----------------------------
-- Table structure for tp5_xadmins
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xadmins`;
CREATE TABLE `tp5_xadmins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `role_id` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '管理员昵称',
  `picture` varchar(255) NOT NULL DEFAULT '' COMMENT '管理员头像',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '管理员登录密码',
  `created_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态标识 0：无效；1：正常；-1：删除',
  `content` varchar(500) NOT NULL DEFAULT '世界上没有两片完全相同的叶子！' COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `index_role` (`role_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ----------------------------
-- Records of tp5_xadmins
-- ----------------------------
INSERT INTO `tp5_xadmins` VALUES ('1', '1', 'moTzxx@admin', 'cms/images/headshot/wuHuang.png', '$2y$10$kMTPK/4eDrK4iYIDNWHW/edPjBp/XSA.vqXMQvuvM1rSuVvi4Wk.m', '2020-09-04 17:01:10', '1', 'HELLO');
INSERT INTO `tp5_xadmins` VALUES ('2', '2', 'baZhaHei@admin', 'cms/images/headshot/baZhaHei.png', '52c59afc073ef974c23497beb7a87266', '2020-10-21 18:02:01', '1', 'HELLO');
INSERT INTO `tp5_xadmins` VALUES ('3', '1', 'niuNengx@admin', 'cms/images/headshot/niuNeng.png', '74cc22bb9abcddc8a1cdafbae1fadc7a', '2020-06-02 19:51:04', '1', 'HELLO');
INSERT INTO `tp5_xadmins` VALUES ('4', '2', 'wuHuang@admin', 'cms/images/headshot/wuHuang.png', '$2y$10$KzNXkl.xJa01iUX2BVu4T.pqCE2yTp68ND2iJLbOgi.NMCNnneb6m', '2020-11-12 19:48:25', '1', '世界上没有两片完全相同的叶子！');

-- ----------------------------
-- Table structure for tp5_xadmin_roles
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xadmin_roles`;
CREATE TABLE `tp5_xadmin_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '角色称呼',
  `nav_menu_ids` text NOT NULL COMMENT '权限下的菜单ID',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `list_order` int(3) unsigned NOT NULL DEFAULT '9' COMMENT '排序 数字越小 越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态标识 -1:删除；  0：失效； 1：正常',
  PRIMARY KEY (`id`),
  KEY `idx` (`list_order`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='管理员角色表';

-- ----------------------------
-- Records of tp5_xadmin_roles
-- ----------------------------
INSERT INTO `tp5_xadmin_roles` VALUES ('1', '终级管理员', '138|139|140|141|1|2|7|6|3|4|5|93|61|76|73|49|50|48|142|67|145|146|147|133|134|151|155|157|156|158|159|', '2020-12-29 19:36:19', '1', '1');
INSERT INTO `tp5_xadmin_roles` VALUES ('2', '初级管理员', '1|2|6|3|4|5|', '2020-11-20 18:25:19', '2', '1');
INSERT INTO `tp5_xadmin_roles` VALUES ('5', '测试管理员', '1|2|3|76|', '2020-11-20 20:36:06', '7', '0');
INSERT INTO `tp5_xadmin_roles` VALUES ('6', 'xxxx', '139|', '2020-11-20 21:55:19', '7', '-1');

-- ----------------------------
-- Table structure for tp5_xad_lists
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xad_lists`;
CREATE TABLE `tp5_xad_lists` (
  `id` int(2) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告自增id',
  `ad_name` varchar(20) NOT NULL DEFAULT '' COMMENT '广告名称',
  `start_time` varchar(20) NOT NULL COMMENT '广告开始投放时间',
  `end_time` varchar(20) NOT NULL COMMENT '广告结束时间',
  `original_img` varchar(500) NOT NULL DEFAULT '' COMMENT '广告图片',
  `list_order` int(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序 数字越小 越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'app前端显示状态 0：正常，-1已删除',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在 app 首页显示  0：不显示  1：显示',
  `ad_tag` varchar(100) NOT NULL DEFAULT '' COMMENT '唯一标识字符串 建议大写',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='广告';

-- ----------------------------
-- Records of tp5_xad_lists
-- ----------------------------
INSERT INTO `tp5_xad_lists` VALUES ('1', '倒计时广告', '2019-07-02 00:00:00', '2019-07-06 00:00:00', 'cms/images/imgFour.jpg', '0', '0', '0', 'DJS');
INSERT INTO `tp5_xad_lists` VALUES ('2', '首屏广告', '2019-07-01 00:00:00', '2019-07-06 00:00:00', 'cms/images/imgOne.jpg', '2', '0', '0', 'SPK');
INSERT INTO `tp5_xad_lists` VALUES ('3', '首屏广告', '2019-07-01 00:00:00', '2019-07-06 00:00:00', 'cms/images/imgTwo.jpg', '0', '0', '1', 'SP');
INSERT INTO `tp5_xad_lists` VALUES ('4', '首屏广告', '2019-07-02 00:00:00', '2019-07-11 00:00:00', 'cms/images/imgThree.jpg', '0', '0', '1', 'SP');

-- ----------------------------
-- Table structure for tp5_xarticles
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xarticles`;
CREATE TABLE `tp5_xarticles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Article 主键',
  `title` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '标题',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '作者ID',
  `created_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序标识 越大越靠前',
  `content` longtext CHARACTER SET utf8mb4 NOT NULL COMMENT '文章内容',
  PRIMARY KEY (`id`),
  KEY `index_title` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- ----------------------------
-- Records of tp5_xarticles
-- ----------------------------
INSERT INTO `tp5_xarticles` VALUES ('1', '这是今年最好的演讲：生命来来往往，来日并不方长', '1', '2020-09-04 20:56:11', '2020-12-13 08:45:03', '0', '<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: #990000;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><strong>余生很贵，经不起浪费</strong></span></span></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><span style=\"color: #843fa1;\">就像三毛所说</span>，</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: #990000;\">我来不及认真地年轻，待明白过来时，只能选择认真地老去</span></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">所以，</span></strong></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">去爱吧，就像从来没有受过伤害一样</span></strong></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">跳舞吧，如同没有任何人注视你一样</span></strong></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">活着吧，如同今天就是末日一样</span></strong></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\">&nbsp;</p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: #990000; font-size: 15px;\"><img src=\"https://timgsa.baidu.com/timg?image&amp;quality=80&amp;size=b9999_10000&amp;sec=1599235079831&amp;di=4e7c08b476267106e7eeefb768964c89&amp;imgtype=0&amp;src=http%3A%2F%2Ft7.baidu.com%2Fit%2Fu%3D1179872664%2C290201490%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D854\" alt=\"\" width=\"117\" height=\"78\" /></span></p>');
INSERT INTO `tp5_xarticles` VALUES ('2', '打败影史第一，它凭什么封神', '2', '2020-09-04 21:16:58', '2020-12-30 16:34:50', '1', '<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">有人说，越在乎，越假装不在乎；越放不下，越假装放得下</span></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px; color: #990000;\">没错。成年人的我们的确有着数不清的佯装，就连感情也难逃此劫</span></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\">&nbsp;</p>\r\n<p style=\"margin: 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">日本电影票房第一的宝座易位了。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">12月26日，《鬼灭之刃无限列车篇》的票房达到了<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">317.2亿日元</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">超过了《千与千寻》的316.8亿日元（含复映），<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">成为日本影史最卖座的电影</span>！</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics4.baidu.com/feed/b8389b504fc2d5629c5260a8f02241e877c66cd3.jpeg?token=38be3a5725091fbbd308dc139c81c674&s=378D46A61A5748C624BBF9A90300D01A\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在此之前，《千与千寻》已经在这个位置上霸占了<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">18年</span>之久。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">18年来，没有一部作品能够望其项背。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics0.baidu.com/feed/3c6d55fbb2fb4316ac6adfb13597972408f7d3bb.jpeg?token=1549a09b753414207c9bb285066f6c2f&s=FA9016C01E213A1D3E9D8580030070DB\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">甚至连爬上300亿日元票房这个档的，都不曾有过。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">2016年的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">《你的名字。》</span>曾一度势头强劲，却直到最后都仍与其有着50多亿日元的差距。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics4.baidu.com/feed/e7cd7b899e510fb3a30f1143cf001992d0430c8e.jpeg?token=159047b681f4c537e4e799c4748f76fd&s=B2A467A15C10F9CE04109D500300D0B9\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》剧场版自今年10月上映以来，就呈现爆炸式的票房增长速度。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">单日、单周等票房记录，能打破的基本都打破了一遍。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">10天，破100亿日元；</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">24天，破200亿<span class=\"bjh-strong\">日元</span>；</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">59天，破300亿<span class=\"bjh-strong\">日元</span>&hellip;&hellip;</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">72天，成为影史第一。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而2001年上映的《千与千寻》，则是在超过1年的长期放映下取得的成绩。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">对比之下，《鬼灭之刃》完全是碾压级的票房增长势头。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/024f78f0f736afc3f6c089fca62a3ac3b6451211.jpeg?token=fcc27ef3d153d8b341834e76b41ba920&s=4C92EC1B199860CA58F184DA0300D033\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">完全不在一个档的曲线斜率</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">对于从10月份到现在的日本电影院来说，排片变成了极其简单的一件事。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">分为《鬼灭之刃》与「其他作品」即可。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics1.baidu.com/feed/279759ee3d6d55fb66c739067b119e4d20a4dd4c.jpeg?token=d256e0f5ab95b77828b2b5a9a594eb99&s=C60227E3C6472CEE5B24393A0300E0D1\" width=\"480px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">作为一部现象级的作品，它早已在日本社会形成了一种<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「鬼灭效应」</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">全国上下对这部动漫，可以说是无人不知，无人不晓，无人不谈。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">就连日本新任首相<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">菅义伟</span>在国会发言时，都玩起了《鬼灭之刃》的梗。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">将自己的答询称为「全集中之呼吸」（《鬼灭之刃》中惯用招式名）。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics3.baidu.com/feed/8d5494eef01f3a296d798e878e166d365d607c84.jpeg?token=1fb387089ca1af63464aee6893c56cd1&s=F6A39747CA1265D6D48C49BA0300D043\" width=\"480px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在日常生活中也随处可见《鬼灭之刃》的影子。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">从便利店常见的便当。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/4d086e061d950a7bfac939461ce2b3def3d3c96b.jpeg?token=31286907b354696a2387496b8c8453ca&s=3B016B81160246E55395CC9003003091\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">到只有自己看得见的私密内衣。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/b219ebc4b74543a95f72f7f206245b85b9011459.jpeg?token=88519424c8cebac3d545051acdd819a2&s=0325A5AE4B971BE912048CC10300F0B3\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">再到和主题有联系的刀&mdash;&mdash;虽然只是菜刀。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/a5c27d1ed21b0ef495ebf26dcbf780dd81cb3eb8.jpeg?token=6179a55ee08343904e5ca7947718af67&s=A22049A5906286EE0E19D5050300F0C0\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">商家们是想尽办法蹭上关于它的热点。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">效果还真就很显著。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">日本咖啡品牌DyDo推出鬼灭合作款，截至今年10月底销量就突破5千万罐。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">相较去年同一时间的销售量成长了149.5％，是一场教科书级别的利用热点进行营销的例子。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics5.baidu.com/feed/0df3d7ca7bcb0a46ba5daa097d5027236b60afb9.jpeg?token=d1ba04790e42e02dc83cce11aa51634d&s=172A6EA79E523CC0580DE97003004051\" width=\"499px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">甚至对旅游业都有影响。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">位于长崎的「灶门神社」因为和鬼灭主人公灶门炭治郎撞姓，所以突然成了「鬼灭圣地」。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">本来门可罗雀的神社一时间变得人头攒动。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">一脸懵逼的当地村民弄清事情缘由后也大方接受，主动给鬼灭立了两尊「神像」。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/63d0f703918fa0ec22654f7030a488e93c6ddbe3.jpeg?token=6dafa905f4eb64d85b2630853f83e950&s=1081F21154D0BDD04E2D9E8203007005\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">就是这画风过于邪典了</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">常见的cosplay就更不用说了。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">其中，尤以对女主角祢豆子的「摧残」最为突出。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics6.baidu.com/feed/6159252dd42a2834bf3ee1c54e8618ed14cebf1b.jpeg?token=61cecf9d4599da78bcf9f2dd4f71a169&s=AD548B4ECCE170965B81ADB203008016\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为这一角色萌点十足，并且时刻叼着竹筒，极具辨识度。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">所以形成只要叼着竹筒，「万物皆可祢豆子」的局面。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/8601a18b87d6277fb41f02573e0bce37e924fc0e.jpeg?token=479923d2ae53fb9b12ff197a293e9cd8&s=9238718480680D1312B55C9F0300D092\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">不要过来啊...</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">许多明星大咖，也都公开表示自己对这部漫画的喜爱。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">如73岁的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">北野武</span>，就在最近的电视节目上cos了动画男主。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://tukuimg.bdstatic.com/scrop/f2bc5166231ec022bdab78d391c45c55.gif\" width=\"400px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">有点想看北野武拍《鬼灭之刃》真人版(辣眼睛)</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》，当真是完全融入了当下的日本社会之中。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这种盛况，超出了所有人的想象。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">到底这部作品拥有怎样的魅力，能够获得如此巨大的成功？</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">今天，鱼叔与大家细细道来。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics6.baidu.com/feed/242dd42a2834349b16c703f8dfd9c4c937d3be40.jpeg?token=64e87872fbdca3f3e8062ba354cd74b0&s=5AA834624B6347241CD5D1DA0000C0B1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》的故事并不复杂。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">日本大正时期，民间依然流传着恶鬼会在太阳下山后，出没食人的传说。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">也有着专门的猎鬼人四处斩杀恶鬼，保护人类的安全。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/cb8065380cd7912377fe05b3b8078885b3b78092.jpeg?token=a32e11fbb985dd91e7c6f92a5a13562e&s=2468FA06D0E3E4B43DA5B0A203003017\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">猎鬼人的组织「鬼杀队」</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">男主<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">炭治郎</span>一家深居山林，以卖炭为生。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在父亲去世后，家境越发贫苦。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但兄弟姐妹相互扶持，过得也倒是平凡而幸福。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics6.baidu.com/feed/3ac79f3df8dcd100fe605a2d65b89617b8122ffc.jpeg?token=d86f2f3d9b39657c56f6a14cfcdf5e7c&s=4908CE1950637EA0201CDCCE030080E1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">直到有一天，炭治郎外出卖炭归来，发现家中惨遭恶鬼袭击。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">母亲和四个弟妹全部被杀，只剩一个妹妹<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">祢豆子</span>生还。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但她也异变成了一只恶鬼。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/a5c27d1ed21b0ef4a5a19d9bc8f780dd80cb3e60.jpeg?token=34e4acfa64b3e3fc5931a28254b83fad&s=50CBB944DE760894008484880300A092\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">恶鬼一饿，就要食人。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">奇迹的是，祢豆子尚存理智人性，扼制住了自己的杀戮欲。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而炭治郎为了让妹妹变回人样，同时寻找杀死家人的恶鬼并讨伐，带着妹妹踏上了漫长的路程。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">并在猎鬼人的指引下，苦习剑术，立志成为猎鬼组织「鬼杀队」的一员。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics0.baidu.com/feed/a1ec08fa513d2697a5e4726443c863fc4316d88b.jpeg?token=0fd550b3b674051aad917c5d9b1d6e6c&s=0EA5D50442137DD680B29CC80300A099\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">可以看出，《鬼灭之刃》属于非常单纯的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">少年热血漫画</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">简单说来，就是运用最最最经典、传统的「千面英雄」模式。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">突遭变故的主角，告别日常生活，进入全新领域学习成长。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">一路升级打怪，结识伙伴，与邪恶战斗到底。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">主题简洁而明确，不追求故弄玄虚的设定，也不经营复杂莫测的反转。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">有点「返璞归真」的意思。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics5.baidu.com/feed/a9d3fd1f4134970aaa60113883f900cfa7865d54.jpeg?token=d73a7dbbc087f44b18b9a1c278b3c0f5&s=CC7239C41B37B6D214CDCC8703006093\" width=\"533px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为它始终聚焦于主角的冒险与成长，让观众能感同身受的看到一个英雄的诞生。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">古往今来，无数英雄传说都是用这种方式去讲述。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">日式热血漫，同样如此。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">从《龙珠》《圣斗士星矢》到《火影忍者》《海贼王》。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">主角千人一面，都是那永不服输、遇强则强、善良真诚的少年。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而《鬼灭之刃》，正是这一形式的杰出继承者。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics4.baidu.com/feed/4e4a20a4462309f7571a1638643dddf4d7cad65a.jpeg?token=ed637467f62b08f169d0c85f3fd2d0b5&s=470E6FAE88D27DEDD21DDD6203006011\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但同时，与老一代的热血漫相比，《鬼灭之刃》也有着自己的扬弃。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">那就是，<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">足够短</span><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">绝不拖泥带水，打个没完没了。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">早一批热血漫虽然经典，但追起来真叫人等晕、累坏。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">背景过于宏大，人物过于繁杂，Boss打完一个又来一个。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">太长就意味着不好掌控，不是所有情节都能有叙事效率，不是所有人物都能塑造好，也不是所有坑都能填上。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">即使是《火影忍者》这样的杰作，也难免有注水、烂尾之嫌。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/2cf5e0fe9925bc3104ae6e0549ec5cb6ca137072.jpeg?token=6a28830a5f197cf078c175419a222eef&s=B58066B110024EF572B5654D03009060\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》选择了做减法。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">原著漫画从2016年开始连载，到今年5月已经完结，<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">四年总计205话</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">相比之下，20年前开始连载的《海贼王》如今刚发表到了第1000话。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">对于现在新一代年轻读者来说，已经很难有耐心再去从头开始追起。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/35a85edf8db1cb13a573c52fcb67874992584bab.jpeg?token=4fa7ca13c91eb8c9b7286c797b49d0f7&s=9FB7BFAA1AB3FFE91CAD0D7E03005019\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》从鬼王开场杀害炭治郎一家，到最后炭治郎和伙伴们一起剿灭鬼王。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">Boss从来不遮遮掩掩，主角也一直目标明确。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">双方在动画第七集就直接接触了。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://tukuimg.bdstatic.com/scrop/4840614a8092e9e151b618939e31b4d4.gif\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">就是一条线走到底的畅快复仇戏码。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">作者并没有闲心去扯其他有的没的，或是给主角安排点支线任务。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这完全符合现在大众对于日常娱乐快节奏化的需求。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/2f738bd4b31c870102f00ed4314c4f280708ff7d.jpeg?token=b415a1d9d4c8ad7cb8d96ca359e63828&s=4E8C6C865D003B57CED598AC03006043\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">短，并不意味着质量不足。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》非常巧妙地结合经典作品的优势。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">一方面，<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">战斗过程极其残酷</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">作者对自己笔下的人物从不手软，有战斗就有牺牲。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">伴随着剧情的深入，是主角团大量的伤亡。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">纵使是鬼杀队的一众精英，面对强劲的恶鬼，说挂就挂。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这点就和《进击的巨人》十分相似。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/024f78f0f736afc3b67c49a6a62a3ac3b64512bf.jpeg?token=131fd9c46813caea8a70f6fe6e6255fc&s=E6D21EC17DC91A4D14C49D14030080C3\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《进击的巨人》</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">另一方面，<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">人物情感细腻丰富</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》并非一味靠角色的死亡去堆叠感官上的刺激。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而是对每一个逝去的个体饱含了哀悼与同情。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">同经典动漫《钢之炼金术师》如出一辙&mdash;&mdash;</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在展现残酷的同时，柔情时刻也必不可少。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics3.baidu.com/feed/5ab5c9ea15ce36d3fdc6fdf62fc0eb80eb50b1f4.jpeg?token=96983e8e4069467ede3643678ccc031a&s=0E4A7A2312E07DBD8D8898C0030070E1\" width=\"480px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《钢之炼金术师》</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">死亡，是有尊严的。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">即使是作为反派而存在的十恶不赦的恶鬼们。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">也会在他们弥留之际，花时间呈现一段有关他们的「回忆杀」。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为《鬼灭之刃》中的鬼，并非先天，都是后天由人转变而来。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/e4dde71190ef76c616303cb98a252cfdae516779.jpeg?token=fc00273eb5609e15bea893d388fb9f19&s=FA21716CD01125DE9E51651D0300D082\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在成为鬼之前，他们多是因为种种原因无法在人类社会继续生存下去的可怜人。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">虽然成为鬼后作恶多端，不可能被原谅，该杀。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但可恨之人必有可悲之苦。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">每当炭治郎斩下恶鬼之头颅，他并不会表现得欢呼雀跃。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">反倒是悲哀怜悯，心有戚戚。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为他明白，人们变为鬼之前活得痛苦。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">成为不老不死、没有感情的怪物后更是一种折磨。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">言曰「杀鬼」，实为「超度」。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这部作品最大的特色，也便在于此。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/a2cc7cd98d1001e9198054c8ad3daaeb55e79777.jpeg?token=5d4086e58ade6673456473dc44da8e2b&s=77A59C441E066F5FD0BF2858030080FA\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/b999a9014c086e0689dea958153baaf30ad1cb6e.jpeg?token=7118e9cb95c2acdd1d89feec5b5e1393&s=5AA83C624B6347241CD5D1DA0000C0B1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">不得不说，《鬼灭之刃》的运气非常好。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为大名鼎鼎的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「飞碟社」(Ufotable)</span>负责了该漫画的动画制作。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">飞碟社一向以精致、华丽、炫酷的画面而闻名。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">旗下的《空之境界》系列、《命运之夜》系列等等，都在动画界有口皆碑。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://tukuimg.bdstatic.com/scrop/b97f875de98b08d2ee8524373f9bd2be.gif\" width=\"500px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《命运之夜》剧场版</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">经费充足，运镜流畅，特效炸裂，实乃业内楷模。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">飞碟社的接手，作用非常关键。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">其实，《鬼灭之刃》原著漫画在连载初期由于画风不突出、剧情平平，非常慢热。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">直到动画版播出的2019年，人气瞬间飙升，粉丝呈爆炸式增长。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">第一季的收视率，几乎就是霸榜的存在。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics4.baidu.com/feed/72f082025aafa40f78ae2ceabd57d24878f01953.jpeg?token=2fa47877544b41239c0248152ef4612b&s=2D747986D54604EF5960A8810300A091\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">「AbemaTV是日本最大的免费网络电视台」</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">动画的爆火，也反过来带动了漫画的销售量。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://pics1.baidu.com/feed/f7246b600c338744197d68ba443c08fed62aa073.jpeg?token=4a475d5ef73420c5d2be642af7c309ff&s=96A7CBA3C0820CEA12297D2B03001048\" width=\"500px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">从2019年开始，<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">《鬼灭之刃》终于打破了《海贼王》对于年度销量第一的13连冠</span><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">实现了累计销量超<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">1亿册</span>的成绩。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">到了2020年，销量更是一骑绝尘，以十倍于第二名的销量碾压夺冠。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics1.baidu.com/feed/bba1cd11728b4710afdc0238d5fd12fafd032309.jpeg?token=7b4cdf736f234ba8d40a417c2380b300&s=8EE4E1165F0C54CE4E496CDA01007032\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">刚开始鱼叔还以为第一第二差不多啊，仔细一看原来是直接多了一位数&hellip;</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">可见，促成「鬼灭效应」的关键，少不了飞碟社的推动。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">动画对原著漫画里打斗场面的升级优化，连原作者看了都叹服不止，热泪盈眶。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://tukuimg.bdstatic.com/scrop/7e0e75a029cbb748c2ade7baf78a2086.gif\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这就使得本就具有特色的招式设计，更加帅气逼人。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">比如，主角炭治郎的招牌剑法「水之呼吸」。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">就创造性地参考了日本传统浮世绘的画风。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">不仅效果绚烂夺目，还极具写意感。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"normal\" style=\"border: 0px; display: block; margin: 0px auto;\" src=\"https://tukuimg.bdstatic.com/scrop/c7ac8d69f331f2207633bc3307d00d2f.gif\" width=\"480px\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这么帅，受到年轻人欢迎是理所当然的。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">网络上，随处可见模仿鬼杀队招式的中二骚年。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics6.baidu.com/feed/34fae6cd7b899e51e2511eea54940834c9950d2f.jpeg?token=b2cb82b6f1d21c474ccaaa435a87907c&s=2A3A6D83924E07EDA689A914010080E0\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">更有特色的地方在于，《鬼灭之刃》对于背景的塑造也同样精细。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">由于整个故事背景是日本大正时期（1912&mdash;1926）。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">对于日本来说，那是一个新旧文化碰撞最为激烈的时代。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">它比前面的明治时代更加开放，更加包容，更加多元化。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">西方文化大量涌入，日本文人、艺术家，接连开创新流派、新风格。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">被冠以<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「大正浪漫」</span>之名。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/f11f3a292df5e0fef865ece94a53e5af5fdf7297.jpeg?token=d739adc09b2fe657d613874d21a59898&s=7620AEE50C4A8E550CD9B00C0300F041\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而与此同时，主角们的身份是持刀的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">武士</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">「武士」和「忍者」，不必多说，可以说是日本最具有代表性的符号了。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics1.baidu.com/feed/14ce36d3d539b600301751d0fc63e42dc75cb7b2.jpeg?token=b3e562f8c79c5d122b5b55ff0f141b1d&s=C6545F8C00625D1F1C1BA1D0030090BB\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">再配合上东亚地区广泛流传的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">妖怪文化</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">造型奇异、诡谲，天马行空，充满想象力。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/7c1ed21b0ef41bd51e3be7d846e950cc39db3d68.jpeg?token=96c4a7d7768ea5c9919d887b0167c640&s=AFCDB844521205D007C6EC940300909B\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">让作品充满了一股日本传统美学的浪漫风格。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">传统文化、民间传说、科技革新、时代骤变&hellip;&hellip;</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这些都在《鬼灭之刃》这一部作品里完美地糅合在一起，形成了一个极具复古情怀的奇幻世界。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而动画化后，出色的场景细节进一步强化了这种<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">怀旧感</span>。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://tukuimg.bdstatic.com/scrop/dd904e971a8378880db6cee041a5d28b.gif\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">鉴于此，所以鬼灭也能收获较为年长的观众。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">许多日本老爷爷老奶奶，都在子孙的影响下，成了《鬼灭之刃》的粉丝。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这是大部分少年动漫想都不敢想的。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">一位87岁老奶奶就在采访中说道：「让我怀念起小时候了。」</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/d31b0ef41bd5ad6e792c1baf96f8e8dcb7fd3c5c.jpeg?token=c027fad30b98c24a11c53a95efbb4905&s=FEF325C50442A74B5C24249C030050C3\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">最后来说关键的一点。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">过去也曾有许多超高人气的动漫IP，但为什么其剧场版就没能大卖呢？</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">因为以往的这些剧场版，大部分是脱离主线之外的番外故事。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">又或者是对TV动画的总结回顾，是纯粉丝向的东西。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics0.baidu.com/feed/83025aafa40f4bfb7dd3283b1b7ca9f7f736181c.jpeg?token=5ebfe2333b4cb7d138d6db6637b3847d&s=D7268CE700410EF21EB1ADB203004003\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《进击的巨人》剧场版皆为TV剧集的精简汇总</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而这部打破纪录的剧场版《鬼灭之刃 无限列车篇》，却完全是第一季剧集的续篇。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">是难得一见的，将主线故事拍成的剧场版。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">剧情承前启后，忠实原著，自然质量得到保障。</span></span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://tukuimg.bdstatic.com/scrop/f6f763e85f18944873d1c5c851bd3567.gif\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这说明，制片方并非是看着漫画、动画剧集火爆，就想着随意出个剧场版捞上一笔。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而是有态度、有规划地打造一部内容全新的、质量上乘的动画电影。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">虽然鬼灭剧场版在国内迟迟未能定档，我们还不能一睹为快。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但透过已出的漫画，我们可以知道，这部剧场版的剧情是影响主角团后期成长的关键内容。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">所以，不看这部剧场版，会很大程度上影响后面第二季的观感。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/8601a18b87d6277f67d83474310bce37e824fc6b.jpeg?token=77a3a9500e0ada280cb6235d411eca94&s=CA927D8A178445EDD26D2DD20200D0B2\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">有了以上多种因素的糅合加成，这部《鬼灭之刃 无限列车篇》自然拥有了破纪录的实力保障。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/6f061d950a7b020895d5442377ea23d4562cc88b.jpeg?token=6d8578a87a7129c74d69355a569293b4&s=5AAC3C624B6347241CD5D1DA0000C0B1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">吹了那么多，似乎《鬼灭之刃》完美无瑕。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">事实当然并非如此。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">它还是存在着一些不足，也有部分人物塑造不到位，挖下的坑没填好的问题。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而且，从前也并非没有高质量的剧场版，比如同样有着庞大基本盘的《海贼王》。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/ca1349540923dd546a0dedddc73a62d99d8248c7.jpeg?token=ca60e327fb89817235722447808f27cd&s=CF5414C6284108D43E6368B20300D01A\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">其第十部剧场版《强者天下》口碑极好，至今豆瓣评分高达8.7。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但也没能成为最特殊的那一个。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">《鬼灭之刃》能够荣登影史第一，肯定还有着来自外部的原因。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">犹记得十多年前，日漫的风潮比现在更甚。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">所谓的「三大民工漫」火得无以复加，认识的小伙伴几乎全都在追。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">还非要相互比个高下。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics1.baidu.com/feed/0df3d7ca7bcb0a46867256977d5027236a60af83.jpeg?token=897ce233fa5f3fd1e0fff8b8128f66e5&s=2CE0EA071CDA05FF176C2D9A01009092\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但这几年来，动漫却逐渐朝着越发小众的方向发展。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">所谓「二次元」和「三次元」间的壁垒在肉眼可见地不断扩大。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">真正优秀的作品变得越来越少。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">无处不在显示，日漫正在式微。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">2015年，著名动画导演<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">庵野秀明</span>（代表作《EVA》）曾在采访中，语出惊人：</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">「日本动画行业正陷入低谷，它的巅峰已过，正在衰落，可以说是到了日落西山的状态&hellip;&hellip;别说再坚持20年，我看大概还有5年就不错了吧。」</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/f3d3572c11dfa9ec9d2d488e74e32604908fc1e6.jpeg?token=781615a850e0d5e64e061bedd69794ef&s=4D2093194C33089E650838A70300A040\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这个著名的<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「5年药丸论」</span>，在今年年初新冠肺炎的疫情下，变得更令人担忧不已。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">然而，他料到了末日，却没料到救世主。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《鬼灭之刃》在如此艰难的一年里，将日本动画、电影产业从水深火热中拯救了出来。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">日本动画迎来了新的曙光。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/8644ebf81a4c510f13564d2c786af42ad42aa535.jpeg?token=e5a92b75b016d914c77dc6e5b3cba584&s=99706884181337C65418C4BB03008097\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">时势造英雄。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">一部作品的成功既有它自身的实力保障，也符合了大时代下的趋势。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">在日本，动画电影一直是看不上TV动画的。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">比如，吉卜力工作室、新海诚、细田守等著名导演几乎都不再尝试制作TV动画。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但TV动画却不断在试图通过剧场版的方式涉足电影界，打破壁垒。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">之前的代表是《名侦探柯南》。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">它的剧场版一般都制作用心，受到广泛关注，其中三部的票房达到60亿日元以上。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-blockquote\" style=\"display: block; position: relative; font-size: 18px; color: #999999; padding-left: 30px; min-height: 24px;\"><span class=\"bjh-p\">《绀青之拳》93亿；</span><span class=\"bjh-p\">《零的执行人》91亿；</span><span class=\"bjh-p\">《唐红的恋歌》68亿。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但与独立动画电影的票房，还是差上一大个量级。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/060828381f30e92406f1dc0f5b3bbf011d95f776.jpeg?token=3fb56062876006cec0e830c2c55387d5&s=17A6A6AF5C0096C01CA96DAF03007049\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">动画剧集与院线电影的联动，早已是一种媒介合流的必然趋势。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而飞碟社多年来致力于以接近电影制作的标准，打造热门IP。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">已经在《空之境界》《命运长夜》等系列中，积累了大量经验。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这种漫画、动画、电影全线发展的野心，最终在《鬼灭之刃》这里开花结果。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics0.baidu.com/feed/bf096b63f6246b601fd1c9c9fdcbcb4b500fa26e.jpeg?token=fd7b892ea13d53ae9b55d8bd4fbfd06d&s=64D1AB66844131571464A49003008093\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">博采众长。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">既是TV动画的代表，又具有电影的制作水准，还借助了网络时代的东风。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">三位一体，打破壁垒。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这是时代的必然性。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">再加上一点偶然性&mdash;&mdash;</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">因为疫情的影响，邻近档期没有任何有力竞争对手。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">试问，在今年的重压之下，谁会拒绝去影院看一部热血且「好哭」的电影呢！</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/3b292df5e0fe99257f2cb363229b8fd88db17198.jpeg?token=805d9153fd1d3e9311941fb584ccbf4f&s=4680D30F98A32C969E0099C903003091\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">当一切水到渠成，后面的事就简单了。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">身边越来越多的人都看过时，这本身已经成为一种真正破圈的社会性话题。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">否则，在社交上都差人一步。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而那些狂热的粉丝，更是锲而不舍地向周围人推荐这部电影。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">这种推荐已经被称为<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「鬼灭骚扰」</span>。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">甚至于都骚扰到了宫崎骏老爷子的头上。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/72f082025aafa40f40570585bc57d24879f0198b.jpeg?token=289e0713edded7a0612a652ba913ab3e&s=9F9E6F815A21329E3600C085030010A3\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">当时，《鬼灭之刃》的票房还未登顶，但势头太猛，超过《千与千寻》指日可待。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">记者追到宫崎骏家门口，询问他的看法。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">专注于捡垃圾的宫崎骏不置可否，只关心手上的活儿。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics1.baidu.com/feed/7c1ed21b0ef41bd5e74f7daa4be950cc39db3d0e.jpeg?token=0692535772dea8d9bff6b52103b77e8c&s=2BE0C3045AAC844F5C49F407000070C1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">作为两者共同的粉丝，鱼叔觉得大可不必。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">虽然票房是衡量一部电影成功与否的一大标准，足够吸引吃瓜群众的眼球，但它也不是全部。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">《千与千寻》这样一部偏文艺的作品能统治票房18年已经足够传奇。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而《鬼灭之刃》作为后来者的发挥也实属惊艳。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">两个，都很香！</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/1b4c510fd9f9d72ab398b06fc219f933359bbbfb.jpeg?token=5ddacf64394ad02ace1bb3ed95761f3d&s=3932F4B354137BF1520D017603004073\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">票房，只是「果」。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">会受到太多因素影响而不能确定。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">创作的「因」却永远会是它的前提条件。</span></span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">毕竟，票房纪录这玩意就是要被不断打破的。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">我们真正应该关注的还是作品的质量与内涵。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics5.baidu.com/feed/dc54564e9258d109e249f1f2c76b1db86d814d86.jpeg?token=3dfbb1eb62cf1165323547834a5c01b6&s=54BE31D421B003944B1D19C70300C090\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">能成为创造纪录的作品，创作者的用心不可或缺。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">宫崎骏，一代大师，自不用多说。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而《鬼灭之刃》的作者<span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">吾峠呼世晴</span>，虽然还算不上是大师，但也初露锋芒。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics2.baidu.com/feed/dc54564e9258d1097fc56e84c76b1db86c814d99.jpeg?token=33955a33426b79f48795c5948bca2498&s=713138D592A6D0EC5428CE680300E0F1\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">吾峠呼世晴的自画像是只鳄鱼</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">直到今天，TA的性别都仍未得到官方确定，其他信息更不用说了。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">就是一心作画，一心创作。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">一心给大家带来优秀的作品。</span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics3.baidu.com/feed/c2fdfc039245d6885838db68b1f1ac19d31b24fa.jpeg?token=1d981d570752634bb03114d6632dbbd7&s=E7345FCBC3B481DC5CFDE52203007013\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>\r\n<p style=\"margin: 26px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">超越宫崎骏的动画作品，一定不会和宫崎骏多么相像。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">但一部大受欢迎的作品，一定是击中了这个时代多数人的共鸣。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">努力，担当，温柔，悲悯&hellip;&hellip;这些都是让人铭记的主题。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">而我更喜欢的，则是作者在漫画里反复强调的一句话。</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\">代表的正是日本文化中最受推崇的匠人精神：</span></p>\r\n<p style=\"margin: 22px 0px 0px; padding: 0px; font-size: 16px; line-height: 24px; color: #333333; text-align: justify; font-family: arial; background-color: #ffffff;\"><span class=\"bjh-p\"><span class=\"bjh-strong\" style=\"font-size: 18px; font-weight: bold;\">「集中一点，登峰造极。」</span></span></p>\r\n<div class=\"img-container\" style=\"margin-top: 30px; margin-bottom: 4px; font-family: arial; font-size: 12px; background-color: #ffffff;\"><img class=\"large\" style=\"border: 0px; width: 600px; display: block;\" src=\"https://pics7.baidu.com/feed/6d81800a19d8bc3e798ccdb994b87719a9d345fc.jpeg?token=625bbf17e3d9ac73a232020164011775&s=F71C14C6080306CE66A33D3C03008008\" data-loadfunc=\"0\" data-loaded=\"0\" /></div>');
INSERT INTO `tp5_xarticles` VALUES ('4', '真正在乎你的人，绝不会说这句话', '3', '2020-09-04 21:12:22', '2020-12-12 09:51:29', '0', '                                                                                                                                            <section>\r\n<p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: #333333; color: #333333; text-align: center;\"><strong style=\"font-size: 15px; margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; overflow-wrap: break-word !important;\">在乎你的男人，绝不会说&ldquo;我很忙，没时间&rdquo;</strong></p>\r\n<hr />\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">网上有一段话，<span style=\"color: #e67e23;\"><strong>想陪你吃饭的人酸甜苦辣都想吃</strong></span></span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">想送你回家的人东南西北都顺路，<span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\">想见你的人 24小时都有空&nbsp;</span></span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: #990000; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">生活中没有谁是真的忙，只看他愿不愿你为你花时间</span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: #990000; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">XXXX</span></p>\r\n</section>                                                                                    ');
INSERT INTO `tp5_xarticles` VALUES ('3', '年轻人，我劝你没事多存点钱', '1', '2020-09-04 21:09:10', '2020-09-11 15:46:44', '2', '<section>\r\n<section>\r\n<section>\r\n<section>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; line-height: 1.75em; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: #ffffff; background-color: #990000; font-size: 16px; box-sizing: border-box !important; word-wrap: break-word !important;\"><img src=\"https://search-operate.cdn.bcebos.com/bf38b0d32a3f51e8d06ad1d3c93201a5.jpg\" alt=\"教师节快乐\" width=\"500\" height=\"98\" /></span></p>\r\n<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; line-height: 1.75em; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: #ffffff; background-color: #990000; font-size: 16px; box-sizing: border-box !important; word-wrap: break-word !important;\">你的存款，就是你选择权</span></p>\r\n</section>\r\n</section>\r\n</section>\r\n</section>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: #333333; color: #333333; font-family: -apple-system-font, BlinkMacSystemFont,;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">我曾经和闺蜜去过一次&ldquo;非同凡响&rdquo;的毕业旅游。</span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: #333333; color: #333333; font-family: -apple-system-font, BlinkMacSystemFont,;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">当时的我们还是大学生，每个月的生活费只会有超支，不会有结余，整天理所当然地做着月光族。</span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: #333333; color: #333333; font-family: -apple-system-font, BlinkMacSystemFont,;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">直到我们站在旅行社的门外盯着别人的海报，才猛然发现自己简直就是拿着买大宝的钱，跑去买人家的SK2。</span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; caret-color: #333333; color: #333333;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">最后，不得不厚着脸皮问家里人拿了一笔小小的旅游基金，报了一个超级特惠团</span></p>');
INSERT INTO `tp5_xarticles` VALUES ('11', 'TESTC', '0', '2020-12-12 11:58:55', '2020-12-12 12:43:37', '0', '                                                                                                            <p>QX</p>                                                                        ');

-- ----------------------------
-- Table structure for tp5_xarticle_points
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xarticle_points`;
CREATE TABLE `tp5_xarticle_points` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID 标识',
  `article_id` int(11) NOT NULL COMMENT '文章标识',
  `view` int(11) NOT NULL DEFAULT '0' COMMENT '文章浏览量',
  `keywords` varchar(30) NOT NULL DEFAULT '' COMMENT '关键词',
  `picture` varchar(100) NOT NULL COMMENT '文章配图',
  `abstract` varchar(255) NOT NULL COMMENT '文章摘要',
  `recommend` tinyint(2) NOT NULL DEFAULT '0' COMMENT '推荐标志  0：未推荐   1：推荐',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态标记    ：-1 删除；0：隐藏；1：显示 ',
  `seo_title` varchar(100) NOT NULL DEFAULT '' COMMENT 'seo 优化 标题设置',
  `seo_keywords` varchar(200) NOT NULL DEFAULT '' COMMENT 'seo 优化 关键词设置',
  `seo_description` text NOT NULL COMMENT 'seo 优化 描述信息设置',
  PRIMARY KEY (`id`),
  KEY `index_article` (`article_id`),
  KEY `index_key_words` (`keywords`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='文章 要点表';

-- ----------------------------
-- Records of tp5_xarticle_points
-- ----------------------------
INSERT INTO `tp5_xarticle_points` VALUES ('1', '1', '2', '', 'home/images/article1.png', '如今科技进步，时代向前，人的平均寿命越来越长了。但长长的一生中，究竟有多少时间真正属于我们自己呢？', '1', '1', '', '', '');
INSERT INTO `tp5_xarticle_points` VALUES ('2', '2', '12', '', 'home/images/article2.png', '我的小天地，我闯荡的大江湖，我的浩瀚星辰和璀璨日月，再与你无关；而你的天地，你行走的江湖，你的日月和星辰，我也再不惦念。从此，一别两宽，各生欢喜。', '1', '1', '', '', '');
INSERT INTO `tp5_xarticle_points` VALUES ('4', '4', '0', '', 'home/images/article4.png', '人都是对喜欢的东西最上心。他若真的在乎你，一分一秒都不想失去你的消息，更不会不时玩消失，不会对你忽冷忽热，因为他比你还害怕失去。所有的不主动都是由于不喜欢，喜欢你的人永远不忙。', '0', '1', '', '', '');
INSERT INTO `tp5_xarticle_points` VALUES ('3', '3', '0', '', 'home/images/article3.png', '因为穷，所以要努力赚钱；努力赚钱，就会没时间找对象；找不到对象就算了，钱也没赚多少，难免开始焦虑；一旦焦虑，每天洗头的时候，掉出来的头发会告诉你什么才是真正的“绝望”。', '1', '1', '', '', '');
INSERT INTO `tp5_xarticle_points` VALUES ('5', '5', '0', '', 'upload/20201212/af37b747c21ab61d3bba57e32cbe738c.jpg', 'X', '0', '-1', '', '', '');
INSERT INTO `tp5_xarticle_points` VALUES ('11', '11', '0', '', 'upload/20201212/52642c147048a4cd5d547d10c3addac0.jpg', 'saX', '0', '-1', '', '', '');

-- ----------------------------
-- Table structure for tp5_xbird_express
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xbird_express`;
CREATE TABLE `tp5_xbird_express` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) NOT NULL COMMENT '快递公司 名称',
  `code` varchar(50) NOT NULL COMMENT '快递公司 对应编码 （快递鸟）',
  PRIMARY KEY (`id`),
  KEY `pk_id` (`id`),
  KEY `idx_code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1824 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tp5_xbird_express
-- ----------------------------
INSERT INTO `tp5_xbird_express` VALUES ('1406', '顺丰速运', 'SF');
INSERT INTO `tp5_xbird_express` VALUES ('1407', '百世快递', 'HTKY');
INSERT INTO `tp5_xbird_express` VALUES ('1408', '中通快递', 'ZTO');
INSERT INTO `tp5_xbird_express` VALUES ('1409', '申通快递', 'STO');
INSERT INTO `tp5_xbird_express` VALUES ('1410', '圆通速递', 'YTO');
INSERT INTO `tp5_xbird_express` VALUES ('1411', '韵达速递', 'YD');
INSERT INTO `tp5_xbird_express` VALUES ('1412', '邮政快递包裹', 'YZPY');
INSERT INTO `tp5_xbird_express` VALUES ('1413', 'EMS', 'EMS');
INSERT INTO `tp5_xbird_express` VALUES ('1414', '天天快递', 'HHTT');
INSERT INTO `tp5_xbird_express` VALUES ('1415', '京东快递', 'JD');
INSERT INTO `tp5_xbird_express` VALUES ('1416', '优速快递', 'UC');
INSERT INTO `tp5_xbird_express` VALUES ('1417', '德邦快递', 'DBL');
INSERT INTO `tp5_xbird_express` VALUES ('1418', '宅急送', 'ZJS');
INSERT INTO `tp5_xbird_express` VALUES ('1419', 'TNT快递', 'TNT');
INSERT INTO `tp5_xbird_express` VALUES ('1420', 'UPS', 'UPS');
INSERT INTO `tp5_xbird_express` VALUES ('1421', 'DHL', 'DHL');
INSERT INTO `tp5_xbird_express` VALUES ('1422', 'FEDEX联邦(国内件）', 'FEDEX');
INSERT INTO `tp5_xbird_express` VALUES ('1423', 'FEDEX联邦(国际件）', 'FEDEX_GJ');
INSERT INTO `tp5_xbird_express` VALUES ('1424', '安捷快递', 'AJ');
INSERT INTO `tp5_xbird_express` VALUES ('1425', '阿里跨境电商物流', 'ALKJWL');
INSERT INTO `tp5_xbird_express` VALUES ('1426', '安迅物流', 'AX');
INSERT INTO `tp5_xbird_express` VALUES ('1427', '安邮美国', 'AYUS');
INSERT INTO `tp5_xbird_express` VALUES ('1428', '亚马逊物流', 'AMAZON');
INSERT INTO `tp5_xbird_express` VALUES ('1429', '澳门邮政', 'AOMENYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1430', '安能物流', 'ANE');
INSERT INTO `tp5_xbird_express` VALUES ('1431', '澳多多', 'ADD');
INSERT INTO `tp5_xbird_express` VALUES ('1432', '澳邮专线', 'AYCA');
INSERT INTO `tp5_xbird_express` VALUES ('1433', '安鲜达', 'AXD');
INSERT INTO `tp5_xbird_express` VALUES ('1434', '安能快运', 'ANEKY');
INSERT INTO `tp5_xbird_express` VALUES ('1435', '八达通  ', 'BDT');
INSERT INTO `tp5_xbird_express` VALUES ('1436', '百腾物流', 'BETWL');
INSERT INTO `tp5_xbird_express` VALUES ('1437', '北极星快运', 'BJXKY');
INSERT INTO `tp5_xbird_express` VALUES ('1438', '奔腾物流', 'BNTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1439', '百福东方', 'BFDF');
INSERT INTO `tp5_xbird_express` VALUES ('1440', '贝海国际 ', 'BHGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1441', '八方安运', 'BFAY');
INSERT INTO `tp5_xbird_express` VALUES ('1442', '百世快运', 'BTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1443', '春风物流', 'CFWL');
INSERT INTO `tp5_xbird_express` VALUES ('1444', '诚通物流', 'CHTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1445', '传喜物流', 'CXHY');
INSERT INTO `tp5_xbird_express` VALUES ('1446', '程光   ', 'CG');
INSERT INTO `tp5_xbird_express` VALUES ('1447', '城市100', 'CITY100');
INSERT INTO `tp5_xbird_express` VALUES ('1448', '城际快递', 'CJKD');
INSERT INTO `tp5_xbird_express` VALUES ('1449', 'CNPEX中邮快递', 'CNPEX');
INSERT INTO `tp5_xbird_express` VALUES ('1450', 'COE东方快递', 'COE');
INSERT INTO `tp5_xbird_express` VALUES ('1451', '长沙创一', 'CSCY');
INSERT INTO `tp5_xbird_express` VALUES ('1452', '成都善途速运', 'CDSTKY');
INSERT INTO `tp5_xbird_express` VALUES ('1453', '联合运通', 'CTG');
INSERT INTO `tp5_xbird_express` VALUES ('1454', '疯狂快递', 'CRAZY');
INSERT INTO `tp5_xbird_express` VALUES ('1455', 'CBO钏博物流', 'CBO');
INSERT INTO `tp5_xbird_express` VALUES ('1456', '承诺达', 'CND');
INSERT INTO `tp5_xbird_express` VALUES ('1457', 'D速物流', 'DSWL');
INSERT INTO `tp5_xbird_express` VALUES ('1458', '到了港', 'DLG ');
INSERT INTO `tp5_xbird_express` VALUES ('1459', '大田物流', 'DTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1460', '东骏快捷物流', 'DJKJWL');
INSERT INTO `tp5_xbird_express` VALUES ('1461', '德坤', 'DEKUN');
INSERT INTO `tp5_xbird_express` VALUES ('1462', '德邦快运', 'DBLKY');
INSERT INTO `tp5_xbird_express` VALUES ('1463', '大马鹿', 'DML');
INSERT INTO `tp5_xbird_express` VALUES ('1464', 'E特快', 'ETK');
INSERT INTO `tp5_xbird_express` VALUES ('1465', 'EWE', 'EWE');
INSERT INTO `tp5_xbird_express` VALUES ('1466', '快服务', 'KFW');
INSERT INTO `tp5_xbird_express` VALUES ('1467', '飞康达', 'FKD');
INSERT INTO `tp5_xbird_express` VALUES ('1468', '富腾达  ', 'FTD');
INSERT INTO `tp5_xbird_express` VALUES ('1469', '凡宇货的', 'FYKD');
INSERT INTO `tp5_xbird_express` VALUES ('1470', '速派快递', 'FASTGO');
INSERT INTO `tp5_xbird_express` VALUES ('1471', '丰通快运', 'FT');
INSERT INTO `tp5_xbird_express` VALUES ('1472', '冠达   ', 'GD');
INSERT INTO `tp5_xbird_express` VALUES ('1473', '国通快递', 'GTO');
INSERT INTO `tp5_xbird_express` VALUES ('1474', '广东邮政', 'GDEMS');
INSERT INTO `tp5_xbird_express` VALUES ('1475', '共速达', 'GSD');
INSERT INTO `tp5_xbird_express` VALUES ('1476', '广通       ', 'GTONG');
INSERT INTO `tp5_xbird_express` VALUES ('1477', '迦递快递', 'GAI');
INSERT INTO `tp5_xbird_express` VALUES ('1478', '港快速递', 'GKSD');
INSERT INTO `tp5_xbird_express` VALUES ('1479', '高铁速递', 'GTSD');
INSERT INTO `tp5_xbird_express` VALUES ('1480', '汇丰物流', 'HFWL');
INSERT INTO `tp5_xbird_express` VALUES ('1481', '黑狗冷链', 'HGLL');
INSERT INTO `tp5_xbird_express` VALUES ('1482', '恒路物流', 'HLWL');
INSERT INTO `tp5_xbird_express` VALUES ('1483', '天地华宇', 'HOAU');
INSERT INTO `tp5_xbird_express` VALUES ('1484', '鸿桥供应链', 'HOTSCM');
INSERT INTO `tp5_xbird_express` VALUES ('1485', '海派通物流公司', 'HPTEX');
INSERT INTO `tp5_xbird_express` VALUES ('1486', '华强物流', 'hq568');
INSERT INTO `tp5_xbird_express` VALUES ('1487', '环球速运  ', 'HQSY');
INSERT INTO `tp5_xbird_express` VALUES ('1488', '华夏龙物流', 'HXLWL');
INSERT INTO `tp5_xbird_express` VALUES ('1489', '豪翔物流 ', 'HXWL');
INSERT INTO `tp5_xbird_express` VALUES ('1490', '合肥汇文', 'HFHW');
INSERT INTO `tp5_xbird_express` VALUES ('1491', '辉隆物流', 'HLONGWL');
INSERT INTO `tp5_xbird_express` VALUES ('1492', '华企快递', 'HQKD');
INSERT INTO `tp5_xbird_express` VALUES ('1493', '韩润物流', 'HRWL');
INSERT INTO `tp5_xbird_express` VALUES ('1494', '青岛恒通快递', 'HTKD');
INSERT INTO `tp5_xbird_express` VALUES ('1495', '货运皇物流', 'HYH');
INSERT INTO `tp5_xbird_express` VALUES ('1496', '好来运快递', 'HYLSD');
INSERT INTO `tp5_xbird_express` VALUES ('1497', '皇家物流', 'HJWL');
INSERT INTO `tp5_xbird_express` VALUES ('1498', '捷安达  ', 'JAD');
INSERT INTO `tp5_xbird_express` VALUES ('1499', '京广速递', 'JGSD');
INSERT INTO `tp5_xbird_express` VALUES ('1500', '九曳供应链', 'JIUYE');
INSERT INTO `tp5_xbird_express` VALUES ('1501', '急先达', 'JXD');
INSERT INTO `tp5_xbird_express` VALUES ('1502', '晋越快递', 'JYKD');
INSERT INTO `tp5_xbird_express` VALUES ('1503', '加运美', 'JYM');
INSERT INTO `tp5_xbird_express` VALUES ('1504', '景光物流', 'JGWL');
INSERT INTO `tp5_xbird_express` VALUES ('1505', '佳怡物流', 'JYWL');
INSERT INTO `tp5_xbird_express` VALUES ('1506', '京东快运', 'JDKY');
INSERT INTO `tp5_xbird_express` VALUES ('1507', '佳吉快运', 'CNEX');
INSERT INTO `tp5_xbird_express` VALUES ('1508', '跨越速运', 'KYSY');
INSERT INTO `tp5_xbird_express` VALUES ('1509', '跨越物流', 'KYWL');
INSERT INTO `tp5_xbird_express` VALUES ('1510', '快速递物流', 'KSDWL');
INSERT INTO `tp5_xbird_express` VALUES ('1511', '快8速运', 'KBSY');
INSERT INTO `tp5_xbird_express` VALUES ('1512', '龙邦快递', 'LB');
INSERT INTO `tp5_xbird_express` VALUES ('1513', '立即送', 'LJSKD');
INSERT INTO `tp5_xbird_express` VALUES ('1514', '联昊通速递', 'LHT');
INSERT INTO `tp5_xbird_express` VALUES ('1515', '民邦快递', 'MB');
INSERT INTO `tp5_xbird_express` VALUES ('1516', '民航快递', 'MHKD');
INSERT INTO `tp5_xbird_express` VALUES ('1517', '美快    ', 'MK');
INSERT INTO `tp5_xbird_express` VALUES ('1518', '门对门快递', 'MDM');
INSERT INTO `tp5_xbird_express` VALUES ('1519', '迈隆递运', 'MRDY');
INSERT INTO `tp5_xbird_express` VALUES ('1520', '明亮物流', 'MLWL');
INSERT INTO `tp5_xbird_express` VALUES ('1521', '南方', 'NF');
INSERT INTO `tp5_xbird_express` VALUES ('1522', '能达速递', 'NEDA');
INSERT INTO `tp5_xbird_express` VALUES ('1523', '平安达腾飞快递', 'PADTF');
INSERT INTO `tp5_xbird_express` VALUES ('1524', '泛捷快递', 'PANEX');
INSERT INTO `tp5_xbird_express` VALUES ('1525', '品骏快递', 'PJ');
INSERT INTO `tp5_xbird_express` VALUES ('1526', 'PCA Express', 'PCA');
INSERT INTO `tp5_xbird_express` VALUES ('1527', '全晨快递', 'QCKD');
INSERT INTO `tp5_xbird_express` VALUES ('1528', '全日通快递', 'QRT');
INSERT INTO `tp5_xbird_express` VALUES ('1529', '快客快递', 'QUICK');
INSERT INTO `tp5_xbird_express` VALUES ('1530', '全信通', 'QXT');
INSERT INTO `tp5_xbird_express` VALUES ('1531', '荣庆物流', 'RQ');
INSERT INTO `tp5_xbird_express` VALUES ('1532', '七曜中邮', 'QYZY');
INSERT INTO `tp5_xbird_express` VALUES ('1533', '如风达', 'RFD');
INSERT INTO `tp5_xbird_express` VALUES ('1534', '日日顺物流', 'RRS');
INSERT INTO `tp5_xbird_express` VALUES ('1535', '瑞丰速递', 'RFEX');
INSERT INTO `tp5_xbird_express` VALUES ('1536', '赛澳递', 'SAD');
INSERT INTO `tp5_xbird_express` VALUES ('1537', '苏宁物流', 'SNWL');
INSERT INTO `tp5_xbird_express` VALUES ('1538', '圣安物流', 'SAWL');
INSERT INTO `tp5_xbird_express` VALUES ('1539', '晟邦物流', 'SBWL');
INSERT INTO `tp5_xbird_express` VALUES ('1540', '上大物流', 'SDWL');
INSERT INTO `tp5_xbird_express` VALUES ('1541', '盛丰物流', 'SFWL');
INSERT INTO `tp5_xbird_express` VALUES ('1542', '速通物流', 'ST');
INSERT INTO `tp5_xbird_express` VALUES ('1543', '速腾快递', 'STWL');
INSERT INTO `tp5_xbird_express` VALUES ('1544', '速必达物流', 'SUBIDA');
INSERT INTO `tp5_xbird_express` VALUES ('1545', '速递e站', 'SDEZ');
INSERT INTO `tp5_xbird_express` VALUES ('1546', '速呈宅配', 'SCZPDS');
INSERT INTO `tp5_xbird_express` VALUES ('1547', '速尔快递', 'SURE');
INSERT INTO `tp5_xbird_express` VALUES ('1548', '闪送', 'SS');
INSERT INTO `tp5_xbird_express` VALUES ('1549', '盛通快递', 'STKD');
INSERT INTO `tp5_xbird_express` VALUES ('1550', '台湾邮政', 'TAIWANYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1551', '唐山申通', 'TSSTO');
INSERT INTO `tp5_xbird_express` VALUES ('1552', '特急送', 'TJS');
INSERT INTO `tp5_xbird_express` VALUES ('1553', '通用物流', 'TYWL');
INSERT INTO `tp5_xbird_express` VALUES ('1554', '腾林物流', 'TLWL');
INSERT INTO `tp5_xbird_express` VALUES ('1555', '全一快递', 'UAPEX');
INSERT INTO `tp5_xbird_express` VALUES ('1556', '优联吉运', 'ULUCKEX');
INSERT INTO `tp5_xbird_express` VALUES ('1557', 'UEQ Express', 'UEQ');
INSERT INTO `tp5_xbird_express` VALUES ('1558', '万家康  ', 'WJK');
INSERT INTO `tp5_xbird_express` VALUES ('1559', '万家物流', 'WJWL');
INSERT INTO `tp5_xbird_express` VALUES ('1560', '武汉同舟行', 'WHTZX');
INSERT INTO `tp5_xbird_express` VALUES ('1561', '维普恩', 'WPE');
INSERT INTO `tp5_xbird_express` VALUES ('1562', '万象物流', 'WXWL');
INSERT INTO `tp5_xbird_express` VALUES ('1563', '微特派', 'WTP');
INSERT INTO `tp5_xbird_express` VALUES ('1564', '温通物流', 'WTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1565', '迅驰物流  ', 'XCWL');
INSERT INTO `tp5_xbird_express` VALUES ('1566', '信丰物流', 'XFEX');
INSERT INTO `tp5_xbird_express` VALUES ('1567', '希优特', 'XYT');
INSERT INTO `tp5_xbird_express` VALUES ('1568', '新杰物流', 'XJ');
INSERT INTO `tp5_xbird_express` VALUES ('1569', '源安达快递', 'YADEX');
INSERT INTO `tp5_xbird_express` VALUES ('1570', '远成物流', 'YCWL');
INSERT INTO `tp5_xbird_express` VALUES ('1571', '远成快运', 'YCSY');
INSERT INTO `tp5_xbird_express` VALUES ('1572', '义达国际物流', 'YDH');
INSERT INTO `tp5_xbird_express` VALUES ('1573', '易达通  ', 'YDT');
INSERT INTO `tp5_xbird_express` VALUES ('1574', '原飞航物流', 'YFHEX');
INSERT INTO `tp5_xbird_express` VALUES ('1575', '亚风快递', 'YFSD');
INSERT INTO `tp5_xbird_express` VALUES ('1576', '运通快递', 'YTKD');
INSERT INTO `tp5_xbird_express` VALUES ('1577', '亿翔快递', 'YXKD');
INSERT INTO `tp5_xbird_express` VALUES ('1578', '运东西网', 'YUNDX');
INSERT INTO `tp5_xbird_express` VALUES ('1579', '壹米滴答', 'YMDD');
INSERT INTO `tp5_xbird_express` VALUES ('1580', '邮政国内标快', 'YZBK');
INSERT INTO `tp5_xbird_express` VALUES ('1581', '一站通速运', 'YZTSY');
INSERT INTO `tp5_xbird_express` VALUES ('1582', '驭丰速运', 'YFSUYUN');
INSERT INTO `tp5_xbird_express` VALUES ('1583', '余氏东风', 'YSDF');
INSERT INTO `tp5_xbird_express` VALUES ('1584', '耀飞快递', 'YF');
INSERT INTO `tp5_xbird_express` VALUES ('1585', '韵达快运', 'YDKY');
INSERT INTO `tp5_xbird_express` VALUES ('1586', '云路', 'YL');
INSERT INTO `tp5_xbird_express` VALUES ('1587', '增益快递', 'ZENY');
INSERT INTO `tp5_xbird_express` VALUES ('1588', '汇强快递', 'ZHQKD');
INSERT INTO `tp5_xbird_express` VALUES ('1589', '众通快递', 'ZTE');
INSERT INTO `tp5_xbird_express` VALUES ('1590', '中铁快运', 'ZTKY');
INSERT INTO `tp5_xbird_express` VALUES ('1591', '中铁物流', 'ZTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1592', '郑州速捷', 'SJ');
INSERT INTO `tp5_xbird_express` VALUES ('1593', '中通快运', 'ZTOKY');
INSERT INTO `tp5_xbird_express` VALUES ('1594', '中邮快递', 'ZYKD');
INSERT INTO `tp5_xbird_express` VALUES ('1595', '中粮我买网', 'WM');
INSERT INTO `tp5_xbird_express` VALUES ('1596', '芝麻开门', 'ZMKM');
INSERT INTO `tp5_xbird_express` VALUES ('1597', '中骅物流', 'ZHWL');
INSERT INTO `tp5_xbird_express` VALUES ('1598', 'AAE全球专递', 'AAE');
INSERT INTO `tp5_xbird_express` VALUES ('1599', 'ACS雅仕快递', 'ACS');
INSERT INTO `tp5_xbird_express` VALUES ('1600', 'ADP Express Tracking', 'ADP');
INSERT INTO `tp5_xbird_express` VALUES ('1601', '安圭拉邮政', 'ANGUILAYOU');
INSERT INTO `tp5_xbird_express` VALUES ('1602', 'APAC', 'APAC');
INSERT INTO `tp5_xbird_express` VALUES ('1603', 'Aramex', 'ARAMEX');
INSERT INTO `tp5_xbird_express` VALUES ('1604', '奥地利邮政', 'AT');
INSERT INTO `tp5_xbird_express` VALUES ('1605', 'Australia Post Tracking', 'AUSTRALIA');
INSERT INTO `tp5_xbird_express` VALUES ('1606', '比利时邮政', 'BEL');
INSERT INTO `tp5_xbird_express` VALUES ('1607', 'BHT快递', 'BHT');
INSERT INTO `tp5_xbird_express` VALUES ('1608', '秘鲁邮政', 'BILUYOUZHE');
INSERT INTO `tp5_xbird_express` VALUES ('1609', '巴西邮政', 'BR');
INSERT INTO `tp5_xbird_express` VALUES ('1610', '不丹邮政', 'BUDANYOUZH');
INSERT INTO `tp5_xbird_express` VALUES ('1611', 'CDEK', 'CDEK');
INSERT INTO `tp5_xbird_express` VALUES ('1612', '加拿大邮政', 'CA');
INSERT INTO `tp5_xbird_express` VALUES ('1613', '递必易国际物流', 'DBYWL');
INSERT INTO `tp5_xbird_express` VALUES ('1614', '大道物流', 'DDWL');
INSERT INTO `tp5_xbird_express` VALUES ('1615', '德国云快递', 'DGYKD');
INSERT INTO `tp5_xbird_express` VALUES ('1616', '到乐国际', 'DLGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1617', 'DHL德国', 'DHL_DE');
INSERT INTO `tp5_xbird_express` VALUES ('1618', 'DHL(英文版)', 'DHL_EN');
INSERT INTO `tp5_xbird_express` VALUES ('1619', 'DHL全球', 'DHL_GLB');
INSERT INTO `tp5_xbird_express` VALUES ('1620', 'DHL Global Mail', 'DHLGM');
INSERT INTO `tp5_xbird_express` VALUES ('1621', '丹麦邮政', 'DK');
INSERT INTO `tp5_xbird_express` VALUES ('1622', 'DPD', 'DPD');
INSERT INTO `tp5_xbird_express` VALUES ('1623', 'DPEX', 'DPEX');
INSERT INTO `tp5_xbird_express` VALUES ('1624', '递四方速递', 'D4PX');
INSERT INTO `tp5_xbird_express` VALUES ('1625', 'EMS国际', 'EMSGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1626', '易客满', 'EKM');
INSERT INTO `tp5_xbird_express` VALUES ('1627', 'EPS (联众国际快运)', 'EPS');
INSERT INTO `tp5_xbird_express` VALUES ('1628', 'EShipper', 'ESHIPPER');
INSERT INTO `tp5_xbird_express` VALUES ('1629', '丰程物流', 'FCWL');
INSERT INTO `tp5_xbird_express` VALUES ('1630', '法翔速运', 'FX');
INSERT INTO `tp5_xbird_express` VALUES ('1631', 'FQ', 'FQ');
INSERT INTO `tp5_xbird_express` VALUES ('1632', '芬兰邮政', 'FLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1633', '方舟国际速递', 'FZGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1634', '国际e邮宝', 'GJEYB');
INSERT INTO `tp5_xbird_express` VALUES ('1635', '国际邮政包裹', 'GJYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1636', 'GE2D', 'GE2D');
INSERT INTO `tp5_xbird_express` VALUES ('1637', '冠泰', 'GT');
INSERT INTO `tp5_xbird_express` VALUES ('1638', 'GLS', 'GLS');
INSERT INTO `tp5_xbird_express` VALUES ('1639', '欧洲专线(邮政)', 'IOZYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1640', '澳大利亚邮政', 'IADLYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1641', '阿尔巴尼亚邮政', 'IAEBNYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1642', '阿尔及利亚邮政', 'IAEJLYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1643', '阿富汗邮政', 'IAFHYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1644', '安哥拉邮政', 'IAGLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1645', '埃及邮政', 'IAJYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1646', '阿鲁巴邮政', 'IALBYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1647', '阿联酋邮政', 'IALYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1648', '阿塞拜疆邮政', 'IASBJYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1649', '博茨瓦纳邮政', 'IBCWNYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1650', '波多黎各邮政', 'IBDLGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1651', '冰岛邮政', 'IBDYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1652', '白俄罗斯邮政', 'IBELSYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1653', '波黑邮政', 'IBHYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1654', '保加利亚邮政', 'IBJLYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1655', '巴基斯坦邮政', 'IBJSTYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1656', '黎巴嫩邮政', 'IBLNYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1657', '波兰邮政', 'IBOLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1658', '宝通达', 'IBTD');
INSERT INTO `tp5_xbird_express` VALUES ('1659', '贝邮宝', 'IBYB');
INSERT INTO `tp5_xbird_express` VALUES ('1660', '出口易', 'ICKY');
INSERT INTO `tp5_xbird_express` VALUES ('1661', '德国邮政', 'IDGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1662', '危地马拉邮政', 'IWDMLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1663', '乌干达邮政', 'IWGDYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1664', '乌克兰EMS', 'IWKLEMS');
INSERT INTO `tp5_xbird_express` VALUES ('1665', '乌克兰邮政', 'IWKLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1666', '乌拉圭邮政', 'IWLGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1667', '林克快递', 'ILKKD');
INSERT INTO `tp5_xbird_express` VALUES ('1668', '文莱邮政', 'IWLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1669', '新喀里多尼亚邮政', 'IXGLDNYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1670', '爱尔兰邮政', 'IE');
INSERT INTO `tp5_xbird_express` VALUES ('1671', '夏浦物流', 'IXPWL');
INSERT INTO `tp5_xbird_express` VALUES ('1672', '印度邮政', 'IYDYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1673', '夏浦世纪', 'IXPSJ');
INSERT INTO `tp5_xbird_express` VALUES ('1674', '厄瓜多尔邮政', 'IEGDEYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1675', '俄罗斯邮政', 'IELSYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1676', '飞特物流', 'IFTWL');
INSERT INTO `tp5_xbird_express` VALUES ('1677', '瓜德罗普岛邮政', 'IGDLPDYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1678', '哥斯达黎加邮政', 'IGSDLJYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1679', '韩国邮政', 'IHGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1680', '华翰物流', 'IHHWL');
INSERT INTO `tp5_xbird_express` VALUES ('1681', '互联易', 'IHLY');
INSERT INTO `tp5_xbird_express` VALUES ('1682', '哈萨克斯坦邮政', 'IHSKSTYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1683', '黑山邮政', 'IHSYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1684', '津巴布韦邮政', 'IJBBWYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1685', '吉尔吉斯斯坦邮政', 'IJEJSSTYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1686', '捷克邮政', 'IJKYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1687', '加纳邮政', 'IJNYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1688', '柬埔寨邮政', 'IJPZYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1689', '克罗地亚邮政', 'IKNDYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1690', '肯尼亚邮政', 'IKNYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1691', '科特迪瓦EMS', 'IKTDWEMS');
INSERT INTO `tp5_xbird_express` VALUES ('1692', '罗马尼亚邮政', 'ILMNYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1693', '摩尔多瓦邮政', 'IMEDWYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1694', '马耳他邮政', 'IMETYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1695', '尼日利亚邮政', 'INRLYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1696', '塞尔维亚邮政', 'ISEWYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1697', '塞浦路斯邮政', 'ISPLSYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1698', '乌兹别克斯坦邮政', 'IWZBKSTYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1699', '西班牙邮政', 'IXBYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1700', '新加坡EMS', 'IXJPEMS');
INSERT INTO `tp5_xbird_express` VALUES ('1701', '希腊邮政', 'IXLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1702', '新西兰邮政', 'IXXLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1703', '意大利邮政', 'IYDLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1704', '英国邮政', 'IYGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1705', '亚美尼亚邮政', 'IYMNYYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1706', '也门邮政', 'IYMYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1707', '智利邮政', 'IZLYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1708', '日本邮政', 'JP');
INSERT INTO `tp5_xbird_express` VALUES ('1709', '今枫国际', 'JFGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1710', '极光转运', 'JGZY');
INSERT INTO `tp5_xbird_express` VALUES ('1711', '吉祥邮转运', 'JXYKD');
INSERT INTO `tp5_xbird_express` VALUES ('1712', '嘉里国际', 'JLDT');
INSERT INTO `tp5_xbird_express` VALUES ('1713', '绝配国际速递', 'JPKD');
INSERT INTO `tp5_xbird_express` VALUES ('1714', '佳惠尔', 'SYJHE');
INSERT INTO `tp5_xbird_express` VALUES ('1715', '联运通', 'LYT');
INSERT INTO `tp5_xbird_express` VALUES ('1716', '联合快递', 'LHKDS');
INSERT INTO `tp5_xbird_express` VALUES ('1717', '林道国际', 'SHLDHY');
INSERT INTO `tp5_xbird_express` VALUES ('1718', '荷兰邮政', 'NL');
INSERT INTO `tp5_xbird_express` VALUES ('1719', '新顺丰', 'NSF');
INSERT INTO `tp5_xbird_express` VALUES ('1720', 'ONTRAC', 'ONTRAC');
INSERT INTO `tp5_xbird_express` VALUES ('1721', 'OCS', 'OCS');
INSERT INTO `tp5_xbird_express` VALUES ('1722', '全球邮政', 'QQYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1723', 'POSTEIBE', 'POSTEIBE');
INSERT INTO `tp5_xbird_express` VALUES ('1724', '啪啪供应链', 'PAPA');
INSERT INTO `tp5_xbird_express` VALUES ('1725', '秦远海运', 'QYHY');
INSERT INTO `tp5_xbird_express` VALUES ('1726', '启辰国际', 'VENUCIA');
INSERT INTO `tp5_xbird_express` VALUES ('1727', '瑞典邮政', 'RDSE');
INSERT INTO `tp5_xbird_express` VALUES ('1728', 'SKYPOST', 'SKYPOST');
INSERT INTO `tp5_xbird_express` VALUES ('1729', '瑞士邮政', 'SWCH');
INSERT INTO `tp5_xbird_express` VALUES ('1730', '首达速运', 'SDSY');
INSERT INTO `tp5_xbird_express` VALUES ('1731', '穗空物流', 'SK');
INSERT INTO `tp5_xbird_express` VALUES ('1732', '首通快运', 'STONG');
INSERT INTO `tp5_xbird_express` VALUES ('1733', '申通快递国际单', 'STO_INTL');
INSERT INTO `tp5_xbird_express` VALUES ('1734', '上海久易国际', 'JYSD');
INSERT INTO `tp5_xbird_express` VALUES ('1735', '泰国138', 'TAILAND138');
INSERT INTO `tp5_xbird_express` VALUES ('1736', 'USPS美国邮政', 'USPS');
INSERT INTO `tp5_xbird_express` VALUES ('1737', '万国邮政', 'UPU');
INSERT INTO `tp5_xbird_express` VALUES ('1738', '中越国际物流', 'VCTRANS');
INSERT INTO `tp5_xbird_express` VALUES ('1739', '星空国际', 'XKGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1740', '迅达国际', 'XD');
INSERT INTO `tp5_xbird_express` VALUES ('1741', '香港邮政', 'XGYZ');
INSERT INTO `tp5_xbird_express` VALUES ('1742', '喜来快递', 'XLKD');
INSERT INTO `tp5_xbird_express` VALUES ('1743', '鑫世锐达', 'XSRD');
INSERT INTO `tp5_xbird_express` VALUES ('1744', '新元国际', 'XYGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1745', 'ADLER雄鹰国际速递', 'XYGJSD');
INSERT INTO `tp5_xbird_express` VALUES ('1746', '日本大和运输(Yamato)', 'YAMA');
INSERT INTO `tp5_xbird_express` VALUES ('1747', 'YODEL', 'YODEL');
INSERT INTO `tp5_xbird_express` VALUES ('1748', '一号线', 'YHXGJSD');
INSERT INTO `tp5_xbird_express` VALUES ('1749', '约旦邮政', 'YUEDANYOUZ');
INSERT INTO `tp5_xbird_express` VALUES ('1750', '玥玛速运', 'YMSY');
INSERT INTO `tp5_xbird_express` VALUES ('1751', '鹰运', 'YYSD');
INSERT INTO `tp5_xbird_express` VALUES ('1752', '易境达', 'YJD');
INSERT INTO `tp5_xbird_express` VALUES ('1753', '洋包裹', 'YBG');
INSERT INTO `tp5_xbird_express` VALUES ('1754', '友家速递', 'YJ');
INSERT INTO `tp5_xbird_express` VALUES ('1755', 'AOL（澳通）', 'AOL');
INSERT INTO `tp5_xbird_express` VALUES ('1756', 'BCWELT   ', 'BCWELT');
INSERT INTO `tp5_xbird_express` VALUES ('1757', '笨鸟国际', 'BN');
INSERT INTO `tp5_xbird_express` VALUES ('1758', '优邦国际速运', 'UBONEX');
INSERT INTO `tp5_xbird_express` VALUES ('1759', 'UEX   ', 'UEX');
INSERT INTO `tp5_xbird_express` VALUES ('1760', '韵达国际', 'YDGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1761', '爱购转运', 'ZY_AG');
INSERT INTO `tp5_xbird_express` VALUES ('1762', '爱欧洲', 'ZY_AOZ');
INSERT INTO `tp5_xbird_express` VALUES ('1763', '澳世速递', 'ZY_AUSE');
INSERT INTO `tp5_xbird_express` VALUES ('1764', 'AXO', 'ZY_AXO');
INSERT INTO `tp5_xbird_express` VALUES ('1765', '贝海速递', 'ZY_BH');
INSERT INTO `tp5_xbird_express` VALUES ('1766', '蜜蜂速递', 'ZY_BEE');
INSERT INTO `tp5_xbird_express` VALUES ('1767', '百利快递', 'ZY_BL');
INSERT INTO `tp5_xbird_express` VALUES ('1768', '斑马物流', 'ZY_BM');
INSERT INTO `tp5_xbird_express` VALUES ('1769', '百通物流', 'ZY_BT');
INSERT INTO `tp5_xbird_express` VALUES ('1770', '策马转运', 'ZY_CM');
INSERT INTO `tp5_xbird_express` VALUES ('1771', 'EFS POST', 'ZY_EFS');
INSERT INTO `tp5_xbird_express` VALUES ('1772', '宜送转运', 'ZY_ESONG');
INSERT INTO `tp5_xbird_express` VALUES ('1773', '飞碟快递', 'ZY_FD');
INSERT INTO `tp5_xbird_express` VALUES ('1774', '飞鸽快递', 'ZY_FG');
INSERT INTO `tp5_xbird_express` VALUES ('1775', '风行快递', 'ZY_FX');
INSERT INTO `tp5_xbird_express` VALUES ('1776', '风行速递', 'ZY_FXSD');
INSERT INTO `tp5_xbird_express` VALUES ('1777', '飞洋快递', 'ZY_FY');
INSERT INTO `tp5_xbird_express` VALUES ('1778', '皓晨快递', 'ZY_HC');
INSERT INTO `tp5_xbird_express` VALUES ('1779', '海悦速递', 'ZY_HYSD');
INSERT INTO `tp5_xbird_express` VALUES ('1780', '君安快递', 'ZY_JA');
INSERT INTO `tp5_xbird_express` VALUES ('1781', '时代转运', 'ZY_JD');
INSERT INTO `tp5_xbird_express` VALUES ('1782', '骏达快递', 'ZY_JDKD');
INSERT INTO `tp5_xbird_express` VALUES ('1783', '骏达转运', 'ZY_JDZY');
INSERT INTO `tp5_xbird_express` VALUES ('1784', '久禾快递', 'ZY_JH');
INSERT INTO `tp5_xbird_express` VALUES ('1785', '金海淘', 'ZY_JHT');
INSERT INTO `tp5_xbird_express` VALUES ('1786', '联邦转运FedRoad', 'ZY_LBZY');
INSERT INTO `tp5_xbird_express` VALUES ('1787', '龙象快递', 'ZY_LX');
INSERT INTO `tp5_xbird_express` VALUES ('1788', '美国转运', 'ZY_MGZY');
INSERT INTO `tp5_xbird_express` VALUES ('1789', '美速通', 'ZY_MST');
INSERT INTO `tp5_xbird_express` VALUES ('1790', '美西转运', 'ZY_MXZY');
INSERT INTO `tp5_xbird_express` VALUES ('1791', 'QQ-EX', 'ZY_QQEX');
INSERT INTO `tp5_xbird_express` VALUES ('1792', '瑞天快递', 'ZY_RT');
INSERT INTO `tp5_xbird_express` VALUES ('1793', '瑞天速递', 'ZY_RTSD');
INSERT INTO `tp5_xbird_express` VALUES ('1794', '速达快递', 'ZY_SDKD');
INSERT INTO `tp5_xbird_express` VALUES ('1795', '四方转运', 'ZY_SFZY');
INSERT INTO `tp5_xbird_express` VALUES ('1796', '上腾快递', 'ZY_ST');
INSERT INTO `tp5_xbird_express` VALUES ('1797', '天际快递', 'ZY_TJ');
INSERT INTO `tp5_xbird_express` VALUES ('1798', '天马转运', 'ZY_TM');
INSERT INTO `tp5_xbird_express` VALUES ('1799', '滕牛快递', 'ZY_TN');
INSERT INTO `tp5_xbird_express` VALUES ('1800', '太平洋快递', 'ZY_TPY');
INSERT INTO `tp5_xbird_express` VALUES ('1801', '唐三藏转运', 'ZY_TSZ');
INSERT INTO `tp5_xbird_express` VALUES ('1802', 'TWC转运世界', 'ZY_TWC');
INSERT INTO `tp5_xbird_express` VALUES ('1803', '润东国际快线', 'ZY_RDGJ');
INSERT INTO `tp5_xbird_express` VALUES ('1804', '同心快递', 'ZY_TX');
INSERT INTO `tp5_xbird_express` VALUES ('1805', '天翼快递', 'ZY_TY');
INSERT INTO `tp5_xbird_express` VALUES ('1806', '德国海淘之家', 'ZY_DGHT');
INSERT INTO `tp5_xbird_express` VALUES ('1807', '德运网', 'ZY_DYW');
INSERT INTO `tp5_xbird_express` VALUES ('1808', '文达国际DCS', 'ZY_WDCS');
INSERT INTO `tp5_xbird_express` VALUES ('1809', '同舟快递', 'ZY_TZH');
INSERT INTO `tp5_xbird_express` VALUES ('1810', 'UCS合众快递', 'ZY_UCS');
INSERT INTO `tp5_xbird_express` VALUES ('1811', '星辰快递', 'ZY_XC');
INSERT INTO `tp5_xbird_express` VALUES ('1812', '先锋快递', 'ZY_XF');
INSERT INTO `tp5_xbird_express` VALUES ('1813', '西邮寄', 'ZY_XIYJ');
INSERT INTO `tp5_xbird_express` VALUES ('1814', '云骑快递', 'ZY_YQ');
INSERT INTO `tp5_xbird_express` VALUES ('1815', '优晟速递', 'ZY_YSSD');
INSERT INTO `tp5_xbird_express` VALUES ('1816', '运淘美国', 'ZY_YTUSA');
INSERT INTO `tp5_xbird_express` VALUES ('1817', '至诚速递', 'ZY_ZCSD');
INSERT INTO `tp5_xbird_express` VALUES ('1818', '增速海淘', 'ZYZOOM');
INSERT INTO `tp5_xbird_express` VALUES ('1819', '中驰物流', 'ZH');
INSERT INTO `tp5_xbird_express` VALUES ('1820', '中欧快运', 'ZO');
INSERT INTO `tp5_xbird_express` VALUES ('1821', '准实快运', 'ZSKY');
INSERT INTO `tp5_xbird_express` VALUES ('1822', '中外速运', 'ZWSY');
INSERT INTO `tp5_xbird_express` VALUES ('1823', '郑州建华', 'ZZJH');

-- ----------------------------
-- Table structure for tp5_xbrands
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xbrands`;
CREATE TABLE `tp5_xbrands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(100) NOT NULL COMMENT '品牌名称',
  `brand_icon` varchar(150) DEFAULT NULL COMMENT '品牌图标',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属分类编码',
  `list_order` int(10) unsigned NOT NULL DEFAULT '999' COMMENT '排序',
  `updated_at` timestamp NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '-1:删除; 1：正常',
  PRIMARY KEY (`id`),
  KEY `index_sel` (`brand_name`,`list_order`) USING BTREE,
  KEY `index_cat` (`cat_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='品牌表';

-- ----------------------------
-- Records of tp5_xbrands
-- ----------------------------
INSERT INTO `tp5_xbrands` VALUES ('1', '戴森(DYSON)', '', '19', '1', '2020-11-09 20:14:16', '1');
INSERT INTO `tp5_xbrands` VALUES ('2', '科沃斯（Ecovacs）', 'cms/images/brand/Ecovacs.jpg', '18', '1', '2020-11-09 20:36:09', '1');
INSERT INTO `tp5_xbrands` VALUES ('6', '花花公子', 'cms/images/brand/PLAYBOY.jpg', '14', '1', '2020-11-09 20:36:10', '1');
INSERT INTO `tp5_xbrands` VALUES ('7', '香飘飘', 'cms/images/brand/Xiangpiaopiao.png', '9', '1', '2020-11-09 20:36:11', '1');
INSERT INTO `tp5_xbrands` VALUES ('8', '雀巢', 'cms/images/brand/Nestle.png', '9', '2', '2020-11-10 10:28:22', '1');
INSERT INTO `tp5_xbrands` VALUES ('9', '太古（taikoo）', 'cms/images/brand/taikoo.jpg', '9', '3', '2020-11-09 20:36:11', '1');
INSERT INTO `tp5_xbrands` VALUES ('10', '伊利', 'cms/images/brand/Yili.jpg', '10', '1', '2020-11-09 20:36:11', '1');
INSERT INTO `tp5_xbrands` VALUES ('11', '雅戈尔', '', '14', '2', '2020-11-09 20:36:12', '1');
INSERT INTO `tp5_xbrands` VALUES ('12', '小米', 'cms/images/brand/xiaomi.gif', '18', '3', '2020-11-09 20:36:12', '1');
INSERT INTO `tp5_xbrands` VALUES ('13', '华为', 'cms/images/brand/HUAWEI.jpg', '18', '3', '2020-11-09 20:36:17', '1');
INSERT INTO `tp5_xbrands` VALUES ('14', '小米', 'cms/images/brand/xiaomi.gif', '20', '1', '2020-12-12 13:14:52', '1');
INSERT INTO `tp5_xbrands` VALUES ('15', '小度', 'cms/images/brand/xiaodu.png', '20', '2', '2020-11-09 20:36:12', '1');
INSERT INTO `tp5_xbrands` VALUES ('16', '索尼', 'cms/images/brand/SONY.jpg', '20', '3', '2020-11-09 20:36:13', '1');
INSERT INTO `tp5_xbrands` VALUES ('17', '漫步者', 'cms/images/brand/EDIFIER.png', '21', '1', '2020-12-12 13:17:39', '1');
INSERT INTO `tp5_xbrands` VALUES ('18', '索尼', 'cms/images/brand/SONY.jpg', '21', '2', '2020-12-07 17:10:39', '1');
INSERT INTO `tp5_xbrands` VALUES ('19', '蒙牛', '', '10', '3', '2020-11-09 20:36:15', '1');

-- ----------------------------
-- Table structure for tp5_xcategorys
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xcategorys`;
CREATE TABLE `tp5_xcategorys` (
  `cat_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(10) NOT NULL DEFAULT '' COMMENT '分类名称',
  `parent_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '该分类的父id，取决于cat_id ',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在 app 首页导航栏显示  0：不显示  1：显示',
  `icon` varchar(255) NOT NULL COMMENT '分类图标',
  `level` tinyint(2) NOT NULL DEFAULT '2' COMMENT '类型  1：一级；2：二级； 3：三级',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序数字越小 越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态 1：正常  -1：已删除',
  PRIMARY KEY (`cat_id`),
  KEY `pk_index` (`cat_id`) USING BTREE,
  KEY `index_sel` (`cat_name`,`parent_id`,`list_order`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- ----------------------------
-- Records of tp5_xcategorys
-- ----------------------------
INSERT INTO `tp5_xcategorys` VALUES ('1', '图书/文娱', '0', '1', 'cms/images/category/books.png', '1', '3', '1');
INSERT INTO `tp5_xcategorys` VALUES ('2', '电器数码', '0', '1', 'cms/images/category/electric.png', '1', '4', '1');
INSERT INTO `tp5_xcategorys` VALUES ('3', '穿搭服饰', '0', '1', 'cms/images/category/clothing.png', '1', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('4', '美食/饮料', '0', '0', 'cms/images/category/food.png', '1', '11', '1');
INSERT INTO `tp5_xcategorys` VALUES ('5', '服饰配件', '3', '1', '', '2', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('6', '饮料冲调', '4', '1', 'cms/images/category/drink.png', '2', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('7', '影音娱乐', '2', '1', '', '2', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('8', '红酒', '4', '1', 'cms/images/category/red_wine.png', '2', '1', '-1');
INSERT INTO `tp5_xcategorys` VALUES ('9', '咖啡奶茶', '6', '1', 'cms/images/category/coffee.png', '3', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('10', '牛奶酸奶', '6', '1', 'cms/images/category/milk.png', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('12', '生活电器', '2', '1', 'cms/images/category/washer.png', '2', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('13', '衬衫', '16', '1', '', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('14', '领带/领结', '5', '1', 'cms/images/category/necktie.png', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('15', '粮油调味', '4', '1', '', '2', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('16', '男装', '3', '1', '', '2', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('17', '食用油', '15', '1', '', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('18', '扫地机器人', '12', '1', '', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('19', '吸尘器', '12', '1', '', '3', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('20', '音箱/音响', '7', '1', '', '3', '1', '1');
INSERT INTO `tp5_xcategorys` VALUES ('21', '耳机/耳麦', '7', '1', '', '3', '2', '1');
INSERT INTO `tp5_xcategorys` VALUES ('22', 'xxxss', '6', '1', '', '3', '999', '-1');

-- ----------------------------
-- Table structure for tp5_xchat_logs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xchat_logs`;
CREATE TABLE `tp5_xchat_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_id` int(11) NOT NULL DEFAULT '0' COMMENT '发送方 admin ID',
  `to_id` int(11) NOT NULL DEFAULT '0' COMMENT '接收方 Admin ID',
  `content` varchar(255) CHARACTER SET utf8mb4 NOT NULL COMMENT '聊天内容',
  `log_time` int(11) NOT NULL DEFAULT '0' COMMENT '记录时间',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0：未读；1：已读',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1：文字；2：图片',
  PRIMARY KEY (`id`),
  KEY `INDEX` (`from_id`,`to_id`)
) ENGINE=MyISAM AUTO_INCREMENT=587 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天记录表';

-- ----------------------------
-- Records of tp5_xchat_logs
-- ----------------------------
INSERT INTO `tp5_xchat_logs` VALUES ('539', '1', '2', '巴扎黑，快出来玩！', '1603515063', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('540', '3', '2', '牛能在吗', '1603515089', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('541', '3', '1', '在吗？', '1603515098', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('542', '3', '1', '快说啊', '1603515089', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('543', '1', '3', '在的', '1603517973', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('544', '1', '2', '想吃饭了', '1603518013', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('576', '1', '4', 'https://www.baidu.com/img/flexible/logo/pc/result.png', '1605181769', '0', '2');
INSERT INTO `tp5_xchat_logs` VALUES ('554', '1', '3', '你这臭家伙！', '1603797882', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('555', '3', '1', '[em_19]', '1603797976', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('559', '1', '3', '[em_20]', '1603801020', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('564', '2', '1', '[em_21]', '1603801615', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('566', '1', '3', 'HELLO', '1603802679', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('575', '4', '1', '啊哈哈哈', '1605181760', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('569', '2', '1', '99', '1603803810', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('570', '2', '1', '[em_34]', '1603803846', '0', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('572', '2', '3', '[em_8]', '1603804393', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('573', '2', '1', '三生三世', '1603805237', '1', '1');
INSERT INTO `tp5_xchat_logs` VALUES ('584', '1', '3', '[em_35][em_50][em_48]', '1605605337', '0', '1');

-- ----------------------------
-- Table structure for tp5_xcms_logs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xcms_logs`;
CREATE TABLE `tp5_xcms_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(10) NOT NULL COMMENT '标签，为了区分所记录不同业务的日志',
  `op_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作对象 ID',
  `op_msg` varchar(12) NOT NULL COMMENT '操作备案',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作管理员ID',
  `add_time` datetime NOT NULL COMMENT '记录添加时间',
  PRIMARY KEY (`id`),
  KEY `index_op_admin_id` (`op_id`,`admin_id`),
  KEY `tag_index` (`tag`)
) ENGINE=MyISAM AUTO_INCREMENT=279 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tp5_xcms_logs
-- ----------------------------
INSERT INTO `tp5_xcms_logs` VALUES ('13', 'ARTICLE', '3', '取消推荐', '3', '2020-03-09 17:31:42');
INSERT INTO `tp5_xcms_logs` VALUES ('14', 'ARTICLE', '3', '推荐商品', '3', '2020-03-09 17:31:43');
INSERT INTO `tp5_xcms_logs` VALUES ('15', 'ARTICLE', '4', '文章更新', '3', '2020-03-09 17:31:56');
INSERT INTO `tp5_xcms_logs` VALUES ('16', 'GOODS', '4', '商品上架', '3', '2020-03-09 17:52:31');
INSERT INTO `tp5_xcms_logs` VALUES ('17', 'GOODS', '4', '商品下架', '3', '2020-03-09 17:53:23');
INSERT INTO `tp5_xcms_logs` VALUES ('18', 'GOODS', '4', '商品上架', '3', '2020-03-09 17:53:29');
INSERT INTO `tp5_xcms_logs` VALUES ('19', 'GOODS', '3', '商品修改成功', '3', '2020-03-09 17:54:23');
INSERT INTO `tp5_xcms_logs` VALUES ('20', 'ARTICLE', '3', '文章更新', '1', '2020-06-02 18:31:48');
INSERT INTO `tp5_xcms_logs` VALUES ('21', 'ARTICLE', '3', '文章更新', '1', '2020-06-02 18:35:57');
INSERT INTO `tp5_xcms_logs` VALUES ('22', 'ARTICLE', '3', '文章更新', '1', '2020-06-02 18:38:11');
INSERT INTO `tp5_xcms_logs` VALUES ('23', 'ARTICLE', '10', '添加文章数据', '1', '2020-06-02 18:51:33');
INSERT INTO `tp5_xcms_logs` VALUES ('24', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 18:56:06');
INSERT INTO `tp5_xcms_logs` VALUES ('25', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 18:56:50');
INSERT INTO `tp5_xcms_logs` VALUES ('26', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:00:47');
INSERT INTO `tp5_xcms_logs` VALUES ('27', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:01:03');
INSERT INTO `tp5_xcms_logs` VALUES ('28', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:03:14');
INSERT INTO `tp5_xcms_logs` VALUES ('29', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:04:44');
INSERT INTO `tp5_xcms_logs` VALUES ('30', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:06:10');
INSERT INTO `tp5_xcms_logs` VALUES ('31', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:17:21');
INSERT INTO `tp5_xcms_logs` VALUES ('32', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:19:42');
INSERT INTO `tp5_xcms_logs` VALUES ('33', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:21:43');
INSERT INTO `tp5_xcms_logs` VALUES ('34', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:22:59');
INSERT INTO `tp5_xcms_logs` VALUES ('35', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:43:26');
INSERT INTO `tp5_xcms_logs` VALUES ('36', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:44:08');
INSERT INTO `tp5_xcms_logs` VALUES ('37', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:44:29');
INSERT INTO `tp5_xcms_logs` VALUES ('38', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:46:24');
INSERT INTO `tp5_xcms_logs` VALUES ('39', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 19:49:16');
INSERT INTO `tp5_xcms_logs` VALUES ('40', 'ARTICLE', '11', '文章更新', '1', '2020-06-02 20:00:53');
INSERT INTO `tp5_xcms_logs` VALUES ('41', 'ARTICLE', '11', '文章删除操作', '1', '2020-06-02 20:01:11');
INSERT INTO `tp5_xcms_logs` VALUES ('42', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 18:41:05');
INSERT INTO `tp5_xcms_logs` VALUES ('43', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 18:41:52');
INSERT INTO `tp5_xcms_logs` VALUES ('44', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 18:45:05');
INSERT INTO `tp5_xcms_logs` VALUES ('45', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 18:46:17');
INSERT INTO `tp5_xcms_logs` VALUES ('46', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:31:01');
INSERT INTO `tp5_xcms_logs` VALUES ('47', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:34:59');
INSERT INTO `tp5_xcms_logs` VALUES ('48', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:38:17');
INSERT INTO `tp5_xcms_logs` VALUES ('49', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:40:34');
INSERT INTO `tp5_xcms_logs` VALUES ('50', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:43:21');
INSERT INTO `tp5_xcms_logs` VALUES ('51', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 19:45:03');
INSERT INTO `tp5_xcms_logs` VALUES ('52', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 20:13:35');
INSERT INTO `tp5_xcms_logs` VALUES ('53', 'GOODS', '6', '商品修改成功', '1', '2020-09-04 20:43:57');
INSERT INTO `tp5_xcms_logs` VALUES ('54', 'GOODS', '3', '商品修改成功', '1', '2020-09-04 20:46:45');
INSERT INTO `tp5_xcms_logs` VALUES ('55', 'ARTICLE', '1', '文章更新', '1', '2020-09-04 20:56:11');
INSERT INTO `tp5_xcms_logs` VALUES ('56', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 20:57:51');
INSERT INTO `tp5_xcms_logs` VALUES ('57', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 20:58:58');
INSERT INTO `tp5_xcms_logs` VALUES ('58', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:02:09');
INSERT INTO `tp5_xcms_logs` VALUES ('59', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:02:38');
INSERT INTO `tp5_xcms_logs` VALUES ('60', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:03:38');
INSERT INTO `tp5_xcms_logs` VALUES ('61', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:04:14');
INSERT INTO `tp5_xcms_logs` VALUES ('62', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:04:29');
INSERT INTO `tp5_xcms_logs` VALUES ('63', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:04:55');
INSERT INTO `tp5_xcms_logs` VALUES ('64', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:05:23');
INSERT INTO `tp5_xcms_logs` VALUES ('65', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:07:46');
INSERT INTO `tp5_xcms_logs` VALUES ('66', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:08:08');
INSERT INTO `tp5_xcms_logs` VALUES ('67', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:08:26');
INSERT INTO `tp5_xcms_logs` VALUES ('68', 'ARTICLE', '3', '文章更新', '1', '2020-09-04 21:09:10');
INSERT INTO `tp5_xcms_logs` VALUES ('69', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:10:30');
INSERT INTO `tp5_xcms_logs` VALUES ('70', 'ARTICLE', '4', '文章更新', '1', '2020-09-04 21:12:22');
INSERT INTO `tp5_xcms_logs` VALUES ('71', 'GOODS', '3', '商品修改成功', '1', '2020-09-04 21:13:31');
INSERT INTO `tp5_xcms_logs` VALUES ('72', 'GOODS', '4', '商品修改成功', '1', '2020-09-04 21:14:10');
INSERT INTO `tp5_xcms_logs` VALUES ('73', 'GOODS', '2', '商品修改成功', '1', '2020-09-04 21:14:24');
INSERT INTO `tp5_xcms_logs` VALUES ('74', 'GOODS', '1', '商品修改成功', '1', '2020-09-04 21:14:49');
INSERT INTO `tp5_xcms_logs` VALUES ('75', 'ARTICLE', '2', '文章更新', '1', '2020-09-04 21:16:59');
INSERT INTO `tp5_xcms_logs` VALUES ('76', 'ARTICLE', '1', '文章更新', '1', '2020-09-07 14:14:35');
INSERT INTO `tp5_xcms_logs` VALUES ('77', 'ARTICLE', '1', '文章更新', '1', '2020-09-07 14:14:52');
INSERT INTO `tp5_xcms_logs` VALUES ('78', 'ARTICLE', '4', '文章更新', '1', '2020-09-07 17:44:15');
INSERT INTO `tp5_xcms_logs` VALUES ('79', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 14:55:05');
INSERT INTO `tp5_xcms_logs` VALUES ('80', 'GOODS', '1', '商品修改成功', '1', '2020-09-08 15:35:36');
INSERT INTO `tp5_xcms_logs` VALUES ('81', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 16:28:26');
INSERT INTO `tp5_xcms_logs` VALUES ('82', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 16:29:33');
INSERT INTO `tp5_xcms_logs` VALUES ('83', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 16:39:01');
INSERT INTO `tp5_xcms_logs` VALUES ('84', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:01:17');
INSERT INTO `tp5_xcms_logs` VALUES ('85', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:05:46');
INSERT INTO `tp5_xcms_logs` VALUES ('86', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:08:10');
INSERT INTO `tp5_xcms_logs` VALUES ('87', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:09:01');
INSERT INTO `tp5_xcms_logs` VALUES ('88', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:09:16');
INSERT INTO `tp5_xcms_logs` VALUES ('89', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:09:30');
INSERT INTO `tp5_xcms_logs` VALUES ('90', 'ARTICLE', '1', '文章更新', '1', '2020-09-08 17:09:42');
INSERT INTO `tp5_xcms_logs` VALUES ('91', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:12:25');
INSERT INTO `tp5_xcms_logs` VALUES ('92', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:12:43');
INSERT INTO `tp5_xcms_logs` VALUES ('93', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:13:11');
INSERT INTO `tp5_xcms_logs` VALUES ('94', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:13:51');
INSERT INTO `tp5_xcms_logs` VALUES ('95', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:14:25');
INSERT INTO `tp5_xcms_logs` VALUES ('96', 'ARTICLE', '4', '文章更新', '1', '2020-09-08 17:14:39');
INSERT INTO `tp5_xcms_logs` VALUES ('97', 'ARTICLE', '4', '文章更新', '1', '2020-09-09 18:46:04');
INSERT INTO `tp5_xcms_logs` VALUES ('98', 'ARTICLE', '1', '文章更新', '1', '2020-09-10 08:52:38');
INSERT INTO `tp5_xcms_logs` VALUES ('99', 'ARTICLE', '1', '文章更新', '1', '2020-09-10 10:03:45');
INSERT INTO `tp5_xcms_logs` VALUES ('100', 'ARTICLE', '1', '文章更新', '1', '2020-09-10 10:04:05');
INSERT INTO `tp5_xcms_logs` VALUES ('101', 'ARTICLE', '2', '文章更新', '1', '2020-09-10 16:57:31');
INSERT INTO `tp5_xcms_logs` VALUES ('102', 'ARTICLE', '1', '文章更新', '1', '2020-09-10 18:17:45');
INSERT INTO `tp5_xcms_logs` VALUES ('103', 'ARTICLE', '2', '文章更新', '1', '2020-09-10 18:29:30');
INSERT INTO `tp5_xcms_logs` VALUES ('104', 'ARTICLE', '3', '文章更新', '1', '2020-09-10 19:38:15');
INSERT INTO `tp5_xcms_logs` VALUES ('105', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 09:30:55');
INSERT INTO `tp5_xcms_logs` VALUES ('106', 'ARTICLE', '2', '文章更新', '1', '2020-09-11 15:41:54');
INSERT INTO `tp5_xcms_logs` VALUES ('107', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 15:42:58');
INSERT INTO `tp5_xcms_logs` VALUES ('108', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 15:45:37');
INSERT INTO `tp5_xcms_logs` VALUES ('109', 'ARTICLE', '4', '文章更新', '1', '2020-09-11 15:46:01');
INSERT INTO `tp5_xcms_logs` VALUES ('110', 'ARTICLE', '3', '文章更新', '1', '2020-09-11 15:46:44');
INSERT INTO `tp5_xcms_logs` VALUES ('111', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 15:54:32');
INSERT INTO `tp5_xcms_logs` VALUES ('112', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 15:58:48');
INSERT INTO `tp5_xcms_logs` VALUES ('113', 'ARTICLE', '1', '文章更新', '1', '2020-09-11 18:14:23');
INSERT INTO `tp5_xcms_logs` VALUES ('114', 'GOODS', '1', '商品修改成功', '1', '2020-09-15 16:35:41');
INSERT INTO `tp5_xcms_logs` VALUES ('115', 'GOODS', '2', '商品修改成功', '1', '2020-09-15 16:52:47');
INSERT INTO `tp5_xcms_logs` VALUES ('116', 'GOODS', '2', '商品修改成功', '1', '2020-09-15 16:52:54');
INSERT INTO `tp5_xcms_logs` VALUES ('117', 'GOODS', '2', '商品修改成功', '1', '2020-09-15 16:53:11');
INSERT INTO `tp5_xcms_logs` VALUES ('118', 'ARTICLE', '4', '文章更新', '1', '2020-10-29 11:17:02');
INSERT INTO `tp5_xcms_logs` VALUES ('119', 'ARTICLE', '1', '取消推荐', '1', '2020-10-29 11:17:58');
INSERT INTO `tp5_xcms_logs` VALUES ('120', 'ARTICLE', '1', '推荐商品', '1', '2020-10-29 11:17:58');
INSERT INTO `tp5_xcms_logs` VALUES ('121', 'ARTICLE', '1', '文章更新', '1', '2020-11-03 16:06:43');
INSERT INTO `tp5_xcms_logs` VALUES ('122', 'ARTICLE', '1', '文章更新', '1', '2020-11-03 16:06:53');
INSERT INTO `tp5_xcms_logs` VALUES ('123', 'ARTICLE', '1', '文章更新', '1', '2020-11-06 18:18:38');
INSERT INTO `tp5_xcms_logs` VALUES ('124', 'GOODS', '2', '商品修改成功', '1', '2020-11-09 10:24:15');
INSERT INTO `tp5_xcms_logs` VALUES ('125', 'GOODS', '2', '商品修改成功', '1', '2020-11-09 11:27:29');
INSERT INTO `tp5_xcms_logs` VALUES ('126', 'GOODS', '2', '商品修改成功', '1', '2020-11-09 11:31:00');
INSERT INTO `tp5_xcms_logs` VALUES ('127', 'GOODS', '2', '商品修改成功', '1', '2020-11-09 11:31:48');
INSERT INTO `tp5_xcms_logs` VALUES ('128', 'GOODS', '4', '商品修改成功', '1', '2020-11-09 14:35:55');
INSERT INTO `tp5_xcms_logs` VALUES ('129', 'GOODS', '4', '商品修改成功', '1', '2020-11-09 21:36:24');
INSERT INTO `tp5_xcms_logs` VALUES ('130', 'GOODS', '1', '商品修改成功', '1', '2020-11-10 10:06:04');
INSERT INTO `tp5_xcms_logs` VALUES ('131', 'GOODS', '1', '商品修改成功', '1', '2020-11-10 10:14:24');
INSERT INTO `tp5_xcms_logs` VALUES ('132', 'GOODS', '3', '商品修改成功', '1', '2020-11-10 10:32:18');
INSERT INTO `tp5_xcms_logs` VALUES ('133', 'GOODS', '3', '商品修改成功', '1', '2020-11-10 10:45:49');
INSERT INTO `tp5_xcms_logs` VALUES ('134', 'GOODS', '2', '商品修改成功', '1', '2020-11-10 10:51:14');
INSERT INTO `tp5_xcms_logs` VALUES ('135', 'GOODS', '2', '商品修改成功', '1', '2020-11-10 10:59:02');
INSERT INTO `tp5_xcms_logs` VALUES ('136', 'GOODS', '4', '商品修改成功', '1', '2020-11-10 11:14:23');
INSERT INTO `tp5_xcms_logs` VALUES ('137', 'GOODS', '6', '商品修改成功', '1', '2020-11-10 11:21:48');
INSERT INTO `tp5_xcms_logs` VALUES ('138', 'GOODS', '6', '商品修改成功', '1', '2020-11-10 11:27:05');
INSERT INTO `tp5_xcms_logs` VALUES ('139', 'GOODS', '5', '商品修改成功', '1', '2020-11-10 11:31:17');
INSERT INTO `tp5_xcms_logs` VALUES ('140', 'GOODS', '7', '商品修改成功', '1', '2020-11-10 11:41:46');
INSERT INTO `tp5_xcms_logs` VALUES ('141', 'GOODS', '36', '添加商品', '1', '2020-11-10 14:34:49');
INSERT INTO `tp5_xcms_logs` VALUES ('142', 'GOODS', '36', '商品上架', '1', '2020-11-10 14:35:07');
INSERT INTO `tp5_xcms_logs` VALUES ('143', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 14:38:25');
INSERT INTO `tp5_xcms_logs` VALUES ('144', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 14:39:00');
INSERT INTO `tp5_xcms_logs` VALUES ('145', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 14:40:19');
INSERT INTO `tp5_xcms_logs` VALUES ('146', 'GOODS', '36', '商品下架', '1', '2020-11-10 14:42:18');
INSERT INTO `tp5_xcms_logs` VALUES ('147', 'GOODS', '36', '商品上架', '1', '2020-11-10 14:42:24');
INSERT INTO `tp5_xcms_logs` VALUES ('148', 'GOODS', '36', '删除商品', '1', '2020-11-10 16:04:24');
INSERT INTO `tp5_xcms_logs` VALUES ('149', 'GOODS', '2', '商品下架', '1', '2020-11-10 16:05:00');
INSERT INTO `tp5_xcms_logs` VALUES ('150', 'GOODS', '7', '商品下架', '1', '2020-11-10 16:09:56');
INSERT INTO `tp5_xcms_logs` VALUES ('151', 'GOODS', '7', '商品上架', '1', '2020-11-10 16:10:07');
INSERT INTO `tp5_xcms_logs` VALUES ('152', 'GOODS', '36', '删除商品', '1', '2020-11-10 16:10:20');
INSERT INTO `tp5_xcms_logs` VALUES ('153', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 16:20:08');
INSERT INTO `tp5_xcms_logs` VALUES ('154', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 16:33:12');
INSERT INTO `tp5_xcms_logs` VALUES ('155', 'ARTICLE', '1', '文章更新', '1', '2020-11-10 16:49:03');
INSERT INTO `tp5_xcms_logs` VALUES ('156', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 17:00:59');
INSERT INTO `tp5_xcms_logs` VALUES ('157', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 17:39:33');
INSERT INTO `tp5_xcms_logs` VALUES ('158', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 17:39:54');
INSERT INTO `tp5_xcms_logs` VALUES ('159', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 17:41:30');
INSERT INTO `tp5_xcms_logs` VALUES ('160', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 18:18:41');
INSERT INTO `tp5_xcms_logs` VALUES ('161', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 19:14:57');
INSERT INTO `tp5_xcms_logs` VALUES ('162', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 19:33:54');
INSERT INTO `tp5_xcms_logs` VALUES ('163', 'GOODS', '7', '商品修改成功', '1', '2020-11-10 19:39:15');
INSERT INTO `tp5_xcms_logs` VALUES ('164', 'GOODS', '5', '商品修改成功', '1', '2020-11-10 19:39:44');
INSERT INTO `tp5_xcms_logs` VALUES ('165', 'GOODS', '6', '商品修改成功', '1', '2020-11-10 19:40:00');
INSERT INTO `tp5_xcms_logs` VALUES ('166', 'GOODS', '4', '商品修改成功', '1', '2020-11-10 19:40:11');
INSERT INTO `tp5_xcms_logs` VALUES ('167', 'GOODS', '3', '商品修改成功', '1', '2020-11-10 19:40:24');
INSERT INTO `tp5_xcms_logs` VALUES ('168', 'GOODS', '1', '商品修改成功', '1', '2020-11-10 19:40:38');
INSERT INTO `tp5_xcms_logs` VALUES ('169', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 19:41:04');
INSERT INTO `tp5_xcms_logs` VALUES ('170', 'GOODS', '2', '商品修改成功', '1', '2020-11-10 19:43:49');
INSERT INTO `tp5_xcms_logs` VALUES ('171', 'GOODS', '36', '商品修改成功', '1', '2020-11-10 19:44:23');
INSERT INTO `tp5_xcms_logs` VALUES ('172', 'GOODS', '36', '商品修改成功', '1', '2020-11-17 15:06:08');
INSERT INTO `tp5_xcms_logs` VALUES ('173', 'GOODS', '36', '商品修改成功', '1', '2020-11-17 15:06:18');
INSERT INTO `tp5_xcms_logs` VALUES ('174', 'ARTICLE', '4', '文章更新', '1', '2020-11-18 18:45:04');
INSERT INTO `tp5_xcms_logs` VALUES ('175', 'GOODS', '36', '商品下架', '1', '2020-11-26 21:38:34');
INSERT INTO `tp5_xcms_logs` VALUES ('176', 'GOODS', '36', '商品上架', '1', '2020-11-26 21:38:35');
INSERT INTO `tp5_xcms_logs` VALUES ('177', 'GOODS', '36', '商品修改成功', '1', '2020-11-27 19:40:54');
INSERT INTO `tp5_xcms_logs` VALUES ('178', 'GOODS', '36', '商品修改成功', '1', '2020-11-27 19:42:51');
INSERT INTO `tp5_xcms_logs` VALUES ('179', 'GOODS', '36', '商品修改成功', '1', '2020-11-27 19:43:49');
INSERT INTO `tp5_xcms_logs` VALUES ('180', 'GOODS', '36', '商品修改成功', '1', '2020-11-27 19:53:49');
INSERT INTO `tp5_xcms_logs` VALUES ('181', 'GOODS', '36', '商品修改成功', '1', '2020-11-27 21:06:56');
INSERT INTO `tp5_xcms_logs` VALUES ('182', 'GOODS', '36', '商品修改成功', '1', '2020-12-01 16:09:15');
INSERT INTO `tp5_xcms_logs` VALUES ('183', 'GOODS', '37', '添加商品', '1', '2020-12-01 17:36:12');
INSERT INTO `tp5_xcms_logs` VALUES ('184', 'GOODS', '37', '商品上架', '1', '2020-12-01 17:36:55');
INSERT INTO `tp5_xcms_logs` VALUES ('185', 'GOODS', '38', '添加商品', '1', '2020-12-02 09:49:24');
INSERT INTO `tp5_xcms_logs` VALUES ('186', 'GOODS', '38', '商品上架', '1', '2020-12-02 09:49:43');
INSERT INTO `tp5_xcms_logs` VALUES ('187', 'GOODS', '38', '商品修改成功', '1', '2020-12-02 14:58:53');
INSERT INTO `tp5_xcms_logs` VALUES ('188', 'GOODS', '37', '商品修改成功', '1', '2020-12-02 15:00:48');
INSERT INTO `tp5_xcms_logs` VALUES ('189', 'GOODS', '37', '商品修改成功', '1', '2020-12-02 15:10:46');
INSERT INTO `tp5_xcms_logs` VALUES ('190', 'GOODS', '38', '商品修改成功', '1', '2020-12-02 15:48:30');
INSERT INTO `tp5_xcms_logs` VALUES ('191', 'GOODS', '36', '商品修改成功', '1', '2020-12-02 16:21:21');
INSERT INTO `tp5_xcms_logs` VALUES ('192', 'GOODS', '36', '删除商品', '1', '2020-12-02 16:21:59');
INSERT INTO `tp5_xcms_logs` VALUES ('193', 'GOODS', '37', '商品修改成功', '1', '2020-12-02 16:22:39');
INSERT INTO `tp5_xcms_logs` VALUES ('194', 'GOODS', '37', '商品修改成功', '1', '2020-12-02 16:23:30');
INSERT INTO `tp5_xcms_logs` VALUES ('195', 'GOODS', '38', '商品修改成功', '1', '2020-12-02 16:41:26');
INSERT INTO `tp5_xcms_logs` VALUES ('196', 'GOODS', '38', '商品修改成功', '1', '2020-12-02 16:41:39');
INSERT INTO `tp5_xcms_logs` VALUES ('197', 'GOODS', '37', '商品修改成功', '1', '2020-12-02 16:49:18');
INSERT INTO `tp5_xcms_logs` VALUES ('198', 'GOODS', '37', '删除商品', '1', '2020-12-02 17:27:59');
INSERT INTO `tp5_xcms_logs` VALUES ('199', 'GOODS', '38', '删除商品', '1', '2020-12-02 17:28:02');
INSERT INTO `tp5_xcms_logs` VALUES ('200', 'GOODS', '2', '商品上架', '1', '2020-12-02 17:28:14');
INSERT INTO `tp5_xcms_logs` VALUES ('201', 'GOODS', '36', '商品修改成功', '1', '2020-12-02 18:35:06');
INSERT INTO `tp5_xcms_logs` VALUES ('202', 'GOODS', '36', '商品修改成功', '1', '2020-12-02 18:37:46');
INSERT INTO `tp5_xcms_logs` VALUES ('203', 'GOODS', '8', '商品修改成功', '1', '2020-12-02 18:39:37');
INSERT INTO `tp5_xcms_logs` VALUES ('204', 'GOODS', '8', '商品修改成功', '1', '2020-12-02 18:40:32');
INSERT INTO `tp5_xcms_logs` VALUES ('205', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:16:32');
INSERT INTO `tp5_xcms_logs` VALUES ('206', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:17:38');
INSERT INTO `tp5_xcms_logs` VALUES ('207', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:20:50');
INSERT INTO `tp5_xcms_logs` VALUES ('208', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:21:12');
INSERT INTO `tp5_xcms_logs` VALUES ('209', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:24:15');
INSERT INTO `tp5_xcms_logs` VALUES ('210', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:32:24');
INSERT INTO `tp5_xcms_logs` VALUES ('211', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 19:34:54');
INSERT INTO `tp5_xcms_logs` VALUES ('212', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 20:16:55');
INSERT INTO `tp5_xcms_logs` VALUES ('213', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 21:37:36');
INSERT INTO `tp5_xcms_logs` VALUES ('214', 'GOODS', '2', '商品修改成功', '1', '2020-12-07 21:39:14');
INSERT INTO `tp5_xcms_logs` VALUES ('215', 'ARTICLE', '4', '文章更新', '1', '2020-12-07 21:42:11');
INSERT INTO `tp5_xcms_logs` VALUES ('216', 'ARTICLE', '4', '文章删除操作', '1', '2020-12-12 09:24:26');
INSERT INTO `tp5_xcms_logs` VALUES ('217', 'ARTICLE', '4', '文章删除操作', '1', '2020-12-12 09:25:29');
INSERT INTO `tp5_xcms_logs` VALUES ('218', 'ARTICLE', '4', '文章删除操作', '1', '2020-12-12 09:25:58');
INSERT INTO `tp5_xcms_logs` VALUES ('219', 'ARTICLE', '1', '文章删除操作', '1', '2020-12-12 09:39:49');
INSERT INTO `tp5_xcms_logs` VALUES ('220', 'ARTICLE', '2', '文章删除操作', '1', '2020-12-12 09:40:02');
INSERT INTO `tp5_xcms_logs` VALUES ('221', 'ARTICLE', '1', '文章删除操作', '1', '2020-12-12 09:45:16');
INSERT INTO `tp5_xcms_logs` VALUES ('222', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:46:11');
INSERT INTO `tp5_xcms_logs` VALUES ('223', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:48:54');
INSERT INTO `tp5_xcms_logs` VALUES ('224', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:51:29');
INSERT INTO `tp5_xcms_logs` VALUES ('225', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:52:50');
INSERT INTO `tp5_xcms_logs` VALUES ('226', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:53:05');
INSERT INTO `tp5_xcms_logs` VALUES ('227', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:53:50');
INSERT INTO `tp5_xcms_logs` VALUES ('228', 'ARTICLE', '4', '文章更新', '1', '2020-12-12 09:56:57');
INSERT INTO `tp5_xcms_logs` VALUES ('229', 'ARTICLE', '5', '添加文章数据', '1', '2020-12-12 09:58:08');
INSERT INTO `tp5_xcms_logs` VALUES ('230', 'ARTICLE', '5', '文章更新', '1', '2020-12-12 09:58:24');
INSERT INTO `tp5_xcms_logs` VALUES ('231', 'ARTICLE', '5', '文章更新', '1', '2020-12-12 09:58:44');
INSERT INTO `tp5_xcms_logs` VALUES ('232', 'ARTICLE', '5', '文章更新', '1', '2020-12-12 09:59:25');
INSERT INTO `tp5_xcms_logs` VALUES ('233', 'ARTICLE', '5', '文章更新', '1', '2020-12-12 10:00:57');
INSERT INTO `tp5_xcms_logs` VALUES ('234', 'GOODS', '1', '商品修改成功', '1', '2020-12-12 10:07:25');
INSERT INTO `tp5_xcms_logs` VALUES ('235', 'GOODS', '1', '商品修改成功', '1', '2020-12-12 10:07:39');
INSERT INTO `tp5_xcms_logs` VALUES ('236', 'ARTICLE', '5', '文章更新', '1', '2020-12-12 10:08:17');
INSERT INTO `tp5_xcms_logs` VALUES ('237', 'ARTICLE', '5', '文章删除操作', '1', '2020-12-12 10:08:41');
INSERT INTO `tp5_xcms_logs` VALUES ('238', 'ARTICLE', '6', '添加文章数据', '1', '2020-12-12 11:36:34');
INSERT INTO `tp5_xcms_logs` VALUES ('239', 'ARTICLE', '6', '文章更新', '1', '2020-12-12 11:38:02');
INSERT INTO `tp5_xcms_logs` VALUES ('240', 'ARTICLE', '7', '添加文章数据', '1', '2020-12-12 11:50:27');
INSERT INTO `tp5_xcms_logs` VALUES ('241', 'ARTICLE', '8', '添加文章数据', '1', '2020-12-12 11:52:32');
INSERT INTO `tp5_xcms_logs` VALUES ('242', 'ARTICLE', '9', '添加文章数据', '1', '2020-12-12 11:53:17');
INSERT INTO `tp5_xcms_logs` VALUES ('243', 'ARTICLE', '10', '添加文章数据', '1', '2020-12-12 11:56:18');
INSERT INTO `tp5_xcms_logs` VALUES ('244', 'ARTICLE', '10', '文章删除操作', '1', '2020-12-12 11:56:25');
INSERT INTO `tp5_xcms_logs` VALUES ('245', 'ARTICLE', '6', '文章删除操作', '1', '2020-12-12 11:56:28');
INSERT INTO `tp5_xcms_logs` VALUES ('246', 'ARTICLE', '11', '添加文章数据', '1', '2020-12-12 11:58:55');
INSERT INTO `tp5_xcms_logs` VALUES ('247', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:05:49');
INSERT INTO `tp5_xcms_logs` VALUES ('248', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:14:49');
INSERT INTO `tp5_xcms_logs` VALUES ('249', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:15:29');
INSERT INTO `tp5_xcms_logs` VALUES ('250', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:15:57');
INSERT INTO `tp5_xcms_logs` VALUES ('251', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:16:52');
INSERT INTO `tp5_xcms_logs` VALUES ('252', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:17:49');
INSERT INTO `tp5_xcms_logs` VALUES ('253', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:23:36');
INSERT INTO `tp5_xcms_logs` VALUES ('254', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:26:02');
INSERT INTO `tp5_xcms_logs` VALUES ('255', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:32:14');
INSERT INTO `tp5_xcms_logs` VALUES ('256', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:33:43');
INSERT INTO `tp5_xcms_logs` VALUES ('257', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:34:39');
INSERT INTO `tp5_xcms_logs` VALUES ('258', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:35:45');
INSERT INTO `tp5_xcms_logs` VALUES ('259', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:35:52');
INSERT INTO `tp5_xcms_logs` VALUES ('260', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:36:14');
INSERT INTO `tp5_xcms_logs` VALUES ('261', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:37:53');
INSERT INTO `tp5_xcms_logs` VALUES ('262', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:37:59');
INSERT INTO `tp5_xcms_logs` VALUES ('263', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:43:29');
INSERT INTO `tp5_xcms_logs` VALUES ('264', 'ARTICLE', '11', '文章更新', '1', '2020-12-12 12:43:37');
INSERT INTO `tp5_xcms_logs` VALUES ('265', 'ARTICLE', '11', '文章删除操作', '1', '2020-12-12 12:44:31');
INSERT INTO `tp5_xcms_logs` VALUES ('266', 'GOODS', '1', '商品修改成功', '1', '2020-12-12 12:59:34');
INSERT INTO `tp5_xcms_logs` VALUES ('267', 'GOODS', '1', '商品修改成功', '1', '2020-12-12 13:01:25');
INSERT INTO `tp5_xcms_logs` VALUES ('268', 'GOODS', '1', '商品修改成功', '1', '2020-12-12 13:02:22');
INSERT INTO `tp5_xcms_logs` VALUES ('269', 'ARTICLE', '1', '文章更新', '1', '2020-12-13 08:45:03');
INSERT INTO `tp5_xcms_logs` VALUES ('270', 'GOODS', '1', '商品修改成功', '1', '2020-12-13 08:54:19');
INSERT INTO `tp5_xcms_logs` VALUES ('271', 'GOODS', '1', '商品修改成功', '1', '2020-12-13 08:58:53');
INSERT INTO `tp5_xcms_logs` VALUES ('272', 'GOODS', '2', '商品修改成功', '1', '2020-12-15 09:32:13');
INSERT INTO `tp5_xcms_logs` VALUES ('273', 'ARTICLE', '2', '文章更新', '1', '2020-12-30 16:32:59');
INSERT INTO `tp5_xcms_logs` VALUES ('274', 'ARTICLE', '2', '文章更新', '1', '2020-12-30 16:33:58');
INSERT INTO `tp5_xcms_logs` VALUES ('275', 'ARTICLE', '2', '文章更新', '1', '2020-12-30 16:34:50');
INSERT INTO `tp5_xcms_logs` VALUES ('276', 'GOODS', '8', '商品修改成功', '1', '2021-01-04 14:06:32');
INSERT INTO `tp5_xcms_logs` VALUES ('277', 'GOODS', '8', '商品下架', '1', '2021-01-09 10:11:53');
INSERT INTO `tp5_xcms_logs` VALUES ('278', 'GOODS', '8', '商品上架', '1', '2021-01-09 10:12:01');

-- ----------------------------
-- Table structure for tp5_xconfigs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xconfigs`;
CREATE TABLE `tp5_xconfigs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID标记',
  `title` varchar(50) NOT NULL COMMENT '配置项标题',
  `tag` varchar(50) NOT NULL COMMENT '缩写标签 建议使用大写字母',
  `conf_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '配置类型 0：业务配置；1：系统配置',
  `input_type` varchar(20) NOT NULL COMMENT '配置项 输入类型，分为 text、number、file、checkbox、image',
  `value` varchar(100) NOT NULL DEFAULT '' COMMENT '配置项的 取值',
  `tip` varchar(100) NOT NULL COMMENT '配置项提示信息',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态  -1：删除  0：正常',
  `add_time` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' COMMENT '添加时间',
  PRIMARY KEY (`id`,`tag`),
  UNIQUE KEY `tag_index` (`tag`) USING BTREE,
  KEY `sel_index` (`title`,`tag`) USING BTREE COMMENT '便于查询',
  KEY `pk_index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='配置表';

-- ----------------------------
-- Records of tp5_xconfigs
-- ----------------------------
INSERT INTO `tp5_xconfigs` VALUES ('1', '我是一个文本1', 'WSWENBEN1', '0', 'text', '1', 'HELLO,不要乱改！', '2', '0', '2019-06-20 10:59:30');
INSERT INTO `tp5_xconfigs` VALUES ('2', '我是一个开关', 'SWITCHTOYOU', '0', 'checkbox', '1', 'HAHAHA', '0', '0', '2020-12-12 10:59:34');
INSERT INTO `tp5_xconfigs` VALUES ('3', '我是一个图片', 'TUPIAN1', '0', 'image', 'cms/images/headshot/wuHuang.png', '注意图片不要太大', '3', '0', '2020-12-12 10:59:38');
INSERT INTO `tp5_xconfigs` VALUES ('4', 'VIP会员费用', 'VIP_MONEY', '0', 'text', '10', 'VIP 就是牛!', '1', '0', '2020-12-01 08:32:09');

-- ----------------------------
-- Table structure for tp5_xgoods
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xgoods`;
CREATE TABLE `tp5_xgoods` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `goods_name` varchar(50) CHARACTER SET utf8mb4 NOT NULL COMMENT '商品名称',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品分类id',
  `brand_id` int(11) NOT NULL DEFAULT '0' COMMENT '品牌编号',
  `thumbnail` varchar(200) CHARACTER SET utf8mb4 NOT NULL COMMENT '缩略图，一般用于订单页的商品展示',
  `slide_imgs` varchar(600) CHARACTER SET utf8mb4 NOT NULL COMMENT '轮播图片，以逗号隔开',
  `sketch` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT '简述，字数不要太多，一般一句话',
  `list_order` int(11) NOT NULL DEFAULT '999' COMMENT '排序，越小越靠前',
  `details` text CHARACTER SET utf8mb4 NOT NULL COMMENT '商品描述详情',
  `market_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '市场价格',
  `selling_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品售价',
  `attr_info` text CHARACTER SET utf8mb4 NOT NULL COMMENT 'json形式保存的属性数据',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存，注意退货未支付订单时的数目变化',
  `created_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' COMMENT '商品创建时间',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '商品更新时间',
  `str_tags` varchar(300) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '标签，可用于搜索，以逗号隔开',
  `recommend` char(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0' COMMENT '推荐标志位',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态 -1：删除 0：未上架 1：已上架 2：预售 ',
  PRIMARY KEY (`goods_id`),
  KEY `idx_index` (`cat_id`,`brand_id`) USING BTREE,
  KEY `sel_index` (`goods_name`,`list_order`) USING BTREE,
  KEY `pk_index` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表\r\n\r\n注意：status 的规定，app 上只显示上架的产品哦';

-- ----------------------------
-- Records of tp5_xgoods
-- ----------------------------
INSERT INTO `tp5_xgoods` VALUES ('1', '香飘飘奶茶 Meco蜜谷果汁茶', '9', '7', 'cms/images/goods/1/1-1.jpg', '', '香飘飘奶茶 Meco蜜谷果汁茶 400ml 15杯 即饮饮料 整箱', '1', '<p>&middot;</p>', '50.55', '49.90', '[{\"spec_id\":\"25\",\"spec_info\":[{\"spec_name\":\"桃桃红柚口味400ml 8杯\",\"spec_id\":\"26\"},{\"spec_name\":\"樱桃莓莓口味400ml 8杯\",\"spec_id\":\"27\"},{\"spec_name\":\"金桔柠檬口味400ml 8杯\",\"spec_id\":\"28\"}],\"spec_name\":\"类别【香飘飘奶茶】\"}]', '501', '2019-11-28 10:51:31', '2020-12-13 08:58:53', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('2', '伊利 金典 纯牛奶250ml*16盒/箱（礼盒装）3.6g乳蛋白 120mg原生高钙', '10', '10', 'cms/images/goods/3/3-1.jpg', '', '光棍节 送男女朋友礼物糖果年货糖果礼物', '2', '<p><span style=\"color: #e03e2d;\">x<strong> dd</strong></span></p>', '120.00', '79.90', '[{\"spec_id\":\"34\",\"spec_info\":[{\"spec_name\":\"【健康有机】有机全脂纯牛奶16盒\",\"spec_id\":\"35\"},{\"spec_name\":\"【不加糖高蛋白】植选植物奶10瓶\",\"spec_id\":\"36\"}],\"spec_name\":\"规格【伊利金典纯牛奶】\"}]', '1499', '2019-03-11 18:03:26', '2020-12-15 09:32:13', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('3', '雀巢 Nestle 咖啡奶茶伴侣 风味饮料 无反式脂肪酸 奶油球 奶精球', '9', '8', 'cms/images/goods/2/2-1.jpg', '', '8月产蒙牛纯甄小蛮腰酸牛奶', '2', '                                                            <p style=\"text-align: center;\"><span style=\"font-size: 24px;\"><strong><span style=\"color: #843fa1;\">好营养，喝蒙牛！</span></strong></span></p>                                    ', '32.00', '28.90', '[{\"spec_id\":\"29\",\"spec_name\":\"口味\",\"spec_info\":[{\"spec_id\":31,\"spec_name\":\"原味奶油\"},{\"spec_id\":32,\"spec_name\":\"香浓奶油\"}]},{\"spec_id\":\"30\",\"spec_name\":\"数量\",\"spec_info\":[{\"spec_id\":33,\"spec_name\":\"50粒装\"}]}]', '300', '2019-11-29 09:42:38', '2020-11-10 19:40:24', '', '1', '1');
INSERT INTO `tp5_xgoods` VALUES ('4', '科沃斯（Ecovacs）地宝T5 Power扫地机器人扫拖一体机智能家用吸尘器激光导航规划全自动洗擦', '18', '2', 'cms/images/goods/4/4-1.jpg', '', '扫拖一体机智能家用吸尘器激光导航规划全自动洗擦拖地机DX93', '2', '                                                            <p><span style=\"color: #843fa1; font-family: Arial, \'microsoft yahei\'; font-size: 16px; font-weight: bold; background-color: #c2e0f4;\">科沃斯（Ecovacs）地宝T5 Power扫地机器人扫拖一体机智能家用吸尘器激光导航规划全自动洗擦拖地机DX93</span></p>                                    ', '3980.00', '3388.00', '[{\"spec_id\":\"37\",\"spec_info\":[{\"spec_name\":\"T8 Power震动擦地抢购\",\"spec_id\":\"38\"},{\"spec_name\":\"沁宝AVA（蓝色）空气净化机器人\",\"spec_id\":\"39\"}],\"spec_name\":\"颜色【科沃斯 Ecovacs 扫地机器人】\"}]', '1180', '2019-03-14 11:03:58', '2020-11-10 19:40:11', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('5', '索尼（SONY）WF-1000XM3 真无线蓝牙降噪耳机 ', '21', '18', 'cms/images/goods/6/6-0.jpg', '', '真无线蓝牙降噪耳机 智能降噪 触控面板 苹果/安卓手机适用 ', '1', '                    <p>x</p>            ', '1299.00', '1099.00', '[{\"spec_id\":\"4\",\"spec_info\":[{\"spec_name\":\"500ml\",\"spec_id\":\"5\"}],\"spec_name\":\"容量【小瓶】\"},{\"spec_id\":\"7\",\"spec_info\":[{\"spec_name\":\"40度\",\"spec_id\":\"8\"},{\"spec_name\":\"38度\",\"spec_id\":\"9\"}],\"spec_name\":\"酒精度数【白酒类型】\"}]', '4121', '2019-03-18 17:03:17', '2020-11-10 19:39:44', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('6', '小度智能音箱 旗舰版 ', '20', '15', 'cms/images/goods/5/5-1.jpg', '', '家居中控台 闹钟 收音机 智能机器人 迷你音响 早教机 送礼 礼品', '2', '                                        <p>q</p>\r\n<p> </p>                        ', '158.99', '129.99', '[{\"spec_id\":\"40\",\"spec_info\":[{\"spec_name\":\"【经典爆款】小度音箱旗舰版\",\"spec_id\":\"41\"},{\"spec_name\":\"【红外遥控】小度音箱升级版\",\"spec_id\":\"42\"},{\"spec_name\":\"【随身音箱】小芦蓝牙音箱\",\"spec_id\":\"43\"}],\"spec_name\":\"颜色【小度智能音箱 】\"}]', '237', '2019-03-11 18:03:26', '2020-11-10 19:40:00', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('7', '索尼（SONY）WF 重低音真无线耳机 IPX4防水防汗 智能操控', '21', '18', 'cms/images/goods/7/7-1.jpg', '', ' 重低音真无线耳机 IPX4防水防汗 智能操控', '0', '                    <p>X</p>            ', '129.00', '99.00', '[{\"spec_id\":\"44\",\"spec_info\":[{\"spec_name\":\"黑色\",\"spec_id\":\"46\"},{\"spec_name\":\"铂金银\",\"spec_id\":\"47\"}],\"spec_name\":\"颜色【索尼（SONY）WF】\"},{\"spec_id\":\"45\",\"spec_info\":[{\"spec_name\":\"WF-1000XM3随身降噪\",\"spec_id\":\"48\"},{\"spec_name\":\"WF-XB700防水运动\",\"spec_id\":\"49\"}],\"spec_name\":\"版本【索尼（SONY）WF】\"}]', '633', '2019-03-19 10:03:48', '2020-11-10 19:39:15', '', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('8', '商品测试数据', '21', '18', 'upload/20201110/3f2d55e101aa2a6a41e47408d128c21e.jpg', '', 'sd', '12', '<p>sd4</p>', '4.00', '1.00', '[{\"spec_id\":\"44\",\"spec_name\":\"颜色\",\"spec_info\":[{\"spec_id\":47,\"spec_name\":\"铂金银\"}]},{\"spec_id\":\"45\",\"spec_name\":\"版本\",\"spec_info\":[{\"spec_id\":48,\"spec_name\":\"WF-1000XM3随身降噪\"},{\"spec_id\":49,\"spec_name\":\"WF-XB700防水运动\"}]}]', '330', '2020-11-10 14:34:49', '2021-01-09 10:12:01', '', '0', '1');

-- ----------------------------
-- Table structure for tp5_xip_whites
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xip_whites`;
CREATE TABLE `tp5_xip_whites` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID 标识',
  `ip` varchar(20) NOT NULL COMMENT 'ip 地址',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态 1：正常；-1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='IP 白名单';

-- ----------------------------
-- Records of tp5_xip_whites
-- ----------------------------
INSERT INTO `tp5_xip_whites` VALUES ('1', '127.0.0.1', '1');
INSERT INTO `tp5_xip_whites` VALUES ('2', '210.12.84.30', '1');
INSERT INTO `tp5_xip_whites` VALUES ('3', '199.32.22.12', '1');
INSERT INTO `tp5_xip_whites` VALUES ('4', '22.132.1.3', '1');
INSERT INTO `tp5_xip_whites` VALUES ('5', '145.55.3.4', '1');
INSERT INTO `tp5_xip_whites` VALUES ('6', '122.4.5.7', '1');
INSERT INTO `tp5_xip_whites` VALUES ('7', '210.12.84.12', '-1');

-- ----------------------------
-- Table structure for tp5_xnav_menus
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xnav_menus`;
CREATE TABLE `tp5_xnav_menus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'navMenu 主键',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '菜单名称',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级菜单ID',
  `action` varchar(100) NOT NULL DEFAULT '' COMMENT 'action地址（etc:admin/home）',
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT '自定义图标样式',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，-1：删除',
  `list_order` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序标识，越小越靠前',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '导航类型 0：菜单类  1：权限链接',
  PRIMARY KEY (`id`),
  KEY `pk_index` (`id`),
  KEY `index_sel` (`list_order`,`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4 COMMENT='菜单导航表';

-- ----------------------------
-- Records of tp5_xnav_menus
-- ----------------------------
INSERT INTO `tp5_xnav_menus` VALUES ('136', '查看商品操作日志', '50', 'cms/goods/viewLogs', '', '1', '0', '2020-03-09 17:45:57', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('2', '菜单管理', '1', 'cms/menu/index', 'cms/images/icon/cms_menu_list.png', '1', '0', '2020-12-28 22:46:24', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('3', '列表管理', '0', '/', 'cms/images/icon/cms_desktop.png', '1', '2', '2020-12-28 22:46:28', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('4', '今日赠言', '3', 'cms/todayWord/index', 'cms/images/icon/cms_diplom.png', '1', '1', '2020-12-28 22:46:31', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('5', '文章列表', '3', 'cms/article/index', 'cms/images/icon/cms_adaptive.png', '1', '2', '2020-11-09 15:00:11', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('1', '管理分配', '0', '/', 'cms/images/icon/cms_manage.png', '1', '1', '2020-11-09 15:03:41', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('6', '管理人员', '1', 'cms/admin/index', 'cms/images/icon/cms_admin.png', '1', '3', '2020-11-09 15:03:13', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('7', '角色管理', '1', 'cms/admin/role', 'cms/images/icon/cms_role.png', '1', '2', '2020-11-09 15:02:51', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('29', '添加导航菜单', '2', 'cms/menu/add', '/', '1', '0', '2018-11-23 20:32:29', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('30', '导航菜单修改', '2', 'cms/menu/edit', '/', '1', '0', '2018-11-23 20:34:54', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('31', '菜单权限设置', '2', 'cms/menu/auth', '/', '1', '0', '2018-11-23 20:35:33', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('33', '添加今日赠言', '4', 'cms/todayWord/add', '/', '1', '0', '2018-11-23 20:37:59', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('34', '修改今日赠言', '4', 'cms/todayWord/edit', '/', '1', '0', '2018-11-23 20:38:17', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('36', '添加文章数据', '5', 'cms/article/add', '/', '1', '0', '2018-11-23 20:39:02', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('37', '修改文章数据', '5', 'cms/article/edit', '/', '1', '0', '2018-11-23 20:39:22', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('38', '添加管理员', '6', 'cms/admin/addAdmin', '/', '1', '0', '2019-08-11 17:05:41', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('39', '修改管理员数据', '6', 'cms/admin/editAdmin', '/', '1', '0', '2019-08-11 17:05:46', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('41', '增加角色', '7', 'cms/admin/addRole', '/', '1', '0', '2018-11-23 20:48:52', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('42', '修改角色数据', '7', 'cms/admin/editRole', '/', '1', '0', '2018-11-23 20:49:08', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('48', '产品分类', '49', 'cms/category/index', 'cms/images/icon/cms_category.png', '1', '1', '2020-11-09 15:01:23', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('49', '商品管理', '0', '/', 'cms/images/icon/cms_goods_manager.png', '1', '3', '2020-11-09 15:01:33', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('50', '商品列表', '49', 'cms/goods/index', 'cms/images/icon/cms_goods.png', '1', '0', '2020-11-09 15:00:56', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('51', '添加产品分类', '48', 'cms/category/add', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('52', '修改产品分类', '48', 'cms/category/edit', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('53', '删除产品分类', '48', 'cms/category/del', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('54', '商品添加', '50', 'cms/goods/add', '/', '1', '0', '2019-03-11 16:53:21', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('55', '商品修改', '50', 'cms/goods/edit', '/', '1', '0', '2019-03-11 16:53:43', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('58', 'ajax 更改上下架状态', '50', 'cms/goods/ajaxPutaway', '/', '1', '0', '2019-03-19 16:40:41', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('59', 'ajax 首页显示状态修改', '48', 'cms/category/ajaxForShow', '/', '1', '0', '2019-03-21 11:52:13', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('60', 'ajax 删除上传的图片', '50', 'cms/goods/ajaxDelUploadImg', '/', '-1', '0', '2020-09-15 16:57:40', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('66', 'ajax 根据分类获取的商品', '61', 'cms/activity/ajaxGetGoodsByCat', '/', '1', '0', '2020-11-17 21:13:02', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('67', '属性/规格', '49', 'cms/specInfo/index', 'cms/images/icon/cms_spec.png', '1', '3', '2020-11-09 21:17:08', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('68', '属性添加', '67', 'cms/specInfo/add', '/', '1', '0', '2019-03-31 17:07:51', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('69', '属性修改', '67', 'cms/specInfo/edit', '/', '1', '0', '2019-03-31 17:08:14', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('70', 'ajax 根据商品分类ID查询 品牌和父', '50', 'cms/goods/ajaxGetBrandAndSpecInfoFstByCat', '/', '1', '0', '2020-12-02 18:52:05', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('72', 'ajax 根据父级属性ID查询属性值', '50', 'cms/goods/ajaxGetSpecInfoBySpecFst', '/', '1', '0', '2020-12-02 18:52:32', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('61', '活动列表', '3', 'cms/activity/index', 'cms/images/icon/cms_activity.png', '1', '4', '2020-11-09 14:59:40', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('62', '活动添加', '61', 'cms/activity/add', '/', '1', '0', '2019-03-29 11:35:17', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('63', '活动修改', '61', 'cms/activity/edit', '/', '1', '0', '2019-03-29 11:35:38', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('65', 'ajax 首页显示状态修改', '61', 'cms/activity/ajaxForShow', '/', '1', '0', '2019-03-29 11:36:35', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('73', '用户列表', '3', 'cms/users/index', 'cms/images/icon/cms_users.png', '1', '6', '2020-11-11 11:09:04', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('75', 'ajax 修改用户状态', '73', 'cms/users/ajaxUpdateUserStatus', '/', '1', '0', '2019-07-09 17:22:57', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('76', '广告列表', '3', 'cms/adList/index', 'cms/images/icon/cms_ad.png', '1', '5', '2020-11-09 14:54:24', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('77', '广告添加', '76', 'cms/adList/add', '/', '1', '0', '2019-07-19 18:10:55', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('80', 'ajax 首页显示广告状态修改', '76', 'cms/adList/ajaxForShow', '/', '1', '0', '2019-07-19 18:11:23', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('78', '广告修改', '76', 'cms/adList/edit', '/', '1', '0', '2019-07-19 18:11:00', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('92', 'ajax 文章推荐操作', '5', 'cms/article/ajaxForRecommend', '/', '1', '0', '2019-07-22 16:22:01', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('93', '业务配置', '3', 'cms/config/index', 'cms/images/icon/cms_config.png', '1', '3', '2020-11-09 14:53:56', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('94', '添加配置项', '93', 'cms/config/add', '/', '1', '0', '2019-07-26 15:08:38', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('95', '配置项修改', '93', 'cms/config/edit', '/', '1', '0', '2019-07-29 14:30:13', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('99', '规格数据展示', '67', 'cms/specInfo/details', '/', '1', '0', '2019-11-14 16:08:47', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('133', '监控统计', '0', '/', 'cms/images/icon/cms_analyze.png', '1', '5', '2020-11-11 09:18:03', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('134', '热销商品', '133', 'cms/analyze/hotSale', 'cms/images/icon/cms_hot_sale_pie.png', '1', '0', '2020-11-12 14:28:00', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('135', '查看文章操作日志', '5', 'cms/article/viewLogs', '', '1', '0', '2020-03-09 17:06:40', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('137', '动态配置开关状态', '93', 'cms/config/ajaxUpdateSwitchValue', '/', '1', '0', '2020-05-25 18:05:34', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('138', '系统配置', '0', '/', 'cms/images/icon/cms_config_system.png', '1', '0', '2020-06-02 19:55:33', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('139', '登录认证', '138', 'cms/sysConf/auth', 'cms/images/icon/cms_auth.png', '1', '1', '2020-06-02 19:55:31', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('140', '文件上传', '138', 'cms/sysConf/opfile', 'cms/images/icon/cms_upload.png', '1', '2', '2020-06-05 20:29:14', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('141', 'IP 白名单', '138', 'cms/sysConf/ipWhite', 'cms/images/icon/cms_ip.png', '1', '3', '2020-06-02 19:55:27', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('142', '品牌列表', '49', 'cms/brand/index', 'cms/images/icon/cms_brand.png', '1', '2', '2020-11-09 20:28:35', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('143', '品牌添加操作', '142', 'cms/brand/add', '/', '1', '0', '2020-11-09 20:28:32', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('144', '品牌的更新操作', '142', 'cms/brand/edit', '/', '1', '0', '2020-11-09 20:28:25', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('145', '订单管理', '0', '/', 'cms/images/icon/cms_order_manager.png', '1', '4', '2020-11-11 09:21:15', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('146', '支付订单', '145', 'cms/order/index', 'cms/images/icon/cms_order_info.png', '1', '1', '2020-11-11 09:20:35', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('147', '售货清单', '145', 'cms/order/details', 'cms/images/icon/cms_order_details.png', '1', '2', '2020-11-11 09:21:40', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('148', 'ajax 获取购物清单', '146', 'cms/order/ajaxGetShoppingList', '/', '1', '0', '2020-11-11 16:31:15', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('149', '添加物流单号', '147', 'cms/order/opCourierSn', '/', '1', '0', '2020-11-11 21:15:32', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('150', '查看物流信息', '147', 'cms/order/lookLogistics', '/', '1', '0', '2020-11-11 20:56:55', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('151', '24时销量图', '133', 'cms/analyze/timeSale', 'cms/images/icon/cms_time_sale.png', '1', '0', '2020-11-12 14:21:58', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('156', 'React 学习', '155', 'cms/expand/react', 'cms/images/icon/cms_react.png', '1', '3', '2020-12-13 10:02:51', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('153', 'ajax 获取正常状态的分类数据', '50', 'cms/goods/ajaxGetNormalCatList', '/', '1', '0', '2020-11-26 18:34:18', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('155', '拓展学习', '0', '/', 'cms/images/icon/cms_expand.png', '1', '6', '2020-12-13 10:02:43', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('157', 'Test 测试页', '155', 'cms/expand/test', 'cms/images/icon/cms_test.png', '1', '0', '2020-12-13 10:08:14', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('158', '操作Excel 实例', '155', 'cms/expand/opExcel', 'cms/images/icon/cms_Excel.png', '1', '3', '2020-12-28 22:47:07', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('159', 'Redis 学习', '155', 'cms/expand/redisTest', 'cms/images/icon/cms_redis_test.png', '1', '4', '2020-12-29 19:38:46', '0');

-- ----------------------------
-- Table structure for tp5_xop_excel
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xop_excel`;
CREATE TABLE `tp5_xop_excel` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `goods_name` varchar(50) NOT NULL DEFAULT '' COMMENT '商品名称',
  `thumbnail` varchar(200) NOT NULL DEFAULT '' COMMENT '缩略图，一般用于订单页的商品展示',
  `place` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '1' COMMENT '产地，国家：美国、澳大利亚等',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  `reference_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品参考价',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' COMMENT '商品更新时间',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态 -1：删除 0：待上架 1：已上架 2：预售 ',
  PRIMARY KEY (`goods_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='商品表. 注意：status 的规定，app 上只显示上架的产品哦';

-- ----------------------------
-- Records of tp5_xop_excel
-- ----------------------------
INSERT INTO `tp5_xop_excel` VALUES ('1', 'GEMEZ 小鸡干脆面（辣味）420g(14g*30)', '/upload/20191006/2842125f4fe5ab6f99e2c0462d623dbe.jpg', '印度尼西亚', '0', '50.90', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('2', '麦可利槟城红酸辣汤面四连包 420g*3', '/upload/20190814/b08cf910ae974a3dfe1ae3153d285392.jpg', '马来西亚', '0', '60.90', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('3', '老板仔脆紫菜海鲜味 32g*4', '/upload/20190814/135c27f1436bec0d79c2e66564db13f8.jpg', '泰国', '0', '39.00', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('4', '麦可利槟城香辣虾汤面四连包 420g*3', '/upload/20190929/4daa5ef000a85b93ccb16e9181cc9b72.jpg', '马来西亚', '0', '60.90', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('5', '纳宝帝丽芝士奶酪威化饼干145g*5', '/upload/20190820/d3a6861665a607b9db89cdf2fc63e655.jpg', '印度尼西亚', '0', '42.00', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('6', 'Gery芝莉黑巧克力味夹心卷160g*5', '/upload/20190917/adb2b26c279aca4f3e416624165c9653.jpg', '印度尼西亚', '0', '58.00', '2020-12-16 18:05:56', '0');
INSERT INTO `tp5_xop_excel` VALUES ('7', 'GEMEZ 小鸡干脆面（辣味）420g(14g*30)', '/upload/20191006/2842125f4fe5ab6f99e2c0462d623dbe.jpg', '印度尼西亚', '0', '50.90', '2020-12-16 20:10:14', '0');
INSERT INTO `tp5_xop_excel` VALUES ('8', '麦可利槟城红酸辣汤面四连包 420g*3', '/upload/20190814/b08cf910ae974a3dfe1ae3153d285392.jpg', '马来西亚', '0', '60.90', '2020-12-16 20:10:14', '0');
INSERT INTO `tp5_xop_excel` VALUES ('9', '老板仔脆紫菜海鲜味 32g*4', '/upload/20190814/135c27f1436bec0d79c2e66564db13f8.jpg', '泰国', '0', '39.00', '2020-12-16 20:10:14', '0');
INSERT INTO `tp5_xop_excel` VALUES ('10', '麦可利槟城香辣虾汤面四连包 420g*3', '/upload/20190929/4daa5ef000a85b93ccb16e9181cc9b72.jpg', '马来西亚', '0', '60.90', '2020-12-16 20:10:14', '0');
INSERT INTO `tp5_xop_excel` VALUES ('11', '纳宝帝丽芝士奶酪威化饼干145g*5', '/upload/20190820/d3a6861665a607b9db89cdf2fc63e655.jpg', '印度尼西亚', '0', '42.00', '2020-12-16 20:10:14', '0');
INSERT INTO `tp5_xop_excel` VALUES ('12', 'Gery芝莉黑巧克力味夹心卷160g*5', '/upload/20190917/adb2b26c279aca4f3e416624165c9653.jpg', '印度尼西亚', '0', '58.00', '2020-12-16 20:10:14', '0');

-- ----------------------------
-- Table structure for tp5_xorder_details
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xorder_details`;
CREATE TABLE `tp5_xorder_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL COMMENT '订单编码',
  `goods_id` int(11) NOT NULL COMMENT '商品编码，便于后期统计',
  `goods_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称，记录以免后期商家更改',
  `goods_thumbnail` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '记录商品的缩略图',
  `goods_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价 记录以防变化',
  `goods_num` int(11) NOT NULL DEFAULT '1' COMMENT '购买数量',
  `goods_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品总价，(不能单纯的以为是 单价*数量)',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '折扣额度',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品SKU_ID,方便后期统计分析',
  `sku_spec_msg` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '记录 商品规格信息，避免后期变动',
  `remark` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '客户商品备注',
  `courier_sn` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '快递单号',
  `courier_code` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '快递公司编号 (比如：快递鸟对应 )',
  `customer_name` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'courier_code 为 JD，必填，对应京东的青龙配送编码，也叫商家编码',
  `created_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `delivery_time` int(11) NOT NULL DEFAULT '0' COMMENT '发货时间',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '订单状态 -1：已取消；0：正常订单； 1：已支付; 2：已发货； 3：已收货 4：已评价 ；5：售后申请中 6：售后已完成  ',
  PRIMARY KEY (`id`),
  KEY `order_detail_order_id_index` (`order_id`),
  KEY `index_sel` (`goods_id`,`goods_name`(191),`sku_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of tp5_xorder_details
-- ----------------------------
INSERT INTO `tp5_xorder_details` VALUES ('1', '1', '2', '伊利 金典 纯牛奶250ml*16盒/箱', 'cms/images/goods/3/3-2.jpg', '79.90', '3', '220.00', '12.00', '101', '【不加糖高蛋白】植选植物奶10瓶', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '1');
INSERT INTO `tp5_xorder_details` VALUES ('2', '2', '3', '雀巢 Nestle 咖啡奶茶伴侣', 'cms/images/goods/2/2-1.jpg', '28.90', '1', '28.90', '3.88', '87', '原味奶油,50粒装', '', 'SF1043866372860', 'SF', '8776', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '1605152135', '2');
INSERT INTO `tp5_xorder_details` VALUES ('3', '2', '4', '科沃斯（Ecovacs）地宝T5 Power扫地机器人', 'cms/images/goods/4/4-1.jpg', '3388.00', '2', '6689.00', '120.00', '91', 'T8 Power震动擦地抢购', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '6');
INSERT INTO `tp5_xorder_details` VALUES ('4', '3', '7', '索尼（SONY）WF-1000XM3 真无线蓝牙降噪耳机', 'cms/images/goods/7/7-3.jpg', '1099.00', '3', '3281.00', '3.50', '3', '', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '3');
INSERT INTO `tp5_xorder_details` VALUES ('5', '1', '1', '香飘飘奶茶 Meco蜜谷果汁茶', 'cms/images/goods/1/1-1.jpg', '49.90', '2', '99.80', '0.00', '84', '桃桃红柚口味400ml 8杯', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '0');
INSERT INTO `tp5_xorder_details` VALUES ('6', '5', '1', '香飘飘奶茶 Meco蜜谷果汁茶', 'cms/images/goods/1/1-1.jpg', '49.90', '1', '49.90', '0.00', '84', '桃桃红柚口味400ml 8杯', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '-1');
INSERT INTO `tp5_xorder_details` VALUES ('7', '5', '3', '雀巢 Nestle 咖啡奶茶伴侣', 'cms/images/goods/2/2-2.jpg', '28.90', '2', '55.68', '1.25', '88', '香浓奶油,50粒装', '', '73141396805899', 'ZTO', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '1605149346', '2');
INSERT INTO `tp5_xorder_details` VALUES ('8', '5', '6', '小度智能音箱 旗舰版', 'cms/images/goods/5/5-1.jpg', '129.99', '2', '250.00', '6.50', '93', '【经典爆款】小度音箱旗舰版', '', 'JDX001665245202', 'JD', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '1605152295', '2');
INSERT INTO `tp5_xorder_details` VALUES ('9', '4', '2', '伊利 金典 纯牛奶250ml*16盒/箱', 'cms/images/goods/3/3-1.jpg', '79.90', '1', '79.90', '0.00', '100', '【健康有机】有机全脂纯牛奶16盒', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '0');
INSERT INTO `tp5_xorder_details` VALUES ('10', '6', '7', '索尼（SONY）WF-1000XM3 真无线蓝牙降噪耳机', 'cms/images/goods/7/7-3.jpg', '1099.00', '2', '2000.00', '188.00', '2', '', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '4');
INSERT INTO `tp5_xorder_details` VALUES ('11', '7', '7', '索尼（SONY）WF 重低音真无线耳机', 'cms/images/goods/7/7-2.jpg', '99.00', '1', '99.00', '0.00', '96', '黑色,WF-1000XM3随身降噪', '', '', '', '', '2020-11-17 11:26:57', '2020-11-17 11:26:57', '0', '5');

-- ----------------------------
-- Table structure for tp5_xorder_infos
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xorder_infos`;
CREATE TABLE `tp5_xorder_infos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID,标识',
  `order_sn` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号，方便用户查询',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '客户编号',
  `pay_channel` tinyint(2) NOT NULL DEFAULT '0' COMMENT '支付渠道  0:微信; 1:支付宝; 2:余额',
  `pay_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际付款金额',
  `reduce_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '减免金额 ，一般用于记录积分抵扣的额度',
  `logistics_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `consignee` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人的姓名',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '收货人的手机',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '收货人的详细地址',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '付款时间',
  `pay_result_json` text NOT NULL COMMENT '支付结果的json数据，比如微信小程序支付后的 返回信息 json形式,方便后期的退款操作',
  `created_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00',
  `order_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '订单状态 0:未付款, 1:已付款，2：用户删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_order_sn` (`order_sn`) USING BTREE,
  KEY `index_user_id` (`user_id`),
  KEY `index_address` (`consignee`,`mobile`),
  KEY `index_pay_time` (`pay_time`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='订单信息表';

-- ----------------------------
-- Records of tp5_xorder_infos
-- ----------------------------
INSERT INTO `tp5_xorder_infos` VALUES ('1', 'MT202011110725678', '2', '0', '280.50', '0.00', '12.00', '鲁班大师', '18890459021', '鬼谷子山脉-稷下星之队-机关科学研究院303室', '1605067929', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '1');
INSERT INTO `tp5_xorder_infos` VALUES ('2', 'MT202011100715190', '1', '1', '500.00', '35.62', '10.00', '东皇太一', '181-2298-9098', '战国时期楚国-祭礼仪式和祭神场一号洞窟北30米', '1605077946', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '1');
INSERT INTO `tp5_xorder_infos` VALUES ('3', 'MT202011090223189', '2', '0', '300.50', '0.00', '6.00', '宫本武藏', '121-3345-9980', '日本-大和故乡 忍者部落夜行者7号院 0071', '1604980800', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '-1');
INSERT INTO `tp5_xorder_infos` VALUES ('4', 'MT202011098872345', '3', '1', '129.90', '0.00', '0.00', '上官婉儿', '18988988836', '北海部落-掖庭一号图书馆北里303号', '0', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '0');
INSERT INTO `tp5_xorder_infos` VALUES ('5', 'MT202011083299813', '4', '0', '127.88', '2.80', '6.00', '太乙真人', '151-0909-2928', '九重天-吾乃太乙，胆小的太乙，懦弱的太乙，傻瓜的太乙', '1605009180', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '1');
INSERT INTO `tp5_xorder_infos` VALUES ('6', 'MT202011083325667', '6', '0', '38.99', '2.88', '0.00', '不知火舞', '188-3398-3349', '日本-饿狼传说-不知火流忍术派-不老药修炼室', '1604891040', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '1');
INSERT INTO `tp5_xorder_infos` VALUES ('7', 'MT202011078878990', '3', '0', '289.88', '0.00', '6.00', '鲁班七号', '18756879879', '战国外邦-鲁班大师精修第一班级北门守卫室', '1605057721', '', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '2020-11-17 11:25:20', '1');

-- ----------------------------
-- Table structure for tp5_xphotos
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xphotos`;
CREATE TABLE `tp5_xphotos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `picture` varchar(255) NOT NULL COMMENT '图片存放位置',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COMMENT='图片资源表';

-- ----------------------------
-- Records of tp5_xphotos
-- ----------------------------
INSERT INTO `tp5_xphotos` VALUES ('8', 'cms/images/headshot/user8.png');
INSERT INTO `tp5_xphotos` VALUES ('2', 'cms/images/headshot/user2.png');
INSERT INTO `tp5_xphotos` VALUES ('4', 'cms/images/headshot/user4.png');
INSERT INTO `tp5_xphotos` VALUES ('7', 'cms/images/headshot/user7.png');
INSERT INTO `tp5_xphotos` VALUES ('6', 'cms/images/headshot/user6.png');
INSERT INTO `tp5_xphotos` VALUES ('3', 'cms/images/headshot/user3.png');
INSERT INTO `tp5_xphotos` VALUES ('1', 'cms/images/headshot/user1.png');
INSERT INTO `tp5_xphotos` VALUES ('9', 'cms/images/headshot/user9.png');
INSERT INTO `tp5_xphotos` VALUES ('5', 'cms/images/headshot/user5.png');

-- ----------------------------
-- Table structure for tp5_xpro_dev_logs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xpro_dev_logs`;
CREATE TABLE `tp5_xpro_dev_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_content` varchar(100) NOT NULL COMMENT '日志内容',
  `log_time` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `pk_index` (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COMMENT='管理平台 开发日志表';

-- ----------------------------
-- Records of tp5_xpro_dev_logs
-- ----------------------------
INSERT INTO `tp5_xpro_dev_logs` VALUES ('1', '公共文件优化、替换;', '2018-06-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('2', '管理系统测试已基本可以使用;', '2018-06-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('3', '补充 404,500异常效果，剔除不用的 public/upload 资源;', '2018-06-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('4', '第一版本框架源码完善，Github上传;', '2018-06-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('5', '补充对 model 类操作的规则验证(validate);', '2018-11-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('6', '优化菜单栏链接，排除跳转无效的Bug;', '2018-11-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('7', '优化管理员角色权限设置', '2018-11-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('8', '数据库表字段优化，文件 tp5_pro.sql上传;', '2018-11-21 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('9', '导航菜单的图标统一资源替换，展示效果人性化;', '2018-11-21 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('10', '对公共布局文件 css、js 的命名尽量统一规划，删减冗余代码;', '2018-11-21 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('11', '优化了页面的边框显示问题，主要是自己看着顺眼、中意;', '2018-11-22 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('12', '顺带变更了几个图片资源;', '2018-11-22 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('13', '首页补充了面板功能，可以清晰展示更新时间线;', '2018-11-22 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('14', '博客同步更新;', '2018-11-22 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('15', '优化后台管理员访问权限;', '2018-11-24 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('16', '优化排除 Linux对路径索引大小写敏感无法识别的 Bug', '2018-11-24 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('17', '对数据表 \"tp5_nav_menus\" 添加字段 \"type\";用以区别导航菜单与权限路径;', '2018-11-24 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('18', '补充了 \"文章管理\" 和 \"今日赠言\" 的分页获取功能;', '2018-11-24 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('19', '补充几天前错删的 role.js 文件;', '2018-11-28 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('20', '对公共类 BaseModel 中的 validate() 进行了优化;', '2018-11-28 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('21', '补充了 ThinkPHP5.1 下的表单令牌功能;', '2018-11-28 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('22', '更新了所有的 model类，降低 CSRF 恶意攻击', '2018-11-28 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('23', 'tp5.sql文件更新，增加表 \"nav_menus\"的 \"action\"字段长度;', '2018-11-29 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('24', '优化登录、登出判断逻辑;删减了之前没必要存在的页面重定向;', '2018-11-29 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('25', '加登录管理员的个人信息页;', '2018-11-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('26', '可进行账号密码等重要信息的修改;', '2018-11-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('27', '后台入口更改为 xxxxx.com/cmsx;', '2018-11-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('28', '添加登录页的验证码功能 (ThinkPHP5.1 内置功能)', '2018-11-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('29', '图片上传功能修改替换反斜线 “\\”为“/”', '2019-03-15 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('30', '列表页分页功能显示调整', '2019-03-15 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('31', '补充商品分类、商品管理功能', '2019-03-27 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('32', '添加多图上传功能', '2019-03-27 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('33', '整理分类及商品搜索功能', '2019-03-27 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('34', '调整 UEditor 编辑器遮挡下拉控件bug', '2019-03-27 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('35', '针对 PHP5.6 php.ini 修改：always_populate_raw_post_data = -1', '2019-05-05 20:39:52');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('36', '完善商品SKU(销售规格)功能', '2019-05-05 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('37', '添加规格管理功能', '2019-05-05 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('38', '添加了商品活动列表', '2019-07-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('39', '添加了用户展示列表', '2019-07-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('40', '设计补充配置项管理功能', '2019-07-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('41', '优化页面下拉列表的搜索功能', '2019-07-30 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('42', '设计商品管理功能、优化 SKU编辑', '2019-11-25 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('43', '完善代码注释，优化数据库,更新 .sql文件', '2019-11-25 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('44', '上传 ECHARTS 图表库', '2019-12-05 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('45', '设计商品价格区间统计饼状图', '2019-12-05 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('46', '梳理规范示例图片资源', '2019-12-05 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('47', '更新 SKU 数据，便于展示效果', '2019-12-05 20:39:45');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('48', '设计补充表 tp5_xcms_logs', '2020-03-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('49', '设计商品、文章操作日志记录功能', '2020-03-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('50', '公共方法文件: getCmsOpViewLogs()', '2020-03-09 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('51', '优化用户登录认证的加密保存,建议修改 /api/IAuth.php 的配置信息', '2020-06-01 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('52', '设计 \"系统配置-IP白名单\" 功能', '2020-06-01 20:39:35');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('53', '补充\"系统配置-FTP\"功能', '2020-06-01 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('54', '集成使用 TinyMCE,替换 UEditor 编辑器', '2020-09-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('55', '优化处理文件文件上传代码逻辑', '2020-09-04 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('56', '集成使用了框架 GatewayWorker', '2020-10-25 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('57', '设计了平台管理员的即时通讯窗口', '2020-10-25 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('58', '注意添加的顶部导航栏中的 \"消息\"！', '2020-10-25 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('59', '补充设计订单管理功能', '2020-11-11 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('60', '整体优化列表搜索效果', '2020-11-11 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('61', '集成使用 Echarts 图标框架，设计监控统计图', '2020-11-11 20:39:23');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('62', 'React-hooks 引入优化', '2020-12-02 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('63', '角色列表 ，React (类实现)替换', '2020-12-02 00:00:00');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('64', '商品添加、修改页，使用钩子(函数实现)优化 SKU 操作', '2020-12-02 20:39:12');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('65', '设计 “开发日志表”，并读取日志信息 ', '2020-12-02 20:47:17');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('66', '提示信息样式风格统一化', '2020-12-13 09:08:27');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('67', '小程序登录接口开发', '2020-12-13 09:08:27');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('68', '管理员权限优化', '2020-12-13 09:08:27');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('69', '后台登录 IAuth优化，密码 hash', '2020-12-13 09:09:04');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('70', '集成 phpspreadshee 使用类', '2020-12-13 09:30:12');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('71', '页面静态化核心处理方法： staticFetch()', '2020-12-30 17:20:58');
INSERT INTO `tp5_xpro_dev_logs` VALUES ('72', 'Redis-hash 记录购物车操作: cartOpRedis() ', '2020-12-30 17:21:25');

-- ----------------------------
-- Table structure for tp5_xskus
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xskus`;
CREATE TABLE `tp5_xskus` (
  `sku_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_img` varchar(150) CHARACTER SET utf8 NOT NULL COMMENT '对应的SKU商品缩略图',
  `spec_info` varchar(300) CHARACTER SET utf8 NOT NULL COMMENT '对应的商品 sku 属性信息，以竖线隔开。举例：12-15-23',
  `spec_name` varchar(300) CHARACTER SET utf8 NOT NULL COMMENT 'sku 规格描述，仅供展示',
  `selling_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品售价',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存',
  `sold_num` int(11) NOT NULL DEFAULT '0' COMMENT '销量',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `sku_status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态   -1：删除（失效）；0: 下架(未上架)；1:上架',
  PRIMARY KEY (`sku_id`),
  KEY `index_sel` (`goods_id`,`sku_id`,`spec_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COMMENT='商品 SKU 库存表\r\n\r\n用于存储商品不同属性搭配的数目、价格等';

-- ----------------------------
-- Records of tp5_xskus
-- ----------------------------
INSERT INTO `tp5_xskus` VALUES ('84', '1', 'cms/images/goods/1/1-1.jpg', '26', '桃桃红柚口味400ml 8杯', '49.90', '99', '4', '2020-12-13 08:58:53', '1');
INSERT INTO `tp5_xskus` VALUES ('85', '1', 'cms/images/goods/1/1-2.jpg', '27', '樱桃莓莓口味400ml 8杯', '49.90', '202', '5', '2020-12-13 08:58:53', '1');
INSERT INTO `tp5_xskus` VALUES ('86', '1', 'cms/images/goods/1/1-3.jpg', '28', '金桔柠檬口味400ml 8杯', '46.90', '200', '8', '2020-12-13 08:58:53', '0');
INSERT INTO `tp5_xskus` VALUES ('87', '3', 'cms/images/goods/2/2-1.jpg', '31-33', '原味奶油,50粒装', '28.90', '200', '121', '2020-12-02 15:18:09', '1');
INSERT INTO `tp5_xskus` VALUES ('88', '3', 'cms/images/goods/2/2-2.jpg', '32-33', '香浓奶油,50粒装', '39.90', '100', '2', '2020-12-02 15:18:15', '1');
INSERT INTO `tp5_xskus` VALUES ('89', '2', 'cms/images/goods/3/3-1.jpg', '35', '【健康有机】有机全脂纯牛奶16盒', '94.90', '290', '1212', '2020-12-15 09:32:13', '1');
INSERT INTO `tp5_xskus` VALUES ('90', '2', 'cms/images/goods/3/3-2.jpg', '36', '【不加糖高蛋白】植选植物奶10瓶', '49.90', '1209', '232', '2020-12-15 09:32:13', '1');
INSERT INTO `tp5_xskus` VALUES ('91', '4', 'cms/images/goods/4/4-1.jpg', '38', 'T8 Power震动擦地抢购', '3399.00', '1000', '12', '2020-11-10 19:40:11', '1');
INSERT INTO `tp5_xskus` VALUES ('92', '4', 'cms/images/goods/4/4-2.jpg', '39', '沁宝AVA（蓝色）空气净化机器人', '6999.00', '180', '3', '2020-11-10 19:40:11', '1');
INSERT INTO `tp5_xskus` VALUES ('93', '6', 'cms/images/goods/5/5-1.jpg', '41', '【经典爆款】小度音箱旗舰版', '129.00', '112', '21', '2020-11-10 19:40:00', '1');
INSERT INTO `tp5_xskus` VALUES ('94', '6', 'cms/images/goods/5/5-2.jpg', '42', '【红外遥控】小度音箱升级版', '99.00', '2', '2', '2020-11-10 19:40:00', '1');
INSERT INTO `tp5_xskus` VALUES ('95', '6', 'cms/images/goods/5/5-3.jpg', '43', '【随身音箱】小芦蓝牙音箱', '59.00', '123', '11', '2020-11-10 19:40:00', '1');
INSERT INTO `tp5_xskus` VALUES ('96', '7', 'cms/images/goods/7/7-1.jpg', '46-48', '黑色,WF-1000XM3随身降噪', '1099.00', '199', '1', '2020-12-02 15:18:19', '1');
INSERT INTO `tp5_xskus` VALUES ('97', '7', 'cms/images/goods/7/7-2.jpg', '46-49', '黑色,WF-XB700防水运动', '699.00', '200', '21', '2020-12-02 15:18:24', '1');
INSERT INTO `tp5_xskus` VALUES ('98', '7', 'cms/images/goods/7/7-3.jpg', '47-48', '铂金银,WF-1000XM3随身降噪', '1099.00', '123', '2', '2020-12-02 15:18:28', '1');
INSERT INTO `tp5_xskus` VALUES ('99', '7', 'cms/images/goods/7/7-2.jpg', '47-49', '铂金银,WF-XB700防水运动', '699.00', '111', '2', '2020-12-02 15:18:33', '0');
INSERT INTO `tp5_xskus` VALUES ('100', '8', 'upload/20201202/0b55a453c51b18337d2d3003f108722f.jpeg', '47-48', '铂金银,WF-1000XM3随身降噪', '25.00', '10', '345', '2021-01-04 14:06:32', '1');
INSERT INTO `tp5_xskus` VALUES ('101', '8', 'upload/20201202/d6c4f6f00cff80f5ac84d63d1ad31fd5.jpg', '47-49', '铂金银,WF-XB700防水运动', '230.00', '320', '443', '2021-01-04 14:06:32', '0');

-- ----------------------------
-- Table structure for tp5_xspec_infos
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xspec_infos`;
CREATE TABLE `tp5_xspec_infos` (
  `spec_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类ID ,主要用于父级ID=0的记录',
  `spec_name` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '属性名称，例如：颜色、红色',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级ID  0：初级分类',
  `list_order` tinyint(4) unsigned NOT NULL DEFAULT '99' COMMENT '排序标识，越小越靠前',
  `mark_msg` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT '备注信息 主要为了区分识别，可不填',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，-1：删除，发布后不要随意删除',
  PRIMARY KEY (`spec_id`),
  KEY `cat_index` (`cat_id`) USING BTREE,
  KEY `sel_index` (`spec_name`,`list_order`) USING BTREE,
  KEY `pk_index` (`spec_id`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COMMENT='商品属性、规格细则表\r\n\r\n一般只存储两级属性，注意 parent_id = 0 表示为属性信息\r\n\r\nparent_id > 0 : 表示为规格信息';

-- ----------------------------
-- Records of tp5_xspec_infos
-- ----------------------------
INSERT INTO `tp5_xspec_infos` VALUES ('25', '9', '类别', '0', '1', '香飘飘奶茶', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('26', '0', '桃桃红柚口味400ml 8杯', '25', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('27', '0', '樱桃莓莓口味400ml 8杯', '25', '2', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('28', '0', '金桔柠檬口味400ml 8杯', '25', '3', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('29', '9', '口味', '0', '1', '雀巢口味', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('30', '9', '数量', '0', '2', '雀巢 每包含量', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('31', '0', '原味奶油', '29', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('32', '0', '香浓奶油', '29', '2', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('33', '0', '50粒装', '30', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('34', '10', '规格', '0', '2', '伊利金典纯牛奶', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('35', '0', '【健康有机】有机全脂纯牛奶16盒', '34', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('36', '0', '【不加糖高蛋白】植选植物奶10瓶', '34', '2', '植选 植物奶高蛋白原', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('37', '18', '颜色', '0', '1', '科沃斯 Ecovacs 扫地机器人', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('38', '0', 'T8 Power震动擦地抢购', '37', '1', 'T8 Power震动擦地', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('39', '0', '沁宝AVA（蓝色）空气净化机器人', '37', '2', '沁宝AVA（蓝色）空气净化机器人', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('40', '20', '颜色', '0', '1', '小度智能音箱 ', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('41', '0', '【经典爆款】小度音箱旗舰版', '40', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('42', '0', '【红外遥控】小度音箱升级版', '40', '2', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('43', '0', '【随身音箱】小芦蓝牙音箱', '40', '3', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('44', '21', '颜色', '0', '1', '索尼（SONY）WF', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('45', '21', '版本', '0', '2', '索尼（SONY）WF', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('46', '0', '黑色', '44', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('47', '0', '铂金银', '44', '2', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('48', '0', 'WF-1000XM3随身降噪', '45', '1', '', '1');
INSERT INTO `tp5_xspec_infos` VALUES ('49', '0', 'WF-XB700防水运动', '45', '2', '', '1');

-- ----------------------------
-- Table structure for tp5_xtest_logs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xtest_logs`;
CREATE TABLE `tp5_xtest_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `open_id` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `name` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `msg` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `add_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3745 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tp5_xtest_logs
-- ----------------------------
INSERT INTO `tp5_xtest_logs` VALUES ('3744', '2353', '', '', '1610161782');

-- ----------------------------
-- Table structure for tp5_xtoday_words
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xtoday_words`;
CREATE TABLE `tp5_xtoday_words` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `word` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '摘句内容，不要太长',
  `from` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '出处',
  `picture` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '插图',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，-1：删除',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 10:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `images_str` varchar(500) NOT NULL COMMENT '多图列表，逗号隔开，建议三张以内',
  PRIMARY KEY (`id`),
  KEY `index_sel` (`id`,`word`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='今日赠言表';

-- ----------------------------
-- Records of tp5_xtoday_words
-- ----------------------------
INSERT INTO `tp5_xtoday_words` VALUES ('1', '谁的青春不迷茫，其实我们都一样！', '谁的青春不迷茫', 'home/images/ps.png', '1', '2020-06-02 19:57:01', '');
INSERT INTO `tp5_xtoday_words` VALUES ('2', '想和你重新认识一次 从你叫什么名字说起', '你的名字', 'home/images/ps2.png', '1', '2020-06-02 19:57:03', '');
INSERT INTO `tp5_xtoday_words` VALUES ('3', '我是一只雁，你是南方云烟。但愿山河宽，相隔只一瞬间.                ', '秦时明月', 'home/images/ps3.png', '1', '2020-06-02 19:57:08', '');
INSERT INTO `tp5_xtoday_words` VALUES ('4', '人老了的好处，就是可失去的东西越来越少了.', '哈尔的移动城堡', 'home/images/ps4.png', '1', '2020-06-02 19:57:10', '');
INSERT INTO `tp5_xtoday_words` VALUES ('5', '到底要怎么才能证明自己成长了 那种事情我也不知道啊 但是只要那一抹笑容尚存 我便心无旁骛 ', '声之形', 'home/images/ps5.png', '1', '2020-11-10 19:57:58', '');
INSERT INTO `tp5_xtoday_words` VALUES ('6', '你觉得被圈养的鸟儿为什么无法自由地翱翔天际？是因为鸟笼不是属于它的东西！', '东京食尸鬼A', 'home/images/ps6.png', '1', '2020-12-12 11:27:36', '');
INSERT INTO `tp5_xtoday_words` VALUES ('7', '我手里拿着刀，没法抱你。我放下刀，没法保护你！！', '死神', 'home/images/ps7.png', '1', '2020-12-12 11:04:14', '');
INSERT INTO `tp5_xtoday_words` VALUES ('8', '不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福!', '千与千寻', 'home/images/ps8.png', '-1', '2020-09-08 15:33:00', '');

-- ----------------------------
-- Table structure for tp5_xusers
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xusers`;
CREATE TABLE `tp5_xusers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nick_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '昵称  默认来自微信、QQ的昵称，可后期编辑',
  `user_avatar` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '用户头像',
  `auth_tel` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '15118988888' COMMENT '手机认证',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '性别  0：未设定   1：男   2：女',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `user_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '  0:普通用户  1：内部员工',
  `reg_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT '注册类型，0：安卓用户(QQ)，1：安卓用户(微信)',
  `integral` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `user_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户状态  0：正常  1：异常（可申诉） 2：黑名单',
  `union_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '第三方授权认证',
  `open_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '微信openid',
  PRIMARY KEY (`id`),
  KEY `pk_index` (`id`),
  KEY `sel_index` (`nick_name`,`auth_tel`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='注册用户表';

-- ----------------------------
-- Records of tp5_xusers
-- ----------------------------
INSERT INTO `tp5_xusers` VALUES ('1', '龙猫', 'https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83erME8I67DDYDfduLmFr6dI6zySrUOPP16N4YP32t1QBiaqic7aXy6dA7TZPA9ibFxXQdILNbKLJrF1WA/132', '15118988888', '0', '1555735686', '0', '0', '700', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('2', '大熊', 'https://wx.qlogo.cn/mmopen/vi_32/ph3pTayT2Y2DgMa2jiaicqv0ba9cMibhd44v1QY9IJiaVhTG5W3PQwibncRpoumZMZBJia3TRd4P3tSKWqaAcqJsDqOQ/132', '18898888877', '2', '1555738810', '0', '0', '0', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('3', '红猪', 'https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKGCoCBnXlicTo9DHHJKNgKjiauCXUzVCGRFibIOnEJD4EFibsyLaGFZRKwN58tw5HlUQWTufRKOLjVzQ/132', '15577888878', '2', '1555738881', '0', '0', '0', '1', '', '');
INSERT INTO `tp5_xusers` VALUES ('4', '卡卡西', 'https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLr5yvbicZQjpfvlicja0mBfaSRG4ibnRX3ibUq9Rak1QvzOV8YC6qKeyrapftlSulZdo7PKpGvzHibwag/132', '15112322322', '1', '1555739036', '1', '0', '50', '2', '', '');
INSERT INTO `tp5_xusers` VALUES ('5', '佐罗', 'https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIxAIXQL4JxsoBWf0GP9HFu0RjIPoPymPjuK0qia7ibrI0x34gmvPuZwo6iaXbFkb875b76Kr1CDicZdQ/132', '18988777787', '1', '1555748309', '1', '0', '0', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('6', '龙溪', 'https://wx.qlogo.cn/mmhead/dbmbvl7UYS8hcRelNJTkocl0MhM0LLmDlApB27KHLlw/132', '18788777788', '0', '1555748365', '0', '0', '0', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('7', '安若', 'https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIE3lcO5EBP17qaibIT5wwuLxKk5Ccb4anTiaRSKgjqmyPchZ1MkxfkgtOM4V0u5yNytVorqhsKDn2Q/132', '16888777787', '1', '1555748448', '0', '0', '0', '0', '', '');

/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : tp5_pro

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2020-09-04 20:47:33
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
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，数字越大越靠前',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在 app 首页显示  0：不显示  1：显示',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'app前端显示状态 0：正常，-1已删除',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '文章更新时间',
  `start_time` varchar(20) NOT NULL COMMENT '广告开始投放时间',
  `end_time` varchar(20) NOT NULL COMMENT '广告结束时间',
  PRIMARY KEY (`id`,`act_tag`),
  UNIQUE KEY `act_tag` (`act_tag`) USING BTREE COMMENT '唯一标识索引',
  KEY `select` (`id`,`title`) USING BTREE COMMENT '便于查询'
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='活动表\r\n\r\n一般用于显示app首页上的活动专栏，注意status的规定';

-- ----------------------------
-- Records of tp5_xactivitys
-- ----------------------------
INSERT INTO `tp5_xactivitys` VALUES ('1', '特价商品推荐', 'cms/images/imgOne.jpg', 'TJSPTJ', '2', '1', '1', '0', '2020-06-02 19:50:15', '1574125637', '1575090450');
INSERT INTO `tp5_xactivitys` VALUES ('2', '春季特惠商品', 'cms/images/imgTwo.jpg', 'CJTHSPA', '1', '2', '0', '0', '2020-06-02 19:50:19', '1574910600', '1575083403');
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
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='活动商品关联表\r\n\r\n';

-- ----------------------------
-- Records of tp5_xact_goods
-- ----------------------------
INSERT INTO `tp5_xact_goods` VALUES ('25', '3', '1', '0');
INSERT INTO `tp5_xact_goods` VALUES ('26', '2', '4', '0');
INSERT INTO `tp5_xact_goods` VALUES ('27', '1', '6', '0');
INSERT INTO `tp5_xact_goods` VALUES ('28', '1', '3', '0');

-- ----------------------------
-- Table structure for tp5_xadmins
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xadmins`;
CREATE TABLE `tp5_xadmins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '管理员昵称',
  `picture` varchar(255) NOT NULL DEFAULT '' COMMENT '管理员头像',
  `password` varchar(200) NOT NULL DEFAULT '' COMMENT '管理员登录密码',
  `role_id` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态标识 0：无效；1：正常；-1：删除',
  `content` varchar(500) NOT NULL DEFAULT '世界上没有两片完全相同的叶子！' COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ----------------------------
-- Records of tp5_xadmins
-- ----------------------------
INSERT INTO `tp5_xadmins` VALUES ('1', 'moTzxx@admin', 'cms/images/headshot/wuHuang.png', '37993cfef6629b18d80d7be625aa2485', '1', '2020-09-04 17:01:10', '1', 'HELLO');
INSERT INTO `tp5_xadmins` VALUES ('2', 'baZhaHei@admin', 'cms/images/headshot/baZhaHei.png', '8fa7b3a3e2f6d44bd205ba89e3759e9f', '2', '2020-06-02 19:50:57', '1', 'HELLO');
INSERT INTO `tp5_xadmins` VALUES ('3', 'niuNengx@admin', 'cms/images/headshot/niuNeng.png', '74cc22bb9abcddc8a1cdafbae1fadc7a', '1', '2020-06-02 19:51:04', '1', 'HELLO');

-- ----------------------------
-- Table structure for tp5_xadmin_roles
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xadmin_roles`;
CREATE TABLE `tp5_xadmin_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '角色称呼',
  `nav_menu_ids` text NOT NULL COMMENT '权限下的菜单ID',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态标识',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='管理员角色表';

-- ----------------------------
-- Records of tp5_xadmin_roles
-- ----------------------------
INSERT INTO `tp5_xadmin_roles` VALUES ('1', '终级管理员', '138|139|140|141|1|2|7|6|3|4|5|93|73|49|48|50|67|61|76|133|134|', '2020-05-27 16:28:22', '1');
INSERT INTO `tp5_xadmin_roles` VALUES ('2', '初级管理员', '1|6|2|3|4|5|', '2018-02-11 21:02:43', '1');

-- ----------------------------
-- Table structure for tp5_xad_lists
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xad_lists`;
CREATE TABLE `tp5_xad_lists` (
  `id` int(2) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告自增id',
  `ad_name` varchar(20) NOT NULL DEFAULT '' COMMENT '广告名称',
  `start_time` varchar(20) NOT NULL COMMENT '广告开始投放时间',
  `end_time` varchar(20) NOT NULL COMMENT '广告结束时间',
  `ad_type` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '广告类型, 0：首页幻灯片广告 1：首屏加载倒计时广告；2:其他广告',
  `ad_url` varchar(50) NOT NULL DEFAULT '' COMMENT '广告链接',
  `original_img` varchar(500) NOT NULL DEFAULT '' COMMENT '广告图片',
  `list_order` int(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序 数字越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'app前端显示状态 0：正常，-1已删除',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在 app 首页显示  0：不显示  1：显示',
  `ad_tag` varchar(100) NOT NULL DEFAULT '' COMMENT '唯一标识字符串 建议大写',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='广告';

-- ----------------------------
-- Records of tp5_xad_lists
-- ----------------------------
INSERT INTO `tp5_xad_lists` VALUES ('1', '倒计时广告', '2019-07-02 00:00:00', '2019-07-06 00:00:00', '1', '/pages/goods/adlike', 'cms/images/imgFour.jpg', '0', '0', '0', 'DJS');
INSERT INTO `tp5_xad_lists` VALUES ('2', '首屏广告', '2019-07-01 00:00:00', '2019-07-06 00:00:00', '2', '/goodsearch/index', 'cms/images/imgOne.jpg', '2', '0', '0', 'SP');
INSERT INTO `tp5_xad_lists` VALUES ('3', '首屏广告', '2019-07-01 00:00:00', '2019-07-06 00:00:00', '0', '../goodsearch/index', 'cms/images/imgTwo.jpg', '0', '0', '1', 'SP');
INSERT INTO `tp5_xad_lists` VALUES ('4', '首屏广告', '2019-07-02 00:00:00', '2019-07-11 00:00:00', '2', '../goodsearch/index1', 'cms/images/imgThree.jpg', '0', '0', '1', 'SP');

-- ----------------------------
-- Table structure for tp5_xarticles
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xarticles`;
CREATE TABLE `tp5_xarticles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Article 主键',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '作者ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序标识 越大越靠前',
  `content` text NOT NULL COMMENT '文章内容',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='文章表';

-- ----------------------------
-- Records of tp5_xarticles
-- ----------------------------
INSERT INTO `tp5_xarticles` VALUES ('1', '这是今年最好的演讲：生命来来往往，来日并不方长', '1', '2019-11-25 15:47:30', '2019-11-25 15:47:30', '0', '<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"letter-spacing: 0.544px; margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; overflow-wrap: break-word !important;\">视频中的演讲者算了一笔时间帐，如果一个人活到</span><span style=\"letter-spacing: 0.544px; margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; color: rgb(153, 0, 0); box-sizing: border-box !important; overflow-wrap: break-word !important;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\">78岁</strong></span><span style=\"letter-spacing: 0.544px; margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; overflow-wrap: break-word !important;\">，那么：</span><br/></p><p class=\"\" style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">要花大概</span><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: rgb(153, 0, 0);\">28.3年</span></strong><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">在睡觉上，足足占据人生的三分之一；</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">要花大概</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(153, 0, 0);\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">10.5年</span></strong></span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">在工作上；并且很可能这份工作不尽人意；</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">同时花在电视和社交媒体上的时间，也将占据</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: rgb(153, 0, 0);\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\">9.5年</strong></span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">；</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">另外，还有吃饭、化妆、照顾孩子等等，也都是不小的时间开销。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">算到最后，真正留给自己的岁月不过</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(153, 0, 0); font-size: 18px;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\">9年</strong></span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">而已。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">而如何利用这空白的9年，对每个人都有重大意义。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">我们每天都有</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: rgb(153, 0, 0);\">86400</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">秒存入自己的生命账户，一天结束后，第二天你将拥有新的86400秒。</span><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">如果这是一笔钱，没有人会任它白白溜走，但现实中我们却一天天浪费永不再来的时间。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">佛祖说，</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: rgb(153, 0, 0);\">人生最大的错误就是认为自己有时间</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">总以为岁月漫漫，有的是时间挥霍等待。</span><br/></p><p class=\"\" style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">总以为明天很多，很多事不必急于一时，很多人无需立刻相见。</span></p><p class=\"\" style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">但其实，人生来来往往，真的没有那么多来日方长。</span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><br/></span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(153, 0, 0);\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">余生很贵，经不起浪费。</span></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">就像三毛所说，</span><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; color: rgb(153, 0, 0);\">我来不及认真地年轻，待明白过来时，只能选择认真地老去。</span></p><p class=\"\" style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">趁阳光正好，趁微风不燥，见想见的人，做想做的事，就是对人生最大的不辜负。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">所以，</span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">去爱吧，就像从来没有受过伤害一样</span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">跳舞吧，如同没有任何人注视你一样</span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px;\">活着吧，如同今天就是末日一样</span></strong></p><p class=\"\" style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(153, 0, 0); font-size: 15px;\">生命来来往往，来日并不方长，别等，别遗憾。</span></p>');
INSERT INTO `tp5_xarticles` VALUES ('2', '真正放下一个人，不是拉黑，也不是删除', '2', '2019-11-28 11:12:42', '2018-11-21 09:11:31', '1', '<p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">有人说，越在乎，越假装不在乎；越放不下，越假装放得下。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px; color: rgb(153, 0, 0);\">没错。成年人的我们的确有着数不清的佯装，就连感情也难逃此劫。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">那个曾被置顶、秒回消息、熬夜畅聊的人，连同那些曾经炽热的喜欢，深夜不眠畅谈的欢快和被宠着重视着的小雀跃，现如今都安安静静地躺在黑名单中。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">不论是因为无所谓的小事而生气地冲动而为，还是因为有矛盾闹别扭时矫情地想博得关注，还是因为心碎而绝望地断绝关系，那看似干脆利落的拉黑、删除，都透露着在乎和放不下。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">大张旗鼓的离开都是试探，试探对方是否像自己一样还在乎；假装洒脱的放下不过是自欺欺人，欺骗自己反正我也不怕离开他。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px; color: rgb(153, 0, 0);\">其实，你很在乎他，也害怕离开他。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">拉黑或删除，不过是你害怕自己再次联系，不愿让自己卑微到尘埃里，想保留自己最后的尊严，而采取的无可奈何的强制手段；又或者是你期待着对方的主动联系，想证明他还在乎你，他离不开你，而实施的小手段。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">而真正放下一个人，从来就不是拉黑和删除，不是明明在乎着却假装不在乎，明明放不下却假装已放下。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; color: rgb(51, 51, 51);\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">真正的放下，是不闻不问，是沉默不语，是无动于衷。</span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; color: rgb(51, 51, 51);\"><strong style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"></span></strong></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px; color: rgb(153, 0, 0);\">但感情结束的那个瞬间，过去你深爱着的，深爱着你的那个人，便不再存在了。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">他的美好，你们感情的默契，不过都是你记忆里的样子而已。而你的记忆常常会被你加上滤镜，就像相亲对象开了美颜的“照骗”一样，美好但不真实。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\"><br/></span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">而这份值得回忆和珍藏的美好，只属于曾经，从不曾属于现在。</span></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; color: rgb(51, 51, 51);\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; font-size: 15px; letter-spacing: 0.5px;\">要知道，执拗地坚持着不该坚持的，本就不是深情，是愚钝；而故作洒脱的拉黑、删除，又何尝不是因为放不下。</span></p>');
INSERT INTO `tp5_xarticles` VALUES ('4', '真正在乎你的人，绝不会说这句话', '1', '2020-09-04 20:13:35', '2020-09-04 20:13:35', '0', '<section>\r\n<p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: #333333; color: #333333; text-align: center;\"><strong style=\"font-size: 15px; margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; overflow-wrap: break-word !important;\">在乎你的男人，绝不会说&ldquo;我很忙，没时间&rdquo;</strong></p>\r\n<p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; font-family: -apple-system-font, BlinkMacSystemFont,;\"><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"../../../upload/20200904/ad4fa25b92974736b2471bf5ee31fcbb.jpg\" alt=\"\" width=\"100\" height=\"100\" /></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">网上有一段话，<span style=\"color: #e67e23;\"><strong>想陪你吃饭的人酸甜苦辣都想吃</strong></span></span></p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">想送你回家的人东南西北都顺路，<span style=\"margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;\">想见你的人 24小时都有空&nbsp;</span></span></p>\r\n<p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; font-family: -apple-system-font, BlinkMacSystemFont,;\">&nbsp;</p>\r\n<p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; color: #333333; text-align: center;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: #990000; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">生活中没有谁是真的忙，只看他愿不愿你为你花时间</span></p>\r\n</section>');
INSERT INTO `tp5_xarticles` VALUES ('3', '年轻人，我劝你没事多存点钱', '1', '2020-06-02 18:38:11', '2020-06-02 18:38:11', '2', '<section><section><section><section><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;\"><img src=\"/upload/20200602/183808NzQ1OTEzNzU2MjI1.jpg\" title=\"183808NzQ1OTEzNzU2MjI1.jpg\" alt=\"04132054190477.jpg\"/></p><p style=\"margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; line-height: 1.75em; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; color: rgb(255, 255, 255); background-color: rgb(153, 0, 0); font-size: 16px; box-sizing: border-box !important; word-wrap: break-word !important;\">你的存款，就是你选择权<br/></span></p></section></section></section></section><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">我曾经和闺蜜去过一次“非同凡响”的毕业旅游。</span></p><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">当时的我们还是大学生，每个月的生活费只会有超支，不会有结余，整天理所当然地做着月光族。</span></p><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">直到我们站在旅行社的门外盯着别人的海报，才猛然发现自己简直就是拿着买大宝的钱，跑去买人家的SK2。</span></p><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; clear: both; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: -apple-system-font, BlinkMacSystemFont, \"><br/></p><p style=\"white-space: normal; margin: 0px 16px; padding: 0px; max-width: 100%; min-height: 1em; caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51);\"><span style=\"margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;\">最后，不得不厚着脸皮问家里人拿了一笔小小的旅游基金，报了一个超级特惠团。</span></p>');

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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='文章 要点表';

-- ----------------------------
-- Records of tp5_xarticle_points
-- ----------------------------
INSERT INTO `tp5_xarticle_points` VALUES ('1', '1', '2', '', 'home/images/article1.png', '如今科技进步，时代向前，人的平均寿命越来越长了。但长长的一生中，究竟有多少时间真正属于我们自己呢？', '1', '1');
INSERT INTO `tp5_xarticle_points` VALUES ('2', '2', '12', '', 'home/images/article2.png', '我的小天地，我闯荡的大江湖，我的浩瀚星辰和璀璨日月，再与你无关；而你的天地，你行走的江湖，你的日月和星辰，我也再不惦念。从此，一别两宽，各生欢喜。', '1', '1');
INSERT INTO `tp5_xarticle_points` VALUES ('4', '4', '0', '', 'home/images/article4.png', '人都是对喜欢的东西最上心。他若真的在乎你，一分一秒都不想失去你的消息，更不会不时玩消失，不会对你忽冷忽热，因为他比你还害怕失去。所有的不主动都是由于不喜欢，喜欢你的人永远不忙。', '0', '1');
INSERT INTO `tp5_xarticle_points` VALUES ('3', '3', '0', '', 'home/images/article3.png', '因为穷，所以要努力赚钱；努力赚钱，就会没时间找对象；找不到对象就算了，钱也没赚多少，难免开始焦虑；一旦焦虑，每天洗头的时候，掉出来的头发会告诉你什么才是真正的“绝望”。', '1', '1');

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
  `show_img` varchar(255) NOT NULL COMMENT '首页展示图片，暂时只用于一级分类',
  `level` tinyint(2) NOT NULL DEFAULT '2' COMMENT '类型  1：一级；2：二级； 3：三级',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序数字越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态 0：正常  -1：已删除',
  PRIMARY KEY (`cat_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- ----------------------------
-- Records of tp5_xcategorys
-- ----------------------------
INSERT INTO `tp5_xcategorys` VALUES ('1', '图书', '0', '1', 'cms/images/category/books.png', '', '1', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('2', '电器', '0', '1', 'cms/images/category/electric.png', '', '1', '2', '0');
INSERT INTO `tp5_xcategorys` VALUES ('4', '美食', '0', '1', 'cms/images/category/food.png', '', '1', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('3', '服饰', '0', '1', 'cms/images/category/clothing.png', '', '1', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('5', '电子书', '1', '1', 'cms/images/category/e-book.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('7', '冰箱', '2', '1', 'cms/images/category/refrigerator.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('6', '饮品', '4', '1', 'cms/images/category/drink.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('8', '红酒', '4', '1', 'cms/images/category/red_wine.png', '', '2', '1', '-1');
INSERT INTO `tp5_xcategorys` VALUES ('9', '咖啡', '6', '1', 'cms/images/category/coffee.png', '', '3', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('10', '牛奶', '6', '1', 'cms/images/category/milk.png', '', '3', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('12', '洗衣机', '2', '1', 'cms/images/category/washer.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('13', '小说', '5', '1', 'cms/images/category/fiction.png', '', '3', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('14', '糖果', '15', '1', 'cms/images/category/candies.png', '', '3', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('15', '休闲食品', '4', '1', 'cms/images/category/leisure-food.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('16', '酒类', '4', '1', 'cms/images/category/wine.png', '', '2', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('17', '白酒', '16', '1', 'cms/images/category/white-wine.png', '', '3', '0', '0');
INSERT INTO `tp5_xcategorys` VALUES ('18', '葡萄酒', '16', '1', 'cms/images/category/grape-wine.png', '', '3', '0', '0');

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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4;

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

-- ----------------------------
-- Table structure for tp5_xconfigs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xconfigs`;
CREATE TABLE `tp5_xconfigs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID标记',
  `title` varchar(50) NOT NULL COMMENT '配置项标题',
  `tag` varchar(50) NOT NULL COMMENT '缩写标签 建议使用大写字母',
  `conf_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '配置类型 0：业务配置；1：系统配置',
  `input_type` varchar(20) NOT NULL COMMENT '配置项 输入类型，分为 text、number、file、checkbox',
  `value` varchar(100) NOT NULL COMMENT '配置项的 取值',
  `tip` varchar(100) NOT NULL COMMENT '配置项提示信息',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态  -1：删除  0：正常',
  `add_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`,`tag`),
  UNIQUE KEY `tag` (`tag`) USING BTREE,
  KEY `selcct` (`id`,`title`,`tag`) USING BTREE COMMENT '便于查询'
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='配置表';

-- ----------------------------
-- Records of tp5_xconfigs
-- ----------------------------
INSERT INTO `tp5_xconfigs` VALUES ('1', '我是一个文本1', 'WSWENBEN1', '0', 'text', '1', 'HELLO,不要乱改！', '2', '0', '2019-07-30 18:09:23');
INSERT INTO `tp5_xconfigs` VALUES ('2', '我是一个开关', 'SWITCHTOYOU', '0', 'checkbox', '1', 'HAHAHA', '0', '0', '2019-07-30 18:13:34');
INSERT INTO `tp5_xconfigs` VALUES ('3', '我是一个图片', 'TUPIAN1', '0', 'button', 'cms/images/icon/goods_manager.png', '注意图片不要太大', '3', '0', '2019-07-30 18:21:18');
INSERT INTO `tp5_xconfigs` VALUES ('4', 'VIP会员费用', 'VIP_MONEY', '0', 'text', '199', 'VIP 就是牛!', '1', '0', '2019-07-30 18:59:31');

-- ----------------------------
-- Table structure for tp5_xgoods
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xgoods`;
CREATE TABLE `tp5_xgoods` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品分类id',
  `thumbnail` varchar(200) NOT NULL COMMENT '缩略图，一般用于订单页的商品展示',
  `tip_word` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT '提示语，字数不要太多，一般一句话',
  `list_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  `details` text NOT NULL COMMENT '商品描述详情',
  `reference_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品参考价',
  `selling_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品售价',
  `attr_info` text NOT NULL COMMENT 'json形式保存的属性数据',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存，注意退货未支付订单时的数目变化',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '商品创建时间',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '商品更新时间',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态 -1：删除 0：待上架 1：已上架 2：预售 ',
  `recommend` char(1) NOT NULL DEFAULT '0' COMMENT '推荐标志位',
  `admin_id` int(11) NOT NULL DEFAULT '1' COMMENT '上传该商品的管理员ID',
  PRIMARY KEY (`goods_id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COMMENT='商品表\r\n\r\n注意：status 的规定，app 上只显示上架的产品哦';

-- ----------------------------
-- Records of tp5_xgoods
-- ----------------------------
INSERT INTO `tp5_xgoods` VALUES ('1', '德芙 Dove分享碗 草莓白巧克力 221g（新旧包装随机发放）', '14', 'cms/images/goods/1/1.jpg', '办公室休闲零食 员工福利糖果巧克力 ', '1', '<p><img src=\"/cms/images/goods/1/5.jpg\" title=\"175706NDMzOTQwNDUzNTE4.jpg\" alt=\"O1CN014zzptX1rlMcSpY1yn_!!1748365671.jpg\"/></p>', '30.55', '32.90', '[{\"spec_id\":\"11\",\"spec_info\":[{\"spec_name\":\"221g\",\"spec_id\":\"12\",\"specFstID\":\"11\"},{\"spec_name\":\"300g\",\"spec_id\":\"13\",\"specFstID\":\"11\"}],\"spec_name\":\"重量【巧克力通用】\"}]', '5000', '2019-11-28 10:51:31', '2019-11-29 15:10:56', '1', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('2', 'CandyLab【水晶棒棒糖组合】手工糖果创意水果味水晶棒棒糖定制', '14', 'cms/images/goods/2/1.jpg', '只是一件裙子嘛', '2', '<p><img src=\"/cms/images/goods/2/3.jpg\" title=\"100125MzY5NTI3NjY5OTU5.png\" alt=\"QQ截图20191129095547.png\"/></p>', '120.00', '105.00', '[{\"spec_id\":\"11\",\"spec_info\":[{\"spec_name\":\"300g\",\"spec_id\":\"13\",\"specFstID\":\"11\"}],\"spec_name\":\"重量【巧克力通用】\"}]', '600', '2019-03-11 18:03:26', '2019-11-29 15:14:48', '1', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('4', '买1箱送1箱法国进口红酒赤霞珠希雅特酒堡干红葡萄酒红酒特价整箱', '18', 'cms/images/goods/4/1.jpg', '好咖啡，有精神头', '2', '<p><br/></p><p><img src=\"/cms/images/goods/4/5.jpg\" title=\"093713NzI5OTYxNjkzNzQ4.jpg\"/></p><p><br/></p>', '1980.00', '388.00', '[{\"spec_id\":\"18\",\"spec_info\":[{\"spec_name\":\"13%VOL\",\"spec_id\":\"19\",\"specFstID\":\"18\"}],\"spec_name\":\"酒精度\"},{\"spec_id\":\"21\",\"spec_info\":[{\"spec_name\":\"750ml*6\",\"spec_id\":\"23\",\"specFstID\":\"21\"},{\"spec_name\":\"750ml*12\",\"spec_id\":\"22\",\"specFstID\":\"21\"}],\"spec_name\":\"净含量\"}]', '5000', '2019-03-14 11:03:58', '2020-03-09 17:53:29', '1', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('5', '江小白白酒500ml40度8瓶青春版清香型国产大瓶整箱正品包邮送礼', '17', 'cms/images/goods/5/1.jpg', '不给你喝，哈哈哈哈', '1', '<p><img src=\"/cms/images/goods/5/4.jpg\" title=\"094745Mjc4NjQ4NzcwNDU1.jpg\" alt=\"TB2OrSAsiCYBuNkSnaVXXcMsVXa_!!2961619882.jpg\"/></p>', '1280.00', '536.00', '[{\"spec_id\":\"4\",\"spec_info\":[{\"spec_name\":\"500ml\",\"spec_id\":\"5\",\"specFstID\":\"4\"}],\"spec_name\":\"容量【小瓶】\"},{\"spec_id\":\"7\",\"spec_info\":[{\"spec_name\":\"40度\",\"spec_id\":\"8\",\"specFstID\":\"7\"},{\"spec_name\":\"38度\",\"spec_id\":\"9\",\"specFstID\":\"7\"}],\"spec_name\":\"酒精度数【白酒类型】\"}]', '4121', '2019-03-18 17:03:17', '2019-11-29 15:13:48', '1', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('7', '纽仕兰牧场Theland新西兰进口全脂纯牛奶4.0蛋白质钙250ml*24盒箱', '10', 'cms/images/goods/7/1.jpg', '一条裙子', '0', '<p><img src=\"/cms/images/goods/7/3.jpg\" title=\"100629MTMzMzg3NDQ4MTA0.png\" alt=\"TB2pn9Tqk7mBKNjSZFyXXbydFXa_!!82033576.png\"/></p>', '129.00', '99.00', '[{\"spec_id\":\"14\",\"spec_info\":[{\"spec_name\":\"250ml*24\",\"spec_id\":\"15\",\"specFstID\":\"14\"},{\"spec_name\":\"250ml*6\",\"spec_id\":\"16\",\"specFstID\":\"14\"}],\"spec_name\":\"规格【牛奶】\"}]', '2399', '2019-03-19 10:03:48', '2019-11-29 15:12:31', '1', '0', '1');
INSERT INTO `tp5_xgoods` VALUES ('3', '蒙牛纯甄小蛮腰酸牛奶原味红西柚味瓶装230g×10瓶学生酸奶', '10', 'cms/images/goods/3/1.jpg', '8月产蒙牛纯甄小蛮腰酸牛奶', '0', '<p style=\"text-align: center;\"><span style=\"font-size: 24px;\"><strong><span style=\"color: #843fa1;\">好营养，喝蒙牛！</span></strong></span></p>\r\n<p style=\"text-align: center;\"><img title=\"094200Mjc1ODM2NzIyNTI5.jpg\" src=\"../../images/goods/3/2.jpg\" alt=\"O1CN01H5YnKT1QuzKuf9HCE_!!1584902037.jpg\" width=\"324\" height=\"324\" /></p>', '30.00', '29.88', '[{\"spec_id\":\"14\",\"spec_info\":[{\"spec_name\":\"230g*10\",\"spec_id\":\"24\",\"specFstID\":\"14\"}],\"spec_name\":\"规格【牛奶】\"}]', '700', '2019-11-29 09:42:38', '2020-09-04 20:46:44', '1', '1', '3');
INSERT INTO `tp5_xgoods` VALUES ('6', '马来西亚进口 零涩 蓝山风味速溶三合一咖啡 40条640g', '9', 'cms/images/goods/6/1.jpg', 'HHEEE', '2', '<p><img title=\"182640MTY0OTg5Njg2NTk0.jpg\" src=\"../../images/goods/6/4.jpg\" width=\"182\" height=\"134\" /></p>\r\n<p>&nbsp;</p>', '28.99', '29.99', '[{\"spec_id\":\"1\",\"spec_info\":[{\"spec_name\":\"640g\",\"spec_id\":\"2\",\"specFstID\":\"1\"}],\"spec_name\":\"容量【速溶咖啡】\"}]', '500', '2019-03-11 18:03:26', '2020-09-04 20:43:57', '1', '0', '1');

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
  KEY `id` (`id`,`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4 COMMENT='菜单导航表';

-- ----------------------------
-- Records of tp5_xnav_menus
-- ----------------------------
INSERT INTO `tp5_xnav_menus` VALUES ('136', '查看商品操作日志', '50', 'cms/goods/viewLogs', '', '1', '0', '2020-03-09 17:45:57', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('2', '菜单管理', '1', 'cms/menu/index', 'cms/images/icon/menu_list.png', '1', '0', '2020-06-02 19:54:40', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('3', '列表管理', '0', '/', 'cms/images/icon/desktop.png', '1', '2', '2020-06-02 19:54:42', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('4', '今日赠言', '3', 'cms/todayWord/index', 'cms/images/icon/diplom.png', '1', '0', '2020-06-02 19:54:44', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('5', '文章列表', '3', 'cms/article/index', 'cms/images/icon/adaptive.png', '1', '0', '2020-06-02 19:54:46', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('1', '管理分配', '0', '/', 'cms/images/icon/manage.png', '1', '1', '2020-06-02 19:54:49', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('6', '管理人员', '1', 'cms/admin/index', 'cms/images/icon/admin.png', '1', '3', '2020-06-02 19:54:51', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('7', '角色管理', '1', 'cms/admin/role', 'cms/images/icon/role.png', '1', '2', '2020-06-02 19:54:55', '0');
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
INSERT INTO `tp5_xnav_menus` VALUES ('48', '产品分类', '49', 'cms/category/index', 'cms/images/icon/goods_category.png', '1', '0', '2020-06-02 19:54:58', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('49', '商品管理', '0', '/', 'cms/images/icon/goods_manager.png', '1', '3', '2020-06-02 19:55:01', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('50', '商品列表', '49', 'cms/goods/index', 'cms/images/icon/goods.png', '1', '0', '2020-06-02 19:55:03', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('51', '添加产品分类', '48', 'cms/category/add', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('52', '修改产品分类', '48', 'cms/category/edit', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('53', '删除产品分类', '48', 'cms/category/del', '/', '1', '0', '2019-03-11 15:16:11', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('54', '商品添加', '50', 'cms/goods/add', '/', '1', '0', '2019-03-11 16:53:21', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('55', '商品修改', '50', 'cms/goods/edit', '/', '1', '0', '2019-03-11 16:53:43', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('98', 'ajax获取商品分类数据', '48', 'cms/category/ajaxGetToSelCategoryList', '/', '1', '0', '2019-11-15 10:47:45', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('58', 'ajax 更改上下架状态', '50', 'cms/goods/ajaxPutaway', '/', '1', '0', '2019-03-19 16:40:41', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('59', 'ajax 首页显示状态修改', '48', 'cms/category/ajaxForShow', '/', '1', '0', '2019-03-21 11:52:13', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('60', 'ajax 删除上传的图片', '50', 'cms/goods/ajaxDelUploadImg', '/', '1', '0', '2019-03-21 18:07:22', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('66', 'ajax 根据分类获取参加活动的商品', '50', 'cms/goods/ajaxGetCatGoodsForActivity', '/', '1', '0', '2019-03-30 12:00:17', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('67', '属性列表', '49', 'cms/specInfo/index', 'cms/images/icon/spec.png', '1', '0', '2020-06-02 19:55:07', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('68', '属性添加', '67', 'cms/specInfo/add', '/', '1', '0', '2019-03-31 17:07:51', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('69', '属性修改', '67', 'cms/specInfo/edit', '/', '1', '0', '2019-03-31 17:08:14', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('70', 'ajax 根据商品分类ID查询 父级属性', '67', 'cms/specInfo/ajaxGetSpecInfoFstByCat', '/', '1', '0', '2019-03-31 18:07:57', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('72', 'ajax 根据父级属性ID查询次级属性', '67', 'cms/specInfo/ajaxGetSpecInfoBySpecFst', '/', '1', '0', '2019-04-04 10:50:43', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('61', '活动列表', '49', 'cms/activity/index', 'cms/images/icon/activity.png', '1', '0', '2020-06-02 19:55:12', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('62', '活动添加', '61', 'cms/activity/add', '/', '1', '0', '2019-03-29 11:35:17', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('63', '活动修改', '61', 'cms/activity/edit', '/', '1', '0', '2019-03-29 11:35:38', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('65', 'ajax 首页显示状态修改', '61', 'cms/activity/ajaxForShow', '/', '1', '0', '2019-03-29 11:36:35', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('73', '用户列表', '3', 'cms/users/index', 'cms/images/icon/users.png', '1', '5', '2020-06-02 19:55:14', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('75', 'ajax 修改用户状态', '73', 'cms/users/ajaxUpdateUserStatus', '/', '1', '0', '2019-07-09 17:22:57', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('76', '广告列表', '49', 'cms/adList/index', 'cms/images/icon/cms_ad.png', '1', '0', '2020-06-02 19:55:22', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('77', '广告添加', '76', 'cms/adList/add', '/', '1', '0', '2019-07-19 18:10:55', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('80', 'ajax 首页显示广告状态修改', '76', 'cms/adList/ajaxForShow', '/', '1', '0', '2019-07-19 18:11:23', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('78', '广告修改', '76', 'cms/adList/edit', '/', '1', '0', '2019-07-19 18:11:00', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('92', 'ajax 文章推荐操作', '5', 'cms/article/ajaxForRecommend', '/', '1', '0', '2019-07-22 16:22:01', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('93', '业务配置', '3', 'cms/config/index', 'cms/images/icon/cms_config.png', '1', '0', '2020-06-02 19:55:44', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('94', '添加配置项', '93', 'cms/config/add', '/', '1', '0', '2019-07-26 15:08:38', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('95', '配置项修改', '93', 'cms/config/edit', '/', '1', '0', '2019-07-29 14:30:13', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('97', 'ajax 根据分类获取参加活动的商品', '61', 'cms/goods/ajaxGetCatGoodsForActivity', '/', '1', '0', '2019-08-16 09:31:52', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('99', '规格数据展示', '67', 'cms/specInfo/details', '/', '1', '0', '2019-11-14 16:08:47', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('133', '监控统计', '0', '/', 'cms/images/icon/cms_analyze.png', '1', '4', '2020-06-02 19:55:39', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('134', '商品价格分布饼图', '133', 'cms/analyze/goodsPricePie', 'cms/images/icon/cms_pie.png', '1', '0', '2020-06-02 19:55:37', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('135', '查看文章操作日志', '5', 'cms/article/viewLogs', '', '1', '0', '2020-03-09 17:06:40', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('137', '动态配置开关状态', '93', 'cms/config/ajaxUpdateSwitchValue', '/', '1', '0', '2020-05-25 18:05:34', '1');
INSERT INTO `tp5_xnav_menus` VALUES ('138', '系统配置', '0', '/', 'cms/images/icon/cms_config_system.png', '1', '0', '2020-06-02 19:55:33', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('139', '登录认证', '138', 'cms/sysConf/auth', 'cms/images/icon/cms_auth.png', '1', '1', '2020-06-02 19:55:31', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('140', '文件上传', '138', 'cms/sysConf/opfile', 'cms/images/icon/cms_upload.png', '1', '2', '2020-06-05 20:29:14', '0');
INSERT INTO `tp5_xnav_menus` VALUES ('141', 'IP 白名单', '138', 'cms/sysConf/ipWhite', 'cms/images/icon/cms_ip.png', '1', '3', '2020-06-02 19:55:27', '0');

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
-- Table structure for tp5_xskus
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xskus`;
CREATE TABLE `tp5_xskus` (
  `sku_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_img` varchar(150) CHARACTER SET utf8 NOT NULL COMMENT '对应的SKU商品缩略图',
  `spec_info` varchar(300) CHARACTER SET utf8 NOT NULL COMMENT '对应的商品 sku属性信息，以逗号隔开。举例：12,15,23',
  `spec_name` varchar(300) CHARACTER SET utf8 NOT NULL COMMENT 'sku 规格描述，仅供展示',
  `selling_price` decimal(11,2) NOT NULL DEFAULT '0.00' COMMENT '商品售价',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存',
  `sold_num` int(11) NOT NULL DEFAULT '0' COMMENT '销量',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态  0:显示（正常） -1：删除（失效）',
  PRIMARY KEY (`sku_id`)
) ENGINE=MyISAM AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COMMENT='商品 SKU 库存表\r\n\r\n用于存储商品不同属性搭配的数目、价格等';

-- ----------------------------
-- Records of tp5_xskus
-- ----------------------------
INSERT INTO `tp5_xskus` VALUES ('73', '1', '', '12', '221g', '32.90', '3000', '11', '2019-11-29 15:10:56', '0');
INSERT INTO `tp5_xskus` VALUES ('74', '1', '', '13', '300g', '50.00', '2000', '12', '2019-11-29 15:10:56', '0');
INSERT INTO `tp5_xskus` VALUES ('75', '7', '', '15', '250ml*24', '99.00', '2099', '87', '2019-11-29 15:12:31', '0');
INSERT INTO `tp5_xskus` VALUES ('76', '7', '', '16', '250ml*6', '52.00', '300', '77', '2019-11-29 15:12:31', '0');
INSERT INTO `tp5_xskus` VALUES ('77', '5', '', '5,8', '500ml,40度', '536.00', '3099', '1', '2019-11-29 15:13:48', '0');
INSERT INTO `tp5_xskus` VALUES ('78', '5', '', '5,9', '500ml,38度', '506.00', '1022', '112', '2019-11-29 15:13:48', '0');
INSERT INTO `tp5_xskus` VALUES ('79', '6', '', '2', '640g', '29.99', '500', '0', '2020-09-04 20:43:57', '0');
INSERT INTO `tp5_xskus` VALUES ('80', '2', '', '13', '300g', '105.00', '600', '3', '2019-11-29 15:14:48', '0');
INSERT INTO `tp5_xskus` VALUES ('81', '3', '', '24', '230g*10', '29.88', '700', '12', '2020-09-04 20:46:45', '0');
INSERT INTO `tp5_xskus` VALUES ('71', '4', '', '19,22', '13%VOL,750ml*12', '388.00', '0', '0', '2019-11-29 14:56:20', '0');
INSERT INTO `tp5_xskus` VALUES ('72', '4', '', '19,23', '13%VOL,750ml*6', '199.00', '0', '0', '2019-11-29 14:56:20', '0');

-- ----------------------------
-- Table structure for tp5_xspec_infos
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xspec_infos`;
CREATE TABLE `tp5_xspec_infos` (
  `spec_id` int(11) NOT NULL AUTO_INCREMENT,
  `spec_name` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '属性名称，例如：颜色、红色',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类ID ,主要用于父级ID=0的记录',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级ID  0：初级分类',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，-1：删除，发布后不要随意删除',
  `list_order` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序标识，越大越靠前',
  `mark_msg` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT '备注信息 主要为了区分识别，可不填',
  PRIMARY KEY (`spec_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COMMENT='商品属性细则表\r\n\r\n一般只存储两级属性，注意 parent_id = 0 表示初级数据\r\n同时，注意添加后不要修改和删除';

-- ----------------------------
-- Records of tp5_xspec_infos
-- ----------------------------
INSERT INTO `tp5_xspec_infos` VALUES ('1', '容量', '9', '0', '1', '0', '速溶咖啡');
INSERT INTO `tp5_xspec_infos` VALUES ('2', '640g', '0', '1', '1', '0', '小包装重量');
INSERT INTO `tp5_xspec_infos` VALUES ('3', '1280g', '0', '1', '1', '2', '双份量装');
INSERT INTO `tp5_xspec_infos` VALUES ('4', '容量', '17', '0', '1', '0', '小瓶');
INSERT INTO `tp5_xspec_infos` VALUES ('5', '500ml', '0', '4', '1', '0', '江小白');
INSERT INTO `tp5_xspec_infos` VALUES ('6', '380ml', '0', '4', '1', '0', '北京二锅头');
INSERT INTO `tp5_xspec_infos` VALUES ('7', '酒精度数', '17', '0', '1', '0', '白酒类型');
INSERT INTO `tp5_xspec_infos` VALUES ('8', '40度', '0', '7', '1', '0', '白酒');
INSERT INTO `tp5_xspec_infos` VALUES ('9', '38度', '0', '7', '1', '0', '');
INSERT INTO `tp5_xspec_infos` VALUES ('10', '52度', '0', '7', '1', '0', '景芝酱香酒');
INSERT INTO `tp5_xspec_infos` VALUES ('11', '重量', '14', '0', '1', '0', '巧克力通用');
INSERT INTO `tp5_xspec_infos` VALUES ('12', '221g', '0', '11', '1', '0', '');
INSERT INTO `tp5_xspec_infos` VALUES ('13', '300g', '0', '11', '1', '0', '');
INSERT INTO `tp5_xspec_infos` VALUES ('14', '规格', '10', '0', '1', '0', '牛奶');
INSERT INTO `tp5_xspec_infos` VALUES ('15', '250ml*24', '0', '14', '1', '0', '盒装');
INSERT INTO `tp5_xspec_infos` VALUES ('16', '250ml*6', '0', '14', '1', '0', '6包装');
INSERT INTO `tp5_xspec_infos` VALUES ('17', '500ml*2', '0', '14', '1', '0', '双瓶装');
INSERT INTO `tp5_xspec_infos` VALUES ('18', '酒精度', '18', '0', '1', '0', '');
INSERT INTO `tp5_xspec_infos` VALUES ('19', '13%VOL', '0', '18', '1', '0', '普通酒度数');
INSERT INTO `tp5_xspec_infos` VALUES ('20', '11%VOL', '0', '18', '1', '0', '度数');
INSERT INTO `tp5_xspec_infos` VALUES ('21', '净含量', '18', '0', '1', '0', '');
INSERT INTO `tp5_xspec_infos` VALUES ('22', '750ml*12', '0', '21', '1', '0', '12瓶装');
INSERT INTO `tp5_xspec_infos` VALUES ('23', '750ml*6', '0', '21', '1', '0', '6瓶装');
INSERT INTO `tp5_xspec_infos` VALUES ('24', '230g*10', '0', '14', '1', '0', '小蛮腰等');

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
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='今日赠言表';

-- ----------------------------
-- Records of tp5_xtoday_words
-- ----------------------------
INSERT INTO `tp5_xtoday_words` VALUES ('1', '谁的青春不迷茫，其实我们都一样！', '谁的青春不迷茫', 'home/images/ps.png', '1', '2020-06-02 19:57:01');
INSERT INTO `tp5_xtoday_words` VALUES ('2', '想和你重新认识一次 从你叫什么名字说起', '你的名字', 'home/images/ps2.png', '1', '2020-06-02 19:57:03');
INSERT INTO `tp5_xtoday_words` VALUES ('3', '我是一只雁，你是南方云烟。但愿山河宽，相隔只一瞬间.                ', '秦时明月', 'home/images/ps3.png', '1', '2020-06-02 19:57:08');
INSERT INTO `tp5_xtoday_words` VALUES ('4', '人老了的好处，就是可失去的东西越来越少了.', '哈尔的移动城堡', 'home/images/ps4.png', '1', '2020-06-02 19:57:10');
INSERT INTO `tp5_xtoday_words` VALUES ('5', '到底要怎么才能证明自己成长了 那种事情我也不知道啊 但是只要那一抹笑容尚存 我便心无旁骛 ', '声之形', 'home/images/ps5.png', '1', '2020-06-02 19:57:11');
INSERT INTO `tp5_xtoday_words` VALUES ('6', '你觉得被圈养的鸟儿为什么无法自由地翱翔天际？是因为鸟笼不是属于它的东西', '东京食尸鬼A', 'home/images/ps6.png', '1', '2020-06-02 19:57:13');
INSERT INTO `tp5_xtoday_words` VALUES ('7', '我手里拿着刀，没法抱你。我放下刀，没法保护你', '死神', 'home/images/ps7.png', '1', '2020-06-02 19:57:15');
INSERT INTO `tp5_xtoday_words` VALUES ('8', '不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福!', '千与千寻', 'home/images/ps8.png', '1', '2020-06-02 19:57:18');

-- ----------------------------
-- Table structure for tp5_xupload_imgs
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xupload_imgs`;
CREATE TABLE `tp5_xupload_imgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL DEFAULT '0' COMMENT '当type=0 时，对应商品ID；当type=1时，对应评论订单ID',
  `picture` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '存储的图片路径',
  `add_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '添加时间',
  `type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '类型 0：商品轮播图（app界面） 1: 评论订单中的图片',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态  1：正常  -1：删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COMMENT='上传图片表\r\n\r\n用于保存商品轮播图或者订单评论中需要的图片，注意其 type的区分使用';

-- ----------------------------
-- Records of tp5_xupload_imgs
-- ----------------------------
INSERT INTO `tp5_xupload_imgs` VALUES ('30', '1', 'cms/images/goods/1/4.jpg', '2020-06-02 19:57:30', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('31', '1', 'cms/images/goods/1/3.jpg', '2020-06-02 19:57:33', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('32', '1', 'cms/images/goods/1/2.jpg', '2020-06-02 19:57:34', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('33', '1', 'cms/images/goods/1/1.jpg', '2020-06-02 19:57:37', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('36', '6', 'cms/images/goods/6/1.jpg', '2020-06-02 19:58:04', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('37', '6', 'cms/images/goods/6/2.jpg', '2020-06-02 19:58:07', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('38', '6', 'cms/images/goods/6/3.jpg', '2020-06-02 19:58:09', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('40', '4', 'cms/images/goods/4/4.jpg', '2020-06-02 19:58:11', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('41', '4', 'cms/images/goods/4/3.jpg', '2020-06-02 19:58:14', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('42', '4', 'cms/images/goods/4/2.jpg', '2020-06-02 19:58:17', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('43', '3', 'cms/images/goods/3/3.jpg', '2020-06-02 19:58:18', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('44', '3', 'cms/images/goods/3/2.jpg', '2020-06-02 19:58:20', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('45', '5', 'cms/images/goods/5/2.jpg', '2020-06-02 19:58:23', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('46', '5', 'cms/images/goods/5/3.jpg', '2020-06-02 19:58:25', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('47', '2', 'cms/images/goods/2/3.jpg', '2020-06-02 19:58:27', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('48', '2', 'cms/images/goods/2/2.jpg', '2020-06-02 19:58:29', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('49', '7', 'cms/images/goods/7/3.jpg', '2020-06-02 19:58:31', '0', '1');
INSERT INTO `tp5_xupload_imgs` VALUES ('50', '7', 'cms/images/goods/7/2.jpg', '2020-06-02 19:58:34', '0', '1');

-- ----------------------------
-- Table structure for tp5_xusers
-- ----------------------------
DROP TABLE IF EXISTS `tp5_xusers`;
CREATE TABLE `tp5_xusers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nick_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '昵称  默认来自微信、QQ的昵称，可后期编辑',
  `user_avatar` varchar(500) COLLATE utf8_unicode_ci NOT NULL COMMENT '用户头像',
  `auth_tel` varchar(11) COLLATE utf8_unicode_ci NOT NULL DEFAULT '15118988888' COMMENT '手机认证',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '性别  0：未设定   1：男   2：女',
  `reg_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `user_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '  0:普通用户  1：内部员工',
  `reg_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT '注册类型，0：安卓用户(QQ)，1：安卓用户(微信)',
  `integral` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `user_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户状态  0：正常  1：异常（可申诉） 2：黑名单',
  `union_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '第三方授权认证',
  `open_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '微信openid',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='注册用户表';

-- ----------------------------
-- Records of tp5_xusers
-- ----------------------------
INSERT INTO `tp5_xusers` VALUES ('1', '龙猫', 'https://img2.woyaogexing.com/2019/11/19/1532c6effbfb43fe90490e1aaa171040!400x400.jpeg', '15118988888', '0', '1555735686', '0', '0', '700', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('2', '大熊', 'https://img2.woyaogexing.com/2019/11/20/0d61858adef44109a3b5b40e1b8ecfff!400x400.jpeg', '18898888877', '2', '1555738810', '0', '0', '0', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('3', '红猪', 'https://img2.woyaogexing.com/2019/11/19/e3f06886561143b780c62412ca326f8d!400x400.jpeg', '15577888878', '2', '1555738881', '0', '0', '0', '1', '', '');
INSERT INTO `tp5_xusers` VALUES ('4', '卡卡西', 'https://img2.woyaogexing.com/2019/11/21/ba315e9432af44fab0f03e06fe7f6a75!400x400.jpeg', '15112322322', '1', '1555739036', '1', '0', '0', '2', '', '');
INSERT INTO `tp5_xusers` VALUES ('5', '佐罗', 'https://img2.woyaogexing.com/2019/11/20/e1a94beb38174eb6a98b07d6d2749833!400x400.jpeg', '18988777787', '1', '1555748309', '1', '0', '0', '0', '', '');
INSERT INTO `tp5_xusers` VALUES ('6', '龙溪', 'https://img2.woyaogexing.com/2019/11/20/23d88c964e4a41f8b08d5d7e5e232c8a!400x400.jpeg', '18788777788', '0', '1555748365', '0', '0', '0', '1', '', '');
INSERT INTO `tp5_xusers` VALUES ('7', '安若', 'https://img2.woyaogexing.com/2019/11/18/79dffa4237594e6995fd0a71048498f5!400x400.jpeg', '16888777787', '1', '1555748448', '0', '0', '0', '0', '', '');

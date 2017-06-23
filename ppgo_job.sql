/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Version : 50712
 Source Host           : localhost
 Source Database       : ppgo_job

 Target Server Version : 50712
 File Encoding         : utf-8

 Date: 06/23/2017 12:23:06 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `default`
-- ----------------------------
DROP TABLE IF EXISTS `default`;
CREATE TABLE `default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '密码盐',
  `last_login` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` char(15) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态，0正常 -1禁用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `default`
-- ----------------------------
BEGIN;
INSERT INTO `default` VALUES ('1', 'admin', 'admin@example.com', '7fef6171469e80d32c0559f88b377245', '', '0', '', '0');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task`;
CREATE TABLE `pp_task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `group_id` int(11) NOT NULL DEFAULT '0' COMMENT '分组ID',
  `task_name` varchar(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `task_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '任务类型',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '任务描述',
  `cron_spec` varchar(100) NOT NULL DEFAULT '' COMMENT '时间表达式',
  `concurrent` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否只允许一个实例',
  `command` text NOT NULL COMMENT '命令详情',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0停用 1启用',
  `notify` tinyint(4) NOT NULL DEFAULT '0' COMMENT '通知设置',
  `notify_email` text NOT NULL COMMENT '通知人列表',
  `timeout` smallint(6) NOT NULL DEFAULT '0' COMMENT '超时设置',
  `execute_times` int(11) NOT NULL DEFAULT '0' COMMENT '累计执行次数',
  `prev_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上次执行时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task` VALUES ('1', '1', '1', '测试任务', '0', '测试任务说明', '0 0/1 11 * *', '0', 'echo \"hello\\n\" >> /tmp/test_cron1.log', '0', '0', '', '0', '46', '1498187640', '1497855526'), ('2', '1', '1', '测试任务23', '0', '这是测试任务3', '*/5 * * * *', '0', 'echo \"hello22\" >> /tmp/test.log', '0', '1', 'sdf@11.com', '2', '12', '1498124835', '1498034382');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_group`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_group`;
CREATE TABLE `pp_task_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `group_name` varchar(50) NOT NULL DEFAULT '' COMMENT '组名',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_group`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_group` VALUES ('1', '1', '测试分组的', '这是测试的分组内容', '0'), ('2', '1', '小红书', '小红书的任务', '0');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_log`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_log`;
CREATE TABLE `pp_task_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务ID',
  `output` mediumtext NOT NULL COMMENT '任务输出',
  `error` text NOT NULL COMMENT '错误信息',
  `status` tinyint(4) NOT NULL COMMENT '状态',
  `process_time` int(11) NOT NULL DEFAULT '0' COMMENT '消耗时间/毫秒',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_log`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_log` VALUES ('1', '1', 'hello\\n\n', '', '0', '6', '1497855900'), ('2', '1', 'hello\\n\n', '', '0', '7', '1497855960'), ('3', '1', 'hello\\n\n', '', '0', '6', '1497856020'), ('4', '1', '', '', '0', '8', '1497856080'), ('5', '1', '', '', '0', '7', '1497856140'), ('6', '1', '', '', '0', '6', '1497856200'), ('7', '1', '', '', '0', '12', '1497856260'), ('8', '1', '', '', '0', '4', '1497856320'), ('9', '1', '', '', '0', '7', '1497856380'), ('10', '1', '', '', '0', '6', '1497856440'), ('11', '1', '', '', '0', '6', '1497856500'), ('12', '1', '', '', '0', '7', '1497856560'), ('13', '1', '', '', '0', '9', '1497856620'), ('14', '1', '', '', '0', '6', '1497856680'), ('15', '1', '', '', '0', '5', '1497856740'), ('16', '1', '', '', '0', '7', '1497856800'), ('17', '1', '', '', '0', '6', '1497856860'), ('18', '1', '', '', '0', '7', '1497856920'), ('19', '1', '', '', '0', '6', '1497856980'), ('20', '1', '', '', '0', '4', '1497857040'), ('21', '1', '', '', '0', '7', '1497857100'), ('22', '1', '', '', '0', '8', '1497857160'), ('23', '1', '', '', '0', '5', '1497857220'), ('24', '1', '', '', '0', '8', '1497857280'), ('25', '1', '', '', '0', '13', '1497857340'), ('26', '1', '', '', '0', '11', '1497857400'), ('27', '1', '', '', '0', '15', '1497857460'), ('28', '1', '', '', '0', '6', '1497857520'), ('29', '1', '', '', '0', '6', '1497857580'), ('30', '1', '', '', '0', '6', '1497857640'), ('31', '1', '', '', '0', '6', '1497857700'), ('32', '1', '', '', '0', '17', '1497857760'), ('33', '1', '', '', '0', '14', '1497857820'), ('34', '1', '', '', '0', '17', '1497857880'), ('35', '1', '', '', '0', '14', '1497857940'), ('36', '1', '', '', '0', '11', '1497858000'), ('37', '1', '', '', '0', '8', '1497858060'), ('38', '1', '', '', '0', '8', '1497858120'), ('39', '1', '', '', '0', '12', '1497858180'), ('40', '1', '', '', '0', '7', '1497858240'), ('41', '1', '', '', '0', '6', '1497858249'), ('42', '1', '', '', '0', '15', '1497860940'), ('43', '1', '', '', '0', '9', '1497861000'), ('44', '1', '', '', '0', '6', '1498058940'), ('45', '2', '', '', '0', '14', '1498060325'), ('48', '1', '', '', '0', '18', '1498060785'), ('49', '2', '', '', '0', '17', '1498107740'), ('50', '2', '', '', '0', '6', '1498107745'), ('51', '2', '', '', '0', '5', '1498107750'), ('52', '2', '', '', '0', '6', '1498107755'), ('53', '2', '', '', '0', '13', '1498122505'), ('54', '2', '', '', '0', '6', '1498122510'), ('55', '2', '', '', '0', '5', '1498122515'), ('56', '2', '', '', '0', '14', '1498124830'), ('57', '2', '', '', '0', '4', '1498124835'), ('58', '1', '', '', '0', '7', '1498187640');
COMMIT;

-- ----------------------------
--  Table structure for `pp_user`
-- ----------------------------
DROP TABLE IF EXISTS `pp_user`;
CREATE TABLE `pp_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '密码盐',
  `last_login` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` char(15) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态，0正常 -1禁用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_user`
-- ----------------------------
BEGIN;
INSERT INTO `pp_user` VALUES ('1', 'admin', 'haodaquan@shoplinq.cn', '7fef6171469e80d32c0559f88b377245', '', '1498123589', '[', '0');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

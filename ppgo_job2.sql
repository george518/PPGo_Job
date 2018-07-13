/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Version : 50639
 Source Host           : localhost
 Source Database       : ppgo_job2

 Target Server Version : 50639
 File Encoding         : utf-8

 Date: 07/13/2018 17:40:58 PM
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
  `group_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分组ID',
  `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器id',
  `task_name` varchar(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '任务描述',
  `cron_spec` varchar(100) NOT NULL DEFAULT '' COMMENT '时间表达式',
  `concurrent` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '是否只允许一个实例',
  `command` text NOT NULL COMMENT '命令详情',
  `timeout` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '超时设置 s',
  `execute_times` int(11) NOT NULL DEFAULT '0' COMMENT '累计执行次数',
  `prev_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上次执行时间',
  `status` tinyint(4) NOT NULL DEFAULT '2' COMMENT '-1删除，0停用 1启用 2审核中,3不通过',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次编辑时间',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次编辑者ID',
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task` VALUES ('1', '2', '1', '蜜月任务名称', '测试任务说明', '*/2 * * * *', '0', 'echo \"hello\\n\" >> /tmp/test.log', '0', '193', '1531462016', '0', '1497855526', '0', '1530776943', '1'), ('2', '2', '4', '外部测试服务器', '一分钟一次2', '*/2 * * * * *', '0', 'echo \"testeee\\n\" >> /tmp/ppgo.log', '0', '151', '1531462016', '0', '1502876155', '0', '1530774680', '1'), ('3', '1', '1', '重要测试任务222', '2s执行一次', '*/2 *  *  *  *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '26', '1531275962', '2', '1502936077', '0', '1531274971', '1'), ('9', '6', '8', '密码验证任务23', '5秒执行一次', '*/5 * * * *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '12', '1502958585', '2', '1502945973', '0', '1531275044', '1'), ('10', '4', '9', '密码验证任务112', '5秒执行一次', '*/5 * * * *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '29', '1531468808', '3', '1503991581', '0', '1531275153', '1'), ('11', '4', '0', 'sdfsd', 'sdfsd', '* * * * * ?', '0', 'echo \"hello ppgo_job\\n\" >> /tmp/test_ppgo.log', '0', '139', '1531469404', '0', '1530599445', '1', '1531444040', '1'), ('12', '2', '0', '本地服务器测试', '5秒一次', '*/5 * * * * *', '0', 'echo \"hello ppgo\\n\" >> /tmp/ppgo.log', '0', '49', '1531462015', '0', '1530761019', '1', '1530761837', '1'), ('13', '2', '0', '本地服务器测试', '5秒一次', '*/5 * * * * *', '0', 'echo \"hello ppgo\\n\" >> /tmp/ppgo.log', '0', '0', '0', '2', '1531468119', '1', '1531468119', '0'), ('14', '2', '0', '本地服务器测试', '5秒一次', '*/5 * * * * *', '0', 'echo \"hello ppgo\\n\" >> /tmp/ppgo.log', '0', '0', '0', '2', '1531468712', '1', '1531468712', '0');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_ban`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_ban`;
CREATE TABLE `pp_task_ban` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL DEFAULT '0' COMMENT '命令',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0-正常，1-删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='权限和角色关系表';

-- ----------------------------
--  Records of `pp_task_ban`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_ban` VALUES ('1', 'rm -rf', '0', '1528639692', '1'), ('2', 'dd if=/dev/random of=/dev/sda', '1528639322', '1528639588', '0'), ('3', 'mkfs.ext3 /dev/sda', '1528639445', '0', '0');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_group`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_group`;
CREATE TABLE `pp_task_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) NOT NULL DEFAULT '' COMMENT '组名',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `create_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改者Id',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：1-正常，0-删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`create_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_group`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_group` VALUES ('1', '抓取任务', '定时抓取网页', '1', '0', '0', '0', '0'), ('2', '测试任务组', '任务分组测试', '0', '0', '1', '1531297875', '1'), ('3', 'dddfsdf', 'ddsdfds', '0', '0', '1', '1528644000', '0'), ('4', '商品任务组', '商品组', '0', '0', '1', '1530760471', '1'), ('5', '另一个任务分组', '另一个任务分组', '1', '1528644075', '1', '1528644096', '0'), ('6', '订单任务组', '订单任务组', '0', '0', '1', '1530760457', '1');
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
) ENGINE=InnoDB AUTO_INCREMENT=465 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_log`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_log` VALUES ('1', '7', '等待10秒\nphp执行完毕', '', '0', '20484', '1502940420'), ('2', '7', '等待10秒\nphp执行完毕', '', '0', '20367', '1502940480'), ('3', '8', '等待11秒\nphp执行完毕', '', '0', '121487', '1502940420'), ('4', '7', '等待10秒\nphp执行完毕', '', '0', '20317', '1502940540'), ('5', '7', '等待10秒\nphp执行完毕', '', '0', '20629', '1502940600'), ('6', '7', '等待10秒\nphp执行完毕', '', '0', '20387', '1502940660'), ('7', '8', '等待11秒\nphp执行完毕', '', '0', '121626', '1502940600'), ('8', '7', '等待10秒\nphp执行完毕', '', '0', '20486', '1502940720'), ('9', '7', '等待10秒\nphp执行完毕', '', '0', '20416', '1502940780'), ('10', '7', '等待10秒\nphp执行完毕', '', '0', '20378', '1502940840'), ('11', '8', '等待11秒\nphp执行完毕', '', '0', '121432', '1502940780'), ('12', '7', '等待10秒\nphp执行完毕', '', '0', '21313', '1502940900'), ('13', '7', '等待10秒\nphp执行完毕', '', '0', '20420', '1502940960'), ('14', '7', '等待10秒\nphp执行完毕', '', '0', '21271', '1502941020'), ('15', '8', '等待11秒\nphp执行完毕', '', '0', '121418', '1502940960'), ('16', '7', '等待10秒\nphp执行完毕', '', '0', '20355', '1502941080'), ('17', '3', '等待11秒\nphp执行完毕', '', '0', '121437', '1502941260'), ('18', '3', '等待11秒\nphp执行完毕', '', '0', '121343', '1502941383'), ('19', '1', '', '', '0', '56', '1502941758'), ('20', '9', '等待11秒\nphp执行完毕', '', '0', '121481', '1502946004'), ('21', '9', '等待11秒\nphp执行完毕', '', '0', '121344', '1502946350'), ('22', '9', '等待11秒\nphp执行完毕', '', '0', '121401', '1502946475'), ('23', '9', '等待11秒\nphp执行完毕', '', '0', '121379', '1502946600'), ('24', '9', '等待11秒\nphp执行完毕', '', '0', '121341', '1502946725'), ('25', '9', '等待11秒\nphp执行完毕', '', '0', '121448', '1502957835'), ('26', '9', '等待11秒\nphp执行完毕', '', '0', '121549', '1502957960'), ('27', '9', '等待11秒\nphp执行完毕', '', '0', '121795', '1502958085'), ('28', '9', '等待11秒\nphp执行完毕', '', '0', '121433', '1502958210'), ('29', '9', '等待11秒\nphp执行完毕', '', '0', '121379', '1502958335'), ('30', '9', '等待11秒\nphp执行完毕', '', '0', '121507', '1502958460'), ('31', '9', '等待11秒\nphp执行完毕', '', '0', '121423', '1502958585'), ('32', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75249', '1504834495'), ('33', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75128', '1504834575'), ('34', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75157', '1504834655'), ('35', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75162', '1504834955'), ('36', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75424', '1504835035'), ('37', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75277', '1504835115'), ('38', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75210', '1504835195'), ('39', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75414', '1504835275'), ('40', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75345', '1504835355'), ('41', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75444', '1504835435'), ('42', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75261', '1504835515'), ('43', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75233', '1504835595'), ('44', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75249', '1504835675'), ('45', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75228', '1504835755'), ('46', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75306', '1504835835'), ('47', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75262', '1504835915'), ('48', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75312', '1504835995'), ('49', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75256', '1504836075'), ('50', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75227', '1504836155'), ('51', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75253', '1504836235'), ('52', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75332', '1504836315'), ('53', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75320', '1504836395'), ('54', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75504', '1504836475'), ('55', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75248', '1504836555'), ('56', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75179', '1504836635'), ('57', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75194', '1504836715'), ('58', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75467', '1512095325'), ('59', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75382', '1512095405'), ('61', '2', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75535', '1512097500'), ('79', '1', '', 'open /Users/haodaquan/.ssh/pp_rsa: no such file or directory:', '-1', '0', '1530775156'), ('80', '1', '', 'open /Users/haodaquan/.ssh/pp_rsa: no such file or directory:', '-1', '0', '1530775195'), ('81', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530775349'), ('82', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776632'), ('83', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776634'), ('84', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776636'), ('85', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776638'), ('86', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776640'), ('87', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776642'), ('88', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776644'), ('89', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776646'), ('90', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776648'), ('91', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776650'), ('92', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776652'), ('93', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776654'), ('94', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776656'), ('95', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776658'), ('96', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776660'), ('97', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776662'), ('98', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776664'), ('99', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776666'), ('100', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776668'), ('101', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776670'), ('102', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776672'), ('103', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776674'), ('104', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776676'), ('105', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776678'), ('106', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776680'), ('107', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776682'), ('108', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776724'), ('109', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776726'), ('110', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776728'), ('111', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776730'), ('112', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776732'), ('113', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776734'), ('114', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776736'), ('115', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776738'), ('116', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776740'), ('117', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776742'), ('118', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776744'), ('119', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776746'), ('120', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776748'), ('121', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776750'), ('122', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776752'), ('123', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776754'), ('124', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776756'), ('125', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776758'), ('126', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776760'), ('127', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776762'), ('128', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776764'), ('129', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776766'), ('130', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776768'), ('131', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776770'), ('132', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776772'), ('133', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776774'), ('134', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776776'), ('135', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776778'), ('136', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776780'), ('137', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776782'), ('138', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776784'), ('139', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776786'), ('140', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776788'), ('141', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776790'), ('142', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776792'), ('143', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776794'), ('144', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776796'), ('145', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776798'), ('146', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776800'), ('147', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776802'), ('148', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776804'), ('149', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776806'), ('150', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776808'), ('151', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776810'), ('152', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776812'), ('153', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776814'), ('154', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776816'), ('155', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776818'), ('156', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776820'), ('157', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776822'), ('158', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776824'), ('159', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776826'), ('160', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776828'), ('161', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776830'), ('162', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776832'), ('163', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776834'), ('164', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776836'), ('165', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776838'), ('166', '1', '', 'open /Users/haodaquan/.ssh/george_service: no such file or directory:', '-1', '0', '1530776840'), ('167', '1', '', '', '0', '84', '1530776960'), ('168', '1', '', '', '0', '59', '1530776962'), ('169', '1', '', '', '0', '81', '1530776964'), ('170', '1', '', '', '0', '61', '1530776966'), ('171', '1', '', '', '0', '71', '1530776968'), ('172', '1', '', '', '0', '64', '1530776970'), ('173', '1', '', '', '0', '65', '1530776972'), ('174', '1', '', '', '0', '83', '1530776974'), ('175', '1', '', '', '0', '63', '1530776976'), ('176', '1', '', '', '0', '69', '1530776978'), ('177', '1', '', '', '0', '71', '1530776980'), ('178', '1', '', '', '0', '98', '1530776982'), ('179', '1', '', '', '0', '71', '1530776984'), ('180', '1', '', '', '0', '65', '1530776986'), ('181', '1', '', '', '0', '71', '1530776988'), ('182', '1', '', '', '0', '72', '1530776990'), ('183', '1', '', '', '0', '76', '1530776992'), ('184', '1', '', '', '0', '77', '1530777000'), ('185', '1', '', '', '0', '81', '1530777005'), ('186', '1', '', '', '0', '96', '1530777009'), ('187', '2', '', '', '0', '72', '1531207858'), ('188', '2', '', '', '0', '76', '1531207869'), ('189', '2', '', '', '0', '72', '1531207958'), ('190', '12', '', '', '0', '12', '1531207964'), ('191', '12', '', '', '0', '6', '1531207986'), ('192', '12', '', '', '0', '6', '1531208038'), ('193', '12', '', '', '0', '7', '1531208048'), ('194', '12', '', '', '0', '7', '1531208670'), ('195', '12', '', '', '0', '5', '1531208679'), ('196', '12', '', '', '0', '15', '1531209005'), ('197', '12', '', '', '0', '9', '1531210801'), ('198', '12', '', '', '0', '9', '1531210808'), ('199', '12', '', '', '0', '10', '1531211025'), ('200', '2', '', '', '0', '86', '1531211026'), ('201', '2', '', '', '0', '92', '1531211028'), ('202', '12', '', '', '0', '7', '1531211030'), ('203', '2', '', '', '0', '65', '1531211030'), ('204', '2', '', '', '0', '66', '1531211032'), ('205', '2', '', '', '0', '64', '1531211034'), ('206', '12', '', '', '0', '6', '1531211035'), ('207', '2', '', '', '0', '61', '1531211036'), ('208', '2', '', '', '0', '72', '1531211038'), ('209', '12', '', '', '0', '8', '1531211040'), ('210', '2', '', '', '0', '84', '1531211040'), ('211', '2', '', '', '0', '66', '1531211042'), ('212', '2', '', '', '0', '65', '1531211044'), ('213', '12', '', '', '0', '6', '1531211045'), ('214', '2', '', '', '0', '67', '1531211046'), ('215', '2', '', '', '0', '68', '1531211048'), ('216', '12', '', '', '0', '11', '1531211050'), ('217', '2', '', '', '0', '108', '1531211050'), ('218', '2', '', '', '0', '68', '1531211052'), ('219', '12', '', '', '0', '6', '1531211140'), ('220', '12', '', '', '0', '6', '1531211145'), ('221', '12', '', '', '0', '6', '1531211150'), ('222', '12', '', '', '0', '8', '1531211220'), ('223', '12', '', '', '0', '8', '1531211225'), ('224', '12', '', '', '0', '7', '1531211230'), ('225', '1', '', '', '0', '63', '1531211252'), ('226', '1', '', '', '0', '59', '1531211254'), ('227', '1', '', '', '0', '75', '1531211256'), ('228', '1', '', '', '0', '70', '1531211258'), ('229', '1', '', '', '0', '54', '1531211260'), ('230', '1', '', '', '0', '58', '1531211262'), ('231', '12', '', '', '0', '41', '1531271840'), ('232', '12', '', '', '0', '7', '1531271845'), ('233', '12', '', '', '0', '7', '1531271850'), ('234', '12', '', '', '0', '14', '1531271855'), ('235', '12', '', '', '0', '10', '1531271860'), ('236', '12', '', '', '0', '8', '1531271865'), ('237', '3', '', 'Process exited with status 127:', '-1', '60', '1531272684'), ('238', '3', '', 'Process exited with status 127:', '-1', '60', '1531275962'), ('239', '12', '', '', '0', '17', '1531276005'), ('240', '12', '', '', '0', '13', '1531276010'), ('241', '12', '', '', '0', '11', '1531276015'), ('242', '12', '', '', '0', '13', '1531276020'), ('243', '12', '', '', '0', '17', '1531276156'), ('244', '12', '', '', '0', '17', '1531276254'), ('245', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531276361'), ('246', '12', '', '', '0', '19', '1531276528'), ('247', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298874'), ('248', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298875'), ('249', '12', '', '', '0', '25', '1531298875'), ('250', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298876'), ('251', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298877'), ('252', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298878'), ('253', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298879'), ('254', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298880'), ('255', '12', '', '', '0', '9', '1531298880'), ('256', '11', '', 'open ddd: no such file or directory:', '-1', '0', '1531298881'), ('257', '11', 'anaconda-ks.cfg\ngolang.org\ninstall.log\ninstall.log.syslog\nsoft\ntest\ntmall.sh\n公共的\n模板\n视频\n图片\n文档\n下载\n音乐\n桌面\n', '', '0', '762', '1531389132'), ('258', '11', 'anaconda-ks.cfg\ngolang.org\ninstall.log\ninstall.log.syslog\nsoft\ntest\ntmall.sh\n公共的\n模板\n视频\n图片\n文档\n下载\n音乐\n桌面\n', '', '0', '64', '1531389133'), ('259', '11', 'anaconda-ks.cfg\ngolang.org\ninstall.log\ninstall.log.syslog\nsoft\ntest\ntmall.sh\n公共的\n模板\n视频\n图片\n文档\n下载\n音乐\n桌面\n', '', '0', '62', '1531389134'), ('260', '11', 'anaconda-ks.cfg\ngolang.org\ninstall.log\ninstall.log.syslog\nsoft\ntest\ntmall.sh\n公共的\n模板\n视频\n图片\n文档\n下载\n音乐\n桌面\n', '', '0', '1093', '1531389135'), ('261', '11', 'anaconda-ks.cfg\ngolang.org\ninstall.log\ninstall.log.syslog\nsoft\ntest\ntmall.sh\n公共的\n模板\n视频\n图片\n文档\n下载\n音乐\n桌面\n', '', '0', '76', '1531389137'), ('264', '11', '', '', '0', '52', '1531444065'), ('265', '11', '', '', '0', '7', '1531444066'), ('266', '11', '', '', '0', '7', '1531444067'), ('267', '11', '', '', '0', '9', '1531444068'), ('268', '11', '', '', '0', '7', '1531444069'), ('269', '11', '', '', '0', '9', '1531444070'), ('270', '11', '', '', '0', '7', '1531444071'), ('271', '11', '', '', '0', '7', '1531444072'), ('272', '11', '', '', '0', '6', '1531444073'), ('273', '11', '', '', '0', '8', '1531444074'), ('274', '11', '', '', '0', '7', '1531444075'), ('275', '11', '', '', '0', '8', '1531444076'), ('276', '11', '', '', '0', '9', '1531444080'), ('277', '11', '', '', '0', '9', '1531444081'), ('278', '11', '', '', '0', '7', '1531444082'), ('279', '11', '', '', '0', '8', '1531444083'), ('280', '11', '', '', '0', '7', '1531444084'), ('281', '11', '', '', '0', '8', '1531444085'), ('282', '11', '', '', '0', '8', '1531444086'), ('283', '11', '', '', '0', '7', '1531444087'), ('284', '11', '', '', '0', '11', '1531444129'), ('285', '11', '', '', '0', '9', '1531444130'), ('286', '11', '', '', '0', '7', '1531444131'), ('287', '11', '', '', '0', '6', '1531444132'), ('288', '11', '', '', '0', '7', '1531444133'), ('289', '11', '', '', '0', '15', '1531444134'), ('290', '11', '', '', '0', '9', '1531444135'), ('291', '11', '', '', '0', '7', '1531444136'), ('292', '11', '', '', '0', '8', '1531444137'), ('293', '11', '', '', '0', '8', '1531444138'), ('294', '11', '', '', '0', '6', '1531444139'), ('295', '11', '', '', '0', '12', '1531444140'), ('296', '11', '', '', '0', '8', '1531444141'), ('297', '11', '', '', '0', '7', '1531444142'), ('298', '11', '', '', '0', '7', '1531444143'), ('299', '11', '', '', '0', '8', '1531444473'), ('300', '11', '', '', '0', '7', '1531444474'), ('301', '11', '', '', '0', '7', '1531444475'), ('302', '11', '', '', '0', '7', '1531444476'), ('303', '11', '', '', '0', '7', '1531444477'), ('304', '11', '', '', '0', '7', '1531444478'), ('305', '11', '', '', '0', '6', '1531444479'), ('306', '11', '', '', '0', '7', '1531444480'), ('307', '11', '', '', '0', '8', '1531444481'), ('308', '11', '', '', '0', '6', '1531444482'), ('309', '11', '', '', '0', '13', '1531444483'), ('310', '11', '', '', '0', '8', '1531444484'), ('311', '11', '', '', '0', '8', '1531444485'), ('312', '11', '', '', '0', '6', '1531444486'), ('313', '11', '', '', '0', '7', '1531444487'), ('314', '11', '', '', '0', '7', '1531444488'), ('315', '11', '', '', '0', '6', '1531444489'), ('316', '11', '', '', '0', '25', '1531461954'), ('317', '1', '', '', '0', '67', '1531461954'), ('318', '2', '', '', '0', '71', '1531461954'), ('319', '11', '', '', '0', '11', '1531461955'), ('320', '12', '', '', '0', '16', '1531461955'), ('321', '11', '', '', '0', '9', '1531461956'), ('322', '1', '', '', '0', '53', '1531461956'), ('323', '2', '', '', '0', '73', '1531461956'), ('324', '11', '', '', '0', '9', '1531461957'), ('325', '11', '', '', '0', '11', '1531461958'), ('326', '1', '', '', '0', '68', '1531461958'), ('327', '2', '', '', '0', '121', '1531461958'), ('328', '11', '', '', '0', '8', '1531461959'), ('329', '12', '', '', '0', '11', '1531461960'), ('330', '11', '', '', '0', '10', '1531461960'), ('331', '1', '', '', '0', '60', '1531461960'), ('332', '2', '', '', '0', '65', '1531461960'), ('333', '11', '', '', '0', '7', '1531461961'), ('334', '11', '', '', '0', '8', '1531461962'), ('335', '1', '', '', '0', '56', '1531461962'), ('336', '2', '', '', '0', '62', '1531461962'), ('337', '11', '', '', '0', '7', '1531461963'), ('338', '11', '', '', '0', '10', '1531461964'), ('339', '1', '', '', '0', '67', '1531461964'), ('340', '2', '', '', '0', '70', '1531461964'), ('341', '11', '', '', '0', '12', '1531461965'), ('342', '12', '', '', '0', '14', '1531461965'), ('343', '11', '', '', '0', '8', '1531461966'), ('344', '1', '', '', '0', '57', '1531461966'), ('345', '2', '', '', '0', '68', '1531461966'), ('346', '11', '', '', '0', '24', '1531461967'), ('347', '11', '', '', '0', '12', '1531461968'), ('348', '1', '', '', '0', '68', '1531461968'), ('349', '2', '', '', '0', '110', '1531461968'), ('350', '11', '', '', '0', '8', '1531461969'), ('351', '12', '', '', '0', '18', '1531461970'), ('352', '11', '', '', '0', '16', '1531461970'), ('353', '1', '', '', '0', '72', '1531461970'), ('354', '2', '', '', '0', '123', '1531461970'), ('355', '11', '', '', '0', '9', '1531461971'), ('356', '11', '', '', '0', '9', '1531461972'), ('357', '1', '', '', '0', '68', '1531461972'), ('358', '2', '', '', '0', '76', '1531461972'), ('359', '11', '', '', '0', '9', '1531461973'), ('360', '11', '', '', '0', '8', '1531461974'), ('361', '1', '', '', '0', '62', '1531461974'), ('362', '2', '', '', '0', '69', '1531461974'), ('363', '12', '', '', '0', '35', '1531461975'), ('364', '11', '', '', '0', '35', '1531461975'), ('365', '11', '', '', '0', '12', '1531461976'), ('366', '1', '', '', '0', '60', '1531461976'), ('367', '2', '', '', '0', '64', '1531461976'), ('368', '11', '', '', '0', '11', '1531461977'), ('369', '11', '', '', '0', '22', '1531461978'), ('370', '1', '', '', '0', '67', '1531461978'), ('371', '2', '', '', '0', '86', '1531461978'), ('372', '11', '', '', '0', '10', '1531461979'), ('373', '12', '', '', '0', '11', '1531461980'), ('374', '11', '', '', '0', '17', '1531461980'), ('375', '1', '', '', '0', '67', '1531461980'), ('376', '2', '', '', '0', '87', '1531461980'), ('377', '11', '', '', '0', '10', '1531461981'), ('378', '11', '', '', '0', '11', '1531461982'), ('379', '1', '', '', '0', '69', '1531461982'), ('380', '2', '', '', '0', '79', '1531461982'), ('381', '11', '', '', '0', '8', '1531461983'), ('382', '11', '', '', '0', '10', '1531461984'), ('383', '2', '', '', '0', '75', '1531461984'), ('384', '1', '', '', '0', '77', '1531461984'), ('385', '12', '', '', '0', '9', '1531461985'), ('386', '11', '', '', '0', '10', '1531461985'), ('387', '11', '', '', '0', '10', '1531461986'), ('388', '1', '', '', '0', '65', '1531461986'), ('389', '2', '', '', '0', '71', '1531461986'), ('390', '11', '', '', '0', '8', '1531461987'), ('391', '11', '', '', '0', '8', '1531461988'), ('392', '1', '', '', '0', '68', '1531461988'), ('393', '2', '', '', '0', '68', '1531461988'), ('394', '11', '', '', '0', '8', '1531461989'), ('395', '12', '', '', '0', '15', '1531461990'), ('396', '11', '', '', '0', '20', '1531461990'), ('397', '2', '', '', '0', '74', '1531461990'), ('398', '1', '', '', '0', '77', '1531461990'), ('399', '11', '', '', '0', '8', '1531461991'), ('400', '11', '', '', '0', '9', '1531461992'), ('401', '1', '', '', '0', '63', '1531461992'), ('402', '2', '', '', '0', '110', '1531461992'), ('403', '11', '', '', '0', '8', '1531461993'), ('404', '11', '', '', '0', '20', '1531461994'), ('405', '1', '', '', '0', '116', '1531461994'), ('406', '2', '', '', '0', '112', '1531461994'), ('407', '12', '', '', '0', '12', '1531461995'), ('408', '11', '', '', '0', '15', '1531461995'), ('409', '11', '', '', '0', '9', '1531461996'), ('410', '1', '', '', '0', '64', '1531461996'), ('411', '2', '', '', '0', '73', '1531461996'), ('412', '11', '', '', '0', '8', '1531461997'), ('413', '11', '', '', '0', '15', '1531461998'), ('414', '1', '', '', '0', '64', '1531461998'), ('415', '2', '', '', '0', '80', '1531461998'), ('416', '11', '', '', '0', '10', '1531461999'), ('417', '12', '', '', '0', '19', '1531462000'), ('418', '11', '', '', '0', '21', '1531462000'), ('419', '1', '', '', '0', '113', '1531462000'), ('420', '2', '', '', '0', '113', '1531462000'), ('421', '11', '', '', '0', '7', '1531462001'), ('422', '11', '', '', '0', '18', '1531462002'), ('423', '1', '', '', '0', '68', '1531462002'), ('424', '2', '', '', '0', '121', '1531462002'), ('425', '11', '', '', '0', '8', '1531462003'), ('426', '11', '', '', '0', '8', '1531462004'), ('427', '1', '', '', '0', '69', '1531462004'), ('428', '2', '', '', '0', '82', '1531462004'), ('429', '12', '', '', '0', '11', '1531462005'), ('430', '11', '', '', '0', '15', '1531462005'), ('431', '11', '', '', '0', '8', '1531462006'), ('432', '1', '', '', '0', '68', '1531462006'), ('433', '2', '', '', '0', '69', '1531462006'), ('434', '11', '', '', '0', '9', '1531462007'), ('435', '11', '', '', '0', '11', '1531462008'), ('436', '1', '', '', '0', '67', '1531462008'), ('437', '2', '', '', '0', '86', '1531462008'), ('438', '11', '', '', '0', '9', '1531462009'), ('439', '12', '', '', '0', '13', '1531462010'), ('440', '11', '', '', '0', '15', '1531462010'), ('441', '1', '', '', '0', '72', '1531462010'), ('442', '2', '', '', '0', '74', '1531462010'), ('443', '11', '', '', '0', '10', '1531462011'), ('444', '11', '', '', '0', '13', '1531462012'), ('445', '1', '', '', '0', '67', '1531462012'), ('446', '2', '', '', '0', '82', '1531462012'), ('447', '11', '', '', '0', '6', '1531462013'), ('448', '11', '', '', '0', '9', '1531462014'), ('449', '1', '', '', '0', '67', '1531462014'), ('450', '2', '', '', '0', '66', '1531462014'), ('451', '12', '', '', '0', '11', '1531462015'), ('452', '11', '', '', '0', '13', '1531462015'), ('453', '11', '', '', '0', '9', '1531462016'), ('454', '1', '', '', '0', '63', '1531462016'), ('455', '2', '', '', '0', '76', '1531462016'), ('456', '10', '', 'Process exited with status 1:', '-1', '395', '1531468808'), ('457', '11', '', '', '0', '39', '1531469379'), ('458', '11', '', '', '0', '9', '1531469380'), ('459', '11', '', '', '0', '9', '1531469381'), ('460', '11', '', '', '0', '7', '1531469382'), ('461', '11', '', '', '0', '7', '1531469383'), ('462', '11', '', '', '0', '8', '1531469384'), ('463', '11', '', '', '0', '8', '1531469385');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_server`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_server`;
CREATE TABLE `pp_task_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `group_id` int(64) NOT NULL,
  `server_name` varchar(64) NOT NULL DEFAULT '0' COMMENT '服务器名称',
  `server_account` varchar(32) NOT NULL DEFAULT 'root' COMMENT '账户名称',
  `server_outer_ip` varchar(20) NOT NULL DEFAULT '0' COMMENT '外网IP',
  `server_ip` varchar(20) NOT NULL DEFAULT '0' COMMENT '服务器内网IP',
  `port` int(4) unsigned NOT NULL DEFAULT '22' COMMENT '服务器端口',
  `password` varchar(64) NOT NULL DEFAULT '0' COMMENT '服务器密码',
  `private_key_src` varchar(128) NOT NULL DEFAULT '0' COMMENT '私钥文件地址',
  `public_key_src` varchar(128) NOT NULL DEFAULT '0' COMMENT '公钥地址',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '登录类型：0-密码登录，1-私钥登录',
  `detail` varchar(255) NOT NULL DEFAULT '0' COMMENT '备注',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='服务器列表';

-- ----------------------------
--  Records of `pp_task_server`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_server` VALUES ('1', '2', '密钥验证服务器', 'root', '0', '10.32.33.27', '22', '', '/Users/georgehao/.ssh/george_service', '/Users/georgehao/.ssh/george_service.pub', '1', '远程服务器示例', '1502862723', '1530776931', '0'), ('4', '1', '密码验证服务器', 'root', '0', '10.32.33.27', '22', '123456', '', '', '0', '这是密码验证服务器', '1502945869', '1530774374', '0'), ('5', '5', '改革名字吧', 'sddsss', '1212', '111', '12', '11111111111', '', '', '0', '是法师打发', '1528595874', '1528602429', '1'), ('6', '3', '对对是的发送到方式', 'sddsss', '1212', '111', '22', '123456', '', '', '0', '是法师打发', '1528595887', '1528599948', '1'), ('7', '3', '是的发送到sd', 'dd', '1212', '1121', '22', '', 'sdfdss', 'dfsdf', '1', '的发生的范德萨', '1528598520', '1528602362', '1'), ('8', '1', '服务器名称11', 'root', '11', '11', '22', '121212121', '', '', '0', '12121', '1528991161', '1528991161', '0'), ('9', '1', '服务器22', 'root', '0', '10.32.33.54', '22', '123456', 'ddd', 'dd', '0', '测试', '1528991244', '1531386562', '0'), ('10', '10', '资源分组11的服务器', 'root', '192.11.11.11', '192.168.1.1', '22', '111232', '', '', '0', 'sdfssdfsdf', '1530587951', '1531359684', '0'), ('11', '9', '服务器分组3的服务器', 'root', '192.11.11.11', '192.168.1.1', '22', '111232', '', '', '0', 'sdfssdfsdf', '1531383433', '1531383433', '0');
COMMIT;

-- ----------------------------
--  Table structure for `pp_task_server_group`
-- ----------------------------
DROP TABLE IF EXISTS `pp_task_server_group`;
CREATE TABLE `pp_task_server_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) NOT NULL DEFAULT '0' COMMENT '组名',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1-正常，0-删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新id',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`create_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_server_group`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_server_group` VALUES ('1', '南方机房', '南方机房组', '1', '0', '1530760598', '0', '1'), ('2', '北方机房', '北方机房的机器', '1', '0', '1530760568', '0', '1'), ('3', '测试删除分组', '测试删除分组', '0', '0', '1528643885', '1', '1'), ('4', '对对对', '对对对ddd', '0', '1528530609', '1528531447', '1', '1'), ('5', '对对对', '对对对ddd', '0', '1528530704', '1528602442', '1', '1'), ('6', '对对对dd', '对对对ddd', '0', '1528530765', '1528531433', '1', '1'), ('7', '对对对dddd', '对对对ddd', '0', '0', '1528531443', '0', '1'), ('8', 'dd', 'dfdf', '0', '1528531006', '1528531438', '1', '1'), ('9', '服务器分组3', '资源分组3', '1', '0', '1531383057', '0', '1'), ('10', '服务器分组4', '资源分组4', '1', '0', '1531383072', '0', '1');
COMMIT;

-- ----------------------------
--  Table structure for `pp_uc_admin`
-- ----------------------------
DROP TABLE IF EXISTS `pp_uc_admin`;
CREATE TABLE `pp_uc_admin` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `login_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `real_name` varchar(32) NOT NULL DEFAULT '0' COMMENT '真实姓名',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `role_ids` varchar(255) NOT NULL DEFAULT '0' COMMENT '角色id字符串，如：2,3,4',
  `phone` varchar(20) NOT NULL DEFAULT '0' COMMENT '手机号码',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '密码盐',
  `last_login` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` char(15) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态，1-正常 0禁用',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改者ID',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_name` (`login_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ----------------------------
--  Records of `pp_uc_admin`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_admin` VALUES ('1', 'admin', '超级管理员', 'abfcf6dcedfb4b5b1505d41a8b4c77e8', '0', '13811551087', 'haodaquan2008@163.com', 'aYk4Q1P83v', '1531469426', '[', '1', '0', '1', '0', '1528462051'), ('2', 'test_1', 'pipi', 'b937149452da9f7a36f304dc00149edc', '1', '13811551000', 'haodaquan@123.com', '1Uep', '1531469465', '[', '1', '1', '1', '1528459479', '1531469623');
COMMIT;

-- ----------------------------
--  Table structure for `pp_uc_auth`
-- ----------------------------
DROP TABLE IF EXISTS `pp_uc_auth`;
CREATE TABLE `pp_uc_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级ID，0为顶级',
  `auth_name` varchar(64) NOT NULL DEFAULT '0' COMMENT '权限名称',
  `auth_url` varchar(255) NOT NULL DEFAULT '0' COMMENT 'URL地址',
  `sort` int(1) unsigned NOT NULL DEFAULT '999' COMMENT '排序，越小越前',
  `icon` varchar(255) NOT NULL,
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否显示，0-隐藏，1-显示',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作者ID',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改者ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态，1-正常，0-删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COMMENT='权限因子';

-- ----------------------------
--  Records of `pp_uc_auth`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_auth` VALUES ('1', '0', '所有权限', '/', '1', '', '0', '1', '1', '1', '1', '1505620970', '1505620970'), ('2', '1', '权限管理', '/', '999', 'fa-id-card', '1', '1', '0', '1', '1', '0', '1505622360'), ('3', '2', '用户管理', '/admin/list', '1', 'fa-user-o', '1', '0', '0', '0', '1', '0', '1528385411'), ('4', '2', '角色管理', '/role/list', '2', 'fa-user-circle-o', '1', '1', '0', '1', '1', '0', '1505621852'), ('5', '3', '新增', '/admin/add', '1', '', '0', '1', '0', '1', '1', '0', '1505621685'), ('6', '3', '修改', '/admin/edit', '2', '', '0', '1', '0', '1', '1', '0', '1505621697'), ('7', '3', '删除', '/admin/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505621756', '1505621756'), ('8', '4', '新增', '/role/add', '1', '', '1', '1', '0', '1', '1', '0', '1505698716'), ('9', '4', '修改', '/role/edit', '2', '', '0', '1', '1', '1', '1', '1505621912', '1505621912'), ('10', '4', '删除', '/role/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505621951', '1505621951'), ('11', '2', '权限因子', '/auth/list', '3', 'fa-list', '1', '1', '1', '1', '1', '1505621986', '1505621986'), ('12', '11', '新增', '/auth/add', '1', '', '0', '1', '1', '1', '1', '1505622009', '1505622009'), ('13', '11', '修改', '/auth/edit', '2', '', '0', '1', '1', '1', '1', '1505622047', '1505622047'), ('14', '11', '删除', '/auth/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505622111', '1505622111'), ('15', '1', '个人中心', 'profile/edit', '1001', 'fa-user-circle-o', '1', '1', '0', '1', '1', '0', '1506001114'), ('16', '15', '资料修改', '/user/edit', '1', 'fa-edit', '1', '0', '0', '0', '1', '1528385551', '1528385551'), ('17', '1', '基本设置', '/', '2', 'fa-cogs', '1', '1', '0', '1', '1', '0', '1528464467'), ('18', '17', '资源分组', '/servergroup/list', '2', 'fa-cubes', '1', '1', '0', '1', '1', '0', '1528466663'), ('19', '17', '资源管理', '/server/list', '1', 'fa-cube', '1', '1', '0', '1', '1', '0', '1528464498'), ('20', '17', '禁用命令', '/ban/list', '3', 'fa-exclamation-triangle', '1', '1', '0', '1', '1', '0', '1528464656'), ('21', '18', '新增', '/servergroup/add', '1', '', '0', '1', '0', '1', '1', '0', '1528466669'), ('22', '18', '修改', '/servergroup/edit', '2', '', '0', '1', '0', '1', '1', '0', '1528466675'), ('23', '18', '删除', '/servergroup/ajaxdel', '3', '', '0', '1', '0', '1', '1', '0', '1528466684'), ('24', '19', '新增', '/server/add', '1', '', '0', '1', '1', '1', '1', '1528464882', '1528464882'), ('25', '19', '修改', '/server/edit', '2', '', '0', '1', '1', '1', '1', '1528464904', '1528464904'), ('26', '19', '删除', '/server/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528464937', '1528464937'), ('27', '20', '新增', '/ban/add', '1', '', '0', '1', '1', '1', '1', '1528464977', '1528464977'), ('28', '20', '修改', '/ban/edit', '2', '', '0', '1', '1', '1', '1', '1528465005', '1528465005'), ('29', '20', '删除', '/ban/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528465036', '1528465036'), ('30', '1', '任务管理', '/job/list', '1', 'fa-tasks', '1', '1', '1', '1', '1', '1528639988', '1528639988'), ('31', '30', '任务列表', '/task/list', '1', 'fa-object-ungroup', '1', '1', '0', '1', '1', '0', '1531212830'), ('32', '30', '任务分组', '/group/list', '3', 'fa-object-group', '1', '1', '0', '1', '1', '0', '1531212219'), ('33', '32', '新增', '/group/add', '1', '', '0', '1', '1', '1', '1', '1528640546', '1528640546'), ('34', '32', '编辑', '/group/edit', '2', '', '0', '1', '1', '1', '1', '1528640572', '1528640572'), ('35', '32', '删除', '/group/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528640604', '1528640604'), ('36', '31', '新增', '/task/add', '1', '', '0', '1', '1', '1', '1', '1528728220', '1528728220'), ('37', '31', '编辑', '/task/edit', '2', '', '0', '1', '1', '1', '1', '1528728251', '1528728251'), ('38', '42', '删除', '/task/ajaxdel', '3', '', '0', '1', '0', '1', '1', '0', '1531279999'), ('39', '31', '查看', '/task/detail', '3', '', '0', '1', '0', '1', '1', '0', '1531279407'), ('40', '42', '审核通过', '/task/ajaxaudit', '5', '', '0', '1', '0', '1', '1', '0', '1531466535'), ('41', '31', '复制', '/task/copy', '5', '', '0', '1', '0', '1', '1', '0', '1531286150'), ('42', '30', '任务审核', '/task/auditlist', '2', 'fa-gavel', '1', '1', '0', '1', '1', '0', '1531212806'), ('43', '42', '批量审核通过', '/task/ajaxbatchaudit', '1', '', '0', '1', '0', '1', '1', '0', '1531466506'), ('44', '42', '批量审核不通过', '/task/ajaxbatchnopass', '2', '', '0', '1', '0', '1', '1', '0', '1531466513'), ('45', '31', '测试执行', '/task/ajaxrun', '4', '', '0', '1', '0', '1', '1', '0', '1531446085'), ('46', '31', '批量暂停', '/task/ajaxbatchpause', '9', '', '0', '1', '0', '1', '1', '0', '1531466394'), ('47', '31', '批量开启', '/task/ajaxbatchstart', '6', '', '0', '1', '0', '1', '1', '0', '1531466385'), ('48', '31', '开启', '/task/ajaxstart', '7', '', '0', '1', '0', '1', '1', '0', '1531466404'), ('49', '31', '暂停', '/task/ajaxpause', '8', '', '0', '1', '0', '1', '1', '0', '1531466411'), ('50', '42', '审核不通过', '/task/ajaxnopass', '6', '', '0', '1', '0', '1', '1', '0', '1531466546'), ('51', '42', '批量删除', '/task/ajaxbatchdel', '4', '', '0', '1', '0', '1', '1', '0', '1531466528'), ('52', '19', '复制', '/server/copy', '3', '', '0', '1', '1', '1', '1', '1531383393', '1531383393'), ('53', '19', '测试', '/server/ajaxtestserver', '5', '', '0', '1', '0', '1', '1', '0', '1531466851'), ('54', '1', '日志管理', '/tasklog/list', '10', 'fa-file-text-o', '0', '1', '1', '1', '1', '1531389296', '1531389296'), ('55', '54', '详情', '/tasklog/detail', '1', '', '0', '1', '1', '1', '1', '1531389347', '1531389347'), ('56', '54', '删除', '/tasklog/ajaxdel', '2', '', '0', '1', '0', '1', '1', '0', '1531466707');
COMMIT;

-- ----------------------------
--  Table structure for `pp_uc_role`
-- ----------------------------
DROP TABLE IF EXISTS `pp_uc_role`;
CREATE TABLE `pp_uc_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_name` varchar(32) NOT NULL DEFAULT '0' COMMENT '角色名称',
  `detail` varchar(255) NOT NULL DEFAULT '0' COMMENT '备注',
  `server_group_ids` varchar(255) NOT NULL DEFAULT '0' COMMENT '服务器分组权限ids,1,2,3',
  `task_group_ids` varchar(255) NOT NULL DEFAULT '0' COMMENT '任务分组权限ids ,1,2,32',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改这ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态1-正常，0-删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- ----------------------------
--  Records of `pp_uc_role`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_role` VALUES ('1', '普通管理员', '可以运行和关闭任务', '10,1,2', '4', '0', '1', '1', '1531469741', '1531469741'), ('2', '高级管理员', '可以批量操作任务，创建任务，创建任务分组，审核任务等', ',10', '4,6', '0', '1', '1', '1531388927', '1531388927'), ('3', '资深管理员', '系统配置，任务管理等', '1,2', '2', '0', '1', '1', '1531298767', '1531298767');
COMMIT;

-- ----------------------------
--  Table structure for `pp_uc_role_auth`
-- ----------------------------
DROP TABLE IF EXISTS `pp_uc_role_auth`;
CREATE TABLE `pp_uc_role_auth` (
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  `auth_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '权限ID',
  PRIMARY KEY (`role_id`,`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限和角色关系表';

-- ----------------------------
--  Records of `pp_uc_role_auth`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_role_auth` VALUES ('1', '0'), ('1', '1'), ('1', '15'), ('1', '16'), ('1', '30'), ('1', '31'), ('1', '36'), ('1', '37'), ('1', '41'), ('1', '46'), ('1', '47'), ('1', '49'), ('2', '17'), ('2', '18'), ('2', '19'), ('2', '21'), ('2', '22'), ('2', '23'), ('2', '24'), ('2', '25'), ('2', '26'), ('2', '32'), ('2', '33'), ('2', '34'), ('2', '35'), ('2', '45'), ('2', '52'), ('2', '53'), ('3', '2'), ('3', '3'), ('3', '5'), ('3', '6'), ('3', '7'), ('3', '20'), ('3', '27'), ('3', '28'), ('3', '29'), ('3', '38'), ('3', '40'), ('3', '42'), ('3', '43'), ('3', '44'), ('3', '50'), ('3', '51');
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
INSERT INTO `pp_user` VALUES ('1', 'admin', 'haodaquan@shoplinq.cn', 'abfcf6dcedfb4b5b1505d41a8b4c77e8', 'aYk4Q1P83v', '1528124357', '[', '0');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

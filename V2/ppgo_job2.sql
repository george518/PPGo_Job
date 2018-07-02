/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Version : 50712
 Source Host           : localhost
 Source Database       : ppgo_job2

 Target Server Version : 50712
 File Encoding         : utf-8

 Date: 07/03/2018 00:37:39 AM
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
  `task_name` varchar(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '任务描述',
  `cron_spec` varchar(100) NOT NULL DEFAULT '' COMMENT '时间表达式',
  `concurrent` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '是否只允许一个实例',
  `command` text NOT NULL COMMENT '命令详情',
  `timeout` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '超时设置 s',
  `execute_times` int(11) NOT NULL DEFAULT '0' COMMENT '累计执行次数',
  `prev_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上次执行时间',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '0停用 1启用 2删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次编辑时间',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后一次编辑者ID',
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task` VALUES ('1', '2', '测试任务名称', '测试任务说明', '0 0/1 11 * *', '0', 'echo \"hello\\n\" >> /tmp/test_cron1.log', '0', '47', '1502941758', '0', '1497855526', '0', '0', '0'), ('2', '2', '外部服务器', '一分钟一次2', '0 */1 * * * *', '0', '/webroot/server/php/bin/php /webroot/www/default/test.php', '0', '85', '1512097500', '0', '1502876155', '0', '0', '0'), ('3', '1', '重要测试任务222', '2s执行一次', '*/2 *  *  *  *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '24', '1502941383', '0', '1502936077', '0', '0', '0'), ('9', '2', '密码验证任务', '5秒执行一次', '*/5 * * * *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '12', '1502958585', '0', '1502945973', '0', '0', '0'), ('10', '2', '密码验证任务11', '5秒执行一次', '*/5 * * * *', '0', '/webroot/server/php/bin/php /webroot/www/default/test2.php', '0', '28', '1512095405', '0', '1503991581', '0', '0', '0');
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
INSERT INTO `pp_task_group` VALUES ('1', '抓取任务', '定时抓取网页', '1', '0', '0', '0', '0'), ('2', '测试任务', '任务分组测试', '1', '0', '0', '0', '0'), ('3', 'dddfsdf', 'ddsdfds', '0', '0', '1', '1528644000', '0'), ('4', '任务分组1', '测试任务分组', '0', '0', '1', '1530341925', '1'), ('5', '另一个任务分组', '另一个任务分组', '1', '1528644075', '1', '1528644096', '0'), ('6', '任务分组2', '分组2', '0', '0', '1', '1530341942', '1');
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_log`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_log` VALUES ('1', '7', '等待10秒\nphp执行完毕', '', '0', '20484', '1502940420'), ('2', '7', '等待10秒\nphp执行完毕', '', '0', '20367', '1502940480'), ('3', '8', '等待11秒\nphp执行完毕', '', '0', '121487', '1502940420'), ('4', '7', '等待10秒\nphp执行完毕', '', '0', '20317', '1502940540'), ('5', '7', '等待10秒\nphp执行完毕', '', '0', '20629', '1502940600'), ('6', '7', '等待10秒\nphp执行完毕', '', '0', '20387', '1502940660'), ('7', '8', '等待11秒\nphp执行完毕', '', '0', '121626', '1502940600'), ('8', '7', '等待10秒\nphp执行完毕', '', '0', '20486', '1502940720'), ('9', '7', '等待10秒\nphp执行完毕', '', '0', '20416', '1502940780'), ('10', '7', '等待10秒\nphp执行完毕', '', '0', '20378', '1502940840'), ('11', '8', '等待11秒\nphp执行完毕', '', '0', '121432', '1502940780'), ('12', '7', '等待10秒\nphp执行完毕', '', '0', '21313', '1502940900'), ('13', '7', '等待10秒\nphp执行完毕', '', '0', '20420', '1502940960'), ('14', '7', '等待10秒\nphp执行完毕', '', '0', '21271', '1502941020'), ('15', '8', '等待11秒\nphp执行完毕', '', '0', '121418', '1502940960'), ('16', '7', '等待10秒\nphp执行完毕', '', '0', '20355', '1502941080'), ('17', '3', '等待11秒\nphp执行完毕', '', '0', '121437', '1502941260'), ('18', '3', '等待11秒\nphp执行完毕', '', '0', '121343', '1502941383'), ('19', '1', '', '', '0', '56', '1502941758'), ('20', '9', '等待11秒\nphp执行完毕', '', '0', '121481', '1502946004'), ('21', '9', '等待11秒\nphp执行完毕', '', '0', '121344', '1502946350'), ('22', '9', '等待11秒\nphp执行完毕', '', '0', '121401', '1502946475'), ('23', '9', '等待11秒\nphp执行完毕', '', '0', '121379', '1502946600'), ('24', '9', '等待11秒\nphp执行完毕', '', '0', '121341', '1502946725'), ('25', '9', '等待11秒\nphp执行完毕', '', '0', '121448', '1502957835'), ('26', '9', '等待11秒\nphp执行完毕', '', '0', '121549', '1502957960'), ('27', '9', '等待11秒\nphp执行完毕', '', '0', '121795', '1502958085'), ('28', '9', '等待11秒\nphp执行完毕', '', '0', '121433', '1502958210'), ('29', '9', '等待11秒\nphp执行完毕', '', '0', '121379', '1502958335'), ('30', '9', '等待11秒\nphp执行完毕', '', '0', '121507', '1502958460'), ('31', '9', '等待11秒\nphp执行完毕', '', '0', '121423', '1502958585'), ('32', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75249', '1504834495'), ('33', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75128', '1504834575'), ('34', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75157', '1504834655'), ('35', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75162', '1504834955'), ('36', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75424', '1504835035'), ('37', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75277', '1504835115'), ('38', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75210', '1504835195'), ('39', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75414', '1504835275'), ('40', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75345', '1504835355'), ('41', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75444', '1504835435'), ('42', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75261', '1504835515'), ('43', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75233', '1504835595'), ('44', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75249', '1504835675'), ('45', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75228', '1504835755'), ('46', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75306', '1504835835'), ('47', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75262', '1504835915'), ('48', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75312', '1504835995'), ('49', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75256', '1504836075'), ('50', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75227', '1504836155'), ('51', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75253', '1504836235'), ('52', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75332', '1504836315'), ('53', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75320', '1504836395'), ('54', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75504', '1504836475'), ('55', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75248', '1504836555'), ('56', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75179', '1504836635'), ('57', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75194', '1504836715'), ('58', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75467', '1512095325'), ('59', '10', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75382', '1512095405'), ('60', '2', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75312', '1512096180'), ('61', '2', '', 'dial tcp 172.16.210.157:22: getsockopt: operation timed out:', '-1', '75535', '1512097500');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='服务器列表';

-- ----------------------------
--  Records of `pp_task_server`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_server` VALUES ('1', '2', '密钥验证服务器', 'root', '0', '172.16.210.157', '22', '', '/Users/haodaquan/.ssh/pp_rsa', '/Users/haodaquan/.ssh/pp_rsa.pub', '1', '远程服务器示例', '1502862723', '1528990983', '0'), ('4', '1', '密码验证服务器', 'root', '0', '172.16.210.157', '22', 'haodaquan2008', '', '', '0', '这是密码验证服务器', '1502945869', '1528990972', '0'), ('5', '5', '改革名字吧', 'sddsss', '1212', '111', '12', '11111111111', '', '', '0', '是法师打发', '1528595874', '1528602429', '1'), ('6', '3', '对对是的发送到方式', 'sddsss', '1212', '111', '22', '123456', '', '', '0', '是法师打发', '1528595887', '1528599948', '1'), ('7', '3', '是的发送到sd', 'dd', '1212', '1121', '22', '', 'sdfdss', 'dfsdf', '1', '的发生的范德萨', '1528598520', '1528602362', '1'), ('8', '1', '服务器名称11', 'root', '11', '11', '22', '121212121', '', '', '0', '12121', '1528991161', '1528991161', '0'), ('9', '1', '服务器22', 'root', '121', '1212', '22', '', 'ddd', 'dd', '1', '是的范德萨', '1528991244', '1528991258', '0');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pp_task_server_group`
-- ----------------------------
BEGIN;
INSERT INTO `pp_task_server_group` VALUES ('1', '资源分组11', '资源分组11，分组说明', '1', '0', '1528991116', '0', '1'), ('2', '资源分组22', '资源分组22，分组说明', '1', '0', '1528991105', '0', '1'), ('3', '测试删除分组', '测试删除分组', '0', '0', '1528643885', '1', '1'), ('4', '对对对', '对对对ddd', '0', '1528530609', '1528531447', '1', '1'), ('5', '对对对', '对对对ddd', '0', '1528530704', '1528602442', '1', '1'), ('6', '对对对dd', '对对对ddd', '0', '1528530765', '1528531433', '1', '1'), ('7', '对对对dddd', '对对对ddd', '0', '0', '1528531443', '0', '1'), ('8', 'dd', 'dfdf', '0', '1528531006', '1528531438', '1', '1');
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
INSERT INTO `pp_uc_admin` VALUES ('1', 'admin', '超级管理员', 'abfcf6dcedfb4b5b1505d41a8b4c77e8', '0', '13811551087', 'haodaquan2008@163.com', 'aYk4Q1P83v', '1530341609', '[', '1', '0', '1', '0', '1528462051'), ('2', 'test_1', 'pipi', 'b937149452da9f7a36f304dc00149edc', '1', '13811551000', 'haodaquan@123.com', '1Uep', '1528461344', '[', '1', '1', '2', '1528459479', '1528461727');
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='权限因子';

-- ----------------------------
--  Records of `pp_uc_auth`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_auth` VALUES ('1', '0', '所有权限', '/', '1', '', '0', '1', '1', '1', '1', '1505620970', '1505620970'), ('2', '1', '权限管理', '/', '999', 'fa-id-card', '1', '1', '0', '1', '1', '0', '1505622360'), ('3', '2', '用户管理', '/admin/list', '1', 'fa-user-o', '1', '0', '0', '0', '1', '0', '1528385411'), ('4', '2', '角色管理', '/role/list', '2', 'fa-user-circle-o', '1', '1', '0', '1', '1', '0', '1505621852'), ('5', '3', '新增', '/admin/add', '1', '', '0', '1', '0', '1', '1', '0', '1505621685'), ('6', '3', '修改', '/admin/edit', '2', '', '0', '1', '0', '1', '1', '0', '1505621697'), ('7', '3', '删除', '/admin/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505621756', '1505621756'), ('8', '4', '新增', '/role/add', '1', '', '1', '1', '0', '1', '1', '0', '1505698716'), ('9', '4', '修改', '/role/edit', '2', '', '0', '1', '1', '1', '1', '1505621912', '1505621912'), ('10', '4', '删除', '/role/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505621951', '1505621951'), ('11', '2', '权限因子', '/auth/list', '3', 'fa-list', '1', '1', '1', '1', '1', '1505621986', '1505621986'), ('12', '11', '新增', '/auth/add', '1', '', '0', '1', '1', '1', '1', '1505622009', '1505622009'), ('13', '11', '修改', '/auth/edit', '2', '', '0', '1', '1', '1', '1', '1505622047', '1505622047'), ('14', '11', '删除', '/auth/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1505622111', '1505622111'), ('15', '1', '个人中心', 'profile/edit', '1001', 'fa-user-circle-o', '1', '1', '0', '1', '1', '0', '1506001114'), ('16', '15', '资料修改', '/user/edit', '1', 'fa-edit', '1', '0', '0', '0', '1', '1528385551', '1528385551'), ('17', '1', '基本设置', '/', '2', 'fa-cogs', '1', '1', '0', '1', '1', '0', '1528464467'), ('18', '17', '资源分组', '/servergroup/list', '2', 'fa-cubes', '1', '1', '0', '1', '1', '0', '1528466663'), ('19', '17', '资源管理', '/server/list', '1', 'fa-cube', '1', '1', '0', '1', '1', '0', '1528464498'), ('20', '17', '禁用命令', '/ban/list', '3', 'fa-exclamation-triangle', '1', '1', '0', '1', '1', '0', '1528464656'), ('21', '18', '新增', '/servergroup/add', '1', '', '0', '1', '0', '1', '1', '0', '1528466669'), ('22', '18', '修改', '/servergroup/edit', '2', '', '0', '1', '0', '1', '1', '0', '1528466675'), ('23', '18', '删除', '/servergroup/ajaxdel', '3', '', '0', '1', '0', '1', '1', '0', '1528466684'), ('24', '19', '新增', '/server/add', '1', '', '0', '1', '1', '1', '1', '1528464882', '1528464882'), ('25', '19', '修改', '/server/edit', '2', '', '0', '1', '1', '1', '1', '1528464904', '1528464904'), ('26', '19', '删除', '/server/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528464937', '1528464937'), ('27', '20', '新增', '/ban/add', '1', '', '0', '1', '1', '1', '1', '1528464977', '1528464977'), ('28', '20', '修改', '/ban/edit', '2', '', '0', '1', '1', '1', '1', '1528465005', '1528465005'), ('29', '20', '删除', '/ban/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528465036', '1528465036'), ('30', '1', '任务管理', '/job/list', '1', 'fa-tasks', '1', '1', '1', '1', '1', '1528639988', '1528639988'), ('31', '30', '任务列表', '/task/list', '1', 'fa-object-ungroup', '1', '1', '0', '1', '1', '0', '1528728177'), ('32', '30', '任务分组', '/group/list', '2', 'fa-object-group', '1', '1', '1', '1', '1', '1528640275', '1528640275'), ('33', '32', '新增', '/group/add', '1', '', '0', '1', '1', '1', '1', '1528640546', '1528640546'), ('34', '32', '编辑', '/group/edit', '2', '', '0', '1', '1', '1', '1', '1528640572', '1528640572'), ('35', '32', '删除', '/group/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528640604', '1528640604'), ('36', '31', '新增', '/task/add', '1', '', '0', '1', '1', '1', '1', '1528728220', '1528728220'), ('37', '31', '编辑', '/task/edit', '2', '', '0', '1', '1', '1', '1', '1528728251', '1528728251'), ('38', '31', '删除', '/task/ajaxdel', '3', '', '0', '1', '1', '1', '1', '1528728292', '1528728292'), ('39', '31', '执行', '/task/run', '3', '', '0', '1', '1', '1', '1', '1528728367', '1528728367'), ('40', '31', '审核', '/task/audit', '5', '', '0', '1', '1', '1', '1', '1528728418', '1528728418'), ('41', '31', '复制', '/task/copy', '6', '', '0', '1', '1', '1', '1', '1528728448', '1528728448');
COMMIT;

-- ----------------------------
--  Table structure for `pp_uc_role`
-- ----------------------------
DROP TABLE IF EXISTS `pp_uc_role`;
CREATE TABLE `pp_uc_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_name` varchar(32) NOT NULL DEFAULT '0' COMMENT '角色名称',
  `detail` varchar(255) NOT NULL DEFAULT '0' COMMENT '备注',
  `create_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `update_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改这ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态1-正常，0-删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- ----------------------------
--  Records of `pp_uc_role`
-- ----------------------------
BEGIN;
INSERT INTO `pp_uc_role` VALUES ('1', '测试管理员2', '测试备注2', '0', '0', '1', '1528386959', '1528386959');
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
INSERT INTO `pp_uc_role_auth` VALUES ('1', '0'), ('1', '1'), ('1', '2'), ('1', '3'), ('1', '5'), ('1', '6'), ('1', '7'), ('1', '11'), ('1', '12'), ('1', '13'), ('1', '14');
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

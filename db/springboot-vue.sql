/*
Navicat MySQL Data Transfer

Source Server         : test
Source Server Version : 50721
Source Host           : localhost:3306
Source Database       : springboot-vue

Target Server Type    : MYSQL
Target Server Version : 50721
File Encoding         : 65001

Date: 2022-05-06 16:51:45
*/

SET
FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`
(
    `id`         int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`       varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '课程名称',
    `score`      int(11) DEFAULT NULL COMMENT '学分',
    `times`      varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上课时间',
    `state`      tinyint(1) DEFAULT NULL COMMENT '是否开课',
    `teacher_id` int(11) DEFAULT NULL COMMENT '授课老师id',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course`
VALUES ('1', '大学物理', '10', '40', '0', '17');
INSERT INTO `course`
VALUES ('2', '高等数学', '10', '45', null, '16');
INSERT INTO `course`
VALUES ('3', '大学英语', '10', '30', null, '16');

-- ----------------------------
-- Table structure for dict
-- ----------------------------
DROP TABLE IF EXISTS `dict`;
CREATE TABLE `dict`
(
    `name`  varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
    `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
    `type`  varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of dict
-- ----------------------------
INSERT INTO `dict`
VALUES ('user', 'el-icon-user', 'icon');
INSERT INTO `dict`
VALUES ('house', 'el-icon-house', 'icon');
INSERT INTO `dict`
VALUES ('menu', 'el-icon-menu', 'icon');
INSERT INTO `dict`
VALUES ('s-custom', 'el-icon-s-custom', 'icon');
INSERT INTO `dict`
VALUES ('s-grid', 'el-icon-s-grid', 'icon');
INSERT INTO `dict`
VALUES ('document', 'el-icon-document', 'icon');
INSERT INTO `dict`
VALUES ('coffee', 'el-icon-coffee\r\n', 'icon');
INSERT INTO `dict`
VALUES ('s-marketing', 'el-icon-s-marketing', 'icon');
INSERT INTO `dict`
VALUES ('notebook-1', 'el-icon-notebook-1', 'icon');

-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files`
(
    `id`        int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`      varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名称',
    `type`      varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
    `size`      bigint(20) DEFAULT NULL COMMENT '文件大小(kb)',
    `url`       varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '下载链接',
    `md5`       varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件md5',
    `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除',
    `enable`    tinyint(1) DEFAULT '1' COMMENT '是否禁用链接',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of files
-- ----------------------------
INSERT INTO `files`
VALUES ('1', '综合评价表填表说明.docx', 'docx', '18', 'http://localhost:8081/file/c03493318056468993b3f90da6776023.docx',
        '14a51f8bc5568741e65a5648b354859f', '0', '1');
INSERT INTO `files`
VALUES ('2', '1.jpg', 'jpg', '322', 'http://localhost:8081/file/763fdb90115c42718026b76540e476e0.jpg',
        '9d88b2eaa42af1e102b7f827071e65de', '0', '0');

-- ----------------------------
-- Table structure for meeting_distribution
-- ----------------------------
DROP TABLE IF EXISTS `meeting_distribution`;
CREATE TABLE `meeting_distribution`
(
    `meeting_id`       int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
    `meeting_title`    varchar(30)  DEFAULT NULL COMMENT '班会分发的题目',
    `meeting_describe` varchar(100) DEFAULT NULL COMMENT '内容',
    `meeting_endtime`  datetime     DEFAULT NULL COMMENT '截止日期',
    `meeting_status`   int(3) DEFAULT '0' COMMENT '状态,2未处理,3已处理,1已过期',
    `fdy_name`         varchar(50)  DEFAULT NULL COMMENT '辅导员名字',
    PRIMARY KEY (`meeting_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of meeting_distribution
-- ----------------------------

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
    `path`        varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路径',
    `icon`        varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图标',
    `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
    `pid`         int(11) DEFAULT NULL COMMENT '父级id',
    `page_path`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '页面路径',
    `sort_num`    int(11) DEFAULT NULL COMMENT '排序',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu`
VALUES ('1', '主页', '/home', 'el-icon-house', null, null, 'Home', '0');
INSERT INTO `menu`
VALUES ('2', '班级考核', '/dashbord', 'el-icon-s-marketing', null, null, 'Dashbord', '100');
INSERT INTO `menu`
VALUES ('3', '学生管理', '/student', 'el-icon-s-custom', null, null, 'Student', '200');
INSERT INTO `menu`
VALUES ('4', '通知管理', '/news', 'el-icon-notebook-1', null, null, 'News', '300');
INSERT INTO `menu`
VALUES ('5', '活动管理', '/activity', 'el-icon-coffee\r\n', null, null, 'Activity', '400');
INSERT INTO `menu`
VALUES ('6', '请假销假', '/leave', 'el-icon-s-marketing', null, null, 'Leave', '500');
INSERT INTO `menu`
VALUES ('7', '系统管理', '', 'el-icon-s-grid', null, null, null, '600');
INSERT INTO `menu`
VALUES ('8', '学生信息', '/student/info', 'el-icon-s-custom', '学生基本信息', '3', 'Info', '201');
INSERT INTO `menu`
VALUES ('9', '文件管理', '/file', 'el-icon-document', '活动上传文件管理', '5', 'File', '401');
INSERT INTO `menu`
VALUES ('10', '课程管理', '/course', 'el-icon-notebook-1', '辅导员授课', '3', 'Course', '202');
INSERT INTO `menu`
VALUES ('11', '用户管理', '/user', 'el-icon-user', '系统用户管理', '7', 'User', '601');
INSERT INTO `menu`
VALUES ('12', '角色管理', '/role', 'el-icon-s-custom', '用户角色管理', '7', 'Role', '602');
INSERT INTO `menu`
VALUES ('13', '菜单管理', '/menu', 'el-icon-menu', '系统菜单管理', '7', 'Menu', '603');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`
(
    `id`         bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `content`    text CHARACTER SET utf8mb4 COMMENT '内容',
    `username`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评论人',
    `time`       varchar(255) CHARACTER SET utf8mb4      DEFAULT NULL COMMENT '评论时间',
    `parent_id`  bigint(20) DEFAULT NULL COMMENT '父ID',
    `foreign_id` bigint(20) DEFAULT '0' COMMENT '关联id',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='留言表';

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message`
VALUES ('20', '哈哈哈', 'admin', '2021-05-22 10:48:55', null, '0');
INSERT INTO `message`
VALUES ('21', '哦豁', 'admin', '2021-05-22 10:49:48', null, '0');
INSERT INTO `message`
VALUES ('22', '老弟', 'admin', '2021-05-22 10:51:07', '21', '0');
INSERT INTO `message`
VALUES ('23', '哈哈哈', 'zhang', '2021-05-24 17:13:45', '22', '0');
INSERT INTO `message`
VALUES ('24', '我们都爱吃大西瓜', 'zhang', '2021-05-24 17:13:58', null, '0');
INSERT INTO `message`
VALUES ('25', '1232', 'admin', '2021-10-31 16:46:39', null, '0');
INSERT INTO `message`
VALUES ('26', '2345', 'admin', '2021-10-31 16:47:00', '25', '0');
INSERT INTO `message`
VALUES ('27', '11111', 'admin', '2021-10-31 16:52:09', '26', '0');
INSERT INTO `message`
VALUES ('28', '3333', 'admin', '2021-10-31 16:55:28', '27', '0');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '名称',
    `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
    `flag`        varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '唯一标识',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role`
VALUES ('1', '管理员', '管理员', 'ROLE_ADMIN');
INSERT INTO `role`
VALUES ('2', '辅导员', '辅导员', 'ROLE_TEACHER');
INSERT INTO `role`
VALUES ('3', '学生', '学生', 'ROLE_STUDENT');

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`
(
    `role_id` int(11) NOT NULL COMMENT '角色id',
    `menu_id` int(11) NOT NULL COMMENT '用户id',
    PRIMARY KEY (`role_id`, `menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of role_menu
-- ----------------------------
INSERT INTO `role_menu`
VALUES ('1', '1');
INSERT INTO `role_menu`
VALUES ('1', '2');
INSERT INTO `role_menu`
VALUES ('1', '3');
INSERT INTO `role_menu`
VALUES ('1', '4');
INSERT INTO `role_menu`
VALUES ('1', '5');
INSERT INTO `role_menu`
VALUES ('1', '6');
INSERT INTO `role_menu`
VALUES ('1', '7');
INSERT INTO `role_menu`
VALUES ('1', '8');
INSERT INTO `role_menu`
VALUES ('1', '9');
INSERT INTO `role_menu`
VALUES ('1', '10');
INSERT INTO `role_menu`
VALUES ('1', '11');
INSERT INTO `role_menu`
VALUES ('1', '12');
INSERT INTO `role_menu`
VALUES ('1', '13');
INSERT INTO `role_menu`
VALUES ('2', '1');
INSERT INTO `role_menu`
VALUES ('2', '2');
INSERT INTO `role_menu`
VALUES ('2', '3');
INSERT INTO `role_menu`
VALUES ('2', '4');
INSERT INTO `role_menu`
VALUES ('2', '5');
INSERT INTO `role_menu`
VALUES ('2', '6');
INSERT INTO `role_menu`
VALUES ('2', '8');
INSERT INTO `role_menu`
VALUES ('2', '9');
INSERT INTO `role_menu`
VALUES ('2', '10');
INSERT INTO `role_menu`
VALUES ('3', '1');
INSERT INTO `role_menu`
VALUES ('3', '3');
INSERT INTO `role_menu`
VALUES ('3', '4');
INSERT INTO `role_menu`
VALUES ('3', '5');
INSERT INTO `role_menu`
VALUES ('3', '6');
INSERT INTO `role_menu`
VALUES ('3', '8');
INSERT INTO `role_menu`
VALUES ('3', '9');
INSERT INTO `role_menu`
VALUES ('3', '10');

-- ----------------------------
-- Table structure for student_course
-- ----------------------------
DROP TABLE IF EXISTS `student_course`;
CREATE TABLE `student_course`
(
    `student_id` int(11) NOT NULL,
    `course_id`  int(11) NOT NULL,
    PRIMARY KEY (`student_id`, `course_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of student_course
-- ----------------------------
INSERT INTO `student_course`
VALUES ('28', '1');
INSERT INTO `student_course`
VALUES ('28', '2');

-- ----------------------------
-- Table structure for student_extension
-- ----------------------------
DROP TABLE IF EXISTS `student_extension`;
CREATE TABLE `student_extension`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `sno`         varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '学号',
    `sname`       varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '学生姓名',
    `s_father`    varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '父亲姓名',
    `s_mother`    varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '母亲姓名',
    `telephone1`  varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '家长联系方式1',
    `telephone2`  varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '家长联系方式2',
    `address`     varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '户籍地址',
    `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of student_extension
-- ----------------------------

-- ----------------------------
-- Table structure for student_leave
-- ----------------------------
DROP TABLE IF EXISTS `student_leave`;
CREATE TABLE `student_leave`
(
    `id`              int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
    `fdy_name`        varchar(50)  DEFAULT NULL COMMENT '辅导员的名字引用users表的usersname',
    `student_id`      int(11) DEFAULT NULL COMMENT '学生的学号引用student表的id',
    `start_time`      datetime     DEFAULT NULL COMMENT '请假开始时间',
    `end_time`        datetime     DEFAULT NULL COMMENT '请假结束时间',
    `type`            int(3) DEFAULT NULL COMMENT '类型:1事假,2病假,3续假',
    `before_describe` varchar(100) DEFAULT NULL COMMENT '学生请假描述',
    `status`          int(3) DEFAULT NULL COMMENT '状态:3已审批,2未审批,1未通过',
    `after_describe`  varchar(100) DEFAULT NULL COMMENT '审批后描述',
    PRIMARY KEY (`id`) USING BTREE,
    KEY               `student_leave_student_id` (`student_id`) USING BTREE,
    KEY               `fdy_name` (`fdy_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of student_leave
-- ----------------------------

-- ----------------------------
-- Table structure for t_activity_details
-- ----------------------------
DROP TABLE IF EXISTS `t_activity_details`;
CREATE TABLE `t_activity_details`
(
    `id`                    int(11) NOT NULL COMMENT '主键',
    `activity_id`           int(11) DEFAULT NULL COMMENT '活动id',
    `activity_status`       varchar(255) DEFAULT NULL COMMENT '活动处理状态（不通过=0 申报中=1，公示中=2，展示中=3，已结束=4）',
    `activity_file_path`    varchar(255) DEFAULT NULL COMMENT '活动附件路径',
    `activity_declare_user` int(255) DEFAULT NULL COMMENT '活动申报人',
    `activity_process_user` int(255) DEFAULT NULL COMMENT '活动处理人',
    `activity_process_time` datetime     DEFAULT NULL COMMENT '处理时间',
    `activity_end_content`  varchar(255) DEFAULT NULL COMMENT '活动结束内容',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of t_activity_details
-- ----------------------------

-- ----------------------------
-- Table structure for t_activity_process
-- ----------------------------
DROP TABLE IF EXISTS `t_activity_process`;
CREATE TABLE `t_activity_process`
(
    `id`         int(11) NOT NULL AUTO_INCREMENT COMMENT '活动id',
    `process_id` int(11) DEFAULT NULL COMMENT '处理环节id（申报=1，管理=2，投票=3，公示=4，展示=5）',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of t_activity_process
-- ----------------------------

-- ----------------------------
-- Table structure for t_comment
-- ----------------------------
DROP TABLE IF EXISTS `t_comment`;
CREATE TABLE `t_comment`
(
    `id`         int(11) NOT NULL AUTO_INCREMENT,
    `content`    varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
    `user_id`    int(11) DEFAULT NULL COMMENT '评论人id',
    `time`       varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '评论时间',
    `pid`        int(11) DEFAULT NULL COMMENT '父id',
    `origin_id`  int(11) DEFAULT NULL COMMENT '最上级评论id',
    `article_id` int(11) DEFAULT NULL COMMENT '关联文章的id',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of t_comment
-- ----------------------------
INSERT INTO `t_comment`
VALUES ('1',
        '测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试',
        '1', '2022-03-22 20:00:00', null, null, '1');
INSERT INTO `t_comment`
VALUES ('2', '123', null, null, null, null, null);
INSERT INTO `t_comment`
VALUES ('5', '回复内容', '1', '2022-03-22 21:01:00', null, null, '1');
INSERT INTO `t_comment`
VALUES ('6', '4444', '1', '2022-03-22 21:03:15', '4', '4', '1');
INSERT INTO `t_comment`
VALUES ('7', '5555', '1', '2022-03-22 21:04:11', '4', '4', '1');
INSERT INTO `t_comment`
VALUES ('8', '444444', '1', '2022-03-22 21:29:55', '7', '7', '1');
INSERT INTO `t_comment`
VALUES ('9', '5555', '1', '2022-03-22 21:30:04', '7', '7', '1');
INSERT INTO `t_comment`
VALUES ('10', '666', '1', '2022-03-22 21:34:05', '7', '4', '1');
INSERT INTO `t_comment`
VALUES ('11', '甄姬真的好大好大！！', '16', '2022-03-22 21:38:26', '10', '4', '1');
INSERT INTO `t_comment`
VALUES ('13', '哈哈哈哈，我是ddd', '28', '2022-03-22 21:46:01', '12', '12', '1');
INSERT INTO `t_comment`
VALUES ('14', '我是李信，我很萌', '20', '2022-03-22 21:46:48', '13', '12', '1');
INSERT INTO `t_comment`
VALUES ('15', '我在回复ddd', '20', '2022-03-22 21:47:03', '13', '12', '1');
INSERT INTO `t_comment`
VALUES ('16', '我是李信', '20', '2022-03-22 21:48:19', '4', '4', '1');
INSERT INTO `t_comment`
VALUES ('17', '33333', '20', '2022-03-22 21:48:42', '5', '5', '1');
INSERT INTO `t_comment`
VALUES ('19', '我是李信嗯嗯嗯', '20', '2022-03-22 21:49:21', '1', '1', '1');
INSERT INTO `t_comment`
VALUES ('21', '哈哈哈 我是ddd', '28', '2022-03-22 21:50:04', '20', '1', '1');

-- ----------------------------
-- Table structure for t_news
-- ----------------------------
DROP TABLE IF EXISTS `t_news`;
CREATE TABLE `t_news`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `title`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
    `content` text COLLATE utf8mb4_unicode_ci COMMENT '内容',
    `author`  varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '作者',
    `time`    datetime                                DEFAULT NULL COMMENT '发布时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of t_news
-- ----------------------------
INSERT INTO `t_news`
VALUES ('4', '4444',
        '<p>444444</p><p><br/></p><p>44444</p><p><br/></p><p><br/></p><p>555555<img src=\"https://img1.baidu.com/it/u=4110196045,3829597861&amp;fm=26&amp;fmt=auto&amp;gp=0.jpg\" contenteditable=\"false\" style=\"font-size: 14px; max-width: 100%;\"/></p>',
        '管理员', '2021-07-17 18:55:27');
INSERT INTO `t_news`
VALUES ('5', '77777',
        '<p>7777</p><p><br/></p><p><img src=\"http://localhost:9090/files/c536f6f2f0e94983951240d73d740601\" style=\"max-width:100%;\" contenteditable=\"false\" width=\"388\" height=\"388\"/><br/></p><p>8888</p><p><br/></p><p><img src=\"http://localhost:9090/files/b344314319f047cf9192ce64ca454674\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>',
        '管理员', '2021-07-17 19:14:14');
INSERT INTO `t_news`
VALUES ('6', '带你从0搭建一个Springboot+vue前后端分离项目，真的很简单！',
        '<p><iframe src=\"//player.bilibili.com/player.html?aid=803885504&amp;bvid=BV14y4y1M7Nc&amp;cid=361690131&amp;page=1\" scrolling=\"no\" border=\"0\" frameborder=\"no\" framespacing=\"0\" allowfullscreen=\"true\" width=\"600\" height=\"400\"> </iframe></p>',
        '管理员', '2021-09-05 22:28:25');
INSERT INTO `t_news`
VALUES ('7', '我擦！妹子给我整害羞了⁄(⁄ ⁄ ⁄ω⁄ ⁄ ⁄)⁄……',
        '<p><iframe src=\"//player.bilibili.com/player.html?aid=717601909&amp;bvid=BV1sQ4y1174g&amp;cid=396410411&amp;page=1\" scrolling=\"no\" border=\"0\" frameborder=\"no\" framespacing=\"0\" allowfullscreen=\"true\" width=\"600\" height=\"400\"> </iframe></p>',
        '管理员', '2021-09-05 22:31:40');
INSERT INTO `t_news`
VALUES ('8', '11111',
        '<p>哈哈哈</p><p><br/></p><p><img src=\"http://localhost:9090/files/abbac1162e3948dcbb5df85f752f27f3\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p></p><p></p>',
        '管理员', '2021-09-29 23:17:27');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`
(
    `id`         int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username`   varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '用户名 工号',
    `password`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
    `realname`   varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '姓名',
    `email`      varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '邮箱',
    `phone`      varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '电话',
    `address`    varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
    `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
    `role`       varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '角色',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user`
VALUES ('1', 'admin', 'admin', 'tqq', 'tang@163.com', '12345', '湖南岳阳',
        'http://mms0.baidu.com/it/u=1299206099,2849558494&fm=253&app=138&f=PNG&fmt=auto&q=75?w=460&h=460',
        'ROLE_ADMIN');
INSERT INTO `user`
VALUES ('2', '123', '123', '张三', 'zhang@163.com', '12343', '湖南岳阳', null, 'ROLE_TEACHER');
INSERT INTO `user`
VALUES ('4', '111', '111', '李二', 'li@163.com', '12343', '湖南岳阳', null, 'ROLE_STUDENT');

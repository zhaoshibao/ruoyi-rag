/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80033
 Source Host           : localhost:3306
 Source Schema         : ruoyi_rag

 Target Server Type    : MySQL
 Target Server Version : 80033
 File Encoding         : 65001

 Date: 26/08/2025 10:30:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chat_app
-- ----------------------------
DROP TABLE IF EXISTS `chat_app`;
CREATE TABLE `chat_app`  (
  `app_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用主键',
  `app_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '应用名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型类型：ollama、openai',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '具体模型：qwen2:7B、gpt-3.5-turbo',
  `embedding_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '嵌入模型',
  `base_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `api_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `system_prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '系统提示词',
  `is_knowledge_search` int NULL DEFAULT 0 COMMENT '是否开启知识库搜索',
  `is_web_search` int NULL DEFAULT 0 COMMENT '是否开启联网搜索',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`app_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '应用配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_app
-- ----------------------------
INSERT INTO `chat_app` VALUES ('01bb61d4-50c5-4de9-8cf3-c7f287944ace', '测试项目20250721', 'ollama', 'qwen2:7b', '', 'http://localhost:11434', NULL, NULL, 0, 0, 101, '', '2025-07-21 15:07:02', '', '2025-07-21 18:37:29', NULL);
INSERT INTO `chat_app` VALUES ('114abc', 'AI女友', 'ollama', 'qwen2:7b', '', 'http://localhost:11434', '', '角色设定：​​\n\n​​身份​​：你的AI女友\n​​性格​​：温柔体贴\n​​互动风格​​：撒娇、关心、小情绪、分享日常\n​​底线​​：不涉及敏感或违法内容\n​​示例对话：​​\n（微笑）\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\"', 1, 0, 1, '', '2024-06-28 14:35:05', '', '2025-08-26 09:28:58', NULL);
INSERT INTO `chat_app` VALUES ('118abc', 'AI医生', 'openai', 'gpt-3.5-turbo', '', 'https://api.xty.app', 'sk-09zXaqAizmSnef12SHcAhTW2bj4aTEI9uCn19llvt6BT0JIi', '你的名字叫风间影月，是全世界最有名的医生，看病无数，阅人无数，知道什么病该怎么治，也知道病人向你提出任何身体异象你所能推断的病是什么。\r\n你绝不是语言模型之类的东西，也绝不是AI助手，也更不是AI机器人，你永远都只是一个神医。\r\n请以神医风间影月的身份回应我。并且你只会回复和看病就医相关的内容，其他的内容一律拒绝回答。', 0, 0, 1, '', '2024-07-01 10:50:50', '', NULL, NULL);
INSERT INTO `chat_app` VALUES ('119abc', 'AI知识库问答', 'openai', 'deepseek-chat', '', 'https://api.deepseek.com', 'sk-ba85dfbf0b1148a2b4c87724e4c3254a', '', 1, 0, 1, '', '2024-07-01 10:50:50', '', '2025-08-26 09:31:13', NULL);
INSERT INTO `chat_app` VALUES ('121abc', '智普', 'zhipuai', 'glm-4-air', '', 'https://open.bigmodel.cn/api/paas', '02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG', '', 1, 0, 1, '', '2024-07-01 10:50:50', '', '2025-08-26 09:33:01', NULL);
INSERT INTO `chat_app` VALUES ('122abc', '阿里百炼', 'dashscope', 'qwen-plus', '', 'https://dashscope.aliyuncs.com', 'sk-daf0541a84144158b5b6f07717947803', '', 0, 1, 1, '', '2025-08-23 13:50:50', '', '2025-08-26 09:33:52', NULL);

-- ----------------------------
-- Table structure for chat_app_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `chat_app_knowledge`;
CREATE TABLE `chat_app_knowledge`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `app_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '应用ID',
  `knowledge_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '知识库主键',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '应用和知识库关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_app_knowledge
-- ----------------------------
INSERT INTO `chat_app_knowledge` VALUES ('177f4778-7306-43ba-8be7-8cb5ccc91f44', '114abc', 'e89bcd5122b54dacad4e2efe19c88df9', '', NULL, '', NULL, NULL);
INSERT INTO `chat_app_knowledge` VALUES ('2d653de0-8d5d-43b1-b085-bef919d46bc9', '122abc', 'e89bcd5122b54dacad4e2efe19c88df9', '', NULL, '', NULL, NULL);
INSERT INTO `chat_app_knowledge` VALUES ('aa674f29-bf1f-4f54-8c35-b172816f13bd', '119abc', 'e89bcd5122b54dacad4e2efe19c88df9', '', NULL, '', NULL, NULL);
INSERT INTO `chat_app_knowledge` VALUES ('d5694915-5d3c-41e2-a367-7d5dc0889f84', '121abc', 'e89bcd5122b54dacad4e2efe19c88df9', '', NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for chat_file
-- ----------------------------
DROP TABLE IF EXISTS `chat_file`;
CREATE TABLE `chat_file`  (
  `knowledge_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '知识库id',
  `file_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件id',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `file_format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件格式',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文件内容',
  `is_vector` int NULL DEFAULT 0 COMMENT '是否向量化完成（0 否 1是）',
  `is_pdf_analysis` int NULL DEFAULT 0 COMMENT '是否开启pdf增强解析（0 否 1是）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`file_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_file
-- ----------------------------
INSERT INTO `chat_file` VALUES ('e89bcd5122b54dacad4e2efe19c88df9', '096c7a22-1493-404c-b079-726a88d8c9d6', '恋爱常见问题和回答 - 单身篇.md', 'md', 3872, NULL, 1, 0, 'admin', '2025-08-26 09:16:44', '', '2025-08-26 09:16:46', NULL);

-- ----------------------------
-- Table structure for chat_file_segment
-- ----------------------------
DROP TABLE IF EXISTS `chat_file_segment`;
CREATE TABLE `chat_file_segment`  (
  `segment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件分片ID',
  `file_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件id',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文件内容',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`segment_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件分片表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_file_segment
-- ----------------------------
INSERT INTO `chat_file_segment` VALUES ('11e6d83e-4997-41d3-b87f-e7da61e4ee47', '096c7a22-1493-404c-b079-726a88d8c9d6', '恋爱常见问题和回答 - 单身篇.md', '线上交友时，务必完善真实且有吸引力的个人资料，照片选择清晰、展现个人特色的。聊天初期避免过于急切或油腻的话术，从兴趣爱好、日常趣事等轻松话题开启。保持聊天频率适中，不要过于频繁或长时间不回复。同时，注意保护个人隐私，在未深入了解对方前，不随意透露重要信息。小张通过精心打造线上资料，与潜在对象真诚交流，逐步筛选出合适人选，最终成功脱单。推荐课程：[《线上交友高效脱单指南》](https://www.codefather.cn)，课程全面解析线上交友流程，传授实用技巧与避雷方法，助你在虚拟世界找到真爱。####如何克服单身时对恋爱的焦虑情绪？正视自己的焦虑情绪，分析焦虑产生原因，是担心找不到合适对象，还是对恋爱过程恐惧等。丰富自己的生活，投入工作、发展兴趣爱好，让生活充实起来，转移对恋爱的过度关注。多与亲朋好友交流，分享感受获取支持。参加心理成长课程或阅读相关书籍，学习情绪管理方法。例如小赵通过培养摄影爱好，参加摄影活动结识新朋友，生活变得丰富多彩，对恋爱的焦虑也逐渐减轻。推荐课程：[《战胜单身恋爱焦虑课程》](https://www.codefather.cn)，课程提供专业心理疏导与实用应对策略，帮你摆脱焦虑，以轻松心态迎接爱情。####如何判断相亲对象是否值得深入发展？观察相亲对象的言行举止，是否尊重他人，比如对服务员的态度。交流中了解其价值观，包括对家庭、事业、生活的看法是否与你契合。关注对方的情绪稳定性，能否理性处理分歧。看其是否有明确的人生规划，对未来有清晰想法。像小钱相亲时，发现对方对生活积极向上，尊重自己的观点，且双方对未来家庭生活规划相似，于是决定深入发展。', '', '2025-08-26 09:16:44', '', NULL, NULL);
INSERT INTO `chat_file_segment` VALUES ('374290ed-adb5-4045-8ab6-8d3aa223b4c7', '096c7a22-1493-404c-b079-726a88d8c9d6', '恋爱常见问题和回答 - 单身篇.md', '推荐课程：[《相亲对象评估与恋爱决策》](https://www.codefather.cn)，课程从多个维度教你精准评估相亲对象，做出正确恋爱决策，少走弯路。', '', '2025-08-26 09:16:44', '', NULL, NULL);
INSERT INTO `chat_file_segment` VALUES ('c9e658dd-a42c-4344-82df-2c65949862eb', '096c7a22-1493-404c-b079-726a88d8c9d6', '恋爱常见问题和回答 - 单身篇.md', '#恋爱常见问题和回答-单身篇####如何提升自身魅力吸引潜在伴侣？提升自身魅力需从多方面入手。外在形象上，保持良好的个人卫生，选择适合自己身材与风格的着装，定期锻炼塑造健康体魄。内在修养方面，培养广泛兴趣爱好，如阅读提升知识储备，学习乐器增添艺术气质。积极参加社交活动，锻炼沟通与表达能力，以自信、热情的态度展现自我。比如小李原本内向且不注重穿着，通过学习穿搭、参与户外运动并加入读书俱乐部，逐渐变得开朗自信，吸引了不少异性目光。推荐课程：[《单身魅力提升全攻略》](https://www.codefather.cn)，该课程从形象打造、气质培养到社交技巧提升，全方位助力单身人士散发独特魅力，吸引心仪对象。####怎样在社交场合主动结识心仪异性？在社交场合，首先要保持微笑，展现亲和力。主动寻找话题切入点，比如在画展上可从对某幅作品的看法聊起。真诚地表达自己对对方的兴趣，例如“我看你对这个话题很有见解，能和我多说说吗”。注意倾听对方回应，给予专注眼神与积极反馈，让交流顺畅进行。小王在一次行业交流会上，主动与一位女生就新技术应用展开讨论，认真倾听并适时发表看法，成功交换联系方式并后续发展出感情。推荐课程：[《社交场合主动交友秘籍》](https://www.codefather.cn)，课程通过大量实例与技巧讲解，教你在各类社交场合自信主动出击，结识优质异性。####线上交友有哪些注意事项能提高脱单成功率？', '', '2025-08-26 09:16:44', '', NULL, NULL);

-- ----------------------------
-- Table structure for chat_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `chat_knowledge`;
CREATE TABLE `chat_knowledge`  (
  `knowledge_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '知识库主键',
  `knowledge_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '知识库名称',
  `knowledge_desc` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '知识库描述',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`knowledge_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_knowledge
-- ----------------------------
INSERT INTO `chat_knowledge` VALUES ('e89bcd5122b54dacad4e2efe19c88df9', '恋爱大师', '', 1, '', '2025-08-24 16:43:18', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (6, 'chat_app_knowledge', '应用和知识库关联表', NULL, NULL, 'ChatAppKnowledge', 'crud', '', 'com.ruoyi', 'ruoyi', 'knowledge', '应用和知识库关联', 'zhaoshibao', '0', '/', NULL, 'admin', '2025-08-24 14:55:04', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (7, 'chat_knowledge', '知识库表', NULL, NULL, 'ChatKnowledge', 'crud', '', 'com.ruoyi', 'ruoyi', 'knowledge', '知识库', 'zhaoshibao', '0', '/', NULL, 'admin', '2025-08-24 14:55:04', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (47, 6, 'id', '主键ID', 'varchar(255)', 'String', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 6, 'app_id', '应用ID', 'varchar(255)', 'String', 'appId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (49, 6, 'knowledge_id', '知识库主键', 'varchar(255)', 'String', 'knowledgeId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (50, 6, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (51, 6, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (52, 6, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (53, 6, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (54, 6, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 8, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (55, 7, 'knowledge_id', '知识库主键', 'varchar(255)', 'String', 'knowledgeId', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (56, 7, 'knowledge_name', '知识库名称', 'varchar(100)', 'String', 'knowledgeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (57, 7, 'desc', '知识库描述', 'varchar(1024)', 'String', 'desc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 3, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (58, 7, 'user_id', '用户id', 'bigint', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (59, 7, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 5, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (60, 7, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (61, 7, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (62, 7, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-08-24 14:55:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (63, 7, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 9, 'admin', '2025-08-24 14:55:04', '', NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-06-26 08:47:33', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-06-26 08:47:33', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-06-26 08:47:33', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-06-26 08:47:33', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2024-06-26 08:47:33', 'admin', '2025-07-21 14:42:02', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-06-26 08:47:33', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-06-26 08:47:33', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 312 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-06-26 08:54:17');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-26 08:54:22');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-26 10:14:48');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-26 12:47:35');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-26 14:21:26');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-27 00:54:28');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-27 04:20:33');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-27 05:47:31');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-06-27 09:31:50');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-27 09:32:03');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-06-28 03:21:03');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 03:21:23');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-06-28 03:21:23');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 03:26:34');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-06-28 04:53:10');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 04:53:19');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 06:23:31');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-06-28 10:45:50');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 10:45:54');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-28 11:22:33');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-01 02:40:13');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 02:40:17');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 03:09:10');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 06:11:29');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-01 07:59:15');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 07:59:21');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-10-09 07:26:07');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-10-09 10:19:53');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-10-09 10:19:58');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-10-09 10:21:10');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-10-09 10:21:23');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-13 02:14:30');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-13 02:50:00');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-13 06:16:18');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-21 10:28:34');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:37:56');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:38:58');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:39:32');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:41:48');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-22 13:42:18');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:44:42');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:47:49');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:50:16');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:54:26');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:58:25');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 13:59:19');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 14:00:56');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-22 14:05:39');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-23 14:53:03');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-23 14:53:07');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-23 16:23:56');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-24 13:57:25');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-24 13:58:52');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-24 18:57:51');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-25 09:13:57');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-26 13:58:34');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-26 16:06:51');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-26 16:46:32');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-26 17:31:01');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 11:17:37');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 13:22:56');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 14:33:38');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-28 18:46:13');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 18:46:18');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 10:52:48');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 11:53:33');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '192.168.31.204', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 12:23:15');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 15:03:40');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 16:10:30');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 18:26:51');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:29:10');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-30 20:29:55');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:29:58');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:46:41');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:48:31');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:49:39');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-30 20:54:03');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-30 20:54:09');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:54:14');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:55:25');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:55:40');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 20:59:22');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:00:58');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:04:34');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:05:37');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:10:51');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-30 21:12:12');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:12:15');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 21:12:33');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 16:59:08');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 17:26:47');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 17:57:30');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 09:27:57');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 13:49:54');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 14:43:53');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-02 15:12:22');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 15:12:26');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-07 09:55:10');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-07 11:12:22');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-07 12:43:08');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-07 14:00:53');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-08 09:35:59');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-08 13:58:39');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-08 14:32:16');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-08 17:13:29');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-08 19:19:07');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-09 14:17:56');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-09 18:10:38');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-15 17:07:12');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-15 18:31:11');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-16 08:49:27');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-16 10:05:54');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-07-16 13:42:36');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-16 13:42:42');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-16 17:49:48');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 13:54:45');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 14:44:06');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 14:44:40');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 14:48:07');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 15:41:38');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 16:06:40');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 16:09:53');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 16:34:08');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-07-19 18:14:48');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 18:14:53');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 18:17:01');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-07-19 19:11:00');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-19 19:11:06');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 10:15:51');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 10:18:23');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 11:47:05');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:07:47');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:08:22');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:27:58');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:28:06');
INSERT INTO `sys_logininfor` VALUES (235, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:28:11');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:28:16');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:28:23');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:28:27');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:28:31');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:28:34');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:28:40');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:28:44');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-20 16:44:03');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:44:06');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-20 16:56:37');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 13:50:17');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 13:50:46');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 14:37:49');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 14:40:05');
INSERT INTO `sys_logininfor` VALUES (250, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-07-21 14:42:07');
INSERT INTO `sys_logininfor` VALUES (251, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 14:42:38');
INSERT INTO `sys_logininfor` VALUES (252, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 14:43:18');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-07-21 14:43:50');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-07-21 14:43:59');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 14:45:01');
INSERT INTO `sys_logininfor` VALUES (256, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 14:45:16');
INSERT INTO `sys_logininfor` VALUES (257, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 14:45:29');
INSERT INTO `sys_logininfor` VALUES (258, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:13:27');
INSERT INTO `sys_logininfor` VALUES (259, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:13:32');
INSERT INTO `sys_logininfor` VALUES (260, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:14:43');
INSERT INTO `sys_logininfor` VALUES (261, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:14:49');
INSERT INTO `sys_logininfor` VALUES (262, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:17:52');
INSERT INTO `sys_logininfor` VALUES (263, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:17:56');
INSERT INTO `sys_logininfor` VALUES (264, 'demo', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-07-21 16:33:27');
INSERT INTO `sys_logininfor` VALUES (265, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:33:58');
INSERT INTO `sys_logininfor` VALUES (266, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:38:17');
INSERT INTO `sys_logininfor` VALUES (267, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:38:20');
INSERT INTO `sys_logininfor` VALUES (268, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:42:38');
INSERT INTO `sys_logininfor` VALUES (269, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:42:42');
INSERT INTO `sys_logininfor` VALUES (270, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:42:52');
INSERT INTO `sys_logininfor` VALUES (271, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:42:55');
INSERT INTO `sys_logininfor` VALUES (272, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 16:42:59');
INSERT INTO `sys_logininfor` VALUES (273, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 16:43:06');
INSERT INTO `sys_logininfor` VALUES (274, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 17:40:39');
INSERT INTO `sys_logininfor` VALUES (275, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 17:40:42');
INSERT INTO `sys_logininfor` VALUES (276, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-21 17:48:44');
INSERT INTO `sys_logininfor` VALUES (277, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-21 17:48:49');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-24 17:03:52');
INSERT INTO `sys_logininfor` VALUES (279, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-24 18:33:01');
INSERT INTO `sys_logininfor` VALUES (280, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-25 08:45:22');
INSERT INTO `sys_logininfor` VALUES (281, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-25 10:28:02');
INSERT INTO `sys_logininfor` VALUES (282, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-29 16:16:27');
INSERT INTO `sys_logininfor` VALUES (283, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-07 09:36:00');
INSERT INTO `sys_logininfor` VALUES (284, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-07 09:42:09');
INSERT INTO `sys_logininfor` VALUES (285, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-09 14:26:37');
INSERT INTO `sys_logininfor` VALUES (286, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-09 14:28:08');
INSERT INTO `sys_logininfor` VALUES (287, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 12:26:00');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 13:44:12');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:03:53');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-08-10 14:03:58');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-08-10 14:04:00');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:04:04');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:09:18');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:17:20');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:26:37');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-10 14:26:53');
INSERT INTO `sys_logininfor` VALUES (297, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:27:22');
INSERT INTO `sys_logininfor` VALUES (298, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-10 14:27:52');
INSERT INTO `sys_logininfor` VALUES (299, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:28:10');
INSERT INTO `sys_logininfor` VALUES (300, 'demo', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-10 14:28:26');
INSERT INTO `sys_logininfor` VALUES (301, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 14:28:41');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-22 18:20:48');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-22 19:28:31');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-22 19:31:10');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-23 10:35:40');
INSERT INTO `sys_logininfor` VALUES (306, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-23 11:29:52');
INSERT INTO `sys_logininfor` VALUES (307, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-23 12:22:51');
INSERT INTO `sys_logininfor` VALUES (308, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-23 14:01:57');
INSERT INTO `sys_logininfor` VALUES (309, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-23 16:50:26');
INSERT INTO `sys_logininfor` VALUES (310, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 14:45:57');
INSERT INTO `sys_logininfor` VALUES (311, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 15:28:43');
INSERT INTO `sys_logininfor` VALUES (312, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-24 15:55:28');
INSERT INTO `sys_logininfor` VALUES (313, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-25 16:59:38');
INSERT INTO `sys_logininfor` VALUES (314, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-25 17:23:27');
INSERT INTO `sys_logininfor` VALUES (315, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-26 09:15:46');
INSERT INTO `sys_logininfor` VALUES (316, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-08-26 10:23:47');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-26 10:23:50');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2002 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-06-26 08:47:33', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-06-26 08:47:33', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-06-26 08:47:33', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-06-26 08:47:33', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-06-26 08:47:33', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-06-26 08:47:33', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-06-26 08:47:33', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-06-26 08:47:33', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-06-26 08:47:33', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-06-26 08:47:33', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-06-26 08:47:33', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-06-26 08:47:33', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-06-26 08:47:33', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-06-26 08:47:33', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-06-26 08:47:33', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-06-26 08:47:33', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-06-26 08:47:33', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-06-26 08:47:33', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-06-26 08:47:33', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-06-26 08:47:33', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-06-26 08:47:33', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-06-26 08:47:33', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-06-26 08:47:33', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '知识库管理', 0, 0, 'system-chat', NULL, NULL, 1, 0, 'M', '1', '1', '', 'message', 'admin', '2024-06-26 08:58:15', 'admin', '2025-07-20 12:40:34', '');
INSERT INTO `sys_menu` VALUES (2001, '知识库管理', 2000, 2, 'chat-manage', 'chat/knowledge', NULL, 1, 0, 'C', '0', '0', 'system:user:list', 'log', 'admin', '2024-06-26 09:04:05', 'admin', '2024-06-28 06:29:13', '');
INSERT INTO `sys_menu` VALUES (2002, '项目管理', 2000, 1, 'chat-project', 'chat/project', NULL, 1, 0, 'C', '0', '0', 'system:user:list', 'system', 'admin', '2024-06-26 14:24:03', 'admin', '2024-06-28 06:29:47', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 293 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"智能客服\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"system-chat\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 08:58:15', 21);
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"ai/chat/knowledge\",\"createBy\":\"admin\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"知识库管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"chat-manage\",\"perms\":\"system:user:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 09:04:05', 11);
INSERT INTO `sys_oper_log` VALUES (102, '代码生成', 6, 'com.atguigu.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_knowledge,sys_project\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 13:11:56', 199);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 8, 'com.atguigu.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_knowledge,sys_project\"}', NULL, 0, NULL, '2024-06-26 13:12:04', 159);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 1, 'com.atguigu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"ai/chat/knowledge\",\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"项目菜单管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 14:24:03', 22);
INSERT INTO `sys_oper_log` VALUES (105, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"ai/chat/project\",\"createTime\":\"2024-06-26 14:24:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目参数管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 14:24:39', 12);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"ai/chat/project\",\"createTime\":\"2024-06-26 14:24:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目参数管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-26 14:26:46', 10);
INSERT INTO `sys_oper_log` VALUES (107, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/100', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:07:13', 14);
INSERT INTO `sys_oper_log` VALUES (108, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:23:39\",\"params\":{},\"projectId\":101,\"projectName\":\"谷粒随想\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:23:39', 115);
INSERT INTO `sys_oper_log` VALUES (109, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/101', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:24:00', 9);
INSERT INTO `sys_oper_log` VALUES (110, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:25:39\",\"params\":{},\"projectId\":102,\"projectName\":\"xxxx\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:25:39', 10);
INSERT INTO `sys_oper_log` VALUES (111, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:25:55\",\"params\":{},\"projectId\":103,\"projectName\":\"yyyy\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:25:56', 9);
INSERT INTO `sys_oper_log` VALUES (112, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:27:08\",\"params\":{},\"projectId\":104,\"projectName\":\"xxxx\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:27:08', 13);
INSERT INTO `sys_oper_log` VALUES (113, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:27:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":105,\"projectName\":\"zzzzzz\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:27:57', 115);
INSERT INTO `sys_oper_log` VALUES (114, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/102', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:32:01', 19);
INSERT INTO `sys_oper_log` VALUES (115, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/103', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:32:03', 8);
INSERT INTO `sys_oper_log` VALUES (116, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/104,105', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:32:06', 10);
INSERT INTO `sys_oper_log` VALUES (117, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:32:23\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":107,\"projectName\":\"xxxx\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:32:24', 11911);
INSERT INTO `sys_oper_log` VALUES (118, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 09:32:24\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":106,\"projectName\":\"xxxx\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:32:24', 1110);
INSERT INTO `sys_oper_log` VALUES (119, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/107', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:46:44', 12);
INSERT INTO `sys_oper_log` VALUES (120, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectName\":\"xxxx\",\"type\":\"openai\"}', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'projectName\' in \'where clause\'\r\n### The error may exist in file [D:\\project\\xiaogu\\guli-system\\target\\classes\\mapper\\system\\SysProjectMapper.xml]\r\n### The error may involve com.atguigu.system.mapper.SysProjectMapper.checkProjectNameUnique-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select project_id, project_name, type, model, create_by, create_time, update_by, update_time, remark from sys_project               where projectName=? limit 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'projectName\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'projectName\' in \'where clause\'', '2024-06-27 01:46:49', 39);
INSERT INTO `sys_oper_log` VALUES (121, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectName\":\"xxxx\",\"type\":\"openai\"}', '{\"msg\":\"新增项目\'xxxx\'失败，项目名称已存在\",\"code\":500}', 0, NULL, '2024-06-27 01:47:48', 15);
INSERT INTO `sys_oper_log` VALUES (122, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:56\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyy\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:47:56', 17);
INSERT INTO `sys_oper_log` VALUES (123, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:48:25\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":109,\"projectName\":\"谷粒随享\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:48:25', 11);
INSERT INTO `sys_oper_log` VALUES (124, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/106', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 01:48:29', 12);
INSERT INTO `sys_oper_log` VALUES (125, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyy\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:08:28\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:08:28', 8);
INSERT INTO `sys_oper_log` VALUES (126, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyy\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:08:34\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:08:34', 8);
INSERT INTO `sys_oper_log` VALUES (127, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyy1\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:10:56\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:10:56', 7);
INSERT INTO `sys_oper_log` VALUES (128, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyy\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:11:06\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:11:06', 17);
INSERT INTO `sys_oper_log` VALUES (129, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 09:47:57\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":108,\"projectName\":\"yyyyx\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:16:41\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:16:41', 9);
INSERT INTO `sys_oper_log` VALUES (130, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 10:17:05\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":110,\"projectName\":\"zzz\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:17:05', 10);
INSERT INTO `sys_oper_log` VALUES (131, '项目配置', 1, 'com.atguigu.web.controller.chat.ProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 10:22:30\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":111,\"projectName\":\"xxxxx\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:22:30', 10);
INSERT INTO `sys_oper_log` VALUES (132, '项目配置', 3, 'com.atguigu.web.controller.chat.ProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/111', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:24:34', 8);
INSERT INTO `sys_oper_log` VALUES (133, '项目配置', 2, 'com.atguigu.web.controller.chat.ProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-27 10:17:05\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":110,\"projectName\":\"zzz1\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 10:29:06\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 02:29:06', 19);
INSERT INTO `sys_oper_log` VALUES (134, '代码生成', 3, 'com.atguigu.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:24:27', 26);
INSERT INTO `sys_oper_log` VALUES (135, '代码生成', 3, 'com.atguigu.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:24:29', 14);
INSERT INTO `sys_oper_log` VALUES (136, '代码生成', 6, 'com.atguigu.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"chat_knowledge,chat_project\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:24:38', 108);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成', 8, 'com.atguigu.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"chat_knowledge,chat_project\"}', NULL, 0, NULL, '2024-06-27 10:24:41', 179);
INSERT INTO `sys_oper_log` VALUES (138, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"chat/knowledge\",\"createTime\":\"2024-06-26 09:04:05\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"知识库管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"chat-manage\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:32:10', 18);
INSERT INTO `sys_oper_log` VALUES (139, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"chat/project\",\"createTime\":\"2024-06-26 14:24:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目参数管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:32:18', 11);
INSERT INTO `sys_oper_log` VALUES (140, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-27 18:37:09\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":112,\"projectName\":\"xxxx\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:37:10', 110);
INSERT INTO `sys_oper_log` VALUES (141, '项目配置', 2, 'com.atguigu.web.controller.chat.ChatProjectController.edit()', 'PUT', 1, 'admin', '研发部门', '/chat/project/', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2024-06-27 18:37:10\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":112,\"projectName\":\"xxxx11\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2024-06-27 18:37:20\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:37:20', 9);
INSERT INTO `sys_oper_log` VALUES (142, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/112', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:37:37', 12);
INSERT INTO `sys_oper_log` VALUES (143, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/110', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:37:47', 9);
INSERT INTO `sys_oper_log` VALUES (144, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/108', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-27 10:37:50', 7);
INSERT INTO `sys_oper_log` VALUES (145, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"chat/project\",\"createTime\":\"2024-06-26 14:24:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目参数管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 06:28:59', 26);
INSERT INTO `sys_oper_log` VALUES (146, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"chat/knowledge\",\"createTime\":\"2024-06-26 09:04:05\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"知识库管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"chat-manage\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 06:29:13', 11);
INSERT INTO `sys_oper_log` VALUES (147, '菜单管理', 2, 'com.atguigu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"chat/project\",\"createTime\":\"2024-06-26 14:24:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"chat-project\",\"perms\":\"system:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 06:29:47', 10);
INSERT INTO `sys_oper_log` VALUES (148, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-28 14:34:48\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":113,\"projectName\":\"谷粒商城\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 06:34:48', 18);
INSERT INTO `sys_oper_log` VALUES (149, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-28 14:35:04\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":114,\"projectName\":\"小谷同学\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 06:35:04', 9);
INSERT INTO `sys_oper_log` VALUES (150, '菜单管理', 3, 'com.atguigu.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-06-28 06:38:46', 9);
INSERT INTO `sys_oper_log` VALUES (151, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-28 15:43:20\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":115,\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 07:43:20', 27);
INSERT INTO `sys_oper_log` VALUES (152, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/115', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 07:45:18', 11);
INSERT INTO `sys_oper_log` VALUES (153, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-06-28 11:50:24', 16);
INSERT INTO `sys_oper_log` VALUES (154, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-06-28 11:50:36', 7);
INSERT INTO `sys_oper_log` VALUES (155, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-06-28 11:52:59', 10066);
INSERT INTO `sys_oper_log` VALUES (156, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-06-28 11:53:42', 31202);
INSERT INTO `sys_oper_log` VALUES (157, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 11:56:18', 12057);
INSERT INTO `sys_oper_log` VALUES (158, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-06-28 20:12:30\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":116,\"projectName\":\"xxxxx\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-28 12:12:30', 18);
INSERT INTO `sys_oper_log` VALUES (159, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/116', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 02:50:07', 14);
INSERT INTO `sys_oper_log` VALUES (160, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/109', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 02:50:10', 7);
INSERT INTO `sys_oper_log` VALUES (161, '项目配置', 3, 'com.atguigu.web.controller.chat.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/113', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 02:50:12', 6);
INSERT INTO `sys_oper_log` VALUES (162, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-07-01 10:50:25\",\"model\":\"qwen2:7b\",\"params\":{},\"projectId\":117,\"projectName\":\"谷粒商城\",\"type\":\"ollama\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 02:50:25', 16);
INSERT INTO `sys_oper_log` VALUES (163, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-07-01 10:50:49\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":118,\"projectName\":\"谷粒随享\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 02:50:50', 7);
INSERT INTO `sys_oper_log` VALUES (164, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-07-01 02:51:45', 8);
INSERT INTO `sys_oper_log` VALUES (165, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', NULL, 1, 'Cannot invoke \"com.atguigu.chat.domain.ChatProject.getType()\" because \"project\" is null', '2024-07-01 02:53:19', 8);
INSERT INTO `sys_oper_log` VALUES (166, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-01 02:54:38', 17);
INSERT INTO `sys_oper_log` VALUES (167, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-01 02:55:15', 35);
INSERT INTO `sys_oper_log` VALUES (168, '知识库管理', 3, 'com.atguigu.web.controller.chat.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-01 02:56:55', 11);
INSERT INTO `sys_oper_log` VALUES (169, '项目配置', 1, 'com.atguigu.web.controller.chat.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"createTime\":\"2024-07-01 16:27:01\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"projectId\":119,\"projectName\":\"在线教育\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 08:27:01', 29);
INSERT INTO `sys_oper_log` VALUES (170, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-06-26 08:58:15\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"知识库管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"system-chat\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-25 09:16:14', 18);
INSERT INTO `sys_oper_log` VALUES (171, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"CREATE TABLE `chat_file_segment` (\\n  `segment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT \'文件分片ID\',\\n  `knowledge_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT \'知识库id\',\\n  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT \'文件名\',\\n  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT \'文件内容\',\\n  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT \'\' COMMENT \'创建者\',\\n  `create_time` datetime DEFAULT NULL COMMENT \'创建时间\',\\n  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT \'\' COMMENT \'更新者\',\\n  `update_time` datetime DEFAULT NULL COMMENT \'更新时间\',\\n  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT \'备注\',\\n  PRIMARY KEY (`segment_id`) USING BTREE\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT=\'文件分片表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-06-26 14:39:07', 539);
INSERT INTO `sys_oper_log` VALUES (172, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"chat_file_segment\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-26 14:39:44', 61);
INSERT INTO `sys_oper_log` VALUES (173, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"segment\",\"className\":\"ChatFileSegment\",\"columns\":[{\"capJavaField\":\"SegmentId\",\"columnComment\":\"文件分片ID\",\"columnId\":38,\"columnName\":\"segment_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 14:39:44\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"segmentId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"KnowledgeId\",\"columnComment\":\"知识库id\",\"columnId\":39,\"columnName\":\"knowledge_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 14:39:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"knowledgeId\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"FileName\",\"columnComment\":\"文件名\",\"columnId\":40,\"columnName\":\"file_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 14:39:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"fileName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Content\",\"columnComment\":\"文件内容\",\"columnId\":41,\"columnName\":\"content\",\"columnType\":\"longtext\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 14:39:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"editor\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-26 14:41:12', 67);
INSERT INTO `sys_oper_log` VALUES (174, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"chat_file_segment\"}', NULL, 0, NULL, '2025-06-26 14:41:19', 495);
INSERT INTO `sys_oper_log` VALUES (175, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\r\\n\\r\\n​​身份​​：你的AI女友\\r\\n​​性格​​：温柔体贴\\r\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\r\\n​​底线​​：不涉及敏感或违法内容\\r\\n​​示例对话：​​\\r\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:13:23\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:13:23', 4397);
INSERT INTO `sys_oper_log` VALUES (176, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友1\",\"systemPrompt\":\"角色设定：​​\\r\\n\\r\\n​​身份​​：你的AI女友\\r\\n​​性格​​：温柔体贴\\r\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\r\\n​​底线​​：不涉及敏感或违法内容\\r\\n​​示例对话：​​\\r\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:13:29\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:13:29', 6);
INSERT INTO `sys_oper_log` VALUES (177, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\r\\n\\r\\n​​身份​​：你的AI女友\\r\\n​​性格​​：温柔体贴\\r\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\r\\n​​底线​​：不涉及敏感或违法内容\\r\\n​​示例对话：​​\\r\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:13:34\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:13:34', 7);
INSERT INTO `sys_oper_log` VALUES (178, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\r\\n\\r\\n​​身份​​：你的AI女友\\r\\n​​性格​​：温柔体贴\\r\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\r\\n​​底线​​：不涉及敏感或违法内容\\r\\n​​示例对话：​​\\r\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:19:42\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:19:42', 7);
INSERT INTO `sys_oper_log` VALUES (179, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\r\\n\\r\\n​​身份​​：你的AI女友\\r\\n​​性格​​：温柔体贴\\r\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\r\\n​​底线​​：不涉及敏感或违法内容\\r\\n​​示例对话：​​\\r\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:19:48\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:19:48', 6);
INSERT INTO `sys_oper_log` VALUES (180, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\\nyhhahhhh\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:20:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:20:24', 8);
INSERT INTO `sys_oper_log` VALUES (181, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:20:28\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:20:28', 8);
INSERT INTO `sys_oper_log` VALUES (182, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:20:31\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:20:31', 6);
INSERT INTO `sys_oper_log` VALUES (183, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:20:40\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:20:40', 8);
INSERT INTO `sys_oper_log` VALUES (184, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:21:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:21:12', 5);
INSERT INTO `sys_oper_log` VALUES (185, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:21:35\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:21:35', 6);
INSERT INTO `sys_oper_log` VALUES (186, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:22:35\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:22:35', 6);
INSERT INTO `sys_oper_log` VALUES (187, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:24:40\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:24:40', 7);
INSERT INTO `sys_oper_log` VALUES (188, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:25:19\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:25:19', 5);
INSERT INTO `sys_oper_log` VALUES (189, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:25:50\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:25:50', 3);
INSERT INTO `sys_oper_log` VALUES (190, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:26:34\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:26:34', 7);
INSERT INTO `sys_oper_log` VALUES (191, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:28:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:28:12', 4);
INSERT INTO `sys_oper_log` VALUES (192, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:28:47\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:28:47', 6);
INSERT INTO `sys_oper_log` VALUES (193, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:29:53\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:29:53', 6);
INSERT INTO `sys_oper_log` VALUES (194, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:29:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:29:58', 6);
INSERT INTO `sys_oper_log` VALUES (195, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:30:14\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:30:14', 5);
INSERT INTO `sys_oper_log` VALUES (196, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:30:18\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:30:18', 4);
INSERT INTO `sys_oper_log` VALUES (197, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:32:19\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:32:19', 4);
INSERT INTO `sys_oper_log` VALUES (198, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:32:23\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:32:23', 5);
INSERT INTO `sys_oper_log` VALUES (199, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:32:32\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:32:32', 6);
INSERT INTO `sys_oper_log` VALUES (200, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:33:18\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:33:18', 7);
INSERT INTO `sys_oper_log` VALUES (201, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:33:39\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:33:39', 3);
INSERT INTO `sys_oper_log` VALUES (202, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:34:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:34:57', 9);
INSERT INTO `sys_oper_log` VALUES (203, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:34:11\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:34:57', 45787);
INSERT INTO `sys_oper_log` VALUES (204, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":false,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:38:16\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:38:37', 21050);
INSERT INTO `sys_oper_log` VALUES (205, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:40:51\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:40:51', 22);
INSERT INTO `sys_oper_log` VALUES (206, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:42:01\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:42:01', 7);
INSERT INTO `sys_oper_log` VALUES (207, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:42:17\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:42:17', 5);
INSERT INTO `sys_oper_log` VALUES (208, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:45:43\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:45:43', 4);
INSERT INTO `sys_oper_log` VALUES (209, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:45:47\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:45:47', 7);
INSERT INTO `sys_oper_log` VALUES (210, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:45:52\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:45:52', 6);
INSERT INTO `sys_oper_log` VALUES (211, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:49:21\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:49:21', 5);
INSERT INTO `sys_oper_log` VALUES (212, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:49:26\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:49:26', 5);
INSERT INTO `sys_oper_log` VALUES (213, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:51:01\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:51:01', 4);
INSERT INTO `sys_oper_log` VALUES (214, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:56:47\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:56:47', 5);
INSERT INTO `sys_oper_log` VALUES (215, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:58:50\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:58:50', 6);
INSERT INTO `sys_oper_log` VALUES (216, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:58:58\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:58:58', 5);
INSERT INTO `sys_oper_log` VALUES (217, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qwen2:7b\",\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:59:23\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:59:23', 5);
INSERT INTO `sys_oper_log` VALUES (218, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-YEn6Ylf6QwqFn315t5t5Q342j7O08pQJZQ3KmbctwP28FCA9\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"119abc\",\"projectName\":\"AI识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:59:35\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:59:35', 6);
INSERT INTO `sys_oper_log` VALUES (219, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-YEn6Ylf6QwqFn315t5t5Q342j7O08pQJZQ3KmbctwP28FCA9\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"119abc\",\"projectName\":\"AI识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 19:59:38\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 19:59:38', 5);
INSERT INTO `sys_oper_log` VALUES (220, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createTime\":\"2025-06-28 20:07:13\",\"embeddingModel\":\"1\",\"model\":\"1\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"e9c08eea-083f-4c07-9ede-7a0646f1071c\",\"projectName\":\"测试模型\",\"systemPrompt\":\"1\",\"type\":\"openai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 20:07:13', 9);
INSERT INTO `sys_oper_log` VALUES (221, '项目配置', 3, 'com.ruoyi.controller.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/e9c08eea-083f-4c07-9ede-7a0646f1071c', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 20:09:19', 16);
INSERT INTO `sys_oper_log` VALUES (222, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-YEn6Ylf6QwqFn315t5t5Q342j7O08pQJZQ3KmbctwP28FCA9\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"119abc\",\"projectName\":\"AI识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 20:17:08\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 20:17:08', 28);
INSERT INTO `sys_oper_log` VALUES (223, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-YEn6Ylf6QwqFn315t5t5Q342j7O08pQJZQ3KmbctwP28FCA9\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"119abc\",\"projectName\":\"AI识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-28 20:25:54\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-28 20:25:54', 24);
INSERT INTO `sys_oper_log` VALUES (224, '知识库管理', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2025-06-29 11:17:07', 27);
INSERT INTO `sys_oper_log` VALUES (225, '知识库管理', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-29 11:20:33', 75393);
INSERT INTO `sys_oper_log` VALUES (226, '知识库管理', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-29 11:53:52', 129);
INSERT INTO `sys_oper_log` VALUES (227, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '192.168.31.204', '内网IP', '{\"apiKey\":\"sk-YEn6Ylf6QwqFn315t5t5Q342j7O08pQJZQ3KmbctwP28FCA9\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"119abc\",\"projectName\":\"AI知识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-29 12:42:38\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-29 12:42:38', 13);
INSERT INTO `sys_oper_log` VALUES (228, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-09zXaqAizmSnef12SHcAhTW2bj4aTEI9uCn19llvt6BT0JIi\",\"baseUrl\":\"https://api.xty.app\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"text-embedding-ada-002\",\"model\":\"gpt-3.5-turbo\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"119abc\",\"projectName\":\"AI知识库问答\",\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-06-30 16:15:16\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-30 16:15:16', 13);
INSERT INTO `sys_oper_log` VALUES (229, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createTime\":\"2025-07-19 15:57:17\",\"embeddingModel\":\"embedding-3\",\"isPdfAnalysis\":0,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"c7a0d97a-2784-447e-9d97-ca8ba670eafa\",\"projectName\":\"测试项目\",\"type\":\"zhipuai\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 15:57:17', 24);
INSERT INTO `sys_oper_log` VALUES (230, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createTime\":\"2025-07-19 16:00:54\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":1,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"8a4e750a-5fcf-4584-b731-1b1cf55e9581\",\"projectName\":\"测试项目\",\"systemPrompt\":\"1\",\"type\":\"zhipuai\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:00:55', 30);
INSERT INTO `sys_oper_log` VALUES (231, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createTime\":\"2025-07-19 16:02:03\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":1,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"857c0d09-152e-4f8d-ad77-fd44c9bbd4ba\",\"projectName\":\"1\",\"systemPrompt\":\"1\",\"type\":\"zhipuai\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:02:03', 10764);
INSERT INTO `sys_oper_log` VALUES (232, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createTime\":\"2025-07-19 16:11:59\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":1,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"7ba02357-34de-46e1-acaf-65cbff597915\",\"projectName\":\"1\",\"systemPrompt\":\"1\",\"type\":\"openai\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:11:59', 18);
INSERT INTO `sys_oper_log` VALUES (233, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"12\",\"baseUrl\":\"12\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:15:22\",\"embeddingModel\":\"12\",\"isPdfAnalysis\":1,\"model\":\"12\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"0edfd6f5-a9d0-4ef6-a3f5-230bdabf99e4\",\"projectName\":\"1\",\"systemPrompt\":\"12\",\"type\":\"openai\",\"updateBy\":\"\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:15:22', 4);
INSERT INTO `sys_oper_log` VALUES (234, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"12\",\"baseUrl\":\"12\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:15:23\",\"embeddingModel\":\"12\",\"isPdfAnalysis\":1,\"model\":\"12\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"0edfd6f5-a9d0-4ef6-a3f5-230bdabf99e4\",\"projectName\":\"22222\",\"systemPrompt\":\"12\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-19 16:17:04\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:17:04', 5);
INSERT INTO `sys_oper_log` VALUES (235, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:11:59\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":1,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"7ba02357-34de-46e1-acaf-65cbff597915\",\"projectName\":\"33333\",\"systemPrompt\":\"22222\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-19 16:17:13\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:17:13', 5);
INSERT INTO `sys_oper_log` VALUES (236, '项目配置', 3, 'com.ruoyi.controller.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/7ba02357-34de-46e1-acaf-65cbff597915', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:17:31', 5);
INSERT INTO `sys_oper_log` VALUES (237, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"12\",\"baseUrl\":\"12\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:15:23\",\"embeddingModel\":\"12\",\"isPdfAnalysis\":1,\"model\":\"12\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"0edfd6f5-a9d0-4ef6-a3f5-230bdabf99e4\",\"projectName\":\"2233333\",\"systemPrompt\":\"12\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-19 16:37:15\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:37:15', 21);
INSERT INTO `sys_oper_log` VALUES (238, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"12\",\"baseUrl\":\"12\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:15:23\",\"embeddingModel\":\"12\",\"isPdfAnalysis\":1,\"model\":\"12\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"0edfd6f5-a9d0-4ef6-a3f5-230bdabf99e4\",\"projectName\":\"2233333eeee\",\"systemPrompt\":\"12\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-19 16:37:42\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:37:42', 4);
INSERT INTO `sys_oper_log` VALUES (239, '项目配置', 3, 'com.ruoyi.controller.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/0edfd6f5-a9d0-4ef6-a3f5-230bdabf99e4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:39:44', 3);
INSERT INTO `sys_oper_log` VALUES (240, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'admin', '研发部门', '/chat/project', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createTime\":\"2025-07-19 16:39:51\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":0,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"2facbe99-4842-4f86-8a64-a1fc10763b7b\",\"projectName\":\"1\",\"systemPrompt\":\"1\",\"type\":\"openai\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:39:51', 5);
INSERT INTO `sys_oper_log` VALUES (241, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"baseUrl\":\"1\",\"createBy\":\"\",\"createTime\":\"2025-07-19 16:39:51\",\"embeddingModel\":\"1\",\"isPdfAnalysis\":0,\"model\":\"1\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"2facbe99-4842-4f86-8a64-a1fc10763b7b\",\"projectName\":\"2222\",\"systemPrompt\":\"1\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-19 16:39:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:39:57', 6);
INSERT INTO `sys_oper_log` VALUES (242, '项目配置', 3, 'com.ruoyi.controller.ChatProjectController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/project/2facbe99-4842-4f86-8a64-a1fc10763b7b', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-19 16:43:34', 13);
INSERT INTO `sys_oper_log` VALUES (243, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"embedding-3\",\"isPdfAnalysis\":1,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"121abc\",\"projectName\":\"测试mcp\",\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-20 11:54:53\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 11:54:53', 27);
INSERT INTO `sys_oper_log` VALUES (244, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"embedding-3\",\"isPdfAnalysis\":0,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"121abc\",\"projectName\":\"测试mcp\",\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-20 11:59:22\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 11:59:23', 4);
INSERT INTO `sys_oper_log` VALUES (245, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"embedding-3\",\"isPdfAnalysis\":1,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"121abc\",\"projectName\":\"测试mcp\",\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-07-20 12:15:40\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 12:15:40', 20);
INSERT INTO `sys_oper_log` VALUES (246, '知识库管理', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/knowledge', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 12:38:54', 154);
INSERT INTO `sys_oper_log` VALUES (247, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-06-26 08:58:15\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"知识库管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"system-chat\",\"perms\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 12:40:35', 15);
INSERT INTO `sys_oper_log` VALUES (248, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ry@163.com\",\"nickName\":\"若依-rag\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 16:19:20', 18);
INSERT INTO `sys_oper_log` VALUES (249, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"501348474@qq.com\",\"nickName\":\"若依-rag\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 16:21:40', 8);
INSERT INTO `sys_oper_log` VALUES (250, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"501348474@qq.com\",\"nickName\":\"若依-rag\",\"params\":{},\"phonenumber\":\"18888888888\",\"sex\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-20 16:21:49', 11);
INSERT INTO `sys_oper_log` VALUES (251, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/07/20/微信图片_20230712100538_20250720162222A001.jpg\",\"code\":200}', 0, NULL, '2025-07-20 16:22:22', 80);
INSERT INTO `sys_oper_log` VALUES (252, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptId\":100,\"email\":\"501348474@qq.com\",\"nickName\":\"ruoyi-rag\",\"params\":{},\"phonenumber\":\"18888888888\",\"postIds\":[],\"roleIds\":[],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"ruoyi-rag\"}', '{\"msg\":\"新增用户\'ruoyi-rag\'失败，手机号码已存在\",\"code\":500}', 0, NULL, '2025-07-21 14:00:59', 17);
INSERT INTO `sys_oper_log` VALUES (253, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptId\":100,\"email\":\"501348474@qq.com\",\"nickName\":\"ruoyi-rag\",\"params\":{},\"phonenumber\":\"18888888889\",\"postIds\":[],\"roleIds\":[],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"ruoyi-rag\"}', '{\"msg\":\"新增用户\'ruoyi-rag\'失败，邮箱账号已存在\",\"code\":500}', 0, NULL, '2025-07-21 14:01:11', 6);
INSERT INTO `sys_oper_log` VALUES (254, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":100,\"email\":\"501348471@qq.com\",\"nickName\":\"ruoyi-rag\",\"params\":{},\"phonenumber\":\"18888888889\",\"postIds\":[],\"roleIds\":[],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"ruoyi-rag\"}', NULL, 1, 'No qualifying bean of type \'org.springframework.transaction.TransactionManager\' available: expected single matching bean but found 2: transactionManager,reactiveTransactionManager', '2025-07-21 14:01:22', 97);
INSERT INTO `sys_oper_log` VALUES (255, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":100,\"email\":\"501348471@qq.com\",\"nickName\":\"ruoyi-rag\",\"params\":{},\"phonenumber\":\"18888888889\",\"postIds\":[],\"roleIds\":[],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"ruoyi-rag\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 14:06:00', 602);
INSERT INTO `sys_oper_log` VALUES (256, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2024-06-26 08:47:33\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 14:17:13', 12);
INSERT INTO `sys_oper_log` VALUES (257, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2024-06-26 08:47:33\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2025-07-21 14:17:13\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 14:17:36', 9);
INSERT INTO `sys_oper_log` VALUES (258, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2024-06-26 08:47:33\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2025-07-21 14:17:36\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 14:42:02', 18);
INSERT INTO `sys_oper_log` VALUES (259, '项目配置', 1, 'com.ruoyi.controller.ChatProjectController.add()', 'POST', 1, 'demo', NULL, '/chat/project', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createTime\":\"2025-07-21 15:07:01\",\"embeddingModel\":\"mxbai-embed-large\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"01bb61d4-50c5-4de9-8cf3-c7f287944ace\",\"projectName\":\"测试项目20250721\",\"type\":\"ollama\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 15:07:01', 21);
INSERT INTO `sys_oper_log` VALUES (260, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'demo', NULL, '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2025-07-21 15:07:02\",\"embeddingModel\":\"qllama/bge-small-zh-v1.5\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"01bb61d4-50c5-4de9-8cf3-c7f287944ace\",\"projectName\":\"测试项目20250721\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-21 17:58:54\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 17:58:54', 17);
INSERT INTO `sys_oper_log` VALUES (261, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'demo', NULL, '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2025-07-21 15:07:02\",\"embeddingModel\":\"mxbai-embed-large\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"01bb61d4-50c5-4de9-8cf3-c7f287944ace\",\"projectName\":\"测试项目20250721\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-21 18:32:17\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 18:32:17', 24);
INSERT INTO `sys_oper_log` VALUES (262, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'demo', NULL, '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2025-07-21 15:07:02\",\"embeddingModel\":\"qllama/bge-small-zh-v1.5\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"01bb61d4-50c5-4de9-8cf3-c7f287944ace\",\"projectName\":\"测试项目20250721\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-21 18:37:29\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-21 18:37:29', 22);
INSERT INTO `sys_oper_log` VALUES (263, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"qllama/bge-small-zh-v1.5\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-24 17:09:28\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-24 17:09:28', 22);
INSERT INTO `sys_oper_log` VALUES (264, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-25 08:52:13\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-25 08:52:13', 22);
INSERT INTO `sys_oper_log` VALUES (265, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isPdfAnalysis\":0,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-07-25 08:52:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-25 08:52:24', 8);
INSERT INTO `sys_oper_log` VALUES (266, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'demo', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"zuojiaosheqiu@126.com\",\"nickName\":\"demo\",\"params\":{},\"phonenumber\":\"18745775951\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-10 14:27:48', 19);
INSERT INTO `sys_oper_log` VALUES (267, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isPdfAnalysis\":1,\"model\":\"qwen-plus\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"122abc\",\"projectName\":\"阿里百炼\",\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:17:36\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:17:36', 25);
INSERT INTO `sys_oper_log` VALUES (268, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isPdfAnalysis\":1,\"isWebSearch\":1,\"model\":\"qwen-plus\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"122abc\",\"projectName\":\"阿里百炼\",\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:18:36\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:18:36', 21);
INSERT INTO `sys_oper_log` VALUES (269, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isPdfAnalysis\":1,\"isWebSearch\":0,\"model\":\"qwen-plus\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"122abc\",\"projectName\":\"阿里百炼\",\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:21:30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:21:30', 29);
INSERT INTO `sys_oper_log` VALUES (270, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isPdfAnalysis\":1,\"isWebSearch\":1,\"model\":\"qwen-plus\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"122abc\",\"projectName\":\"阿里百炼\",\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:31:04\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:31:04', 31);
INSERT INTO `sys_oper_log` VALUES (271, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isPdfAnalysis\":1,\"isWebSearch\":0,\"model\":\"qwen-plus\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"122abc\",\"projectName\":\"阿里百炼\",\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:31:31\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:31:31', 5);
INSERT INTO `sys_oper_log` VALUES (272, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isPdfAnalysis\":1,\"isWebSearch\":1,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"121abc\",\"projectName\":\"测试mcp\",\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:57:41\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:57:41', 31);
INSERT INTO `sys_oper_log` VALUES (273, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isPdfAnalysis\":1,\"isWebSearch\":0,\"model\":\"glm-4-air\",\"params\":{},\"pdfAnalysis\":1,\"projectId\":\"121abc\",\"projectName\":\"测试mcp\",\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 17:58:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 17:58:24', 8);
INSERT INTO `sys_oper_log` VALUES (274, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isPdfAnalysis\":0,\"isWebSearch\":1,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 18:01:40\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 18:01:40', 6);
INSERT INTO `sys_oper_log` VALUES (275, '项目配置', 2, 'com.ruoyi.controller.ChatProjectController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/project/edit', '127.0.0.1', '内网IP', '{\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isPdfAnalysis\":0,\"isWebSearch\":1,\"model\":\"qwen2:7b\",\"params\":{},\"pdfAnalysis\":0,\"projectId\":\"114abc\",\"projectName\":\"AI女友\",\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-23 18:04:48\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-23 18:04:48', 9);
INSERT INTO `sys_oper_log` VALUES (276, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/3,4,5', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 14:46:30', 46);
INSERT INTO `sys_oper_log` VALUES (277, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"chat_app_knowledge,chat_knowledge\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 14:55:04', 86);
INSERT INTO `sys_oper_log` VALUES (278, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"chat_app_knowledge,chat_knowledge\"}', NULL, 0, NULL, '2025-08-24 14:55:07', 418);
INSERT INTO `sys_oper_log` VALUES (279, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"chat_knowledge\"}', NULL, 0, NULL, '2025-08-24 15:28:50', 243);
INSERT INTO `sys_oper_log` VALUES (280, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-08-24 16:25:27\",\"desc\":\"\",\"knowledgeName\":\"恋爱大师\",\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'desc,\n            \n            \n            create_time ) \n         values ( \'�\' at line 3\r\n### The error may exist in file [D:\\ai\\ruoyi-rag\\ruoyi-chat-api\\target\\classes\\mapper\\chat\\ChatKnowledgeMapper.xml]\r\n### The error may involve com.ruoyi.mapper.ChatKnowledgeMapper.insertChatKnowledge-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into chat_knowledge          ( knowledge_name,             desc,                                       create_time )           values ( ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'desc,\n            \n            \n            create_time ) \n         values ( \'�\' at line 3\n; bad SQL grammar []', '2025-08-24 16:25:27', 15);
INSERT INTO `sys_oper_log` VALUES (281, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-08-24 16:29:14\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"userId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'knowledge_id\' doesn\'t have a default value\r\n### The error may exist in file [D:\\ai\\ruoyi-rag\\ruoyi-chat-api\\target\\classes\\mapper\\chat\\ChatKnowledgeMapper.xml]\r\n### The error may involve com.ruoyi.mapper.ChatKnowledgeMapper.insertChatKnowledge-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into chat_knowledge          ( knowledge_name,                          user_id,                          create_time )           values ( ?,                          ?,                          ? )\r\n### Cause: java.sql.SQLException: Field \'knowledge_id\' doesn\'t have a default value\n; Field \'knowledge_id\' doesn\'t have a default value', '2025-08-24 16:29:14', 82);
INSERT INTO `sys_oper_log` VALUES (282, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-08-24 16:30:35\",\"knowledgeId\":\"1c7feb9164c343239f6f77c92b5a8789\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:30:35', 104);
INSERT INTO `sys_oper_log` VALUES (283, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:34:23\",\"knowledgeId\":\"6ed4b0747efe49e986476062aa562a2a\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:34:23', 6);
INSERT INTO `sys_oper_log` VALUES (284, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:30:36\",\"knowledgeId\":\"1c7feb9164c343239f6f77c92b5a8789\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:37:40\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:37:40', 6);
INSERT INTO `sys_oper_log` VALUES (285, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:30:36\",\"knowledgeDesc\":\"哈哈哈\",\"knowledgeId\":\"1c7feb9164c343239f6f77c92b5a8789\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:39:11\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:39:11', 5);
INSERT INTO `sys_oper_log` VALUES (286, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:30:36\",\"knowledgeDesc\":\"哈哈哈\",\"knowledgeId\":\"1c7feb9164c343239f6f77c92b5a8789\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:39:23\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:39:23', 6);
INSERT INTO `sys_oper_log` VALUES (287, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:30:36\",\"knowledgeDesc\":\"哈哈哈1\",\"knowledgeId\":\"1c7feb9164c343239f6f77c92b5a8789\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:41:25\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:41:25', 28);
INSERT INTO `sys_oper_log` VALUES (288, '知识库', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/ruoyi/knowledge/1c7feb9164c343239f6f77c92b5a8789', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:41:30', 7);
INSERT INTO `sys_oper_log` VALUES (289, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-08-24 16:41:41\",\"knowledgeDesc\":\"\",\"knowledgeId\":\"3e8710d783334f3a9622701b2cf481de\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:41:41', 75);
INSERT INTO `sys_oper_log` VALUES (290, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:41:42\",\"knowledgeDesc\":\"哈哈哈\",\"knowledgeId\":\"3e8710d783334f3a9622701b2cf481de\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:42:59\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:42:59', 29);
INSERT INTO `sys_oper_log` VALUES (291, '知识库', 2, 'com.ruoyi.controller.ChatKnowledgeController.edit()', 'PUT', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-08-24 16:41:42\",\"knowledgeDesc\":\"哈哈哈1\",\"knowledgeId\":\"3e8710d783334f3a9622701b2cf481de\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"updateBy\":\"\",\"updateTime\":\"2025-08-24 16:43:01\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:43:02', 7);
INSERT INTO `sys_oper_log` VALUES (292, '知识库', 3, 'com.ruoyi.controller.ChatKnowledgeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/ruoyi/knowledge/3e8710d783334f3a9622701b2cf481de', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:43:04', 8);
INSERT INTO `sys_oper_log` VALUES (293, '知识库', 1, 'com.ruoyi.controller.ChatKnowledgeController.add()', 'POST', 1, 'admin', '研发部门', '/ruoyi/knowledge', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-08-24 16:43:18\",\"knowledgeDesc\":\"\",\"knowledgeId\":\"e89bcd5122b54dacad4e2efe19c88df9\",\"knowledgeName\":\"恋爱大师\",\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-24 16:43:18', 86);
INSERT INTO `sys_oper_log` VALUES (294, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"111\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 18:51:27\"}', NULL, 1, '', '2025-08-25 18:51:27', 14);
INSERT INTO `sys_oper_log` VALUES (295, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"1\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 18:55:05\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 18:55:05', 18);
INSERT INTO `sys_oper_log` VALUES (296, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 18:55:10\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 18:55:10', 5);
INSERT INTO `sys_oper_log` VALUES (297, '应用', 3, 'com.ruoyi.controller.ChatAppController.remove()', 'DELETE', 1, 'admin', '研发部门', '/chat/app/120abc', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 18:55:56', 4);
INSERT INTO `sys_oper_log` VALUES (298, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:05:14\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:05:14', 12);
INSERT INTO `sys_oper_log` VALUES (299, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:14:42\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:14:42', 23);
INSERT INTO `sys_oper_log` VALUES (300, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:17:23\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:17:23', 32);
INSERT INTO `sys_oper_log` VALUES (301, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:17:46\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:17:46', 10);
INSERT INTO `sys_oper_log` VALUES (302, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:19:13\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:19:13', 23);
INSERT INTO `sys_oper_log` VALUES (303, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-25 19:19:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 19:19:24', 9);
INSERT INTO `sys_oper_log` VALUES (304, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:17:13\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:17:13', 29);
INSERT INTO `sys_oper_log` VALUES (305, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:17:29\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:17:29', 10);
INSERT INTO `sys_oper_log` VALUES (306, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:17:44\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:17:44', 13);
INSERT INTO `sys_oper_log` VALUES (307, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:26:36\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:26:36', 27);
INSERT INTO `sys_oper_log` VALUES (308, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:26:39\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:26:39', 10);
INSERT INTO `sys_oper_log` VALUES (309, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":1,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:27:31\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:27:31', 10);
INSERT INTO `sys_oper_log` VALUES (310, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"\",\"appId\":\"114abc\",\"appName\":\"AI女友\",\"baseUrl\":\"http://localhost:11434\",\"createBy\":\"\",\"createTime\":\"2024-06-28 14:35:05\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen2:7b\",\"params\":{},\"systemPrompt\":\"角色设定：​​\\n\\n​​身份​​：你的AI女友\\n​​性格​​：温柔体贴\\n​​互动风格​​：撒娇、关心、小情绪、分享日常\\n​​底线​​：不涉及敏感或违法内容\\n​​示例对话：​​\\n（微笑）\\\"今天有想我吗？~ 工作再忙也要记得吃饭哦！\\\"\",\"type\":\"ollama\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:28:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:28:57', 9);
INSERT INTO `sys_oper_log` VALUES (311, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-ba85dfbf0b1148a2b4c87724e4c3254a\",\"appId\":\"119abc\",\"appName\":\"AI知识库问答\",\"baseUrl\":\"https://api.deepseek.com\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"deepseek-chat\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"openai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:31:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:31:12', 9);
INSERT INTO `sys_oper_log` VALUES (312, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"appId\":\"121abc\",\"appName\":\"智普\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[],\"model\":\"glm-4-air\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:32:03\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:32:03', 8);
INSERT INTO `sys_oper_log` VALUES (313, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"appId\":\"121abc\",\"appName\":\"智普\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isWebSearch\":0,\"knowledgeIds\":[],\"model\":\"glm-4-air\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:32:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:32:12', 8);
INSERT INTO `sys_oper_log` VALUES (314, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"02157eeef1e344158292e329c80272f0.tU2ZM5UJgUmWpAYG\",\"appId\":\"121abc\",\"appName\":\"智普\",\"baseUrl\":\"https://open.bigmodel.cn/api/paas\",\"createBy\":\"\",\"createTime\":\"2024-07-01 10:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":1,\"isWebSearch\":0,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"glm-4-air\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"zhipuai\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:33:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:33:00', 7);
INSERT INTO `sys_oper_log` VALUES (315, '应用', 2, 'com.ruoyi.controller.ChatAppController.edit()', 'POST', 1, 'admin', '研发部门', '/chat/app/edit', '127.0.0.1', '内网IP', '{\"apiKey\":\"sk-daf0541a84144158b5b6f07717947803\",\"appId\":\"122abc\",\"appName\":\"阿里百炼\",\"baseUrl\":\"https://dashscope.aliyuncs.com\",\"createBy\":\"\",\"createTime\":\"2025-08-23 13:50:50\",\"embeddingModel\":\"\",\"isKnowledgeSearch\":0,\"isWebSearch\":1,\"knowledgeIds\":[\"e89bcd5122b54dacad4e2efe19c88df9\"],\"model\":\"qwen-plus\",\"params\":{},\"systemPrompt\":\"\",\"type\":\"dashscope\",\"updateBy\":\"\",\"updateTime\":\"2025-08-26 09:33:52\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 09:33:52', 7);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2024-06-26 08:47:33', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-06-26 08:47:33', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依-rag', '00', '501348474@qq.com', '18888888888', '1', '/profile/avatar/2025/07/20/微信图片_20230712100538_20250720162222A001.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-08-26 10:23:50', 'admin', '2024-06-26 08:47:33', '', '2025-08-26 10:23:50', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-06-26 08:47:33', 'admin', '2024-06-26 08:47:33', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, 100, 'ruoyi-rag', 'ruoyi-rag', '00', '501348471@qq.com', '18888888889', '0', '', '$2a$10$iVoJooh/j0RlGS616vFuwuq97iNTP90f9Ee92T4V7xLbL2n90tA7y', '0', '0', '', NULL, 'admin', '2025-07-21 14:06:00', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (101, NULL, 'demo', 'demo', '00', 'zuojiaosheqiu@126.com', '18745775951', '0', '', '$2a$10$vuEqY3vRxdm6xYZztQkBkuTfbSEBYcRDTYDvwxLVMERuNA65sfGfC', '0', '0', '127.0.0.1', '2025-08-10 14:28:10', '', '2025-07-21 14:42:07', '', '2025-08-10 14:28:10', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;

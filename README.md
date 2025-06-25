# RuoYi-RAG 智能知识库服务端

## 项目介绍

RuoYi-RAG 是一个基于 RuoYi 框架开发的 AI 知识库检索增强生成（RAG）系统的服务端。该系统为 [AI知识库管理系统](https://github.com/zhaoshibao/ruoyi-rag-admin.git) 和 [AI知识库用户端](https://github.com/zhaoshibao/ruoyi-rag-web.git) 提供接口服务，支持多种 AI 模型进行知识检索和问答。

## 功能特性

### 项目管理

- 创建、修改、删除项目
- 支持多种 AI 模型类型（如 OpenAI GPT-3.5-turbo、Ollama Qwen2:7b 等）
- 自定义系统提示词
- 项目列表展示与搜索

### 知识库管理

- 按项目上传知识文件
- 知识文件内容向量化存储
- 知识库文件删除
- 知识库列表展示与搜索

### AI 对话功能

- 多会话管理：支持创建和管理多个聊天会话
- 消息历史记录：保存和显示聊天历史记录
- 流式响应：支持 AI 回复的流式显示，提供更好的用户体验
- 普通响应：支持传统的一次性返回完整回复的模式
- 联网搜索：支持 AI 在回答问题时进行网络搜索，获取最新信息
- 智能补全：提供代码和文本的智能补全功能

## 技术架构

### 核心技术栈

- **后端框架**：Spring Boot 3.3.0
- **AI 框架**：Spring AI 1.0.0-M6
- **数据库**：MySQL、MongoDB
- **向量存储**：Qdrant Vector Store
- **搜索引擎**：SearXNG

### 主要模块

- **ruoyi-admin**：系统管理模块
- **ruoyi-chat**：AI 聊天核心模块
- **ruoyi-chat-api**：AI 聊天接口模块
- **ruoyi-common**：通用工具模块
- **ruoyi-framework**：框架核心模块
- **ruoyi-system**：系统功能模块
- **ruoyi-quartz**：定时任务模块
- **ruoyi-generator**：代码生成模块

### AI 模型支持

- **OpenAI**：支持 GPT-3.5-turbo 等模型
- **Ollama**：支持 Qwen2:7b 等开源模型

## 安装部署

### 环境要求

- JDK 17+
- MySQL 8.0+
- MongoDB 4.0+
- Qdrant Vector Store
- Maven 3.6+

### 数据库配置

1. 创建数据库 `ruoyi_rag`
2. 执行 SQL 脚本：`sql/ruoyi_rag.sql`

### 配置修改

根据实际环境修改以下配置：

1. 数据库连接配置
2. MongoDB 连接配置
3. Qdrant Vector Store 配置
4. AI 模型配置（OpenAI API Key 等）

### 编译打包

```bash
mvn clean package -DskipTests
```

### 启动服务

```bash
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

或使用脚本：

```bash
# Windows
ry.bat

# Linux
./ry.sh
```

## 接口文档

启动服务后，访问 Swagger 文档：

```
http://localhost:8080/swagger-ui/index.html
```

## 开发指南

### 项目结构

- **controller**：控制器层，处理 HTTP 请求
- **service**：服务层，实现业务逻辑
- **operator**：AI 操作层，实现不同 AI 模型的交互
- **pojo/domain**：数据模型层
- **vo**：视图对象层
- **utils**：工具类

### 扩展新的 AI 模型

1. 实现 `AiOperator` 接口
2. 添加 `@BeanType` 注解指定模型类型
3. 实现必要的方法（如 `chatStream`、`upload` 等）

## 前端项目

- [AI知识库管理系统](https://github.com/zhaoshibao/ruoyi-rag-admin.git)：管理端页面
- [AI知识库用户端](https://github.com/zhaoshibao/ruoyi-rag-web.git)：用户端页面

## 许可证

[MIT License](LICENSE)

## 致谢

- 本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 框架开发
- 感谢所有为本项目做出贡献的开发者

        
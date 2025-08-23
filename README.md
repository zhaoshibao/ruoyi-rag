# RuoYi-RAG 智能知识库服务端

## 项目介绍

RuoYi-RAG 是一个基于 Spring AI 框架开发的 AI 知识库检索增强生成（RAG）系统的服务端。该系统为 [AI知识库管理系统](https://github.com/zhaoshibao/ruoyi-rag-admin.git) 和 [AI知识库用户端](https://github.com/zhaoshibao/ruoyi-rag-web.git) 提供接口服务，支持多种 AI 模型进行知识检索和问答，并引入SearXNG搜索引擎、Neo4j知识图谱、MCP服务（高德地图、邮件、数据库）来增强大模型回答能力，使模型回答更丰富、更准确、更及时。

**核心特点：**

- 🤖 多模型支持：适配 OpenAI、各大国内主流大模型平台，以及本地 vllm、ollama 部署
- 📚 灵活知识库：支持 PDF、TXT、MD 等多种格式文档
- 🕸️ 知识图谱集成：基于 Neo4j 的知识图谱问答能力
- 🚀 简单配置：只需配置对应服务平台的 `API_KEY` 即可使用

**架构图：**

![ruoyi-rag项目架构图](https://github.com/user-attachments/assets/e9e8290c-9642-4774-b5d9-01d2fd2a0968)

## 服务启动文档
- [文档地址](https://blog.csdn.net/u013795511/article/details/149218898)
## 功能特性

### 项目管理

- 创建、修改、删除项目
- 项目列表展示与搜索
- 支持多种 AI 模型类型（OpenAI 、Ollama 、智谱AI等）
- 自定义系统提示词
- 支持上传多种文件格式（如 PDF、DOCX、TXT、Markdown，CSV 等）
- 支持知识图谱展示与搜索


### 知识库管理

- 知识库列表展示与搜索
- 知识库文件删除
- 知识文件内容查看


### AI 对话功能

- 多会话管理：支持创建和管理多个聊天会话
- 消息历史记录：保存和显示聊天历史记录
- 流式响应：支持 AI 回复的流式显示，提供更好的用户体验
- 普通响应：支持传统的一次性返回完整回复的模式
- 联网搜索：支持 AI 在回答问题时进行网络搜索，获取最新信息


### 图片生成
- 支持 AI 生成图片

### 文档总结
- 支持 AI 对文档内容进行总结

### MCP 服务
- 集成文件系统、高德地图等mcp服务
- 自定义获取时间、发送邮件、查询数据库等mcp服务

## 技术架构

### 核心技术栈

- **后端框架**：Spring Boot 3.3.0
- **用户端**：Vue 3 + Element Plus
- **AI 框架**：Spring AI 1.0.0
- **数据库**：MySQL、Redis、MongoDB
- **向量存储**：Qdrant Vector Store
- **搜索引擎**：SearXNG
- **图数据库**：Neo4j

### 主要模块

- **ruoyi-admin**：系统管理模块
- **ruoyi-chat**：AI 聊天核心模块
- **ruoyi-chat-api**：AI 聊天接口模块
- **ruoyi-common**：通用工具模块
- **ruoyi-framework**：框架核心模块
- **ruoyi-system**：系统功能模块
- **ruoyi-quartz**：定时任务模块
- **ruoyi-generator**：代码生成模块
- **ruoyi-mcp-server**：MCP服务端模块
- **ui**：用户端模块

### AI 模型支持

- **OpenAI**：支持 GPT-3.5-turbo 等模型
- **Ollama**：支持 Qwen2:7b 等开源模型
- **智谱AI**：支持 智谱AI 等模型

## 安装部署

### 环境要求

- JDK 17+
- MySQL 8.0+
- MongoDB 4.0+
- Redis 6.0+
- Qdrant Vector Store
- Maven 3.6+
- Neo4j 5.7+
- SearXNG 2025.7.8-fe52290
- node.js 18+

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

## github源码地址
- [AI知识库服务端](https://github.com/zhaoshibao/ruoyi-rag.git)：服务端
- [AI知识库管理系统](https://github.com/zhaoshibao/ruoyi-rag-admin.git)：管理端页面
- [AI知识库用户端](https://github.com/zhaoshibao/ruoyi-rag-web.git)：用户端页面

## 贡献者名单

感谢以下贡献者的支持！

<a href="https://github.com/zhaoshibao/ruoyi-rag/contributors">
    <img src="https://contributors.nn.ci/api?repo=zhaoshibao/ruoyi-rag" alt="贡献者名单">
</a>

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=zhaoshibao/ruoyi-rag)](https://www.star-history.com/#zhaoshibao/ruoyi-rag)

## 许可证

[MIT License](LICENSE)

## 致谢

- 本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 框架开发
- 感谢所有为本项目做出贡献的开发者

        

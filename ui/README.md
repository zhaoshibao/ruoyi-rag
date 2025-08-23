
# RuoYi-RAG-Web

## 项目介绍

RuoYi-RAG-Web 是一个基于 Vue 3 和 Element Plus 开发的 AI 知识库系统的用户端页面。该项目提供了与 AI 模型进行对话的界面，支持流式响应和普通响应两种模式，并具有联网搜索功能。

## 技术栈

- **前端框架**：Vue 3 + Vite
- **UI 组件库**：Element Plus
- **状态管理**：Pinia
- **路由管理**：Vue Router
- **HTTP 请求**：Axios
- **代码高亮**：Prism.js
- **富文本编辑**：Quill
- **WebSocket**：Socket.io-client

## 功能特性

### 聊天功能

- **多会话管理**：支持创建和管理多个聊天会话
- **消息历史记录**：保存和显示聊天历史记录
- **代码高亮**：自动识别和高亮显示代码块
- **流式响应**：支持 AI 回复的流式显示，提供更好的用户体验
- **普通响应**：支持传统的一次性返回完整回复的模式
- **联网搜索**：支持 AI 在回答问题时进行网络搜索，获取最新信息
- **消息中断**：支持用户在 AI 生成回复过程中随时中断

### 用户界面

- **响应式设计**：适配不同屏幕尺寸的设备
- **侧边栏折叠**：支持聊天列表侧边栏的折叠和展开
- **模型选择**：支持选择不同的 AI 模型进行对话
- **主题切换**：支持明暗主题切换

## 项目结构

```
ruoyi-rag-web/
├── src/                    # 源代码目录
│   ├── api/                # API 接口定义
│   │   └── chat/           # 聊天相关 API
│   ├── assets/             # 静态资源
│   ├── components/         # 公共组件
│   │   └── Chat/           # 聊天相关组件
│   ├── store/              # 状态管理
│   │   └── chat.js         # 聊天状态管理
│   ├── views/              # 页面视图
│   │   └── chat/           # 聊天页面
│   ├── App.vue             # 根组件
│   └── main.js             # 入口文件
├── vite.config.js          # Vite 配置
└── package.json            # 项目依赖
```

## 核心组件

### 聊天页面 (Chat.vue)

聊天页面是用户与 AI 进行对话的主界面，包含以下功能：

- 聊天历史列表显示
- 消息输入框
- 流式/普通模式切换
- 停止生成按钮
- 侧边栏折叠/展开

### 消息列表 (MessageList.vue)

负责显示聊天消息，具有以下特点：

- 区分用户和 AI 的消息样式
- 支持代码高亮显示
- 自动滚动到最新消息
- 显示打字动画效果

### 聊天输入框 (ChatInput.vue)

用户输入消息的组件，包含：

- 文本输入区域
- 发送按钮
- 联网搜索开关

## 状态管理

项目使用 Pinia 进行状态管理，主要包含以下状态：

- 当前会话 ID
- 消息列表
- 会话列表
- 发送状态
- SSE 连接状态
- 用户 UUID

## 通信方式

### 普通模式

使用传统的 HTTP 请求发送消息并接收完整回复。

### 流式模式 (SSE)

使用 Server-Sent Events (SSE) 技术实现 AI 回复的流式显示，提供更好的用户体验。

## 开发环境设置

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

### 构建生产版本

```bash
npm run build:prod
```

### 预览生产构建

```bash
npm run preview
```

## 配置说明

### 环境变量

项目使用不同的环境配置文件：

- `.env.development`：开发环境配置
- `.env.production`：生产环境配置
- `.env.staging`：测试环境配置

### 后端接口

默认后端接口配置在 `vite.config.js` 中：

```javascript
const baseUrl = 'http://localhost:9090' // 后端接口
```

## 部署说明

1. 执行构建命令生成静态文件：
   ```bash
   npm run build:prod
   ```

2. 将生成的 `dist` 目录下的文件部署到 Web 服务器


## 版本历史

- v1.0.0 - 初始版本，实现基本的与AI大模型进行对话的功能

## 许可证

MIT License


## 致谢

- 本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 框架开发
- 感谢所有为本项目做出贡献的开发者

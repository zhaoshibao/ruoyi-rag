# RuoYi-RAG-Admin

## 项目介绍

RuoYi-RAG-Admin 是一个基于 RuoYi-Vue 框架开发的 AI 知识库检索增强生成（RAG）系统的管理端页面。该系统允许用户创建项目、上传知识文件、管理知识库，并通过不同的 AI 模型进行知识检索和问答。

## 功能特性

### 项目管理
- 创建、修改、删除项目
- 支持多种 AI 模型类型（如 OpenAI GPT-3.5-turbo、Ollama Qwen2:7b 等）
- 项目列表展示与搜索

### 知识库管理
- 按项目上传知识文件（支持 txt、word、pdf 格式）
- 查看知识文件内容
- 删除知识文件
- 按项目和用户筛选知识文件

### 系统特性
- 基于 Vue.js 和 Element UI 的现代化界面
- 响应式设计，支持多种设备访问
- 权限控制，不同角色可访问不同功能
- 与后端 API 无缝集成

## 技术栈

### 前端技术
- Vue.js 2.6.12
- Vuex 3.6.0
- Vue Router 3.4.9
- Element UI 2.15.14
- Axios 0.24.0
- Sass/SCSS
- ES6+

### 开发工具
- Node.js (>= 8.9)
- npm (>= 3.0.0)
- Vue CLI 4.4.6

## 安装部署

### 环境要求
- Node.js >= 8.9
- npm >= 3.0.0

### 安装步骤

1. 克隆项目代码
```bash
git clone https://github.com/zhaoshibao/ruoyi-rag-admin.git

cd ruoyi-rag-admin
```

2. 安装依赖
```bash
npm install
```

3. 开发环境运行
```bash
npm run dev
```

4. 生产环境构建
```bash
npm run build:prod
```

### 配置说明

- 开发环境配置文件：`.env.development`
- 生产环境配置文件：`.env.production`
- 测试环境配置文件：`.env.staging`

## 项目结构

```
ruoyi-rag-admin/
├── public/                 # 静态资源
├── src/                    # 源代码
│   ├── api/                # API 接口
│   │   ├── chat/           # 知识库和项目相关接口
│   │   │   ├── knowledge.js # 知识库管理接口
│   │   │   └── project.js  # 项目管理接口
│   ├── assets/             # 主题、字体等静态资源
│   ├── components/         # 全局公用组件
│   ├── layout/             # 布局组件
│   ├── router/             # 路由配置
│   ├── store/              # 全局状态管理
│   ├── utils/              # 全局工具方法
│   ├── views/              # 页面组件
│   │   ├── chat/           # 知识库系统相关页面
│   │   │   ├── knowledge.vue # 知识库管理页面
│   │   │   └── project.vue  # 项目管理页面
│   ├── App.vue             # 入口页面
│   ├── main.js             # 入口文件
│   └── permission.js       # 权限管理
├── .env.development        # 开发环境配置
├── .env.production         # 生产环境配置
├── .env.staging            # 测试环境配置
├── package.json            # 项目依赖
└── vue.config.js           # Vue 配置
```

## 使用指南

### 项目管理

1. 在左侧菜单中选择「项目管理」
2. 点击「新增」按钮创建新项目
3. 填写项目名称并选择 AI 模型类型
4. 点击「确定」保存项目

### 知识库管理

1. 在左侧菜单中选择「知识库管理」
2. 可通过项目和用户筛选知识文件
3. 在项目管理页面，点击「上传知识库」按钮上传文件
4. 支持上传 txt、word、pdf 格式的文件，单个文件不超过 5MB
5. 点击「查看内容」可预览知识文件内容
6. 点击「删除」可移除知识文件

## 开发指南

### 添加新功能

1. 在 `src/api` 目录下添加相应的 API 接口
2. 在 `src/views` 目录下创建新的页面组件
3. 在 `src/router/index.js` 中添加新的路由配置

### 修改现有功能

1. 找到对应的页面组件（如 `src/views/chat/knowledge.vue`）
2. 修改组件代码实现新的功能
3. 如需修改 API 接口，编辑 `src/api/chat` 目录下的相应文件

## 常见问题

1. **问题**: 上传文件失败
   **解决**: 检查文件格式是否为 txt、word 或 pdf，且文件大小不超过 5MB

2. **问题**: 无法创建项目
   **解决**: 确认是否有项目管理权限，检查网络连接是否正常

3. **问题**: 知识库内容无法显示
   **解决**: 检查文件是否成功上传，以及文件内容是否符合系统要求


## 版本历史

- v1.0.0 - 初始版本，实现基本的项目管理和知识库管理功能

## 许可证

本项目基于 MIT 许可证 - 详见 LICENSE 文件


## 致谢

- 本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 框架开发
- 感谢所有为本项目做出贡献的开发者

        
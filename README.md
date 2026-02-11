# TodoList 应用

一个现代化的待办事项管理应用，使用 Vue 3 + Tailwind CSS 前端和 Flask 后端。

## 🚀 功能特性

- ✅ 添加、编辑、删除任务
- ✅ 标记任务完成/未完成
- ✅ 按状态筛选（全部/待完成/已完成）
- ✅ 实时统计
- ✅ 响应式设计
- ✅ 现代化 UI

## 📁 项目结构

```
todolist-app/
├── frontend/           # Vue3 + Tailwind CSS 前端
│   ├── src/           
│   │   ├── components/ # Vue 组件
│   │   ├── App.vue    # 主应用组件
│   │   └── main.js    # 入口文件
│   ├── package.json   # 依赖配置
│   └── vite.config.js # Vite 配置
├── backend/            # Flask 后端
│   ├── app.py         # 主应用
│   ├── config.py      # 配置文件
│   └── requirements.txt # Python 依赖
└── README.md
```

## 🛠️ 技术栈

### 前端
- **Vue 3** - 渐进式 JavaScript 框架
- **Tailwind CSS** - 实用优先的 CSS 框架
- **Vite** - 下一代前端构建工具
- **Axios** - HTTP 客户端

### 后端
- **Flask** - 轻量级 Python Web 框架
- **Flask-SQLAlchemy** - ORM 数据库工具
- **Flask-CORS** - 跨域支持
- **SQLite** - 轻量级数据库（开发环境）

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone <你的仓库地址>
cd todolist-app
```

### 2. 启动后端

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

后端服务将在 http://localhost:5000 运行

### 3. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端服务将在 http://localhost:5173 运行

### 4. 访问应用

打开浏览器访问 http://localhost:5173

## 📡 API 文档

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | `/api/todos` | 获取所有任务 |
| POST | `/api/todos` | 创建任务 |
| GET | `/api/todos/<id>` | 获取单个任务 |
| PUT | `/api/todos/<id>` | 更新任务 |
| DELETE | `/api/todos/<id>` | 删除任务 |
| DELETE | `/api/todos/clear-completed` | 清除已完成任务 |
| GET | `/api/health` | 健康检查 |

## 🌐 Codespace 支持

本项目支持 GitHub Codespace，点击仓库页面的 "Code" → "Codespaces" → "Create codespace" 即可在云端开发环境中运行。

Codespace 会自动配置好所有依赖，启动前后端服务。

## 📝 License

MIT License
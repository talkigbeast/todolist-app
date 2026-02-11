#!/bin/bash
set -e

echo "🚀 启动服务..."

# 启动后端（后台运行）
echo "📡 启动后端服务..."
cd backend
python app.py &
cd ..

# 等待后端启动
sleep 2

# 启动前端（后台运行）
echo "🎨 启动前端服务..."
cd frontend
npm run dev &
cd ..

echo "✅ 服务已启动！"
echo "📝 后端: http://localhost:5000"
echo "🎨 前端: http://localhost:5173"
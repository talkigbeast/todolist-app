#!/bin/bash
set -e

echo "🚀 安装后端依赖..."
cd /workspaces/todolist-app/backend
pip install --user -r requirements.txt

echo "📦 安装前端依赖..."
cd /workspaces/todolist-app/frontend
npm install

echo "✅ 依赖安装完成！"
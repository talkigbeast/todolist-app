#!/bin/bash
# postCreateCommand - 安装依赖
set -e

echo "🚀 安装依赖..."

# 安装后端依赖
echo "📦 安装后端依赖..."
cd /workspaces/todolist-app/backend
pip install --user -r requirements.txt

# 安装前端依赖
echo "📦 安装前端依赖..."
cd /workspaces/todolist-app/frontend
npm install

echo "✅ 依赖安装完成！"
#!/bin/bash
set -e

echo "🚀 设置开发环境..."

# 安装后端依赖
echo "📦 安装后端依赖..."
cd /workspaces/todolist-app/backend
pip install --user -r requirements.txt

echo "✅ 环境设置完成！"
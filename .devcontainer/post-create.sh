#!/bin/bash
set -e

echo "🚀 设置开发环境..."

# 安装后端依赖
echo "📦 安装后端依赖..."
cd backend
python -m pip install --upgrade pip
pip install -r requirements.txt
cd ..

# 安装前端依赖
echo "📦 安装前端依赖..."
cd frontend
npm install
cd ..

echo "✅ 环境设置完成！"
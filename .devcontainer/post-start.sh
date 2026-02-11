#!/bin/bash
# postStartCommand - 在 Codespace 启动后执行

echo "🚀 启动服务..."

# 创建日志目录
mkdir -p /tmp/services

# ========== 启动后端 ==========
echo "📡 启动后端服务..."
nohup bash -c '
    cd /workspaces/todolist-app/backend
    python app.py
' > /tmp/services/backend.log 2>&1 &
backend_pid=$!
disown $backend_pid
echo $backend_pid > /tmp/services/backend.pid

# 等待后端启动
sleep 3

# 检查后端状态
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ 后端已启动 (PID: $backend_pid)"
else
    echo "⚠️ 后端可能启动失败，查看日志: cat /tmp/services/backend.log"
fi

# ========== 启动前端 ==========
echo "🎨 检查前端依赖..."
cd /workspaces/todolist-app/frontend

# 如果 node_modules 不存在，先安装依赖
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.bin/vite" ]; then
    echo "📦 安装前端依赖..."
    npm install > /tmp/services/npm-install.log 2>&1
    if [ $? -ne 0 ]; then
        echo "❌ npm install 失败，查看日志: cat /tmp/services/npm-install.log"
    else
        echo "✅ 前端依赖安装完成"
    fi
fi

# 启动前端服务
echo "🎨 启动前端服务..."
nohup bash -c '
    cd /workspaces/todolist-app/frontend
    npm run dev -- --host
' > /tmp/services/frontend.log 2>&1 &
frontend_pid=$!
disown $frontend_pid
echo $frontend_pid > /tmp/services/frontend.pid

sleep 2

echo ""
echo "=========================================="
echo "✅ 服务启动命令已提交到后台"
echo "📡 后端: http://localhost:5000"
echo "🎨 前端: http://localhost:5173"
echo "=========================================="
echo ""
echo "查看日志:"
echo "  tail -f /tmp/services/backend.log"
echo "  tail -f /tmp/services/frontend.log"

# 保持脚本运行一段时间，确保进程启动
sleep 5

exit 0
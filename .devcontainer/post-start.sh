#!/bin/bash
set -e

echo "🚀 启动服务..."

# 启动后端（后台运行，记录日志）
echo "📡 启动后端服务..."
nohup bash -c 'cd /workspaces/todolist-app/backend && source venv/bin/activate && python app.py' > /tmp/backend.log 2>&1 &

# 等待后端启动
sleep 3

# 检查后端是否运行
if curl -s http://localhost:5000/api/health > /dev/null; then
    echo "✅ 后端服务已启动 (http://localhost:5000)"
else
    echo "⚠️ 后端服务可能未正常启动，查看日志: /tmp/backend.log"
fi

# 启动前端（后台运行，记录日志）
echo "🎨 启动前端服务..."
nohup bash -c 'cd /workspaces/todolist-app/frontend && npm run dev -- --host' > /tmp/frontend.log 2>&1 &

# 等待前端启动
sleep 5

echo "✅ 启动命令已执行"
echo "📝 后端日志: tail -f /tmp/backend.log"
echo "📝 前端日志: tail -f /tmp/frontend.log"
echo "🔗 后端地址: http://localhost:5000"
echo "🔗 前端地址: http://localhost:5173"
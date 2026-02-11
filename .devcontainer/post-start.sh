#!/bin/bash

# 启动后端
echo "📡 启动后端服务..."
cd /workspaces/todolist-app/backend
nohup python -u app.py > /tmp/backend.log 2>&1 &
echo $! > /tmp/backend.pid

# 等待后端启动
sleep 3

# 检查后端是否成功
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ 后端已启动 (PID: $(cat /tmp/backend.pid))"
else
    echo "⚠️ 后端启动可能失败，查看日志: cat /tmp/backend.log"
fi

# 启动前端
echo "🎨 启动前端服务..."
cd /workspaces/todolist-app/frontend
nohup npm run dev -- --host > /tmp/frontend.log 2>&1 &
echo $! > /tmp/frontend.pid

sleep 2

echo "✅ 服务启动命令已执行"
echo "📡 后端: http://localhost:5000 (PID: $(cat /tmp/backend.pid 2>/dev/null || echo 'unknown'))"
echo "🎨 前端: http://localhost:5173 (PID: $(cat /tmp/frontend.pid 2>/dev/null || echo 'unknown'))"
echo ""
echo "查看日志:"
echo "  tail -f /tmp/backend.log"
echo "  tail -f /tmp/frontend.log"
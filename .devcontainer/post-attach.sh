#!/bin/bash
# postAttachCommand - 在用户连接到 Codespace 后执行
# 用于确保服务正在运行

echo "🔍 检查服务状态..."

# 检查后端是否运行
backend_running=false
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ 后端服务已在运行"
    backend_running=true
else
    echo "📡 后端未运行，准备启动..."
fi

# 检查前端是否运行
frontend_running=false
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo "✅ 前端服务已在运行"
    frontend_running=true
else
    echo "🎨 前端未运行，准备启动..."
fi

# 启动未运行的服务
if [ "$backend_running" = false ] || [ "$frontend_running" = false ]; then
    echo ""
    echo "🚀 启动服务..."
    bash /workspaces/todolist-app/.devcontainer/post-start.sh
else
    echo ""
    echo "=========================================="
    echo "✅ 所有服务已运行"
    echo "📡 后端: http://localhost:5000"
    echo "🎨 前端: http://localhost:5173"
    echo "=========================================="
fi

# 显示日志位置
echo ""
echo "查看日志:"
echo "  tail -f /tmp/services/backend.log"
echo "  tail -f /tmp/services/frontend.log"
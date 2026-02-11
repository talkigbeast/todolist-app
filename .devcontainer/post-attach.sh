#!/bin/bash
# postAttachCommand - 在用户连接到 Codespace 后执行

echo "🔍 检查服务状态..."

# ========== 检查后端 ==========
backend_running=false
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ 后端服务已在运行"
    backend_running=true
else
    echo "📡 后端未运行，准备启动..."
fi

# ========== 检查前端 ==========
frontend_running=false
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo "✅ 前端服务已在运行"
    frontend_running=true
else
    echo "🎨 前端未运行，准备启动..."
fi

# ========== 启动未运行的服务 ==========
if [ "$backend_running" = false ] || [ "$frontend_running" = false ]; then
    echo ""
    echo "🚀 启动服务..."
    
    # 创建日志目录
    mkdir -p /tmp/services
    
    # 启动后端
    if [ "$backend_running" = false ]; then
        echo "📡 启动后端..."
        nohup bash -c '
            cd /workspaces/todolist-app/backend
            python app.py
        ' > /tmp/services/backend.log 2>&1 &
        echo $! > /tmp/services/backend.pid
        sleep 2
    fi
    
    # 启动前端
    if [ "$frontend_running" = false ]; then
        echo "🎨 检查前端依赖..."
        cd /workspaces/todolist-app/frontend
        
        # 如果 node_modules 不存在，先安装依赖
        if [ ! -d "node_modules" ] || [ ! -f "node_modules/.bin/vite" ]; then
            echo "📦 安装前端依赖..."
            npm install
        fi
        
        echo "🎨 启动前端..."
        nohup bash -c '
            cd /workspaces/todolist-app/frontend
            npm run dev -- --host
        ' > /tmp/services/frontend.log 2>&1 &
        echo $! > /tmp/services/frontend.pid
        sleep 2
    fi
    
    echo ""
    echo "=========================================="
    echo "✅ 服务已启动"
    echo "📡 后端: http://localhost:5000"
    echo "🎨 前端: http://localhost:5173"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "✅ 所有服务已运行"
    echo "📡 后端: http://localhost:5000"
    echo "🎨 前端: http://localhost:5173"
    echo "=========================================="
fi

echo ""
echo "查看日志:"
echo "  tail -f /tmp/services/backend.log"
echo "  tail -f /tmp/services/frontend.log"
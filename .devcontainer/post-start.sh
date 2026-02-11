#!/bin/bash
# postStartCommand - 使用 supervisor 保持进程运行

echo "🚀 配置服务..."

# 安装 supervisor
pip install --user supervisor

# 创建 supervisor 配置
mkdir -p /tmp/supervisor/conf.d

cat > /tmp/supervisor/supervisord.conf << 'EOF'
[supervisord]
nodaemon=false
logfile=/tmp/supervisor/supervisord.log
pidfile=/tmp/supervisor/supervisord.pid

[program:backend]
command=python /workspaces/todolist-app/backend/app.py
directory=/workspaces/todolist-app/backend
autostart=true
autorestart=true
stdout_logfile=/tmp/supervisor/backend.log
stderr_logfile=/tmp/supervisor/backend.log

[program:frontend]
command=npm run dev -- --host
directory=/workspaces/todolist-app/frontend
autostart=true
autorestart=true
stdout_logfile=/tmp/supervisor/frontend.log
stderr_logfile=/tmp/supervisor/frontend.log
EOF

# 启动 supervisor
echo "🚀 启动服务..."
~/.local/bin/supervisord -c /tmp/supervisor/supervisord.conf

echo "✅ 服务已启动"
echo "📡 后端: http://localhost:5000"
echo "🎨 前端: http://localhost:5173"
echo ""
echo "查看日志:"
echo "  cat /tmp/supervisor/backend.log"
echo "  cat /tmp/supervisor/frontend.log"
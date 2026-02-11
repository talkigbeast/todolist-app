from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import os

app = Flask(__name__)

# 配置
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///todos.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# 启用 CORS
CORS(app)

db = SQLAlchemy(app)

# 数据模型
class Todo(db.Model):
    __tablename__ = 'todos'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    completed = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'completed': self.completed,
            'created_at': self.created_at.isoformat()
        }

# 创建数据库表
with app.app_context():
    db.create_all()

# API 路由

@app.route('/api/todos', methods=['GET'])
def get_todos():
    """获取所有任务"""
    todos = Todo.query.order_by(Todo.created_at.desc()).all()
    return jsonify([todo.to_dict() for todo in todos])

@app.route('/api/todos', methods=['POST'])
def create_todo():
    """创建新任务"""
    data = request.get_json()
    
    if not data or 'title' not in data:
        return jsonify({'error': '标题不能为空'}), 400
    
    title = data['title'].strip()
    if not title:
        return jsonify({'error': '标题不能为空'}), 400
    
    todo = Todo(title=title)
    db.session.add(todo)
    db.session.commit()
    
    return jsonify(todo.to_dict()), 201

@app.route('/api/todos/<int:todo_id>', methods=['GET'])
def get_todo(todo_id):
    """获取单个任务"""
    todo = Todo.query.get_or_404(todo_id)
    return jsonify(todo.to_dict())

@app.route('/api/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    """更新任务"""
    todo = Todo.query.get_or_404(todo_id)
    data = request.get_json()
    
    if 'title' in data:
        title = data['title'].strip()
        if title:
            todo.title = title
    
    if 'completed' in data:
        todo.completed = bool(data['completed'])
    
    db.session.commit()
    return jsonify(todo.to_dict())

@app.route('/api/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    """删除任务"""
    todo = Todo.query.get_or_404(todo_id)
    db.session.delete(todo)
    db.session.commit()
    return jsonify({'message': '任务已删除'}), 200

@app.route('/api/todos/clear-completed', methods=['DELETE'])
def clear_completed():
    """清除所有已完成的任务"""
    Todo.query.filter_by(completed=True).delete()
    db.session.commit()
    return jsonify({'message': '已清除所有完成任务'})

# 健康检查
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat()
    })

# 首页
@app.route('/', methods=['GET'])
def index():
    return jsonify({
        'message': 'TodoList API 服务运行中',
        'version': '1.0.0',
        'endpoints': {
            'GET /api/todos': '获取所有任务',
            'POST /api/todos': '创建任务',
            'GET /api/todos/<id>': '获取单个任务',
            'PUT /api/todos/<id>': '更新任务',
            'DELETE /api/todos/<id>': '删除任务',
            'DELETE /api/todos/clear-completed': '清除已完成任务',
            'GET /api/health': '健康检查'
        }
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', 'True').lower() == 'true'
    app.run(host='0.0.0.0', port=port, debug=debug)
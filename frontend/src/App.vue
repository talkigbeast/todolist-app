<template>
  <div class="min-h-screen bg-gray-100 py-8">
    <div class="max-w-2xl mx-auto px-4">
      <div class="bg-white rounded-lg shadow-md p-6">
        <h1 class="text-3xl font-bold text-center text-gray-800 mb-8">
          📝 TodoList 待办事项
        </h1>
        
        <!-- 添加任务 -->
        <div class="flex gap-2 mb-6">
          <input
            v-model="newTodo"
            @keyup.enter="addTodo"
            type="text"
            placeholder="输入新任务..."
            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            @click="addTodo"
            class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
          >
            添加
          </button>
        </div>
        
        <!-- 筛选标签 -->
        <div class="flex gap-2 mb-4 justify-center">
          <button
            v-for="filter in filters"
            :key="filter.value"
            @click="currentFilter = filter.value"
            :class="[
              'px-4 py-1 rounded-full text-sm transition-colors',
              currentFilter === filter.value
                ? 'bg-blue-500 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            {{ filter.label }}
          </button>
        </div>
        
        <!-- 任务列表 -->
        <div class="space-y-2">
          <TodoItem
            v-for="todo in filteredTodos"
            :key="todo.id"
            :todo="todo"
            @toggle="toggleTodo"
            @delete="deleteTodo"
            @edit="editTodo"
          />
        </div>
        
        <!-- 空状态 -->
        <div v-if="filteredTodos.length === 0" class="text-center py-12 text-gray-500">
          <p class="text-lg">{{ emptyMessage }}</p>
        </div>
        
        <!-- 统计 -->
        <div v-if="todos.length > 0" class="mt-6 pt-4 border-t border-gray-200">
          <p class="text-sm text-gray-600 text-center">
            共 {{ todos.length }} 个任务 · <span class="text-green-600">{{ completedCount }} 已完成</span> · 
            <span class="text-orange-600">{{ pendingCount }} 待完成</span>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import TodoItem from './components/TodoItem.vue'

const todos = ref([])
const newTodo = ref('')
const currentFilter = ref('all')

const filters = [
  { value: 'all', label: '全部' },
  { value: 'active', label: '待完成' },
  { value: 'completed', label: '已完成' }
]

const filteredTodos = computed(() => {
  switch (currentFilter.value) {
    case 'active':
      return todos.value.filter(t => !t.completed)
    case 'completed':
      return todos.value.filter(t => t.completed)
    default:
      return todos.value
  }
})

const emptyMessage = computed(() => {
  switch (currentFilter.value) {
    case 'active':
      return '没有待完成的任务 🎉'
    case 'completed':
      return '还没有完成的任务'
    default:
      return '暂无任务，添加一个吧！'
  }
})

const completedCount = computed(() => todos.value.filter(t => t.completed).length)
const pendingCount = computed(() => todos.value.filter(t => !t.completed).length)

// API 调用
const API_URL = '/api/todos'

const fetchTodos = async () => {
  try {
    const response = await axios.get(API_URL)
    todos.value = response.data
  } catch (error) {
    console.error('获取任务失败:', error)
  }
}

const addTodo = async () => {
  if (!newTodo.value.trim()) return
  
  try {
    const response = await axios.post(API_URL, {
      title: newTodo.value.trim()
    })
    todos.value.unshift(response.data)
    newTodo.value = ''
  } catch (error) {
    console.error('添加任务失败:', error)
  }
}

const toggleTodo = async (todo) => {
  try {
    const response = await axios.put(`${API_URL}/${todo.id}`, {
      completed: !todo.completed
    })
    const index = todos.value.findIndex(t => t.id === todo.id)
    if (index !== -1) {
      todos.value[index] = response.data
    }
  } catch (error) {
    console.error('更新任务失败:', error)
  }
}

const deleteTodo = async (id) => {
  try {
    await axios.delete(`${API_URL}/${id}`)
    todos.value = todos.value.filter(t => t.id !== id)
  } catch (error) {
    console.error('删除任务失败:', error)
  }
}

const editTodo = async (todo) => {
  const newTitle = prompt('编辑任务:', todo.title)
  if (newTitle === null || newTitle.trim() === '') return
  
  try {
    const response = await axios.put(`${API_URL}/${todo.id}`, {
      title: newTitle.trim()
    })
    const index = todos.value.findIndex(t => t.id === todo.id)
    if (index !== -1) {
      todos.value[index] = response.data
    }
  } catch (error) {
    console.error('编辑任务失败:', error)
  }
}

onMounted(fetchTodos)
</script>
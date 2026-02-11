<template>
  <div
    class="flex items-center gap-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors group"
  >
    <input
      type="checkbox"
      :checked="todo.completed"
      @change="$emit('toggle', todo)"
      class="w-5 h-5 text-blue-500 rounded focus:ring-blue-500 cursor-pointer"
    />
    
    <span
      :class="[
        'flex-1 text-lg',
        todo.completed ? 'line-through text-gray-400' : 'text-gray-800'
      ]"
    >
      {{ todo.title }}
    </span>
    
    <span class="text-xs text-gray-400">
      {{ formatDate(todo.created_at) }}
    </span>
    
    <div class="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
      <button
        @click="$emit('edit', todo)"
        class="p-1 text-blue-500 hover:bg-blue-100 rounded"
        title="编辑"
      >
        ✏️
      </button>
      <button
        @click="$emit('delete', todo.id)"
        class="p-1 text-red-500 hover:bg-red-100 rounded"
        title="删除"
      >
        🗑️
      </button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  todo: {
    type: Object,
    required: true
  }
})

defineEmits(['toggle', 'delete', 'edit'])

const formatDate = (dateStr) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>
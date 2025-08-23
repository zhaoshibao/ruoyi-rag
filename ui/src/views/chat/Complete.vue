<template>
  <div>
    <textarea 
      ref="textInput"
      v-model="inputText"
      @keydown.tab.prevent="handleTabPress" 
      @keydown.ctrl.prevent="showOptions"
      placeholder="输入文本后按 Tab 键补全,按 Ctrl 键显示补全选项"
      rows="10"
      style="width: 100%; padding: 10px; font-family: monospace;"
    ></textarea>
    
    <div v-if="loading" class="loading">AI 思考中...</div>
    
    <!-- 多候选项面板 -->
    <div v-if="optionsVisible" class="options-panel">
      <div 
        v-for="(option, index) in completions" 
        :key="index"
        class="option-item"
        :class="{ selected: selectedOption === index }"
        @click="applyCompletion(option.completion)"
      >
        <pre>{{ option.completion }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue';
import axios from 'axios';

const inputText = ref('');
const textInput = ref(null);
const loading = ref(false);
const optionsVisible = ref(false);
const selectedOption = ref(0);
// 补全选项
const completions = ref([]);

// 获取当前光标位置
const getCursorPosition = () => {
  return textInput.value.selectionStart;
};

// Tab键补全处理
const handleTabPress = async () => {
  if (!inputText.value) return;
  
  const cursorPos = getCursorPosition();
  loading.value = true;
  
  try {
    const response = await axios.post('/api/ai/complete', {
      text: inputText.value,
      cursorPosition: cursorPos
    });
    
    inputText.value = response.data.fullText;
    moveCursor(cursorPos + response.data.completion.length);
  } finally {
    loading.value = false;
  }
};

// 显示多补全选项
const showOptions = async () => {
  console.log('显示多补全选项');
  
  const cursorPos = getCursorPosition();
  loading.value = true;
  
  try {
    const response = await axios.post('/api/ai/complete-options', {
      text: inputText.value,
      cursorPosition: cursorPos
    });
    
    completions.value = response.data;
    optionsVisible.value = true;
    selectedOption.value = 0;
  } finally {
    loading.value = false;
  }
};

// 应用选中的补全
const applyCompletion = (completion) => {
  const cursorPos = getCursorPosition();
  inputText.value = 
    inputText.value.substring(0, cursorPos) + 
    completion + 
    inputText.value.substring(cursorPos);
  
  optionsVisible.value = false;
  moveCursor(cursorPos + completion.length);
};

// 移动光标位置
const moveCursor = (position) => {
  nextTick(() => {
    textInput.value.focus();
    textInput.value.setSelectionRange(position, position);
  });
};

// 在<script setup>部分添加

// 键盘导航候选项
const handleKeyNavigation = (event) => {
  if (!optionsVisible.value) return;
  
  if (event.key === 'ArrowDown') {
    event.preventDefault();
    selectedOption.value = (selectedOption.value + 1) % completions.value.length;
  } else if (event.key === 'ArrowUp') {
    event.preventDefault();
    selectedOption.value = (selectedOption.value - 1 + completions.value.length) % completions.value.length;
  } else if (event.key === 'Enter' && completions.value.length > 0) {
    event.preventDefault();
    applyCompletion(completions.value[selectedOption.value].completion);
  } else if (event.key === 'Escape') {
    event.preventDefault();
    optionsVisible.value = false;
  }
};

// 在onMounted中添加事件监听
onMounted(() => {
  window.addEventListener('keydown', handleKeyNavigation);
  
  // 添加一个额外的键盘事件监听器来捕获Ctrl+Space
  textInput.value.addEventListener('keydown', (event) => {
    // 检测Ctrl+Space组合键
    if (event.ctrlKey && event.code === 'Space') {
      console.log('捕获到Ctrl+Space组合键');
      event.preventDefault(); // 阻止默认行为
      showOptions(); // 手动调用showOptions方法
    }
  });
});

// 在组件卸载时移除事件监听
onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyNavigation);
  
  // 移除额外添加的事件监听器
  if (textInput.value) {
    textInput.value.removeEventListener('keydown', null);
  }
});
</script>

<style scoped>
.loading {
  padding: 8px;
  color: #666;
  font-style: italic;
}

.options-panel {
  border: 1px solid #ddd;
  border-radius: 4px;
  max-height: 300px;
  overflow-y: auto;
  margin-top: 5px;
}

.option-item {
  padding: 8px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.option-item:hover {
  background: #f5f5f5;
}

.option-item.selected {
  background: #e6f7ff;
}

pre {
  margin: 0;
  font-family: inherit;
  white-space: pre-wrap;
}
</style>
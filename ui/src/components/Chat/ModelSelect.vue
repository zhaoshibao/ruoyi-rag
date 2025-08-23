<template>
  <div class="模型-container">
    <div class="model" @click="toggleModelBox">
      {{ selectedModel }}
      <svg
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="icon-md text-token-text-tertiary"
        :class="{'rotate-arrow': showModelBox}"
      >
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M5.29289 9.29289C5.68342 8.90237 6.31658 8.90237 6.70711 9.29289L12 14.5858L17.2929 9.29289C17.6834 8.90237 18.3166 8.90237 18.7071 9.29289C19.0976 9.68342 19.0976 10.3166 18.7071 10.7071L12.7071 16.7071C12.5196 16.8946 12.2652 17 12 17C11.7348 17 11.4804 16.8946 11.2929 16.7071L5.29289 10.7071C4.90237 10.3166 4.90237 9.68342 5.29289 9.29289Z"
          fill="currentColor"
        ></path>
      </svg>
    </div>
    <div class="model-box" v-if="showModelBox">
      <ul>
        <li v-for="model in models" :key="model.projectId" @click="selectModel(model)">
          <h2>{{ model.projectName }}</h2>
          <div class="model-info">{{ model.model }} ({{ model.type }})</div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { useChatStore } from '@/store/chat';
import { ref, onMounted } from 'vue';
import { fetchProjects } from '@/api/chat/chat'; // 导入获取项目的函数

  const chatStore = useChatStore(); // 获取 chatStore
  const showModelBox = ref(false);
  const models = ref([]); // 存储模型列表
  const selectedModel = ref(''); // 默认选择第一个模型

  // 切换模型选择框显示状态
  const toggleModelBox = () => {
    showModelBox.value = !showModelBox.value;
  };

  // 选择模型
  const selectModel = (model) => {
    selectedModel.value = model.projectName;
    chatStore.projectId = model.projectId; // 设置 projectId
    showModelBox.value = false; // 选择后隐藏模型框
    console.log(`Selected model: ${selectedModel.value}, Project ID: ${chatStore.projectId}`);
  };

  // 获取模型列表
  const getModels = async () => {
    try {
      const response = await fetchProjects(); // 获取项目数据
      if (response.code === 200) {
        models.value = response.rows; // 从返回数据中获取模型数组
        if (models.value.length > 0) {
          selectedModel.value = models.value[0].projectName;
          chatStore.projectId = models.value[0].projectId;
        }
      } else {
        console.error('获取模型失败:', response.msg);
      }
    } catch (error) {
      console.error('获取模型失败:', error);
    }
  };

  // 组件挂载后获取模型列表
  onMounted(() => {
    getModels();
  });

</script>

<style scoped>
.model-box {
  color: #333;
  background-color: #fff;
  padding: 20px 10px;
  border-radius: 8px;
  position: absolute;
  bottom: 50px; /* 改为bottom，使其向上弹出 */
  border: 2px solid #f5f5f5;
  text-align: center;
  box-shadow: 2px 2px 5px rgba(245, 245, 245, 0.3);
  z-index: 1000; /* 确保弹出框在其他元素之上 */
}

.model-box li {
  padding: 10px 10px;
  cursor: pointer;
  text-align: left;
}
.model-box li:hover {
  background-color: #f5f5f5;
}
.model {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 10px 20px;
  border-radius: 10px;
}
.model:hover,
.model:active {
  background-color: #f5f5f5;
}
h2 {
  font-size: 18px;
}
.model-info {
  margin-top: 0;
  font-size: 16px;
  color: #666;
}
/* 添加箭头旋转动画 */
.rotate-arrow {
  transform: rotate(180deg);
  transition: transform 0.3s ease;
}
</style>

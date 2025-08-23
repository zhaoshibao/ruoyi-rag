<template>
  <div class="message-list">
    <div v-for="(message, index) in messages" :key="index" class="message-item" :class="message.sender">
      <div class="message-content" v-html="message.text"></div>
      <span v-if="message.isTyping" class="cursor">_</span> <!-- 添加光标 -->
    </div>
  </div>
</template>

<script>
export default {
  props: {
    messages: {
      type: Array,
      default: () => [],
    },
  },
};
</script>

<style scoped>
.message-list {
  max-height: 100%;
  overflow-y: auto;
  padding: 10px;
}

.message-item {
  margin-bottom: 15px;
  position: relative; /* 为光标设置相对定位 */
}

.message-item.user {
  text-align: right;
}

.message-item.chatgpt {
  text-align: left;
}

.message-content {
  display: inline-block;
  padding: 10px;
  border-radius: 10px;
  line-height: 1.5;
}

.user .message-content {
  background-color: #d1eaff;
}

.cursor {
  display: inline-block;
  animation: blink 1s step-end infinite; /* 添加闪烁动画 */
  position: absolute; /* 绝对定位光标 */
  bottom: 5px; /* 光标相对于消息底部的位置 */
  right: 10px; /* 光标相对于消息右侧的位置 */
}
.code-block {
  background-color: #f5f5f5; /* 背景颜色 */
  border-radius: 5px; /* 圆角边框 */
  padding: 10px; /* 内边距 */
  margin: 10px 0; /* 外边距 */
  overflow: auto; /* 允许滚动 */
}

@keyframes blink {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
}

/* 响应式布局：适配不同屏幕 */
@media (max-width: 768px) {
  .message-content {
    max-width: 80%;
    font-size: 14px;
  }
}
</style>

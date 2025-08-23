<template>
  <ul class="message-list" ref="messageListRef">
    <li :class="message.sender === 'user' ? 'ask' : 'answer'" v-for="(message, index) in messages" :key="index">
      <div :class="message.sender === 'user' ? 'askIcon' : 'answerIcon'">
        <el-icon v-if="message.sender === 'user'">
          <User />
        </el-icon>
        <el-icon v-else>
          <Service/>
        </el-icon>
      </div>
      <div class="message-wrapper">
        <MdPreview ref="editorRef"
          editorId="preview-only"
          previewTheme="github"
          :showCodeRowNumber="false"
          :modelValue="message.text"
          :key="message.id"
        />
        <div class="message-actions">
          <el-tooltip
            content="复制内容"
            placement="top"
            :hide-after="1000"
          >
            <el-button type="text" @click="copyMessage(message.text)">
              <el-icon><DocumentCopy /></el-icon>
            </el-button>
          </el-tooltip>
          <el-tooltip
            v-if="message.sender === 'chatgpt'"
            content="重新生成"
            placement="top"
            :hide-after="1000"
          >
            <el-button type="text" @click="regenerateMessage(message, index)">
              <el-icon><RefreshRight /></el-icon>
            </el-button>
          </el-tooltip>
        </div>
        <span v-if="message.isTyping" class="cursor">_</span>
      </div>
    </li>
  </ul>
</template>

<script setup>
import { onMounted, watch, ref, nextTick, onBeforeUnmount } from "vue";
import { MdPreview } from 'md-editor-v3';
import { DocumentCopy, RefreshRight, User, Service } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';
import { useChatStore } from '@/store/chat';
import 'md-editor-v3/lib/preview.css';

const messageListRef = ref(null);
const props = defineProps(["messages"]);
const shouldAutoScroll = ref(true);
const chatStore = useChatStore();

// 复制消息内容
const copyMessage = async (text) => {
  try {
    await navigator.clipboard.writeText(text);
    ElMessage.success('复制成功');
  } catch (err) {
    console.error('复制失败:', err);
    ElMessage.error('复制失败');
  }
};

// 重新生成消息
const regenerateMessage = async (message, index) => {
  if (chatStore.isSending) {
    ElMessage.warning('请等待当前消息生成完成');
    return;
  }
  
  // 获取上一条用户消息
  const userMessage = props.messages.slice(0, index).reverse()
    .find(msg => msg.sender === 'user');
    
  if (userMessage) {
    // 重新发送用户消息
    await chatStore.sendMessageToChatGPT({
      msg: userMessage.text,
      useWebSearch: false
    });
  }
};

const scrollToBottom = async () => {
  if (messageListRef.value && shouldAutoScroll.value) {
    await nextTick();
    messageListRef.value.scrollTop = messageListRef.value.scrollHeight;
  }
};

// 检测用户是否手动滚动
const handleScroll = () => {
  if (!messageListRef.value) return;
  
  const element = messageListRef.value;
  const { scrollTop, scrollHeight, clientHeight } = element;
  // 如果用户向上滚动超过200px，则停止自动滚动
  shouldAutoScroll.value = scrollHeight - scrollTop - clientHeight < 200;
};

onMounted(() => {
  scrollToBottom();
  // 添加滚动事件监听
  messageListRef.value?.addEventListener('scroll', handleScroll);
});

onBeforeUnmount(() => {
  // 移除滚动事件监听
  messageListRef.value?.removeEventListener('scroll', handleScroll);
});

// 监听消息变化自动滚动到底部
watch(() => props.messages, () => {
  scrollToBottom();
}, { deep: true });

</script>

<style scoped>
.message-list {
  max-height: 100%;
  overflow-y: auto; /* 只在需要时显示纵向滚动条 */
  overflow-x: hidden; /* 禁止横向滚动 */
  padding: 10px;
  list-style: none; /* 移除列表样式 */
  margin: 0; /* 移除默认外边距 */
}

.user .message-content {
  background-color: #d1eaff;
}

.cursor {
  display: inline-block;
  animation: blink 1s step-end infinite;
  position: absolute;
  bottom: 5px;
  right: 10px;
}

.code-block {
  background-color: #f5f5f5;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  overflow-x: auto; /* 代码块允许横向滚动 */
  max-width: 100%; /* 限制最大宽度 */
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}

/* 响应式布局：适配不同屏幕 */
@media (max-width: 768px) {
  .message-content {
    max-width: 80%;
    font-size: 14px;
  }
}
</style>

<style lang="scss" scoped>
li {
  margin-bottom: 20px;
  max-width: 100%; /* 限制最大宽度 */
}

li.ask {
  display: flex;
  flex-direction: row-reverse;
  text-align: right;

  .askIcon {
    margin-left: 20px;
    font-size: 30px;
    flex-shrink: 0; /* 防止图标缩小 */
  }

  .askContent {
    border: 1px solid #aaa;
    border-radius: 20px;
    padding: 20px 20px 0 20px;
    background-color: #eee;
    line-height: 20px;
    max-width: 80%; /* 限制消息内容宽度 */
    word-wrap: break-word; /* 允许长单词换行 */
    overflow-wrap: break-word; /* 现代浏览器的长单词换行 */
  }
}

li.answer {
  display: flex;
  text-align: left;

  .answerIcon {
    margin-right: 20px;
    font-size: 30px;
    flex-shrink: 0; /* 防止图标缩小 */

    :deep(.el-loading-spinner) {
      left: -5px;
    }
  }

  .answerContent {
    border: 1px solid #aaa;
    border-radius: 20px;
    padding: 20px;
    background-color: #eee;
    line-height: 25px;
    max-width: 80%; /* 限制消息内容宽度 */
    word-wrap: break-word; /* 允许长单词换行 */
    overflow-wrap: break-word; /* 现代浏览器的长单词换行 */
  }
}

.message-md .md-editor-preview-wrapper {
  color: var(--gray-900);
  max-width: 100%;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Noto Sans SC', 'PingFang SC', 'Noto Sans SC', 'Microsoft YaHei', 'Hiragino Sans GB', 'Source Han Sans CN', 'Courier New', monospace;

  #preview-only-preview {
    font-size: 15px;
  }

  h1, h2 {
    font-size: 1.2rem;
  }

  h3, h4 {
    font-size: 1.1rem;
  }

  h5, h6 {
    font-size: 1rem;
  }

  a {
    color: var(--main-700);
  }

  code {
    font-size: 13px;
    font-family: 'Menlo', 'Monaco', 'Consolas', 'PingFang SC', 'Noto Sans SC', 'Microsoft YaHei', 'Hiragino Sans GB', 'Source Han Sans CN', 'Courier New', monospace;
    line-height: 1.5;
    letter-spacing: 0.025em;
    tab-size: 4;
    -moz-tab-size: 4;
    background-color: var(--gray-100);
  }
}

.message-wrapper {
  position: relative;
  flex: 1;
  max-width: 80%;
}

.message-actions {
  display: none;
  position: absolute;
  bottom: -30px;
  padding: 4px 8px;
  background-color: #f5f5f5;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  z-index: 1;
}

li.ask:hover .message-actions,
li.answer:hover .message-actions {
  display: flex;
  gap: 8px;
}

li.ask .message-actions {
  right: 0; /* 用户消息的操作按钮靠右对齐 */
}

li.answer .message-actions {
  left: 0; /* AI消息的操作按钮靠左对齐 */
}

.message-actions .el-button {
  padding: 4px 8px;
}

.message-actions .el-icon {
  font-size: 16px;
}
</style>

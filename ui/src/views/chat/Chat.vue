<template>
  <el-container class="chat-page">
    <el-aside :class="['chat-aside', { 'is-collapsed': isChatListCollapsed }]" :style="{ width: isChatListCollapsed ? '0' : sidebarWidth }">
        <chat-list
          ref="chatListRef"
          @select-chat="handleSelectChat"
        />
    </el-aside>
    <div class="collapse-button" @click="handleChatListCollapse">
      <el-icon :class="{ 'is-collapse': isChatListCollapsed }">
        <CaretLeft />
      </el-icon>
    </div>
    <el-container class="main-container">
      <el-main class="chat-main">
        <message-list :messages="messages" />
      </el-main>
      <el-footer class="chat-footer" :class="{ 'is-collapsed': isChatListCollapsed }">
        <div class="input-container">
          <chat-input @send="handleSendMessage" :disabled="chatStore.isSending">
            <template #left>
              <model-select />
            </template>
          </chat-input>
          <!-- <div v-if="chatStore.isSending" class="stop-button">
            <el-button @click="stopSending" type="danger" :icon="Close" circle>
              停止生成
            </el-button>
          </div> -->
        </div>
      </el-footer>
    </el-container>
    
  </el-container>
</template>

<script setup>
  import { ref, watch, onUnmounted } from 'vue';
  import ChatInput from '@/components/Chat/ChatInput.vue';
  import MessageList from '@/components/Chat/MessageList.vue';
  import ChatList from '@/components/Chat/ChatList.vue';
  import { useChatStore } from '@/store/chat';
  import { Close } from '@element-plus/icons-vue';
  import ModelSelect from "@/components/Chat/ModelSelect.vue";
  const chatStore = useChatStore();
  const messages = ref(chatStore.messages);
  const sidebarWidth = ref('300px');
  const chatListRef = ref(null);
  
  // 使用独立的状态控制聊天记录列表的显示
  const isChatListCollapsed = ref(false);
  

  // 只控制聊天记录列表的展开/收起
  const handleChatListCollapse = () => {
    isChatListCollapsed.value = !isChatListCollapsed.value;
  };

  // 监听 chatStore 的 messages 变化
  watch(() => chatStore.messages, (newMessages) => {
    messages.value = newMessages;
  });
  
  const handleSendMessage = async (message, useWebSearch = false) => {
    const chatId = chatStore.chatId;
    const language = 0;
    const msg = message;

    const messagePayload = {
      chatId,
      language,
      msg,
      useWebSearch, // 添加联网搜索参数
    };

    await chatStore.sendMessageToChatGPT(messagePayload);
    
  };
  
  
  // 停止发送
  const stopSending = () => {
    console.log('🛑 用户点击停止按钮');
    
    // 通用：调用store的停止方法（会处理AbortController和状态重置）
    chatStore.stopCurrentSSE();
    
    // 强制更新UI以确保按钮状态正确
    console.log('停止后isSending状态:', chatStore.isSending);
  };
  
  // 组件卸载时清理连接
  onUnmounted(() => {
    // 无
  });

</script>

<style scoped>
.chat-page {
  display: flex;
  height: 100vh;
  overflow: hidden; /* 防止整体出现滚动条 */
}

.chat-aside {
  border-right: 1px solid #dcdfe6;
  background-color: #fff;
  transition: width 0.3s;
  overflow: hidden; /* 防止侧边栏出现横向滚动条 */
  display: flex;
  flex-direction: column;
}

.sidebar-content {
  flex: 1;
  background-color: #f5f7fa;
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.sidebar-wrapper {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.sidebar-wrapper > * {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow-y: auto;
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: absolute;
  width: 100%;
  height: 100%;
}

.fade-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.fade-enter-to,
.fade-leave-from {
  opacity: 1;
  transform: translateX(0);
}

.main-container {
  position: relative;
  overflow: hidden; /* 防止主容器出现横向滚动条 */
  width: 100%; /* 确保容器占满可用空间 */
}

.chat-main {
  flex: 1;
  padding: 20px 0;
  overflow-x: hidden; /* 禁止横向滚动 */
  overflow-y: auto; /* 允许纵向滚动 */
  height: calc(100vh - 180px); /* 调整高度，为底部留出更多空间 */
  padding-bottom: 100px; /* 增加底部内边距，防止最后的消息被输入框遮挡 */
}

.chat-footer {
  position: absolute;
  bottom: 0;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: #fff;
  padding: 10px 0;
  /* box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05); 添加轻微阴影，提升层次感 */
}

.input-container {
  display: flex;
  align-items: center;
  gap: 15px;
  width: 100%;
  max-width: 1000px;
  margin-bottom: 60px; /* 减小底部边距 */
  position: relative; /* 添加相对定位 */
}

.stop-button {
  position: absolute;
  right: -70px; /* 调整按钮位置 */
  top: 50%;
  transform: translateY(-50%);
}

.stop-button .el-button {
  padding: 8px 16px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.collapse-button {
  position: absolute;
  left: 300px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 50px;
  background-color: #f2f2f2;
  border-radius: 0 4px 4px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
}

.collapse-button:hover {
  background-color: #e6e6e6;
}

.collapse-button .el-icon {
  transition: transform 0.3s;
}

.collapse-button .is-collapse {
  transform: rotate(180deg);
}

/* 当侧边栏收起时，调整按钮位置 */
.is-collapsed + .collapse-button {
  left: 0;
}

.chat-aside {
  transition: all 0.3s;
  overflow: hidden;
  position: relative;
}

.chat-aside.is-collapsed {
  padding: 0;
  margin: 0;
}

.collapse-button {
  position: absolute;
  left: 300px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 50px;
  background-color: #f2f2f2;
  border-radius: 0 4px 4px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
}

.collapse-button:hover {
  background-color: #e6e6e6;
}

.collapse-button .el-icon {
  transition: transform 0.3s;
}

.collapse-button .is-collapse {
  transform: rotate(180deg);
}

/* 当侧边栏收起时，调整按钮位置 */
.is-collapsed + .collapse-button {
  left: 0;
}
</style>

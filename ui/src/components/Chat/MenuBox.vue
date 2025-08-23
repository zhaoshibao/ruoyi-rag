<template>
  <div class="menu-box" :class="{ 'menu-box-hidden': isHidden.value }">
    <div class="icon-box">
      <div class="icon-column1" v-if="!isHidden.value">
        <el-button type="primary" size="small" @click="createNewChat" class="new-chat-btn">
          <el-icon><Plus /></el-icon> 新建会话
        </el-button>
      </div>
      <!--<div class="icon-column2">
        <el-tooltip :content="isHidden.value ? '展开侧边栏' : '折叠侧边栏'" placement="right">
          <div class="toggle-btn" @click="toggleSidebar">
            <el-icon v-if="!isHidden.value"><ArrowLeft /></el-icon>
            <el-icon v-else><ArrowRight /></el-icon>
          </div>
        </el-tooltip>
      </div>-->
    </div>
  </div>
</template>

<script>
import { ArrowLeft, ArrowRight, Plus } from "@element-plus/icons-vue";
import { useChatStore } from "@/store/chat";

export default {
  components: {
    ArrowLeft,
    ArrowRight,
    Plus
  },
  props: {
    isHidden: {
      type: Object, // 修改为Object类型以接收ref对象
      required: true,
    },
  },
  methods: {
    toggleSidebar() {
      this.$emit("toggle-sidebar");
    },
    async createNewChat() {
      const chatStore = useChatStore();
      try {
        await chatStore.createNewChat();
      } catch (error) {
        console.error("创建新聊天失败:", error);
      }
    },
  },
};
</script>

<style scoped>
.menu-box {
  padding: 16px;
  border-bottom: 1px solid #ebeef5;
  background-color: #fff;
  display: flex;
  justify-content: space-between;
}

.menu-box-hidden {
  padding: 8px;
  justify-content: center;
}

.icon-box {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.icon-column1 {
  flex: 1;
}

.icon-column2 {
  display: flex;
  justify-content: flex-end;
}

.new-chat-btn {
  width: 100%;
  max-width: 180px;
  height: 32px;
}

.toggle-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 4px;
  cursor: pointer;
  color: #606266;
  transition: all 0.3s;
}

.toggle-btn:hover {
  background-color: #f2f6fc;
  color: #409eff;
}
</style>

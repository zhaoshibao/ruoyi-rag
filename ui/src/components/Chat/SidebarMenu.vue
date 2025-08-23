<template>
  <div class="sidebar-menu" :class="{ 'sidebar-hidden': isHidden }">
    <div class="menu-header">
      <div class="logo">
        <img src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" alt="Logo" class="logo-img" />
        <span v-if="!isHidden" class="logo-text">RAG助手</span>
      </div>
      <el-button 
        type="text" 
        class="toggle-btn"
        @click="$emit('toggle-sidebar')"
      >
        <el-icon><Fold /></el-icon>
      </el-button>
    </div>
    
    <div class="menu-items">
      <div 
        v-for="item in menuItems" 
        :key="item.key"
        :class="['menu-item', { active: props.activeMenu === item.key }]"
        @click="switchMenu(item.key)"
      >
        <el-icon class="menu-icon"><component :is="item.icon" /></el-icon>
        <span v-if="!isHidden" class="menu-label">{{ item.label }}</span>
      </div>
    </div>
    
    <div class="user-profile" @click="showUserMenu = !showUserMenu">
      <el-avatar :size="isHidden ? 30 : 40" src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" />
      <span v-if="!isHidden">熊猫助手</span>
      <div v-if="showUserMenu && !isHidden" class="user-menu">
        <div class="menu-item" @click.stop="openUserSettings">
          <el-icon><Setting /></el-icon>
          <span>账号设置</span>
        </div>
        <div class="menu-item" @click.stop="logout">
          <el-icon><SwitchButton /></el-icon>
          <span>退出账号</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { 
  ChatDotRound, 
  Folder, 
  Collection, 
  Setting, 
  SwitchButton,
  Fold
} from '@element-plus/icons-vue';

export default {
  components: {
    ChatDotRound,
    Folder,
    Collection,
    Setting,
    SwitchButton,
    Fold
  },
  props: {
    isHidden: {
      type: Boolean,
      default: false
    },
    activeMenu: {
      type: String,
      default: 'chat'
    }
  },
  emits: ['menu-change', 'toggle-sidebar', 'open-settings'],
  setup(props, { emit }) {
    const showUserMenu = ref(false);

    const menuItems = [
      { key: 'chat', label: '聊天记录', icon: 'ChatDotRound' },
      { key: 'project', label: '项目管理', icon: 'Folder' },
      { key: 'knowledge', label: '知识库管理', icon: 'Collection' }
    ];

    const switchMenu = (key) => {
      if (key !== props.activeMenu) {
        console.log('切换菜单到:', key);
        emit('menu-change', key);
      }
    };

    const openUserSettings = () => {
      showUserMenu.value = false;
      emit('open-settings');
    };

    const logout = () => {
      showUserMenu.value = false;
      // 实现退出登录逻辑
      console.log('退出登录');
    };

    // 点击页面其他地方关闭用户菜单
    const handleClickOutside = (event) => {
      if (showUserMenu.value && !event.target.closest('.user-profile')) {
        showUserMenu.value = false;
      }
    };

    // 添加和移除全局点击事件监听器
    onMounted(() => {
      document.addEventListener('click', handleClickOutside);
    });

    onUnmounted(() => {
      document.removeEventListener('click', handleClickOutside);
    });

    return {
      props,
      menuItems,
      switchMenu,
      showUserMenu,
      openUserSettings,
      logout
    };
  }
};
</script>

<style scoped>
.sidebar-menu {
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #001529;
  color: #fff;
  width: 100%;
  transition: all 0.3s;
}

.sidebar-hidden {
  width: 60px;
}

.menu-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo {
  display: flex;
  align-items: center;
}

.logo-img {
  width: 24px;
  height: 24px;
  margin-right: 8px;
}

.logo-text {
  font-size: 16px;
  font-weight: bold;
}

.toggle-btn {
  color: #fff;
}

.menu-items {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding-top: 20px;
  overflow-y: auto;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  cursor: pointer;
  transition: all 0.3s;
  gap: 10px;
  border-radius: 4px;
  margin: 4px 8px;
}

.menu-icon {
  font-size: 18px;
}

.menu-label {
  font-size: 14px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.menu-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.menu-item.active {
  background-color: #1890ff;
}

.user-profile {
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  position: relative;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.user-menu {
  position: absolute;
  bottom: 100%;
  left: 0;
  width: 100%;
  background-color: #001529;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 10;
}

.user-menu .menu-item {
  padding: 10px 16px;
}
</style>
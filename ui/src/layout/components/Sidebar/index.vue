<template>
  <div :class="{ 'has-logo': showLogo }" class="sidebar-container">
    <!-- 导航菜单 -->
    <div class="sidebar-menu">
      <el-menu
        :collapse="isCollapse"
        :background-color="getMenuBackground"
        :text-color="getMenuTextColor"
        :active-text-color="theme"
        :collapse-transition="false"
        mode="vertical"
        :class="sideTheme"
        router
      >
        <el-menu-item index="/chat/index">
          <el-icon><ChatLineRound /></el-icon>
          <template #title>聊天记录</template>
        </el-menu-item>
        <el-menu-item index="/project/index">
          <el-icon><Folder /></el-icon>
          <template #title>项目管理</template>
        </el-menu-item>
        <el-menu-item index="/knowledge/index">
          <el-icon><Files /></el-icon>
          <template #title>知识库管理</template>
        </el-menu-item>
         <el-menu-item index="/image/index">
          <el-icon><Picture /></el-icon>
          <template #title>图片生成</template>
        </el-menu-item>
        <el-menu-item index="/summarizer/index">
          <el-icon><Document /></el-icon>
          <template #title>文档总结</template>
        </el-menu-item>

      </el-menu>
    </div>
    
    <!-- 用户信息 -->
    <div class="sidebar-user" :class="{ 'is-collapse': isCollapse }">
      <el-dropdown trigger="click" @command="handleCommand">
        <div class="user-info">
          <el-avatar :size="32" src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" />
          <span v-if="!isCollapse" class="username">{{ userStore.name }}</span>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="git">
              <svg-icon icon-class="github"/>&nbsp;源码地址
            </el-dropdown-item>
            <el-dropdown-item divided command="settings">
              <el-icon><Setting /></el-icon>个人设置
            </el-dropdown-item>
           
            <el-dropdown-item divided command="logout">
              <el-icon><SwitchButton /></el-icon>退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
    <user-profile-dialog v-model:visible="showProfileDialog" />
  </div>
</template>

<script setup>
import { ElMessageBox } from 'element-plus'
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/assets/styles/variables.module.scss'
import useAppStore from '@/store/modules/app'
import useSettingsStore from '@/store/modules/settings'
import usePermissionStore from '@/store/modules/permission'
import { Setting, SwitchButton } from '@element-plus/icons-vue'
import useUserStore from '@/store/modules/user'
import UserProfileDialog from '@/components/UserProfile/UserProfileDialog.vue'
import { ChatLineRound, Folder, Files } from '@element-plus/icons-vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const appStore = useAppStore()

const settingsStore = useSettingsStore()
const permissionStore = usePermissionStore()

const sidebarRouters = computed(() => permissionStore.sidebarRouters)
const showLogo = computed(() => settingsStore.sidebarLogo)
const sideTheme = computed(() => settingsStore.sideTheme)
const theme = computed(() => settingsStore.theme)
const isCollapse = computed(() => !appStore.sidebar.opened)

// 获取菜单背景色
const getMenuBackground = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-bg)'
  }
  return sideTheme.value === 'theme-dark' ? variables.menuBg : variables.menuLightBg
})

// 获取菜单文字颜色
const getMenuTextColor = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-text)'
  }
  return sideTheme.value === 'theme-dark' ? variables.menuText : variables.menuLightText
})

const activeMenu = computed(() => {
  const { meta, path } = route
  if (meta.activeMenu) {
    return meta.activeMenu
  }
  return path
})

const userStore = useUserStore()
const showProfileDialog = ref(false)

// 处理下拉菜单命令
const handleCommand = (command) => {
  if (command === 'settings') {
    router.push('/user/profile')
  } else if (command === 'logout') {
    // 处理登出逻辑
    logout()
  } else if (command === 'git') {
    window.open('https://github.com/zhaoshibao/ruoyi-rag')
  }
}


function logout() {
  ElMessageBox.confirm('确定注销并退出系统吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    userStore.logOut().then(() => {
      location.href = '/web/index'
    })
  }).catch(() => { })
}
</script>

<style lang="scss" scoped>
.sidebar-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: v-bind(getMenuBackground);
}

.sidebar-menu {
  flex: 1;
  overflow-y: auto;
  
  .el-menu {
    border: none;
    
    .el-menu-item {
      display: flex;
      align-items: center;
      padding: 0 16px;
      height: 50px;
      
      .el-icon {
        font-size: 18px;
        margin-right: 12px;
      }
      
      &:hover, &.is-active {
        background-color: var(--menu-hover, rgba(0, 0, 0, 0.06)) !important;
      }
      
      &.is-active {
        color: var(--menu-active-text, #409eff);
      }
    }
  }
}

.sidebar-user {
  position: absolute;
  bottom: 0;
  width: 100%;
  padding: 12px 16px;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  background-color: v-bind(getMenuBackground);
  transition: all 0.3s;
  
  &.is-collapse {
    padding: 12px;
    
    .user-info {
      justify-content: center;
    }
  }
  
  .user-info {
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    
    .username {
      color: v-bind(getMenuTextColor);
      font-size: 14px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
}

:deep(.el-dropdown-menu__item) {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  
  .el-icon {
    margin-right: 4px;
  }
}
</style>

<template>
  <el-dialog
    title="个人中心"
    v-model="dialogVisible"
    width="500px"
    :close-on-click-modal="false"
    append-to-body
  >
    <div class="user-profile-form">
      <div class="avatar-container">
        <div class="avatar-title">头像</div>
        <div class="avatar-content">
          <el-avatar :size="80" :src="form.avatar" />
          <div class="avatar-actions">
            <el-icon><View /></el-icon>
            <el-icon><Delete /></el-icon>
          </div>
        </div>
      </div>
      
      <el-form :model="form" label-width="80px">
        <el-form-item label="名称">
          <el-input v-model="form.name" placeholder="请输入名称" />
          <el-button type="primary" link class="save-btn" size="small">保存</el-button>
        </el-form-item>
        
        <el-form-item label="主题">
          <el-radio-group v-model="form.theme" class="theme-group">
            <el-radio label="light" border>
              <el-icon><Sunny /></el-icon>
            </el-radio>
            <el-radio label="dark" border>
              <el-icon><Moon /></el-icon>
            </el-radio>
            <el-radio label="auto" border>
              <el-icon><Monitor /></el-icon>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="语言">
          <el-select v-model="form.language" placeholder="请选择语言">
            <el-option label="简体中文" value="zh-CN" />
          </el-select>
        </el-form-item>
      </el-form>
    </div>
  </el-dialog>
</template>

<script setup>
import { ref, defineProps, defineEmits } from 'vue'
import { View, Delete, Sunny, Moon, Monitor } from '@element-plus/icons-vue'

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:visible'])

const dialogVisible = computed({
  get: () => props.visible,
  set: (val) => emit('update:visible', val)
})

const form = ref({
  avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
  name: '熊猫助手',
  theme: 'light',
  language: 'zh-CN'
})
</script>

<style lang="scss" scoped>
.user-profile-form {
  padding: 20px;
  
  .avatar-container {
    margin-bottom: 24px;
    
    .avatar-title {
      font-size: 14px;
      color: #606266;
      margin-bottom: 12px;
    }
    
    .avatar-content {
      display: flex;
      align-items: center;
      gap: 16px;
      
      .avatar-actions {
        display: flex;
        gap: 12px;
        
        .el-icon {
          font-size: 20px;
          color: #606266;
          cursor: pointer;
          
          &:hover {
            color: #409eff;
          }
        }
      }
    }
  }
  
  .el-form-item {
    margin-bottom: 20px;
    position: relative;
    
    .save-btn {
      position: absolute;
      right: 0;
      top: 50%;
      transform: translateY(-50%);
    }
  }
  
  .theme-group {
    display: flex;
    gap: 12px;
    
    .el-radio {
      margin-right: 0;
      
      .el-icon {
        margin-right: 4px;
      }
    }
  }
}
</style>
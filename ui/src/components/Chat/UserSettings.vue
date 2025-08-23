<template>
  <el-dialog
    v-model="dialogVisible"
    title="个人设置"
    width="30%"
    :before-close="handleClose"
  >
    <el-tabs v-model="activeTab">
      <el-tab-pane label="个人中心" name="profile">
        <div class="profile-content">
          <div class="avatar-section">
            <div class="avatar-wrapper">
              <el-avatar :size="100" :src="userForm.avatar" />
              <div class="avatar-upload">
                <el-upload
                  class="avatar-uploader"
                  action="#"
                  :show-file-list="false"
                  :auto-upload="false"
                  :on-change="handleAvatarChange"
                >
                  <el-icon class="avatar-icon"><Camera /></el-icon>
                </el-upload>
              </div>
            </div>
          </div>
          
          <el-form :model="userForm" label-width="80px" class="user-form">
            <el-form-item label="昵称">
              <el-input v-model="userForm.nickname" placeholder="请输入昵称"></el-input>
            </el-form-item>
            
            <el-form-item label="主题">
              <el-radio-group v-model="userForm.theme" class="theme-selector">
                <el-radio-button label="light">
                  <el-icon><Sunny /></el-icon>
                </el-radio-button>
                <el-radio-button label="dark">
                  <el-icon><Moon /></el-icon>
                </el-radio-button>
                <el-radio-button label="auto">
                  <el-icon><MagicStick /></el-icon>
                </el-radio-button>
              </el-radio-group>
            </el-form-item>
            
            <el-form-item label="语言">
              <el-select v-model="userForm.language" placeholder="请选择语言">
                <el-option label="简体中文" value="zh-CN"></el-option>
                <el-option label="English" value="en-US"></el-option>
              </el-select>
            </el-form-item>
          </el-form>
          
          <div class="form-actions">
            <el-button type="primary" @click="saveUserSettings">保存</el-button>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>
  </el-dialog>
</template>

<script>
import { ref, watch } from 'vue';
import { Camera, Sunny, Moon, MagicStick } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';

export default {
  components: {
    Camera,
    Sunny,
    Moon,
    MagicStick
  },
  props: {
    visible: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:visible', 'save-settings'],
  setup(props, { emit }) {
    const dialogVisible = ref(false);
    const activeTab = ref('profile');
    
    const userForm = ref({
      avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
      nickname: '熊猫助手',
      theme: 'light',
      language: 'zh-CN'
    });
    
    // 监听visible属性变化
    watch(() => props.visible, (newVal) => {
      dialogVisible.value = newVal;
    });
    
    // 监听对话框状态变化
    watch(dialogVisible, (newVal) => {
      emit('update:visible', newVal);
    });
    
    // 处理对话框关闭
    const handleClose = () => {
      dialogVisible.value = false;
    };
    
    // 处理头像变化
    const handleAvatarChange = (file) => {
      // 这里应该上传头像到服务器，现在只是模拟
      const reader = new FileReader();
      reader.readAsDataURL(file.raw);
      reader.onload = () => {
        userForm.value.avatar = reader.result;
      };
    };
    
    // 保存用户设置
    const saveUserSettings = () => {
      // 这里应该调用API保存设置，现在只是模拟
      ElMessage.success('设置保存成功');
      emit('save-settings', userForm.value);
      dialogVisible.value = false;
    };
    
    return {
      dialogVisible,
      activeTab,
      userForm,
      handleClose,
      handleAvatarChange,
      saveUserSettings
    };
  }
};
</script>

<style scoped>
.profile-content {
  padding: 20px 0;
}

.avatar-section {
  display: flex;
  justify-content: center;
  margin-bottom: 30px;
}

.avatar-wrapper {
  position: relative;
  display: inline-block;
}

.avatar-upload {
  position: absolute;
  bottom: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  transition: all 0.3s;
}

.avatar-upload:hover {
  background-color: rgba(0, 0, 0, 0.7);
}

.avatar-icon {
  color: white;
  font-size: 16px;
}

.user-form {
  max-width: 400px;
  margin: 0 auto;
}

.theme-selector {
  display: flex;
  justify-content: center;
}

.form-actions {
  text-align: center;
  margin-top: 20px;
}
</style>
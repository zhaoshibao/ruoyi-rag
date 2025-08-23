<template>
  <div class="image-generation">
    <el-card class="box-card">
      <div class="input-area">
        <el-form :model="form" label-width="80px">
          <el-form-item label="提示词">
            <el-input
              v-model="form.prompt"
              type="textarea"
              :rows="3"
              placeholder="请输入图片生成提示词"
            />
          </el-form-item>
          <el-form-item label="图片风格">
            <el-input
              v-model="form.style"
              placeholder="请输入图片风格（可选）"
            />
          </el-form-item>
          <el-form-item label="分辨率">
            <el-select v-model="form.resolution" placeholder="请选择分辨率">
              <el-option label="1080x1080" value="1080*1080" />
              <el-option label="1920x1080" value="1920*1080" />
              <el-option label="1080x1920" value="1080*1920" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="generateImage" :loading="loading">
              生成图片
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-card>

    <el-card class="box-card history-card" v-if="imageHistory.length > 0">
      <template #header>
        <div class="card-header">
          <span>生成历史</span>
          <el-button link @click="clearHistory">清空历史</el-button>
        </div>
      </template>
      <div class="image-list">
        <div v-for="(item, index) in imageHistory" :key="index" class="image-item">
          <div class="image-wrapper">
            <el-image
              :src="item.imageUrl"
              fit="cover"
              :preview-src-list="[item.imageUrl]"
              preview-teleported
              style="width: 300px; height: 300px;"
            />
          </div>
          <div class="prompt-text">提示词：{{ item.prompt }}</div>
          <div class="button-group">
            <el-button type="primary" link @click="downloadImage(item.imageUrl)">
              下载
            </el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { text2Image } from '@/api/image/image'

const form = ref({
  prompt: '图片风格为一个动漫女孩，身穿汉服在满是樱花的树下跳舞。脸上带有淡淡的笑容',
  style: '',
  resolution: '1080*1080'
})

const loading = ref(false)
const imageHistory = ref([])

const generateImage = async () => {
  if (!form.value.prompt) {
    ElMessage.warning('请输入提示词')
    return
  }

  loading.value = true
  try {
    const blob = await text2Image(form.value.prompt, form.value.style, form.value.resolution)
    
    // 将Blob转换为Base64
    const reader = new FileReader()
    reader.readAsDataURL(blob)
    reader.onloadend = () => {
      const imageUrl = reader.result
      // 添加到历史记录
      imageHistory.value.unshift({
        prompt: form.value.prompt,
        style: form.value.style,
        resolution: form.value.resolution,
        imageUrl
      })
    }
  } catch (error) {
    ElMessage.error(error.message || '图片生成失败')
  } finally {
    loading.value = false
  }
}

// 下载图片
const downloadImage = (imageUrl) => {
  const link = document.createElement('a')
  link.href = imageUrl
  link.download = `generated-image-${Date.now()}.png`
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

// 清空历史
const clearHistory = () => {
  imageHistory.value = []
}
</script>

<style lang="scss" scoped>
.image-generation {
  padding: 20px;

  .box-card {
    margin-bottom: 20px;
  }

  .history-card {
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }

  .image-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;

    .image-item {
      display: flex;
      flex-direction: column;
      gap: 10px;

      .image-wrapper {
        width: 300px;
        height: 300px;
      }

      .prompt-text {
        font-size: 14px;
        color: #666;
        word-break: break-all;
      }

      .button-group {
        display: flex;
        justify-content: flex-end;
      }
    }
  }
}
</style>
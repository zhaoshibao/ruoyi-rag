<template>
  <div class="app-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>文档总结</span>
        </div>
      </template>
      
      <el-form :model="form" label-width="80px">
        <el-form-item label="上传方式">
          <el-radio-group v-model="form.uploadType">
            <el-radio label="file">文件上传</el-radio>
            <el-radio label="url">URL链接</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item v-if="form.uploadType === 'file'" label="文件">
          <el-upload
            ref="uploadRef"
            class="upload-demo"
            action=""
            :auto-upload="false"
            :on-change="handleFileChange"
            :on-remove="handleFileRemove"
            :limit="1"
            :file-list="fileList"
            :before-upload="() => false"
          >
            <template #trigger>
              <el-button type="primary">选择文件</el-button>
            </template>
            <template #tip>
              <div class="el-upload__tip">
                支持doc, docx, pdf, txt, markdown等文档格式
              </div>
            </template>
          </el-upload>
        </el-form-item>

        <el-form-item v-else label="URL">
          <el-input v-model="form.url" placeholder="请输入文档URL地址"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">生成摘要</el-button>
          <el-button v-if="form.uploadType === 'file' && form.file" @click="clearFile">清除文件</el-button>
        </el-form-item>
      </el-form>

      <div class="summary-list" v-if="summaryList.length > 0">
        <el-divider>摘要历史</el-divider>
        <el-timeline>
          <el-timeline-item
            v-for="(item, index) in summaryList"
            :key="index"
            :timestamp="formatTime(item.timestamp)"
            placement="top"
          >
            <el-card class="summary-card">
              <div class="summary-header">
                <span class="summary-type">
                  {{ item.type === 'file' ? '文件上传' : 'URL链接' }}
                </span>
                <span class="summary-source">
                  {{ item.source }}
                </span>
              </div>
              <div class="summary-content">
                <!-- 使用MdPreview组件替换简单的p标签 -->
                <div class="message-md">
                  <MdPreview 
                    :editorId="`summary-preview-${index}`"
                    previewTheme="github"
                    :showCodeRowNumber="false"
                    :modelValue="item.content"
                    :key="`summary-${index}`"
                  />
                </div>
              </div>
             
              <div v-if="item.followUpQuestion" class="follow-up-section">
                <div class="follow-up-answer">
                  <strong>回答：</strong>
                  <div class="message-md">
                    <MdPreview 
                      :editorId="`followup-preview-${index}`"
                      previewTheme="github"
                      :showCodeRowNumber="false"
                      :modelValue="item.followUpAnswer"
                      :key="`followup-${index}`"
                    />
                  </div>
                </div>
              </div>
              <div class="summary-actions">
                <el-button type="primary" link @click="handleCopy(item.content)">
                  <el-icon><CopyDocument /></el-icon> 复制
                </el-button>
                <el-button type="danger" link @click="handleDelete(index)">
                  <el-icon><Delete /></el-icon> 删除
                </el-button>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { CopyDocument, Delete } from '@element-plus/icons-vue'
import { genSummaryByFile } from '@/api/summarizer/summarizer'
import { MdPreview } from 'md-editor-v3'
import 'md-editor-v3/lib/preview.css'

const uploadRef = ref(null)
const fileList = ref([])

const form = ref({
  uploadType: 'file',
  file: null,
  url: ''
})

const loading = ref(false)
const summaryList = ref([])

const handleFileChange = (file) => {
  form.value.file = file.raw  // 使用 file.raw 获取真正的 File 对象
  // 更新文件列表显示
  fileList.value = [{
    name: file.name,
    status: 'ready',
    uid: file.uid
  }]
}

const handleFileRemove = () => {
  form.value.file = null
  fileList.value = []
}

const clearFile = () => {
  form.value.file = null
  fileList.value = []
  // 清除上传组件的文件列表
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}

const handleSubmit = async () => {
  try {
    loading.value = true
    let result
    let source = ''
    
    if (form.value.uploadType === 'file') {
      if (!form.value.file) {
        ElMessage.warning('请选择要上传的文件')
        return
      }
      result = await genSummaryByFile({
        file: form.value.file
      })
      source = form.value.file.name
    } else {
      if (!form.value.url) {
        ElMessage.warning('请输入文档URL地址')
        return
      }
      result = await genSummaryByFile({
        url: form.value.url
      })
      source = form.value.url
    }

    summaryList.value.unshift({
      content: result,
      timestamp: new Date().getTime(),
      type: form.value.uploadType,
      source,
      tempQuestion: '',
      followUpQuestion: '',
      followUpAnswer: ''
    })

    // 提交成功后清除文件选择和URL输入
    if (form.value.uploadType === 'file') {
      clearFile()
    } else {
      form.value.url = ''
    }

    ElMessage.success('摘要生成成功')
  } catch (error) {
    console.error('生成摘要失败:', error)
    ElMessage.error('生成摘要失败，请重试')
  } finally {
    loading.value = false
  }
}

// 复制摘要内容
const handleCopy = async (content) => {
  try {
    await navigator.clipboard.writeText(content)
    ElMessage.success('复制成功')
  } catch (err) {
    console.error('复制失败:', err)
    ElMessage.error('复制失败')
  }
}

// 删除摘要记录
const handleDelete = async (index) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这条摘要记录吗？',
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    summaryList.value.splice(index, 1)
    ElMessage.success('删除成功')
  } catch {
    // 用户取消删除
  }
}

const formatTime = (timestamp) => {
  const date = new Date(timestamp)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.summary-list {
  margin-top: 20px;
}

.summary-item {
  padding: 15px;
  border-bottom: 1px solid #ebeef5;
}

.summary-item:last-child {
  border-bottom: none;
}

.summary-content {
  margin-bottom: 10px;
}

.summary-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 15px;
}

.chat-input {
  margin-top: 15px;
}

.follow-up-section {
  margin-top: 15px;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.follow-up-question {
  margin-bottom: 10px;
  color: #666;
}

.follow-up-answer {
  color: #333;
}

.summary-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

.summary-type {
  background-color: #409eff;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.summary-source {
  color: #666;
  font-size: 14px;
  max-width: 60%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 应用MessageList.vue中的MdPreview样式 */
.message-md :deep(.md-editor-preview-wrapper) {
  color: var(--gray-900);
  max-width: 100%;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Noto Sans SC', 'PingFang SC', 'Noto Sans SC', 'Microsoft YaHei', 'Hiragino Sans GB', 'Source Han Sans CN', 'Courier New', monospace;
}

.message-md :deep(.md-editor-preview-wrapper) .md-editor-preview {
  font-size: 15px;
}

.message-md :deep(.md-editor-preview-wrapper) h1, 
.message-md :deep(.md-editor-preview-wrapper) h2 {
  font-size: 1.2rem;
}

.message-md :deep(.md-editor-preview-wrapper) h3, 
.message-md :deep(.md-editor-preview-wrapper) h4 {
  font-size: 1.1rem;
}

.message-md :deep(.md-editor-preview-wrapper) h5, 
.message-md :deep(.md-editor-preview-wrapper) h6 {
  font-size: 1rem;
}

.message-md :deep(.md-editor-preview-wrapper) a {
  color: #409eff;
}

.message-md :deep(.md-editor-preview-wrapper) code {
  font-size: 13px;
  font-family: 'Menlo', 'Monaco', 'Consolas', 'PingFang SC', 'Noto Sans SC', 'Microsoft YaHei', 'Hiragino Sans GB', 'Source Han Sans CN', 'Courier New', monospace;
  line-height: 1.5;
  letter-spacing: 0.025em;
  tab-size: 4;
  -moz-tab-size: 4;
  background-color: #f5f5f5;
  padding: 2px 4px;
  border-radius: 3px;
}

.message-md :deep(.md-editor-preview-wrapper) pre {
  background-color: #f8f8f8;
  border-radius: 6px;
  padding: 16px;
  overflow-x: auto;
}

.message-md :deep(.md-editor-preview-wrapper) blockquote {
  border-left: 4px solid #409eff;
  padding-left: 16px;
  margin: 16px 0;
  color: #666;
}
</style>
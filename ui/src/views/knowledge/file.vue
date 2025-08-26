<template>
  <div class="app-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <div class="title-container">
            <span class="knowledge-name" @click="goToKnowledgeList">{{ knowledgeName }}</span><span class="file-list-text"> / 文件列表</span>
          </div>
          <el-button type="primary" @click="handleUpload">上传文件</el-button>
        </div>
      </template>

      <!-- 在表格上方添加刷新时间显示 -->
      <div class="mb8" style="text-align: right; font-size: 12px; color: #909399;">
        <span v-if="lastRefreshTime">上次刷新: {{ lastRefreshTime }}</span>
      </div>

      <!-- 文件列表 -->
      <el-table v-loading="loading" :data="fileList">
        <el-table-column label="文件名" align="center" prop="fileName" />
        <el-table-column label="文件格式" align="center" prop="fileType" />
        <el-table-column label="文件大小" align="center" prop="fileSize">
          <template #default="scope">
            {{ formatFileSize(scope.row.fileSize) }}
          </template>
        </el-table-column>
        <el-table-column label="是否向量化完成" align="center" prop="isVector" width="150">
          <template #default="scope">
            <el-tag :type="scope.row.isVector === 1 ? 'success' : 'warning'">
              {{ scope.row.isVector === 1 ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="是否开启PDF增强解析" align="center" prop="pdfAnalysis" width="180">
          <template #default="scope">
            <el-tag :type="scope.row.isPdfAnalysis === 1 ? 'success' : 'info'">
              {{ scope.row.isPdfAnalysis === 1 ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template #default="scope">
          <div v-if="scope.row.isVector === 1">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看切片</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </div>
          <div v-else>
            <el-tooltip content="正在向量化" placement="top">
              <span>
                <el-icon class="is-loading"><Loading /></el-icon>
                <span style="margin-left: 5px;">正在向量化</span>
              </span>
            </el-tooltip>
          </div>
        </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 上传文件对话框 -->
    <el-dialog 
      title="上传文件" 
      v-model="uploadDialogVisible" 
      width="600px" 
      append-to-body
      destroy-on-close
      :close-on-click-modal="false"
      class="upload-dialog"
    >
      <el-form ref="uploadForm" :model="fileData" label-width="150px">
        <el-form-item label="文件上传" prop="fileUpload">
          <el-upload
            ref="upload"
            class="upload-area"
            :action="fileUploadUrl"
            :headers="fileUploadHeaders"
            :data="fileData"
            :on-success="handleSuccess"
            :before-upload="beforeUpload"
            :on-remove="handleRemove"
            name="file"
            multiple
            :file-list="uploadFileList"
            drag
          >
            <el-icon class="upload-icon"><Upload /></el-icon>
            <div class="upload-text">拖拽文件到此处或<em>点击上传</em></div>
            <div class="upload-tip">
              <div class="file-types">
                <el-tag v-for="type in fileTypes" :key="type" size="small" effect="plain" class="file-type-tag">{{ type }}</el-tag>
              </div>
              <p>支持多个文件同时上传，单个文件不超过50MB</p>
            </div>
          </el-upload>
        </el-form-item>
        <el-form-item label="开启PDF增强解析" prop="pdfAnalysis">
          <div class="switch-container">
            <el-switch 
              v-model="fileData.pdfAnalysis" 
              :active-value="1" 
              :inactive-value="0"
              class="custom-switch" 
            />
            <span class="switch-tip">{{ fileData.pdfAnalysis === 1 ? '已开启' : '未开启' }}</span>
            <el-tooltip content="开启后将对PDF文件进行更深入的解析，提取更多结构化信息" placement="top">
              <el-icon class="info-icon"><InfoFilled /></el-icon>
            </el-tooltip>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="cancelUpload">取 消</el-button>
          <el-button type="primary" @click="closeUploadDialog">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, getCurrentInstance, onBeforeMount, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getFileListByKnowledgeId, getKnowledge } from "@/api/knowledge/knowledge"
import { parseTime } from '@/utils/ruoyi'
import { getToken } from "@/utils/auth"
import { Upload, InfoFilled } from '@element-plus/icons-vue'

const { proxy } = getCurrentInstance()
const route = useRoute()
const router = useRouter()

// 支持的文件类型
const fileTypes = ref(['PDF', 'Word', 'Excel', 'TXT', 'Markdown'])

// 定时刷新相关
const timer = ref(null)
const lastRefreshTime = ref('')

// 知识库ID
const knowledgeId = ref('')
// 知识库名称
const knowledgeName = ref('')
// 加载状态
const loading = ref(true)
// 文件列表数据
const fileList = ref([])
// 总条数
const total = ref(0)
// 查询参数
const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  knowledgeId: undefined
})

// 上传对话框显示状态
const uploadDialogVisible = ref(false)
// 上传文件列表
const uploadFileList = ref([])
// 上传文件URL
const fileUploadUrl = import.meta.env.VITE_APP_BASE_API + '/chat/file/upload'
// 上传文件请求头
const fileUploadHeaders = { Authorization: 'Bearer ' + getToken() }
// 上传文件数据
const fileData = ref({
  knowledgeId: undefined,
  pdfAnalysis: 0 // 默认关闭PDF增强解析
})

// 设置定时刷新
function setupTimer() {
  clearTimer(); // 先清除可能存在的定时器
  timer.value = setInterval(() => {
    if (!loading.value) { // 只有在不加载状态时才刷新
      getList();
    }
  }, 5000); // 每5秒刷新一次
}

// 清除定时器
function clearTimer() {
  if (timer.value) {
    clearInterval(timer.value);
    timer.value = null;
  }
}

// 在组件挂载前调用
onBeforeMount(() => {
  // 设置定时刷新
  setupTimer();
})

// 在组件卸载前调用
onBeforeUnmount(() => {
  // 组件销毁前清除定时器
  clearTimer();
})

// 在组件挂载后调用
onMounted(() => {
  // 从路由参数获取知识库ID
  const routeKnowledgeId = route.params.knowledgeId || route.query.knowledgeId
  console.log(routeKnowledgeId)
  if (routeKnowledgeId) {
    knowledgeId.value = routeKnowledgeId
    queryParams.value.knowledgeId = routeKnowledgeId
    // 获取知识库信息
    getKnowledgeInfo()
    // 获取文件列表
    getList()
  } else {
    proxy.$modal.msgError('知识库ID不能为空')
    router.push('/knowledge')
  }
})

// 获取知识库信息
function getKnowledgeInfo() {
  getKnowledge(knowledgeId.value).then(response => {
    if (response.code === 200 && response.data) {
      knowledgeName.value = response.data.knowledgeName || '未命名知识库'
    }
  }).catch(() => {
    knowledgeName.value = '未命名知识库'
  })
}

// 获取文件列表
function getList() {
  loading.value = true
  getFileListByKnowledgeId(knowledgeId.value).then(response => {
    fileList.value = response.rows || []
    total.value = response.total || 0
    loading.value = false
    lastRefreshTime.value = new Date().toLocaleString() // 更新刷新时间
  }).catch(error => {
    console.error('获取文件列表失败:', error)
    fileList.value = []
    total.value = 0
    loading.value = false
    lastRefreshTime.value = new Date().toLocaleString() // 即使失败也更新刷新时间
    proxy.$modal.msgError('获取文件列表失败')
  })
}

// 格式化文件大小
function formatFileSize(size) {
  if (!size) return '0 B'
  
  const units = ['B', 'KB', 'MB', 'GB', 'TB']
  let index = 0
  let fileSize = size
  
  while (fileSize >= 1024 && index < units.length - 1) {
    fileSize /= 1024
    index++
  }
  
  return fileSize.toFixed(2) + ' ' + units[index]
}

// 上传按钮操作
function handleUpload() {
  fileData.value = {
    knowledgeId: knowledgeId.value,
    pdfAnalysis: 0 // 默认关闭PDF增强解析
  }
  uploadFileList.value = [] // 打开弹窗前清空文件列表
  uploadDialogVisible.value = true
}

// 上传前检查
function beforeUpload(file) {
  // 可以在这里添加文件类型、大小等检查逻辑
  return true
}

// 上传成功处理
function handleSuccess(res, file) {
  if (res.code === 200) {
    uploadFileList.value.push({ id: res.data, name: file.name })
    proxy.$modal.msgSuccess("文件上传成功")
  } else {
    proxy.$modal.msgError(res.msg || "文件上传失败")
  }
}

// 移除文件处理
function handleRemove(file, fileList) {
  uploadFileList.value = fileList
}

// 关闭上传对话框
function closeUploadDialog() {
  uploadDialogVisible.value = false
  // 刷新文件列表
  getList()
}

// 取消上传
function cancelUpload() {
  uploadDialogVisible.value = false
  uploadFileList.value = []
}

// 删除文件
function handleDelete(row) {
  proxy.$modal.confirm('是否确认删除文件名为"' + row.fileName + '"的文件？').then(function() {
    // 这里需要调用删除文件的API
    // 暂时模拟删除成功
    proxy.$modal.msgSuccess("删除成功")
    getList() // 刷新列表
  }).catch(() => {})
}

// 跳转到知识库列表页面
function goToKnowledgeList() {
  router.push('/knowledge/index');
}
// 查看文件
function handleView(row) {
  router.push({
    path: '/knowledge/chunk/index',
    query: {
      knowledgeId: knowledgeId.value,
      fileId: row.fileId,
      fileName: row.fileName
    }
  });
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.mb8 {
  margin-bottom: 8px;
}

/* 上传区域样式 */
.upload-dialog :deep(.el-dialog__body) {
  padding: 20px 30px;
}

.upload-area {
  width: 100%;
}

.upload-area :deep(.el-upload) {
  width: 100%;
}

.upload-area :deep(.el-upload-dragger) {
  width: 100%;
  height: 200px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border: 2px dashed #dcdfe6;
  border-radius: 8px;
  transition: all 0.3s;
}

.upload-area :deep(.el-upload-dragger:hover) {
  border-color: #409eff;
  background-color: rgba(64, 158, 255, 0.06);
}

.upload-icon {
  font-size: 48px;
  color: #909399;
  margin-bottom: 10px;
}

.upload-text {
  font-size: 16px;
  color: #606266;
  margin-bottom: 10px;
}

.upload-text em {
  color: #409eff;
  font-style: normal;
  font-weight: bold;
}

.upload-tip {
  text-align: center;
  color: #909399;
  font-size: 13px;
  margin-top: 10px;
}

.file-types {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  margin-bottom: 8px;
}

.file-type-tag {
  margin: 0 4px 4px 0;
}

.switch-container {
  display: flex;
  align-items: center;
}

.switch-tip {
  margin-left: 10px;
  font-size: 14px;
  color: #606266;
}

.info-icon {
  margin-left: 8px;
  color: #909399;
  cursor: pointer;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}

.knowledge-name {
  cursor: pointer;
  color: #409eff;
  transition: color 0.3s;
}

.knowledge-name:hover {
  color: #66b1ff;
  text-decoration: underline;
}
</style>
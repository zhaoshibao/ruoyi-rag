<template>
  <div class="app-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <div class="title-container">
            <el-button icon="Back" link @click="goBack">返回</el-button>
            <span class="knowledge-name" @click="goToKnowledgeList">{{ knowledgeName }}</span>
            <span class="file-list-text"> / </span>
            <span class="file-name" @click="goToFileList">文件列表</span>
            <span class="file-list-text"> / {{ fileName }} 分片列表</span>
          </div>
        </div>
      </template>

      <!-- 在表格上方添加刷新时间显示 -->
      <div class="mb8" style="text-align: right; font-size: 12px; color: #909399;">
        <span v-if="lastRefreshTime">上次刷新: {{ lastRefreshTime }}</span>
      </div>

      <!-- 文件分片列表 -->
      <el-table v-loading="loading" :data="chunkList">
        <el-table-column label="分片ID" align="center" prop="segmentId" width="280" />
        <el-table-column label="文件名" align="center" prop="fileName" />
        <el-table-column label="内容" align="center" prop="content">
          <template #default="scope">
            <div class="content-preview">
              {{ scope.row.content }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
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
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, onBeforeMount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getKnowledge, getFileChunkListByKnowledgeId } from '@/api/knowledge/knowledge'
import { parseTime } from '@/utils/ruoyi'
import { getCurrentInstance } from 'vue'

const { proxy } = getCurrentInstance()
const route = useRoute()
const router = useRouter()

// 定时刷新相关
const timer = ref(null)
const lastRefreshTime = ref('')

// 文件ID
const fileId = ref('')
// 知识库ID
const knowledgeId = ref('')
// 知识库名称
const knowledgeName = ref('')
// 文件名
const fileName = ref('')
// 加载状态
const loading = ref(true)
// 文件分片列表数据
const chunkList = ref([])
// 总条数
const total = ref(0)
// 查询参数
const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  knowledgeId: undefined
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
  //setupTimer();
})

// 在组件卸载前调用
onBeforeUnmount(() => {
  // 组件销毁前清除定时器
  clearTimer();
})

// 在组件挂载后调用
onMounted(() => {
  // 从路由参数获取知识库ID和文件名
  const routeKnowledgeId = route.params.knowledgeId || route.query.knowledgeId
  const routeFileId = route.params.fileId || route.query.fileId
  const routeFileName = route.params.fileName || route.query.fileName
  
  if (fileId) {
    knowledgeId.value = routeKnowledgeId
    fileId.value = routeFileId
    fileName.value = routeFileName || '未知文件'
    queryParams.value.knowledgeId = knowledgeId
    queryParams.value.fileId = fileId
    // 获取知识库信息
    getKnowledgeInfo()
    // 获取文件分片列表
    getList()
  } else {
    proxy.$modal.msgError('文件ID不能为空')
    router.push('/knowledge/file/index')
  }
})

// 获取文件信息
function getKnowledgeInfo() {
  getKnowledge(knowledgeId.value).then(response => {
    if (response.code === 200 && response.data) {
      knowledgeName.value = response.data.knowledgeName || '未命名知识库'
    }
  }).catch(() => {
    knowledgeName.value = '未命名知识库'
  })
}

// 获取文件分片列表
function getList() {
  loading.value = true
  getFileChunkListByKnowledgeId(fileId.value).then(response => {
    chunkList.value = response.rows || []
    total.value = response.total || 0
    loading.value = false
    lastRefreshTime.value = new Date().toLocaleString() // 更新刷新时间
  }).catch(error => {
    console.error('获取文件分片列表失败:', error)
    chunkList.value = []
    total.value = 0
    loading.value = false
    lastRefreshTime.value = new Date().toLocaleString() // 即使失败也更新刷新时间
    proxy.$modal.msgError('获取文件分片列表失败')
  })
}

// 返回上一页
function goBack() {
  router.go(-1)
}

// 跳转到知识库列表页面
function goToKnowledgeList() {
  router.push('/knowledge/index')
}

// 跳转到文件列表页面
function goToFileList() {
  router.push({
    path: '/knowledge/file/index',
    query: {
      knowledgeId: knowledgeId.value
    }
  })
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title-container {
  display: flex;
  align-items: center;
}

.mb8 {
  margin-bottom: 8px;
}

.knowledge-name {
  cursor: pointer;
  color: #409eff;
  transition: all 0.3s;
}

.knowledge-name:hover {
  color: #66b1ff;
  text-decoration: underline;
}

.file-name {
  cursor: pointer;
  color: #409eff;
  transition: all 0.3s;
}

.file-name:hover {
  color: #66b1ff;
  text-decoration: underline;
}

.content-preview {
  max-height: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: pre-wrap;
  word-break: break-all;
}
</style>
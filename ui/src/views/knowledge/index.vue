<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm"  :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="type">
        <el-select
          v-model="queryParams.projectId"
          placeholder="选择项目"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="project in projectList"
            :key="project.projectId"
            :label="project.projectId != undefined ? project.projectId + ' ' + project.projectName : project.projectName"
            :value="project.projectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar :showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <!-- 在表格上方添加 -->
    <div class="mb8" style="text-align: right; font-size: 12px; color: #909399;">
      <span v-if="lastRefreshTime">上次刷新: {{ lastRefreshTime }}</span>
    </div>

    <el-table v-loading="loading" :data="knowledges" @selection-change="handleSelectionChange">
      <el-table-column label="项目名称" align="center" prop="projectName" />
      <el-table-column label="文件名" align="center" prop="fileName" />
      <el-table-column label="上传时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <div v-if="scope.row.isVector === 1">
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">查看内容</el-button>
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

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 查看知识库内容对话框 -->
    <el-dialog title="知识库内容详情"
      v-model="dialogOpen"
      width="80%"
      top="5vh">
      <el-table 
        v-loading="contentLoading" 
        :data="knowledgeContent" 
        border
        style="width: 100%"
        max-height="500">
        <el-table-column label="序号" type="index" width="60" align="center" />
        <el-table-column label="文件名" prop="fileName" width="120" align="center" />
        <el-table-column label="内容片段" prop="content" show-overflow-tooltip>
          <template #default="scope">
            <div style="white-space: pre-wrap; word-break: break-all;">{{ scope.row.content }}</div>
          </template>
        </el-table-column>
        
        <el-table-column label="创建时间" prop="createTime" width="180" align="center">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页组件 -->
      <pagination
        v-show="contentTotal > 0"
        :total="contentTotal"
        v-model:page="contentQueryParams.pageNum"
        v-model:limit="contentQueryParams.pageSize"
        @pagination="getKnowledgeContent"
        style="margin-top: 20px;"
      />
      
      <template #footer>
        <el-button type="primary" @click="dialogOpen = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 添加或修改知识库对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="选择项目">
          <el-select
            v-model="form.projectId"
            style="width: 240px">
            <el-option
              v-for="project in formProjectList"
              :key="project.projectId"
              :label="project.projectName"
              :value="project.projectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="文件上传" prop="fileUpload">
          <el-upload
            class="upload-demo"
            action="submitForm"
            :data="fileData"
            name="file"
            :limit="1"
            :file-list="fileList">
            <el-button size="small" type="primary">点击上传</el-button>
            <div class="el-upload__tip">只能上传txt、word、pdf文件，且不超过5M</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onBeforeMount,onMounted ,onBeforeUnmount} from 'vue'
import { listKnowledge, getKnowledge, addKnowledge, listProject, delKnowledge} from "@/api/knowledge/knowledge";

const { proxy } = getCurrentInstance()

// 定时刷新定时器
const timer = ref(null)
const lastRefreshTime = ref('')
const projectList = ref([])
const formProjectList = ref([])
const fileList = ref([{fileName: 'food.jpeg', url: ""}])
const fileData = ref({
    projectId: undefined
})
const dialogOpen = ref(false)
const fileContent = ref("")
// 知识库内容相关
const knowledgeContent = ref([])
const contentLoading = ref(false)
const contentTotal = ref(0)
const currentKnowledgeId = ref(null)
const currentProjectId = ref(null)
const contentQueryParams = ref({
        pageNum: 1,
        pageSize: 10
})
// 加载状态
const loading = ref(true)
// 选中数组
const ids = ref([])
// 非单个禁用
const single = ref(true)
// 非多个禁用
const multiple = ref(true)
// 显示搜索条件
const showSearch = ref(true)
// 总条数
const total = ref(0)
// 知识库表格数据
const knowledges = ref([])
// 弹出层标题
const title = ref("")
// 是否显示弹出层
const open = ref(false)
// 查询参数
const queryParams = ref({
        pageNum: 1,
        pageSize: 10,
        projectId: undefined,
        user: undefined
      })
// 表单参数
const form = ref({
    projectId: 109
})
// 表单校验
const rules = ref({
        postName: [
          { required: true, message: "岗位名称不能为空", trigger: "blur" }
        ],
        postCode: [
          { required: true, message: "岗位编码不能为空", trigger: "blur" }
        ]
      })
//注册一个钩子，在组件被挂载之前被调用。
onBeforeMount(() => {
    getProjectList();
    getList();
    // 设置定时刷新，每5秒刷新一次
    setupTimer();
  })
//注册一个钩子，在组件被卸载之前被调用。
onBeforeUnmount(() => {
  // 组件销毁前清除定时器
  clearTimer();
})
 function setupTimer() {
  clearTimer(); // 先清除可能存在的定时器
  timer.value = setInterval(() => {
    if (!loading.value && !contentLoading.value) { // 只有在两个loading都为false时才刷新
      getList();
    }
  }, 5000);
}
function  clearTimer() {
  if (timer.value) {
    clearInterval(timer.value);
    timer.value = null;
  }
}
function  getProjectList() {
  listProject().then(response => {
    formProjectList.value = response.rows;
    projectList.value = Array.of({
      "projectId": undefined,
      "projectName": "全部"
    }).concat(response.rows);
    form.value.projectId = formProjectList.value.length == 0 ? undefined : formProjectList.value[0].projectId
  });
}


/** 查询知识库列表 */
function getList() {
  loading.value = true
  console.log('开始加载数据，loading:', loading.value)
  
  return listKnowledge(queryParams.value)
    .then(response => {
      console.log('获取数据成功:', response)
      knowledges.value = response.rows
      total.value = response.total
      loading.value = false
      lastRefreshTime.value = new Date().toLocaleString()
    })
    .catch(error => {
      console.error('获取知识库列表失败:', error)
      knowledges.value = []
      total.value = 0
      loading.value = false
    lastRefreshTime.value = new Date().toLocaleString();
    proxy.$modal.msgError('获取知识库列表失败')
    })
}
// 取消按钮
function cancel() {
  open.value = false
  reset()
}
// 表单重置
function reset() {
  form.value = {
    postId: undefined,
    postCode: undefined,
    postName: undefined,
    status: "0",
    remark: undefined
  };
  proxy.resetForm("form");
}
/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}
/** 查看内容按钮操作 */
function handleView(row){
  currentKnowledgeId.value = row.knowledgeId;
  currentProjectId.value = row.projectId;
  contentQueryParams.value.pageNum = 1;
  dialogOpen.value = true;
  getKnowledgeContent();
}
/** 获取知识库内容分页数据 */
function getKnowledgeContent() {
  contentLoading.value = true;
  getKnowledge(currentProjectId.value, currentKnowledgeId.value).then(response => {
    console.log('知识库内容数据:', response.data);
    
    // 假设接口返回的数据结构，根据实际情况调整
    if (response.data && Array.isArray(response.data)) {
      // 如果返回的是数组，进行分页处理
      const startIndex = (contentQueryParams.value.pageNum - 1) * contentQueryParams.value.pageSize;
      const endIndex = startIndex + contentQueryParams.value.pageSize;
      knowledgeContent.value = response.data.slice(startIndex, endIndex);
      contentTotal.value = response.data.length;
    } else if (response.data && response.data.content) {
      // 如果返回的是单个内容对象，将其转换为数组格式
      const contentArray = [{
        content: response.data.content,
        fileName: response.data.fileName || 'N/A',
        createTime: response.data.createTime || new Date().toISOString()
      }];
      knowledgeContent.value = contentArray;
      contentTotal.value = 1;
    } else {
      // 如果数据格式不符合预期，显示空数据
      knowledgeContent.value = [];
      contentTotal.value = 0;
    }
    
    contentLoading.value = false;
  }).catch(error => {
    console.error('获取知识库内容失败:', error);
    knowledgeContent.value = [];
    contentTotal.value = 0;
    contentLoading.value = false;
    proxy.$modal.msgError('获取知识库内容失败');
  });
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryForm");
  queryParams.value.projectId = undefined;
  handleQuery();
}
// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.postId)
  single.value = selection.length!=1
  multiple.value = !selection.length
}
/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "上传知识库";
} 
/** 提交按钮 */
function submitForm() {
  proxy.$refs["form"].validate(valid => {
    if (valid) {
        addPost(this.form).then(response => {
          this.$modal.msgSuccess("新增成功");
          this.open = false;
          this.getList();
        });
    }
  });
}
/** 删除按钮操作 */
function handleDelete(row) {
  console.log(row)
  const fileName = row.fileName
  const knowledgeData = {knowledgeId: row.knowledgeId, projectId: row.projectId};
  proxy.$modal.confirm('是否确认删除文件名称为"' + fileName + '"的数据项？').then(function() {
    return delKnowledge(knowledgeData);
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}


</script>


<style scoped>

.is-loading {
  animation: rotating 2s linear infinite;
}

@keyframes rotating {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

</style>

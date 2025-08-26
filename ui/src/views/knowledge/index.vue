<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm"  :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="知识库名称" prop="knowledgeName">
        <el-input v-model="queryParams.knowledgeName" placeholder="请输入知识库名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

       <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd">新增</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
    </el-row>
    <el-table v-loading="loading" :data="knowledges" @selection-change="handleSelectionChange">
      <el-table-column label="知识库名称" align="center" prop="knowledgeName" />
      <el-table-column label="知识库描述" align="center" prop="knowledgeDesc" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
         <el-button link type="primary" icon="Edit" @click="handleView(scope.row)">查看</el-button>
             <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
         
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

  

    <!-- 添加或修改知识库对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="知识库名称" prop="knowledgeName">
          <el-input v-model="form.knowledgeName" placeholder="请输入知识库名称" clearable />
        </el-form-item>
        <el-form-item label="知识库描述" prop="desc">
          <el-input v-model="form.knowledgeDesc" placeholder="请输入知识库描述"/>
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
import { ref, onMounted, onBeforeUnmount, getCurrentInstance } from 'vue'
import { listKnowledge, addKnowledge, updateKnowledge, delKnowledge, getFileListByKnowledgeId, getKnowledge } from "@/api/knowledge/knowledge";

const { proxy } = getCurrentInstance()

// 知识库内容相关
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
        knowledgeName: undefined,
      })
// 表单参数 - 初始化为空字符串而不是undefined
const form = ref({
  knowledgeName: "",
  knowledgeDesc: ""
})
// 表单引用
const formRef = ref(null)
// 表单校验
const rules = ref({
        knowledgeName: [
          { required: true, message: "知识库名称不能为空", trigger: "blur" }
        ],
      })
// 列定义（之前缺失）
const columns = ref([])

// 在组件挂载后调用
onMounted(() => {
    getList();
})

// 组件卸载前调用
onBeforeUnmount(() => {

})


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
    })
    .catch(error => {
      console.error('获取知识库列表失败:', error)
      knowledges.value = []
      total.value = 0
      loading.value = false
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
    knowledgeName: "",
    knowledgeDesc: ""
  };
  // 使用新的表单引用
  if (formRef.value) {
    formRef.value.resetFields();
  }
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  if (proxy.$refs["queryForm"]) {
    proxy.$refs["queryForm"].resetFields();
  }
  queryParams.value.projectId = undefined;
  handleQuery();
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.postId)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加知识库";
} 
/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const knowledgeId = row.knowledgeId || ids.value
  getKnowledge(knowledgeId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改知识库"
  })
}

/** 提交按钮 */
function submitForm() {
  formRef.value.validate(valid => {
    if (valid) {
       if (form.value.knowledgeId != undefined) { 
        updateKnowledge(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
       } else {
        addKnowledge(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        });
       }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  console.log(row)
  const fileName = row.fileName || row.knowledgeName; // 增加容错处理
  const knowledgeData = {knowledgeId: row.knowledgeId, projectId: row.projectId};
  proxy.$modal.confirm('是否确认删除名称为"' + fileName + '"的数据项？').then(function() {
    return delKnowledge(knowledgeData);
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

// 修复缺失的parseTime方法
function parseTime(time) {
  if (!time) return '';
  const date = new Date(time);
  return date.toLocaleString();
}

// 查看文件
function handleView(row) {
  proxy.$router.push({
    path: '/knowledge/file/index',  // 修改这里，从'/knowledge/file'改为'/knowledge/file/index'
    query: {
      knowledgeId: row.knowledgeId
    }
  });
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

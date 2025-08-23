<template>
  <div class="knowledge-list">
    <div class="list-header">
      <h3>知识库列表</h3>
      <el-button type="primary" size="small" @click="createKnowledge">
        <el-icon><Plus /></el-icon> 新建知识库
      </el-button>
    </div>
    
    <el-divider></el-divider>
    
    <div class="list-content">
      <div 
        v-for="knowledge in knowledgeBases" 
        :key="knowledge.id"
        :class="['knowledge-item', { active: activeKnowledge === knowledge.id }]"
        @click="selectKnowledge(knowledge)"
      >
        <div class="knowledge-info">
          <el-icon><Collection /></el-icon>
          <div class="knowledge-details">
            <div class="knowledge-name">{{ knowledge.name }}</div>
            <div class="knowledge-date">{{ formatDate(knowledge.createTime) }}</div>
          </div>
        </div>
        <div class="knowledge-actions">
          <el-dropdown trigger="click" @click.stop>
            <el-icon><More /></el-icon>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="editKnowledge(knowledge)">
                  <el-icon><EditPen /></el-icon> 编辑
                </el-dropdown-item>
                <el-dropdown-item @click="uploadFiles(knowledge)">
                  <el-icon><Upload /></el-icon> 上传文件
                </el-dropdown-item>
                <el-dropdown-item @click="deleteKnowledge(knowledge)">
                  <el-icon><Delete /></el-icon> 删除
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
      
      <div v-if="knowledgeBases.length === 0" class="empty-list">
        <el-empty description="暂无知识库" />
      </div>
    </div>
    
    <!-- 知识库表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑知识库' : '新建知识库'"
      width="30%"
    >
      <el-form :model="knowledgeForm" label-width="80px">
        <el-form-item label="知识库名称">
          <el-input v-model="knowledgeForm.name" placeholder="请输入知识库名称"></el-input>
        </el-form-item>
        <el-form-item label="知识库描述">
          <el-input 
            v-model="knowledgeForm.description" 
            type="textarea" 
            placeholder="请输入知识库描述"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveKnowledge">确定</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 文件上传对话框 -->
    <el-dialog
      v-model="uploadDialogVisible"
      title="上传文件"
      width="30%"
    >
      <el-upload
        class="upload-demo"
        drag
        action="#"
        :auto-upload="false"
        :on-change="handleFileChange"
        multiple
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">
          将文件拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持 PDF、Word、Excel、TXT 等文件格式
          </div>
        </template>
      </el-upload>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="uploadDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitUpload">上传</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { Plus, Collection, More, EditPen, Delete, Upload, UploadFilled } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';

export default {
  components: {
    Plus,
    Collection,
    More,
    EditPen,
    Delete,
    Upload,
    UploadFilled
  },
  emits: ['select-knowledge'],
  setup(props, { emit }) {
    const knowledgeBases = ref([]); // 知识库列表
    const activeKnowledge = ref(null); // 当前选中的知识库
    const dialogVisible = ref(false); // 对话框显示状态
    const uploadDialogVisible = ref(false); // 上传对话框显示状态
    const isEdit = ref(false); // 是否为编辑模式
    const currentKnowledge = ref(null); // 当前操作的知识库
    const fileList = ref([]); // 上传文件列表
    
    const knowledgeForm = ref({ // 知识库表单数据
      id: '',
      name: '',
      description: ''
    });

    // 加载知识库列表（模拟数据）
    const loadKnowledgeBases = () => {
      // 这里应该是从API获取数据，现在使用模拟数据
      knowledgeBases.value = [
        { id: '1', name: '产品手册', description: '公司产品相关文档和说明书', createTime: '2023-05-15T10:30:00', fileCount: 12 },
        { id: '2', name: '技术文档', description: '技术架构和开发文档', createTime: '2023-06-20T14:45:00', fileCount: 8 },
        { id: '3', name: '培训资料', description: '员工培训和学习资料', createTime: '2023-07-10T09:15:00', fileCount: 5 },
        { id: '4', name: '市场分析', description: '市场调研和竞品分析报告', createTime: '2023-08-05T16:20:00', fileCount: 3 },
        { id: '5', name: '用户反馈', description: '用户反馈和问题汇总', createTime: '2023-09-12T11:40:00', fileCount: 7 }
      ];
      
      if (knowledgeBases.value.length > 0) {
        activeKnowledge.value = knowledgeBases.value[0].id;
      }
    };

    // 选择知识库
    const selectKnowledge = (knowledge) => {
      activeKnowledge.value = knowledge.id;
      emit('select-knowledge', knowledge);
    };

    // 创建新知识库
    const createKnowledge = () => {
      isEdit.value = false;
      knowledgeForm.value = {
        id: '',
        name: '',
        description: ''
      };
      dialogVisible.value = true;
    };

    // 编辑知识库
    const editKnowledge = (knowledge) => {
      isEdit.value = true;
      knowledgeForm.value = {
        id: knowledge.id,
        name: knowledge.name,
        description: knowledge.description
      };
      dialogVisible.value = true;
    };

    // 保存知识库
    const saveKnowledge = () => {
      if (!knowledgeForm.value.name) {
        ElMessage.warning('请输入知识库名称');
        return;
      }

      if (isEdit.value) {
        // 更新知识库
        const index = knowledgeBases.value.findIndex(k => k.id === knowledgeForm.value.id);
        if (index !== -1) {
          knowledgeBases.value[index] = {
            ...knowledgeBases.value[index],
            name: knowledgeForm.value.name,
            description: knowledgeForm.value.description
          };
          ElMessage.success('知识库更新成功');
        }
      } else {
        // 创建新知识库
        const newKnowledge = {
          id: Date.now().toString(), // 模拟ID生成
          name: knowledgeForm.value.name,
          description: knowledgeForm.value.description,
          createTime: new Date().toISOString(),
          fileCount: 0
        };
        knowledgeBases.value.unshift(newKnowledge);
        activeKnowledge.value = newKnowledge.id;
        ElMessage.success('知识库创建成功');
      }

      dialogVisible.value = false;
    };

    // 删除知识库
    const deleteKnowledge = (knowledge) => {
      ElMessageBox.confirm(
        `确定要删除知识库 "${knowledge.name}" 吗？`,
        '删除确认',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }
      ).then(() => {
        knowledgeBases.value = knowledgeBases.value.filter(k => k.id !== knowledge.id);
        if (activeKnowledge.value === knowledge.id && knowledgeBases.value.length > 0) {
          activeKnowledge.value = knowledgeBases.value[0].id;
        }
        ElMessage.success('知识库删除成功');
      }).catch(() => {
        // 取消删除
      });
    };

    // 上传文件
    const uploadFiles = (knowledge) => {
      currentKnowledge.value = knowledge;
      fileList.value = [];
      uploadDialogVisible.value = true;
    };

    // 处理文件变化
    const handleFileChange = (file) => {
      console.log('文件变化:', file);
    };

    // 提交上传
    const submitUpload = () => {
      // 模拟上传成功
      ElMessage.success('文件上传成功');
      uploadDialogVisible.value = false;
      
      // 更新文件数量
      if (currentKnowledge.value) {
        const index = knowledgeBases.value.findIndex(k => k.id === currentKnowledge.value.id);
        if (index !== -1) {
          knowledgeBases.value[index].fileCount += fileList.value.length || 1; // 假设上传了至少一个文件
        }
      }
    };

    // 格式化日期
    const formatDate = (dateString) => {
      const date = new Date(dateString);
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    };

    onMounted(() => {
      loadKnowledgeBases();
    });

    return {
      knowledgeBases,
      activeKnowledge,
      dialogVisible,
      uploadDialogVisible,
      isEdit,
      knowledgeForm,
      fileList,
      currentKnowledge,
      selectKnowledge,
      createKnowledge,
      editKnowledge,
      saveKnowledge,
      deleteKnowledge,
      uploadFiles,
      handleFileChange,
      submitUpload,
      formatDate
    };
  }
};
</script>

<style scoped>
.knowledge-list {
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 16px;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.list-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
}

.list-content {
  flex: 1;
  overflow-y: auto;
}

.knowledge-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 4px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.knowledge-item:hover {
  background-color: #f5f7fa;
}

.knowledge-item.active {
  background-color: #ecf5ff;
  color: #409eff;
}

.knowledge-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.knowledge-details {
  display: flex;
  flex-direction: column;
}

.knowledge-name {
  font-weight: 500;
  margin-bottom: 4px;
}

.knowledge-date {
  font-size: 12px;
  color: #909399;
}

.knowledge-actions {
  opacity: 0.6;
}

.knowledge-item:hover .knowledge-actions {
  opacity: 1;
}

.empty-list {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

.upload-demo {
  width: 100%;
}
</style>
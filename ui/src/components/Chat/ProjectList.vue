<template>
  <div class="project-list">
    <div class="list-header">
      <h3>项目列表</h3>
      <el-button type="primary" size="small" @click="createProject">
        <el-icon><Plus /></el-icon> 新建项目
      </el-button>
    </div>
    
    <el-divider></el-divider>
    
    <div class="list-content">
      <div 
        v-for="project in projects" 
        :key="project.id"
        :class="['project-item', { active: activeProject === project.id }]"
        @click="selectProject(project)"
      >
        <div class="project-info">
          <el-icon><Folder /></el-icon>
          <div class="project-details">
            <div class="project-name">{{ project.name }}</div>
            <div class="project-date">{{ formatDate(project.createTime) }}</div>
          </div>
        </div>
        <div class="project-actions">
          <el-dropdown trigger="click" @click.stop>
            <el-icon><More /></el-icon>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="editProject(project)">
                  <el-icon><EditPen /></el-icon> 编辑
                </el-dropdown-item>
                <el-dropdown-item @click="deleteProject(project)">
                  <el-icon><Delete /></el-icon> 删除
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
      
      <div v-if="projects.length === 0" class="empty-list">
        <el-empty description="暂无项目" />
      </div>
    </div>
    
    <!-- 项目表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑项目' : '新建项目'"
      width="30%"
    >
      <el-form :model="projectForm" label-width="80px">
        <el-form-item label="项目名称">
          <el-input v-model="projectForm.name" placeholder="请输入项目名称"></el-input>
        </el-form-item>
        <el-form-item label="项目描述">
          <el-input 
            v-model="projectForm.description" 
            type="textarea" 
            placeholder="请输入项目描述"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveProject">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { Plus, Folder, More, EditPen, Delete } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';

export default {
  components: {
    Plus,
    Folder,
    More,
    EditPen,
    Delete
  },
  emits: ['select-project'],
  setup(props, { emit }) {
    const projects = ref([]); // 项目列表
    const activeProject = ref(null); // 当前选中的项目
    const dialogVisible = ref(false); // 对话框显示状态
    const isEdit = ref(false); // 是否为编辑模式
    const projectForm = ref({ // 项目表单数据
      id: '',
      name: '',
      description: ''
    });

    // 加载项目列表（模拟数据）
    const loadProjects = () => {
      // 这里应该是从API获取数据，现在使用模拟数据
      projects.value = [
        { id: '1', name: '智能客服项目', description: '基于大模型的智能客服系统', createTime: '2023-05-15T10:30:00' },
        { id: '2', name: '法律咨询助手', description: '提供法律咨询服务的AI助手', createTime: '2023-06-20T14:45:00' },
        { id: '3', name: '医疗诊断系统', description: '辅助医生进行初步诊断的AI系统', createTime: '2023-07-10T09:15:00' },
        { id: '4', name: '教育辅导平台', description: '为学生提供个性化学习辅导', createTime: '2023-08-05T16:20:00' },
        { id: '5', name: '金融分析工具', description: '分析金融市场趋势和投资建议', createTime: '2023-09-12T11:40:00' }
      ];
      
      if (projects.value.length > 0) {
        activeProject.value = projects.value[0].id;
      }
    };

    // 选择项目
    const selectProject = (project) => {
      activeProject.value = project.id;
      emit('select-project', project);
    };

    // 创建新项目
    const createProject = () => {
      isEdit.value = false;
      projectForm.value = {
        id: '',
        name: '',
        description: ''
      };
      dialogVisible.value = true;
    };

    // 编辑项目
    const editProject = (project) => {
      isEdit.value = true;
      projectForm.value = {
        id: project.id,
        name: project.name,
        description: project.description
      };
      dialogVisible.value = true;
    };

    // 保存项目
    const saveProject = () => {
      if (!projectForm.value.name) {
        ElMessage.warning('请输入项目名称');
        return;
      }

      if (isEdit.value) {
        // 更新项目
        const index = projects.value.findIndex(p => p.id === projectForm.value.id);
        if (index !== -1) {
          projects.value[index] = {
            ...projects.value[index],
            name: projectForm.value.name,
            description: projectForm.value.description
          };
          ElMessage.success('项目更新成功');
        }
      } else {
        // 创建新项目
        const newProject = {
          id: Date.now().toString(), // 模拟ID生成
          name: projectForm.value.name,
          description: projectForm.value.description,
          createTime: new Date().toISOString()
        };
        projects.value.unshift(newProject);
        activeProject.value = newProject.id;
        ElMessage.success('项目创建成功');
      }

      dialogVisible.value = false;
    };

    // 删除项目
    const deleteProject = (project) => {
      ElMessageBox.confirm(
        `确定要删除项目 "${project.name}" 吗？`,
        '删除确认',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }
      ).then(() => {
        projects.value = projects.value.filter(p => p.id !== project.id);
        if (activeProject.value === project.id && projects.value.length > 0) {
          activeProject.value = projects.value[0].id;
        }
        ElMessage.success('项目删除成功');
      }).catch(() => {
        // 取消删除
      });
    };

    // 格式化日期
    const formatDate = (dateString) => {
      const date = new Date(dateString);
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    };

    onMounted(() => {
      loadProjects();
    });

    return {
      projects,
      activeProject,
      dialogVisible,
      isEdit,
      projectForm,
      selectProject,
      createProject,
      editProject,
      saveProject,
      deleteProject,
      formatDate
    };
  }
};
</script>

<style scoped>
.project-list {
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

.project-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 4px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.project-item:hover {
  background-color: #f5f7fa;
}

.project-item.active {
  background-color: #ecf5ff;
  color: #409eff;
}

.project-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.project-details {
  display: flex;
  flex-direction: column;
}

.project-name {
  font-weight: 500;
  margin-bottom: 4px;
}

.project-date {
  font-size: 12px;
  color: #909399;
}

.project-actions {
  opacity: 0.6;
}

.project-item:hover .project-actions {
  opacity: 1;
}

.empty-list {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}
</style>
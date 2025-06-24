<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目" prop="type">
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
      <el-form-item label="用户" prop="user">
        <el-input
          v-model="queryParams.user"
          placeholder="请输入上传用户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
<!--      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:post:add']"
        >新增</el-button>
      </el-col>-->
<!--      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:post:remove']"
        >删除</el-button>
      </el-col>-->
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="knowledges" @selection-change="handleSelectionChange">
      <el-table-column label="知识文件编号" align="center" prop="knowledgeId" />
      <el-table-column label="上传用户" align="center" prop="createBy" />
      <el-table-column label="项目编号" align="center" prop="projectId" />
      <el-table-column label="文件名" align="center" prop="fileName" />
      <el-table-column label="上传时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
            v-hasPermi="['chat:knowledge:queryVo']"
          >查看内容</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['chat:knowledge:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog
      title="文件内容内下"
      :visible.sync="dialogOpen"
      width="550px">
      <span>{{ fileContent }}</span>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="dialogOpen = false">OK</el-button>
      </span>
    </el-dialog>

    <!-- 添加或修改知识库对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
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
            <div slot="tip" class="el-upload__tip">只能上传txt、word、pdf文件，且不超过5M</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listKnowledge, getKnowledge, addKnowledge, listProject, delKnowledge} from "@/api/chat/knowledge";

export default {
  name: "knowledge",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      projectList: [],
      formProjectList: [],
      fileList: [{fileName: 'food.jpeg', url: ""}],
      fileData: {
        projectId: undefined
      },
      dialogOpen: false,
      fileContent: "",
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 知识库表格数据
      knowledges: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectId: undefined,
        user: undefined
      },
      // 表单参数
      form: {
        projectId: 109
      },
      // 表单校验
      rules: {
        postName: [
          { required: true, message: "岗位名称不能为空", trigger: "blur" }
        ],
        postCode: [
          { required: true, message: "岗位编码不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getProjectList();
    this.getList();
  },
  methods: {
    getProjectList() {
      listProject().then(response => {
        this.formProjectList = response.rows;
        this.projectList = Array.of({
          "projectId": undefined,
          "projectName": "全部"
        }).concat(response.rows);
        this.form.projectId = this.formProjectList.length == 0 ? undefined : this.formProjectList[0].projectId
      });
    },
    /** 查询岗位列表 */
    getList() {
      this.loading = true;
      listKnowledge(this.queryParams).then(response => {
        this.knowledges = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        postId: undefined,
        postCode: undefined,
        postName: undefined,
        status: "0",
        remark: undefined
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    handleView(row){
      const knowledgeId = row.knowledgeId;
      console.log(knowledgeId)
      getKnowledge(knowledgeId).then(response => {
        this.fileContent = response.data.content
        this.dialogOpen = true;
      });
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.queryParams.projectId = undefined;
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.postId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "上传知识库";
    },
    /** 提交按钮 */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
            addPost(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      console.log(row)
      const knowledgeData = {knowledgeId: row.knowledgeId, projectId: row.projectId};
      this.$modal.confirm('是否确认删除知识库编号为"' + knowledgeData.knowledgeId + '"的数据项？').then(function() {
        return delKnowledge(knowledgeData);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  },
};
</script>

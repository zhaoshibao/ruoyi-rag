<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <el-input
          v-model="queryParams.projectName"
          placeholder="请输入项目名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="模型类型" prop="type">
        <el-select
          v-model="selectedModel"
          placeholder="选择模型类型"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="mod in models"
            :key="mod"
            :label="mod"
            :value="mod"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:post:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['chat:project:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['chat:project:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="projectList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="项目编号" align="center" prop="projectId" />
      <el-table-column label="项目名称" align="center" prop="projectName" />
      <el-table-column label="模型类型" align="center" prop="type" />
      <el-table-column label="具体模型" align="center" prop="model" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding" width="280">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpload(scope.row)"
            v-hasPermi="['system:knowledge:add']"
          >上传知识库</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:project:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:project:remove']"
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

    <!-- 添加或修改项目对话框 -->
    <el-dialog :title="projectTitle" :visible.sync="projectOpen" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="form.projectName" placeholder="请输入项目名称" />
        </el-form-item>
        <el-form-item label="选择模型" prop="selectedModel">
          <el-radio-group v-model="form.selectedModel">
            <el-radio
              v-for="mdl in models"
              :key="mdl"
              :label="mdl"
              :value="mdl"
            >{{mdl}}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="上传知识库" :visible.sync="acknowledgeOpen" width="550px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="文件上传" prop="fileUpload">
          <el-upload
            class="upload-demo"
            :action="fileUploadUrl"
            :headers="fileUploadHeaders"
            :data="fileData"
            :on-success="handleSuccess"
            :before-remove="removeFile"
            name="file"
            multiple
            :file-list="fileList">
            <el-button size="small" type="primary">点击上传</el-button>
            <div slot="tip" class="el-upload__tip">只能上传txt、word、pdf文件，如果需要查看文件详情，请移步知识库管理</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="closeForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listProject, getProject, delProject, addProject, updateProject, listAcknowledges, removeFile} from "@/api/chat/project";
import { getToken } from "@/utils/auth";

export default {
  name: "Post",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      models: [
        "openai gpt-3.5-turbo",
        "ollama qwen2:7b"
      ],
      fileList: [],
      fileData: {},
      fileUploadUrl: process.env.VUE_APP_BASE_API + '/chat/knowledge/upload',
      fileUploadHeaders: {Authorization: 'Bearer ' + getToken()},
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
      // 项目列表
      projectList: [],
      // 弹出层标题
      projectTitle: "",
      // 是否显示弹出层
      projectOpen: false,
      acknowledgeOpen: false,
      // 已选择模型
      selectedModel: undefined,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectName: undefined,
        type: undefined,
        model: undefined
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        projectName: [
          { required: true, message: "项目名称不能为空", trigger: "blur" }
        ],
        selectedModel: [
          { required: true, message: "请选择模型", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  watch: {
    selectedModel(n, o) {
      if (n != undefined){
        let mt = n.split(" ");
        this.queryParams.type = mt[0];
        this.queryParams.model = mt[1];
      } else {
        this.queryParams.type = undefined;
        this.queryParams.model = undefined;
      }
    },
    form: {
      immediate: true,
      deep: true,
      handler(n, o) {
        let slctModel = n.selectedModel
        if (slctModel != undefined){
          let mt = slctModel.split(" ");
          this.form.type = mt[0];
          this.form.model = mt[1];
        } else {
          this.form.type = undefined;
          this.form.model = undefined;
        }
      }
    }
  },
  methods: {
    /** 查询项目列表 */
    getList() {
      this.loading = true;
      listProject(this.queryParams).then(response => {
        this.projectList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.projectOpen = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        projectId: undefined,
        selectedModel: this.models[0],
        type: undefined,
        model: undefined
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.selectedModel = undefined;
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.projectId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.projectOpen = true;
      this.projectTitle = "添加项目";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const projectId = row.projectId || this.ids
      getProject(projectId).then(response => {
        this.form = response.data;
        this.form.selectedModel = this.form.type + " " + this.form.model;
        this.projectOpen = true;
        this.projectTitle = "修改项目";
      });
    },
    handleUpload(row) {
      this.fileData.projectId = row.projectId || this.ids
      listAcknowledges(this.fileData).then(response => {
        this.form = response.rows;
        this.acknowledgeOpen = true;
      });
    },
    handleSuccess(res, file){
      if (res.code === 200) {
        this.fileList.push({ id: res.data, name: file.name});
        this.$modal.msgSuccess("文件上传成功");
      } else {
        this.$modal.msgSuccess("文件上传失败");
      }
    },
    removeFile(file, fileList){
      let removeFileData = {knowledgeId: file.id, projectId: this.fileData.projectId};
      removeFile(removeFileData).then(response => {
        if (response.code === 200) {
          this.fileList = fileList;
          return true;
        }
        return false;
      });
    },
    closeForm(){
      this.fileList = [];
      this.acknowledgeOpen = false;
    },
    // upload(){
    //   uploadFile(this.fileData).then(response => {
    //     this.$modal.msgSuccess("上传成功");
    //     this.acknowledgeOpen = false;
    //   });
    // },
    /** 提交按钮 */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.projectId != undefined) {
            updateProject(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.projectOpen = false;
              this.getList();
            });
          } else {
            addProject(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.projectOpen = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const projectIds = row.projectId || this.ids;
      this.$modal.confirm('是否确认删除项目编号为"' + projectIds + '"的数据项？').then(function() {
        return delProject(projectIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

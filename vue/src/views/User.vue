<template>
  <div>
    <div style="margin: 10px 0">
      <el-input
          v-model="username"
          placeholder="请输入学号"
          style="width: 200px"
          suffix-icon="el-icon-search"
      ></el-input>
      <el-input
          v-model="realname"
          class="ml-5"
          placeholder="请输入姓名"
          style="width: 200px"
          suffix-icon="el-icon-message"
      ></el-input>
      <el-input
          v-model="address"
          class="ml-5"
          placeholder="请输入地址"
          style="width: 200px"
          suffix-icon="el-icon-position"
      ></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd">新增 <i class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm
          cancel-button-text="我再想想"
          class="ml-5"
          confirm-button-text="确定"
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
          @confirm="delBatch"
      >
        <el-button slot="reference" type="danger">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
      <el-upload
          :action="'http://' + serverIp + ':8081/user/import'"
          :on-success="handleExcelImportSuccess"
          :show-file-list="false"
          accept="xlsx"
          style="display: inline-block"
      >
        <el-button class="ml-5" type="primary">导入 <i class="el-icon-bottom"></i></el-button>
      </el-upload>
      <el-button class="ml-5" type="primary" @click="exp">导出 <i class="el-icon-top"></i></el-button>
    </div>

    <el-table
        :data="tableData"
        :header-cell-class-name="'headerBg'"
        border
        stripe
        @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column label="ID" prop="id" width="80"></el-table-column>
      <el-table-column label="用户名" prop="username" width="140"></el-table-column>
      <el-table-column label="角色" prop="role">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.role === 'ROLE_ADMIN'" type="primary">管理员</el-tag>
          <el-tag v-if="scope.row.role === 'ROLE_TEACHER'" type="warning">辅导员</el-tag>
          <el-tag v-if="scope.row.role === 'ROLE_STUDENT'" type="success">学生</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="姓名" prop="realname" width="120"></el-table-column>
      <el-table-column label="邮箱" prop="email"></el-table-column>
      <el-table-column label="电话" prop="phone"></el-table-column>
      <el-table-column label="地址" prop="address"></el-table-column>
      <el-table-column align="center" label="操作" width="500">
        <template slot-scope="scope">
          <el-button
              v-if="scope.row.role === 'ROLE_TEACHER'"
              type="primary"
              @click="lookCourse(scope.row.courses)"
          >查看教授课程 <i class="el-icon-document"></i
          ></el-button>
          <el-button
              v-if="scope.row.role === 'ROLE_STUDENT'"
              type="warning"
              @click="lookStuCourse(scope.row.stuCourses)"
          >查看已选课程 <i class="el-icon-document"></i
          ></el-button>
          <el-button type="success" @click="handleEdit(scope.row)"
          >编辑 <i class="el-icon-edit"></i
          ></el-button>
          <el-popconfirm
              cancel-button-text="我再想想"
              class="ml-5"
              confirm-button-text="确定"
              icon="el-icon-info"
              icon-color="red"
              title="您确定删除吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button slot="reference" type="danger"
            >删除 <i class="el-icon-remove-outline"></i
            ></el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div style="padding: 10px 0">
      <el-pagination
          :current-page="pageNum"
          :page-size="pageSize"
          :page-sizes="[2, 5, 10, 20]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
      >
      </el-pagination>
    </div>

    <el-dialog :visible.sync="dialogFormVisible" title="用户信息" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="用户名">
          <el-input v-model="form.username" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="form.role" clearable placeholder="请选择角色" style="width: 100%">
            <el-option
                v-for="item in roles"
                :key="item.name"
                :label="item.name"
                :value="item.flag"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="姓名">
          <el-input v-model="form.realname" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="电话">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="vis" title="课程信息" width="30%">
      <el-table :data="courses" border stripe>
        <el-table-column label="课程名称" prop="name"></el-table-column>
        <el-table-column label="学分" prop="score"></el-table-column>
      </el-table>
    </el-dialog>

    <el-dialog :visible.sync="stuVis" title="课程信息" width="30%">
      <el-table :data="stuCourses" border stripe>
        <el-table-column label="课程名称" prop="name"></el-table-column>
        <el-table-column label="学分" prop="score"></el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import {serverIp} from '../../public/config'

export default {
  name: 'User',
  data() {
    return {
      serverIp: serverIp,
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      username: '',
      realname: '',
      address: '',
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
      roles: [],
      courses: [],
      vis: false,
      stuCourses: [],
      stuVis: false,
    }
  },
  created() {
    this.load()
  },
  methods: {
    lookCourse(courses) {
      this.courses = courses
      this.vis = true
    },
    lookStuCourse(stuCourses) {
      this.stuCourses = stuCourses
      this.stuVis = true
    },
    load() {
      this.request
          .get('/user/page', {
            params: {
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              username: this.username,
              realname: this.realname,
              address: this.address,
            },
          })
          .then((res) => {
            this.tableData = res.data.records
            this.total = res.data.total
          })

      this.request.get('/role').then((res) => {
        this.roles = res.data
      })
    },
    save() {
      this.request.post('/user', this.form).then((res) => {
        if (res.code === '200') {
          this.$message.success('保存成功')
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error('保存失败')
        }
      })
    },
    handleAdd() {
      this.dialogFormVisible = true
      this.form = {}
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
    },
    del(id) {
      this.request.delete('/user/' + id).then((res) => {
        if (res.code === '200') {
          this.$message.success('删除成功')
          this.load()
        } else {
          this.$message.error('删除失败')
        }
      })
    },
    handleSelectionChange(val) {
      console.log(val)
      this.multipleSelection = val
    },
    delBatch() {
      let ids = this.multipleSelection.map((v) => v.id) // [{}, {}, {}] => [1,2,3]
      this.request.post('/user/del/batch', ids).then((res) => {
        if (res.code === '200') {
          this.$message.success('批量删除成功')
          this.load()
        } else {
          this.$message.error('批量删除失败')
        }
      })
    },
    reset() {
      this.username = ''
      this.realname = ''
      this.address = ''
      this.load()
    },
    handleSizeChange(pageSize) {
      console.log(pageSize)
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum)
      this.pageNum = pageNum
      this.load()
    },
    exp() {
      window.open(`http://${serverIp}:8081/user/export`)
    },
    handleExcelImportSuccess() {
      this.$message.success('导入成功')
      this.load()
    },
  },
}
</script>

<style>
.headerBg {
  background: #eee !important;
}
</style>

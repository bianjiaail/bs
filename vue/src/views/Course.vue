<template>
  <div>
    <div style="margin: 10px 0">
      <el-input v-model="name" placeholder="请输入名称" style="width: 200px" suffix-icon="el-icon-search"></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>
    <div style="margin: 10px 0">
      <el-button v-if="user.role === 'ROLE_ADMIN'" type="primary" @click="handleAdd">新增 <i
          class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm
          cancel-button-text='我再想想'
          class="ml-5"
          confirm-button-text='确定'
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
          @confirm="delBatch"
      >
        <el-button slot="reference" type="danger">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>

    </div>
    <el-table :data="tableData" :header-cell-class-name="'headerBg'" border stripe
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column label="ID" prop="id" width="80"></el-table-column>
      <el-table-column label="课程名称" prop="name"></el-table-column>
      <el-table-column label="文件类型" prop="score"></el-table-column>
      <el-table-column label="课时" prop="times"></el-table-column>
      <el-table-column label="授课老师" prop="teacher"></el-table-column>
      <el-table-column label="启用">
        <template slot-scope="scope">
          <el-switch v-model="scope.row.state" active-color="#13ce66" inactive-color="#ccc"
                     @change="changeEnable(scope.row)"></el-switch>
        </template>
      </el-table-column>
      <el-table-column align="center" label="操作" width="280">
        <template slot-scope="scope">
          <el-button type="primary" @click="selectCourse(scope.row.id)">选课</el-button>
          <el-button v-if="user.role === 'ROLE_ADMIN'" type="success" @click="handleEdit(scope.row)">编辑 <i
              class="el-icon-edit"></i></el-button>
          <el-popconfirm
              cancel-button-text='我再想想'
              class="ml-5"
              confirm-button-text='确定'
              icon="el-icon-info"
              icon-color="red"
              title="您确定删除吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button v-if="user.role === 'ROLE_ADMIN'" slot="reference" type="danger">删除 <i
                class="el-icon-remove-outline"></i></el-button>
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
          @current-change="handleCurrentChange">
      </el-pagination>
    </div>

    <el-dialog :visible.sync="dialogFormVisible" title="课程信息" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="学分">
          <el-input v-model="form.score" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="课时">
          <el-input v-model="form.times" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="老师">
          <el-select v-model="form.teacherId" clearable placeholder="请选择">
            <el-option v-for="item in teachers" :key="item.id" :label="item.realname" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>

export default {
  name: "Course",
  data() {
    return {
      form: {},
      tableData: [],
      name: '',
      multipleSelection: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      dialogFormVisible: false,
      teachers: [],
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {}
    }
  },
  created() {
    this.load()
  },
  methods: {
    selectCourse(courseId) {
      this.request.post('/course/studentCourse/' + courseId + "/" + this.user.id).then(res => {
        if (res.code === '200') {
          this.$message.success("选课成功")
        } else {
          this.$message.success(res.msg)
        }
      })
    },
    load() {
      this.request.get("/course/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {

        this.tableData = res.data.records
        this.total = res.data.total

      })

      this.request.get("/user/role/ROLE_TEACHER").then(res => {
        this.teachers = res.data
      })
    },
    changeEnable(row) {
      this.request.post("/course/update", row).then(res => {
        if (res.code === '200') {
          this.$message.success("操作成功")
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
      this.request.delete("/course/" + id).then(res => {
        if (res.code === '200') {
          this.$message.success("删除成功")
          this.load()
        } else {
          this.$message.error("删除失败")
        }
      })
    },
    handleSelectionChange(val) {
      console.log(val)
      this.multipleSelection = val
    },
    delBatch() {
      let ids = this.multipleSelection.map(v => v.id)  // [{}, {}, {}] => [1,2,3]
      this.request.post("/course/del/batch", ids).then(res => {
        if (res.code === '200') {
          this.$message.success("批量删除成功")
          this.load()
        } else {
          this.$message.error("批量删除失败")
        }
      })
    },
    save() {
      this.request.post("/course", this.form).then(res => {
        if (res.code === '200') {
          this.$message.success("保存成功")
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error("保存失败")
        }
      })
    },
    reset() {
      this.name = ""
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
    download(url) {
      window.open(url)
    },
  }
}
</script>

<style scoped>

</style>

<template>
  <div>
    <div style="margin: 10px 0">
      <el-input v-model="name" placeholder="请输入名称" style="width: 200px" suffix-icon="el-icon-search"></el-input>

      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd(null)">新增 <i class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm cancel-button-text="我再想想" class="ml-5" confirm-button-text="确定" icon="el-icon-info"
                     icon-color="red" title="您确定批量删除这些数据吗？" @confirm="delBatch">
        <el-button slot="reference" type="danger">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" :header-cell-class-name="'headerBg'" border default-expand-all row-key="id" stripe
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column label="ID" prop="id" width="80"></el-table-column>
      <el-table-column label="名称" prop="name"></el-table-column>
      <el-table-column label="路径" prop="path"></el-table-column>
      <el-table-column label="页面路径" prop="pagePath"></el-table-column>
      <el-table-column align="center" class-name="fontSize18" label="图标" label-class-name="fontSize12">
        <template slot-scope="scope">
          <span :class="scope.row.icon"/>
        </template>
      </el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>
      <el-table-column label="顺序" prop="sortNum"></el-table-column>
      <el-table-column align="center" label="操作" width="300">
        <template slot-scope="scope">
          <!-- v-if 添加条件  && !scope.row.path  没有路径 -->
          <el-button v-if="!scope.row.pid && !scope.row.path" type="primary" @click="handleAdd(scope.row.id)">新增子菜单 <i
              class="el-icon-plus"></i></el-button>
          <el-button type="success" @click="handleEdit(scope.row)">编辑 <i class="el-icon-edit"></i></el-button>
          <el-popconfirm cancel-button-text="我再想想" class="ml-5" confirm-button-text="确定" icon="el-icon-info"
                         icon-color="red" title="您确定删除吗？" @confirm="del(scope.row.id)">
            <el-button slot="reference" type="danger">删除 <i class="el-icon-remove-outline"></i></el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :visible.sync="dialogFormVisible" title="菜单信息" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="路径">
          <el-input v-model="form.path" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="页面路径">
          <el-input v-model="form.pagePath" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="图标">
          <el-select v-model="form.icon" clearable placeholder="请选择" style="width: 100%">
            <el-option v-for="item in options" :key="item.name" :label="item.name" :value="item.value"><i
                :class="item.value"/> {{ item.name }}
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="顺序">
          <el-input v-model="form.sortNum" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" autocomplete="off"></el-input>
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
  name: 'Menu',
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: '',
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
      options: [],
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request
          .get('/menu', {
            params: {
              name: this.name,
            },
          })
          .then((res) => {
            this.tableData = res.data
          })

      // 请求图标的数据
      this.request.get('/menu/icons').then((res) => {
        this.options = res.data
      })
    },
    save() {
      this.request.post('/menu', this.form).then((res) => {
        if (res.code === '200') {
          this.$message.success('保存成功')
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error('保存失败')
        }
      })
    },
    handleAdd(pid) {
      this.dialogFormVisible = true
      this.form = {}
      if (pid) {
        this.form.pid = pid
      }
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true

      // 请求图标数据
      this.request.get('/menu/icons').then((res) => {
        this.options = res.data
      })
    },
    del(id) {
      this.request.delete('/menu/' + id).then((res) => {
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
      this.request.post('/menu/del/batch', ids).then((res) => {
        if (res.code === '200') {
          this.$message.success('批量删除成功')
          this.load()
        } else {
          this.$message.error('批量删除失败')
        }
      })
    },
    reset() {
      this.name = ''
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

.fontSize18 {
  font-size: 18px;
}

.fontSize12 {
  font-size: 12px;
}
</style>

<template>
  <div>
    <div style="margin: 10px 0">
      <el-input
          v-model="sno"
          placeholder="请输入学号"
          style="width: 200px"
          suffix-icon="el-icon-search"
      ></el-input>
      <el-input
          v-model="sname"
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
      <el-table-column label="ID" prop="id" width="40"></el-table-column>
      <el-table-column label="学号" prop="sno" width="100"></el-table-column>
      <el-table-column label="学生姓名" prop="sname" width="100"></el-table-column>
      <el-table-column label="父亲姓名" prop="sfather"></el-table-column>
      <el-table-column label="母亲姓名" prop="smother"></el-table-column>
      <el-table-column label="父亲联系方式" prop="telephone1"></el-table-column>
      <el-table-column label="母亲联系方式" prop="telephone2"></el-table-column>
      <el-table-column label="户籍地址" prop="address"></el-table-column>
      <el-table-column label="班级" prop="cid"></el-table-column>
      <el-table-column align="center" label="操作" width="200">
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

    <el-dialog :visible.sync="dialogFormVisible" title="学生信息" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="学号">
          <el-input v-model="form.sno" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="学生姓名">
          <el-input v-model="form.sname" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="父亲姓名">
          <el-input v-model="form.sfather" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="母亲姓名">
          <el-input v-model="form.smother" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="父亲联系方式">
          <el-input v-model="form.telephone1" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="母亲联系方式">
          <el-input v-model="form.telephone2" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="班级">
          <el-input v-model="form.cid" autocomplete="off"></el-input>
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
      sno: '',
      sname: '',
      address: '',
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],

    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request
          .get('/studentInfo/page', {
            params: {
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              sno: this.sno,
              sname: this.sname,
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
      this.request.post('/studentInfo', this.form).then((res) => {
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
      this.request.delete('/studentInfo/' + id).then((res) => {
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
      this.request.post('/studentInfo/del/batch', ids).then((res) => {
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
      window.open(`http://${serverIp}:8081/studentInfo/export`)
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

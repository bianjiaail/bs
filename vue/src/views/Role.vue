<template>
  <div>
    <div style="margin: 10px 0">
      <el-input v-model="name" placeholder="请输入名称" style="width: 200px" suffix-icon="el-icon-search"></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd">新增 <i class="el-icon-circle-plus-outline"></i></el-button>
      <el-popconfirm cancel-button-text="我再想想" class="ml-5" confirm-button-text="确定" icon="el-icon-info"
                     icon-color="red" title="您确定批量删除这些数据吗？" @confirm="delBatch">
        <el-button slot="reference" type="danger">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" :header-cell-class-name="'headerBg'" border stripe
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column label="ID" prop="id" width="80"></el-table-column>
      <el-table-column label="名称" prop="name"></el-table-column>
      <el-table-column label="唯一标识" prop="flag"></el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>
      <el-table-column align="center" label="操作" width="280">
        <template slot-scope="scope">
          <el-button type="info" @click="selectMenu(scope.row)">分配菜单 <i class="el-icon-menu"></i></el-button>
          <el-button type="success" @click="handleEdit(scope.row)">编辑 <i class="el-icon-edit"></i></el-button>
          <el-popconfirm cancel-button-text="我再想想" class="ml-5" confirm-button-text="确定" icon="el-icon-info"
                         icon-color="red" title="您确定删除吗？" @confirm="del(scope.row.id)">
            <el-button slot="reference" type="danger">删除 <i class="el-icon-remove-outline"></i></el-button>
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

    <el-dialog :visible.sync="dialogFormVisible" title="角色信息" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="唯一标识">
          <el-input v-model="form.flag" autocomplete="off"></el-input>
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

    <el-dialog :visible.sync="menuDialogVis" title="菜单分配" width="30%">
      <el-tree ref="tree" :data="menuData" :default-checked-keys="checks" :default-expanded-keys="expends"
               :props="props" node-key="id"
               show-checkbox>
				<span slot-scope="{ data }" class="custom-tree-node">
					<span><i :class="data.icon"></i> {{ data.name }}</span>
				</span>
      </el-tree>
      <div slot="footer" class="dialog-footer">
        <el-button @click="menuDialogVis = false">取 消</el-button>
        <el-button type="primary" @click="saveRoleMenu">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Role',
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: '',
      form: {},
      dialogFormVisible: false,
      menuDialogVis: false,
      multipleSelection: [],
      menuData: [],
      props: {
        label: 'name',
      },
      expends: [],
      checks: [],
      roleId: 0,
      roleFlag: '',
      ids: [],
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request
          .get('/role/page', {
            params: {
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              name: this.name,
            },
          })
          .then((res) => {
            this.tableData = res.data.records
            this.total = res.data.total
          })
    },
    save() {
      this.request.post('/role', this.form).then((res) => {
        if (res.code === '200') {
          this.$message.success('保存成功')
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$message.error('保存失败')
        }
      })
    },
    saveRoleMenu() {
      this.request.post('/role/roleMenu/' + this.roleId, this.$refs.tree.getCheckedKeys()).then((res) => {
        if (res.code === '200') {
          this.$message.success('更改成功')
          this.menuDialogVis = false

          if (this.roleFlag === 'ROLE_ADMIN') {
            this.$store.commit('logout')
          }
        } else {
          this.$message.error(res.msg)
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
      this.request.delete('/role/' + id).then((res) => {
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
      this.request.post('/role/del/batch', ids).then((res) => {
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
    selectMenu(role) {

      this.roleId = role.id
      this.roleFlag = role.flag

      // 请求菜单数据
      this.request.get('/menu').then((res) => {
        this.menuData = res.data
        // 把后台返回的菜单数据处理成 id数组
        this.expends = this.menuData.map((v) => v.id)
      })

      this.request.get('/role/roleMenu/' + this.roleId).then((res) => {

        this.checks = res.data

        this.request.get('/menu/ids').then((r) => {
          const ids = r.data
          ids.forEach((id) => {
            if (!this.checks.includes(id)) {
              this.$nextTick(() => {
                this.$refs.tree.setChecked(id, false)
              })

            }
          })
        })
        this.menuDialogVis = true
      })
    },
  },
}
</script>

<style>
.headerBg {
  background: #eee !important;
}
</style>

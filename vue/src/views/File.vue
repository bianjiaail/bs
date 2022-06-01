<template>
  <div>
    <div style="margin: 10px 0">
      <el-input
          v-model="name"
          placeholder="请输入名称"
          style="width: 200px"
          suffix-icon="el-icon-search"
      ></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>
    <div style="margin: 10px 0">
      <el-upload
          :action="'http://' + serverIp + ':8081/file/upload'"
          :on-success="handleFileUploadSuccess"
          :show-file-list="false"
          style="display: inline-block"
      >
        <el-button class="ml-5" type="primary">上传文件 <i class="el-icon-top"></i></el-button>
      </el-upload>
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
      <el-table-column label="文件名称" prop="name"></el-table-column>
      <el-table-column label="文件类型" prop="type"></el-table-column>
      <el-table-column label="文件大小(kb)" prop="size"></el-table-column>
      <el-table-column label="预览">
        <template slot-scope="scope">
          <el-button type="primary" @click="preview(scope.row.url)">预览</el-button>
        </template>
      </el-table-column>
      <el-table-column label="下载">
        <template slot-scope="scope">
          <el-button type="primary" @click="download(scope.row.url)">下载</el-button>
        </template>
      </el-table-column>
      <el-table-column label="启用">
        <template slot-scope="scope">
          <el-switch
              v-model="scope.row.enable"
              active-color="#13ce66"
              inactive-color="#ccc"
              @change="changeEnable(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column align="center" label="操作" width="200">
        <template slot-scope="scope">
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
  </div>
</template>

<script>
import {serverIp} from '../../public/config'

export default {
  name: 'File',
  data() {
    return {
      serverIp: serverIp,
      tableData: [],
      name: '',
      multipleSelection: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.request
          .get('/file/page', {
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
    changeEnable(row) {
      this.request.post('/file/update', row).then((res) => {
        if (res.code === '200') {
          this.$message.success('操作成功')
        }
      })
    },
    del(id) {
      this.request.delete('/file/' + id).then((res) => {
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
      this.request.post('/file/del/batch', ids).then((res) => {
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
    handleFileUploadSuccess(res) {
      console.log(res)
      this.$message.success('上传成功')
      this.load()
    },
    download(url) {
      window.open(url)
    },
    preview(url) {
      window.open('https://file.keking.cn/onlinePreview?url=' + encodeURIComponent(window.btoa(url)))
    },
  },
}
</script>

<style scoped></style>

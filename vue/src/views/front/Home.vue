<template>
  <div>
    <div>

    </div>

    <div style="margin: 10px 0">
      <el-row :gutter="10">
        <el-col v-for="item in files" :key="item.id" :span="6" style="margin-bottom: 10px"></el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FrontHome',
  data() {
    return {
      imgs: [],
      files: [],
    }
  },
  created() {
    this.request.get('/echarts/file/front/all').then((res) => {
      console.log(res.data)
      this.files = res.data.filter((v) => v.type === 'png' || v.type === 'jpg' || v.type === 'webp')
    })
  },
  methods: {},
}
</script>

<style></style>

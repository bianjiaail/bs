<template>
  <div class="homepage-hero-module">
    <div class="video-container">
      <div :style="fixStyle" class="filter">
        <div style="width: 400px; margin: 100px auto">
          <div style="font-size: 30px; text-align: center; padding: 30px 0; color: #333">欢迎登录 辅导员事务管理系统</div>
          <el-form ref="form" :model="form" :rules="rules" size="normal">
            <el-form-item prop="username">
              <el-input v-model="form.username" placeholder="请输入用户名(工号/学号 )"
                        prefix-icon="el-icon-user-solid"></el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input v-model="form.password" placeholder="请输入密码" prefix-icon="el-icon-lock" show-password></el-input>
            </el-form-item>
            <el-form-item>
              <div style="display: flex">
                <el-input v-model="form.validCode" placeholder="请输入验证码" prefix-icon="el-icon-key" style="width: 50%"
                          @keyup.enter.native="login"></el-input>
                <ValidCode @input="createValidCode"/>
              </div>
            </el-form-item>
            <!--            <el-form-item>-->
            <!--              <el-radio v-model="form.role" :label="1" style="color: white">管理员</el-radio>-->
            <!--              <el-radio v-model="form.role" :label="2" style="color: white">普通用户</el-radio>-->
            <!--            </el-form-item>-->
            <el-form-item>
              <el-button style="width: 100%" type="primary" @click="login">登 录</el-button>
            </el-form-item>
            <el-form-item>
              <el-button type="text" @click="$router.push('')">忘记密码</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <img :style="fixStyle" alt="背景" autoplay class="fillWidth" loop muted src="../assets/loginbg.jpg"/>
    </div>
  </div>
</template>

<script>
import request from '../utils/request'
import ValidCode from '../components/ValidCode'
import {setRoutes} from '@/router'

export default {
  name: 'Login',
  components: {
    ValidCode,
  },
  data() {
    return {
      fixStyle: '',
      form: {role: 1},
      rules: {
        username: [{required: true, message: '请输入用户名', trigger: 'blur'}],
        password: [{required: true, message: '请输入密码', trigger: 'blur'}],
      },
      validCode: '',
    }
  },
  mounted() {
    sessionStorage.removeItem('user')
  },
  methods: {
    // 接收验证码组件提交的 4位验证码
    createValidCode(data) {
      this.validCode = data
    },
    login() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          if (!this.form.validCode) {
            this.$message.error('请填写验证码')
            return
          }
          if (this.form.validCode.toLowerCase() !== this.validCode.toLowerCase()) {
            this.$message.error('验证码错误')
            return
          }
          request.post('/user/login', this.form).then((res) => {
            if (res.code === '200') {
              localStorage.setItem('user', JSON.stringify(res.data)) // 存储用户信息到浏览器
              localStorage.setItem('menus', JSON.stringify(res.data.menus)) // 存储用户信息到浏览器

              /// 动态设置当前用户的路由
              setRoutes()
              this.$message.success('登录成功')
              this.$router.push('/') //登录成功之后进行页面的跳转，跳转到主页
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
  },
}
</script>

<style scoped>
.homepage-hero-module,
.video-container {
  position: relative;
  height: 100vh;
  overflow: hidden;
}

.video-container .poster img {
  z-index: 0;
  position: absolute;
}

.video-container .filter {
  z-index: 1;
  position: absolute;
  /*background: rgba(0, 0, 0, 0.4);*/
  width: 100%;
}

.fillWidth {
  width: 100%;
  height: 100%;
}
</style>

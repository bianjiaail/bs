<template>
  <el-menu
      :collapse="isCollapse"
      :collapse-transition="false"
      :default-openeds="opens"
      active-text-color="#ffd04b"
      background-color="rgb(48, 65, 86)"
      router
      style="min-height: 100%; overflow-x: hidden"
      text-color="#fff"
  >
    <div style="height: 60px; line-height: 60px; text-align: center">
      <img alt="" src="../assets/logo.png" style="width: 20px; position: relative; top: 5px"/>
      <b v-show="logoTextShow" style="color: white; margin-left: 5px">辅导员事务管理系统</b>
    </div>
    <div v-for="item in menus" :key="item.id">
      <div v-if="item.path">
        <el-menu-item :index="item.path">
          <i :class="item.icon"></i>
          <span slot="title">{{ item.name }}</span>
        </el-menu-item>
      </div>
      <div v-else>
        <el-submenu :index="item.id + ''">
          <template slot="title">
            <i :class="item.icon"></i>
            <span slot="title">{{ item.name }}</span>
          </template>
          <div v-for="subItem in item.children" :key="subItem.id">
            <el-menu-item :index="subItem.path">
              <i :class="subItem.icon"></i>
              <span slot="title">{{ subItem.name }}</span>
            </el-menu-item>
          </div>
        </el-submenu>
      </div>
    </div>
  </el-menu>
</template>

<script>
export default {
  name: 'Aside',
  props: {
    isCollapse: Boolean,
    logoTextShow: Boolean,
  },
  data() {
    return {
      menus: localStorage.getItem('menus') ? JSON.parse(localStorage.getItem('menus')) : [],
      opens: localStorage.getItem('menus') ? JSON.parse(localStorage.getItem('menus')).map((v) => v.id + '') : [],
    }
  },
}
</script>

<style>
.el-menu-item.is-active {
  background-color: rgb(38, 52, 69) !important;
}

.el-menu-item:hover {
  background-color: rgb(38, 52, 69) !important;
}

.el-submenu__title:hover {
  background-color: rgb(38, 52, 69) !important;
}

/*解决收缩菜单文字不消失问题*/
.el-menu--collapse span {
  visibility: hidden;
}
</style>

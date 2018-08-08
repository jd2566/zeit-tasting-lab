<template>
  <el-menu :default-active="active" mode="horizontal" router>
    <el-menu-item index="menu">Menu Editor</el-menu-item>
    <el-menu-item index="match_maker">Match Maker</el-menu-item>
  </el-menu>
</template>

<script>
  export default {
    data: function () {
      return {
        active: "menu"
      }
    },
    methods: {

    }
  }
</script>

<style scoped>

</style>

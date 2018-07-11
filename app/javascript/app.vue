<template>
  <div id="lab">
    <el-container style="padding:10px;">

      <el-aside width="35vw" style="height: 98vh;">
        <item-selector></item-selector>
      </el-aside>

      <el-container style="height: 98vh;">

        <el-header>
          <main-menu></main-menu>
        </el-header>

        <el-main>
          <router-view></router-view>
        </el-main>

      </el-container>

    </el-container>

    <user-panel></user-panel>
  </div>
</template>

<script>
import UserPanel from './parts/user-panel.vue'
import MainMenu from './parts/main-menu.vue'
import ItemSelector from './parts/item-selector.vue'

export default {
  data: function () {
    return {
    }
  },
  components: {
    MainMenu,
    UserPanel,
    ItemSelector
  },
}
</script>

<style scoped>
</style>

<template>
  <el-card shadow="never">
    <div slot="header">
      已選擇品項
    </div>
    <el-tag v-for="item in getSelected" :key="item.id" style="margin:5px 0 2px 0;">{{ item.name }}</el-tag>
  </el-card>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {

      }
    },
    computed: {
      ...mapGetters([
        'getSelected'
      ])
    },
    methods: {

    }
  }
</script>

<style scoped>

</style>

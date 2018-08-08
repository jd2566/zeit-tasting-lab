<template>
  <el-container>
    <el-main>
      <el-row>

      </el-row>
    </el-main>
  </el-container>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        items
      }
    },
    computed: {
      ...mapGetters([
        'getSelected'
      ])
    },
    mounted() {
      this.$nextTick(function () {
        if (this.$store.getters.isLoggedIn) {

        }
      })
    },
    methods: {

    }
  }
</script>

<style scoped>

</style>

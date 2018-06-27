<template>
  <el-row>
    ABC
  </el-row>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        category: {
          id: "",
          name: ""
        }
      }
    },
    computed: {
      ...mapGetters([
        'getCategory'
      ])
    },
    watch: {
      getCategory: {
        deep: true,
        handler: function (new_category) {
          this.loadItems();
        }
      }
    },
    mounted() {
      if (this.getCategory.id !== '') {
        this.loadItems();
      }
    },
    methods: {
      loadItems () {
        console.log(this.getCategory.id)
      }
    }
  }
</script>

<style scoped>

</style>

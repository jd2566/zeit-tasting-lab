<template>
  <el-container>
    <el-header style="height:10vh;">
      <h2 class="ui horizontal divider header" style="margin:20px;">Test</h2>
    </el-header>

    <el-main style="height:88vh;">
      <div class="ui stackable two column grid">
        <div class="column" v-for="section in sections" :key="section.id">
          <div class="ui piled segment">
            <h1 class="ui horizontal divider header">
              {{ section.name }}
            </h1>
            <div class="ui vertically divided grid">
              <div class="row" v-for="item in section.items" :key="item.id">
                <div class="five wide column">
                  <img v-if="item.images.length > 0" class="ui fluid centered rounded small image" :src="item.images[0].url">
                  <img v-else class="ui fluid centered rounded small image" src="/images/nike.png">
                </div>
                <div class="eleven wide column">
                  <h2 class="ui dividing header">
                    {{ item.name }}
                  </h2>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </el-main>

  </el-container>
</template>

<script>
  export default {
    props: ['menu-id'],
    data: function () {
      return {
        loading: false,
        sections: []
      }
    },
    mounted() {
      this.loading = true;
      this.$http.get('/menu/' + this.$props.menuId + '/data/').then(response => {
        this.sections = response.body;
        this.loading = false;
      }, response => {
        this.handleError(response)
      });
    },
    methods: {

    },
    components: {

    }
  }
</script>

<style scoped>

</style>

<template>
  <el-container>
    <el-header style="height:10vh;">
      <h2 class="ui horizontal divider header" style="margin:20px;">ZEIT x LINCK</h2>
    </el-header>

    <el-main style="height:88vh;">
      <div class="ui stackable two column centered grid">
        <div class="column" v-for="section in sections" :key="section.id">
          <div class="ui piled segment">
            <h1 class="ui horizontal divider header">
              {{ section.name }}
            </h1>
            <div class="ui hidden divider"></div>
            <div class="ui vertically divided grid">
              <div class="row" v-for="item in section.items" :key="item.id">
                <div class="five wide column">
                  <img v-if="item.images.length > 0" class="ui fluid centered rounded small image" :src="item.images[0].url">
                  <img v-else class="ui fluid centered rounded small image" src="/images/zeit.jpg">
                </div>
                <div class="eleven wide column">
                  <h2 class="ui dividing header">
                    <span v-if="locale == 'tw'">{{ item.name }}</span>
                    <span v-if="locale == 'us'">{{ item.eng }}</span>
                    <span v-if="locale == 'jp'">{{ item.jpn }}</span>
                  </h2>
                  <span v-if="locale == 'tw'">{{ item.detail }}</span>
                  <span v-if="locale == 'us'">{{ item.eng_detail }}</span>
                  <span v-if="locale == 'jp'">{{ item.jpn_detail }}</span>
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
    props: ['menu-id', 'lang'],
    data: function () {
      return {
        locale: this.$props.lang,
        loading: false,
        sections: []
      }
    },
    mounted() {
      this.loading = true;
      this.$http.get('/menu/' + this.$props.menuId + '/' + this.$props.lang + '/data/').then(response => {
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

<template>
  <el-container style="">
    <el-header style="height:5vh;">
      <h1 class="ui horizontal divider header" style="margin:20px; font-size:3rem">ZEIT x LINCK</h1>
    </el-header>

    <el-main style="height:88vh;">
      <div class="ui stackable two column centered grid">
        <div class="sixteen wide mobile eight wide computer column" v-for="section in sections" :key="section.id">
          <div class="ui piled segment">
            <h1 class="ui horizontal divider header">
              {{ section.name }}
            </h1>
            <div class="ui hidden divider"></div>
            <div class="ui vertically divided grid">
              <div class="row" v-for="item in section.items" :key="item.id">
                <div class="five wide column">
                  <img v-if="item.images.length > 0" class="ui fluid centered rounded image" :src="item.images[0].url">
                  <img v-else class="ui fluid centered rounded image" src="/images/zeit.jpg">
                </div>
                <div class="eleven wide column">
                  <h2 class="ui dividing header" style="font-size:3rem">
                    <span v-if="locale == 'tw'">{{ item.name }}</span>
                    <span v-if="locale == 'us'">{{ item.eng }}</span>
                    <span v-if="locale == 'jp'">{{ item.jpn }}</span>
                  </h2>
                  <span v-if="locale == 'tw'">{{ item.detail }}</span>
                  <span v-if="locale == 'us'">{{ item.eng_detail }}</span>
                  <span v-if="locale == 'jp'">{{ item.jpn_detail }}</span>
                </div>
                <div class="ui basic segment sixteen wide column">
                  <div class="ui two column grid">
                    <div class="column" v-for="match in item.matches" :key="match.name" >
                      <div class="ui massive list">
                        <a class="item">
                          <i v-if="match.name == 'Wiffogato'" class="glass martini icon"></i>
                          <i v-else-if="match.name == 'Affogato'" class="coffee icon"></i>
                          <i v-else class="heart icon"></i>
                          <div class="content">
                            <div class="header">{{ match.name }}</div>
                            <div class="item">
                              <div v-for="i in match.items" :key="i.id" class="list">
                                <div class="item">
                                  <img v-if="i.image != undefined" class="ui small image middle aligned" :src="i.image.url">
                                  <img v-else class="ui small image middle aligned" src="/images/zeit.jpg">
                                  <div class="middle aligned content">
                                    <div class="header">{{ i.name }}</div>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </a>
                      </div>
                    </div>
                  </div>

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
    data: function () {
      return {
        menuId: this.$route.fullPath.split("/")[2],
        locale: this.$route.fullPath.split("/")[3],
        loading: false,
        sections: []
      }
    },
    mounted() {
      this.loading = true;
      this.$http.get('/menu/' + this.menuId + '/' + this.lang + '/data/').then(response => {
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
.header {
  font-size: 2.5rem;
}
</style>

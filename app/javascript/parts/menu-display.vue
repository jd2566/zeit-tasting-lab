<template>
  <el-container>
    <el-header>
      <h1 class="ui center aligned icon header" style="font-size:3rem">
        <img class="ui image" src="/images/zeit.jpg">
        ZEIT x LINCK
      </h1>
    </el-header>
    <el-main>
      <div class="ui hidden divider"></div>
      <div class="ui one column centered grid">
        <div class="sixteen wide mobile eight wide computer column">
          <div class="three ui basic buttons">
            <button v-for="section in sections" :key="section.id" class="massive ui button" style="font-size:2.3rem">
              {{ section.name }}
            </button>
          </div>
        </div>
      </div>
    </el-main>
    <el-main style="height:96vh;">
      <div class="ui stackable two column centered grid">
        <div class="sixteen wide column" v-for="section in sections" :key="section.id">
          <div class="ui piled segment">
            <h1 class="ui horizontal divider header" style="font-size:3rem">
              {{ section.name }}
            </h1>

            <div class="ui hidden divider"></div>

            <div class="ui three doubling cards">
              <div v-for="item in section.items" :key="item.id" class="card">
                <div class="image">
                  <img v-if="item.images.length > 0" class="ui fluid centered rounded image" :src="item.images[0].url">
                  <img v-else class="ui fluid centered rounded image" src="/images/zeit.jpg">
                </div>
                <div class="content" >
                  <span class="header" style="font-size: 2.6rem;"
                        v-if="locale == 'tw'">{{ item.name }}</span>
                  <span class="header" style="font-size: 2.6rem;"
                        v-if="locale == 'us'">{{ item.eng }}</span>
                  <span class="header" style="font-size: 2.6rem;"
                        v-if="locale == 'jp'">{{ item.jpn }}</span>
                  <div class="meta" style="font-size: 2.2rem;">
                    <span class="right floated">
                      {{ item.price }} <i class="dollar sign icon"></i>
                    </span>
                  </div>

                  <div class="ui hidden divider" style="margin-bottom: 2.5rem"></div>

                  <div v-for="match in item.matches" :key="match.name" style="margin-bottom: 2.5rem">
                    <div class="ui dividing header" >
                      <i v-if="match.name == 'Wiffogato'" class="glass martini grey icon"></i>
                      <i v-else-if="match.name == 'Affogato'" class="coffee grey icon"></i>
                      <i v-else class="heart grey icon"></i>
                      <div class="content" style="font-size:2.2rem">
                        {{ match.name }}
                      </div>
                    </div>
                    <div class="ui massive list">
                      <div v-for="i in match.items" :key="i.id" class="item">
                        <img v-if="i.image != undefined" class="ui tiny image middle aligned" :src="i.image.url">
                        <img v-else class="ui tiny image middle aligned" src="/images/zeit.jpg">
                        <div class="middle aligned content">
                          <div v-if="locale == 'tw'" class="header">{{ i.name }}</div>
                          <div v-if="locale == 'us'" class="header">{{ i.eng }}</div>
                          <div v-if="locale == 'jp'" class="header">{{ i.jpn }}</div>
                          <div class="meta">
                            <i class="dollar sign icon"></i>
                            {{ match.price }}
                          </div>
                        </div>
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
      this.$http.get('/menu/' + this.menuId + '/' + this.locale + '/data/').then(response => {
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
  font-size: 2.2rem;
}
</style>

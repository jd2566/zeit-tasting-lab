<template>
  <el-container>
    <el-header>
      <div class="ui top fixed borderless menu">
        <div class="item">
          <img class="ui image" style="width: 56px" src="/images/zeit.jpg">
        </div>
        <div class="item">
          ZEIT x LINCK
        </div>
        <div class="right menu">
          <a @click="openMenu(menuId, 'tw')" class="item"><i class="tw flag" target="_blank"></i></a>
          <a @click="openMenu(menuId, 'us')" class="item"><i class="us flag" target="_blank"></i></a>
          <a @click="openMenu(menuId, 'jp')" class="item"><i class="jp flag" target="_blank"></i></a>
        </div>
      </div>
    </el-header>
    <el-main>
      <div class="ui hidden divider"></div>
      <div class="ui one column centered grid">
        <div class="sixteen wide mobile eight wide computer column">
          <div class="three ui basic buttons">
            <button v-for="section in sections" :key="section.id" class="massive ui button">
              {{ section.name }}
            </button>
          </div>
        </div>
      </div>
    </el-main>
    <el-main style="height:96vh;">
      <div class="ui doubling two column centered grid">
        <div class="sixteen wide column" v-for="section in sections" :key="section.id">
          <div class="ui piled segment">
            <h1 class="ui horizontal divider header" style="font-size:3rem">
              {{ section.name }}
            </h1>

            <div class="ui hidden divider"></div>

            <div class="ui two cards">
              <div v-for="item in section.items" :key="item.id" class="card">
                <div class="image">
                  <img v-if="item.images.length > 0" class="ui fluid centered rounded image" :src="item.images[0].url">
                  <img v-else class="ui fluid centered rounded image" src="/images/zeit.jpg">
                </div>
                <div class="content" >
                  <span class="header" v-if="locale == 'tw'">{{ item.name }}</span>
                  <span class="header" v-if="locale == 'us'">{{ item.eng }}</span>
                  <span class="header" v-if="locale == 'jp'">{{ item.jpn }}</span>
                  <div class="meta">
                    <span class="right floated">
                      {{ item.price }} <i class="dollar sign icon"></i>
                    </span>
                  </div>

                  <div class="ui hidden divider" style="margin-bottom: 2.5rem"></div>

                  <div v-for="match in item.matches" :key="match.name" style="margin-bottom: 2.5rem">
                    <div class="ui dividing small header" >
                      <i v-if="match.name == 'Wiffogato'" class="glass martini grey icon"></i>
                      <i v-else-if="match.name == 'Affogato'" class="coffee grey icon"></i>
                      <i v-else class="heart grey icon"></i>
                      <div class="content">
                        {{ match.name }}
                      </div>
                    </div>

                    <div v-for="i in match.items" :key="i.id" class="item">
                      <div class="ui center aligned header">
                        <div class="ui secondary center aligned segment">
                          <img v-if="i.image != undefined" class="ui image center aligned" :src="i.image.url">
                          <img v-else class="ui image center aligned" src="/images/zeit.jpg">
                          <div class="ui header">
                            <span v-if="locale == 'tw'">{{ i.name }}</span>
                            <span v-if="locale == 'us'">{{ i.eng }}</span>
                            <span v-if="locale == 'jp'">{{ i.jpn }}</span>
                          </div>
                          <div class="ui basic label">
                            <i class="dollar sign icon"></i>
                            <span>{{ match.price }}</span>
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
      openMenu (id, lang) {
        window.location('/menu/' + id + '/' + lang);
      }
    },
    components: {

    }
  }
</script>

<style scoped>

</style>

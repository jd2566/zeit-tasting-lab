<template>
  <el-container>
    <el-header>
      <div class="ui top fixed borderless menu">
        <div class="item">
          <img class="ui image" style="width: 56px" src="/images/zeit.jpg">
        </div>
        <div class="item">
          <h3>ZEIT x LINCK</h3>
        </div>
        <div class="right menu">
          <a @click="touched('tw')" class="item"><i class="tw flag" target="_blank"></i></a>
          <a @click="touched('us')" class="item"><i class="us flag" target="_blank"></i></a>
          <a @click="touched('jp')" class="item"><i class="jp flag" target="_blank"></i></a>
        </div>
      </div>
    </el-header>
    <el-main>
      <div class="ui doubling two column centered grid">
        <div class="sixteen wide column" v-for="section in sections" :key="section.id">

            <div class="ui hidden divider"></div>

            <h2 class="ui horizontal divider header">
              {{ section.name }}
            </h2>

            <div class="ui hidden divider"></div>

            <div class="ui one cards">
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

                    <div v-if="match.name == 'Wiffogato' || match.name == 'Affogato'" class="ui two column grid">
                      <div class="six wide column" style="padding-right:0">
                        <img v-if="match.name == 'Affogato'"
                             class="ui fluid centered rounded image" src="/images/Affogato.png"
                             v-touch="">
                        <img v-else
                             class="ui fluid centered rounded image" src="/images/Wiffogato.png">
                      </div>
                      <div class="ten wide column">
                        <div v-for="i in match.items" :key="i.id" class="item">
                          <div class="ui center aligned header">
                            <div class="ui secondary center aligned segment">
                              <div class="ui small center aligned header">
                                <span v-if="locale == 'tw'">{{ i.name }}</span>
                                <span v-if="locale == 'us'">{{ i.eng }}</span>
                                <span v-if="locale == 'jp'">{{ i.jpn }}</span>
                              </div>
                              <div class="ui basic small label">
                                <i class="dollar sign icon"></i>
                                <span>{{ match.price }}</span>
                              </div>
                            </div>
                          </div>
                        </div>

                      </div>
                    </div>

                    <div v-else v-for="i in match.items" :key="i.id" class="item">
                      <div class="ui center aligned header">
                        <div class="ui secondary center aligned segment">
                          <div class="ui small center aligned header">
                            <span v-if="locale == 'tw'">{{ i.name }}</span>
                            <span v-if="locale == 'us'">{{ i.eng }}</span>
                            <span v-if="locale == 'jp'">{{ i.jpn }}</span>
                          </div>
                          <div class="ui basic small label">
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
        sections: [],
        zoomAffo: false,
        zoomWiffo: false
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
      touched (lang) {
        window.location.assign(window.location.protocol + "//" +
                               window.location.host + '/menu/' + this.menuId + '/' + lang)
      },
      zoom () {

      }
    },
    components: {

    }
  }
</script>

<style scoped>

</style>

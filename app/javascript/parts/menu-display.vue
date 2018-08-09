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
                                <a class="item">
                                  <img v-if="i.image != undefined" class="ui avatar image" :src="i.image.url">
                                  <img v-else class="ui avatar image" src="/images/zeit.jpg">
                                  <div class="content">
                                    <div class="header">{{ i.name }}</div>
                                  </div>
                                </a>
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

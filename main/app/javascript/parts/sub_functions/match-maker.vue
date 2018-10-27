<template>
  <el-container>
    <el-main>
      <el-row>
        <div class="ui action input">
          <input type="text" v-model="matches.newName">
          <button class="ui button" @click="newCategory"><i class="plus icon"></i>搭配種類</button>
        </div>
        <div class="ui hidden divider"></div>
        <el-radio-group v-model="matches.current">
          <el-radio-button v-for="match in matches.categories" :key="match.id" :label="match.name"></el-radio-button>
        </el-radio-group>
        <div class="ui hidden divider"></div>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <div class="ui fluid vertical menu">
            <a class="item" @click="editMode = 'new'">新搭配 <i class="plus icon"></i></a>
            <a v-for="match_cate in matches.match[matches.current]" :key="match_cate.match.id"
               class="item"
               @click="changeMatch(match_cate)"> {{ match_cate.match.name }} </a>
          </div>
        </el-col>
        <el-col :span="18">

          <h5 class="ui top attached header">
            搭配組成
          </h5>
          <div class="ui attached segment">
            <div class="ui basic segment">
            <div class="ui fluid icon teal basic button" @click="addItem" :disabled="getSelected.length == 0">
                <i class="angle double down icon"></i>
                加入品項
            </div>
            </div>
            <div class="ui four stackable cards">
              <div v-for="item in matchingItems" :key="item.id" class="card">
                <div class="image">
                  <img v-if="item.images.length == 0"
                       src="http://via.placeholder.com/240x240" class="image">
                  <img v-else :src="item.images[0].url" class="image" alt="">
                </div>
                <div class="content">
                  {{ item.name }}
                </div>
                <div class="ui bottom attached button" @click="removeItem(item.id)">
                  <i class="minus icon"></i>
                  移除
                </div>
              </div>
            </div>
            <div v-if="matchingItems.length == 0" class="ui message">
              未加入品項
            </div>
          </div>
          <h5 class="ui attached header">
            售價
          </h5>
          <div class="ui attached segment">

            <el-input-number v-model="makingMatch.price" controls-position="right" :min="0" :max="10000" :step="5"></el-input-number>

          </div>
          <h5 class="ui attached header">
            搭配說明
          </h5>
          <div class="ui attached segment">
            <el-tabs v-model="locale">
              <el-tab-pane label="中文" name="tw">
                <div class="ui form">
                  <div class="eight wide field">
                    <label>名稱</label>
                    <input type="text" v-model="makingMatch.name">
                  </div>
                  <div class="fields">
                    <div class="eight wide field">
                      <label>描述</label>
                      <textarea rows="4" v-model="makingMatch.detail"></textarea>
                    </div>
                    <div class="eight wide field">
                      <label>吃法</label>
                      <textarea rows="4" v-model="makingMatch.how_to"></textarea>
                    </div>
                  </div>
                </div>
              </el-tab-pane>

              <el-tab-pane label="英文" name="en">
                <div class="ui form">
                  <div class="eight wide field">
                    <label>名稱</label>
                    <input type="text" v-model="makingMatch.eng">
                  </div>
                  <div class="fields">
                    <div class="eight wide field">
                      <label>描述</label>
                      <textarea rows="4" v-model="makingMatch.eng_detail"></textarea>
                    </div>
                    <div class="eight wide field">
                      <label>吃法</label>
                      <textarea rows="4" v-model="makingMatch.eng_how_to"></textarea>
                    </div>
                  </div>
                </div>
              </el-tab-pane>

              <el-tab-pane label="日文" name="jp">
                <div class="ui form">
                  <div class="eight wide field">
                    <label>名稱</label>
                    <input type="text" v-model="makingMatch.jpn">
                  </div>
                  <div class="fields">
                    <div class="eight wide field">
                      <label>描述</label>
                      <textarea rows="4" v-model="makingMatch.jpn_detail"></textarea>
                    </div>
                    <div class="eight wide field">
                      <label>吃法</label>
                      <textarea rows="4" v-model="makingMatch.jpn_how_to"></textarea>
                    </div>
                  </div>
                </div>
              </el-tab-pane>
            </el-tabs>
          </div>
          <div v-if="editMode == 'new'" class="ui bottom attached button" @click="newMatch">Match!</div>
          <div v-if="editMode == 'edit'" class="ui bottom attached button" @click="editMatch">Edit</div>

        </el-col>

      </el-row>
    </el-main>
  </el-container>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        locale: "tw",
        header: { "headers": { "Authorization": this.$cookie.get('token')}},
        matches: {
          newName: "",
          current: "",
          categories: [],
          match: {}
        },
        editMode: "new",
        makingMatch: {
          id: "",
          name: "",
          eng: "",
          jpn: "",
          detail: "",
          how_to: "",
          eng_detail: "",
          jpn_detail: "",
          eng_how_to: "",
          jpn_how_to: "",
          price: 0
        },
        matchingItems: []
      }
    },
    computed: {
      ...mapGetters([
        'getSelected'
      ]),
      currentCategory () {
        return this.matches.current;
      }
    },
    watch: {
      currentCategory (val) {
        this.editMode = 'new';
        this.$http.get('/api/v1/categories/' + val + '/matches', this.header).then(response => {
          this.matches.match[this.currentCategory] = response.body
        }, response => {
          this.handleError(response)
        });
      },
      editMode (val) {
        if (val === 'new') {
          this.emptyMatch();
        }
      }
    },
    mounted() {
      this.$nextTick(function () {
        if (this.$store.getters.isLoggedIn) {
          this.$http.get('/api/v1/match_categories', this.header).then(response => {
            this.matches.categories = response.body;

            response.body.forEach(category => {
              this.matches.match[category.name] = []
            }, this);

            if(this.matches.categories.length > 0)
              this.matches.current = this.matches.categories[0].name;

          }, response => {
            this.handleError(response)
          });
        }
      })
    },
    methods: {
      newCategory () {
        let data = {
          categories: {
            root_category_id: 2,
            name: this.matches.newName
          }
        };
        this.$http.post('/api/v1/categories/', data, this.header).then(response => {
          let match = response.body;
          this.matches.categories.push({id: match.id, name: match.name})
          this.matches.match[match.name] = [];
          this.matches.current = match.name
          this.matches.newName = ""
        }, response => {
          this.handleError(response)
        });
      },
      addItem () {
        this.matchingItems = _.union(  this.matchingItems, this.getSelected );
        this.$store.commit("syncSelected", []);
      },
      removeItem (item_id) {
        this.matchingItems = this.matchingItems.filter(i => i.id !== item_id);
      },
      newMatch () {
        let data = {
          match: this.makingMatch,
          category: this.matches.current,
          items: _.map(this.matchingItems, 'id')
        }
        this.$http.post('/api/v1/matches/', data, this.header).then(response => {
          let match = response.body;
          this.matches.match[this.matches.current].push(match);
          this.editMode = 'new';
        }, response => {
          this.handleError(response)
        });
      },
      changeMatch (data) {
        this.editMode = 'edit'
        this.makingMatch = data.match
        this.matchingItems = data.items
      },
      editMatch () {
        let data = {
          match: this.makingMatch,
          category: this.matches.current,
          items: _.map(this.matchingItems, 'id')
        }
        this.$http.patch('/api/v1/matches/' + this.makingMatch.id, data, this.header).then(response => {
          let match = response.body;

        }, response => {
          this.handleError(response)
        });
      },
      emptyMatch () {
        this.makingMatch = {
          id: "",
          name: "",
          eng: "",
          jpn: "",
          detail: "",
          how_to: "",
          eng_detail: "",
          jpn_detail: "",
          eng_how_to: "",
          jpn_how_to: ""
        };
        this.matchingItems = [];
      }
    }
  }
</script>

<style scoped>

</style>

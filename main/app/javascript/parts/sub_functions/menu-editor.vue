<template>
  <el-row>

    <el-row :gutter="5" v-loading="menusLoading">

      <el-col :span="24">
        <el-form :inline="true" style="margin:10px;">
          <el-form-item>
            <el-input v-model="newMenuName" placeholder="名稱"></el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="success" icon="el-icon-plus" @click="newMenu">菜單</el-button>
          </el-form-item>
        </el-form>
        <el-tabs v-model="currentTab" v-if="menus.length > 0" type="border-card">
          <el-tab-pane
            v-for="(menu) in menus"
            :key="menu.id"
            v-loading="itemsLoading">
            <span slot="label"><i class="el-icon-document"></i> {{ menu.name }}</span>

            <div class="ui header">
              瀏覽菜單
            </div>
            <div class="ui basic buttons">
              <button class="ui button" @click="openMenu(menu.id, 'tw')"><i class="tw flag"></i></button>
              <button class="ui button" @click="openMenu(menu.id, 'us')"><i class="us flag"></i></button>
              <button class="ui button" @click="openMenu(menu.id, 'jp')"><i class="jp flag"></i></button>
            </div>

            <el-button type="danger"
                       icon="el-icon-delete" @click="deleteData(menu.id)"
                       style="float:right"
                       circle></el-button>
            <div class="ui dividing grey header"> <i class="list icon"></i> 分類設定</div>
            <div class="ui  segment">
              <el-form :inline="true">
                <i class="tw flag"></i>
                <el-form-item>
                  <el-input v-model="newSectionTitle.name" placeholder="中文名稱"></el-input>
                </el-form-item>
                <i class="us flag"></i>
                <el-form-item>
                  <el-input v-model="newSectionTitle.eng" placeholder="英文名稱"></el-input>
                </el-form-item>
                <i class="jp flag"></i>
                <el-form-item>
                  <el-input v-model="newSectionTitle.jpn" placeholder="日文名稱"></el-input>
                </el-form-item>

                <el-form-item>
                  <el-button type="success" icon="el-icon-plus" @click="newSection(menu.id)">菜單分類</el-button>
                </el-form-item>
              </el-form>

            </div>

            <div style="height: 48vh; display: block; overflow-x:scroll;">
              <el-row :gutter="5" justify="center"
                      v-for="section in menu.sections" :key="section.id" style="margin-bottom: 16px;">

                <el-col :span="24">
                  <el-card>
                    <div slot="header" style="min-height:40px; vertical-align: middle;">
                      <div v-if="section.name != undefined" class="ui basic large label">
                        <i class="tw flag"></i>
                        {{ section.name }}
                      </div>
                      <div v-if="section.eng != undefined" class="ui basic large label">
                        <i class="us flag"></i>
                        {{ section.eng }}
                      </div>
                      <div v-if="section.jpn != undefined" class="ui basic large label">
                        <i class="jp flag"></i>
                        {{ section.jpn }}
                      </div>
                      <span style="float:right;">
                        <el-button @click="deleteData(menu.id, section.id)"
                                  type="text" style="top:0;">刪除</el-button>
                      </span>
                      <div class="ui hidden divider"></div>
                      <div class="ui fluid icon teal basic button"
                           @click="addItem(menu.id, section.id)"
                           :loading="addLoading"
                           :disabled="getSelected.length == 0">
                          <i class="angle double down icon"></i>
                          加入品項
                      </div>
                    </div>
                    <el-row style="height: 31vh; overflow-y: scroll;">
                      <el-card v-if="section.items.length == 0"> 未加入品項 </el-card>
                      <el-col :span="8" v-for="item in section.items" :key="item.id" >

                        <el-card style="width:240px;" :body-style="{ padding: '0px' }">
                          <img v-if="item.images.length == 0"
                              src="http://via.placeholder.com/240x240" class="image">
                          <img v-else :src="item.images[0].url" style="width: 100%" class="image" alt="">
                          <div style="padding: 14px; max-height:50px;">
                            {{ item.name }}
                            <el-button style="float: right; padding: 3px 0"
                                      type="text"
                                      @click="removeFromSection(menu.id, section.id, item.id)">移除</el-button>
                          </div>
                        </el-card>

                      </el-col>
                    </el-row>
                  </el-card>
                </el-col>
              </el-row>

            </div>

          </el-tab-pane>

        </el-tabs>
        <el-card v-if="menus.length == 0" shadow="never">未新增菜單</el-card>
      </el-col>


    </el-row>

  </el-row>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        baseUrl: '/api/v1/menus/',
        header: { "headers": { "Authorization": this.$cookie.get('token')}},
        selected: [],
        menusLoading: false,
        newMenuName: "",
        newLoading: false,
        currentTab: "",
        menus: [],
        newSectionTitle: {
          name: "",
          eng: "",
          jpn: ""
        },
        addLoading: false,
        itemsLoading: false
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
          this.loadMenus();
        }
      })
    },
    methods: {
      loadMenus () {
        this.menusLoading = true;
        this.menus = [];
        this.$http.get(this.baseUrl, this.header).then(response => {
          this.menus = response.body;
          this.menusLoading = false;
        }, response => {
          this.handleError(response)
        });
      },
      newMenu () {
        let data = { menu: { name: this.newMenuName } };
        this.$http.post(this.baseUrl, data, this.header).then(response => {

          this.menus.push({ id: response.body.id, name: response.body.name });
          this.newMenuName = "";
          this.$message({
            type: 'success',
            message: '新增成功!'
          });
        }, response => {
          this.handleError(response)
        });
      },
      deleteData (menu, section = "") {

        this.$confirm('確定要刪除嗎?', '進行刪除', {
          confirmButtonText: '確定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          let url = this.baseUrl + menu;
          if (section !== "") {
            url += "/sections/" + section;
          }
          this.itemsLoading = true;
          this.$http.delete(url, this.header).then(response => {

            if (section == "") {
              this.menus = this.menus.filter(e => e.id !== menu);
            } else {
              let target = this.menus.find(e => e.id == menu);
              let new_sections = target.sections.filter(e => e.id !== section);
              this.$set(target, 'sections', new_sections);
            }

            this.itemsLoading = false;
            this.$message({
              type: 'success',
              message: '刪除成功!'
            });
          }, response => {
            this.itemsLoading = false;
            this.handleError(response)
          });

        }).catch(() => {
        });

      },
      newSection (menu) {
        let data = { section: this.newSectionTitle };
        this.itemsLoading = true;
        this.$http.post(this.baseUrl + menu + '/sections/', data, this.header).then(response => {

          this.menus[this.currentTab]['sections'].push({ id: response.body.id, name: response.body.name, items: [] });
          this.newSectionTitle = {name: "", eng: "", jpn: ""};

          this.itemsLoading = false;
          this.$message({
            type: 'success',
            message: '新增成功!'
          });
        }, response => {
          this.itemsLoading = false;
          this.handleError(response)
        });
      },
      addItem (menu_id, section_id) {
        let url = this.baseUrl + menu_id + '/sections/' + section_id + '/add_items';
        this.addLoading = true;
        this.$http.post(url, {items_id: _.map(this.getSelected, "id") }, this.header).then(response => {

          let section = this.menus[this.currentTab]['sections']
                            .find(s => s.id == section_id);
          section.items = _.union( section.items, this.getSelected );
          this.$store.commit("syncSelected", []);

          this.$message({
            type: 'success',
            message: '新增成功!'
          });
          this.addLoading = false;
        }, response => {
          this.addLoading = false;
          this.handleError(response)
        });
      },
      removeFromSection (menu_id, section_id, item_id) {
        let url = this.baseUrl + menu_id + '/sections/' + section_id + '/remove_item/' + item_id;
        this.itemsLoading = true;
        this.$http.delete(url, this.header).then(response => {

          let section = this.menus[this.currentTab]['sections']
                            .find(s => s.id == section_id);
          section.items = section.items.filter(i => i.id !== item_id);

          this.$message({
            type: 'success',
            message: '移除成功!'
          });
          this.itemsLoading = false;
        }, response => {
          this.itemsLoading = false;
          this.handleError(response)
        });
      },
      openMenu (id, lang) {
        window.open('/menu/' + id + '/' + lang, '_blank');
      }
    }
  }
</script>

<style scoped>
  .image {
    width: auto;
    max-height: 240px;
    display: block;
  }

  .clearfix:before,
  .clearfix:after {
    display: table;
    content: "";
  }

  .clearfix:after {
    clear: both
  }

</style>

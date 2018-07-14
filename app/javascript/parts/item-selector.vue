<template>
  <el-row>
    <el-col :span="8">
      <!-- root menu -->
      <el-menu
        v-loading="roots.loading"
        @open="handleOpen">
        <el-submenu v-for="r in roots.data" :key="r.id" :index="'root_'+r.id">
          <template slot="title">
            <span>{{ r.name }}</span>
          </template>

          <!-- category menu -->
          <el-menu-item v-for="category in categories[r.id]"
                        :key="category.id"
                        :index="'root_' + r.id + '-'+ category.id"
                        @click="setCurrentCategory(category.id, category.name)">
                        {{ category.name }}
          </el-menu-item>

          <el-menu-item index="new" @click="openForm('new', 'categories')">
            <i class="el-icon-circle-plus-outline"></i>
            <span>分類</span>
          </el-menu-item>

          <el-menu-item index="edit" @click="openForm('edit', 'root_categories')">
            <i class="el-icon-edit"></i>
            <span>修改主分類</span>
          </el-menu-item>
          <el-menu-item index="delete" @click="deleteCheck('root_categories', r.id)">
            <i class="el-icon-circle-close-outline"></i>
            <span>刪除主分類</span>
          </el-menu-item>
        </el-submenu>

        <el-menu-item index="new" @click="openForm('new', 'root_categories')">
          <i class="el-icon-circle-plus-outline"></i>
          <span>主分類</span>
        </el-menu-item>
      </el-menu>
    </el-col>

    <el-col :span="16" v-if="getCategory.id != ''">
      <el-container>
        <el-header style="margin-bottom:10px;">
          <el-row>
            <el-card shadow="always" :body-style="{ 'min-height': '40px' }" >
              <span class="middle">
                {{ getCategory.name }}
              </span>
              <span style="float: right;">
                <el-button type="success" icon="el-icon-edit" style="margin-right:5fpx;"
                          @click="openForm('edit', 'categories')" circle></el-button>
                <el-button type="danger" icon="el-icon-close"
                          @click="deleteCheck('categories', getCategory.id)" circle></el-button>
              </span>
            </el-card>
          </el-row>
        </el-header>
        <br>
        <item-list></item-list>
      </el-container>

    </el-col>

      <el-dialog
        :title="formDialog.title"
        :visible.sync="formDialog.visible"
        width="30%"
        :before-close="dialogClose"
        :close-on-click-modal="false">

        <el-form ref="form" :model="form" label-width="60px">
          <el-form-item :label="formLabels.name">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
        </el-form>

        <span slot="footer" class="dialog-footer">
          <el-button @click="formDialog.visible = false">取消</el-button>
          <el-button type="primary" @click="sendForm" :loading="formDialog.loading">送出</el-button>
        </span>
      </el-dialog>

  </el-row>
</template>

<script>
  import { mapGetters } from 'vuex'
  import ItemList from './item-list.vue'

  export default {
    data: function () {
      return {
        header: { "headers": { "Authorization": this.$cookie.get('token')}},
        roots: {
          loading: false,
          data: []
        },
        categories: {
          data: []
        },
        formDialog: {
          title: "",
          visible: false,
          loading: false,
          action: "",
          target: ""
        },
        form: {
          name: ""
        },
        titles: {
          root_categories: "主分類",
          categories: "分類"
        },
        formLabels: {
          name: "名稱"
        }
      }
    },
    computed: {
      ...mapGetters([
        'getRoot',
        'getCategory'
      ])
    },
    mounted: function () {
      if (this.$store.getters.isLoggedIn) {
        this.roots.loading = true;
        this.$http.get('/api/v1/root_categories', this.header).then(response => {

          response.body.forEach(root => {
            this.roots.data.push({ id: root.id, name: root.name, active: false });
            this.categories[root.id] = root.categories;
          }, this);

          this.roots.loading = false;
        }, response => {
          this.handleError(response)
          this.roots.loading = false;
        });
      }
    },
    methods: {
      handleOpen (index) {
        var splited = index.split("_");
        if (splited[0] === 'root') {
          var root = this.roots.data.find(d => d.id == splited[1]);
          this.$store.commit("setRoot", root);
        }
      },
      dialogClose () {
        this.formDialog.visible = false;
      },
      openForm (action, type) {

        let prefix = action === 'new' ? '新增' : '修改';

        if (action === 'edit') {
          if (type === 'root_categories') {
            this.form.name = this.getRoot.name;
          } else if (type === 'categories') {
            this.form.name = this.getCategory.name;
          }
        }else{
          this.form.name = "";
        }

        this.formDialog = {
          title: prefix + this.titles[type],
          visible: true,
          loading: false,
          action: action,
          target: type
        }

      },
      sendForm () {
        // prepare data
        var data = {}
        data[this.formDialog.target] = this.form;
        if (this.formDialog.target === 'categories' && this.formDialog.action === 'new') {
          data[this.formDialog.target]["root_category_id"] = this.getRoot.id;
        }
        // prepare url
        var url = '/api/v1/' + this.formDialog.target;
        var method = "";

        if (this.formDialog.action === 'edit') {
          let id = "";
          if (this.formDialog.target === 'root_categories') {
            id = this.getRoot.id;
          } else {
            id = this.getCategory.id;
          }

          url += '/' + id;
          method = this.$http.patch(url, data, this.header);
        }else{
          method = this.$http.post(url, data, this.header);
        }
        // send request
        this.formDialog.loading = true;
        method.then(response => {
          if (this.formDialog.action === 'edit') {
            this.updateData(response.body);
          } else {
            this.pushData(response.body);
          }
          this.formDialog.visible = false;
          this.formDialog.loading = false;
        }, response => {
          this.handleError(response)
          this.formDialog.loading = false;
        });
      },
      pushData (data) {
        switch (this.formDialog.target) {
          case 'root_categories':
            this.roots.data.push({id: data.id, name: data.name});
            break;
          case 'categories':
            this.categories[this.getRoot.id].push({id: data.id, name: data.name});
            break;

          default:
            break;
        }
      },
      updateData (data) {
        switch (this.formDialog.target) {
          case 'root_categories':
            this.$set(this.roots.data.find(d => d.id == data.id), 'name', data.name);
            this.$store.commit("setRoot", { name: data.name });
            break;
          case 'categories':
            this.$set(this.categories[this.getRoot.id].find(d => d.id == data.id), 'name', data.name);
            this.$store.commit("setCategory", { name: data.name });
            break;

          default:
            break;
        }
      },
      deleteCheck (target, id) {
        this.formDialog.target = target;
        this.$confirm('確定要刪除此' + this.titles[target] + "嗎?", '刪除' + this.titles[target], {
          confirmButtonText: '確定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          var url = '/api/v1/' + target + "/" + id;
          this.$http.delete(url, this.header).then(response => {

            this.removeData(id);

            this.$message({
              type: 'success',
              message: '刪除成功!'
            });
          }, response => {
            this.handleError(response)
          });
        });
      },
      removeData (target_id) {
        switch (this.formDialog.target) {
          case 'root_categories':
            this.roots.data = this.roots.data.filter(e => e.id !== target_id);
            break;
          case 'categories':
            this.$store.commit("setCategory", { id: "", name: "" });
            this.categories[this.getRoot.id] = this.categories[this.getRoot.id].filter(e => e.id !== target_id);
            break;

          default:
            break;
        }
      },
      setCurrentCategory (id, name) {
        this.$store.commit("setCategory", { id: id, name: name });
      }

    },
    components: {
      ItemList
    }
  }
</script>

<style scoped>
  .middle {
    height: 42px;
    line-height: 42px;
    vertical-align: middle;
  }
</style>

<template>
<el-row>
  <el-col :span="3">
    <el-menu
      v-loading="rootLoading"
      @open="handleOpen">
      <el-submenu v-for="(r, index) in root" :key="r.id" :index="'root_'+r.id">
        <template slot="title">
          <span>{{ r.name }}</span>
        </template>

        <el-menu-item v-for="category in root[index].categories"
                      :key="category.id"
                      :index="'root_' + r.id + '-'+ category.id"
                      @click="loadItems">
                      {{ category.name }}
        </el-menu-item>

        <el-menu-item index="new" @click="dialogOpen('new', '分類', 'categories')">
          <i class="el-icon-circle-plus-outline"></i>
          <span>分類</span>
        </el-menu-item>

        <el-menu-item index="edit" @click="dialogOpen('edit', '主分類', 'root_categories', r.id, r.name)">
          <i class="el-icon-edit"></i>
          <span>修改主分類</span>
        </el-menu-item>
        <el-menu-item index="delete" @click="deleteCheck('主分類', 'root_categories', r.id)">
          <i class="el-icon-circle-close-outline"></i>
          <span>刪除主分類</span>
        </el-menu-item>
      </el-submenu>

      <el-menu-item index="new" @click="dialogOpen('new', '主分類', 'root_categories')">
        <i class="el-icon-circle-plus-outline"></i>
        <span>主分類</span>
      </el-menu-item>
    </el-menu>
    <el-dialog
      :title="nameDialog.title"
      :visible.sync="nameDialog.visible"
      width="30%"
      :before-close="dialogClose"
      :close-on-click-modal="false">
      <el-input :placeholder="nameDialog.label" v-model="nameDialog.value" size="large"></el-input>
      <span slot="footer" class="dialog-footer">
        <el-button @click="nameDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="sendDialog" :loading="nameDialog.loading">
          {{ nameDialog.action }}
        </el-button>
      </span>
    </el-dialog>

  </el-col>
  <el-col :span="6" v-if="categoryPanel.visible">
    <el-card class="box-card" shadow="hover">
      <div slot="header" class="clearfix">
        <span>Card name</span>
        <el-button style="float: right; padding: 3px 0" type="text">Operation button</el-button>
      </div>
      <div v-for="o in 4" :key="o" class="text item">
        {{'List item ' + o }}
      </div>
    </el-card>
  </el-col>
</el-row>
</template>

<script>
export default {
  data: function () {
    return {
      nameDialog: {
        loading: false,
        mode: "",
        id: "",
        title: "",
        visible: false,
        editing: "",
        value: "",
        action: ""
      },
      categoryPanel: {
        visible: false,
        title: ""
      },
      rootLoading: false,
      currentRoot: "",
      currentCategories: "",
      root: []
    }
  },
  created: function () {
    this.rootLoading = true;
    this.$http.get('/api/v1/root_categories').then(response => {
      var responseData = response.body;
      this.root = response.body;
      this.rootLoading = false;
    }, response => {
      this.handleError(response)
    });
  },
  methods: {
    handleOpen (index) {
      var splited = index.split("_");
      if (splited[0] === 'root') {
        this.currentRoot = splited[1];
      }
    },
    dialogOpen (mode, title, target, id = "", value = "") {
      var prefix = "新增";
      if (mode === 'edit') {
        prefix = '修改';
      }
      this.nameDialog = {
        loading: false,
        mode: mode,
        id: id,
        title: prefix + title,
        visible: true,
        editing: target,
        value: value,
        action: prefix
      }
    },
    dialogClose () {
      this.nameDialog.visible = false;
    },
    sendDialog () {
      var data = {}
      data[this.nameDialog.editing] = {
        name: this.nameDialog.value
      }
      if (this.nameDialog.editing === 'categories') {
        data[this.nameDialog.editing]["root_category_id"] = this.currentRoot;
      }

      var url = '/api/v1/' + this.nameDialog.editing;
      var method = ""
      if (this.nameDialog.mode === 'edit') {
        url += '/' + this.nameDialog.id;
        method = this.$http.patch(url, data);
      }else{
        method = this.$http.post(url, data);
      }
      this.nameDialog.loading = true;

      method.then(response => {
        if (this.nameDialog.editing === 'root_categories') {
          if (this.nameDialog.mode === 'edit') {
            var rootIndex = this.root.findIndex(d => d.id === response.body.id);
            this.root[rootIndex] = extend(this.root[rootIndex], {id: response.body.id, name: response.body.name});
          }else{
            this.root.push({id: response.body.id, name: response.body.name});
          }
          this.nameDialog.loading = false;
          this.nameDialog.visible = false;
          this.$message.success(this.nameDialog.action + '成功!');
        }
      }, response => {
        this.handleError(response)
      });
    },
    deleteCheck (title, target, id) {
      this.$confirm('確定要刪除此' + title + "嗎?", '刪除' + title, {
        confirmButtonText: '確定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        var url = '/api/v1/' + target + "/" + id;
        this.$http.delete(url).then(response => {
          this.root = this.root.filter(e => e.id !== id);
          this.$message({
            type: 'success',
            message: '刪除成功!'
          });
        }, response => {
          this.handleError(response)
        });
      });
    },
    loadItems (category_id) {
      this.categoryPanel.visible = true
    },
    handleError (response) {
      switch (response.status) {
        case 401:
          this.$message.error('驗證失敗');
          break;
        case 404:
          this.$message.error('查無資料');
          break;
        case 500:
          this.$message.error('伺服器發生錯誤');
          break;
        default:
          break;
      }
      this.nameDialog.loading = false;
      this.rootLoading = false;
    }
  }
}
</script>

<style scoped>

</style>

<template>
<el-row :gutter="5">
  <el-col :span="4">
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
                      @click="loadItems(category.id)">
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
    <el-card class="box-card" shadow="never" :body-style="{padding:'0px'}">
      <div slot="header" style="min-height: 42px">
        <span>{{ categoryPanel.title }}</span>
        <span style="float: right;">
          <el-button type="success"
                     icon="el-icon-edit"
                     style="margin-right:8px;"
                     @click="dialogOpen('edit', '分類', 'categories', currentCatergory.id, currentCatergory.name)"
                     circle></el-button>
          <el-button type="danger"
                     icon="el-icon-close"
                     @click="deleteCheck('分類', 'categories', currentCatergory.id)"
                     circle></el-button>
        </span>
      </div>
      <el-container>
        <el-main v-loading="itemsLoading">
          <el-row v-for="item in items" :key="item.id">
            <el-card class="box-card" :body-style="{'min-height':'42px'}">
              {{ item.name }}
              <span style="float:right;">
                <el-button @click="openItemForm('', item.id)"
                           icon="el-icon-edit" type="success" circle plain></el-button>
                <el-button @click="deleteCheck('項目', 'categories/'+currentCatergory.id+'/items', item.id)"
                           icon="el-icon-close"
                           type="danger" circle plain></el-button>
              </span>
            </el-card>
          </el-row>
        </el-main>
        <el-footer>
          <el-button @click="openItemForm" style="float:right;bottom:0;" type="success" icon="el-icon-plus" circle></el-button>
        </el-footer>
      </el-container>
      <el-dialog
        :title="itemForm.title"
        :visible.sync="itemForm.visible"
        width="35%"
        :before-close="formClose"
        :close-on-click-modal="false">
        <el-form :model="itemForm">
          <el-form-item label="名稱">
            <el-input v-model="itemForm.item.name"></el-input>
          </el-form-item>
          <el-form-item label="說明">
            <el-input type="textarea" v-model="itemForm.item.detail"></el-input>
          </el-form-item>
          <el-upload
            v-if="itemForm.id !== ''"
            :action="'/api/v1/categories/' + currentCatergory.id + '/items/' + itemForm.id + '/image'"
            :headers="jwt"
            :on-preview="handlePreview"
            :on-remove="handleRemove"
            :file-list="currentItem.images"
            multiple
            list-type="picture-card">
            <el-button size="small" type="primary">上傳</el-button>
            <div slot="tip" class="el-upload__tip">jpg/png files with a size less than 500kb</div>
          </el-upload>
          <el-dialog :visible.sync="dialogVisible">
            <img width="100%" :src="dialogImageUrl" alt="">
          </el-dialog>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="itemForm.visible = false">取消</el-button>
          <el-button type="primary" @click="sendForm" :loading="itemForm.loading">
            {{ itemForm.action }}
          </el-button>
        </span>
      </el-dialog>

    </el-card>
  </el-col>
</el-row>
</template>

<script>
export default {
  data: function () {
    return {
      jwt: {
        Authorization: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNTI5NDYwNzg0LCJleHAiOjE1Mjk1NDcxODQsImp0aSI6ImE2YzFiYTdiLWZlYzktNGFhNy05NGZjLTNlYWI3YzliNzdhZCJ9.FVaYWU_uqhCv_wNsWTi5reM23qCGFjc7YKllJSRfTEE"
      },
      itemForm:{
        loading: false,
        visible: false,
        mode: "",
        id: "",
        title: "",
        item: {
          name: "",
          detail: "",
          images:[]
        },
        action: ""
      },
      dialogImageUrl: '',
      dialogVisible: false,
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
      root: [],
      currentItemId: "",
      items: [],
      itemsLoading: false
    }
  },
  computed: {
    rootIndex: function () {
      return this.root.findIndex(d => d.id == this.currentRoot);
    },
    categoryIndex: function () {
      return this.root[this.rootIndex].categories.findIndex(d => d.id == this.currentCategories);
    },
    itemIndex: function () {
      var id = this.currentItemId;
      if (this.currentItemId === '') {
        if (this.itemForm.id !== '') {
          id = this.itemForm.id;
        }
      }

      if (id === '') {
        return 0;
      } else {
        return this.items.findIndex(d => d.id == id);
      }
    },
    currentCatergory: {
      get: function() {
        return this.root[this.rootIndex].categories[this.categoryIndex];
      },
      set: function(newValue) {
        this.root[this.rootIndex].categories[this.categoryIndex] =
          extend(this.root[this.rootIndex].categories[this.categoryIndex], newValue);
      }
    },
    currentItem: {
      get: function() {
        var item = {
          name: "",
          detail: "",
          images:[]
        };
        if (this.items.length !== 0) {
          item = this.items[this.itemIndex];
        }
        return item;
      },
      set: function(newValue) {
        this.items[this.itemIndex] = extend(this.items[this.itemIndex], newValue);
      }
    }
  },
  created: function () {
    this.rootLoading = true;
    this.$http.get('/api/v1/root_categories').then(response => {
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

      if (target === 'categories' && mode === 'edit') {
        value = this.root[this.rootIndex].categories[this.categoryIndex].name;
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
    formClose () {
      this.itemForm.visible = false;
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
      } else {
        method = this.$http.post(url, data);
      }
      this.nameDialog.loading = true;

      method.then(response => {
        if (this.nameDialog.editing === 'root_categories') {
          if (this.nameDialog.mode === 'edit') {
            var index = this.toRootIndex(response.body.id);
            this.root[index] = extend(this.root[index], {id: response.body.id, name: response.body.name});
          }else{
            this.root.push({id: response.body.id, name: response.body.name});
          }

        } else if (this.nameDialog.editing === 'categories') {
          if (this.nameDialog.mode === 'edit') {
            this.currentCatergory = { name: response.body.name };
            this.categoryPanel.title = response.body.name;
          } else {
            this.root[this.rootIndex].categories.push({id: response.body.id, name: response.body.name});
          }
        }
        this.nameDialog.loading = false;
        this.nameDialog.visible = false;
        this.$message.success(this.nameDialog.action + '成功!');
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
          if (target === 'categories') {
            this.categoryPanel.visible = false;
            this.root[this.rootIndex].categories.splice(this.categoryIndex, 1);
          } else if (target === 'root_categories') {
            this.root = this.root.filter(e => e.id !== id);
          } else {
            this.items = this.items.filter(e => e.id !== id);
          }
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
      this.categoryPanel.visible = true;
      this.currentCategories = category_id;
      this.categoryPanel.title = this.currentCatergory.name;
      this.nameDialog.value = this.currentCatergory.name;

      this.itemsLoading = true;
      this.$http.get('/api/v1/categories/' + category_id + '/items/').then(response => {
        this.items = response.body;
        this.itemsLoading = false;
      }, response => {
        this.handleError(response)
      });
    },
    openItemForm (el, item_id = "") {
      var formItem = ""
      if (item_id === "") {
        this.itemForm.mode = "new";
        this.itemForm.action = "新增";
        formItem = { name: "", detail: "" };
      } else {
        this.itemForm.mode = "edit";
        this.itemForm.action = "修改";
        formItem = {
          name: this.currentItem.name,
          detail: this.currentItem.detail
        };
      }
      this.itemForm.item = extend(this.itemForm.item, formItem);
      this.itemForm.title = this.itemForm.action + "品項";
      this.itemForm.id = item_id;
      this.itemForm.visible = true;
    },
    sendForm () {
      var url = '/api/v1/categories/' + this.currentCatergory.id + '/items';
      var method;
      var data = {
        item: {
          name: this.itemForm.item.name,
          detail: this.itemForm.item.detail
        }
      };
      if (this.itemForm.mode === 'edit') {
        url += '/' + this.itemForm.id;
        method = this.$http.patch(url, data);
      } else {
        method = this.$http.post(url, data);
      }

      this.itemForm.loading = true;

      method.then(response => {
        if (this.itemForm.mode === 'edit') {
          this.currentItem = response.body;
        } else {
          this.items.push(response.body);
          this.itemForm.visible = false;
        }
        this.itemForm.loading = false;
        this.$message.success(this.itemForm.action + '成功!');
      }, response => {
        this.handleError(response)
      });

    },
    handleRemove(file, fileList) {
      console.log(file, fileList);
    },
    handlePreview(file) {
      this.dialogImageUrl = file.url;
      this.dialogVisible = true;
    },

    toRootIndex (root_id) {
      return this.root.findIndex(d => d.id === root_id);
    }
  }
}
</script>

<style scoped>
  .el-row {
    margin: 10px;
  }
</style>

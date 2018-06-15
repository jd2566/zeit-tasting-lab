<template>
  <el-col :span="4">
    <el-menu
      default-active="2"
      @open="handleOpen"
      @close="handleClose">
      <el-submenu v-for="root in rootCategories" :key="root" :index="root.name">
        <template slot="title">
          <span>{{ root.name }}</span>
        </template>

      </el-submenu>
      <el-menu-item index="new" @click="dialogOpen('new', '主分類', 'root_categories')">
        <i class="el-icon-circle-plus-outline"></i>
        <span>新增主分類</span>
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
        <el-button type="primary" @click="sendDialog">{{ nameDialog.action }}</el-button>
      </span>
    </el-dialog>
  </el-col>

</template>

<script>
export default {
  data: function () {
    return {
      nameDialog: {
        mode: "",
        title: "",
        visible: false,
        editing: "",
        value: "",
        action: ""
      },
      currentRoot: "",
      currentCategories: "",
      rootCategories: []
    }
  },
  methods: {
    handleOpen (index) {
      console.log("test")
    },
    handleClose (index) {
      // this.$refs.modal.open()
    },
    dialogOpen (mode, title, target) {
      var prefix = "新增";
      if (mode === 'edit') {
        prefix = '修改';
      }
      this.nameDialog = {
        mode: 'new',
        title: prefix + title,
        visible: true,
        editing: target,
        value: "",
        action: prefix
      }
    },
    dialogClose () {
      this.nameDialog.visible = false;
    },
    sendDialog () {
      var data = {
        root_category: {
          name: this.nameDialog.value
        }
      }
      var url = '/api/v1/root_categories';
      this.$http.post(url, data).then(response => {
        var responseData = response.body.data[0];
        debugger
      }, response => {
        this.handleError(response)
      });
    },
    handleError (response) {
      switch (response.status) {
        case 401:
          this.$message.error('驗證失敗');
          break;

        default:
          break;
      }
    }
  }
}
</script>

<style scoped>

</style>

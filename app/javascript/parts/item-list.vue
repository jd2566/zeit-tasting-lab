<template>
  <el-container style="height: 88vh;">
    <el-main v-loading="listLoading">
      <div class="ui large label">
        品項數
        <div class="detail">{{ items.length }}</div>
      </div>

      <div class="ui divider"></div>

      <el-row v-for="item in items" :key="item.id" style="margin-bottom:5px">
        <el-card shadow="never" class="middle" :body-style="{'min-height':'78px'}" @click="setChecked(item.id)">
          <div v-if="item.checked" class="ui green left corner label" @click="setChecked(item.id)">
            <i class="check icon"></i>
          </div>
          <div v-else class="ui left corner label" @click="setChecked(item.id)">
            <i class="minus icon"></i>
          </div>
          <div>
            <img @click="setChecked(item.id)"
               v-if="item.images[0]" class="ui tiny left floated image" :src="item.images[0].url">
            <img @click="setChecked(item.id)"
                v-if="item.images.length == 0" class="ui tiny left floated image" src="/images/zeit.jpg">
            <span @click="setChecked(item.id)"> {{ item.name }} </span>
          </div>

          <span style="float:right;">
            <el-button @click="itemClicked(item)"
                       :disabled="item.checked"
                       icon="el-icon-edit" type="success" circle plain></el-button>
            <el-button @click="deleteCheck(item.id)"
                       :disabled="item.checked"
                       icon="el-icon-close"
                       type="danger" circle plain></el-button>
          </span>
        </el-card>
        <el-dialog
          title="修改品項"
          :visible.sync="item.open"
          width="35%"
          :close-on-click-modal="false">
          <el-form :model="item">
            <el-tabs type="border-card" v-model="defaultTab">
              <el-tab-pane label="中文" name="tw">
                <el-form-item label="名稱">
                  <el-input v-model="item.name"></el-input>
                </el-form-item>
                <el-form-item label="說明">
                  <el-input type="textarea" v-model="item.detail" rows="6"></el-input>
                </el-form-item>
              </el-tab-pane>
              <el-tab-pane label="英文" name="eng">
                <el-form-item label="名稱">
                  <el-input v-model="item.eng"></el-input>
                </el-form-item>
                <el-form-item label="說明">
                  <el-input type="textarea" v-model="item.eng_detail" rows="6"></el-input>
                </el-form-item>
              </el-tab-pane>
              <el-tab-pane label="日文" name="jpn">
                <el-form-item label="名稱">
                  <el-input v-model="item.jpn"></el-input>
                </el-form-item>
                <el-form-item label="說明">
                  <el-input type="textarea" v-model="item.jpn_detail" rows="6"></el-input>
                </el-form-item>
              </el-tab-pane>
            </el-tabs>

            <div class="ui hidden divider"></div>

            <el-form-item label="售價">
              <el-input-number v-model="item.price" controls-position="right" :min="0" :max="10000" :step="5"></el-input-number>
            </el-form-item>

            <div class="ui hidden divider"></div>

            <el-upload
              v-if="item.id !== ''"
              :action="baseUrl + item.id + '/image'"
              :headers="header.headers"
              :on-preview="handlePreview"
              :on-success="handleUploaded"
              :on-remove="handleRemove"
              :file-list="item.images"
              multiple
              list-type="picture-card">
              <el-button size="small" type="primary">上傳</el-button>
              <div slot="tip" class="el-upload__tip">jpg/png files with a size less than 500kb</div>
            </el-upload>
          </el-form>
          <span slot="footer" class="dialog-footer">
            <el-button @click="item.open = false">取消</el-button>
            <el-button type="primary" @click="updateItem(item)" :loading="item.loading">
              修改
            </el-button>
          </span>
        </el-dialog>
      </el-row>

      <!-- 照片預覽視窗 -->
      <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>

      <el-dialog
        title="新增品項"
        :visible.sync="itemForm.open"
        width="35%"
        :close-on-click-modal="false">

        <el-form :model="itemForm">
          <el-form-item label="名稱">
            <el-input v-model="itemForm.item.name"></el-input>
          </el-form-item>
          <el-form-item label="說明">
            <el-input type="textarea" v-model="itemForm.item.detail"></el-input>
          </el-form-item>
        </el-form>

        <span slot="footer" class="dialog-footer">
          <el-button @click="itemForm.open = false">取消</el-button>
          <el-button type="primary" @click="newItem" :loading="itemForm.loading">
            新增
          </el-button>
        </span>

      </el-dialog>
    </el-main>
    <el-footer style="margin-top: 5px;">
      <span style="float: right;">
        <el-button type="success" icon="el-icon-plus" @click="itemForm.open = true">新增品項</el-button>
      </span>
    </el-footer>
  </el-container>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        baseUrl: '/api/v1/categories/' + this.$store.getters.getCategory.id + '/items/',
        header: { "headers": { "Authorization": this.$cookie.get('token')}},
        listLoading: false,
        items: [],
        itemForm:{
          loading: false,
          open: false,
          item: {
            name: "",
            detail: ""
          },
        },
        defaultTab: 'tw',
        titles: {
          items: '品項'
        },
        dialogImageUrl: '',
        dialogVisible: false
      }
    },
    computed: {
      ...mapGetters([
        'getCategory',
        'getSelected'
      ])
    },
    watch: {
      getCategory: {
        deep: true,
        handler: function (new_category) {
          this.baseUrl = '/api/v1/categories/' + new_category.id + '/items/';
          this.loadItems();
        }
      },
      getSelected (items) {
        if (items.length == 0) {
          this.items.forEach(i => {
            i.checked = false;
          });
        }
      }
    },
    mounted() {
      this.$nextTick(function () {
        if (this.getCategory.id !== '' && this.$store.getters.isLoggedIn) {
          this.loadItems();
        }
      })
    },
    methods: {
      loadItems () {
        this.listLoading = true;
        this.items = [];
        this.$http.get(this.baseUrl, this.header).then(response => {
          response.body.forEach(i => {
            let item = extend(i, {open: false, loading: false, checked: false})
            this.items.push(item);
            this.updateSelected();
          }, this);
          this.listLoading = false;
        }, response => {
          this.handleError(response)
        });
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      handleUploaded(response, file, fileList) {
        const targetItem = this.items.find(d => d.id == response.item);
        targetItem.images.push(response.image);
      },
      handleRemove(file, fileList) {
        const targetItem = this.items.find(d => d.open == true);

        this.$http.delete(this.baseUrl + targetItem.id + '/del_image/' + file.id, this.header).then(response => {
          const targetItem = this.items.find(d => d.open == true);
          targetItem.images = targetItem.images.filter(e => e.id != response.body.image);
          this.$message({
            type: 'success',
            message: '刪除成功!'
          });
        }, response => {
          this.handleError(response)
        });
      },
      deleteCheck (id) {

        this.$confirm('確定要刪除此品項嗎?', '刪除品項', {
          confirmButtonText: '確定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {

          this.$http.delete(this.baseUrl + id, this.header).then(response => {

            this.items = this.items.filter(e => e.id !== id);

            this.$message({
              type: 'success',
              message: '刪除成功!'
            });
          }, response => {
            this.handleError(response)
          });

        }).catch(() => {
        });
      },
      newItem () {
        let data = { item: this.itemForm.item }
        this.$http.post(this.baseUrl, data, this.header).then(response => {
          let item = extend(response.body, {open: false, loading: false, checked: false})

          this.items.push(item);
          this.itemForm.open = false;
          this.itemForm.item = {
            name: "", detail: ""
          }
          this.$message({
            type: 'success',
            message: '新增成功!'
          });
        }, response => {
          this.handleError(response)
        });
      },
      updateItem (item) {
        this.$http.patch(this.baseUrl + item.id, item, this.header).then(response => {
          let data = response.body;
          this.$set(item, 'name', data.name);
          this.$set(item, 'open', false);
          this.$message({
            type: 'success',
            message: '更新成功!'
          });
        }, response => {
          this.handleError(response)
        });

      },
      itemClicked (item) {
        this.$set(item, 'open', true);
      },
      updateSelected () {
        let selected = this.items.filter(s => s.checked);
        this.$store.commit("syncSelected", selected);
      },
      setChecked (item) {
        const targetItem = this.items.find(d => d.id == item);
        targetItem.checked = !targetItem.checked;
        this.updateSelected();
      }
    }
  }
</script>

<style scoped>

</style>

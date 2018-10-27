<template>
  <el-dialog
    title="登入"
    :visible.sync="dialogVisible"
    width="30%"
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    :show-close="false"
    center>

    <el-form ref="user" :model="user" label-width="120px" :rules="formRules">
      <el-form-item label="email" required>
        <el-col :span="20">
          <el-input v-model="user.email"></el-input>
        </el-col>
      </el-form-item>
      <el-form-item label="密碼" required>
        <el-col :span="20">
          <el-input type="password" v-model="user.password"></el-input>
        </el-col>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button type="primary" size="large" @click="login" :loading="loading">送出</el-button>
    </span>
  </el-dialog>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    data: function () {
      return {
        dialogVisible: false,
        loading: false,
        user: {
          email: "",
          password: ""
        },
        formRules: {
          email: [
            { required: true, message: '請填寫', trigger: 'blur' },
            { type: "email", message: '格式錯誤', trigger: 'blur' }
          ],
          password: [
            { required: true, message: '請填寫', trigger: 'blur' }
          ]
        }
      }
    },
    beforeMount: function () {
      this.dialogVisible = !this.isLoggedIn;
      if (this.$store.getters.getEmail !== "") {
        this.user.email = this.$store.getters.getEmail;
      }
    },
    computed: {
      ...mapGetters([
        'isLoggedIn'
      ])
    },
    watch: {
      isLoggedIn: function (val) {
        this.dialogVisible = !val;
      }
    },
    methods: {
      login () {
        var isValid = false;
        this.$refs.user.validate((valid) => {
          if (valid) {
            isValid = true;
          } else {
            return false;
          }
        });
        if (isValid) {
          this.loading = true;
          this.$http.post('/login', { user: this.user }).then(response => {

            this.$store.commit("setUserData", {
              email: response.body.email,
              token: response.headers.map.authorization[0],
              loggedIn: true
            });

            this.$cookie.set('token', response.headers.map.authorization[0], 1);

            window.location.reload();
          },response => {
            this.handleError(response);
            this.loading = false;
          });
        }
      }
    }
  }
</script>

<style scoped>

</style>

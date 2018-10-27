export default {
  methods: {
    handleError(response) {
      switch (response.status) {
        case 401:
          this.$message.error('驗證失敗');
          this.$store.commit("logout");
          break;
        case 404:
          this.$message.error('查無資料');
          break;
        case 422:
          this.$message.error('傳送資料錯誤');
          break;
        case 500:
          this.$message.error('伺服器發生錯誤');
          break;
        default:
          break;
      }
    }
  }
}

<script>
export default {
  created() {
    const { params, queryVo } = this.$route
    const { path } = params
    this.$router.replace({ path: '/' + path, queryVo })
  },
  render: function(h) {
    return h() // avoid warning message
  }
}
</script>

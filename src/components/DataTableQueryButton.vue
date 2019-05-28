<template>
  <el-button type="primary" @click="onSearchClick">查询</el-button>
</template>

<script>
export default {
  props: {
    queryParams: {
      type: [Object, Function]
    },
    /* DataTable的ref的字符串名称 */
    table: {
      type: String,
      default: 'table'
    }
  },
  //directives: {}, TODO:局部指令无用
  methods: {
    onSearchClick() {
      const dataTable = this.$vnode.context.$refs[this.table];
      dataTable.query((typeof this.queryParams == 'function') ?
        this.queryParams() : this.queryParams);
    }
  }
}
</script>
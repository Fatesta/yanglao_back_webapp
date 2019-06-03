<template>
  <el-button type="primary" v-bind="$attrs" @click="onSearchClick">查询</el-button>
</template>

<script>
export default {
  name: 'data-table-query-button',
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
  methods: {
    onSearchClick() {
      const dataTable = this.$vnode.context.$refs[this.table];
      dataTable.query((typeof this.queryParams == 'function') ?
        this.queryParams() : this.queryParams);
    }
  }
}
</script>
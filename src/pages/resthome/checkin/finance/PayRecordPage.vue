<template>
  <div>
    <data-table-app-page>
      <data-table
        ref="table"
        url="/api/community/berth/payrecord/page"
        lazy
      >
        <el-table-column prop="type" label="金额类别" width="170" :formatter="formatters.type" show-overflow-tooltip></el-table-column>
        <el-table-column prop="money" label="金额" width="90" show-overflow-tooltip></el-table-column>
        <el-table-column prop="operatorUsername" label="操作账号" width="100"></el-table-column>
        <el-table-column prop="createTime" label="记录时间" width="170"></el-table-column>
      </data-table>
    </data-table-app-page>
    <normal-pay ref="normalPay" />
  </div>
</template>

<script>

export default {
  pageProps: {
    title: '账单'
  },
  data() {
    return {
      formatters: {
        type: (r, c, v) => ({1: '押金', 2: '余款'}[v])
      },
      searchForm: {
        berthId: this.$params.berthId,
        checkinId: this.$params.checkinId
      }
    };
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  }
}
</script>

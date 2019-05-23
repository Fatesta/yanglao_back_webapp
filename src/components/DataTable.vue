<template>
  <div>
    <el-table fit stripe :data="tableData" v-loading="loading">
      <slot></slot>
    </el-table>
    <el-pagination
      :style="{margin: '8px -10px 8px 0px', float: 'right'}"
      background
      @size-change="onSizeChange"
      @current-change="onCurrentChange"
      :current-page="currentPage"
      :total="total"
      :page-sizes="pagination.pageSizes"
      :page-size="pagination.pageSize"
      :layout="pagination.layout"
    >
    </el-pagination>
  </div>
</template>


<script>
export default {
  props: {
    url: {
      type: 'String',
      required: true
    },
    queryParams: {
      type: 'Object',
      required: false
    }
  },
  data() {
    return {
      pagination: {
        pageSizes: [5, 8, 10, 20, 30, 50],
        pageSize: 8,
        layout: 'total, prev, pager, next, jumper, sizes'
      },
      currentPage: 1,
      total: 5,
      tableData: [],
      loading: true
    };
  },
  methods: {
    onSizeChange(num) {
      this.pagination.pageSize = num;
      this._fetch();
    },
    onCurrentChange(num) {
      this.currentPage = num;
      this._fetch();
    },
    query(params) {
      // 如果传递了 查询参数，则覆盖上次的
      if (typeof params == 'object') {
        this.queryParams = params;
      }
      this._fetch();
    },
    reloadCurrentPage() {
      this._fetch();
    },
    async _fetch() {
      if (!this.loading) {
        this.loading = true;
      }
      const params = {
        ...this.queryParams,
        ...{rows: this.pagination.pageSize, page: this.currentPage}
      };
      const ret = await axios.get(this.url, {params});
      this.tableData = ret.rows;
      this.total = ret.total;
      this.loading = false;
    }
  },
  created() {
    this._fetch();
  }
}
</script>
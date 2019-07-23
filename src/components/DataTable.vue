<template>
  <div>
    <el-table
      ref="table"
      v-loading="loading"
      :height="attrs.height || height"
      v-bind="attrs"
      :data="tableData"
      size="medium"
      @current-change="onCurrentRowChange"
      element-loading-text="查询数据中"
    >
      <slot></slot>
    </el-table>
    <el-pagination
      :style="{
        height: '28px',
        margin: '8px -20px 8px 0px',
        float: 'right'
      }"
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
  name: 'data-table',
  inheritAttrs: false,
  props: {
    url: {
      type: String
    },
    queryParams: {
      type: Object
    },
    loadFilter: {
      type: Function
    },
    lazy: {
      type: Boolean
    }
  },
  data() {
    return {
      fetchParams: this.queryParams,
      pagination: {
        pageSizes: [5, 8, 10, 20, 30, 50],
        pageSize: 10,
        layout: 'total, prev, pager, next, jumper, sizes',
        ...this.$attrs.pagination
      },
      height: 0,
      currentPage: 1,
      currentRow: null,
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
        this.fetchParams = params;
      }
      this.currentPage = 1;
      this._fetch();
    },
    reloadCurrentPage() {
      this._fetch();
    },
    async _fetch() {
      const params = {
        ...this.fetchParams,
        ...{rows: this.pagination.pageSize, page: this.currentPage}
      };

      let startTime = +new Date(); //记录请求开始时间
      if (!this.loading) {
        this.loading = true;
      }
      let ret = await this.axios.get(this.url, {params});
      // 加载数据，并让用户感知到执行了查询，在小于MIN_TIME毫秒之内，有相同的时长感觉
      const MIN_TIME = 100;
      const renderData = () => {
        if (this.loadFilter) {
          ret = this.loadFilter(ret);
        }
        this.tableData = ret.rows;
        this.total = ret.total;
        this.loading = false;
      };
      const diffTime = +new Date - startTime;
      if (diffTime < MIN_TIME) {
        setTimeout(renderData, MIN_TIME - diffTime);
      } else {
        renderData();
      }
    },
    setCurrentRow(row) {
      this.$refs.table.setCurrentRow(row);
    },
    onCurrentRowChange(row) {
      this.currentRow = row;
    }
  },
  beforeCreate() {
    const defaults = {
      stripe: true
    };
    this.attrs = Object.assign({}, defaults, this.$attrs);
  },
  mounted() {
    if (!this.lazy) {
      this._fetch();
    }
  }
}
</script>
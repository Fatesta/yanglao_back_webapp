<template>
  <el-dialog
    :title="title"
    :visible.sync="visible"
    width="750px"
  >
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="姓名">
        <el-input v-model="searchForm.realName" style="width: 70px"></el-input>
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="searchForm.phone" style="width: 110px"></el-input>
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="searchForm" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/shop/employee/employeePage"
      :pagination="{pageSize: 5}"
      :stripe="false"
      :height="288"
      lazy
      highlight-current-row
    >
      <el-table-column prop="realName" label="姓名" width="200"></el-table-column>
      <el-table-column prop="phone" label="手机号" width="120"></el-table-column>
    </data-table>
    <div slot="footer" style="margin-top: 8px;">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onOk">确定</el-button>
    </div>
  </el-dialog>
</template>

<script>

export default {
  data() {
    return {
      visible: false,
      title: '选择员工',
      searchForm: {}
    }
  },
  methods: {
    show(options) {
      this.title = options.title || this.title;
      this.visible = true;
      if (this.$refs.table) {
        this.$refs.table.setCurrentRow(null);
      }
      this.options = options;
      this.$nextTick(() => {
        this.$refs.table.query(options.queryParams);
      });
    },
    onOk() {
      const row = this.$refs.table.currentRow;
      if (!row) {
        this.$message.warning('请先点击一行选择');
        return;
      }
      const isClose = this.options.onOk(row);
      if (isClose) {
        this.visible = false;
      }
    }
  }
}
</script>
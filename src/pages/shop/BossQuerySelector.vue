<template>
  <el-dialog
    title="选择商家"
    :visible.sync="visible"
    width="750px"
  >
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="工号">
        <el-input v-model="searchForm.username" clearable style="width: 120px"></el-input>
      </el-form-item>
      <el-form-item label="姓名">
        <el-input v-model="searchForm.realName" clearable style="width: 90px"></el-input>
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="searchForm.phone" clearable style="width: 130px"></el-input>
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="searchForm" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/shop/boss/bossPage"
      :pagination="{pageSize: 5}"
      :stripe="false"
      :height="288"
      highlight-current-row
    >
      <el-table-column prop="username" label="工号" width="100" show-overflow-tooltip></el-table-column>
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
      searchForm: {}
    }
  },
  methods: {
    show(options) {
      this.visible = true;
      if (this.$refs.table) {
        this.$refs.table.setCurrentRow(null);
      }
      this.options = options;
    },
    onOk() {
      const boss = this.$refs.table.currentRow;
      if (!boss) {
        this.$message.warning('请先点击一行来选择一个商家');
        return;
      }
      const isClose = this.options.onOk(boss);
      if (isClose) {
        this.visible = false;
      }
    }
  }
}
</script>
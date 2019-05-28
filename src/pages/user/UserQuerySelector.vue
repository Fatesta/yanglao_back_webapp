<template>
  <el-dialog
    title="选择用户"
    :visible.sync="visible"
    width="760px"
    :modal="false"
  >
    <el-form :inline="true" :model="searchForm" size="mini">
      <el-form-item label="昵称">
        <el-input v-model="searchForm.aliasName" style="width: 70px"></el-input>
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="searchForm.telphone" style="width: 130px"></el-input>
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="searchForm" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/user/listUser"
      :pagination="{pageSize: 5}"
      :stripe="false"
      :height="288"
      highlight-current-row
    >
      <el-table-column prop="aliasName" label="昵称" width="120" show-overflow-tooltip></el-table-column>
      <el-table-column prop="realName" label="姓名" width="80"></el-table-column>
      <el-table-column prop="sex" label="性别" :formatter="formatters.sex" width="60"></el-table-column>
      <el-table-column prop="idcard" label="身份证号码" width="170"></el-table-column>
      <el-table-column prop="telphone" label="手机号" width="110"></el-table-column>
      <el-table-column prop="userType" label="用户类型" :formatter="formatters.userType" width="120"></el-table-column>
    </data-table>
    <div slot="footer" class="dialog-footer" style="margin-top: 8px;">
      <el-button size="small" type="default" @click="visible = false">取消</el-button>
      <el-button size="small" type="primary" @click="onOk">确定</el-button>
    </div>
  </el-dialog>
</template>

<script>

export default {
  data() {
    return {
      visible: false,
      formatters: {
        sex(row, col, val) { return DictMan.itemMap('user.gender')[val]; },
        userType(row, col, val) { return DictMan.itemMap('user.type')[val]; },
      },
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
      const isClose = this.options.onOk(this.$refs.table.currentRow);
      if (isClose) {
        this.visible = false;
      }
    }
  }
}
</script>
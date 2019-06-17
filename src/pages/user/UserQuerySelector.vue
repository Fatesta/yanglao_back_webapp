<template>
  <el-dialog
    title="选择用户"
    :visible.sync="visible"
    width="920px"
  >
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="昵称">
        <el-input v-model="searchForm.aliasName" clearable style="width: 70px"></el-input>
      </el-form-item>
      <el-form-item label="姓名">
        <el-input v-model="searchForm.realName" clearable style="width: 70px"></el-input>
      </el-form-item>
      <el-form-item label="身份证号码">
        <el-input v-model="searchForm.idcard" clearable style="width: 160px"></el-input>
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="searchForm.telphone" clearable style="width: 110px"></el-input>
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
      <el-table-column prop="aliasName" label="昵称" width="100" show-overflow-tooltip></el-table-column>
      <el-table-column prop="realName" label="姓名" width="80"></el-table-column>
      <el-table-column prop="sex" label="性别" :formatter="formatters.sex" width="60"></el-table-column>
      <el-table-column prop="age" label="年龄" width="60"></el-table-column>
      <el-table-column prop="idcard" label="身份证号码" width="180"></el-table-column>
      <el-table-column prop="telphone" label="手机号" width="120"></el-table-column>
      <el-table-column prop="userType" label="用户类型" :formatter="formatters.userType" width="120"></el-table-column>
      <el-table-column prop="orgName" label="社区" width="160" show-overflow-tooltip></el-table-column>
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
      const user = this.$refs.table.currentRow;
      if (!user) {
        this.$message.warning('请先点击一行来选择一个用户');
        return;
      }
      const isClose = this.options.onOk(user);
      if (isClose) {
        this.visible = false;
      }
    }
  }
}
</script>
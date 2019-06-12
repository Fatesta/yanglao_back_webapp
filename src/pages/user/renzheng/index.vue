<template>
  <data-table-app-page>
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="姓名">
        <el-input v-model="searchForm.realName" clearable style="width: 90px"></el-input>
      </el-form-item>
      <el-form-item label="身份证号码">
        <el-input v-model="searchForm.idcard" clearable style="width: 190px"></el-input>
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="searchForm.telphone" clearable style="width: 130px"></el-input>
      </el-form-item>
      <el-form-item label="用户类型">
        <type-select
          v-model="searchForm.userType"
          :items="DictMan.items('user.type')"
          style="width: 140px"
        />
      </el-form-item>
      <el-form-item label="认证状态">
        <type-select
          v-model="searchForm.state"
          :items="DictMan.items('user.renzheng.state')"
          style="width: 110px"
        />
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="searchForm" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/user/listUser"
    >
      <el-table-column prop="aliasName" label="昵称" width="120"></el-table-column>
      <el-table-column prop="realName" label="姓名" width="80"></el-table-column>
      <el-table-column prop="sex" label="性别" :formatter="formatters.sex" width="60"></el-table-column>
      <el-table-column prop="idcard" label="身份证号码" width="174"></el-table-column>
      <el-table-column prop="telphone" label="手机号" width="120"></el-table-column>
      <el-table-column prop="userType" label="用户类型" :formatter="formatters.userType" width="120"></el-table-column>
      <el-table-column prop="state" label="认证状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="['warning', '', 'success', 'danger'][scope.row.state]">
            {{DictMan.itemMap('user.renzheng.state')[scope.row.state]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="isVolunteer" label="志愿者" :formatter="formatters.isVolunteer" width="80"></el-table-column>
      <el-table-column label="操作" width="280">
        <template slot-scope="scope" fixed="right">
          <el-button
            :disabled="scope.row.state != 1"
            type="primary"
            plain
            style="margin-left: 0px"
            @click="onCheckClick(scope.row)">审核</el-button>
          <el-button
            :disabled="scope.row.state == 0"
            style="margin-left: 0px"
            @click="onCertDetailsClick(scope.row)">认证信息</el-button>
          <el-dropdown
            @command="onCommandClick($event, scope.row)"
            :show-timeout="100"
          >
            <el-button
              split-button
            >
              更多操作<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="certEdit" icon="el-icon-edit">认证编辑</el-dropdown-item>
              <el-dropdown-item command="permissionSettings" icon="el-icon-user-solid">设置权限</el-dropdown-item>
              <el-dropdown-item command="asVolunteer" icon="el-icon-medal" v-if="!scope.row.isVolunteer">成为志愿者</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </data-table>

    <check-dialog ref="checkDialog"></check-dialog>
    <permission-settings ref="permissionSettings"></permission-settings>
    <cert-edit-dialog ref="certEditDialog"></cert-edit-dialog>
  </data-table-app-page>
</template>


<script>
import CertEditDialog from './CertEditDialog.vue';
import CheckDialog from './CheckDialog.vue';
import PermissionSettings from './PermissionSettings.vue';

export default {
  components: {
    CheckDialog,
    PermissionSettings,
    CertEditDialog
  },
  data() {
    return {
      formatters: {
        sex(row, col, val) { return DictMan.itemMap('user.gender')[val]; },
        userType(row, col, val) { return DictMan.itemMap('user.type')[val]; },
        isVolunteer(row, col, val) { return val ? '是' : ''; }
      },
      checkDialogVisible: false,
      searchForm: {}
    }
  },
  methods: {
    onCheckClick(row) {
      this.$refs.checkDialog.open(row.userId, (state) => {
        row.state = state;
      });
    },
    onCommandClick(cmd, user) {
      switch (cmd) {
        case 'certEdit': 
          this.$refs.certEditDialog.open(user, false, (newRecord) => {
            Object.assign(row, newRecord);
            row.state = 1;
          });
          break;
        case 'permissionSettings':
          this.$refs.permissionSettings.open(user.userId);
          break;
        case 'asVolunteer':
          this.$message.info('todo');
          break;
      }
    },
    onCertDetailsClick(row) {
      this.$refs.certEditDialog.open(row, 'readonly');
    }
  }
}
</script>
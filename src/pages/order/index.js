
export default {
  template: `
    <div>
      <el-card class="box-card" shadow="never">
        <el-form :inline="true" :model="searchForm" size="mini">
          <el-form-item label="订单号">
            <el-input v-model="searchForm.orderno" style="width: 70px"></el-input>
          </el-form-item>
          <el-form-item label="订单状态">
            <type-select
              v-model="searchForm.state"
              :items="DictMan.items('productOrder.status')"
              style="width: 110px"
            />
          </el-form-item>
          <el-form-item label="支付状态">
            <type-select
              v-model="searchForm.payStatus"
              :items="DictMan.items('payStatus')"
              style="width: 110px"
            />
          </el-form-item>
          <el-form-item label="支付方式">
            <type-select
              v-model="searchForm.payType"
              :items="DictMan.items('payType')"
              style="width: 110px"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSearch">查询</el-button>
          </el-form-item>
        </el-form>
        <data-table
          ref="table"
          url="/api/user/listUser"
          :query-params="{userType: -1}"
        >
          <el-table-column prop="aliasName" label="昵称" width="120"></el-table-column>
          <el-table-column prop="realName" label="姓名" width="80"></el-table-column>
          <el-table-column prop="sex" label="性别" :formatter="formatters.sex" width="60"></el-table-column>
          <el-table-column prop="idcard" label="身份证号码" width="170"></el-table-column>
          <el-table-column prop="telphone" label="手机号" width="110"></el-table-column>
          <el-table-column prop="userType" label="用户类型" :formatter="formatters.userType" width="120"></el-table-column>
            <el-table-column prop="state" label="认证状态" width="100">
              <template slot-scope="scope">
                <el-tag :type="['warning', '', 'success', 'danger'][scope.row.state]" size="small">
                  {{DictMan.itemMap('user.renzheng.state')[scope.row.state]}}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="isVolunteer" label="志愿者" :formatter="formatters.isVolunteer" width="80"></el-table-column>
            <el-table-column label="操作" width="320">
              <template slot-scope="scope">
                <el-button
                  :disabled="scope.row.state != 1"
                  size="mini"
                  type="text"
                  @click="onCheckClick(scope.row)">审核</el-button>
                <el-button
                  :disabled="scope.row.state == 0"
                  size="mini"
                  type="text"
                  @click="onCertDetailsClick(scope.row)">认证信息</el-button>
                <el-button
                  size="mini"
                  type="text"
                  @click="onCertEditClick(scope.row)">认证编辑</el-button>
                <el-button
                  size="mini"
                  type="text"
                  @click="onPermissionSettingsClick(scope.row)">设置权限</el-button>
                <el-button
                  :disabled="scope.row.isVolunteer"
                  size="mini"
                  type="text"
                  @click="onAsVolunteerClick(scope.row)">成为志愿者</el-button>
                </template>
              </template>
            </el-table-column>
        </data-table>
      </el-card>
      <check-dialog ref="checkDialog"></check-dialog>
      <permission-settings ref="permissionSettings"></permission-settings>
      <cert-edit-dialog ref="certEditDialog"></cert-edit-dialog>
    </div>
  `,
  components: {
    'check-dialog': CheckDialog,
    'permission-settings': PermissionSettings,
    'cert-edit-dialog': CertEditDialog
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
    onCertEditClick(row) {
      this.$refs.certEditDialog.open(row, false, () => {
        row.state = 1;
      });
    },
    onCertDetailsClick(row) {
      this.$refs.certEditDialog.open(row, 'readonly');
    },
    onAsVolunteerClick(row) {
    },
    onPermissionSettingsClick(row) {
      this.$refs.permissionSettings.open(row.userId);
    },
    onSearch() {
      this.$refs.table.query(this.searchForm);
    }
  }
};
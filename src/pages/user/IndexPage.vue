<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="姓名">
          <el-input v-model="searchForm.realName" clearable style="width: 100px"></el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="searchForm.telphone" clearable style="width: 130px"></el-input>
        </el-form-item>
        <el-form-item label="设备号/卡号">
          <el-input v-model="searchForm.deviceCode" clearable style="width: 170px"></el-input>
        </el-form-item>
        <el-form-item label="用户类型">
          <type-select
            v-model="searchForm.userType"
            :items="DictMan.items('user.type')"
            style="width: 140px"
          />
        </el-form-item>
        <el-form-item>
          <data-table-query-button icon="el-icon-search" :query-params="searchForm" />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            icon="el-icon-more"
            @click="onQuerierShowClick">高级查询</el-button>
        </el-form-item>
      </el-form>
      <el-dropdown
        split-button
        type="primary"
       
        icon="el-icon-plus"
        trigger="click"
        @command="onCommandClick($event)"
        @click="onAddClick">
        <i class="el-icon-plus"></i>
        <span>增加</span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="import-device-users">批量导入设备用户</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
      <el-button
        type="default"
       
        icon="el-icon-download"
        style="margin-left: 8px;"
        @click="onExportClick"
      >
        导出
      </el-button>
    </div>
    <data-table
      ref="table"
      url="/api/user/listUser"
    >
      <el-table-column prop="realName" label="姓名" width="80" :formatter="formatters.realName"></el-table-column>
      <el-table-column prop="aliasName" label="昵称" width="100" show-overflow-tooltip></el-table-column>
      <el-table-column prop="sex" label="性别" :formatter="formatters.sex" width="60"></el-table-column>
      <el-table-column prop="age" label="年龄" width="60"></el-table-column>
      <el-table-column prop="idcard" label="身份证号码" width="174" :formatter="formatters.idcard"></el-table-column>
      <el-table-column prop="telphone" label="手机号" width="120" :formatter="formatters.telphone"></el-table-column>
      <el-table-column prop="orgName" label="社区" width="160" show-overflow-tooltip></el-table-column>
      <el-table-column prop="userType" label="用户类型" :formatter="formatters.userType" width="120"></el-table-column>
      <el-table-column prop="deviceCode" label="设备号/卡号" :formatter="formatters.deviceCode" width="150"></el-table-column>
      <el-table-column prop="onLine" label="在线状态" width="80">
        <template slot-scope="scope">
          {{scope.row.onLine ? '在线' : '离线'}}
        </template>
      </el-table-column>
      <el-table-column prop="applyTypesText" label="评估对象类型" width="120" :formatter="formatters.applyTypesText" show-overflow-tooltip></el-table-column>
      <el-table-column prop="evalScore" label="评估分数" width="80" :formatter="formatters.evalScore"></el-table-column>
      <el-table-column prop="allowanceMoney" label="拟享受市补贴" width="110" :formatter="formatters.allowanceMoney"></el-table-column>
      <el-table-column prop="registerTime" label="注册时间" width="170"></el-table-column>
      <el-table-column label="操作" width="154" fixed="right">
        <template slot-scope="scope">
          <el-button
            style="margin-left: 0px"
            @click="onDetailsClick(scope.row)"
          >
            详情
          </el-button>
          <el-dropdown
            @command="onCommandClick($event, scope.row)"
            :show-timeout="100"
          >
            <el-button
              type="primary"
              plain
              split-button
            >
              更多<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="wallet" icon="el-icon-wallet">钱包</el-dropdown-item>
              <el-dropdown-item command="trade" icon="el-icon-tickets">消费记录</el-dropdown-item>
              <el-dropdown-item command="points" icon="el-icon-tickets">积分记录</el-dropdown-item>
              <el-dropdown-item command="health-archive" icon="el-icon-document" divided>健康档案</el-dropdown-item>
              <el-dropdown-item command="returnvisit" icon="el-icon-document">回访记录</el-dropdown-item>
              <el-dropdown-item command="address" icon="el-icon-goods">收货地址</el-dropdown-item>
              <template v-if="scope.row.userType == 2">
                <el-dropdown-item
                  command="vipcard-change"
                  icon="el-icon-bank-card"
                  divided
                >更换卡</el-dropdown-item>
                <el-dropdown-item
                  command="vipcard-change-record"
                  icon="el-icon-bank-card"
                >卡更换记录</el-dropdown-item>
              </template>
              <template v-if="scope.row.userType == 9">
                <el-dropdown-item
                  command="hubei-settings"
                  icon="el-icon-setting"
                  divided
                >设备设置</el-dropdown-item>
                <el-dropdown-item
                  command="hubei-change-device-code"
                  icon="el-icon-bank-card"
                >更换设备号</el-dropdown-item>
              </template>
              <el-dropdown-item
                command="set-validity"
                icon="el-icon-refresh"
                divided>启用/禁用</el-dropdown-item>
              <el-dropdown-item
                v-if="scope.row.userType <= 1"
                command="user-reset-password"
                icon="el-icon-key"
                divided
              >重置用户密码</el-dropdown-item>
              <el-dropdown-item command="user-edit" icon="el-icon-edit" divided >修改</el-dropdown-item>
              <el-dropdown-item command="user-cancel" icon="el-icon-document-delete" divided >注销用户</el-dropdown-item>
            </el-dropdown-menu> 
          </el-dropdown>
        </template>
      </el-table-column>
    </data-table>

    <user-querier ref="userQuerier"></user-querier>
    <user-basic-details ref="userBasicDetails"></user-basic-details>
    <device-user-import-dialog ref="deviceUserImportDialog"></device-user-import-dialog>
    <vip-card-change ref="vipCardChange"></vip-card-change>
  </data-table-app-page>
</template>


<script>
import { stringify } from 'qs';

export default {
  pageProps: {
    title: '用户管理'
  },
  components: {
    UserQuerier: () => import('./UserQuerier.vue'),
    UserBasicDetails: () => import('./UserBasicDetails.vue'),
    DeviceUserImportDialog: () => import('./DeviceUserImportDialog.vue'),
    VipCardChange: () => import('./vipcard/change/Change.vue'),
  },
  data() {
    const unknownIfEmpty = (row, col, v) => v ? v : '未知';
    return {
      formatters: {
        realName: unknownIfEmpty,
        idcard: unknownIfEmpty,
        telphone: unknownIfEmpty,
        deviceCode: (row, col, v) => [2,9].includes(row.userType) ? v : '-',
        sex(row, col, val) { return DictMan.itemMap('user.gender')[val]; },
        userType(row, col, val) { return DictMan.itemMap('user.type')[val]; },
        applyTypesText(row, col, val) { return val || '未申请'; },
        evalScore(row, col, val) { return val || 0; },
        allowanceMoney(row, col, val) { return val || 0; },
      },
      searchForm: {}
    }
  },
  methods: {
    onQuerierShowClick() {
      this.$refs.userQuerier.show({
        values: this.searchForm,
        table: this.$refs.table
      });
    },
    onAddClick() {
      app.pushPage({
        path: '/user/edit',
        title: '增加用户',
        params: {
          mode: 'add',
          onSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        }
      });
    },
    onEditClick(user) {
       app.pushPage({
        path: '/user/edit',
        title: '修改用户',
        params: {
          mode: 'update',
          user,
          onSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        }
      });
    },
    onDetailsClick(user) {
      this.$refs.userBasicDetails.show(user);
    },
    onExportClick() {
      this.$message.info('正在处理导出，请稍等...');
      location.href = "api/user/export?" + stringify(this.searchForm);
    },
    onCommandClick(cmd, user) {
      switch (cmd) {
        case 'user-edit':
          this.onEditClick(user);
          break;
        case 'health-archive':
          openTab({
            url: 'view/health/archive/index.do?userId=' + user.id,
            title: '健康档案'
          });
          break;
        case 'returnvisit':
          openTab({
            url: 'view/community/returnvisit/index.do?userId=' + user.id,
            title: '用户[' + user.aliasName  + '] - 回访记录'
          });
          break;
        case 'address':
          openTab({
            url: "view/user/address/index.do?userId=" + user.userId + '&_func_code=user-address',
            title: "用户[" + user.aliasName + "] - 收货地址"
          });
          break;
        case 'wallet':
          openTab({
            url: "view/user/purse/index.do?userId=" + user.userId + '&deviceCode=' + user.deviceCode + '&userType=' + user.userType,
            title: "用户[" + user.aliasName + "] - 钱包"
          });
          break;
        case 'trade':
          openTab({
            url: "view/user/userTradeRecord.do?accountId="+user.id,
            title: "用户[" + user.aliasName + "] - 消费记录"
          });
          break;
        case 'points':
          openTab({
            url: "view/user/userIntegral/userIntegralDetailFom.do?accountId="+user.id,
            title: "用户[" + user.aliasName + "] - 积分记录"
          });
          break;
        case 'set-validity':
          const act = user.isvalid ? '禁用' : '启用';
          this.$confirm(`${user.isvalid ? '' : '当前为禁用状态，'}确认${act}？`, `确认${act}`, {
            type: 'warning'
          }).then(async () => {
            const actVal = +!user.isvalid;
            const ret = await axios.post('/api/device/setValid',
              {deviceId: user.id, isvalid: actVal});
            if (ret.success) {
              this.$message.success('操作成功');
              user.isvalid = actVal;
            }
          });
          break;
        case 'user-cancel':
          this.$confirm(`确认注销用户 ${user.aliasName}？`, `确认`, {
            type: 'warning'
          }).then(async () => {
            const ret = await axios.post('/api/user/cancelUser',
                {userId: user.id, userType: user.userType});
            if (ret.success) {
              this.$message.success('注销用户成功');
              this.$refs.table.reloadCurrentPage();
            }
          });
          break;
        case 'user-reset-password':
          this.$confirm(`确认重置用户 ${user.aliasName} 的密码 ？`, `确认`, {
            type: 'warning'
          }).then(async () => {
            const ret = await axios.post('/api/user/resetPassword', {userId: user.id});
            if (ret.success) {
              this.$message.success('重置密码成功');
            }
          });
          break;
        case 'vipcard-change':
          this.$refs.vipCardChange.show({
            user,
            onSuccess: ({newCardCode}) => {
              user.deviceCode = newCardCode;
            }
          });
          break;
        case 'vipcard-change-record':
          openTab({
            url: 'view/user/vipcard/change/record.do?cardCode=' + user.deviceCode,
            title: '会员卡更换记录'
          });
          break;
        case 'hubei-settings':
          openTab({
            url: 'device/showDeviceDetail.do?_func_code=device-detail&deviceId=' + user.id,
            title: '设备设置'
          });
          break;
        case 'hubei-change-device-code':
          this.$prompt(`更换设备号 - 用户${user.aliasName}`, {
            inputPlaceholder: '请输入新的设备号',
            inputPattern: /^\d+$/
          }).then(async ({action, value}) => {
            if ('confirm' == action) {
              const ret = await axios.post('/api/device/changeDeviceCode',
                {deviceCode: value, oldDeviceId: user.id, oldDeviceCode: user.deviceCode});
              if (ret.success) {
                this.$message.success('更换设备号成功');
                this.$refs.table.reloadCurrentPage();
              }
            }
          });
          break;
        case 'import-device-users':
          this.$refs.deviceUserImportDialog.show({
            onSuccess: () => {
              this.$refs.table.reloadCurrentPage();
            }
          });
          break;
      }
    },
  }
}
</script>
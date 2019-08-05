<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
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
        <el-form-item label="社区">
          <org-select v-model="searchForm.orgId" style="width:260px" />
        </el-form-item>
        <el-form-item>
          <data-table-query-button :query-params="searchForm" />
        </el-form-item>
      </el-form>
      <el-button
        v-if="[1,4,9,14].includes(app.admin.roleId)"
        icon="el-icon-plus"
        @click="onAddClick"
      >
        增加
      </el-button>
    </div>
    <data-table
      ref="table"
      url="/api/shop/boss/bossPage"
    >
      <el-table-column prop="username" label="工号" width="100" show-overflow-tooltip></el-table-column>
      <el-table-column prop="realName" label="姓名" width="140" show-overflow-tooltip></el-table-column>
      <el-table-column prop="phone" label="手机号" width="120"></el-table-column>
      <el-table-column prop="email" label="邮箱" width="200"></el-table-column>
      <el-table-column prop="balance" label="余额" width="100" :formatter="formatters.balance" show-overflow-tooltip></el-table-column>
      <el-table-column prop="oldCardBalance" label="老年卡余额" width="100"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="{row: shop}">
          <el-button
            type="primary"
            plain
            @click="onShopClick(shop)">
            店铺
          </el-button>
          <el-button
            type="primary"
            plain
            @click="onTradeClick(shop)">
            交易流水
          </el-button>
          <el-button
            type="primary"
            plain
            @click="onWithdrawClick(shop)">
            提现
          </el-button>
          <el-button
            @click="onUpdateClick(shop)">
            修改
          </el-button>
        </template>
      </el-table-column>
    </data-table>

  </data-table-app-page>
</template>

<script>
import { Select } from 'element-ui';

export default {
  pageProps: {
    title: '商家管理'
  },
  components: {
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 })
  },
  data() {
    return {
      searchForm: {},
      formatters: {
        balance: (row, col, val) => row.moneyType == 1 ? val : `${val} (虚拟)`
      },
      app
    }
  },
  methods: {
    onAddClick() {
      this.pushPage({
        path: '/shop/boss/edit',
        title: '增加商家',
        params: {
          mode: 'add',
          onSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        }
      });
    },
    onUpdateClick(boss) {
      this.pushPage({
        path: '/shop/boss/edit',
        title: '修改商家',
        params: {
          mode: 'update',
          boss,
          onSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        }
      });
    },
    onWithdrawClick(boss) {
      if (boss.moneyType != 1) {
        this.$alert('该余额类型无法提现');
        return;
      }
      this.openTab({
        url: "shop/finance/withdraw/index.do?operator=" + boss.adminId,
        title: boss.realName + " - 提现管理"
      });
    },
    onShopClick(boss) {
      this.pushPage({
        path: '/shop/shop/index',
        params: { boss },
        subTitle: boss.realName,
        key: boss.id
      });
    },
    onTradeClick(boss) {
      this.pushPage({
        path: '/shop/finance/trade/index',
        params: { boss },
        subTitle: boss.realName,
        key: boss.id
      });
    }
  }
}
</script>

<style scoped>
.cell > .el-button {
  margin-left: 0px;
}
</style>
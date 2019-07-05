<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
      <el-form :inline="true" :model="searchForm">
        <el-form-item
          label="商家工号"
          v-if="!$params.boss && [1,9,14,15].includes(app.admin.roleId)">
          <el-input v-model="searchForm.adminUsername" clearable style="width: 120px"></el-input>
          <el-button icon="el-icon-user" @click="onBossSelectClick"></el-button>
        </el-form-item>
        <el-form-item
          label="商家社区"
          v-if="!$params.boss && [1,9,14,15].includes(app.admin.roleId)">
          <org-select v-model="searchForm.orgId" style="width:260px" />
        </el-form-item>
        <el-form-item label="店铺名称">
          <el-input v-model="searchForm.name" clearable style="width: 200px"></el-input>
        </el-form-item>
        <el-form-item label="行业">
          <type-select
            v-model="searchForm.industryId"
            :items="DictMan.items('product.industry')"
            style="width: 110px"
          />
        </el-form-item>
        <el-form-item>
          <data-table-query-button :query-params="searchForm" />
        </el-form-item>
      </el-form>
      <el-button
        v-if="[1,2,4,9,14].includes(app.admin.roleId)"
        type="primary"
       
        icon="el-icon-plus"
        @click="onAddClick"
      >
        新建
      </el-button>
    </div>
    <data-table
      ref="table"
      url="/api/shop/pro/proPage"
      lazy
    >
      <el-table-column prop="imgUrl" label="店铺图片" width="100">
        <template slot-scope="scope">
          <img :src="scope.row.imgUrl" style="height: 50px;width: 80px;border-radius: 4px;" />
        </template>
      </el-table-column>
      <el-table-column prop="name" label="店铺名称" width="240" show-overflow-tooltip></el-table-column>
      <el-table-column prop="industryText" label="所属行业" width="80"></el-table-column>
      <el-table-column prop="linkman" label="联系人" width="80"></el-table-column>
      <el-table-column prop="telephone" label="联系电话" width="140"></el-table-column>
      <el-table-column prop="adminUsername" label="商家工号" width="100"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="{row}">
          <el-button
            type="primary"
            plain
            icon="el-icon-s-order"
            @click="onOrderClick(row)"
          >
            订单
          </el-button>
          <el-button
            type="primary"
            plain
            @click="onTradeRecordClick(row)"
          >
            交易流水
          </el-button>
          <el-dropdown
            @command="onCommandClick($event, row)"
            :show-timeout="100"
          >
            <el-button
              type="primary"
              plain
              split-button
            >
              管理<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="product" icon="el-icon-s-goods">商品</el-dropdown-item>
              <el-dropdown-item command="service" icon="el-icon-water-cup" v-if="[1,2,4,9,14].includes(app.admin.roleId)">服务</el-dropdown-item>
              <el-dropdown-item command="employee" icon="el-icon-user">员工</el-dropdown-item>
              <!--<el-dropdown-item command="coupon" icon="el-icon-discount" v-if="['catering'].includes(row.industryId)">优惠券</el-dropdown-item>-->
              <el-dropdown-item command="edit" icon="el-icon-edit" divided v-if="[1,2,4,9,14].includes(app.admin.roleId)">修改</el-dropdown-item>
              <el-dropdown-item command="businessMode" icon="el-icon-setting" v-if="[1,2,4,9,14].includes(app.admin.roleId)">派单模式设置</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <el-button
            @click="onDetailsClick(row)"
          >
            详情
          </el-button>
        </template>
      </el-table-column>
    </data-table>

    <dispatch-order-mode-settings ref="dispatchOrderModeSettings" />
    <boss-query-selector ref="bossQuerySelector" />
  </data-table-app-page>
</template>


<script>
import { Select } from 'element-ui';

export default {
  pageProps: {
    title: '店铺管理'
  },
  components: {
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 }),
    DispatchOrderModeSettings: () => import('./DispatchOrderModeSettings.vue'),
    BossQuerySelector: () => import('@/pages/shop/BossQuerySelector.vue')
  },
  data() {
    return {
      app,
      searchForm: {
        adminUsername: this.$params.boss && this.$params.boss.username,
        name: ''
      }
    }
  },
  methods: {
    onBossSelectClick() {
      this.$refs.bossQuerySelector.show({
        onOk: (boss) => {
          this.searchForm.adminUsername = boss.username;
          return true;
        }
      });
    },
    onDetailsClick(shop) {
      this.pushPage({
        path: '/shop/shop/details',
        params: { shop },
        subTitle: shop.name,
        key: shop.id
      });
    },
    onAddClick(shop) {
      this.pushPage({
        path: '/shop/shop/edit',
        title: '新建店铺',
        params: {
          mode: 'add',
          onSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        }
      });
    },
    onOrderClick(shop) {
      if (shop.industryId == 'integral_mall') {
        openTab({
          url: '/shop/order/index.do?providerId=' + shop.providerId + '&industryId=' + shop.industryId,
          title: shop.name + " - " + "订单管理"
        });
      } else {
        this.pushPage({
          path: '/shop/order/index',
          subTitle: shop.name,
          params: { shop },
          key: shop.providerId
        });
      }
    },
    onTradeRecordClick(shop) {
      this.pushPage({
        path: '/shop/finance/trade/index',
        subTitle: shop.name,
        params: { shop },
        key: shop.providerId
      });
    },
    onCommandClick(cmd, shop) {
      switch (cmd) {
        case 'product':
          if(shop.industryId == "activity") {
            openTab({
              url: "/activity/index.do?providerId=" + shop.providerId + '&_func_code=activityManager',
              title: shop.name + " - 活动管理"
            });
          } else {
            openTab({
              url: "shop/product/index.do?providerId=" + shop.providerId,
              title: shop.name + " - 商品管理"
            });
          }
          break;
        case 'service':
          openTab({
            url: 'view/shop/proService/index.do?_func_code=shop&providerId=' + shop.providerId,
            title: shop.name + ' - 服务管理'
          });
          break;
        case 'employee':
          openTab({
            url: 'view/shop/employee/index.do?_func_code=shop&providerId=' + shop.providerId,
            title: shop.name + ' - 员工管理'
          });
          break;
        /*
        case 'coupon':
          openTab({
            url: 'view/coupon/batch/index.do',
            title: '优惠券'
          });
          break;*/
        case 'edit':
          this.pushPage({
            path: '/shop/shop/edit',
            title: '修改店铺',
            params: {
              mode: 'update',
              shop,
              onSuccess: () => {
                this.$refs.table.reloadCurrentPage();
              }
            }
          });
          break;
        case 'businessMode':
          this.$refs.dispatchOrderModeSettings.show(shop);
          break;
      }
    }
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  }
}
</script>

<style scoped>
.cell > .el-button--small {
  margin-left: 0px;
}

</style>

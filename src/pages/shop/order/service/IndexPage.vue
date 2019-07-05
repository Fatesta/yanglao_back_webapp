<template>
  <data-table-app-page>
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="工单编号">
        <el-input v-model="searchForm.orderno" clearable style="width: 210px"></el-input>
      </el-form-item>
      <el-form-item label="工单状态">
        <type-select
          v-model="searchForm.statuses"
          :items="statusItems"
          style="width: 130px"
        />
      </el-form-item>
      <el-form-item label="线上/线下">
        <type-select
          v-model="searchForm.lineState"
          :items="[{text: '线上', value: 1}, {text: '线下', value: 0}]"
          style="width: 130px"
        />
      </el-form-item>
      <el-form-item label="下单用户">
        <el-input v-model="creatorName" readonly clearable style="width: 100px" @focus="onCreatorNameInputFocus"></el-input>
        <el-button v-show="searchForm.creator" icon="el-icon-close" type="text" @click="creatorName = '', searchForm.creator = null"></el-button>
      </el-form-item>
      <el-form-item label="行业">
        <type-select
          v-model="searchForm.industryId"
          :items="DictMan.items('product.industry')"
          style="width: 110px"
        />
      </el-form-item>
      <el-form-item label="下单日期">
        <el-date-picker
          v-model="searchForm.startCreateTime"
          value-format="yyyy-MM-dd"
          align="right"
          type="date"
          placeholder="选择日期"
          style="width: 140px">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <data-table-query-button
          :query-params="() => ({
            ...searchForm,
            ...(searchForm.startCreateTime ? {
                startCreateTime: searchForm.startCreateTime + ' 00:00:00',
                endCreateTime: searchForm.startCreateTime + ' 23:59:59'
              } : {})
          })" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/shop/order/orderPage"
    >
      <el-table-column prop="orderno" label="工单号" width="190"></el-table-column>
      <el-table-column prop="status" label="工单状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[scope.row.status]">
            {{statusMap[scope.row.status]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="payStatus" label="支付状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="['warning', 'success'][scope.row.payStatus]">
            {{DictMan.itemMap('payStatus')[scope.row.payStatus]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="lineState" label="线上下" width="70" :formatter="formatters.lineState"></el-table-column>
      <el-table-column prop="providerName" label="商家店铺" width="240" show-overflow-tooltip></el-table-column>
      <el-table-column prop="industryId" label="行业" width="80" :formatter="formatters.industryId"></el-table-column>
      <el-table-column prop="creatorName" label="下单人" width="80" show-overflow-tooltip></el-table-column>
      <el-table-column prop="creatorOrgName" label="下单人社区" width="100" show-overflow-tooltip></el-table-column>
      <el-table-column prop="createTime" label="下单时间" width="170"></el-table-column>
      <el-table-column label="操作" width="140" fixed="right">
        <template slot-scope="scope">
          <el-button
            type="primary"
            plain
            @click="onDetailsClick(scope.row)">详情</el-button>
          <el-button
            :disabled="!(scope.row.longitude && scope.row.latitude)"
            type="primary"
            plain
            style="margin-left:0px"
            @click="onLocationClick(scope.row)">定位</el-button>
        </template>
      </el-table-column>
    </data-table>
    <user-query-selector ref="userQuerySelector" />
  </data-table-app-page>
</template>

<script>
export default {
  pageProps: {
    title: '服务工单'
  },
  components: {
    UserQuerySelector: () => import('@/pages/user/UserQuerySelector.vue')
  },
  data() {
    return {
      formatters: {
        lineState: (row, col, val) => val ? '线上' : '线下',
        industryId: (row, col, val) => DictMan.itemMap('product.industry')[val]
      },
      creatorName: null,
      searchForm: {
        creator: null,
        industryIds: "'mall','activity','catering','housekeeping'"
      },
      statusItems: [
        {value: '10,11', text: '服务未开始'},
        {value: '12,13,14', text: '服务进行中'},
        {value: '15', text: '服务已完成'},
        {value: '16', text: '服务已取消'}
      ]
    };
  },
  computed: {
    statusMap() {
      let statusMap = {};
      this.statusItems.forEach(function(item) {
        item.value.split(',').forEach(function(k) {
          statusMap[k] = item.text;
        });
      });
      return statusMap;
    }
  },
  methods: {
    onCreatorNameInputFocus() {
      this.searchForm.creator = null;
      this.creatorName = null;
      this.$refs.userQuerySelector.show({
        onOk: (user) => {
          this.searchForm.creator = user.id;
          this.creatorName = user.aliasName;
          return true;
        }
      });
    },
    onDetailsClick(order) {
      this.pushPage({
        path: '/shop/order/details',
        params: {
          order,
          type: 'service',
          statusMap: this.statusMap,
          onDeleteSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        },
        key: order.orderno,
        title: '工单详情',
        subTitle: order.orderno
      });
    },
    onLocationClick({orderno}) {
      if (getModuleContext('shop.orderLocation') && getModuleContext('shop.orderLocation').isCreated()) {
          openModuleByCode('shop.orderLocation');
          getModuleContext('shop.orderLocation').gotoOrder(orderno);
      } else {
        openModuleByCode('shop.orderLocation', {onLoad: function() {
          getModuleContext('shop.orderLocation').gotoOrder(orderno);
        }});
      }
    } 
  }
}
</script>
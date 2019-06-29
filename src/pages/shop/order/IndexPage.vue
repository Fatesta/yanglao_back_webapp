<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="订单号">
          <el-input v-model="searchForm.orderno" clearable style="width: 190px"></el-input>
        </el-form-item>
        <el-form-item label="订单状态">
          <type-select
            v-model="searchForm.status"
            :items="DictMan.items('productOrder.status')"
            style="width: 130px"
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
      <el-button
        v-if="this.$params.shop.industryId != 'activity' && [1,2,4,9,14].includes(app.admin.roleId)"
        type="primary"
        icon="el-icon-plus"
        @click="onAddClick"
      >
        下单
      </el-button>
      <el-button
        type="default"
        icon="el-icon-download"
        @click="onExportClick"
      >
        导出
      </el-button>
    </div>
    <data-table
      ref="table"
      url="/api/shop/order/orderPage"
      lazy
    >
      <el-table-column prop="orderno" label="订单号" width="190"></el-table-column>
      <el-table-column prop="status" label="订单状态" width="120">
        <template slot-scope="scope">
          <el-tag :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[scope.row.status]">
            {{scope.row.statusText}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="paymentFee" label="订单金额" width="90"></el-table-column>
      <el-table-column prop="payStatus" label="支付状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="['warning', 'success'][scope.row.payStatus]">
            {{scope.row.payStatusText}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="payTypeText" label="支付方式" width="120"></el-table-column>
      <el-table-column prop="linkman" label="下单人" width="120"></el-table-column>
      <el-table-column prop="createTime" label="下单时间" width="170"></el-table-column>
      <el-table-column label="操作" fixed="right">
        <template slot-scope="scope">
          <el-button
            type="primary"
            plain
            @click="onDetailsClick(scope.row)">
            详情
          </el-button>
          <el-button
            v-if="
              ['housekeeping', 'catering'].includes(scope.row.industryId)
              && (scope.row.status == 10 || scope.row.status == 12)"
            type="primary"
            plain
            @click="onTakingClick(scope.row)"
          >
            {{$params.shop.businessMode == 0 ? '接单' : '派单'}}
          </el-button>
        </template>
      </el-table-column>
    </data-table>
    
    <employee-query-selector ref="employeeQuerySelector" />
  </data-table-app-page>
</template>

<script>
import { stringify } from 'qs';

export default {
  pageProps: {
    title: '订单管理'
  },
  components: {
    EmployeeQuerySelector: () => import('../EmployeeQuerySelector.vue')
  },
  data() {
    return {
      searchForm: {
        providerId: this.$params.shop.providerId
      },
      app
    }
  },
  methods: {
    onAddClick(order) {
      const { shop } = this.$params;
      if (['housekeeping', 'catering'].includes(shop.industryId)) {
        this.pushPage({
          path: '/shop/order/flow/place/index',
          params: {
            shop,
            orderTable: this.$refs.table
          },
          subTitle: shop.name
        });
      } else {
        openTab({
          url: "/shop/order/orderAdd.do?providerId=" + shop.providerId,
          title: shop.name + " - 下单"
        });
      }
    },
    onTakingClick(order) {
      const submit = async (handler) => {
        handler = handler || this.$params.shop.adminId;
        let operator = this.$params.shop.adminId;
        const ret = await axios.post(
          '/api/shop/order/taking',
          {
            orderno: order.orderno,
            creator: order.creator,
            operator,
            handler
          });
        if (ret.success) {
          order.status = 13;
          order.operator = operator;
          order.handler = handler;
          this.$message.success((this.$params.shop.businessMode == 0 ? '接单' : '派单') + '成功');
        } else {
          this.$message.error(ret.message);
        }
      };

      if (this.$params.shop.businessMode == 1) {
        this.$refs.employeeQuerySelector.show({
          title: '指派订单服务人员',
          queryParams: {
            providerId: order.providerId
          },
          onOk: (employee) => {
            submit(employee.adminId);
            return true;
          }
        });
      } else {
        submit();
      }
    },
    onDetailsClick(order) {
      this.pushPage({
        path: '/shop/order/details',
        params: {
          order,
          shop: this.$params.shop,
          onDeleteSuccess: () => {
            this.$refs.table.reloadCurrentPage();
          }
        },
        key: order.orderno,
        subTitle: order.orderno
      });
    },
    onExportClick() {
      this.$message.info('正在处理导出，请稍等...');
      location.href = "api/shop/order/export?" + stringify(this.searchForm);
    }
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  }
}
</script>
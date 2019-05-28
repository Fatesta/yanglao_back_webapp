<template>
  <el-card class="box-card" shadow="never">
    <el-form :inline="true" :model="searchForm" size="mini">
      <el-form-item label="订单号">
        <el-input v-model="searchForm.orderno" style="width: 170px"></el-input>
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
    <data-table
      ref="table"
      url="/api/shop/order/orderPage"
      lazy
    >
      <el-table-column prop="orderno" label="订单号" width="190"></el-table-column>
      <el-table-column prop="status" label="订单状态" width="120">
        <template slot-scope="scope">
          <el-tag :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[scope.row.status]" size="small">
            {{DictMan.itemMap('productOrder.status')[scope.row.status]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="paymentFee" label="金额" width="70"></el-table-column>
      <el-table-column prop="payStatus" label="支付状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="['warning', 'success'][scope.row.payStatus]" size="small">
            {{DictMan.itemMap('payStatus')[scope.row.payStatus]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="payType" label="支付方式" width="120" :formatter="formatters.payType"></el-table-column>
      <el-table-column prop="linkman" label="下单人" width="120"></el-table-column>
      <el-table-column prop="linkphone" label="联系电话" width="140"></el-table-column>
      <el-table-column prop="createTime" label="下单时间" width="170"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            @click="onDetailsClick(scope.row)">查看详情</el-button>
          </template>
        </template>
      </el-table-column>
    </data-table>
  </el-card>
</template>

<script>
export default {
  data() {
    return {
      formatters: {
        payType: (row, col, val) => DictMan.itemMap('payType')[val]
      },
      searchForm: {
        providerId: this.$attrs.routeParams.providerId
      }
    }
  },
  methods: {
    onDetailsClick(order) {
      openTab({
        title: '订单详情 - ' + order.orderno,
        url: '/view/shop/workOrder/orderDetail.do?orderCode=' + order.orderno
      });
    }
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  }
}
</script>
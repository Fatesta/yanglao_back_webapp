<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="交易类型">
          <type-select
            v-model="searchForm.tradeType"
            :items="DictMan.items('tradeType')"
            style="width: 150px"
          />
        </el-form-item>
        <el-form-item label="支付方式">
          <type-select
            v-model="searchForm.payType"
            :items="DictMan.items('payType')"
            style="width: 120px"
          />
        </el-form-item>
        <el-form-item label="优惠方式">
          <type-select
            v-model="searchForm.yhType"
            :items="[
              {value:  0, text: '无优惠'},
              {value: -1, text: '店铺充值赠送'},
              {value:  2, text: '店铺优惠劵抵扣'},
              {value:  1, text: '平台优惠劵抵扣'},
              {value: -2, text: '老年卡补贴'}
            ]"
            style="width: 150px"
          />
        </el-form-item>
        <el-form-item label="交易时间">
          <el-date-picker
            v-model="searchForm.createTimes"
            format="yyyy-MM-dd HH:mm"
            value-format="yyyy-MM-dd HH:mm:ss"
            :default-time="['00:00:00', '23:59:59']"
            align="right"
            type="daterange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            placeholder="选择时间范围"
            :picker-options="pickerOptions"
          />
        </el-form-item>
        <el-form-item>
          <data-table-query-button :query-params="getQueryParams" />
        </el-form-item>
        <el-form-item>
          <el-button
            type="default"
            icon="el-icon-download"
            @click="onExportClick"
          >
            导出
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <data-table
      ref="table"
      url="/api/shop/finance/tradeDetailPage"
      lazy
    >
      <el-table-column prop="createTime" label="交易时间" width="170"></el-table-column>
      <el-table-column prop="formattedTradeType" label="交易类型" width="120" show-overflow-tooltip></el-table-column>
      <el-table-column prop="payType" label="支付方式" width="110" :formatter="formatters.payType"></el-table-column>
      <el-table-column prop="totalFee" label="原价" width="80"></el-table-column>
      <el-table-column prop="tradePrice" label="实收" width="80"></el-table-column>
      <el-table-column prop="formattedCouponAmount" label="优惠" width="180" show-overflow-tooltip></el-table-column>
      <el-table-column prop="userAccountAliasName" label="买家" width="100"></el-table-column>
      <el-table-column prop="userAccountDeviceCode" label="设备号/卡号" width="160" :formatter="formatters.userAccountDeviceCode"></el-table-column>
      <el-table-column prop="providerName" label="店铺名称" width="200" show-overflow-tooltip v-if="!searchForm.providerId"></el-table-column>
      <el-table-column prop="operationAccountUsername" label="操作商家工号" width="120"></el-table-column>
      <el-table-column prop="operationPhoneLogo" label="商家设备标识" width="120" show-overflow-tooltip></el-table-column>
      <el-table-column prop="orderno" label="订单号" width="190">
        <template slot-scope="{row}">
          <el-button v-if="row.orderno && !row.orderno.startsWith('PPCW')" type="text" @click="onOrderDetailsClick(row.orderno)">{{row.orderno}}</el-button>
        </template>
      </el-table-column>
    </data-table>

  </data-table-app-page>
</template>

<script>
import { stringify } from 'qs';
import moment from 'moment';

export default {
  pageProps: {
    title: '交易流水'
  },
  data() {
    return {
      formatters: {
        userAccountDeviceCode: (row, col, v) =>
          (row.userAccount && [2,9].includes(+row.userAccount[0])) ? v : '-',
        payType: (row, col, val) => DictMan.itemMap('payType')[val]
      },
      searchForm: {
        providerId: this.$params.shop && this.$params.shop.providerId,
        providerAccount: this.$params.boss && this.$params.boss.adminId,
        userAccount: this.$params.userAccount
      },
      pickerOptions: {
        shortcuts: [
          {
          text: '昨天',
          onClick(picker) {
            const end = moment().subtract(1, 'd');
            const start = moment().subtract(1, 'd');
            picker.$emit('pick', [
              start.format('YYYY-MM-DD 00:00:00'),
              end.format('YYYY-MM-DD 23:59:00')
            ]);
          }
        }].concat(
          [[7, '最近七天'], [30, '最近一个月'], [90, '最近三个月'], [180, '最近六个月']].map(([days, text]) => {
            return {
              text,
              onClick(picker) {
                const end = moment();
                const start = moment();
                picker.$emit('pick', [
                  start.subtract(days - 1, 'd').format('YYYY-MM-DD 00:00:00'),
                  end.format('YYYY-MM-DD 23:59:00')
                ]);
              }
            };
          }))
      },
      app
    }
  },
  methods: {
    getQueryParams() {
      let queryParams = {...this.searchForm};
      queryParams = {
        ...queryParams,
        ...(queryParams.createTimes ? {
            startCreateTime: queryParams.createTimes[0],
            endCreateTime: queryParams.createTimes[1]
          } : {})
      };
      delete queryParams.createTimes;
      return queryParams;
    },
    onOrderDetailsClick(orderno) {
      this.pushPage({
        path: '/shop/order/details',
        params: {
          order: {orderno},
          shop: this.$params.shop
        },
        key: orderno,
        subTitle: orderno
      });
    },
    onExportClick() {
      this.$message.info('正在处理导出，请稍等...');
      location.href = "api/shop/finance/exportTradeDetail?" + stringify(this.getQueryParams());
    }
  },
  mounted() {
    this.$refs.table.query(this.getQueryParams());
  }
}
</script>
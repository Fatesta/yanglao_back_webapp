<template>
  <el-card shadow="hover" body-style="padding: 8px 20px;" style="margin-bottom: 4px">
    <el-form :model="queryForm" size="mini" :inline="true">
      <el-form-item
        v-if="[1,14,15].includes(app.admin.roleId)"
        label="社区"
      >
        <org-select v-model="queryForm.orgId" is-admin style="width:230px" />
      </el-form-item>
      <el-form-item
        v-if="[1,9,14,15].includes(app.admin.roleId)"
        label="商家"
      >
        <el-select v-model="queryForm.bossId" clearable filterable style="width:100px">
          <el-option
            v-for="boss in bossPage.rows"
            :key="boss.adminId"
            :value="boss.adminId"
            :label="boss.realName"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="店铺">
        <el-select
          v-model="queryForm.providerId"
          clearable
          filterable
          style="width:200px"
        >
          <el-option
            v-for="shop in shopPage.rows"
            :key="shop.id"
            :value="shop.id"
            :label="shop.name"
          />
        </el-select>
      </el-form-item>
      <el-form-item v-if="isTradeQueryForm" label="类型">
        <type-select
          v-model="queryForm.tradeType"
          placeholder=""
          :clearable="false"
          :items="[{value: 4, text: '给用户充值'}, {value: 3, text: '销售额'}]"
          style="width: 112px"
        />
      </el-form-item>
      <el-form-item label="时间">
        <type-select
          v-model="queryForm.timeUnit"
          placeholder=""
          :clearable="false"
          :items="[{value: 'day', text: '日'}, {value: 'month', text: '月'}, {value: 'year', text: '年'}]"
          style="width: 64px"
        />
        <el-date-picker
          v-model="queryForm.dateRange"
          :type="{day: 'daterange', month: 'monthrange', year: 'year'}[queryForm.timeUnit]"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          style="width:240px"
        />
      </el-form-item>
    </el-form>
  </el-card>
</template>


<script>
import { Select } from 'element-ui';
import moment from 'moment';

export default {
  components: {
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 }),
  },
  props: {isTradeQueryForm: Boolean, default: false},
  data() {
    return {
      queryForm: {
        orgId: null,
        bossId: null,
        providerId: null,
        timeUnit: 'day',
        dateRange: null,
        tradeType: this.isTradeQueryForm && 3
      },
      bossPage: {},
      shopPage: {},
      app
    };
  },
  watch: {
    async 'queryForm.orgId'(orgId) {
      this.bossPage = {};

      if (orgId) {
        this.bossPage = await this.axios.get(
          '/api/shop/boss/bossPage', {params: {orgId, page: 1, rows: 10000}});
        if (this.bossPage.total == 1) {
          this.queryForm.bossId = this.bossPage.rows[0].adminId;
        } else {
          this.queryForm.bossId = null;
          this.onQuery();
        }
      } else {
        this.queryForm.bossId = null;
        this.onQuery();
      }
    },
    'queryForm.bossId'(bossId) {
      this.shopPage = {};
      if (bossId) {
        this.queryShopByBossId(bossId);
      } else {
        this.queryForm.providerId = null;
      }
    },
    'queryForm.providerId'(value) {
      this.onQuery();
    },
    'queryForm.timeUnit': {
      handler(value) {
        switch(value) {
          case 'day':
            this.queryForm.dateRange = [moment().subtract(29, 'days'), moment()];
            break;
          case 'month':
            this.queryForm.dateRange = [moment().subtract(11, 'month'), moment()];
            break;
          case 'year':
            this.queryForm.dateRange = moment();
            break;
        }
      },
      immediate: true
    },
    'queryForm.tradeType'(value) {
      this.onQuery();
    },
    'queryForm.dateRange'(value) {
      this.onQuery();
    }
  },
  mounted() {
    switch (app.admin.roleId) {
      case 1:
      case 14:
      case 15:
        this.onQuery();
        break;
      case 2:
      case 4:
        this.queryShopByBossId();
        break;
      case 9:
        this.onOrgChange(app.admin.orgId);
        break;
    }
  },
  methods: {
    onQuery() {
      let params = {...this.queryForm};
      if (params.dateRange) {
        const { timeUnit } = params;
        if (timeUnit == 'year') {
          params.dateRange = new Array(2).fill(params.dateRange);
        }
        const [ startDate, endDate ] = params.dateRange;

        // 检查范围是否合法
        if (timeUnit != 'year') {
          const TIME_DIFF_MAX = {day: 30, month: 12};
          if (moment(endDate).diff(moment(startDate), timeUnit) + 1 > TIME_DIFF_MAX[timeUnit]) {
            this.$message.warning(`按${{day:'日', month:'月',year:'年'}[timeUnit]}统计时间差不能超过${TIME_DIFF_MAX[timeUnit]}`);
            return;
          }
        }

        // 转换为字符串
        const format = ({year: 'YYYY', month: 'YYYY-MM', day: 'YYYY-MM-DD'})[timeUnit];
        params.startTime = moment(startDate).format(format);
        params.endTime = moment(endDate).format(format);
        
        delete params.dateRange;
      }

      if (!params.tradeType) {
        delete params.tradeType;
      }

      this.$emit('query', params);
    },
    async queryShopByBossId(bossId) {
      this.shopPage = await this.axios.get(
        '/api/shop/pro/proPage', {params: {bossId, page: 1, rows: 10000}});
      if (this.shopPage.total == 1) {
        this.queryForm.providerId = this.shopPage.rows[0].id;
      } else {
        this.queryForm.providerId = null;
      }
    }
  }
}
</script>

<style scoped>
.el-form-item {
  margin-bottom: 0px !important;
}
</style>
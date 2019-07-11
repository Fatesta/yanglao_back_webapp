<template>
  <div>
    <data-table-app-page>
      <data-table
        ref="table"
        url="/api/community/berth/checkinRecord/page"
        lazy
      >
        <el-table-column prop="id" label="记录ID" width="70" show-overflow-tooltip></el-table-column>
        <el-table-column prop="berthNo" label="入住床位" width="170" :formatter="formatters.berthNo" show-overflow-tooltip></el-table-column>
        <el-table-column prop="userName" label="入住人" width="80" show-overflow-tooltip></el-table-column>
        <el-table-column prop="userIdcard" label="入住人身份证号" width="174"></el-table-column>
        <el-table-column prop="startTime" label="入住日期" width="110"></el-table-column>
        <el-table-column prop="endTime" label="退住日期" width="110"></el-table-column>
        <el-table-column prop="days" label="入住时长" width="120" :formatter="formatters.days"></el-table-column>
        <el-table-column prop="deposit" label="已付押金" width="90"></el-table-column>
        <el-table-column prop="paidMoney" label="已付款" width="90"></el-table-column>
        <el-table-column prop="amount" label="总费用" width="90"></el-table-column>
        <el-table-column prop="state" label="状态" width="120" show-overflow-tooltip>
          <template slot-scope="{row}">
            <el-tag :type="['danger', 'success', 'warning'][row.state]">
              {{formatters.state(row)}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="入住记录创建时间" width="170"></el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="{row}">
            <el-button
              type="primary"
              plain
              @click="onCheckinPayRecordClick(row)">
              账单
            </el-button>
            <el-button
              v-if="(row.state == 0 || row.state == 2 || row.diffMoney < 0)"
              plain
              @click="onPayClick(row)">
              交费
            </el-button>
          </template>
        </el-table-column>
      </data-table>
    </data-table-app-page>
    <normal-pay ref="normalPay" />
  </div>
</template>

<script>
import { toDurationText } from '@/utils/time-ui';

export default {
  pageProps: {
    title: '入住记录'
  },
  components: {
    NormalPay: () => import('../NormalPay')
  },
  data() {
    return {
      formatters: {
        berthNo: (r) => (r.buildingNo + '栋' + r.floorNo + '层' + r.roomNo + '房-床位' + r.berthNo),
        state(checkin) {
          let text = {0: '入住中', 1: '费用已交清', 2: '费用未交清'}[checkin.state];
          if (checkin.diffMoney == 0)
            return text;
          else if(checkin.diffMoney > 0) {
            text += '，还欠款' + +checkin.diffMoney.toFixed(2);
          } else {
            text += '，需退款' + -checkin.diffMoney.toFixed(2);
          }
          return text;
        },
        days: (r, c, v) => toDurationText(v, {unit: 'day', precision: 'day'})
      },
      searchForm: {
        berthId: this.$params.berthId,
        resthomeId: this.$params.resthomeId
      }
    };
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  },
  methods: {
    onCheckinPayRecordClick(row) {
      this.pushPage({
        path: '/resthome/checkin/finance/pay-record',
        params: {
          checkinId: row.id
        },
        key: row.id,
        subTitle: `入住记录${row.id}`
      });
    },
    onPayClick(row) {
      this.$refs.normalPay.show({
        berthNo: row.berthNo,
        berthCheckin: { id: row.id  }
      }, () => {
        this.$refs.table.reloadCurrentPage();
      });
    }
  }
}
</script>

<template>
  <plain-page>
    <el-card shadow="never" body-style="padding: 10px 20px;">
      <el-row :gutter="56">
        <el-col :span="4">
          <span class="balance-title">
            余额
          </span>
        </el-col>
        <el-col v-if="balances.oldCardBalance" :span="4">
          <span class="balance-title">
            老年卡余额
          </span>
        </el-col>
        <el-col :span="4">
          <span class="balance-title">
            积分
          </span>
        </el-col>
        <el-col :span="4">
          <span class="balance-title">
            优惠券
          </span>
        </el-col>
        <el-col :span="4">
          <span class="balance-title">
            服务卡
          </span>
        </el-col>
      </el-row>
      <el-row :gutter="56">
        <el-col :span="4">
          <span class="balance-num" style="color:#F56C6C">{{balances.balance}}</span>
        </el-col>
        <el-col v-if="balances.oldCardBalance" :span="4">
          <span class="balance-num" style="color:#E6A23C;">{{balances.oldCardBalance}}</span>
        </el-col>
        <el-col :span="4">
          <span class="balance-num secondary">{{balances.points}}</span>
        </el-col>
        <el-col :span="4">
          <span class="balance-num secondary">{{couponCount}}张</span>
        </el-col>
        <el-col :span="4">
          <span class="balance-num secondary">{{serviceCardCount}}张</span>
        </el-col>
      </el-row>
    </el-card>
    <el-card shadow="never" body-style="padding: 10px 20px;" style="margin-top: 4px;">
      <el-tabs v-model="tab" @tab-click="onTabClick">
        <el-tab-pane label="优惠券" name="coupon">
          <data-table
            ref="couponTable"
            url="/api/user/purse/coupon/page"
            :queryParams="{providerId: '', scope: '', type: 0, accountId: $params.user.userType == 9 ? $params.user.deviceCode : $params.user.id}"
            :pagination="{pageSize: 30}"
            :height="405"
          >
            <el-table-column prop="couponNumber" label="编号" width="100" />
            <el-table-column prop="subject" label="主题" width="160" show-overflow-tooltip />
            <el-table-column prop="expiryTime" label="有效期" width="200" :formatter="formatters.expiryTime" show-overflow-tooltip />
            <el-table-column prop="providerName" label="店铺" width="260" show-overflow-tooltip />
            <el-table-column prop="status" label="状态" width="90">
              <template slot-scope="{row}">
                <el-tag :type="['success', 'warning', 'error'][row.status]">
                  {{DictMan.itemMap('coupon.status')[row.status]}}
                </el-tag>
              </template>
            </el-table-column>
          </data-table>
        </el-tab-pane>
        <el-tab-pane label="服务卡" name="serviceCard">
          <data-table
            ref="serviceCardTable"
            data="serviceCards"
            :pagination="{pageSize: 30}"
            :height="405"
          >
            <el-table-column prop="cardName" label="名称" width="200" show-overflow-tooltip/>
            <el-table-column prop="cardNumber" label="卡号" width="140" show-overflow-tooltip />
            <el-table-column prop="price" label="价格" width="90" show-overflow-tooltip />
            <el-table-column prop="expiryTime" label="有效期" width="230"  :formatter="formatters.expiryTime" show-overflow-tooltip />
            <el-table-column prop="contactNumber" label="联系电话" width="140" show-overflow-tooltip />
          </data-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </plain-page>
</template>

<script>
export default {
  pageProps: {
    title: '钱包'
  },
  data() {
    return {
      tab: 'coupon',
      balances: {
        balance: '-',
        points: '-',
      },
      couponCount: 0,
      serviceCardCount: 0,
      serviceCards: [],
      formatters: {
        expiryTime: (row) => `${row.startTime.substring(0, 10)} ~ ${row.endTime.substring(0, 10)}`
      }
    };
  },
  async mounted() {
    const ret = await this.axios.get('/api/user/purse/get', {params: {userId: this.$params.user.id}});
    this.balances = {
      balance: ret.gold,
      points: ret.silver,
      oldCardBlance: null
    };
    if (ret.oldCardBlance != '-1' && data.oldCardBlance !== '') {
      this.balances.oldCardBlance = ret.oldCardBlance;
    }

    this.serviceCards = ret.cardList;

    // 计算可用券和卡数量
    let num = 0;
    ret.couponList.forEach(c => {
      if (c.status == 0)
        num++;
    });
    this.couponCount = num;
    this.serviceCardCount = ret.cardList.length;
  },
  methods: {
    onTabClick() {

    }
  }
}
</script>


<style scoped>
.balance-title {
  font-size: 14px;
  color: #909399;
}
.balance-num {
  font-size: 18px;
  font-weight: bold;
}
.balance-num.secondary {
  font-size:16px;
  font-weight:normal;
}
</style>

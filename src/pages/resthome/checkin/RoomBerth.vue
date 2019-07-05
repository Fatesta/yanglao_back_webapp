<template>
  <el-card
    shadow="hover"
    class="room-berth"
    :style="{
      'background-color': berth.isEmpty ? '#f0f9eb' : '#fef0f0'
    }"
    :body-style="{
      'padding': '10px'
    }">
    <div slot="header">
      床{{berth.berthNo}}
      <span style="color:#909399">{{berth.berthTypeName}}</span>
      <el-dropdown @command="onCommand" style="float: right;">
        <span class="el-dropdown-link">
          <i class="el-icon-setting"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="payDeposit" v-if="!berth.isEmpty">交押金</el-dropdown-item>
          <el-dropdown-item command="pay" v-if="!berth.isEmpty">交费</el-dropdown-item>
          <el-dropdown-item command="userInfo" v-if="!berth.isEmpty">入住人详情</el-dropdown-item>
          <el-dropdown-item command="checkinRecord">入住记录</el-dropdown-item>
          <el-dropdown-item command="checkinPayRecord">账单</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
    <el-row>
      <el-col :span="12" class="user-info">
        <el-row>
          <el-col v-html="!berth.isEmpty && berth.berthCheckin.userInfo ? berth.berthCheckin.userInfo.realName : '&nbsp;'"></el-col>
        </el-row>
        <el-row>
          <el-col>
            <span v-html="!berth.isEmpty && berth.berthCheckin.userInfo ? (berth.berthCheckin.userInfo.sex == 1 ? '女' : '男') : '&nbsp;'"></span>
            <span style="margin-left:4px;" v-if="!berth.isEmpty && berth.berthCheckin.userInfo">{{berth.berthCheckin.userInfo.age}}岁</span>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12" class="operations">
        <el-button
          v-if="berth.isEmpty"
          size="mini"
          type="success"
          plain
          @click="onCheckinClick"
        >入住</el-button>
        <el-button
          v-else
          size="mini"
          type="danger"
          plain
          @click="onCheckoutClick"
        >退住</el-button>
      </el-col>
    </el-row>

    <user-basic-details ref="userBasicDetails" />
    <deposit-pay ref="depositPay" />
    <normal-pay ref="normalPay" />
  </el-card>
</template>

<script>

export default {
  components: {
    UserBasicDetails: () => import('@/pages/user/UserBasicDetails.vue'),
    DepositPay: () => import('./DepositPay'),
    NormalPay: () => import('./NormalPay')
  },
  props: {
    berth: Object
  },
  methods: {
    onCheckinClick() {
      this.pushPage({
        path: '/resthome/checkin/checkin-form',
        params: {
          berth: this.berth,
          onSuccess: (user) => {
            this.berth.isEmpty = false;
            this.berth.berthCheckin = {userInfo: user};
          }
        },
        key: this.berth.id
      });
    },
    onCheckoutClick() {
      this.pushPage({
        path: '/resthome/checkin/leave-form',
        params: {
          berth: this.berth,
          onSuccess: () => {
            this.berth.isEmpty = true;
          }
        },
        key: this.berth.id
      });
    },
    onCommand(cmd) {
      switch (cmd) {
        case 'payDeposit':
          this.$refs.depositPay.show(this.berth);
          break;
        case 'pay':
          this.$refs.normalPay.show(this.berth);
          break;
        case 'userInfo':
          this.$refs.userBasicDetails.show({id: this.berth.berthCheckin.userId});
          break;
        case 'checkinRecord':
          this.pushPage({
            path: '/resthome/checkin/record/checkin-record',
            params: {
              berthId: this.berth.id
            },
            key: this.berth.id,
            subTitle: `床位${this.berth.berthNo}`
          });
          break;
        case 'checkinPayRecord':
          this.pushPage({
            path: '/resthome/checkin/finance/pay-record',
            params: {
              berthId: this.berth.id
            },
            key: this.berth.id,
            subTitle: `床位${this.berth.berthNo}`
          });
          break;
      }
    }
  },
  created() {
    let { berth } = this;
    if (!berth.isEmpty) {
      if (berth.berthCheckin == null) {
          berth.berthCheckin = {userInfo: null};
      }
    }
  }
}
</script>

<style scoped>
.room-berth {
  width: 190px;
  font-size: 14px;
  color: #606266;
}
.user-info {
  padding-left: 20px;
  line-height: 24px;
  text-align: left;
}
.operations {
  line-height: 48px;
}
</style>

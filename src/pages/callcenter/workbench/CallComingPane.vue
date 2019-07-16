<template>
  <div
    style="width:420px; margin: 0 auto;"
  >
    <template v-if="userInfo">
      <el-card shadow="never" style="margin-bottom: 20px;">
        <div slot="header" style="font-weight: 500;">用户信息</div>
        <el-row>
          <el-col :span="5">姓名</el-col>
          <el-col :span="18">{{userInfo.realName || userInfo.aliasName}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="5">性别</el-col>
          <el-col :span="18">{{userInfo.sex == 0 ? '男' : '女'}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="5">年龄</el-col>
          <el-col :span="18">{{userInfo.age}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="5">电话号码</el-col>
          <el-col :span="18">{{userInfo.telphone}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="5">家庭地址</el-col>
          <el-col :span="18">{{userInfo.address}}</el-col>
        </el-row>
      </el-card>
      <el-button type="primary" icon="el-icon-user" plain @click="onUserDetailsClick">
        用户详情
      </el-button>
      <el-button type="danger" icon="el-icon-location" plain @click="onLocateUserClick">
        用户位置
      </el-button>
      <el-button type="success" icon="el-icon-s-order" plain @click="onPlaceOrderClick">
        快速下单
      </el-button>
      <el-button type="default" plain @click="onCloseClick">
        关闭
      </el-button>
    </template>
    <div v-else>未查询到用户信息，可能为非平台用户</div>

    <user-basic-details ref="userBasicDetails" />
  </div>
</template>

<script>
export default {
  components: {
    UserBasicDetails: () => import('@/pages/user/UserBasicDetails.vue')
  },
  data() {
    return {
      userInfo: null
    };
  },
  methods: {
    loadByNumber(number) {
      this.axios('/api/user/getUserByPhone?phone=' + number).then((user) => {
        this.userInfo = user;
      });
    },
    onUserDetailsClick() {
      this.$refs.userBasicDetails.show(this.userInfo);
    },
    onLocateUserClick() {
      openModuleByCode('taishitu', {
        onLoad: () => { 
          getModuleContext('taishitu').stat.deviceQuery.gotoPositionByTelephone(this.userInfo.telphone);
        }
      });
    },
    onPlaceOrderClick() {
      window.lastCallComingUserInfo = this.userInfo;
      this.pushPage({
        path: '/shop/shop/index'
      });
    },
    onCloseClick() {
      this.$emit('close');
      this.userInfo = null;
    }
  }
}
</script>


<style scoped>
>>> .el-card__header {
  padding: 10px 10px;
}
.el-row {
  font-size: 14px;
  line-height: 40px;
}
.el-col-5 {
  font-weight: 500;
}

.el-button {
  display: block;
  width: 100%;
  margin: 10px auto;
}
</style>


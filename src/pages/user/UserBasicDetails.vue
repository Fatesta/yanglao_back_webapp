<template>
  <el-dialog
    title="用户基本信息详情"
    :visible.sync="visible"
    top="5vh"
    width="600px"
  >
    <el-row>
      <el-col :span="5">昵称</el-col>
      <el-col :span="18">{{userInfo.aliasName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">姓名</el-col>
      <el-col :span="18">{{userInfo.realName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">性别</el-col>
      <el-col :span="18">{{userInfo.sex == 0 ? '男' : '女'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">生日</el-col>
      <el-col :span="18">{{userInfo.birthday}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">年龄</el-col>
      <el-col :span="18">{{userInfo.age}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">身份证号码</el-col>
      <el-col :span="18">{{userInfo.idcard}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">手机号</el-col>
      <el-col :span="18">{{userInfo.telphone}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">社区</el-col>
      <el-col :span="18">{{userInfo.orgName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">紧急联系人</el-col>
      <el-col :span="18">{{userInfo.name}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">紧急联系电话</el-col>
      <el-col :span="18">{{userInfo.contactTel}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">家庭地址</el-col>
      <el-col :span="18">{{userInfo.address}}</el-col>
    </el-row>
    <el-row v-if="userInfo.elderlyCard">
      <el-col :span="5">老年卡号</el-col>
      <el-col :span="18">{{userInfo.elderlyCard}}</el-col>
    </el-row>
    <el-row v-if="!userInfo.isvalid">
      <el-col :span="5">启用状态</el-col>
      <el-col :span="18">{{userInfo.isvalid ? '启用' : '禁用'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">用户类型</el-col>
      <el-col :span="18">{{DictMan.itemMap('user.type')[userInfo.userType]}}</el-col>
    </el-row>
    <el-row v-if="userInfo.userType == 2">
      <el-col :span="5">卡号</el-col>
      <el-col :span="18">{{userInfo.deviceCode}}</el-col>
    </el-row>
    <el-row v-if="userInfo.userType == 9">
      <el-col :span="5">设备号</el-col>
      <el-col :span="18">{{userInfo.deviceCode}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">备注</el-col>
      <el-col :span="18">{{userInfo.remark}}</el-col>
    </el-row>
  </el-dialog>
</template>

<script>
export default {
  pageProps: {
    title: '用户基本信息详情'
  },
  data() {
    return {
      visible: false,
      userInfo: {}
    };
  },
  methods: {
    async show(user) {
      this.visible = true;
      this.userInfo = user;
      this.userInfo = await axios.get('/api/user/getBasicInfo', {params: {userId: user.id}});
    }
  }
}
</script>


<style scoped>
.el-row {
  font-size: 14px;
  line-height: 40px;
}
.el-col-5 {
  padding-right: 16px;
  text-align: right;
  font-weight: 500;
} 
</style>

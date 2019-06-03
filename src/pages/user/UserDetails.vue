<template>
  <el-dialog
    title="用户基本信息详情"
    :visible.sync="visible"
    top="5vh"
    width="600px"
  >
    <el-row>
      <el-col :span="5">昵称</el-col>
      <el-col :span="10">{{userInfo.aliasName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">姓名</el-col>
      <el-col :span="10">{{userInfo.realName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">性别</el-col>
      <el-col :span="10">{{userInfo.sex == 0 ? '男' : '女'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">生日</el-col>
      <el-col :span="10">{{userInfo.birthday}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">年龄</el-col>
      <el-col :span="10">{{userInfo.age}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">身份证</el-col>
      <el-col :span="10">{{userInfo.idcard}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">手机号</el-col>
      <el-col :span="10">{{userInfo.telphone}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">紧急联系人</el-col>
      <el-col :span="10">{{userInfo.name}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">紧急联系电话</el-col>
      <el-col :span="10">{{userInfo.contactTel}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">家庭地址</el-col>
      <el-col :span="10">{{userInfo.address}}</el-col>
    </el-row>
    <el-row v-if="userInfo.elderlyCard">
      <el-col :span="5">老年卡号</el-col>
      <el-col :span="10">{{userInfo.elderlyCard}}</el-col>
    </el-row>
    <el-row v-if="!userInfo.isvalid">
      <el-col :span="5">启用状态</el-col>
      <el-col :span="10">{{userInfo.isvalid ? '启用' : '禁用'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">用户类型</el-col>
      <el-col :span="10">{{DictMan.itemMap('user.type')[userInfo.userType]}}</el-col>
    </el-row>
    <el-row v-if="userInfo.userType == 2">
      <el-col :span="5">卡号</el-col>
      <el-col :span="10">{{userInfo.deviceCode}}</el-col>
    </el-row>
    <el-row v-if="userInfo.userType == 9">
      <el-col :span="5">设备号</el-col>
      <el-col :span="10">{{userInfo.deviceCode}}</el-col>
    </el-row>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      userInfo: {}
    };
  },
  methods: {
    show(user) {
      this.visible = true;
      this.userInfo = user;
    }
  }
}
</script>


<style scoped>
.el-row {
  line-height: 40px;
}
.el-col-5 {
  padding-right: 16px;
  text-align: right;
  font-weight: 500;
} 
</style>

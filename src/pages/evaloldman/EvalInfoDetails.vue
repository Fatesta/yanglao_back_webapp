<template>
  <el-drawer
    :title="`${evalInfo.name} 详情`"
    :visible.sync="visible"
    direction="rtl"
    :modal="false"
    size="560px"
  >
    <el-row>
      <el-col :span="6">姓名</el-col>
      <el-col :span="18">{{evalInfo.name}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">年龄</el-col>
      <el-col :span="18">{{evalInfo.age}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">身份证号码</el-col>
      <el-col :span="18">{{evalInfo.idcard}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">联系电话</el-col>
      <el-col :span="18">{{evalInfo.phone}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">所在社区</el-col>
      <el-col :span="18">{{evalInfo.communityName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">居住街道</el-col>
      <el-col :span="18">{{evalInfo.street}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">居住地址</el-col>
      <el-col :span="18">{{evalInfo.address}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">申请对象类型</el-col>
      <el-col :span="18">{{evalInfo.applyTypesText}}</el-col>
    </el-row>
    <el-row style="margin-top: 8px">
      <el-col :span="6">代理人姓名</el-col>
      <el-col :span="18">{{evalInfo.agentName}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">与代理人关系</el-col>
      <el-col :span="18">{{evalInfo.agentRelation}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">代理人联系电话</el-col>
      <el-col :span="18">{{evalInfo.agentPhone}}</el-col>
    </el-row>
    <el-row style="margin-top: 8px">
      <el-col :span="6">评估机构</el-col>
      <el-col :span="18">{{evalInfo.institutions}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">疾病诊断类别</el-col>
      <el-col :span="18">{{evalInfo.diseases}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">评估分数</el-col>
      <el-col :span="18">{{evalInfo.evalScore}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="6">拟享受市补贴</el-col>
      <el-col :span="18">{{evalInfo.allowanceMoney}}</el-col>
    </el-row>
    <el-row style="margin-top: 8px">
      <el-col :span="6">养老需求</el-col>
      <el-col :span="18">{{evalInfo.needsText}}</el-col>
    </el-row>
  </el-drawer>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      evalInfo: {}
    };
  },
  methods: {
    show(evalInfo) {
      this.visible = true;
      this.evalInfo = evalInfo;
    }
  }
}
</script>


<style scoped>
.el-row {
  font-size: 14px;
  line-height: 40px;
}
.el-col-6 {
  padding-right: 16px;
  text-align: right;
  color: #606266;
} 
</style>

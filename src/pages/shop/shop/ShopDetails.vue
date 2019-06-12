<template>
  <el-dialog
    title="店铺信息详情"
    :visible.sync="visible"
    top="5vh"
    width="600px"
  >
    <el-row>
      <el-col :span="5">店铺图片</el-col>
      <el-col :span="18"><img :src="shopInfo.imgUrl" style="height: 50px;width: 80px;border-radius: 4px;"/></el-col>
    </el-row>
    <el-row>
      <el-col :span="5">店铺名称</el-col>
      <el-col :span="18">{{shopInfo.name}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">店铺描述</el-col>
      <el-col :span="18">{{shopInfo.description}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">所属行业</el-col>
      <el-col :span="18">{{shopInfo.industryText}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">店铺地址</el-col>
      <el-col :span="18">{{shopInfo.fullAddress}}</el-col>
    </el-row>
    <el-row v-if="shopInfo.orgId == -1">
      <el-col :span="5">服务社区</el-col>
      <el-col :span="18">
        <span v-if="shopInfo.orgId == -1">无限制</span>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="5">服务范围</el-col>
      <el-col :span="18">{{shopInfo.serviceArea == 0 ? '无限制' : shopInfo.serviceArea + '米'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">营业时间</el-col>
      <el-col :span="18">{{shopInfo.serviceTime}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">派单模式</el-col>
      <el-col :span="18">{{shopInfo.businessMode ? '是' : '否'}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">联系人</el-col>
      <el-col :span="18">{{shopInfo.linkman}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">联系电话</el-col>
      <el-col :span="18">{{shopInfo.telephone}}</el-col>
    </el-row>
    <el-row>
      <el-col :span="5">商家工号</el-col>
      <el-col :span="18">{{shopInfo.adminUsername}}</el-col>
    </el-row>
  </el-dialog>
</template>


<script>
export default {
  data() {
    return {
      visible: false,
      shopInfo: {}
    };
  },
  methods: {
    show(shopInfo) {
      this.visible = true;
      this.shopInfo = shopInfo;
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

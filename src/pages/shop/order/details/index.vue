

<template>
    <el-card shadow="never">
      <el-row type="flex" justify="center">
        <el-col :span="24">
          <h1>工单详情</h1>
          <table class="order-info">
            <tr>
              <th>工单号：</th>
              <td>{{orderInfo.orderno}}</td>
              <th>工单状态：</th>
              <td>{{orderInfo.status}}</td>
            </tr>
            <tr>
              <th>联系人：</th>
              <td>{{orderInfo.linkman}}</td>
				      <th>联系电话：</th>
				      <td>{{orderInfo.linkphone}}</td>
            </tr>
            <tr>
              <th>下单人：</th>
              <td>{{orderInfo.creatorName}}</td>
              <th>下单时间：</th>
              <td>{{orderInfo.createTime}}</td>
            </tr>
            <tr>
              <th>工单地址：</th>
              <td colspan="3">{{orderInfo.address}}</td>
            </tr>
            <tr>
              <th>商家店铺：</th>
              <td colspan="3">{{orderInfo.providerName}}</td>
            </tr>
            <tr>
              <th>备注：</th>
              <td colspan="3">{{orderInfo.remark}}</td>
            </tr>
          </table>
        </el-col>
      </el-row>
    </el-card>
</template>

<script>
export default {
  data() {
    return {
      orderInfo: {}
    }
  }
}
</script>

<style scoped>
  .order-info {
    width: 200px
  }
</style>
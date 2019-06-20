<template>
  <el-card shadow="never">
    <section style="margin-top: -20px">
      <div class="order-operations" v-if="[1,2,4,9,14].includes(app.admin.roleId)">
        <el-button
          v-if="
            ['housekeeping'].includes($params.order.industryId)
            && ($params.order.status >= 13
            && $params.order.status != 16
            && !$params.order.startFlowTime)"
          type="primary"
          round
          @click="onFlowStartClick"
        >
          开始
        </el-button>
        <el-button
          v-else-if="
            ['housekeeping', 'catering'].includes($params.order.industryId)
            && ($params.order.status >= 13
            && $params.order.status != 16
            && !$params.order.endFlowTime)"
          type="success"
          round
          @click="onFlowFinishClick"
        >
          完成
        </el-button>
        <el-button
          v-else-if="
            ['housekeeping', 'catering'].includes($params.order.industryId)
            && ($params.order.status == 15 && $params.order.starLevel == null)"
          type="primary"
          plain
          round
          @click="onCommentClick"
        >
          评价
        </el-button>
        
        <el-button
          v-if="['housekeeping', 'catering'].includes($params.order.industryId)
            && [10, 12, 13, 14].includes($params.order.status)"
          type="warning"
          plain
          round
          @click="onCancelClick"
        >
          取消
        </el-button>
        <el-tooltip content="修改" placement="bottom">
          <el-button
            type="danger"
            plain
            circle
            icon="el-icon-edit"
            @click="onEditClick"
          />
        </el-tooltip>
        <el-tooltip content="删除" placement="bottom">
          <el-button
            v-if="$params.order.payStatus == 0"
            type="danger"
            plain
            circle
            icon="el-icon-delete"
            @click="onDeleteClick"
          />
        </el-tooltip>
      </div>
      <h1>
        <span style="margin-right: 8px;">{{orderOutName}}号：{{orderInfo.orderno}}</span>
        <template v-if="$params.type != 'service'">
          <el-tag size="big" :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[$params.order.status]">
            {{DictMan.itemMap('productOrder.status')[$params.order.status]}}
          </el-tag>
        </template>
        <template v-else>
          <el-tag size="big" :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[$params.order.status]">
            {{$params.orderStatusText}}
          </el-tag>
        </template>
      </h1>
      <table class="info-table">
        <tr>
          <th>商家店铺：</th>
          <td colspan="3">{{orderInfo.providerName}}</td>
        </tr>
        <tr>
          <th>工单地址：</th>
          <td colspan="3">{{orderInfo.address}}</td>
        </tr>
        <tr>
          <th>{{orderOutName}}备注：</th>
          <td colspan="3">{{orderInfo.remark}}</td>
        </tr>
      </table>
      <table class="info-table">
        <tr>
          <th>联系人：</th>
          <td>{{orderInfo.linkman}}</td>
        </tr>
        <tr>
          <th>联系电话：</th>
          <td>{{orderInfo.linkphone}}</td>
        </tr>
      </table>
    </section>
    <section>
      <h1>{{orderOutName}}商品</h1>
      <el-table
        :data="orderProducts"
        size="medium"
        v-loading="loadings.orderProducts"
      >
        <el-table-column prop="imageFile" width="100" label="商品">
          <template slot-scope="scope">
            <img :src="scope.row.imageFile" style="height: 50px;width: 80px;border-radius: 4px;" />
          </template>
        </el-table-column>
        <el-table-column prop="productName" width="300"></el-table-column>
        <el-table-column prop="price" width="200" label="单价" :formatter="(row, col, val) => '¥' + val"></el-table-column>
        <el-table-column prop="quantity" label="商品数量"></el-table-column>
      </el-table>
      <div
        style="
          float: right;
          position: relative;
          right: 8px;
          margin-top: 8px;
          font-size: 13px;
        ">
        <table>
          <tr>
            <td>商品总额：</td>
            <td style="font-size: 16px;">¥{{orderInfo.totalFee}}</td>
          </tr>
        </table>
      </div>
    </section>
    <section>
      <h1>{{orderOutName}}过程</h1>
      <el-timeline>
        <el-timeline-item
          v-if="orderFlowInfo.orderEndTime"
          :timestamp="orderFlowInfo.orderEndTime.substring(0, 19)"
          placement="top"
          color="#67C23A"
        >
          <el-card>
            <h4>完成服务</h4>
            <p>【{{orderFlowInfo.orderEndOperator}}】完成服务<template v-if="orderFlowInfo.orderEndAddress">于位置【{{orderFlowInfo.orderEndAddress}}】</template></p>
            <template v-if="orderFlowInfo.orderEndImage">
              <el-image
                v-for="(url, index) in orderFlowInfo.orderEndImage.split(',')"
                :key="index"
                :src="url"
                class="order-flow-image"
                @click="viewImage(url)"
              />
            </template>
            <p>备注：{{orderFlowInfo.orderEndRemark}}</p>
            <audio :src="orderFlowInfo.voiceFile" controls style="vertical-align: middle;"></audio>
          </el-card>
        </el-timeline-item>
        <el-timeline-item
          v-if="orderFlowInfo.orderStartTime"
          :timestamp="orderFlowInfo.orderStartTime.substring(0, 19)"
          placement="top"
          color="#409EFF"
        >
          <el-card>
            <h4>开始服务</h4>
            <p>【{{orderFlowInfo.orderStartOperator}}】开始服务<template v-if="orderFlowInfo.orderStartAddress">于位置【{{orderFlowInfo.orderStartAddress}}】</template></p>
            <template v-if="orderFlowInfo.orderStartImage">
              <el-image
                v-for="(url, index) in orderFlowInfo.orderStartImage.split(',')"
                :key="index"
                :src="url"
                class="order-flow-image"
                @click="viewImage(url)"
              />
            </template>
            <p>备注：{{orderFlowInfo.orderStartRemark}}</p>
          </el-card>
        </el-timeline-item>
        <el-timeline-item
          :timestamp="orderInfo.createTime"
          placement="top"
        >
          <el-card>
            <h4>下单</h4>
            <p>【{{orderInfo.creatorName}}】提交了订单。</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </section>
    <section>
      <h1>{{orderOutName}}评价</h1>
      <table class="info-table">
        <tr>
          <th>分数评价：</th>
          <td colspan="3"><el-rate v-model="orderFlowInfo.starLevel" disabled/></td>
        </tr>
        <tr>
          <th>文字评价：</th>
          <td colspan="3" style="height: 40px;word-break: break-all;">{{orderFlowInfo.appraiseMessage}}</td>
        </tr>
      </table>
    </section>

    <start-form ref="startForm" />
    <finish-form ref="finishForm" />
    <comment ref="comment" />
  </el-card>
</template>

<script>
import StartForm from '../flow/StartForm.vue';
import FinishForm from '../flow/FinishForm.vue';
import Comment from '../flow/Comment.vue';

export default {
  _pageProps: {
    title: '订单详情'
  },
  components: {
    StartForm,
    FinishForm,
    Comment
  },
  data() {
    return {
      orderOutName: this.$params.type == 'service' ? '工单' : '订单',
      orderInfo: this.$params.order,
      orderFlowInfo: {},
      orderProducts: [],
      loadings: {
        orderProducts: true
      },
      app
    }
  },
  methods: {
    viewImage(url) {
      window.open(url);
    },
    onFlowStartClick() {
      const { order } = this.$params;
      this.$refs.startForm.show({
        order,
        onSuccess: () => {
          order.startFlowTime = 1;
        }
      })
    },
    onFlowFinishClick() {
      const { order } = this.$params;
      this.$refs.finishForm.show({
        order,
        onSuccess: () => {
          order.endFlowTime = 1;
        }
      })
    },
    onCommentClick() {
      const { order } = this.$params;
      this.$refs.comment.show({
        order,
        onSuccess: (form) => {
          order.starLevel = form.starLevel;
        }
      });
    },
    onCancelClick() {
      const { order } = this.$params;
      this.$confirm(`确认取消订单 ${order.orderno} ？`, {
        type: 'warning'
      }).then(async () => {
         const ret = await axios.post('/api/shop/order/cancel', {
           orderno: order.orderno,
           creator: order.creator,
           operator: ''
         });
         if (ret.success) {
           this.$message.success('取消订单成功');
           order.status = 16;
         }
      });
    },
    onEditClick() {
      this.$alert('开发中');
    },
    onDeleteClick() {
      const orderCode = this.$params.order.orderno;
      this.$confirm(`确认删除订单 ${orderCode} ？`, {
        type: 'warning'
      }).then(async () => {
         const ret = await axios.post('/api/shop/order/delete', {
           orderno: orderCode
         });
         if (ret.success) {
           this.$message.success('删除订单成功');
         }
      });
    }
  },
  async mounted() {
    const orderCode = this.$params.order.orderno;
    // TODO：合并请求为一个
    this.orderProducts = (await axios.get('/api/shop/order/orderDetailPage', {params: {orderno: orderCode}})).rows;
    this.loadings.orderProducts = false;
    this.orderInfo = await axios.get('/api/shop/order/detail',  {params: { orderCode }});
    this.orderFlowInfo = await axios.get('/api/shop/order/orderFlowInfo', {params: { orderCode }});
  }
}
</script>

<style scoped>
section {
  position: relative;
  width: 80%;
  margin: 32px auto;
}
section > h1 {
  margin-bottom: 8px;
}

.order-operations {
  float: right;
}

.order-flow-image {
  width: 100px;
  height: 100px;
  margin-right: 8px;
  cursor: pointer;
}
.info-table {
  width: 100%;
}
.info-table th {
  text-align: left;
  font-size: 13px;
  width: 80px;
  padding: 4px;
}
.info-table td {
  text-align: left;
  padding: 5px;
  font-size: 13px;
  line-height: 25px;
}
</style>
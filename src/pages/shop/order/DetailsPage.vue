<template>
  <plain-page
    style="width: 90%;margin: 4px auto;"
  >
    <el-card shadow="never"
        :style="{
          'border-top': '2px solid',
          'border-top-color': {10: '#409EFF', 12: '#E6A23C', 13: '#E6A23C', 14: '#E6A23C', 15: '#67C23A', 16: '#F56C6C'}[orderInfo.status]
        }"
        class="section"
      >
        <div>
        <span style="margin-right: 16px;">{{orderOutName}}&nbsp;{{orderInfo.orderno}}</span>
        <template v-if="$params.type != 'service'">
          <el-tag size="large" :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[orderInfo.status]">
            {{DictMan.itemMap('productOrder.status')[orderInfo.status] }}
          </el-tag>
        </template>
        <template v-else>
          <el-tag size="large" :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[orderInfo.status]">
            {{$params.statusMap[orderInfo.status]}}
          </el-tag>
        </template>

        <div class="order-operations" v-if="[1,2,4,9,14].includes(app.admin.roleId)">
          <el-button
            v-if="
              ['housekeeping'].includes(orderInfo.industryId)
              && (orderInfo.status >= 13
              && orderInfo.status != 16
              && !loadings.orderFlowInfo
              && !orderFlowInfo.orderStartTime)"
            type="primary"
            round
            @click="onFlowStartClick"
          >
            开始
          </el-button>
          <el-button
            v-else-if="
              ['housekeeping', 'catering'].includes(orderInfo.industryId)
              && (orderInfo.status >= 13
              && orderInfo.status != 16
              && !loadings.orderFlowInfo
              && !orderFlowInfo.orderEndTime)"
            type="success"
            round
            @click="onFlowFinishClick"
          >
            完成
          </el-button>
          <el-button
            v-else-if="
              ['housekeeping', 'catering'].includes(orderInfo.industryId)
              && (orderInfo.status == 15 && !loadings.orderFlowInfo && !orderFlowInfo.starLevel)"
            type="primary"
            plain
            round
            @click="onCommentClick"
          >
            评价
          </el-button>
          
          <el-button
            v-if="['housekeeping', 'catering'].includes(orderInfo.industryId)
              && [10, 12, 13, 14].includes(orderInfo.status)"
            type="warning"
            plain
            round
            @click="onCancelClick"
          >
            取消
          </el-button>
          <el-tooltip content="修正订单信息">
            <el-dropdown placement="bottom-start" trigger="click" @command="onOrderModifyCommand">
              <el-button
                type="danger"
                plain
                circle
                icon="el-icon-edit"
              />
              <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item v-if="orderFlowInfo.orderStartTime" command="flow-start">订单过程-开始</el-dropdown-item>
                  <el-dropdown-item v-if="orderFlowInfo.orderEndTime" command="flow-finish">订单过程-完成</el-dropdown-item>
                  <el-dropdown-item command="remark">订单备注</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </el-tooltip>
          <el-tooltip content="删除订单">
            <el-button
              v-if="orderInfo.status == 16"
              type="danger"
              plain
              circle
              icon="el-icon-delete"
              @click="onDeleteClick"
            />
          </el-tooltip>
        </div>
      </div>
    </el-card>
    <el-card shadow="never" body-style="padding: 10px 20px;" class="section">
      <table class="info-table">
        <tr>
          <th>支付状态：</th>
          <td colspan="3">
            <el-tag size="medium" :type="['warning', 'success'][orderInfo.payStatus]">
              {{orderInfo.payStatusText || DictMan.itemMap('payStatus')[orderInfo.payStatus]}}
            </el-tag>
          </td>
        </tr>
        <tr>
          <th>{{orderOutName}}金额：</th>
          <td colspan="3">
            {{orderInfo.paymentFee > 0 ? `¥${orderInfo.paymentFee}` : '免费'}}
          </td>
        </tr>
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
          <td colspan="3" v-html="(orderInfo.remark && orderInfo.remark.split('\n').join('<br>')) || '无'"></td>
        </tr>
      </table>
      <table class="info-table">
        <tr>
          <th>联系人：</th>
          <td>{{orderInfo.linkman}}，{{orderInfo.linkphone}}</td>
        </tr>
      </table>
    </el-card>
    <el-card shadow="never" body-style="padding: 10px 20px;" class="section">
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
          margin-bottom: 10px;
          font-size: 14px;
        ">
        <table>
          <tr>
            <td>商品总额：</td>
            <td>¥{{orderInfo.paymentFee}}</td>
          </tr>
        </table>
      </div>
    </el-card>
    <el-card shadow="never" class="section">
      <el-timeline style="padding-inline-start: 4px;">
        <el-timeline-item
          v-if="orderFlowInfo.orderEndTime"
          :timestamp="orderFlowInfo.orderEndTime.substring(0, 19)"
          placement="top"
          color="#67C23A"
        >
          <el-card shadow="never" body-style="padding:0px 20px">
            <h4>完成服务</h4>
            <p>【{{orderFlowInfo.orderEndOperator}}】完成服务<template v-if="orderFlowInfo.orderEndAddress">于位置【{{orderFlowInfo.orderEndAddress}}】</template></p>
            <template v-if="orderFlowInfo.orderEndImage">
              <el-image
                v-for="(url, index) in orderFlowInfo.orderEndImage.split(',')"
                :key="index"
                :src="url"
                fit="cover"
                :preview-src-list="previewSrcs(orderFlowInfo.orderEndImage, index)"
                class="order-flow-image"
              />
            </template>
            <p>备注：{{orderFlowInfo.orderEndRemark}}</p>
            <audio v-if="orderFlowInfo.voiceFile" :src="orderFlowInfo.voiceFile" controls style="vertical-align: middle;"></audio>
          </el-card>
        </el-timeline-item>
        <el-timeline-item
          v-if="orderFlowInfo.orderStartTime"
          :timestamp="orderFlowInfo.orderStartTime.substring(0, 19)"
          placement="top"
          color="#409EFF"
        >
          <el-card shadow="never" body-style="padding:0px 20px">
            <h4>开始服务</h4>
            <p>【{{orderFlowInfo.orderStartOperator}}】开始服务<template v-if="orderFlowInfo.orderStartAddress">于位置【{{orderFlowInfo.orderStartAddress}}】</template></p>
            <template v-if="orderFlowInfo.orderStartImage">
              <el-image
                v-for="(url, index) in orderFlowInfo.orderStartImage.split(',')"
                :key="index"
                :src="url"
                fit="cover"
                :preview-src-list="previewSrcs(orderFlowInfo.orderStartImage, index)"
                class="order-flow-image"
              />
            </template>
            <p>备注：{{orderFlowInfo.orderStartRemark}}</p>
          </el-card>
        </el-timeline-item>
        <el-timeline-item
          :timestamp="orderInfo.createTime"
          placement="top"
        >
          <el-card shadow="never" body-style="padding:0px 20px">
            <h4>下单</h4>
            <p>【{{orderInfo.creatorName}}】提交了订单。</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-card>
    <el-card shadow="never" body-style="padding: 10px 20px;" class="section">
      <template slot="header">{{orderOutName}}评价</template>
      <table class="info-table">
        <tr>
          <th>分数评价：</th>
          <td colspan="3">
            <el-rate v-model="orderFlowInfo.starLevel" disabled style="display:inline-block" />
            <template v-if="isNaN(parseInt(orderFlowInfo.starLevel))">（未评价）</template>
          </td>
        </tr>
        <tr>
          <th>文字评价：</th>
          <td colspan="3" style="height: 40px;word-break: break-all;">{{orderFlowInfo.appraiseMessage}}</td>
        </tr>
      </table>
    </el-card>

    <start-form ref="startForm" />
    <finish-form ref="finishForm" />
    <comment ref="comment" />
  </plain-page>
</template>

<script>
export default {
  pageProps: {
    title: '订单详情'
  },
  components: {
    StartForm: () => import('./flow/StartForm.vue'),
    FinishForm: () => import('./flow/FinishForm.vue'),
    Comment: () => import('./flow/Comment.vue')
  },
  data() {
    return {
      orderOutName: this.$params.type == 'service' ? '工单' : '订单',
      orderInfo: this.$params.order,
      orderFlowInfo: {},
      orderProducts: [],
      loadings: {
        orderFlowInfo: true,
        orderProducts: true
      },
      app
    }
  },
  mounted() {
    const orderCode = this.orderInfo.orderno;
    if (typeof this.$params.order.status == 'undefined') {//没有传递过来完整的订单实体，则查询
      this.axios.get('/api/shop/order/detail', {params: { orderCode: this.$params.order.orderno }})
        .then(ret => {
          Object.assign(this.orderInfo, ret);
        });
    }
    this.axios.get('/api/shop/order/orderDetailPage', {params: {orderno: orderCode}})
      .then(page => {
        this.orderProducts = page.rows;
        this.loadings.orderProducts = false;
      });
    this.axios.get('/api/shop/order/orderFlowInfo', {params: { orderCode }})
      .then(ret => {
        this.orderFlowInfo = ret;
        this.loadings.orderFlowInfo = false;
      });
  },
  methods: {
    onFlowStartClick() {
      const { order } = this.$params;
      this.$refs.startForm.show({
        order,
        onSuccess: () => {
          order.startFlowTime = 1;
          this.refreshOrderFlowInfo();
        }
      });
    },
    onFlowFinishClick() {
      const { order } = this.$params;
      this.$refs.finishForm.show({
        order,
        onSuccess: () => {
          order.endFlowTime = 1;
          this.refreshOrderFlowInfo();
        }
      });
    },
    onCommentClick() {
      const { order } = this.$params;
      this.$refs.comment.show({
        order,
        onSuccess: (form) => {
          order.starLevel = form.starLevel;
          this.refreshOrderFlowInfo();
        }
      });
    },
    onCancelClick() {
      const { order } = this.$params;
      this.$confirm(`确认取消订单 ${order.orderno} ？`, {
        type: 'warning'
      }).then(async () => {
         const ret = await this.axios.post('/api/shop/order/cancel', {
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
    onOrderModifyCommand(cmd) {
      const { order } = this.$params;
      switch (cmd) {
        case 'flow-start':
          this.$refs.startForm.show({
            order,
            mode: 'update',
            onSuccess: () => {
              this.refreshOrderFlowInfo();
            }
          });
          break;
        case 'flow-finish':
          this.$refs.finishForm.show({
            order,
            mode: 'update',
            onSuccess: () => {
              this.refreshOrderFlowInfo();
            }
          });
          break;
        case 'remark':
          this.$prompt(null, '修改订单备注', {inputType: 'textarea', inputValue: order.remark, rows: 4}).then(async ({action, value}) => {
            if ('confirm' == action) {
              const ret = await this.axios.post('/api/shop/order/update',
                {orderno: order.orderno, remark: value});
              if (ret.success) {
                this.$message.success('修改成功');
                this.orderInfo.remark = order.remark = value;
              }
            }
          });
          break;
      }
    },
    onDeleteClick() {
      const orderCode = this.orderInfo.orderno;
      this.$confirm(`确认删除订单 ${orderCode} ？`, {
        type: 'warning'
      }).then(async () => {
         const ret = await this.axios.post('/api/shop/order/delete', {
           orderno: orderCode
         });
         if (ret.success) {
           this.$message.success('删除订单成功');
           this.$params.onDeleteSuccess && this.$params.onDeleteSuccess();
         }
      });
    },
    async refreshOrderFlowInfo() {
      this.orderFlowInfo = await this.axios.get('/api/shop/order/orderFlowInfo',
        {params: { orderCode: this.orderInfo.orderno }});
    },
    previewSrcs(srcCsv, index) {
      const srcs = srcCsv.split(',');
      return srcs.slice(index).concat(srcs.slice(0, index));
    }
  }
}
</script>

<style scoped>
.section {
  position: relative;
  margin-top: 4px;
}
.section >>> .el-card__header {
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
  border-radius: 4px;
}
.info-table {
  width: 100%;
}
.info-table th {
  text-align: left;
  font-size: 14px;
  width: 70px;
  padding-right: 20px;
  font-weight: normal;
}
.info-table td {
  text-align: left;
  padding: 5px;
  font-size: 14px;
  line-height: 25px;
}
</style>
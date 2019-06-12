<template>
  <data-table-app-page>
    <div style="padding-bottom: 8px">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="订单号">
          <el-input v-model="searchForm.orderno" clearable style="width: 190px"></el-input>
        </el-form-item>
        <el-form-item label="订单状态">
          <type-select
            v-model="searchForm.status"
            :items="DictMan.items('productOrder.status')"
            style="width: 130px"
          />
        </el-form-item>
        <el-form-item label="支付状态">
          <type-select
            v-model="searchForm.payStatus"
            :items="DictMan.items('payStatus')"
            style="width: 110px"
          />
        </el-form-item>
        <el-form-item label="支付方式">
          <type-select
            v-model="searchForm.payType"
            :items="DictMan.items('payType')"
            style="width: 110px"
          />
        </el-form-item>
        <el-form-item label="下单日期">
          <el-date-picker
            v-model="searchForm.startCreateTime"
            value-format="yyyy-MM-dd"
            align="right"
            type="date"
            placeholder="选择日期"
            style="width: 140px">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <data-table-query-button
            :query-params="() => ({
              ...searchForm,
              ...(searchForm.startCreateTime ? {
                  startCreateTime: searchForm.startCreateTime + ' 00:00:00',
                  endCreateTime: searchForm.startCreateTime + ' 23:59:59'
                } : {})
            })" />
        </el-form-item>
      </el-form>
      <el-button
        v-if="this.$params.shop.industryId != 'activity' && [1,2,4,9,14].includes(app.admin.roleId)"
        type="primary"
       
        icon="el-icon-plus"
        @click="onAddClick"
      >
        下单
      </el-button>
    </div>
    <data-table
      ref="table"
      url="/api/shop/order/orderPage"
      lazy
    >
      <el-table-column prop="orderno" label="订单号" width="190"></el-table-column>
      <el-table-column prop="status" label="订单状态" width="120">
        <template slot-scope="scope">
          <el-tag :type="{12: 'warning', 13: 'warning', 14: 'warning', 15: 'success', 16: 'danger'}[scope.row.status]">
            {{DictMan.itemMap('productOrder.status')[scope.row.status]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="paymentFee" label="金额" width="70"></el-table-column>
      <el-table-column prop="payStatus" label="支付状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="['warning', 'success'][scope.row.payStatus]">
            {{DictMan.itemMap('payStatus')[scope.row.payStatus]}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="payType" label="支付方式" width="120" :formatter="formatters.payType"></el-table-column>
      <el-table-column prop="linkman" label="下单人" width="120"></el-table-column>
      <el-table-column prop="linkphone" label="联系电话" width="140"></el-table-column>
      <el-table-column prop="createTime" label="下单时间" width="170"></el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template slot-scope="scope">
          <el-button
            @click="onDetailsClick(scope.row)">
            详情
          </el-button>

          <el-button
            v-if="scope.row.industryId == 'housekeeping' && scope.row.status == 10"
            type="primary"
            plain
            @click="onTakingClick(scope.row)"
            style="margin-left: 0px"
          >
            {{$params.shop.businessMode == 0 ? '接单' : '派单'}}
          </el-button>
          <el-button
            v-else-if="scope.row.industryId == 'housekeeping' &&
              (scope.row.status >= 13 && !scope.row.startFlowTime)"
            type="warning"
            plain
            @click="onFlowStartClick(scope.row)"
            style="margin-left: 0px"
          >
            开始
          </el-button>
          <el-button
            v-else-if="scope.row.industryId == 'housekeeping' &&
              (scope.row.status >= 13 && !scope.row.endFlowTime)"
            type="success"
            plain
            @click="onFlowFinishClick(scope.row)"
            style="margin-left: 0px"
          >
            完成
          </el-button>
          <el-button
            v-else-if="scope.row.industryId == 'housekeeping' &&
              (scope.row.status == 15 && scope.row.starLevel == null)"
            type="primary"
            plain
            @click="onCommentClick(scope.row)"
            style="margin-left: 0px"
          >
            评价
          </el-button>
          <el-button
            v-if="scope.row.industryId == 'housekeeping' && [10, 12, 13, 14].includes(scope.row.status)"
            type="danger"
            plain
            @click="onCancelClick(scope.row)"
            style="margin-left: 0px"
          >
            取消
          </el-button>
        </template>
      </el-table-column>
    </data-table>

    <employee-query-selector ref="employeeQuerySelector" />
    <start-form ref="startForm" />
    <finish-form ref="finishForm" />
    <comment ref="comment" />

  </data-table-app-page>
</template>

<script>
import EmployeeQuerySelector from '../EmployeeQuerySelector.vue';
import StartForm from './flow/StartForm.vue';
import FinishForm from './flow/FinishForm.vue';
import Comment from './flow/Comment.vue';

export default {
  components: {
    EmployeeQuerySelector,
    StartForm,
    FinishForm,
    Comment
  },
  data() {
    return {
      formatters: {
        payType: (row, col, val) => DictMan.itemMap('payType')[val]
      },
      searchForm: {
        providerId: this.$params.shop.providerId
      },
      app
    }
  },
  methods: {
    onAddClick(order) {
      const { shop } = this.$params;
      
      if (shop.industryId == 'housekeeping') {
        app.pushPage({
          path: '/shop/order/flow/place/index',
          params: {
            shop,
            orderTable: this.$refs.table
          },
          title: shop.name + ' - 下单'
        });
      } else {
        openTab({
          url: "/shop/order/orderAdd.do?providerId=" + shop.providerId,
          title: shop.name + " - 下单"
        });
      }
    },
    onDetailsClick(order) {
      openTab({
        title: '订单详情 - ' + order.orderno,
        url: '/view/shop/workOrder/orderDetail.do?orderCode=' + order.orderno
      });
    },
    onTakingClick(order) {
      const submit = async (handler) => {
        const ret = await axios.post(
          '/api/shop/order/housekeeping/taking',
          {
            orderno: order.orderno,
            creator: order.creator,
            operator: this.$params.shop.adminId,
            handler: handler || this.$params.shop.adminId
          });
        if (ret.success) {
          order.status = 13;
          this.$message.success((this.$params.shop.businessMode == 0 ? '接单' : '派单') + '成功');
        } else {
          this.$message.error(ret.message);
        }
      };

      if (this.$params.shop.businessMode == 1) {
        this.$refs.employeeQuerySelector.show({
          title: '指派订单服务人员',
          queryParams: {
            providerId: order.providerId
          },
          onOk: (employee) => {
            submit(employee.adminId);
          }
        });
      } else {
        submit();
      }
    },
    onFlowStartClick(order) {
      this.$refs.startForm.show({
        order,
        onSuccess: () => {
          order.startFlowTime = 1;
        }
      })
    },
    onFlowFinishClick(order) {
      this.$refs.finishForm.show({
        order,
        onSuccess: () => {
          order.endFlowTime = 1;
        }
      })
    },
    onCommentClick(order) {
      this.$refs.comment.show({
        order,
        onSuccess: (form) => {
          order.starLevel = form.starLevel;
        }
      });
    },
    onCancelClick(order) {
      this.$confirm(`确认取消订单 ${order.orderno} ？`, {
        type: 'warning'
      }).then(async () => {
         const ret = await axios.post('/api/shop/order/housekeeping/cancel', {
           orderno: order.orderno,
           creator: order.creator,
           operator: ''
         });
         if (ret.success) {
           this.$message.success('取消订单成功');
           order.status = 16;
         }
      });
    } 
  },
  mounted() {
    this.$refs.table.query(this.searchForm);
  }
}
</script>
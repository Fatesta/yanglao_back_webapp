<template>
  <div style="padding: 8px;">
    <el-button
      type="text"
      icon="el-icon-back"
      size="small"
      style="font-size: 24px"
      @click="placeFollow.back"
    />
    <el-card shadow="never">
      <el-row>
        <el-col :span="24">
          <el-form ref="userInfoForm" :model="form"
            label-width="100px"
            label-position="left"
            size="small"
            style="margin-top: 8px;">
            <el-form-item
              label="用户"
              :rules="[{required: true}]">
              <el-button type="primary" icon="el-icon-user" size="mini" plain @click="onSelectUserClick">选择用户</el-button>
              <template v-if="user">
                <el-row>
                  <el-col :span="8">平台用户：{{user.aliasName}}</el-col>
                </el-row>
                <el-row>
                  <el-col :span="8">身份证号：{{user.idcard}}</el-col>
                </el-row>
                <el-row>
                  <el-col :span="8">联系电话：{{user.telphone}}</el-col>
                </el-row>
              </template>
            </el-form-item>
            <el-form-item
              prop="linkman"
              label="联系人"
              :rules="[{required: true, message: ' '}]">
              <el-input v-model="form.linkman" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item
              prop="linkphone"
              label="联系电话"
              :rules="[{required: true, message: ' '}]">
              <el-input v-model="form.linkphone" style="width: 300px"></el-input>
            </el-form-item>
            <el-form-item
              prop="address"
              label="订单地址"
              :rules="[{required: true, message: ' '}]">
              <el-input type="textarea" :rows="2" v-model="form.address"  style="width: 300px"></el-input>
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
    </el-card>
    <el-card shadow="never" style="margin-top: 16px">
      <el-table :data="selections" :show-header="false">
        <el-table-column prop="product.imageFile" width="100">
          <template slot-scope="scope">
            <img :src="scope.row.product.imageFile" style="height: 50px;width: 80px;border-radius: 4px;" />
          </template>
        </el-table-column>
        <el-table-column prop="product.name" width="300"></el-table-column>
        <el-table-column prop="num" width="100" :formatter="(row, col, val) => ('x' + val)"></el-table-column>
        <el-table-column prop="product.price" width="200">
          <template slot-scope="scope">
            <span>¥&nbsp;{{scope.row.product.price}}</span>
            <el-button
              icon="el-icon-edit"
              size="small"
              @click="onEditPriceClick(scope.row.product)"
            />
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <el-card shadow="never" style="margin-top: 16px">
      <el-form
        :model="form"
        label-width="100px"
        label-position="left"
        size="small">
        <el-form-item
          prop="remark"
          label="订单备注">
          <el-input type="textarea" :rows="2" v-model="form.remark"  style="width: 300px"></el-input>
        </el-form-item>
      </el-form>
    </el-card>
    <div style="margin-top: 24px;text-align: center;">
      <el-button
        type="primary"
        size="small"
        @click="onSubmit"
        :loading="submitting"
        :disabled="submitDisabled"
        >完成下单</el-button>
    </div>

    <user-query-selector ref="userQuerySelector" />
  </div>
</template>


<script>
import UserQuerySelector from '@/pages/user/UserQuerySelector.vue';

/* 订单表单 */
export default {
  components: {
    UserQuerySelector
  },
  data() {
    return {
      form: {
        linkman: '',
        linkphone: '',
        address: '',
        remark: ''
      },
      user: null, // 选择下单用户
      submitting: false,
      submitDisabled: false,
      selections: this.$params.selections
    }
  },
  methods: {
    onSelectUserClick() {
      this.$refs.userQuerySelector.show({
        onOk: (user) => {
          if (user.userType == 0) {
            this.$alert('请优先选择 会员卡用户、老人App用户、设备用户');
            return false;
          }
          this.user = user;
          // 设置默认填写信息为选择用户的基本信息
          this.$refs.userInfoForm.resetFields();
          this.form.linkman = user.aliasName;
          this.form.linkphone = user.telphone;
          this.form.address = user.address;
          return true;
        }
      });
    },
    onEditPriceClick(product) {
      this.$prompt('修改商品在订单中的价格', {
        inputPattern: /^\d+$/
      }).then(({action, value}) => {
        if ('confirm' == action)
          product.price = value;
      });
    },
    onSubmit() {
      const { form } = this;
      // 检查是否选择了下单用户
      if (!this.user) {
        this.$message.warning('请选择下单用户');
      }
      this.$refs.userInfoForm.validate(async (valid) => {
        if (!valid) return;

        let productListJSON = JSON.stringify(this.selections.map((sel) => {
          return {
              productId: sel.product.productId.toString(),
              productName: Base64.encode(sel.product.name, true),
              price: sel.product.price,
              imageFile: sel.product.imageFile,
              quantity: "1"
          };
        }));
        let data = {
          providerId: this.$params.providerId,
          industryId: this.$params.industryId,
          creator: this.user.id,
          payType: 33,
          productListJSON,
          ...this.form,
        };
        this.submitting = true;
        const ret = await axios.post('/api/shop/order/addOrder', data);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('下单成功');
          this.submitDisabled = true;
        }
      });

    }
  }
}
</script>

<template>
  <div style="padding: 8px;width: 70%;margin: 0 auto;">
    <section>
      <el-row>
        <el-col :span="24">
          <el-form ref="userInfoForm" :model="form"
            label-width="100px"
            label-position="left"
           
            style="margin-top: 8px;">
            <el-form-item
              label="用户"
              :rules="[{required: true}]">
              <el-button type="primary" icon="el-icon-user" plain @click="onSelectUserClick">选择用户</el-button>
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
    </section>
    <section style="margin-top: 16px">
      <el-table :data="selections" size="medium" style="width:70%">
        <el-table-column prop="product.imageFile" label="商品" width="100">
          <template slot-scope="scope">
            <img :src="scope.row.product.imageFile" style="height: 50px;width: 80px;border-radius: 4px;" />
          </template>
        </el-table-column>
        <el-table-column prop="product.name" width="300"></el-table-column>
        <el-table-column prop="num" label="商品数量" width="100"></el-table-column>
        <el-table-column prop="product.price" label="单价">
          <template slot-scope="scope">
            <span>¥{{scope.row.product.price}}</span>
            <el-button
              icon="el-icon-edit"
             
              @click="onEditPriceClick(scope.row.product)"
            />
          </template>
        </el-table-column>
      </el-table>
    </section>
    <section style="margin-top: 16px">
      <el-form
        :model="form"
        label-width="100px"
        label-position="left"
       >
        <el-form-item
          prop="remark"
          label="订单备注">
          <el-input type="textarea" :rows="2" v-model="form.remark"  style="width: 300px"></el-input>
        </el-form-item>
      </el-form>
    </section>
    <section style="margin-top: 24px;">
      <el-button
        @click="placeFollow.back"
      >返回</el-button>
      <el-button
        type="primary"
        @click="onSubmit"
        :loading="submitting"
        :disabled="submitDisabled"
        >完成下单</el-button>
    </section>

    <user-query-selector ref="userQuerySelector" />
  </div>
</template>


<script>
/* 订单表单 */
export default {
  components: {
    UserQuerySelector: () => import('@/pages/user/UserQuerySelector.vue')
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
          product.price = +value;
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

        let totalPrice = 0;
        let productListJSON = JSON.stringify(this.selections.map((sel) => {
          totalPrice += sel.product.price;
          return {
              productId: sel.product.productId.toString(),
              productName: Base64.encode(sel.product.name, true),
              price: sel.product.price,
              imageFile: sel.product.imageFile,
              quantity: "1"
          };
        }));
        let data = {
          providerId: this.$params.shop.providerId,
          industryId: this.$params.shop.industryId,
          creator: this.user.id,
          payType: 33,
          productListJSON,
          totalFee: totalPrice,
          paymentFee: totalPrice,
          ...this.form,
        };
        this.submitting = true;
        const ret = await axios.post('/api/shop/order/addOrder', data);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('下单成功');
          this.submitDisabled = true;
          this.$params.orderTable.reloadCurrentPage();
        }
      });

    }
  }
}
</script>

<template>
  <el-dialog
    title="评价订单"
    :visible.sync="visible"
    :close-on-click-modal="false"
    width="600px"
  >
    <el-form ref="form" :model="form" label-width="100px">
      <el-form-item label="分数评价">
        <el-rate v-model="form.starLevel" style="position: relative;top: 4px;"></el-rate>
      </el-form-item>
      <el-form-item
        prop="remark"
        label="文字评价">
        <el-input type="textarea" :rows="3" v-model="form.feedbackMessage"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit" :loading="submitting">提交</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      form: {
        starLevel: 5
      },
      submitting: false
    }
  },
  methods: {
    async show(options) {
      const { order } = options;
      this.form = {
        orderno: order.orderno,
        operator: order.creator,
        starLevel: 5,
        feedbackMessage: ''
      };
      this.visible = true;
      this.options = options;
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) {
          return;
        }
        let postData = {...this.form};
        this.submitting = true;
        const ret = await this.axios.post('/api/shop/order/comment', postData);
        if (ret.success) {
          this.$message.success('订单评价成功');
          this.visible = false;
          this.options.onSuccess(this.form);
        } else {
          this.$message.error(ret.message);
        }
        this.submitting = false;
      });
    }
  }
}
</script>
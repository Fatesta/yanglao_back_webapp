<template>
  <el-dialog
      title="交费"
      :visible.sync="visible"
      width="400px"
    >
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 600px;margin: 0 auto"
    >
      <el-form-item
        label="床位"
      >
        <span>{{berth.berthNo}}</span>
      </el-form-item>
      <el-form-item
        label="已交金额"
      >
        {{checkinRecord.paidMoney}}
      </el-form-item>
      <el-form-item
        prop="money"
        label="本次交金额"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input-number ref="moneyInput" v-model="form.money" :precision="2" :min="0" :controls="false"></el-input-number>
      </el-form-item>
    </el-form>
    <div slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit" :loading="submitting">提交</el-button>
    </div>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      submitting: false,
      berth: {},
      checkinRecord: {},
      form: {
        checkinId: null,
        deposit: 0
      }
    };
  },
  methods: {
    async show(berth, onSuccess) {
      this.options = { onSuccess };
      this.visible = true;
      this.berth = berth;
      this.checkinRecord = await this.axios.get('/api/community/berth/checkin/checkinRecord',
        {params: {checkinId: berth.berthCheckin.id}})
      this.form = {
        checkinId: this.checkinRecord.id,
        deposit: 0
      };
      this.$refs.moneyInput.select();
    },
    async onSubmit(value) {
      this.submitting = true;
      const success = await this.axios.post('/api/community/berth/checkin/payMoney', this.form);
      this.submitting = false;
      if (success) {
        this.$message.success('交费成功');
        this.options.onSuccess();
        setTimeout(() => {
          this.visible = false;
        }, 100);
      }
    }
  }
}
</script>


<!--
增加用户
-->
<template>
  <el-dialog
    title="更换会员卡"
    :visible.sync="visible"
    :close-on-click-modal="false"
    width="460px"
  >
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
     
      style="width: 400px;"
    >
      <el-form-item label="昵称">
        {{userInfo.aliasName}}
      </el-form-item>
      <el-form-item label="身份证号">
        {{userInfo.idcard}}
      </el-form-item>
      <el-form-item label="手机号">
        {{userInfo.telphone}}
      </el-form-item>
       <el-form-item label="旧卡号">
        <el-input v-model="userInfo.deviceCode" readonly></el-input>
      </el-form-item>
      <el-form-item
        prop="newCardCode"
        label="新卡号"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input v-model.trim="form.newCardCode"></el-input>
      </el-form-item>
      <el-form-item
        prop="reasonType"
        label="更换原因"
        :rules="[{required: true, message: ' '}]">
        <el-radio-group v-model="form.reasonType">
          <el-radio :label="1">丢失</el-radio>
          <el-radio :label="2">损坏</el-radio>
          <el-radio :label="3">其它</el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>

    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
    </span>
  </el-dialog>
</template>


<script>
export default {
  data() {
    return {
      visible: false,
      userInfo: {},
      form: {
        newCardCode: '',
        reasonType: null
      },
      submitting: false
    }
  },
  methods: {
    async show(options) {
      this.options = options;
      this.visible = true;
      if (this.$refs.form) {
        this.$refs.form.resetFields();
      }
      this.userInfo = options.user;
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        this.submitting = true;
        let data = {...this.form, userId: this.userInfo.id, oldCardCode: this.userInfo.deviceCode};
        const ret = await axios.post('/api/user/vipcard/change/change', data);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('更换会员卡成功');
          this.visible = false;
          this.options.onSuccess(data);
        } else {
          this.$message.error({1: '卡号未被登记', 2: '卡号已被其它用户使用'}[ret.code]);
        }
      });
    },
  }
}
</script>
<template>
  <el-dialog
    title="修改密码"
    :visible.sync="visible"
    width="360px"
  >
    <el-form ref="form" :model="form" label-width="100px">
      <el-form-item
        prop="password"
        label="输入新密码"
        :rules="[{required: true, message: ' ', trigger: 'blur'}]">
        <el-input ref="passwordInput" type="password" v-model="form.password" style="width:200px"></el-input>
      </el-form-item>
      <el-form-item
        prop="confirmPassword"
        label="确认新密码"
        :rules="[
          {required: true, message: ' ', trigger: 'blur'},
          {validator: validateConfirm, trigger: 'blur'}]">
        <el-input type="password" v-model="form.confirmPassword" style="width:200px"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit">确认</el-button>
    </span>
  </el-dialog>
</template>

<script>
import config from '@/config/app.config';

export default {
  data() {
    return {
      visible: false,
      form: {},
      validateConfirm: (rule, value, callback) => {
        if (!value) {
          callback(new Error(' '));
        } else if (this.form.password != value) {
          callback(new Error('两次输入密码不一致'));
        } else {
          callback();
        }
      }
    };
  },
  watch: {
    visible(value) {
      if (value) {
        this.$nextTick(() => {
          this.form = {};
          this.$refs.form.clearValidate();
          this.$refs.passwordInput.focus();
        });
      }
    }
  },
  methods: {
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        const ret = await axios.post('/api/admin/changePwd', {
          passwd: this.form.confirmPassword
        });
        if (ret.success) {
          this.visible = false;
          config.set('autoLoginEnabled', false);
          config.set('password', '');
          this.$message.success('修改密码成功');
        }
      });

    }
  }
}
</script>

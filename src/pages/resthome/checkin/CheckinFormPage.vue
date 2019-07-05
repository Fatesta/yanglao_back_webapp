<template>
  <normal-page>
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 500px;margin: 0 auto"
    >
      <el-form-item
        prop="berthId"
        label="入住床位"
      >
        <span>{{$params.berth.berthNo}}</span>
      </el-form-item>
      <el-form-item label="入住用户">
        <el-button type="primary" plain icon="el-icon-user" @click="onSelectUser">选择用户</el-button>
        <template v-if="user">
          <el-row>
            <el-col :span="8">平台用户：{{user.aliasName}}</el-col>
          </el-row>
          <el-row>
            <el-col :span="8">身份证号：{{user.idcard}}</el-col>
          </el-row>
        </template>
      </el-form-item>
      <el-form-item
        prop="startTime"
        label="实际入住日期"
        :rules="[{required: true, message: ' '}]"
      >
        <el-date-picker
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="选择日期"
          v-model="form.startTime" />
      </el-form-item>
      <el-form-item
        prop="paidMoney"
        label="已付押金"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input-number v-model="form.paidMoney" :precision="2" :controls="false"></el-input-number>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
      </el-form-item>
    </el-form>
    <user-query-selector ref="userQuerySelector" />
  </normal-page>
</template>


<script>
export default {
  pageProps: {
    title: '登记入住'
  },
  components: {
    UserQuerySelector: () => import('@/pages/user/UserQuerySelector')
  },
  data() {
    return {
      submitting: false,
      form: {
        berthId: this.$params.berth.id,
        startTime: new Date(),
        paidMoney: 0,
        userId: null
      },
      user: null
    };
  },
  methods: {
    onSelectUser() {
      this.$refs.userQuerySelector.show({
        onOk: (user) => {
          this.form.userId = user.id;
          this.user = user;
          return true;
        }
      });
    },
    async onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        if (!this.form.userId) {
          this.$message.warning('请选择用户');
          return;
        }
        this.submitting = true;
        const code = await this.axios.post('/api/community/berth/checkin/new', this.form);
        this.submitting = false;
        if (code <= 1) {
          this.$message.success('入住成功');
          this.$params.onSuccess();
        } else if (code == 2) {
          this.$message.error('床位已有人入住');
        } else if (code == 3) {
          this.$message.error('该用户已在其它房间入住中');
        }
      });
    }
  }
}
</script>
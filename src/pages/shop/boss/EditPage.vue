<!--
增加用户
-->
<template>
  <normal-page>
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 500px;margin: 0 auto;"
    >
      <el-form-item
        prop="realName"
        label="姓名"
      >
        <el-input v-model.trim="form.realName"></el-input>
      </el-form-item>
      <el-form-item
        prop="sex"
        label="性别"
        :rules="[{required: true, message: ' '}]">
        <el-radio-group v-model="form.sex">
          <el-radio :label="'M'">男</el-radio>
          <el-radio :label="'W'">女</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item
        prop="phone"
        label="手机号"
        :rules="[{required: true, message: ' '}, {min: 6, max: 11, message: '长度为6~11'}]">
        <el-input v-model.trim="form.phone"></el-input>
      </el-form-item>
      <el-form-item
        v-if="$params.mode == 'add'"
        prop="passwd"
        label="密码"
        :rules="[{required: true, message: ' '}]">
        <el-input type="password" show-password v-model.trim="form.passwd"></el-input>
      </el-form-item>
      <el-form-item
        prop="email"
        label="邮箱">
        <el-input v-model.trim="form.email"></el-input>
      </el-form-item>
      <el-form-item
        prop="orgIds"
        label="组织"
        :rules="[{required: true, message: ' '}]"
      >
        <org-check-tree
          v-model="form.orgIds"
          style="width: 100%;" />
        <el-alert
          type="info"
          :closable="false"
          :title="`已选择 ${form.orgIds.length || 0} 个`"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
      </el-form-item>
    </el-form>
  </normal-page>
</template>

<script>
export default {
  pageProps: {
    title: '编辑商家'
  },
  components: {
    OrgCheckTree: () => import('@/pages/org/OrgCheckTree.vue')
  },
  data() {
    return {
      form: {
        id: null,
        realName: '',
        sex: 'M',
        phone: '',
        passwd: this.$params.mode == 'add' ? '123456' : '',
        email: '',
        orgIds: [],
        moneyType: 1
      },
      submitting: false
    }
  },
  methods: {
    onSubmit() {
      this.$refs.form.validate(async (valid, errFields) => {
        if (!valid) return;
        let formData = {...this.form};
        formData.orgIds = this.form.orgIds.join(',');
        
        this.submitting = true;
        const ret = await this.axios.post('/api/shop/boss/saveBoss', formData);
        this.submitting = false;
        if (ret.success) {
          this.$message.success(`${this.$params.mode == 'add' ? '增加' : '修改'}商家成功`);
          this.$params.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    }
  },
  async mounted(options) {
    if (this.$params.mode == 'add') {
      return;
    }
    this.submitting = true;
    const boss = await this.axios.get('/api/shop/boss', {params: {id: this.$params.boss.id}});
    this.submitting = false;
    for (let key in this.form) {
      this.form[key] = boss[key];
    }
  }
}
</script>
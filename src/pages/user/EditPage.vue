<!--
增加用户
-->
<template>
  <el-card shadow="never">
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 500px;margin: 0 auto"
    >
      <el-form-item
        prop="realName"
        label="姓名"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input v-model.trim="form.realName"></el-input>
      </el-form-item>
      <el-form-item
        prop="sex"
        label="性别"
        :rules="[{required: true, message: ' '}]">
        <el-radio-group v-model="form.sex">
          <el-radio :label="'0'">男</el-radio>
          <el-radio :label="'1'">女</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item
        prop="birthday"
        label="生日"
      >
        <el-date-picker
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="选择日期"
          :default-value="moment().subtract('y', 60).month(0).toDate()"
          v-model="form.birthday" />
      </el-form-item>
      <el-form-item
        prop="idcard"
        label="身份证"
        :rules="[{required: false, message: ' '}]"
      >
        <el-input v-model.trim="form.idcard"></el-input>
      </el-form-item>
      <el-form-item
        prop="telephone"
        label="手机号"
        :rules="[{required: form.userType == 1, message: ' '}]">
        <el-input v-model.trim="form.telephone"></el-input>
      </el-form-item>
      <el-form-item
        prop="name"
        label="紧急联系人"
      >
        <el-input v-model.trim="form.name"></el-input>
      </el-form-item>
      <el-form-item
        prop="contactTel"
        label="紧急联系电话"
        :rules="[{required: false, message: ' '}]">
        <el-input v-model.trim="form.contactTel"></el-input>
      </el-form-item>
      <el-form-item
        prop="orgId"
        label="社区"
        :rules="[{required: true, message: ' '}]">
        <org-select ref="orgSelect" v-model="form.orgId" />
      </el-form-item>
      <el-form-item
        prop="address"
        label="家庭地址"
      >
        <el-input type="textarea" :rows="1" v-model.trim="form.address"></el-input>
      </el-form-item>
      <el-form-item
        v-if="mode == 'add'"
        prop="userType"
        label="用户类型"
        :rules="[{required: true, message: ' '}]"
      >
        <type-select
          v-model="form.userType"
          :items="DictMan.items('user.type').filter(item => [1, 2, 9].includes(+item.value))"
          @change="onUserTypeChange"
          style="width: 140px"
        />
      </el-form-item>
      <el-form-item
        v-if="[2,9].includes(+form.userType)"
        prop="deviceCode"
        :label="form.userType == 2 ? '卡号' : '设备号'"
        :rules="[{required: true, message: ' '}]">
        <el-input v-model.trim="form.deviceCode"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
import { Select } from 'element-ui';
import moment from 'moment';

export default {
  pageProps: {
    title: '编辑用户'
  },
  components: {
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 })
  },
  data() {
    return {
      mode: this.$params.mode,
      form: {
        id: null,
        userType: null,
        aliasName: '',
        realName: '',
        sex: null,
        birthday: null,
        idcard: '',
        telephone: '',
        password: null,
        name: '',
        contactTel: '',
        orgId: null,
        address: '',
        remark: '',
        imagePath: '',
        deviceCode: ''
      },
      moment,
      submitting: false
    }
  },
  methods: {
    onSubmit() {
      if (this.mode == 'add') {
        this.onAddSubmit();
      } else {
        this.onUpdateSubmit();
      }
    },
    onAddSubmit() {
      if (this.form.userType == 1) {
        this.form.password = '123456';
      } else {
        this.form.password = '';
      }
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        this.submitting = true;
        this.form.aliasName = this.form.realName;
        const ret = await axios.post('/api/user/registUser', this.form);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('增加用户成功');
          this.$refs.form.resetFields();
          this.$params.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    },
    onUpdateSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        this.submitting = true;
        let data = _.pick({...this.form},
          'aliasName,realName,sex,birthday,idcard,telephone,name,contactTel,orgId,address'.split(','));
        data.userId = this.form.id;
        data.appUserId = data.userId;
        data.userType = this.form.userType;
        data.aliasName = this.form.realName;
        const ret = await axios.post('/api/user/updateUser', data);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('修改用户成功');
          this.$params.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    },
  },
  async mounted() {
    if (this.mode == 'update') {
      this.submitting = true;
      const user = await axios.get('/api/user/getBasicInfo', {params: {userId: this.$params.user.id}});
      this.submitting = false;
      this.form = user;
      this.form.telephone = user.telphone;
      this.$refs.orgSelect.setValue(user.orgId);
    }
  }
}
</script>
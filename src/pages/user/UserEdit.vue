<!--
增加用户
-->
<template>
  <el-dialog
    :title="`${mode == 'add' ? '增加' : '修改'}用户`"
    :visible.sync="visible"
    top="5vh"
    :close-on-click-modal="false"
    width="600px"
  >
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      size="small"
      style="width: 500px;"
    >
      <el-form-item
        prop="aliasName"
        label="昵称"
        :rules="[{required: true, message: ' '}]">
        <el-input v-model.trim="form.aliasName"></el-input>
      </el-form-item>
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
          v-model="form.birthday" />
      </el-form-item>
      <el-form-item
        prop="idcard"
        label="身份证"
        :rules="[{len: 18, message: '长度为18'}]"
      >
        <el-input v-model.trim="form.idcard"></el-input>
      </el-form-item>
      <el-form-item
        prop="telephone"
        label="手机号"
        :rules="[{required: form.userType == 1, message: ' '}, {min: 6, max: 11, message: '长度为6~11'}]">
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
        label="联系联系电话"
        :rules="[{min: 6, max: 11, message: '长度为6~11'}]">
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
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button size="small" type="default" @click="visible = false">取消</el-button>
      <el-button size="small" type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
import OrgSelect from './OrgSelect.vue';

export default {
  components: {
    OrgSelect
  },
  data() {
    return {
      visible: false,
      mode: null,
      form: {
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
        imagePath: ''
      },
      submitting: false
    }
  },
  methods: {
    async show(options) {
      this.mode = options.mode;
      this.options = options;
      this.visible = true;
      if (this.$refs.form) {
        this.$refs.form.resetFields();
      }
      if (options.mode == 'update') {
        this.submitting = true;
        const user = await axios.get('/api/user/getBasicInfo', {params: {userId: options.user.id}});
        this.submitting = false;
        options.user = user;
        this.form = user;
        this.form.telephone = user.telphone;
        this.$refs.orgSelect.setValue(user.orgId);
      } else {
        this.$refs.orgSelect.clear(null);
      }
    },
    onSubmit() {
      if (this.options.mode == 'add') {
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
        const ret = await axios.post('/api/user/registUser', this.form);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('增加用户成功');
          this.visible = false;
          this.options.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    },
    onUpdateSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        this.submitting = true;
        let data = {...this.form};
        const { user } = this.options;
        data.userId = user.id;
        data.appUserId = user.id;
        data.userType = user.userType;
        const ret = await axios.post('/api/user/updateUser', data);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('修改用户成功');
          this.visible = false;
          this.options.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    },
  }
}
</script>
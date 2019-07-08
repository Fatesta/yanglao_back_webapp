<!--
创建会员卡用户，并充值
-->
<template>
  <card-page>

    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 500px;margin: 0 auto"
    >
      <el-form-item
        prop="deviceCodeTail"
        label="卡号"
        :rules="[{required: true, message: ' '}]">
        <el-input v-model="form.deviceCodeTail" placeholder="卡号剩余位" >
          <template slot="prepend">7128020</template>
        </el-input>
      </el-form-item>
      <el-form-item
        prop="rechargeAmount"
        label="充值金额"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input-number v-model="form.rechargeAmount" :precision="2" :controls="false"></el-input-number>
      </el-form-item>
      <el-form-item
        prop="bossId"
        label="服务商家"
        :rules="[{required: true, message: ' '}]"
      >
        <span>{{selectedBossName}}</span>
        <el-button type="primary" plain icon="el-icon-user" @click="onSelectBossClick">选择</el-button>
      </el-form-item>

      <el-form-item style="margin-top: 8px">
      </el-form-item>
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
        <org-select v-model="form.orgId" />
      </el-form-item>
      <el-form-item
        prop="diqu"
        label="家庭地址-地区"
      >
        <city-select v-model="city" style="width: 100%;"></city-select>
      </el-form-item>
      <el-form-item
        prop="address"
        label="家庭地址-详细"
      >
        <el-input type="textarea" :rows="1" v-model.trim="form.address"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting">开通</el-button>
      </el-form-item>
    </el-form>

    <boss-query-selector ref="bossQuerySelector" />
  </card-page>
</template>

<script>
import { Select } from 'element-ui';
import moment from 'moment';

export default {
  pageProps: {
    title: '会员卡用户开通'
  },
  components: {
    OrgSelect: () => import('@/pages/org/OrgSelect'),
    CitySelect: () => import('@/components/cityselect/CitySelect'),
    BossQuerySelector: () => import('@/pages/shop/BossQuerySelector.vue')
  },
  data() {
    return {
      mode: this.$params.mode,
      form: {
        id: null,
        userType: 2,
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
        deviceCode: '',
        bossId: null,
        rechargeAmount: 200,
        deviceCodeTail: '',
      },
      selectedBossName: null,
      city: {prov: '湖北省', city: '武汉市'},
      moment,
      submitting: false
    }
  },
  methods: {
    onSelectBossClick() {
      this.$refs.bossQuerySelector.show({
        onOk: (boss) => {
          this.form.bossId = boss.adminId;
          this.selectedBossName = boss.realName;
          return true;
        }
      });
    },
    onSubmit() {
      debugger;
      this.$refs.form.validate(async (valid, errs) => {
        if (!valid && Object.keys(errs).length == 1 && errs.sex) {
          this.$message.warning('请输入性别');
          return;
        }
        if (!valid) return;
        let userData = {...this.form};
        userData.aliasName = userData.realName;
        userData.address = (this.city.prov || '')
          + (this.city.city || '')
          + (this.city.dist || '') + userData.address;
        userData.deviceCode = '7128020' + this.form.deviceCodeTail;
        delete userData.deviceCodeTail;
        console.log(userData);
        this.$refs.form.resetFields();
        // 方便多次重复
        this.form.orgId = userData.orgId;
        this.form.bossId = userData.bossId;
        return;
        this.submitting = true;
        const ret = await this.axios.post('/api/user/registUser', userData);
        this.submitting = false;
        if (ret.success) {
          this.$message.success('开卡成功');
          this.$refs.form.resetFields();
          this.$params.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    }
  },
}
</script>
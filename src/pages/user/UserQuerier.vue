<!--
用户高级查询器
-->
<template>
  <el-dialog
    title="用户高级查询"
    :visible.sync="visible"
    :modal="false"
    width="580px"
  >
    <el-tabs tab-position="left" style="height: 440px">
      <el-tab-pane label="基本信息">
        <el-form :model="form" label-width="110px" style="width: 400px">
          <el-form-item label="昵称">
            <el-input v-model="form.aliasName" clearable></el-input>
          </el-form-item>
          <el-form-item label="姓名">
            <el-input v-model="form.realName" clearable></el-input>
          </el-form-item>
          <el-form-item label="身份证">
            <el-input v-model="form.idcard" clearable></el-input>
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="form.telphone" clearable></el-input>
          </el-form-item>
          <el-form-item label="设备号/卡号">
            <el-input v-model="form.deviceCode" clearable></el-input>
          </el-form-item>
          <el-form-item label="用户类型">
            <type-select
              v-model="form.userType"
              :items="DictMan.items('user.type')"
            />
          </el-form-item>
          <el-form-item label="社区">
            <org-select v-model="form.orgId" />
          </el-form-item>
          <el-form-item
            prop="sex"
            label="在线状态"
          >
            <el-radio-group v-model="form.onLine">
              <el-radio label="">全部</el-radio>
              <el-radio :label="1">在线</el-radio>
              <el-radio :label="0">离线</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="注册日期">
            <el-date-picker
              v-model="form.registerTimeRange"
              type="daterange"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              :default-time="['00:00:00', '23:59:59']"
              style="width: 100%;"
            >
            </el-date-picker>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <el-tab-pane label="评估对象">
        <el-form :model="form" label-width="110px" style="width: 400px">
          <el-form-item label="申请对象类型">
            <el-checkbox-group v-model="form.applyTypes">
              <el-checkbox
                v-for="item in DictMan.items('evalOldman.applyType')"
                :key="item.value"
                :label="item.value"
                name="applyTypes"
              >{{item.text}}</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="条件">
            <el-radio-group v-model="form.applyTypeJoinPredicate">
              <el-radio label="or">至少符合一个</el-radio>
              <el-radio label="and" >同时符合全部</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <el-tab-pane label="特殊老人">
        <el-form :model="form" label-width="170px" style="width: 400px">
          <el-form-item label="市区两级补贴老人">
            <el-checkbox v-model="form.role" :true-label="-1"></el-checkbox>
          </el-form-item>
          <el-form-item label="区级养老护理补贴老人">
            <el-checkbox v-model="form.isGrant" :true-label="1"></el-checkbox>
          </el-form-item>
        </el-form>
      </el-tab-pane>
    </el-tabs>
    <div slot="footer" style="margin-top: 8px;">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="default" @click="onReset">重置</el-button>
      <el-button type="primary" @click="onSubmit">查询</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { Select } from 'element-ui';

export default {
  components: {
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 })
  },
  data() {
    return {
      visible: false,
      form: {
        applyTypes: [],
        applyTypeJoinPredicate: 'or'
      }
    }
  },
  methods: {
    show(options) {
      this.options = options;
      this.form = Object.assign(this.form, options.values);
      this.table = options.table;
      this.visible = true;
    },
    onReset() {
      for (let key in this.form) {
        this.form[key] = '';
        this.$set(this.options.values, key, '');
      }
    },
    onSubmit() {
      for (let key in this.form) {
        this.$set(this.options.values, key, this.form[key]);
      }
      
      let queryParams = {...this.form};
      if (this.form.registerTimeRange) {
        queryParams.minRegisterTime = this.form.registerTimeRange[0];
        queryParams.maxRegisterTime = this.form.registerTimeRange[1];
        delete queryParams.registerTimeRange;
      }
      if (this.form.applyTypes) {
        queryParams.applyTypes = this.form.applyTypes.join(',');
      }
      this.table.query(queryParams);
    }
  }
}
</script>

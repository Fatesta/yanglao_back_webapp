<template>
  <el-dialog
    title="设置权限"
    :visible.sync="visible"
    width="30%"
  >
    <el-alert
      type="info"
      :closable="false"
      :style="{marginBottom: '16px'}"
      :title="(form.permissionTypes.length ?
        '已设置 ' + form.permissionTypes.length + ' 个权限' : '未设置权限')"
    >
    </el-alert>
    <el-checkbox v-model="checkAll" @change="onCheckAllChange" style="margin-bottom: 16px">全选</el-checkbox>
    <el-checkbox-group v-model="form.permissionTypes" @change="onChange" v-loading="loading">
      <el-checkbox
        v-for="item in allPermissionTypes"
        :label="+item.value"
        :key="item.value"
        >
        {{item.text}}
      </el-checkbox>
    </el-checkbox-group>
    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onOkClick">确定</el-button>
    </span>
  </el-dialog>
</template>


<script>
/* 权限设置 */
export default {
  data() {
    return {
      visible: false,
      loading: true,
      checkAll: false,
      form: {
        permissionTypes: [], //选中的
        userId: null
      }
    }
  },
  computed: {
    allPermissionTypes() {
      return DictMan.items('user.permissionType');
    }
  },
  methods: {
    async open(userId) {
      this.visible = true;
      this.loading = true;
      this.checkAll = false;
      this.form = {
        userId: userId,
        permissionTypes: []
      };
      const ret = await axios.get(
        'api/user/permission/getPermissionTypesByUserId',
        {params: {userId: userId}});
      this.form.permissionTypes = ret;
      this._setCheckAll(this.form.permissionTypes);
      this.loading = false;
    },
    onChange(checked) {
      this._setCheckAll(this.form.permissionTypes);
    },
    _setCheckAll(checks) {
      this.checkAll = checks.length > 0 && (checks.length == this.allPermissionTypes.length);
    },
    onCheckAllChange(checked) {
      this.form.permissionTypes = checked ? this.allPermissionTypes.map(item => +item.value) : [];
      this.checkAll = checked;
    },
    async onOkClick() {
      const ret = await axios.post(
        '/api/user/permission/save',
        {userId: this.form.userId, typeCsv: this.form.permissionTypes.join(',')});
      if (ret.success) {
        this.$message.success('设置成功');
        this.visible = false;
      }
    }
  }
}
</script>
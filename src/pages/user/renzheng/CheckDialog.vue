<template>
  <el-dialog
    title="审核"
    :visible.sync="visible"
    width="30%"
  >
    <el-form ref="checkForm" :model="checkForm" label-width="80px">
      <el-form-item label="说明">
        <el-input type="textarea" :rows="2" v-model="checkForm.stateDesc"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button size="small" type="default" @click="visible = false">取消</el-button>
      <el-button size="small" type="success" @click="onPassClick">通过</el-button>
      <el-button size="small" type="danger" @click="onNoPassClick">不通过</el-button>
    </span>
  </el-dialog>
</template>


<script>
/* 审核 */
export default {
  data() {
    return {
      visible: false,
      checkForm: {
        stateDesc: ''
      }
    }
  },
  methods: {
    open(userId, onSuccess) {
      this.visible = true;
      this.checkForm = {stateDesc: '', state: 1, userId: userId};
      this.onSuccess = onSuccess;
    },
    onPassClick() {
      this._check(2);
    },
    onNoPassClick() {
      this._check(3);
    },
    async _check(state) {
      const ret = await axios.post('/api/user/renzheng/check',
        {...this.checkForm, ...{state: state}});
      if (ret.success) {
        this.$message.success('审核成功');
        this.visible = false;
        this.onSuccess(state);
      }
    }
  }
}
</script>
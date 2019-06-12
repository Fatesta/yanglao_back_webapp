<template>
  <el-dialog
    title="开始订单"
    :visible.sync="visible"
    top="5vh"
    width="640px"
  >
    <el-form ref="form" :model="form" label-width="50px">
      <el-form-item
        prop="remark"
        label="内容">
        <el-input type="textarea" :rows="3" v-model="form.remark"></el-input>
      </el-form-item>
      <el-form-item label="照片">
        <el-upload
          action="/api/util/upload"
          accept="image/*"
          list-type="picture"
          :on-success="onUploadSuccess">
          <el-button type="primary" plain>上传照片</el-button>
        </el-upload>
      </el-form-item>
    </el-form>
    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit" :loading="submitting">提交</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      form: {},
      submitting: false,
      fileList: []
    }
  },
  methods: {
    async show(options) {
      const { order } = options;
      this.form = {
        orderno: order.orderno,
        creator: order.creator,
        operator: order.handler,
        longitude: order.longitude,
        latitude: order.latitude,
        remark: ''
      };
      this.fileList = [];
      this.visible = true;
      this.onSuccess = options.onSuccess;
    },
    onUploadSuccess(response, file) {
      this.fileList.push({name: '', url: response.data.url});
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) {
          return;
        }
        let postData = {...this.form};
        postData['pictureImage'] = this.fileList.map(f => f.url).join(',');
        this.submitting = true;
        const ret = await axios.post('/api/shop/order/housekeeping/start', postData);
        if (ret.success) {
          this.$message.success('订单开始成功');
          this.visible = false;
          this.onSuccess(this.form);
        } else {
          this.$message.error(ret.message);
        }
        this.submitting = false;
      });
    }
  }
}
</script>
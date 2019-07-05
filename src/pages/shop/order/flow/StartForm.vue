<template>
  <el-dialog
    :title="`${mode == 'update' ? '修改' : ''}订单开始`"
    :visible.sync="visible"
    :close-on-click-modal="false"
    width="640px"
  >
    <el-form ref="form" :model="form" label-width="50px">
      <el-form-item label="时间">
        <el-date-picker
          v-model="form.startTime"
          value-format="yyyyMMddHHmmss"
          type="datetime"
          placeholder="选择日期时间"
        />
      </el-form-item>
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
          :file-list="fileList"
          :on-success="onUploadSuccess"
          :on-remove="onRemove">
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
import moment from 'moment';

export default {
  data() {
    return {
      mode: null,
      visible: false,
      form: {},
      submitting: false,
      fileList: []
    }
  },
  methods: {
    async show(options) {
      this.mode = options.mode;
      const { order } = options;
      this.form = {
        orderno: order.orderno,
        creator: order.creator,
        operator: order.handler,
        longitude: order.longitude,
        latitude: order.latitude,
        remark: '',
        startTime: moment().format('YYYYMMDDHHmmss')
      };
      if (order.startFlowTime) {
        let orderFlowInfo = await this.axios.get('/api/shop/order/orderFlowInfo',
          {params: { orderCode: order.orderno }});
        this.form.remark = orderFlowInfo.orderStartRemark,
        this.form.startTime = moment(order.startFlowTimestamp).format('YYYYMMDDHHmmss');
        this.fileList = orderFlowInfo.orderStartImage.split(',').map(url => ({name: '', url}));
      } else {
        this.fileList = [];
      }
      this.visible = true;
      this.submitting = false;
      this.onSuccess = options.onSuccess;
    },
    onUploadSuccess(response, file) {
      this.fileList.push({name: '', url: response.data.url});
    },
    onRemove(file, fileList) {
      this.fileList.splice(fileList.findIndex(f => f.url == file.url), 1);
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) {
          return;
        }
        let postData = {...this.form};
        postData['pictureImage'] = this.fileList.map(f => f.url).join(',');
        this.submitting = true;
        if (this.mode == 'update') {
          await this.axios.post('/api/shop/order/housekeeping/deleteFlow',
            {orderno: this.form.orderno, action: 5});
        }
        const ret = await this.axios.post('/api/shop/order/housekeeping/start', postData);
        if (ret.success) {
          this.$message.success(this.mode == 'update' ? '修改成功' : '订单开始成功');
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
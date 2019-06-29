<template>
  <div>
  <el-dialog
    :title="`${mode == 'update' && '修改'}订单完成`"
    :visible.sync="visible"
    :close-on-click-modal="false"
    width="640px"
  >
    <el-form ref="form" :model="form" label-width="50px">
      <el-form-item label="时间">
        <el-date-picker
          v-model="form.endTime"
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
          ref="imageUpload"
          action="/api/util/upload"
          accept="image/*"
          list-type="picture"
          :file-list="fileList"
          :on-success="onPhotoUploadSuccess"
          :on-remove="onPhotoRemove">
          <el-button type="primary" plain>上传照片</el-button>
        </el-upload>
      </el-form-item>
      <el-form-item label="录音">
        <audio controls style="display: block;margin-bottom: 8px;" ref="audio" />
        <el-button type="primary" plain icon="el-icon-microphone" @click="onOpenRecorderClick">新录音</el-button>
        <el-upload
          ref="audioUpload"
          action="/api/util/upload"
          :limit="1"
          accept="audio/*"
          :show-file-list="false"
          :on-success="onRecordingUploadSuccess"
          style="display: inline-block;"
        >
          <el-button slot="trigger" type="primary" plain>从本地选取已有录音</el-button>
        </el-upload>
      </el-form-item>
    </el-form>
    <span slot="footer">
      <el-button type="default" @click="visible = false">取消</el-button>
      <el-button type="primary" @click="onSubmit" :loading="submitting">提交</el-button>
    </span>
  </el-dialog>

  <audio-recorder-dialog ref="audioRecorderDialog" />

  </div>
</template>

<script>
import AudioRecorderDialog from '@/components/AudioRecorderDialog.vue';
import moment from 'moment';

export default {
  components: {
    AudioRecorderDialog
  },
  data() {
    return {
      mode: null,
      visible: false,
      form: {},
      submitting: false,
      fileList: [],
      voiceFile: null
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
        endTime: moment().format('YYYYMMDDHHmmss')

      };
      if (this.$refs.imageUpload) {
        this.$refs.imageUpload.clearFiles();
      }
      if (this.$refs.audioUpload) {
        this.$refs.audioUpload.clearFiles();
        this.$refs.audio.src = '';
      }
      if (order.endFlowTime) {
        let orderFlowInfo = await this.axios.get('/api/shop/order/orderFlowInfo',
          {params: { orderCode: order.orderno }});
        this.form.remark = orderFlowInfo.orderEndRemark,
        this.form.endTime = moment(order.endFlowTimestamp).format('YYYYMMDDHHmmss');
        this.fileList = orderFlowInfo.orderEndImage.split(',').map(url => ({name: '', url}));
        this.voiceFile = orderFlowInfo.voiceFile;
      } else {
        this.fileList = [];
        this.voiceFile = null;
      }
      this.visible = true;
      this.submitting = false;
      this.onSuccess = options.onSuccess;
    },
    onPhotoUploadSuccess(response, file) {
      this.fileList.push({name: '', url: response.data.url});
    },
    onPhotoRemove(file, fileList) {
      this.fileList.splice(fileList.findIndex(f => f.url == file.url), 1);
    },
    onOpenRecorderClick() {
      this.$refs.audioRecorderDialog.show({
        onSuccess: async (result) => {
          let formData = new FormData();
          formData.append('file', result.blod);
          const response = await axios.create().post('/api/util/upload', formData);
          if (response.data.success) {
            this.voiceFile = response.data.data.url;
            this.$refs.audio.src = this.voiceFile;
          } else {
            this.$message.error('对不起，发生错误');
          }
        }
      });
    },
    onRecordingUploadSuccess(response) {
      this.voiceFile = response.data.url;
      this.$refs.audio.src = this.voiceFile;
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) {
          return;
        }
        let postData = {...this.form};
        postData['pictureImage'] = this.fileList.map(f => f.url).join(',');
        postData['voiceFile'] = this.voiceFile;
        this.submitting = true;
        if (this.mode == 'update') {
          await axios.post('/api/shop/order/housekeeping/deleteFlow',
            {orderno: this.form.orderno, action: 6});
        }
        const ret = await axios.post('/api/shop/order/housekeeping/finish', postData);
        if (ret.success) {
          this.$message.success(this.mode == 'update' ? '修改成功' : '订单完成成功');
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
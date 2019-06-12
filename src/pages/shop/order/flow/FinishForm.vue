<template>
  <div>
  <el-dialog
    title="完成订单"
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
          :on-success="onPhotoUploadSuccess">
          <el-button type="primary" plain>上传照片</el-button>
        </el-upload>
      </el-form-item>
      <el-form-item label="录音">
        <audio controls style="display: block;margin-bottom: 8px;" ref="audio" />
        <el-button type="primary" plain icon="el-icon-microphone" @click="onOpenRecorderClick">录音</el-button>
        <el-upload
          ref="upload"
          action="/api/util/upload"
          :limit="1"
          accept="audio/*"
          :show-file-list="false"
          :on-success="onRecordingUploadSuccess"
          style="display: inline-block;"
        >
          <el-button slot="trigger" type="primary" plain icon="el-icon-upload2">或从本地选取文件</el-button>
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

export default {
  components: {
    AudioRecorderDialog
  },
  data() {
    return {
      visible: false,
      form: {},
      submitting: false,
      fileList: [],
      voiceFile: null
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
      this.voiceFile = null;
      this.visible = true;
      this.onSuccess = options.onSuccess;
    },
    onPhotoUploadSuccess(response, file) {
      this.fileList.push({name: '', url: response.data.url});
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
        const ret = await axios.post('/api/shop/order/housekeeping/finish', postData);
        if (ret.success) {
          this.$message.success('订单完成');
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
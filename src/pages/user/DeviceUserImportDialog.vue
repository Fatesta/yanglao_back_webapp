<template>
  <el-dialog
    title="批量导入设备用户"
    :visible.sync="visible"
    width="400px"
  >
    <el-button size="small" @click="onDownloadTemplateClick">下载模板</el-button>
    <el-upload
      ref="upload"
      action="/api/device/importDevice"
      :auto-upload="false"
      :limit="1"
      accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"
      :on-success="onSuccess"
      style="margin-top: 16px"
    >
      <el-button slot="trigger" size="small" type="primary" plain>选取文件</el-button>
    </el-upload>
    <span slot="footer" class="dialog-footer">
      <el-button size="small" type="default" @click="visible = false">取消</el-button>
      <el-button size="small" type="primary" @click="onSubmit" :loading="submitting">提交</el-button>
    </span>
  </el-dialog>
</template>


<script>
export default {
  data() {
    return {
      visible: false,
      submitting: false
    };
  },
  methods: {
    show(options) {
      this.visible = true;
      this.options = options; 
      if (this.$refs.upload) {
        this.$refs.upload.clearFiles();
      }
    },
    onDownloadTemplateClick() {
      location.href = '/module/device/device_template.xls';
    },
    onChange(file) {
      this.file = file;
    },
    onSubmit() {
      this.submitting = true;
      this.$refs.upload.submit();
    },
    onSuccess(response) {
      this.submitting = false;
      if (response.success) {
        this.$message.success('操作成功');
        this.$refs.upload.clearFiles();
        this.options.onSuccess();
      } else {
        this.$message.error(response.message);
      }
    }
  }
}
</script>

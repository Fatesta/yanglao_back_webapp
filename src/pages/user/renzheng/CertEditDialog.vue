<template>
  <el-dialog
    :title="!readonly ? '编辑认证' : '认证信息'"
    :visible.sync="visible"
    top="5vh"
    width="600px"
  >
    <el-form ref="form" :model="form" label-width="100px" size="small">
      <el-form-item
        prop="realName"
        label="真实姓名"
        :rules="[{required: true, message: ' '}]">
        <el-input v-model="form.realName" :readonly="readonly" style="width: 200px"></el-input>
      </el-form-item>
      <el-form-item
        prop="idcard"
        label="身份证号"
        :rules="[{required: true, message: ' '}, {len: 18, message: '长度为18'}]">
        <el-input v-model="form.idcard" :readonly="readonly" style="width: 200px"></el-input>
      </el-form-item>
      <el-form-item
        prop="address"
        label="家庭地址"
        :rules="[{required: true, message: ' '}]">
        <el-input type="textarea" :rows="1" :readonly="readonly" v-model="form.address"  style="width: 360px"></el-input>
      </el-form-item>
    </el-form>
    <div style="margin: 32px 0px 0px 24px">
      <div
        v-for="(title, index) in ['身份证正面', '身份证反面', '手持身份证']"
        :key="index"
        style="width: 240px;height: 180px;margin: 0px 24px 24px 0px;display:inline-block">
        <el-image
          fit="cover"
          :src="idcardImgUrls[index]"
          style="width: 100%;height:140px;">
          <div
            v-for="soltType in ['error', 'placeholder']"
            :key="soltType"
            :slot="soltType"
            style="width: 100%;height: 100%;text-align: center;background: #f5f7fa;">
            <i class="el-icon-picture-outline" style="line-height: 140px;font-size:30px"></i>
          </div>
        </el-image>
        <div style="margin-top: 8px">
          {{title}}
          <el-upload
            style="display: inline-block;"
            action="/api/util/upload"
            :show-file-list="false"
            :on-success="function(response, file){ onUploadSuccess(response, file, index); }">
            <el-button size="small" v-if="!readonly">点击上传</el-button>
          </el-upload>
          <el-link target="_blank" :underline="false" :href="idcardImgUrls[index]" v-if="readonly" type="info">点击查看大图</el-link>
        </div>
      </div>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button size="small" type="default" @click="visible = false" v-if="!readonly">取消</el-button>
      <el-button size="small" type="primary" @click="onSubmit" v-if="!readonly" :loading="submitting">提交</el-button>
    </span>
  </el-dialog>
</template>

<script>
/* 认证编辑 */

export default {
  data() {
    return {
      visible: false,
      readonly: true,
      form: {},
      submitting: false,
      idcardImgUrls: new Array(3).fill('')
    }
  },
  methods: {
    async open(user, readonly, onSuccess) {
      this.form = {
        userId: user.id,
        realName: user.realName,
        idcard: user.idcard,
        address: user.address,
      };
      this.idcardImgUrls = new Array(3).fill('');
      this.visible = true;
      this.readonly = !!readonly;
      this.onSuccess = onSuccess;
      const filePage = await axios.get(
        '/api/uploadfile/uploadfilePage',
        {params: {type: 0, resourceId: user.id, page: 1, rows: 3}});
      let urls = new Array(3).fill('');
      filePage.rows.forEach((item, index) => {
        urls[index] = item.imgPath;
      });
      this.idcardImgUrls = urls;
    },
    onUploadSuccess(response, file, index) {
      this.idcardImgUrls.splice(index, 1, response.data.url);
    },
    onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) {
          return;
        } else if (this.idcardImgUrls.includes('')) {
          this.$message.warning('请完成身份证上传');
          return;
        }
        this.form['headImages'] = this.idcardImgUrls.join(',');
        this.submitting = true;
        const ret = await axios.post('/api/user/renzheng/saveRenzhengInfo', this.form);
        if (ret.success) {
          this.$message.success('提交成功');
          this.visible = false;
          this.onSuccess(this.form);
        } else {
          this.$message.error({226: '身份证号码不合法', 229: '身份证已被绑定'})[ret.code]
        }
        this.submitting = false;
      });
    }
  }
}
</script>
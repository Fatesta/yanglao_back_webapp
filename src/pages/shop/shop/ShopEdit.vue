<!--
增加用户
-->
<template>
  <div>
    <el-dialog
      :title="`${mode == 'add' ? '新建' : '修改'}店铺`"
      :visible.sync="visible"
      top="5vh"
      :close-on-click-modal="false"
      width="600px"
    >
      <el-form
        ref="form"
        :model="form" 
        label-width="120px"
       
        style="width: 500px;"
      >
        <el-form-item
          prop="imgUrl"
          label="店铺封面"
        >
          <div>
            <el-image
              fit="cover"
              :src="form.imgUrl"
              style="display: block;height: 80px;width: 110px;">
              <div slot="error" style="
                height: 80px;width: 110px;
                font-size: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                background: #f5f7fa;
                color: #909399;">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
            <el-upload
              style="display: inline-block;margin-top: 8px;"
              action="/api/util/upload"
              accept="image/*"
              :show-file-list="false"
              :on-success="onUploadSuccess"
            >
              <el-button>点击上传</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item
          prop="name"
          label="店铺名称"
          :rules="[{required: true, message: ' '}]"
        >
          <el-input v-model.trim="form.name"></el-input>
        </el-form-item>
        <el-form-item
          prop="description"
          label="店铺描述"
        >
          <el-input type="textarea" :rows="3" v-model.trim="form.description"></el-input>
        </el-form-item>
        <el-form-item
          prop="industryId"
          label="所属行业"
          :rules="[{required: true, message: ' '}]"
        >
          <type-select
            v-model="form.industryId"
            :items="DictMan.items('product.industry')"
            style="width: 100%;" 
          />
        </el-form-item>
        <el-form-item
          prop="diqu"
          label="所在地区"
          :rules="[{required: true, message: ' '}]"
        >
          <city-select ref="citySelect" v-model="form.diqu" style="width: 100%;"></city-select>
        </el-form-item>
        <el-form-item
          prop="address"
          label="详细地址"
          :rules="[{required: true, message: ' '}]"
        >
          <el-input type="textarea" :rows="1" v-model.trim="form.address"></el-input>
        </el-form-item>
        <el-form-item
          prop="orgId"
          label="服务社区"
        >
          <el-radio-group v-model="isOrgLimited">
            <el-radio :label="false">无限制</el-radio>
            <el-radio :label="true">有限制</el-radio>
          </el-radio-group>
          <org-check-tree
            v-show="isOrgLimited"
            ref="orgCheckTree"
            v-model="form.orgId"
            style="width: 100%;" />
          <el-alert
            v-show="isOrgLimited"
            type="info"
            :closable="false"
            :title="`已选择 ${form.orgId.length || 0} 个`"
          />
        </el-form-item>
        <el-form-item
          prop="serviceArea"
          label="服务范围"
          :rules="[{required: true, message: ' '}]"
        >
          <el-radio-group v-model="isServiceScopeLimited">
            <el-radio :label="false">无限制</el-radio>
            <el-radio :label="true">有限制</el-radio>
          </el-radio-group>
          <div v-show="isServiceScopeLimited">
            <el-input-number
              v-model="form.serviceArea"
              controls-position="right"
              :min="0"
            />
            <span>(单位米)</span>
          </div>

        </el-form-item>
        <el-form-item
          prop="serviceTime"
          label="营业时间"
          :rules="[{required: true, message: ' '}]"
        >
          <el-time-picker
            is-range
            v-model="form.serviceTime"
            format="HH:mm"
            value-format="HH:mm"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            placeholder="选择时间范围"
            style="width: 100%;" 
          />
        </el-form-item>
        <el-form-item
          prop="businessMode"
          label="派单模式"
        >
          <el-checkbox v-model="form.businessMode" size="medium"></el-checkbox>
        </el-form-item>
        <el-form-item
          prop="linkman"
          label="联系人"
          :rules="[{required: true, message: ' '}]"
        >
          <el-input v-model.trim="form.linkman"></el-input>
        </el-form-item>
        <el-form-item
          prop="telephone"
          label="联系电话"
          :rules="[{required: true, message: ' '}, {min: 6, max: 11, message: '长度为6~11'}]">
          <el-input v-model.trim="form.telephone"></el-input>
        </el-form-item>
        <el-form-item
          v-if="mode == 'add'"
          prop="bossId"
          label="所属商家"
          :rules="[{required: true, message: ' '}]"
        >
          <span>{{selectedBossName}}</span>
          <el-button type="primary" plain icon="el-icon-user" @click="onSelectBossClick">选择</el-button>
        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button type="default" @click="visible = false">取消</el-button>
        <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
      </span>
    </el-dialog>

    <boss-query-selector ref="bossQuerySelector" />

  </div>
</template>

<script>
import OrgCheckTree from '@/pages/org/OrgCheckTree.vue';
import CitySelect from '@/components/cityselect/CitySelect.vue';
import BossQuerySelector from '@/pages/shop/BossQuerySelector.vue';

export default {
  components: {
    OrgCheckTree,
    CitySelect,
    BossQuerySelector
  },
  data() {
    return {
      visible: false,
      mode: null,
      form: {
        bossId: '',
        orgId: -1,
        name: '',
        description: '',
        imgUrl: '',
        industryId: '',
        diqu: null,
        address: '',
        serviceArea: '',
        serviceTime: ['08:00', '17:00'],
        linkman: '',
        telephone: '',
        businessMode: 0
      },
      isOrgLimited: false,
      isServiceScopeLimited: false,
      selectedBossName: '',
      submitting: false
    }
  },
  methods: {
    async show(options) {
      this.mode = options.mode;
      this.options = options;
      this.visible = true;
      if (this.$refs.form) {
        this.$refs.form.resetFields();
        this.isOrgLimited = false;
        this.isServiceScopeLimited = false;
        this.selectedBossName = '';
      }

      if (options.mode == 'update') {
        this.submitting = true;
        const shop = await axios.get('/api/shop/pro/info', {params: {id: options.shop.id}});
        this.submitting = false;
        options.shop = shop;
        for (let key in this.form) {
          this.form[key] = shop[key];
        }
        this.form.id = shop.id;
        this.form.serviceTime = shop.serviceTime.match(/(\d{2}:\d{2})/);
        this.form.bossId = shop.adminId;
        this.isOrgLimited = shop.orgId != -1;
        this.isServiceScopeLimited = shop.serviceArea != 0;
        this.$refs.orgCheckTree.setValue(shop.orgId);
        this.$refs.citySelect.setValue({prov: shop.province, city: shop.city, dist: shop.area});
      } else {
        this.form.id = null;
        this.$refs.orgCheckTree && this.$refs.orgCheckTree.clear();
        this.$refs.citySelect && this.$refs.citySelect.clear();
      }
    },
    onSelectBossClick() {
      this.$refs.bossQuerySelector.show({
        onOk: (boss) => {
          this.form.bossId = boss.id;
          this.selectedBossName = boss.realName;
          return true;
        }
      });
    },
    onUploadSuccess(response, file, index) {
      this.form.imgUrl = response.data.url;
    },
    onSubmit() {
      this.$refs.form.validate(async (valid, errFields) => {
        if (!valid) {
          if (Object.keys(errFields).length == 1 && errFields.bossId) {
            this.$alert('请选择所属商家');
          }
          return;
        }

        let formData = {...this.form};
        delete formData.diqu;
        const { diqu } = this.form;
        formData.province = diqu.prov;
        formData.city = diqu.city;
        formData.area = diqu.dist;
        formData.serviceTime = this.form.serviceTime.join(' ~ ');
        formData.serviceArea = this.isServiceScopeLimited ? this.form.serviceArea : 0;
        formData.orgId = this.isOrgLimited ? this.form.orgId.join(',') : -1;
        
        this.submitting = true;
        const ret = await axios.post('/api/shop/pro/savePro', formData);
        this.submitting = false;
        if (ret.success) {
          this.$message.success(`${this.options.mode == 'add' ? '新建' : '修改'}店铺成功`);
          this.visible = false;
          this.options.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    }
  }
}
</script>
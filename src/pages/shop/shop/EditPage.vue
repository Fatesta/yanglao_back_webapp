<!--
增加用户
-->

<template>
  <normal-page>
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 500px;margin: 0 auto"
    >
      <el-form-item
        prop="imgUrl"
        label="店铺图片"
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
            <el-button>上传</el-button>
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
        <el-input type="textarea" :rows="4" v-model.trim="form.description"></el-input>
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
        prop="providerType"
        label="店铺类型"
        :rules="[{required: true, message: ' '}]"
      >
        <type-select
          v-model="form.providerType"
          :items="DictMan.items('provider.type')"
          style="width: 100%;" 
        />
      </el-form-item>
      <el-form-item
        prop="diqu"
        label="所在地区"
        :rules="[{required: true, message: ' '}]"
      >
        <city-select v-model="form.diqu" style="width: 100%;"></city-select>
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
        v-if="$params.mode == 'add'"
        prop="bossId"
        label="所属商家"
        :rules="[{required: true, message: ' '}]"
      >
        <span>{{selectedBossName}}</span>
        <el-button type="primary" plain icon="el-icon-user" @click="onSelectBossClick">选择</el-button>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting">确定</el-button>
      </el-form-item>
    </el-form>

    <boss-query-selector ref="bossQuerySelector" />
  </normal-page>
</template>

<script>
import { waitNotNull } from '@/utils/async-utils';

export default {
  pageProps: {
    title: '编辑店铺'
  },
  components: {
    OrgCheckTree: () => import('@/pages/org/OrgCheckTree.vue'),
    CitySelect: () => import('@/components/cityselect/CitySelect.vue'),
    BossQuerySelector: () => import('@/pages/shop/BossQuerySelector.vue')
  },
  data() {
    return {
      form: {
        id: null,
        bossId: '',
        orgId: -1,
        name: '',
        description: '',
        imgUrl: '',
        industryId: '',
        providerType: '0',
        diqu: {prov: '湖北省', city: '武汉市'},
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
    onSelectBossClick() {
      this.$refs.bossQuerySelector.show({
        onOk: (boss) => {
          this.form.bossId = boss.adminId;
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
        const ret = await this.axios.post('/api/shop/pro/savePro', formData);
        this.submitting = false;
        if (ret.success) {
          this.$message.success(`${this.$params.mode == 'add' ? '新建' : '修改'}店铺成功`);
          this.$params.onSuccess();
        } else {
          this.$message.error(ret.message);
        }
      });
    }
  },
  async mounted() {
    if (this.$params.mode == 'add') {
      return;
    }
    this.submitting = true;
    let shop = await this.axios.get('/api/shop/pro/info', {params: {id: this.$params.shop.id}});
    shop.providerType = shop.providerType + '';
    this.submitting = false;
    for (let key in this.form) {
      if (shop[key]) {
        this.form[key] = shop[key];
      }
    }
    this.form.id = shop.id;
    this.form.serviceTime = shop.serviceTime.match(/(\d{2}:\d{2})/);
    this.form.bossId = shop.adminId;
    this.isOrgLimited = shop.orgId != -1;
    this.isServiceScopeLimited = shop.serviceArea != 0;

    this.form.orgId = shop.orgId;
    this.form.diqu = {prov: shop.province, city: shop.city, dist: shop.area};
  },
}
</script>
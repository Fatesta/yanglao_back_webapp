<!--
编辑志愿者信息
-->
<template>
  <card-page>
    <el-form
      ref="form"
      :model="form"
      label-width="80px"
      style="width: 500px; margin: 0 auto"
    >
      <el-form-item
        prop="volunteerDesc"
        label="提供服务"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input v-model.trim="form.volunteerDesc" type="textarea" :rows="4" placeholder="输入提供的服务内容" />
      </el-form-item>
      <el-form-item
        prop="profession"
        label="服务领域"
        :rules="[{required: true, message: ' '}]"
      >
        <el-checkbox-group v-model="form.profession">
          <el-checkbox
            v-for="item in [{text: '理发', value: 'lf'}]"
            :key="item.value"
            :label="item.value"
            name="profession"
          >{{item.text}}</el-checkbox>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item
        prop="orgId"
        label="社区"
        :rules="[{required: true, message: ' '}]">
        <org-select v-model="form.orgId" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="onSubmit" >完成</el-button>
      </el-form-item>
    </el-form>
  </card-page>
</template>

<script>
export default {
  pageProps: {
    title: '编辑志愿者信息'
  },
  components: {
    OrgSelect: () => import('@/pages/org/OrgSelect')
  },
  data() {
    return {
      form: {
        volunteerDesc: '',
        profession: [],
        orgId: null
      },
      submitting: false,
    };
  },
  methods: {
    onSubmit() {

    }
  }
}
</script>

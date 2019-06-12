
<template>
  <el-card class="box-card"
    style="
      height: 100%;
      margin: 0 auto;">
    <el-form label-width="150px"
      style="width: 500px;margin: 0 auto;">
      <el-form-item label="外观主题">
        <el-radio-group v-model="theme" @change="onThemeChange">
          <el-radio label="light">浅色</el-radio>
          <el-radio label="dark">深色</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="导航菜单默认展开">
        <el-switch v-model="sideMenuCollapsed" @change="onSideMenuCollapsedChange" />
      </el-form-item>
      <el-form-item label="自动登陆">
        <el-switch
          v-model="autoLoginEnabled"
          @change="onAutoLoginChange" />
        <span v-if="autoLoginEnabled">(在下次生效)</span>
      </el-form-item>
    </el-form>
  </el-card>
</template>


<script>
import config from '@/config/app.config';
export default {
  data() {
    return {
      theme: config.get('theme'),
      sideMenuCollapsed: !config.get('sideMenuCollapsed'),
      autoLoginEnabled: config.get('autoLoginEnabled')
    };
  },
  methods: {
    onThemeChange(value) {
      config.set('theme', value);
      app.$refs.navMenu.theme = value;
      app.theme = value;
    },
    onSideMenuCollapsedChange(value) {
      config.set('sideMenuCollapsed', !value);
      app.$refs.navMenu.collapsed = !value;
    },
    onAutoLoginChange(checked) {
      this.autoLoginEnabled = checked;
      config.set('autoLoginEnabled', checked);
      if (checked) {
        config.set('rememberPasswordEnabled', true);
      }
    },
  }
}
</script>
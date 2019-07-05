
<template>
  <normal-page>
    <el-form label-width="150px"
      style="width: 500px;margin: 0 auto;">
      <el-form-item label="外观主题">
        <el-radio-group v-model="theme" @change="onThemeChange">
          <el-radio label="light">浅色</el-radio>
          <el-radio label="dark">深色</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="外观尺寸">
        <el-slider
          v-model="size"
          @change="onSizeChange"
          style="width:250px;margin-left: 8px;"
          :step="100/4"
          :max="75"
          :format-tooltip="(val) => ['超小', '小（默认）', '中', '大'][val / 25]" />
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
  </normal-page>
</template>


<script>
import config from '@/config/app.config';
import Vue from 'vue';

export default {
  pageProps: {
    title: '设置'
  },
  data() {
    return {
      theme: config.get('theme'),
      size: ['mini', 'small', 'medium', ''].indexOf(config.get('size')) * 25,
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
    onSizeChange(value) {
      const size = ['mini', 'small', 'medium', ''][value / 25];
      config.set('size', size);
      Vue.prototype.$ELEMENT = { size };
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
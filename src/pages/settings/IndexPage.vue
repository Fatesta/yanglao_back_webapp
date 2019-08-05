
<template>
  <card-page
    style="
      width: 700px;
      margin: 4px auto;"
  >
    <el-row>
      <el-col :span="5">外观主题</el-col>
      <el-col :span="19">
        <el-radio-group v-model="theme" @change="onThemeChange">
          <el-radio label="light">浅色</el-radio>
          <el-radio label="dark">深色</el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="5">外观尺寸</el-col>
      <el-col :span="19">
        <el-slider
          v-model="size"
          @change="onSizeChange"
          style="width:200px;"
          :step="100/4"
          :max="75"
          :format-tooltip="(val) => ['超小', '小（默认）', '中', '大'][val / 25]" />
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="5">导航菜单默认展开</el-col>
      <el-col :span="19">
        <el-switch v-model="sideMenuCollapsed" @change="onSideMenuCollapsedChange" />
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24"><el-divider /></el-col>
    </el-row>
    <el-row>
      <el-col :span="5">自动登陆</el-col>
      <el-col :span="19">
        <el-switch
          v-model="autoLoginEnabled"
          @change="onAutoLoginChange" />
        <span v-if="autoLoginEnabled" class="info">(在下次生效)</span>
      </el-col>
    </el-row>
    <template v-if="[1,6,9,11,13,14,15].indexOf(app.admin.roleId) > -1">
      <el-row>
        <el-col :span="24"><el-divider /></el-col>
      </el-row>
      <el-row>
        <el-col :span="5">态势图自动打开</el-col>
        <el-col :span="19">
          <el-switch
            v-model="autoOpenStatEnabled"
            @change="onAutoOpenStatChange" />
        </el-col>
      </el-row>
    </template>
    <template v-if="browser.isChrome">
      <el-row>
        <el-col :span="24"><el-divider /></el-col>
      </el-row>
      <el-row>
        <el-col :span="5">智能语音助手</el-col>
        <el-col :span="19">
          <el-tooltip :content="`${!voiceAssistantRunning ? '启动' : '退出'}智能语音助手`">
            <el-button
              type="primary"
              plain
              circle
              :icon="voiceAssistantRunning ? 'el-icon-turn-off-microphone' : 'el-icon-microphone'"
              @click="onVoiceAssistantClick"
            />
          </el-tooltip>
          <el-link :underline="false" class="el-icon-question" style="margin-left: 8px;font-size: 22px;" @click="onOpenVoiceAssistantManualClick"></el-link>
        </el-col>
      </el-row>
    </template>
  </card-page>
</template>


<script>
import config from '@/config/app.config';
import Vue from 'vue';
import voiceAssistant from '@/voiceassistant/voice-assistant';

export default {
  pageProps: {
    title: '设置'
  },
  data() {
    return {
      app,
      browser: {
        isChrome: navigator.userAgent.indexOf("Chrome") > -1
      },
      voiceAssistantRunning: voiceAssistant.isRunning(),
      theme: config.get('theme'),
      size: ['mini', 'small', 'medium', ''].indexOf(config.get('size')) * 25,
      sideMenuCollapsed: !config.get('sideMenuCollapsed'),
      autoLoginEnabled: config.get('autoLoginEnabled'),
      autoOpenStatEnabled: config.get('autoOpenStatEnabled')
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
    onAutoOpenStatChange(checked) {
      this.autoOpenStatEnabled = checked;
      config.set('autoOpenStatEnabled', checked);
    },
    onVoiceAssistantClick() {
      voiceAssistant.turn();
      this.voiceAssistantRunning = !this.voiceAssistantRunning;
    },
    onOpenVoiceAssistantManualClick() {
      app.pushPage('/voice-assistant-manual');
    }
  }
}
</script>

<style scoped>
.el-row {
  font-size: 14px;
  line-height: 40px;
}
.el-col-5 {
  padding-right: 24px;
  text-align: right;
  vertical-align: middle;
  color: #606266;
}
.el-divider--horizontal {
  margin: 10px 0;
}

.info {
  margin-left: 8px;
  color: #909399;
}
</style>
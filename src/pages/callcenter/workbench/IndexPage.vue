<template>
  <plain-page style="display:flex">
    <el-card shadow="never" style="width: 320px;">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="呼叫中心" name="cc" v-loading="loading">
          <div id="callcenter-workbench-container">
            <iframe
              ref="ccIframe"
              allow="microphone"
              style="
                visibility: visible;
                display: block;
                overflow: auto;
                height: 100%;
                margin: 0px;
                outline: none;
                border-width: 0px;"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="坐席" name="agent">
          <el-row style="width: 260px;margin: 10px auto;">
            <el-col :span="7">
              <el-avatar :size="60" :src="agentAvatar" />
            </el-col>
            <el-col :span="12">
              <el-row style="font-size: 15px;">
                <el-col style="color:#606266;margin-bottom: 8px">{{agent.displayName}}</el-col>
                <el-col style="color:#606266"><i class="el-icon-phone" />02759769039</el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-card shadow="never" style="margin-left: 4px;">
      <el-tabs v-model="rightActiveTab">
        <el-tab-pane key="record" name="record" label="通话记录">
          <record ref="record" style="max-width: 1020px;" />
        </el-tab-pane>
        <el-tab-pane v-if="callComingPaneShow" key="callcoming" name="callcoming" label="最近来电">
          <call-coming-pane
            ref="callComingPane"
            @close="callComingPaneShow = false, rightActiveTab = 'record'"
          />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </plain-page>
</template>


<script>
import agentAvatar from '../img/5.png';
import CallComingPane from './CallComingPane';

export default {
  pageProps: {
    title: '客服工作台'
  },
  components: {
    Record: () => import('../Record'),
    CallComingPane
  },
  data() {
    return {
      activeTab: 'cc',
      rightActiveTab: 'record',
      callComingPaneShow: false,
      loading: true,
      agent: {},
      agentAvatar
    };
  },
  async mounted() {
    const { ccIframe } = this.$refs;
    ccIframe.src = "/statics/callcenter-workbench.html";
    ccIframe.addEventListener('load', () => {
      this.loading = false;
      this.initWorkbench(ccIframe.contentWindow.WorkbenchSdk);
    });

    window.debug_getCC = () => { return this; }
    var isChrome = (navigator.userAgent.indexOf('Chrome/')>=0 && navigator.userAgent.indexOf('WebKit')>=0);
    if (!isChrome) {
      this.$alert('呼叫中心只支持谷歌Chrome浏览器');
      this.loading = false;
      return;
    }
    this.agent = await this.axios.get('/api/callcenter/agentConfig/getCurrentAgent');
  },
  methods: {
    initWorkbench(WorkbenchSdk) {
      this.loading = false;
      app.$refs.navMenu.collapse();

      let workbench = new WorkbenchSdk({
        width: '280px',
        dom: 'callcenter-workbench-container',
        instanceId: '8be96811-aa89-4c56-8349-f2d46a7c934d',
        ajaxPath: '/api/callcenter/workbench/api',
        ajaxMethod: 'post',
        afterCallRule: 10,
        header: true,
        //autoAnswerCall: 5,
        onInit() {
          console.log('WorkbenchSdk onInit');
          workbench.register();
        },
        onErrorNotify(error) {
          console.warn(error)
        },
        onCallComing: (connid, callerNumber, calleeNumber, contacId) => {
          console.info('onCallComing');
          this.pushPage({ path: '/callcenter/workbench/index' });
          this.activeTab = 'cc';//select workbench
          this.callComingPaneShow = true;
          this.rightActiveTab = 'callcoming';
          this.$nextTick(() => {
            this.$refs.callComingPane.loadByNumber(callerNumber);
          });
        },
        onCallRelease: () => {
          this.$refs.record.query();
        },
        onCallEstablish(connid, caller, calee, contactId) {
        },
        onHangUp: () => {
          this.$refs.record.query();
        }
      });
    }
  }
}
</script>

<style scoped>
#callcenter-workbench-container {
  position: relative;
  margin-right: 8px;
  min-height: 552px;
  height: 552px;
}

>>> .el-tabs__content {
  padding-top: 8px;
}
>>> .el-card__body {
  padding: 0px 10px;
}
</style>
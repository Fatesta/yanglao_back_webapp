<template>
  <plain-page style="display:flex">
    <el-card shadow="never" style="width: 320px;">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="呼叫中心" name="cc" v-loading="loading">
          <div id="callcenter-workbench-container"></div>
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
      <el-tabs value="r">
        <el-tab-pane label="通话记录" name="r">
          <record style="max-width: 1020px;" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </plain-page>
</template>


<script>
import agentAvatar from '../img/5.png';

export default {
  pageProps: {
    title: '客服工作台'
  },
  components: {
    record: () => import('../Record')
  },
  data() {
    return {
      activeTab: 'cc',
      loading: true,
      agent: {},
      agentAvatar
    };
  },
  async mounted() {
    var isChrome = (navigator.userAgent.indexOf('Chrome/')>=0 && navigator.userAgent.indexOf('WebKit')>=0);
    if (!isChrome) {
      this.$alert('呼叫中心只支持谷歌Chrome浏览器');
      this.loading = false;
      return;
    }

    // 加载软电话sdk资源
    const version_sdk = '0.7.0';
    const version_sip = '0.0.3';
    const version_voip = '2.6.3';
    // 样式
    let style = document.createElement('link');
    style.href = `https://g.alicdn.com/acca/workbench-sdk/${version_sdk}/main.min.css`;
    style.rel = 'stylesheet';
    style.type = 'text/css';
    document.head.appendChild(style);
    // 脚本
    [
      `https://g.alicdn.com/cloudcallcenter/SIPml/${version_sip}/SIPml-api.js`,
      `https://g.alicdn.com/cloudcallcenter-voip/agentbar-sdk/${version_voip}/index.js`,
      `https://g.alicdn.com/acca/workbench-sdk/${version_sdk}/workbenchSdk.min.js`
    ].forEach((jsUrl, index) => {
      let script = document.createElement('script');
      script.src = jsUrl;
      script.onload = () => {
        if (index < 2)  return;

        this.loading = false;
        app.$refs.navMenu.collapsed = true;

        let lastCallComingUser = null;

        let workbench = new WorkbenchSdk({
          width: '280px',
          dom: 'callcenter-workbench-container',
          instanceId: '8be96811-aa89-4c56-8349-f2d46a7c934d',
          ajaxPath: '/api/callcenter/workbench/api',
          ajaxMethod: 'post',
          afterCallRule: 10,
          header: true,
          //autoAnswerCall: 5,
          moreActionList: ['mobilePhoneAnswer', 'break', 'offline'],
          onInit() {
            console.log('WorkbenchSdk onInit');
          },
          onErrorNotify(error) {
            console.warn(error)
          },
          onCallComing: (connid, callerNumber, calleeNumber, contacId) => {
            this.activeTab = 'cc';//select workbench
            
            setTimeout(function() {
              if (lastCallComingUser) {
                openModuleByCode('taishitu', {
                  onLoad() { 
                    getModuleContext('taishitu').stat.deviceQuery.gotoPositionByTelephone(callerNumber);
                  }
                });
              }
            }, 500);

            if(!(window.Notification && Notification.permission !== "denied")) {
              return;
            }
            Notification.requestPermission((status) => {
              if(status != 'granted')
                  return;
              this.axios('/api/user/getUserByPhone?phone=' + callerNumber, function(user) {
                lastCallComingUser = user;
                var foundUser = !!user;
                var body = '来电话了！' + '号码：' + callerNumber;
                if (foundUser) {
                  if (user.realName) {
                    body += '\n姓名：' + user.realName;
                  } else if (user.aliasName) {
                    body += '\n用户名：' + user.aliasName;
                  } else {
                    body += user.aliasName;
                  }
                  body += '\n性别：' + (user.sex == 0 ? '男' : '女');
                  body += '\n年龄：' + user.age + '岁';
                  body += '\n家庭地址：' + user.address;
                  //body += '\n所在社区：' + user.orgName;
                } else {
                  body += '\n未查询到用户信息，可能为非平台用户';
                }
                // 弹出一个通知
                var notif = new Notification('呼叫中心', {
                  body : body,
                  icon : '/images/callcoming.png'
                });
                // 自动关闭通知
                var timer = setTimeout(() => {
                  notif.close();
                }, 1000*60*2);
                notif.onclick = () => {
                  this.pushPage({
                    path: '/callcenter/workbench/index'
                  });
                };
              });
            });
          },
          onCallRelease() {
            lastCallComingUser = null;
          },
          onCallEstablish(connid, caller, calee, contactId) {
            setTimeout(function() {
              if (lastCallComingUser) {
                //showOpButtons(lastCallComingUser);
              }
            }, 1000);
          },
          onStatusChange(code, lastCode, context){
            console.log(code, lastCode, context);
          },
          onHangUp() {
              
          }
        });
        workbench.showWebNotification = function() {};
      };

      document.body.appendChild(script);
    });

    this.agent = await this.axios.get('/api/callcenter/agentConfig/getCurrentAgent');
  }
}
</script>

<style scoped>
#callcenter-workbench-container {
  position: relative;
  margin-right: 8px;
  min-height: 560px;
}
>>> .el-tabs__content {
  padding-top: 8px;
}
>>> .el-card__body {
  padding: 0px 10px;
}
</style>

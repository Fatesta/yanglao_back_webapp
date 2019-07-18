
<template>
  <el-container>
    <el-header
      :style="{
        height: '60px',
        lineHeight: '60px',
        padding: '0px 0px 0px 20px',
        backgroundColor: '#409EFF',
        position: 'relative',
        userSelect: 'none'
      }"
    >

      <span
        :style="{
          fontSize: '23px',
          color: '#fff',
          letterSpacing: '1.5px',
          cursor: 'pointer'
        }"
        @click="onTitleClick"
        >
        {{appName}}
      </span>

      <!-- 右侧工具信息 -->
      <div :style="{
        position: 'absolute',
        height: '60px',
        display: 'inline-block',
        right: 0,
        color: 'rgba(255, 255, 255, 0.9)',
        cursor: 'pointer'
      }">
        <div
          ref="timeTextContainer"
          class="header-item-hover"
          style="
            float: left;
            display: inline-block;
            line-height: 60px;
            font-size: 14px;
            padding: 0px 17px;"
        >
        </div>
        <el-dropdown
          ref="userDropdown"
          @command="onCommandClick"
          :show-timeout="100"
          class="header-item-hover"
          :style="{
            display: 'inline-block',
            float: 'left',
            padding: '0px 12px 0px 12px',
            color: 'inherit'
          }"
        >
          <div class="header-item-hover">
            {{admin ? admin.realName : '加载中'}}
            <i class="el-icon-arrow-down" />
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item icon="el-icon-key" command="modifyPassword">修改密码</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
        <el-popover
          ref="messagePopover"
          placement="bottom-end"
          width="200"
          trigger="hover"
          content="暂无新消息。">
          <div
            slot="reference"
            class="header-item-hover"
            style="
              display: inline-block;
              width: 48px;
              text-align: center;"
            >
            <i class="el-icon-alarm-clock icon-button" />
          </div>
        </el-popover>
        <div
          ref="logoutButton"
          class="header-item-hover"
          style="
            display: inline-block;
            padding: 0px 17px;
            float: right;
          "
          @click="logout"
        >
          <i class="el-icon-switch-button icon-button"></i>
        </div>
        <div
          ref="settingButton"
          class="header-item-hover"
          style="
            display: inline-block;
            padding: 0px 17px;
            float: right;
          "
          @click="onSettingClick"
        >
          <i class="el-icon-setting icon-button"></i>
        </div>
      </div>
    </el-header>
    <el-container>
      <nav-menu ref="navMenu" :height="(contentMaxHeight - 60)" />
      <el-main
        :style="{
          padding: '2px 0px 0px 0px'
        }"
      >
        <el-tabs
          v-show="tabs.length"
          :value="activeTabKey"
          type="card"
          closable
          @tab-click="onTabClick"
          @tab-remove="onTabRemove"
        >
          <el-tab-pane
            v-for="tab in tabs"
            :key="tab.key"
            :name="tab.key"
            :label="tab.title"
            :style='{
              height: (contentMaxHeight - 104) + "px",
              overflow: "auto"
            }'
            v-loading="tab.loading"
          >
            <component :is="tab.content" />
          </el-tab-pane>
        </el-tabs>

      </el-main>
    </el-container>
    <password-update-dialog ref="passwordUpdateDialog" :visible="true" />
  </el-container>
</template>


<script>
import Vue from 'vue';
import ElementUI, { Message } from 'element-ui';
import '@/components/index'; // 公共vue组件，应全部打包到本入口文件只有一份
import NavMenu from './NavMenu';
import PasswordUpdateDialog from '@/pages/admin/PasswordUpdateDialog';
import config, { APP_NAME } from '@/config/app.config';
import pages from '@/pages';
import { stringify } from 'qs';
import leftPad from 'left-pad';
import { setTimeout } from 'timers';

Vue.use(ElementUI, { size: config.get('size') });

export default {
  components: {
    NavMenu,
    PasswordUpdateDialog
  },
  data() {
    return {
      appName: APP_NAME,
      contentMaxHeight: document.body.offsetHeight,
      theme: config.get('theme'),
      admin: null,
      tabs: [],
      activeTabKey: null,
      isInitialled: false
    };
  },
  async mounted() {
    const {timeTextContainer} = this.$refs;
    const minuteTick = () => {
      let now = new Date();
      let timeText = `${now.getMonth() + 1}月${now.getDate()}日`;
      timeText += ` 周${['日','一','二','三','四','五','六'][now.getDay()]}`;
      timeText += ` ${leftPad(now.getHours(), 2, 0)}:${leftPad(now.getMinutes(), 2, 0)}`;
      timeTextContainer.innerText = timeText;
      setTimeout(minuteTick, (60 - now.getSeconds()) * 1000);
    };
    minuteTick();
    
    // 实例方法
    Vue.prototype.pushPage = this.pushPage.bind(this);
    Vue.prototype.$closeCurrentPage = this.closeCurrentPage.bind(this);

    // 暴漏给以前的（未使用webpack前）代码
    window.app = this;

    // 兼容老版本api
    window.openModuleByCode = function (code, options) {
      var node = Object.assign({}, findFunc(app.$refs.navMenu.menuTreeNodes, code));
      app.openTab(node, options);
      function findFunc(nodes, code) {
        for (var i in nodes) {
          var node = nodes[i];
          if (node.attributes && node.attributes.code && node.attributes.code.toString() == code)
              return node;
          node = findFunc(node.children, code);
          if (node)
              return node;
        }
        return null;
      }
    }

    DictMan.fetch();

    const ret = await this.axios.get('/api/currentUser');
    if (ret.admin == null) {
      this.$router.push('/login');
      return;
    }
    this.admin = ret.admin;

    // 提供给老代码用
    window.admin = ret.admin;

    const nodes = await this.axios.get('/api/admin/listAdminMenu');

    this.$refs.navMenu.menuTreeNodes = nodes.map((node, index) => {
      node.iconCls = ['user', 'goods', 'data-board', 'monitor', 'sunny', 'star-off', 'setting', 'help'][index];
      return node;
    });
    if([1,6,9,11,13,14,15].indexOf(this.admin.roleId) > -1 && config.get('autoOpenStatEnabled')) {
      openModuleByCode('taishitu', {
        onLoad: () => {
          this.isInitialled = true;
        }
      });
    } else if (this.admin.roleId == 13) {
      this.pushPage({ path: '/callcenter/workbench/index' });
    } else {
      this.isInitialled = true;
      this.pushPage({
        path: '/home'
      });
    }

    if (this.admin.roleId == 10) {
      openModuleByCode('ycyl.chat.doctorView');
    }

    document.onkeydown = this.onKeyDown;
    window.onresize = this.onResize;
  },
  methods: {
    onTitleClick() {
      this.$refs.navMenu.onCollapse();
    },
    onKeyDown(e) {
      if (27 == e.keyCode) {
        if (this.tabs.length > 0) {
          this.onTabRemove(this.tabs[this.tabs.length - 1].key);
        } else if (location.hash != '#/login') {
          this.logout();
        } else {
          location.reload();
        }
      }
      else if (83 == e.keyCode && e.ctrlKey) {
        this.onSettingClick();
      }
    },
    onResize() {
      this.contentMaxHeight = document.body.offsetHeight;
    },
    onCommandClick(cmd) {
      switch (cmd) {
        case 'modifyPassword':
          this.$refs.passwordUpdateDialog.visible = true;
          break;
      }
    },
    onSettingClick() {
      this.pushPage('/settings/index');
    },
    logout() {
      this.$router.replace('/logout');
    },
    onTabClick(tab) {
      let pageInstance = tab.$children[0];
      pageInstance.onPageResume && pageInstance.onPageResume();
    },
    onTabRemove(key) {
      let tabs = this.tabs;
      let activeTabKey = this.activeTabKey;
      if (activeTabKey == key) {
        tabs.forEach((tab, index) => {
          if (tab.key == key) {
            let nextTab = tabs[index + 1] || tabs[index - 1];
            if (nextTab) {
              activeTabKey = nextTab.key;
            }
          }
        });
      }
      
      this.activeTabKey = '';
      this.tabs = tabs.filter(tab => tab.key !== key);
      this.$nextTick(() => {
        this.activeTabKey = activeTabKey;
      });
    },
    pushPage(options) {
      if (typeof options == 'string') {
        options = { path: options };
      }
      const { path } = options;

      // path + 可选的key 作为tab的key
      const tabKey = path + (options.key ? '__' + options.key : '');
      // 根据key检查该tab是否已经打开
      const addedTab = this.tabs.find(tab => tab.key == tabKey);
      if (addedTab) {
        // 如果之前已经打开了，则现在选中该tab
        this.activeTabKey = '';
        setTimeout(() => {
          this.activeTabKey = tabKey;
        });
      } else {
        const page = pages[path];
        if (!page) {``
          this.$message.error('未找到指定页面：' + path);
          return;
        }
        let tab = {
          title: options.title || '...',
          key: tabKey + '',
          content: null, // vue组件
          loading: true // vue组件加载状态
        };
        this.tabs.push(tab);
        this.activeTabKey = tabKey;
        loadAsyncComponentSetTabContent(tab, page);
      }

      /* 异步加载vue组件，并设置为tab的content */
      function loadAsyncComponentSetTabContent(tab, page) {
        page().then(({default: component}) => {
          // 设置标题
          let title = (options.title
            || (component.pageProps && component.pageProps.title)
            || '未定义标题');
          if (options.subTitle) {
            title = `${options.subTitle} - ${title}`;
          }
          tab.title = title;

          component.props = component.props || {};
          // 给组件设置props
          // TODO: FIX: 在热更新模式下，没有重复执行该代码，因此该属性无法设置
          component.props['$params'] = {
            type: Object,
            default: () => (options.params || {})
          };
          
          tab.content = component;

          tab.loading = false;
        });
      }
    },
    closeCurrentPage() {
      this.onTabRemove(this.activeTabKey);
    },
    /* 打开一个标签页承载一个页面，这个方法现在被NavMenu，以及原使用easyui代码的方法调用 */
    openTab(item, options) {
      const addedTab = this.tabs.find(tab => tab.key == item.id);
      if (addedTab) {
        this.activeTabKey = '';
        setTimeout(() => {
          this.activeTabKey = item.id + '';

          options && options.onLoad && options.onLoad();
        });
        return;
      }

      var url = item.attributes.url;
      if (!url) {
        return;
      }
      var paramIdx = url.indexOf("?");
      var path = url.substring(0, paramIdx == -1 ? undefined : paramIdx);
      var params = paramIdx == -1 ? "" : url.substr(paramIdx);
      if (path.endWiths('.js')) {
        this.pushPage({
          path: path.substring(0, path.length - 3),
          params,
          title: item.text
        });
      } else if (!path.endWiths(".do") && path.startsWith('http')) {
          window.open(path);
      } else if (!path.endWiths(".do")) {
        url = path + ".do" + params;//此处在path结尾加上.do，以变成控制器url
        var win = window.open(url, new Date().getTime());
      } else {
          url = path + (!params ? "?" : params + "&");
          if (options && options.params)
            url += stringify(options.params);
          if (!item.isNoNode)
            url += "&_func_id=" + item.id;
          var funcCode = item.attributes.code;

          let tab = {
            title: item.text,
            key: (item.id || item.text).toString(),
            content: {
              render(h) {
                return h(
                  'iframe',
                  {
                    attrs: {
                      id: (funcCode ? 'module-iframe-' + funcCode : ''),
                      src: url
                    },
                    style: `
                      visibility:hidden;
                      display: block;
                      overflow:auto;
                      width:100%;
                      height:100%;
                      margin:0px;
                      outline: none;
                      border-width:0px;`
                  }
                );
              },
              mounted() {
                this.$el.contentWindow.addEventListener('load', () => {
                  this.$el.style.visibility = 'visible';
                  tab.loading = false;
                  options && options.onLoad && options.onLoad();
                });
              }
            },
            loading: true
          };
          this.tabs.push(tab);
          this.activeTabKey = tab.key;
      }
    }
  },
  beforeRouteEnter(to, from, next) {
    next();
    if (from.path == '/login') {
      setTimeout(() => {
        Message.info({message: '登陆成功，欢迎使用', duration: 1000});
      }, 100);
    }
  }
}

</script>

<style scoped>
.el-container {
  width: 100%;
  height: 100%;
  background-image: none;
  background-color: #fff;
}

.icon-button {
  font-size: 16px;
  font-weight: bold;
  text-shadow: 0 1px 0px rgba(0,0,0,.25)
}
</style>

<style>
.el-main > .el-tabs > .el-tabs__header {
  left: 2px;
}
.el-main > .el-tabs > .el-tabs__content {
  padding: 0px;
  background: #f5f7f9;
}
.header-item-hover:hover {
  background-color: #53a8ff;
  color: #fff;
}

.op-tip-row {
  line-height: 32px;
}
.op-text-col {
  text-align: left;
}
.op-keys-col {
  text-align: left;
}
.key {
  display: inline-block;
  padding: 2px 4px;
  min-width: 32px;
  background: #606266;
  color: #fff;
  border-radius: 2px;
  font-size: 14px;
  text-align: center;
  line-height: 20px;
  vertical-align: middle;
}
</style>
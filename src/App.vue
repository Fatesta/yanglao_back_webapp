
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
        <el-tooltip content="当前时间">
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
        </el-tooltip>
        <el-dropdown
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
            <i class="el-icon-user-solid" />
            {{admin ? admin.realName : '加载中'}}
            <i class="el-icon-arrow-down" />
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item icon="el-icon-key" command="modifyPassword">修改密码</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
        <!--
        <el-popover
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
        -->
        <el-tooltip content="退出登陆">
          <div
            class="header-icon-item header-item-hover"
            @click="logout"
          >
            <i class="el-icon-switch-button icon-button"></i>
          </div>
        </el-tooltip>
        <el-tooltip content="打开设置">
          <div
            class="header-icon-item header-item-hover"
            @click="onSettingClick"
          >
            <i class="el-icon-setting icon-button"></i>
          </div>
        </el-tooltip>
        <el-tooltip content="进入/退出全屏">
          <div
            class="header-icon-item header-item-hover"
            @click="onFullScreenClick"
          >
            <i class="el-icon-full-screen icon-button"></i>
          </div>
        </el-tooltip>
      </div>
    </el-header>
    <el-container>
      <nav-menu ref="navMenu" :height="(contentMaxHeight - 60)" />
      <el-main
        :style="{
          padding: '0px 0px 0px 0px'
        }"
      >
        <el-tabs
          ref="tabs"
          v-show="tabs.length"
          :value="activeTabKey"
          type="border-card"
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
              height: (contentMaxHeight - 100) + "px",
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
import config, { APP_NAME } from '@/config/app.config';
import pages from '@/pages';
import { stringify } from 'qs';
import leftPad from 'left-pad';
import fullScreen from '@/utils/fullscreen';

Vue.use(ElementUI, { size: config.get('size') });

export default {
  components: {
    NavMenu,
    PasswordUpdateDialog: () => import('@/pages/admin/PasswordUpdateDialog')
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

    // 对于非页面组件，仍要使用pushPage
    Vue.prototype.pushPage = this.pushPage;

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
    onFullScreenClick() {
      fullScreen.switch();
    },
    onSettingClick() {
      this.pushPage('/settings/index');
    },
    logout() {
      this.$router.replace('/logout');
    },
    onTabClick(clickTab) {
      this.setOtherPagePause(clickTab.name);

      let pageInstance = clickTab.$children[0];
      if (pageInstance.onPageResume) {
        pageInstance.onPageResume();
        pageInstance._pageState = 'resume';
      }
    },
    onTabRemove(key) {
      //TODO: 关闭时激活tab选择的优化
      let tabs = this.tabs;
      let activeTabKey = this.activeTabKey;
      if (activeTabKey == key) {
        tabs.forEach((tab, index) => {
          if (tab.key == key) {
            let nextTab = tabs[index - 1] || tabs[index + 1];
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

      // 统计
      RUN_ENV == 'production' && setTimeout(() => {
        this.axios.post('/api/open-count/inc', {path});
      }, 10);

      // path + 可选的key 作为tab的key
      const tabKey = path + (options.key ? '__' + options.key : '');
      // 根据key检查该tab是否已经打开
      const addedTab = this.tabs.find(tab => tab.key == tabKey);
      if (addedTab) {
        this.setOtherPagePause(tabKey);
        // 如果之前已经打开了，则现在选中该tab
        this.activeTabKey = '';
        setTimeout(() => {
          this.activeTabKey = tabKey;
        });
      } else {
        const page = pages[path];
        if (!page) {
          this.$message.error('未找到指定页面：' + path);
          return;
        }
        let tab = {
          title: options.title || '...',
          key: tabKey + '',
          content: null, // vue组件
          loading: true, // vue组件加载状态
          parentTab: options.parentTab
        };
        this.setOtherPagePause(tabKey);
        
        this.insertNewTab(tab);
        this.activeTabKey = tabKey;

        /* 异步加载组件，并设置为tab的content */
        page().then(({default: component}) => {
          /*
           组件类将实例化多次，使用不同的参数。
           所以下面的修改（包括mixins）必须基于原组件类对象，这里保证修改的是拷贝对象，下次使用的原对象是没有经过修改的
          */
          component = {...component};

          // 混入一些数据和方法
          (component.mixins = component.mixins || []).push({
            props: {
              // 父页面传递的参数
              $params: {
                type: Object,
                default: () => (options.params || {})
              }
            },
            methods: {
              pushPage: (options) => {
                if (typeof options == 'string') {
                  options = { path: options };
                }
                // 记录父tab
                options.parentTab = tab;
                this.pushPage(options);
              },
              openTab: (options) => {
                this.openTab(
                  {attributes: {url: options.url}, text: options.title, id: new Date().getTime(), isNoNode: true},
                  {parentTab: tab}
                );
              },
              $closeCurrentPage: this.closeCurrentPage.bind(this)
            }
          });

          tab.content = component;
          // 设置标题
          let title = (options.title
            || (component.pageProps && component.pageProps.title)
            || '未定义标题');
          if (options.subTitle) {
            title = `${options.subTitle} - ${title}`;
          }
          tab.title = title;

          tab.loading = false;
        });
      }
    },
    closePage(key) {
      this.onTabRemove(key);
    },
    closeCurrentPage() {
      this.onTabRemove(this.activeTabKey);
    },
    /* 将新打开tab插入到tabs */
    insertNewTab(newTab) {
      let tabs = this.tabs;
      if (newTab.parentTab) {
        // 将新tab插入到parentTab的后面（右边）
        // S1.找到parentTab的索引
        const parentTabIndex = tabs.findIndex(tab => tab.key == newTab.parentTab.key);
        // S2.找到该parentTab之后的最后一个“子“tab的索引
        let index = parentTabIndex + 1;
        for (let i = index; i < tabs.length; i++) {
          if (tabs[i].parentTab && (tabs[i].parentTab.key == newTab.parentTab.key)) {
            index = i + 1;
          } else {
            break;
          }
        }
        tabs.splice(index, 0, newTab);
      } else {
        // 插入到最后
        tabs.push(newTab);
      }
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
      var searchIndex = url.indexOf("?");
      var path = url.substring(0, searchIndex == -1 ? undefined : searchIndex);
      var params = searchIndex == -1 ? "" : url.substr(searchIndex);
      if (path.endWiths('.js')) {
        this.pushPage({
          path: path.substring(0, path.length - 3),
          params,
          title: item.text
        });
      } else if (!path.endWiths(".do") && path.startsWith('http')) {
          window.open(path);
      } else if (!path.endWiths(".do")) {
        url = path + ".do" + params;
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
            loading: true,
            parentTab: options && options.parentTab
          };
          this.insertNewTab(tab);
          this.activeTabKey = tab.key;
          RUN_ENV == 'production' && setTimeout(() => {
            this.axios.post('/api/open-count/inc', {path});
          }, 10);
      }
    },
    setOtherPagePause(notPageName) {
      // 遍历除当前点击tab外的其它tab中的内容组件实例
      this.$refs.tabs.$children.slice(1).forEach((tabPane) => {
        if (tabPane.name != notPageName) {
          let pageInstance = tabPane.$children[0];
          if (pageInstance && pageInstance.onPagePause && pageInstance._pageState != 'pause') {
            pageInstance.onPagePause();
            pageInstance._pageState = 'pause';
          }
        }
      });
    }
  },
  beforeRouteEnter(to, from, next) {
    next();
    if (from.path == '/login') {
      setTimeout(() => {
        Message.success({message: '登陆成功，欢迎使用', duration: 1000});
      }, 100);
    }
  }
}

</script>

<style scoped>
.el-container {
  width: 100%;
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

.el-main > .el-tabs--border-card > .el-tabs__content {
  overflow: auto;
}
.el-main > .el-tabs--border-card {
  border: none;
}
.el-main > .el-tabs--border-card > .el-tabs__header .el-tabs__nav {
  border-left: 0px;
  border-radius: 0px;
}
.el-main > .el-tabs--border-card > .el-tabs__header .el-tabs__nav > .el-tabs__item {
  font-weight: normal;
}
.el-main > .el-tabs--border-card > .el-tabs__header .el-tabs__nav > .el-tabs__item:not(.is-active):not(:hover) {
  color: #606266;
}
.el-main > .el-tabs--border-card > .el-tabs__content {
  padding: 0px;
  background: #f5f7f9;
}
.header-icon-item {
  display: block;
  padding: 0px 17px;
  float: right;
}
.header-item-hover:hover {
  background-color: #53a8ff;
  color: #fff;
}
</style>
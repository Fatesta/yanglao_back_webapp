
<template>
  <el-container>
    <el-header
      :style="{
        height: '60px',
        lineHeight: '60px',
        padding: '0px 0px 0px 20px',
        backgroundColor: styles.header.backgroundColor,
        position: 'relative',
        userSelect: 'none'
      }"
    >

      <span
        :style="{
          fontSize: '23px',
          color: styles.header.color,
          letterSpacing: '1px',
          cursor: 'pointer'
        }"
        @click="onTitleClick"
        >
        {{appName}}
      </span>
      
      <div :style="{
        position: 'absolute',
        height: '60px',
        display: 'inline-block',
        right: 0,
        color: styles.header.color2,
        cursor: 'pointer'
      }">
        <el-popover
          ref="messagePopover"
          placement="bottom-end"
          width="200"
          trigger="hover"
          content="暂无新消息。">
          <div
            slot="reference"
            style="
              display: inline-block;
              width: 48px;
              text-align: center;"
            @mouseover="$refs.messagePopover.$el.querySelector('.el-popover__reference').style.backgroundColor = styles.header.hoverColor"
            @mouseout="$refs.messagePopover.$el.querySelector('.el-popover__reference').style.backgroundColor = 'unset'"
            >
            <i class="el-icon-bell icon-button" />
          </div>
        </el-popover>
        <div
          ref="logoutButton"
          style="
            display: inline-block;
            padding: 0px 17px;
            float: right;
          "
          @mouseover="$refs.logoutButton.style.backgroundColor = styles.header.hoverColor"
          @mouseout="$refs.logoutButton.style.backgroundColor = 'unset'"
          @click="logout"
        >
          <i class="el-icon-switch-button icon-button"></i>
        </div>
        <div
          ref="settingButton"
          style="
            display: inline-block;
            padding: 0px 17px;
            float: right;
          "
          @mouseover="$refs.settingButton.style.backgroundColor = styles.header.hoverColor"
          @mouseout="$refs.settingButton.style.backgroundColor = 'unset'"
          @click="onSettingClick"
        >
          <i class="el-icon-setting icon-button"></i>
        </div>
        <el-dropdown
          ref="userDropdown"
          @command="onCommandClick"
          :show-timeout="100"
          :style="{
            display: 'inline-block',
            float: 'right',
            padding: '0px 12px 0px 12px',
            color: styles.header.color2
          }"
          size="large"
          @mouseover.native="$refs.userDropdown.$el.style.backgroundColor = styles.header.hoverColor"
          @mouseout.native="$refs.userDropdown.$el.style.backgroundColor = 'unset'"
        >
          <div>
            {{admin && admin.realName}}
            <i class="el-icon-arrow-down" />
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item icon="el-icon-house" command="index">首页</el-dropdown-item>
            <el-dropdown-item icon="el-icon-key" command="modifyPassword" divided>密码</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </el-header>
    <el-container>
      <nav-menu ref="navMenu" :height="(contentMaxHeight - 60)" />
      <el-main style="padding: 2px;">
        <el-tabs
          :value="activeTabKey"
          type="card"
          closable
          @tab-remove="onTabRemove"
        >
          <el-tab-pane
            v-for="tab in tabs"
            :key="tab.key"
            :name="tab.key"
            :label="tab.title"
            :style='{height: (contentMaxHeight - 108) + "px"}'
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
import ElementUI from 'element-ui';
import '@/components/index'; // 公共vue组件，应全部打包到本入口文件只有一份
import NavMenu from './NavMenu';
import PasswordUpdateDialog from '@/pages/admin/PasswordUpdateDialog';
import config, { APP_NAME } from '@/config/app.config';
import pages from '@/pages';
import { stringify } from 'qs';

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
      activeTabKey: null
    };
  },
  async mounted() {
    DictMan.fetch();
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

    window.addEventListener('resize', () => {
      this.contentMaxHeight = document.body.offsetHeight;
    });

    const ret = await axios.get('/api/currentUser');
    if (ret.admin == null) {
      this.$router.push('/login');
      return;
    }
    this.admin = ret.admin;

    const nodes = await axios.get('/api/admin/listAdminMenu');
    this.$refs.navMenu.menuTreeNodes = nodes.map((node, index) => {
      node.iconCls = ['user', 'goods', 'data-board', 'monitor', 'sunny', 'star-off', 'setting', 'help'][index];
      return node;
    });
    this.$nextTick(() => {
      if([1,6,9,11,13,14,15].indexOf(this.admin.roleId) > -1) {
        openModuleByCode('taishitu');
      }
      if (this.admin.roleId == 10) {
        openModuleByCode('ycyl.chat.doctorView');
      }
    });

    document.addEventListener('keydown', (e) => {
      if (27 == e.keyCode) {
        this.logout();
      }
    });
  },
  computed: {
    styles() {
      const themeStyles = {
        dark: {
          header: {
            backgroundColor: '#242f42',
            color: '#eee',
            color2: '#ddd',
            hoverColor: '#1c273a'
          }
        },
        light: {
          header: {
            backgroundColor: '#409EFF',
            color: '#fff',
            color2: '#eee',
            hoverColor: '#53a8ff'
          }
        }
      };
      return themeStyles[this.theme];
    }
  },
  methods: {
    onTitleClick() {
      this.$refs.navMenu.onCollapse();
    },
    onCommandClick(cmd) {
      switch (cmd) {
        case 'index':
          openModuleByCode('taishitu');
          break;
        case 'modifyPassword':
          this.$refs.passwordUpdateDialog.visible = true;
          break;
      }
    },
    onSettingClick() {
      app.pushPage('/settings/index');
    },
    logout() {
      this.$router.replace('/logout');
    },
    onTabRemove(key) {
      let tabs = this.tabs;
      let activeTabKey = this.activeTabKey;
      if (activeTabKey === key) {
        tabs.forEach((tab, index) => {
          if (tab.key === key) {
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
        if (!page) {
          this.$message.error('未找到指定页面：' + path);
          return;
        }
        let tab = {
          title: options.title || '...',
          key: tabKey,
          content: null, // vue组件
          loading: true // vue组件加载状态
        };
        this.tabs.push(tab);
        this.activeTabKey = tabKey;
        loadAsyncComponentSetTabContent(tab, page);
      }

      /* 异步加载vue组件，并设置为tab的content */
      function loadAsyncComponentSetTabContent(tab, page) {
        if (typeof page === 'function') {
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
            component.props['$params'] = {
              type: Object,
              default: () => options.params
            };
            
            tab.content = component;

            tab.loading = false;
          });
        }
      }
    },
    /* 打开一个标签页承载一个页面，这个方法现在被NavMenu，以及原使用easyui代码的方法调用 */
    openTab(item, options) {
      const addedTab = this.tabs.find(tab => tab.key == item.id);
      if (addedTab) {
        this.activeTabKey = '';
        setTimeout(() => {
          this.activeTabKey = item.id;
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
            key: item.id,
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
                      padding:0px;
                      border-width:0px;`
                  }
                );
              },
              mounted() {
                this.$el.contentWindow.addEventListener('load', () => {
                  this.$el.style.visibility = 'visible';
                  tab.loading = false;
                  options && options.onLoad();
                });
              }
            },
            loading: true
          };
          this.tabs.push(tab);
          this.activeTabKey = item.id;
      }
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
}
</style>
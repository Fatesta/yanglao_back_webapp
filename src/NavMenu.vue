<script>
import config from '@/config/app.config.js';

/* 导航菜单 */
export default {
  props: {
    height: Number
  },
  render(h) {
    const styles = this.styles;
    let children = this.menuTreeNodes.map(node => buildSubmenu(node, 1));

    return h(
      'el-aside',
      {
        style: {
          position: 'relative',
          width: 'unset',
          height: this.height + 'px'
        }
      }, [
        h(
          'el-menu',
          {
            ref: 'menu',
            props: {
              collapse: this.collapsed,
              uniqueOpened: true,
              ...styles
            },
            style: 'height: 100%',
            class: 'main-menu',
            on: {
              select: this.onSelect
            }
          },
          children
        ),
        // 展开收缩按钮
        h('i', {
          style: {
            position: 'absolute',
            bottom: '8px',
            width: '100%',
            fontSize: '18px',
            textAlign: 'center',
            cursor: 'pointer',
            color: '#909399'
          },
          class: `el-icon-${this.collapsed ? 's-unfold' : 's-fold'}`,
          on: {
            click: this.onCollapse
          }
        })
      ]);

    function buildSubmenu(node, level) {
      if (node.children.length) {
        return h(
          'el-submenu',
          {
            props: {
              index: node.id + ''
            }
          }, [
            h('template', {slot: 'title'}, [
              level == 1 && h('i',
                {
                  class: `el-icon-${node.iconCls || 'menu'}`,
                  style: {color: styles.iconColor}
                }),
              h('span', node.text)
            ])
          ].concat(node.children.map(node => buildSubmenu(node, level + 1))));
      } else {
        return h(
          'el-menu-item',
          {
            props: {index: node.id + ''}
          },
          [h('template', {slot: 'title'}, [
            level == 1 && h('i',
              {
                class: `el-icon-${node.iconCls || 'menu'}`,
                style: {color: styles.iconColor}
              }),
            h('span', node.text)
          ])]
        );
      }
    }
  },
  data() {
    return {
      theme: config.get('theme'),
      collapsed: config.get('sideMenuCollapsed'),
      menuTreeNodes: [],
    }
  },
  computed: {
    styles() {
      const themeStyles = {
        dark: {
          backgroundColor: '#021d6a',
          textColor: "#ffffffb3",
          activeTextColor: "#fff"
        },
        light:  {
          textColor: '#303133',
          iconColor: '#909399'
        }
      };
      return themeStyles[this.theme];
    },
    menuIndexMap() {
      let map = new Map();
      f(this.menuTreeNodes);
      function f(nodes) {
        nodes.forEach(node => {
          map.set(node.id+'', node);
          f(node.children);
        });
      }
      return map;
    }
  },
  watch: {
    collapsed(value) {
      this.timer && clearInterval(this.timer);
      this.timer = setInterval(() => {
        if (value) {
          if (this.$el.children[0].offsetWidth == 65) {
            clearInterval(this.timer);
            this.timer = null;
            this.$emit('collapsed');
          }
        } else {
          if (this.$el.children[0].offsetWidth == 203) {
            clearInterval(this.timer);
            this.timer = null;
            this.$emit('expanded');
          }
        }
      }, 60);
    }
  },
  methods: {
    collapse() {
      // 已折叠时立即发送事件
      if (this.collapsed) {
        this.$emit('collapsed');
        return;
      }
      this.collapsed = true;
    },
    expand() {
      // 已展开时立即发送事件
      if (!this.collapsed) {
        this.$emit('expanded');
        return;
      }
      this.collapsed = false;
    },
    onCollapse() {
      this.collapsed = !this.collapsed;
    },
    onSelect(index) {
      const item = this.menuIndexMap.get(index);
      app.openTab(item);
    }
  }
};
</script>

<style>
.el-menu-item.is-active {
  /*background: hsla(0,0%,100%,.1) !important;*/
  background-color: #ecf5ff;
  border-left: 3px solid #2d8cf0;
}

.main-menu:not(.el-menu--collapse) {
  width: 202px;
}
</style>

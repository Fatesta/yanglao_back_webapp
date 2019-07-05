import config from '@/config/app.config.js';

/* 导航菜单 */
export default {
  props: {
    height: Number
  },
  render(h) {
    const styles = this.styles;

    return h(
      'el-aside',
      {
        style: {
          width: this.collapsed ? '65px' : '210px',
          height: this.height + 'px'
        }
      }, [
        h(
          'el-menu',
          {
            props: {
              collapse: this.collapsed,
              uniqueOpened: true,
              ...styles
            },
            style: 'height: 100%',
            on: {
              select: this.onSelect
            }
          },
          this.menuTreeNodes.map(node => children(node, 1))
        )
      ]);

    function children(node, level) {
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
                  'class': `el-icon-${node.iconCls || 'menu'}`,
                  style: {color: styles.iconColor}
                }),
              h('span', node.text)
            ])
          ].concat(node.children.map(node => children(node, level + 1))));
      } else {
        return h(
          'el-menu-item',
          {
            props: {index: node.id + ''}
          },
          node.text
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
          backgroundColor: "#0a2e57",
          textColor: "#ccc",
          activeTextColor: "#20a0ff",
          iconColor: '#fff'
        },
        light: {

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
  methods: {
    onCollapse() {
      this.collapsed = !this.collapsed;
    },
    onSelect(index) {
      const item = this.menuIndexMap.get(index);
      app.openTab(item);
    }
  }
};
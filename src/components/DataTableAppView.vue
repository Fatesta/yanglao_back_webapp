<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
/*
创建带一个可选的工具栏、一个表格的一个可复用页面组件。

例子：
<data-table-app-view>
  <table-toolbar>...</table-toolbar>
  <data-table>...</data-table>
</data-table-app-view>
*/
export default {
  name: 'data-table-app-view',
  mounted() {
    const children = this.$slots.default;

    let toolbarElm = null, table;
    if (children.length == 1) {
      table = children[0].componentInstance;
    } else {
      toolbarElm = (children[0].componentInstance && children[0].componentInstance.$el)
        || children[0].elm;
      table = children[2].componentInstance;
    }

    table.$el.children[0].style.overflow = 'auto';

    this.$nextTick(resize);

    window.addEventListener('resize', resize);
    app.$refs.navMenu.$on('collapsed', resize).$on('expanded', resize);

    function resize() {
      let restHeight = document.body.offsetHeight - (104 + 32 * 2 + 5 + 10);
      if (toolbarElm)
        restHeight -= toolbarElm.offsetHeight;
      table.height = restHeight;
    }
  },
  methods: {

  }
}
</script>
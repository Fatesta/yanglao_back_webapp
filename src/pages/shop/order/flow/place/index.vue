<template>
  <keep-alive include="place">
    <component :is="current" />
  </keep-alive>
</template>


<script>
/* 下单流程 */
import Place from './pages/Place.vue';
import OrderForm from './pages/OrderForm.vue';

const pages = [Place, OrderForm];

export default {
  data() {
    return {
      index: 0,
      current: null
    }
  },
  created() {
    this.setCurrent(pages[0]);
  },
  methods: {
    next(options) {
      this.setCurrent(pages[++this.index], options);
    },
    back() {
      this.setCurrent(pages[--this.index]);
    },
    setCurrent(c, options) {
      c.props = c.props || {};
      Object.assign(c.props, 
        {
          $params: {
            type: Object, default: () =>
              Object.assign(this.$params, options && options.params)
          },
          placeFollow: {
            type: Object, default: () => this
          }
        });
      this.current = c;
    }
  }
}
</script>

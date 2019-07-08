<template>
  <card-page>
    <keep-alive include="place">
      <component :is="current" />
    </keep-alive>
  </card-page>
</template>


<script>
/* 下单流程 */
import Place from './pages/Place.vue';

let pages = [Place];

export default {
  pageProps: {
    title: '下单'
  },
  data() {
    ({
      'housekeeping': () => import('./pages/types/housekeeping/OrderForm.vue'),
      'catering': () => import('./pages/types/catering/OrderForm.vue')
    })[this.$params.shop.industryId]().then(({default: page}) => {
      pages[1] = page;
    });

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

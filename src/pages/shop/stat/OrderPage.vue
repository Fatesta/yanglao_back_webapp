<template>
  <plain-page
    style="height: calc(100% - 1vh)"
  >
    <query-form-card @query="onQuery" />

    <el-card
      shadow="hover"
      body-style="padding:0px"
      style="height: calc(100% - 56px)"
    >
      <div ref="chartContainer" v-loading="loading"></div>
    </el-card>
  </plain-page>
</template>

<script>
import QueryFormCard from './QueryFormCard';
import echarts from 'echarts';

export default {
  pageProps: {
    title: '订单统计'
  },
  components: {
    QueryFormCard
  },
  data() {
    return {
      loading: true
    }
  },
  mounted() {
    this.isActive = true;
    this.chart = echarts.init(this.$refs.chartContainer);
    const resize = this.resize.bind(this);
    this.resize();
    app.$refs.navMenu.$on('collapsed', resize).$on('expanded', resize);
    window.addEventListener('resize', resize);
  },
  methods: {
    async onQuery(params) {
      this.loading = true;
      const data = await this.axios.get('/api/shop/stat/queryOrdersStats', {params});
      this.chart.clear();
      this.loading = false;

      if (!data.length) {
        this.$message.warning('无数据');
        return;
      }

      this.chart.setOption({
        tooltip: {
          trigger: 'axis'
        },
        grid: {
          top: 'middle',
          left: '20px',
          right: '20px',
          bottom: '20px',
          height: '80%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: data.map(({statDate}) =>
            statDate.split('-').map(s => s[0] == '0' ? s.substring(1) : s).join('-')),
          axisLine: {
            lineStyle: {
              color: "#999"
            }
          }
        },
        yAxis: {
          type: 'value',
          splitLine: {
            lineStyle: {
              type: 'dashed',
              color: '#DDD'
            }
          },
          axisLine: {
            show: false,
            lineStyle: {
              color: "#333"
            },
          },
          nameTextStyle: {
            color: "#999"
          },
          splitArea: {
            show: false
          }
        },
        series: [{
          name: '订单数',
          type: 'line',
          data: _.pluck(data, 'ordersQuantity'),
          color: "#F58080",
          lineStyle: {
            normal: {
              width: 3,
              color: '#F58080',
              shadowColor: 'rgba(0,0,0, 0.1)',
              shadowBlur: 10,
              shadowOffsetY: 7,
            }
          },
          symbolSize: 6,
          itemStyle: {
            normal: {
              label: {
                show: true,
                fontSize: 14
              }
            }
          },
        }]
      });
    },
    resize() {
      if (this.isActive) {
        const { chartContainer } = this.$refs;
        chartContainer.style.height = chartContainer.parentElement.parentElement.offsetHeight + 'px';
        this.chart.resize();
      }
    },
    onPageResume() {
      this.isActive = true;
      this.$nextTick(() => {
        this.resize();
      });
    },
    onPagePause() { this.isActive = false; }
  },
}
</script>



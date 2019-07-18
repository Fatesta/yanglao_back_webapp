<template>
  <plain-page
    style="height: calc(100% - 1vh)"
  >
    <query-form-card @query="onQueryClick" />

    <el-card
      shadow="hover"
      v-loading="loading"
      body-style="padding:0px"
      style="height: calc(100% - 56px)"
    >
      <div ref="chartContainer"></div>
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
    const { chartContainer } = this.$refs;

    this.chart = echarts.init(chartContainer);

    const resize = () => {
      chartContainer.style.height =
        chartContainer.parentElement.parentElement.offsetHeight + 'px';
      this.chart.resize();
    };
    app.$refs.navMenu.$on('collapsed', resize).$on('expanded', resize).collapse();
    window.addEventListener('resize', resize);
  },
  methods: {
    async onQueryClick(params) {
      this.loading = true;
      const data = await this.axios.get('/api/shop/stat/queryOrdersStats', {params});
      this.loading = false;

      this.chart.resize();
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
          itemStyle: {
            normal: {
              label: {
                show: true,
                fontSize: 14
              },
              color: '#F58080',
              borderWidth: 4,
              borderColor: "#F58080"
            }
          },
        }]
      });
    },
    onPageResume() {
    }
  },
}
</script>



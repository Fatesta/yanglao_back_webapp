<template>
  <plain-page
    style="height: calc(100% - 1vh)"
  >
    <query-form-card is-trade-query-form @query="onQueryClick" />

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
    title: '交易统计'
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
    if ([1,14,15].includes(app.admin.roleId)) {
      app.$refs.navMenu.collapse();
    }
    window.addEventListener('resize', resize);
  },
  methods: {
    async onQueryClick(params) {
      this.chart.clear();
      this.loading = true;
      const data = await this.axios.get('/api/shop/stat/queryProvidersAccountStats', {params});
      this.loading = false;

      if (!data.length) {
        this.$message.warning('无数据');
        return;
      }

      var dates = data.map(({statDate}) =>
       statDate.split('-').map(s => s[0] == '0' ? s.substring(1) : s).join('-'));

      this.chart.setOption({
        grid: {
          top: '60px',
          bottom: '40px',
          left: '60px',
          right: '60px',
        },
        legend: {
          top: 10,
          right: 20,
          textStyle: {
            fontSize: 13
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross'
          }
        },
        xAxis: [{
          type: 'category',
          boundaryGap: true,
          show: true,
          axisTick: {
            show: false
          },
          axisLabel: {
            color: '#999',
            interval: 0
          },
          axisLine: {
            lineStyle: {
              type: 'solid',
              color: '#4e608b',
              width: 1
            }
          },
          data: dates
        }],
        yAxis: [{
          type: 'value',
          nameTextStyle: {
            fontSize: 14
          },
          splitLine: {
            lineStyle: {
              type: 'dashed',
              color: '#DDD'
            }
          },
          axisLine: {
            show: false,
            lineStyle: {
              color: "#999"
            },
          }
        }, {
          type: 'value',
          nameTextStyle: {
            fontSize: 14
          },
          splitLine: {
            lineStyle: {
              type: 'dashed',
              color: '#DDD'
            }
          },
          axisLine: {
            show: false,
            lineStyle: {
              color: "#999"
            },
          }
        }],
        series: [{
          name:'交易金额',
          color: '#F58080',
          type:'line',
          symbolSize: 7,
          yAxisIndex: 0,
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
              }
            }
          },
          data: data.map(item => params.tradeType == 3 ? item.income : item.tradePrice).map(x => x.toFixed(2))
        }, {
          name:'交易次数',
          type: 'bar',
          barWidth: '40%',
          yAxisIndex: 1,
          symbolSize: 7,
          itemStyle: {
            normal: {
              label: {
                show: true,
                fontSize: 13
              },
              color: new echarts.graphic.LinearGradient(0, 1, 0, 0, [{
                offset: 0,
                color: "#4889fb" // 0% 处的颜色
              }, {
                offset: 1,
                color: "#15b3ff" // 100% 处的颜色
              }], false)
            }
          },
          data: data.map(item => item.tradeAmount)
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
  }
}
</script>



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
    app.$refs.navMenu.$on('collapsed', resize).$on('expanded', resize).collapse();
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
        grid: [{
          top: '7%',
          bottom: 0,
          left: '60px',
          right: '60px',
          height: '39%',
        }, {
          top: '52%',
          bottom: 0,
          left: '60px',
          right: '60px',
          height: '39%',
        }],
        legend: {
          show: true,
          top: 10,
          itemGap: 20,
          textStyle: {
            fontSize: 14
          }
        },
        tooltip: {
          trigger: 'axis',
          formatter(params){
            var time = params[0].axisValueLabel;
            var html = '<div><time>' + time + '</time><br />';
            params.forEach((item) => {
              html += '<p style="margin: 0;padding: 0;">' + item.marker + item.seriesName + ': ' + item.data + '</p>'
            });
            html += '</div>';
            return html;
          }
        },
        axisPointer: {
          link: {
            xAxisIndex: 'all'
          }
        },
        xAxis: [{
          type: 'category',
          gridIndex: 0,
          boundaryGap: true,
          axisLabel: {
            show: false,
            interval: 0
          },
          axisLine: {
            show: false,
            lineStyle: {
              color: "#fff"
            }
          },
          data: dates
        }, {
          type: 'category',
          gridIndex: 1,
          position: 'bottom',
          boundaryGap: true,
          axisLabel: {
            show: true,
            interval: 0
          },
          axisLine: {
            show: true,
            lineStyle: {
              color: "#999"
            }
          },
          data: dates
        }],
        yAxis: [{
          //name: '交易金额',
          type: 'value',
          nameTextStyle: {
            fontSize: 14
          },
          gridIndex: 0,
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
          //name: '交易次数',
          type: 'value',
          nameTextStyle: {
            fontSize: 14
          },
          gridIndex: 1,
          //inverse: true,
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
          hoverAnimation: false,
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
          color: '#0d8ecf',
          type:'line',
          xAxisIndex: 1,
          yAxisIndex: 1,
          symbolSize: 7,
          hoverAnimation: false,
          lineStyle: {
            normal: {
              width: 3,
              color: '#0d8ecf',
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



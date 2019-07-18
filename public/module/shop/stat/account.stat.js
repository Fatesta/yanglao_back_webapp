define([CONFIG.modulePath + 'shop/stat/statquerier.js?v=1.4', '/lib/echarts/echarts.min.js'], function(StatQuerier, echarts) {
    return function() {
        return new StatQuerier({
            elem: "#account",
            onQuery: function(params) {
                $("#account #accountCanvasDiv").hide();
                $.get(CONFIG.baseUrl + "shop/stat/queryProvidersAccountStats.do", params, function(data){
                    if(data.length == 0) {
                        showAlert("提示", params.timeTitle + " 无数据", "info");
                        return;
                    }
                    params.title = params.timeTitle;
                    drawCanvas(params, data);
                });
            }
        });
    };
    
    function drawCanvas(params, statData) {
        $("#account #accountCanvasDiv").height('99%').fadeIn('fast');
        
        var labels = _.map(statData, 'statDate').map(function(date) {
            return date.split('-').map(function(s) {
                return s[0] == '0' ? s.substring(1) : s;
            }).join('-');
        });

        var option = {
            title: {
                text: params.title + '交易统计',
                left:'center'
            },
            grid: [{
                top: '9%',
                bottom: 0,
                left: '60px',
                right: '60px',
                height: '37%',
            }, {
                top: '50%',
                bottom: 0,
                left: '60px',
                right: '60px',
                height: '37%',
            }],
            tooltip: {
                trigger: 'axis',
                formatter: function(params){
                    var time = params[0].axisValueLabel;
                    var html =
                        '<div><time>' + time + '</time><br />';
                    params.forEach(function(item) {
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
                    interval: 0
                },
                data: labels
            }, {
                type: 'category',
                gridIndex: 1,
                position: 'top',
                boundaryGap: true,
                axisLabel: {
                    show: false,
                    interval: 0
                },
                data: labels
            }],
            yAxis: [{
                name: '交易金额',
                type: 'value',
                nameTextStyle: {
                    fontSize: 14
                },
                gridIndex: 0,
                splitLine: {
                    lineStyle: {
                        type: 'dashed'
                    }
                }
            }, {
                name: '交易次数',
                type: 'value',
                nameTextStyle: {
                    fontSize: 14
                },
                gridIndex: 1,
                inverse: true,
                splitLine: {
                    lineStyle: {
                        type: 'dashed'
                    }
                }
            }],
            series: [
              {
                  name:'交易金额',
                  color: '#ec4646',
                  type:'line',
                  symbolSize: 7,
                  hoverAnimation: false,
                  itemStyle: {
                      normal: {
                          label: {
                              show: true
                          }
                      }
                  },
                  data: _.pluck(statData, params.tradeType == 3 ? 'income' : 'tradePrice').map(function(x) { return x.toFixed(2) })
              },
              {
                  name:'交易次数',
                  color: '#0d8ecf',
                  type:'line',
                  xAxisIndex: 1,
                  yAxisIndex: 1,
                  symbolSize: 7,
                  hoverAnimation: false,
                  itemStyle: {
                      normal: {
                          label: {
                              show: true
                          }
                      }
                  },
                  data: _.pluck(statData, 'tradeAmount')
              }
            ]
        };

        echarts.init(document.getElementById('accountCanvasDiv')).setOption(option);
    }
});
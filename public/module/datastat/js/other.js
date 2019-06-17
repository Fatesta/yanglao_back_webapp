require(['/lib/echarts/echarts.min.js'], function(echarts) {
    $('.title').click(function() {
        requestFullScreen($(document.body).get(0));
        return false;
    });
    redrawCharts();

    function redrawCharts() {
        $('#charts').fadeIn('slow');
        
        drawCharts();
    }

    function drawCharts() {
        var textStyle = {
            fontFamily: '微软雅黑',
            color: '#fff',
            fontWeight: 'lighter'
        };
        
        $.get(CONFIG.baseUrl + 'datastat/shopAboutCounts.do', function(stat) {
            (function() {
                $('#orderTotal').text(stat.orderTotal);
                $('#activityParticipantTotal').text(stat.activityParticipantTotal);
            })();
        });
        
        //社区人数
        (function() {
            return;
            var orgNames = [];
            var data = stat.orgUserCounts.map(function(item) {
                orgNames.push(item.orgName);
                return {
                    value: item.count,
                    name: item.orgName,
                    itemStyle: {color: '#ef76b8'}
                };
            });
            var option = {
                title: {
                    text: '老年人生活社区人数前10',
                    textStyle: textStyle,
                    left: 20
                },
                tooltip: {},
                yAxis: {
                    data: orgNames,
                    type: 'category',
                    maxInterval: total,
                    axisLine: {
                        lineStyle: {
                            color: '#d9eff2'
                        }
                    },
                    axisTick: {show: false},
                    splitLine: {show:false}
                },
                xAxis: {
                    axisLine: {
                        lineStyle: {
                            color: '#d9eff2'
                        }
                    },
                    axisTick: {show: false},
                    splitLine: {show:false}
                },
                series: [{
                    name: '',
                    type: 'bar',
                    barWidth: 16,
                    data: data,
                    label: {
                        normal: {
                            show: true,
                            position: 'right',
                            textStyle: {
                                fontSize: 16
                            }
                        }
                    }
                }],
                textStyle: textStyle
            };
            echarts.init(document.getElementById('orgUserCount')).setOption(option);
        })();
    }
    
    
});
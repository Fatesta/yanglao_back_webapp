require(['/lib/echarts/echarts.min.js'], function(echarts) {
    redrawCharts();
    
    $('.main-title').title('服务工单统计');
    $('#charts').click(function() {
        requestFullScreen($(document.body).get(0));
        setTimeout(redrawCharts, 1000);
        return false;
    });
    $(document).keyup(function() {
        setTimeout(redrawCharts, 1000);
    });
    
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
        
        //服务项目分类
        (function() {
            $.get(CONFIG.baseUrl + 'datastat/service/productCounts.do', function(items) {
                var categorys = [];
                var data = items.map(function(item) {
                    categorys.push(item.categoryName);
                    return {value: item.count, name: item.categoryName};
                });
                var xAxisData = _.pluck(data, 'name');
                var option = {
                    height: '56%',
                    title : {
                        text: '服务项目分类',
                        textStyle: textStyle,
                        left:'center'
                    },
                    tooltip : {},
                    xAxis: {
                        type: 'category',
                        data: categorys,
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:false},
                        axisLabel: {
                            rotate: 50
                        }
                    },
                    yAxis: {
                        name: '商品数量',
                        type: 'value',
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:false}
                    },
                    series : [{
                        type: 'bar',
                        data: data,
                        itemStyle: {
                            normal: {
                                color: function(params) {
                                    var colors = [
                                      '#ff8050','#ef76b8','#3bcc44','#86cef7','#6396ec',
                                      '#fffb95','#9BCA63','#FAD860','#F3A43B','#60C0DD',
                                      '#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0'
                                    ];
                                    return colors[params.dataIndex]
                                }
                            }
                        },
                        label: {
                            normal: {
                                show: true,
                                position: 'top',
                                textStyle: {
                                    fontSize: 16
                                }
                            }
                        }
                    }],
                    textStyle: textStyle
                };
                echarts.init(document.getElementById('serviceCategory')).setOption(option);
            });
        })();
            
        $.get(CONFIG.baseUrl + 'datastat/service/totalCounts.do', function(stat) {
            //总数
            $('#serviceTotal').text(stat.serviceCount);
            $('#customerTotal').text(stat.customerCount);
            
            //服务状态
            (function(){
                var total = stat.serviceCount;
                var colors = ['#02e7ff', '#3d93dc', '#b0d794', '#c55583'];
                $.get(CONFIG.baseUrl + 'datastat/service/orderStateCounts.do', function(items) {
                    var margin = 4, borderWidth = 10;
                    //根据当前容器尺寸计算出合适的尺寸
                    $('.service-state').empty();
                    var itemsContainerSize = $('.service-state').height();
                    var itemSize = (itemsContainerSize - margin * 4 - borderWidth * 4) / 2;
                    var baseX = ($('.service-state').width() - itemsContainerSize) / 2;
                    items.forEach(function(item, index) {
                        item.color = colors[index];
                        
                        (function(item) {
                            option = {
                                title: {
                                    text: item.title,
                                    top: '80%',
                                    left: 'center',
                                    textStyle: {
                                        fontSize: 16,
                                        color: item.color
                                    }
                                },
                                tooltip: {
                                    show: false,
                                },
                                toolbox: {
                                    show: false,
                                },
                                series: [{
                                    type: 'pie',
                                    radius: ['70%', '50%'],
                                    center: ['50%', '40%'],
                                    avoidLabelOverlap: false,
                                    hoverAnimation: false,
                                    label: {
                                        normal: {
                                            show: false,
                                            position: 'center'
                                        },
                                        emphasis: {
                                            show: false,
                                            textStyle: {
                                                fontSize: '130%',
                                                fontWeight: 'bold'
                                            }
                                        }
                                    },
                                    labelLine: {
                                        normal: {
                                            show: false
                                        }
                                    },
                                    data: [
                                           {
                                               value: total - item.count,
                                               itemStyle: {
                                                   color: "#022f35"
                                               },
                                           },
                                           {
                                               value: item.count,
                                               itemStyle: {
                                                   color: item.color
                                               },
                                               label: {
                                                   normal: {
                                                       show: true,
                                                       formatter: '{c}',
                                                       textStyle: {
                                                           fontSize: 15,
                                                           fontWeight: 'bold'
                                                       },
                                                       position: 'center'
                                                   }
                                               }
                                           }
                                           ]
                                }]
                            };
                            var rows = Math.floor(index / 2);
                            var cols = index % 2;
                            var container = $('<div class="chart"></div>');
                            $('.service-state').append(container);
                            container.empty().removeAttr('_echarts_instance_').css({
                                left: baseX + ((cols * (itemSize + borderWidth * 2)) + (cols + 1) * margin),
                                top: rows * (itemSize + borderWidth * 2) + rows * margin,
                                width: itemSize,
                                height: itemSize});
                            echarts.init(container.get(0)).setOption(option);
                        })(item);
                    });
                });
            })();
            
            //线上线下占比
            $.get(CONFIG.baseUrl + 'datastat/service/orderCreatorTypeCount.do', function(items) {
                (function() {
                    var onlineCount = 0, totalCount = 0;
                    var userTypeMap = {};
                    items.forEach(function(item) {
                        totalCount += item.count;
                        if (item.userType != 9)
                            onlineCount += item.count;
                    });
                    //临时假数据代码
                    if (nowAdminUsername == 'qqhl') {
                        onlineCount = Math.floor(stat.serviceCount - stat.serviceCount * 0.43);
                    }
                    var data = [
                        {value: onlineCount, name:'线上', itemStyle: {color: '#6396ec'}},
                        {value: stat.serviceCount - onlineCount, name:'线下', itemStyle: {color: '#ef76b8'}}];
                    var option = {
                        title: {
                            text: '线上线下占比',
                            textStyle: textStyle,
                            left: 'center'
                        },
                
                        tooltip : {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {d}% ({c})"
                        },
                        series : [
                            {  
                                name:"占比",
                                type:'pie',
                                radius : '40%',
                                center: ['50%', '50%'],
                                data: data,
                                formatter: "{a} <br/>{b} : {d}% ({c})", 
                                itemStyle: {
                                    emphasis: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }                                
                                },
                                label:{
                                    show:true,
                                    formatter:'{b} {d}% ({c})'
                                }
                            }
                        ],
                        textStyle: textStyle
                    };
                    echarts.init(document.getElementById('pic1')).setOption(option);
                })();
            });
        });
            
        //客户服务需求
        (function() {
            $.get(CONFIG.baseUrl + 'datastat/service/orderCounts.do', function(items) {
                if (items.length == 0) {
                    for (var i = 0; i < 5; i++) {
                        items.push({categoryName: '', count: 0});
                    }
                }
                var categorys = [];
                var data = items.map(function(item) {
                    categorys.push(item.categoryName);
                    return {value: item.count, name: item.categoryName};
                });
                var option = {
                    title: {
                        text: '客户服务需求',
                        textStyle: textStyle,
                        left: 'center'
                    },
            
                    tooltip : {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {d}% ({c})"
                    },
                    series : [
                        {  
                            name:"占比",
                            type:'pie',
                            radius : '40%',
                            center: ['50%', '50%'],
                            data:  data,
                            formatter: "{a} <br/>{b} : {d}% ({c})", 
                            itemStyle: {
                                normal: {
                                    color: function(params) {
                                        var colors = [
                                          '#ff8050','#ef76b8','#3bcc44','#86cef7','#6396ec',
                                          '#fffb95','#9BCA63','#FAD860','#F3A43B','#60C0DD',
                                          '#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0'
                                        ];
                                        return colors[params.dataIndex]
                                    }
                                },
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }                                
                            },
                        label:{
                            show:true,
                            formatter:'{b} {d}% ({c})'
                        }
                        }
                    ],
                    textStyle: textStyle
                };
                echarts.init(document.getElementById('pic3')).setOption(option);
                
                // 服务需求TOPn
                (function() {
                    $('.service-need-rank').empty();
                    items.sort(function(x, y){
                        return y.count - x.count;
                    }).slice(0, 3).forEach(function(item, i) {
                        var html =
                            '<div>' +
                            '   <div>NO.' + (i + 1)  + '</div>' +
                            '   <div>' + item.categoryName + '</div>' +
                            '   <div>' + item.count + '</div>' +
                            '</div>';
                        $('.service-need-rank').append(html);
                    });
                })();
            });
        })();

    }
    
    
});
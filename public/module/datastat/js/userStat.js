require(['/lib/echarts/echarts.min.js'], function(echarts) {
    redrawCharts();
    
    $('.main-title').title('老年人用户数据分析统计');
    $('#charts').click(function() {
        requestFullScreen($(document.body).get(0));
        return false;
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
        
        $.get(CONFIG.baseUrl + 'datastat/oldman.do', function(stat) {
            //总数
            (function() {
                $('#total').styledNumber(stat.total);
            })();
    
            //性别
            (function() {
                var option = {
                    height: '60%',
                    title: {
                        text: '老年人性别',
                        textStyle: textStyle,
                        left: 'center'
                    },
                    tooltip: {},
                    yAxis: {
                        data: ["男", "女"],
                        maxInterval: 2,
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:false},
                        nameTextStyle: {
                            fontSize: 10
                        }
                    },
                    xAxis: {
                        name: '人数',
                        type: 'value',
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            },
                        },
                        axisTick: {show: false},
                        splitLine: {show:false}
                    },
                    series: [{
                        type: 'bar',
                        barWidth: 16,
                        data: [
                            {value: stat.man, itemStyle: {color: '#6396ec'}},
                            {value: stat.woman, itemStyle: {color: '#fe69b3'}}
                        ],
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
                echarts.init(document.getElementById('totalAndSex')).setOption(option);
            })();
    
            //年龄段分布
            (function() {
                var data = [
                    {value: stat.age_lt60, name:'<60岁', itemStyle: {color: '#ff8050'}},
                    {value: stat.age_60a69, name:'60~69岁', itemStyle: {color: '#ef76b8'}},
                    {value: stat.age_70a79, name:'70~79岁', itemStyle: {color: '#3bcc44'}},
                    {value: stat.age_80a89, name:'80~89岁', itemStyle: {color: '#86cef7'}},
                    {value: stat.age_90a99, name:'90~99岁', itemStyle: {color: '#6396ec'}},
                    {value: stat.age_gteq100, name:'>=100岁', itemStyle: {color: '#fffb95'}}
                ];
                var xAxisData = _.pluck(data, 'name');
                var option = {
                    height: '60%',
                    title : {
                        text: '老年人年龄段分布',
                        textStyle: textStyle,
                        left:'center'
                    },
                    tooltip : {},
                    xAxis: {
                        type: 'category',
                        data: xAxisData,
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:false}
                    },
                    yAxis: {
                        name: '人数',
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
                echarts.init(document.getElementById('age')).setOption(option);
            })();
            
            drawOldmanAbout(stat.total);

        });
        
        function drawOldmanAbout(total) {
            $.get(CONFIG.baseUrl + 'datastat/oldmanAbout.do', function(stat) {
                //评估状况
                (function() {
                    var data = [];
                    var i = 0;
                    var nums = [143, 1, 57, 1, 11];
                    var colors =['#ff8050', '#ef76b8', '#3bcc44', '#86cef7', '#6396ec', '#fffb95'];
                    _.forEach(['<60', '60~69', '70~79', '80~89', '>=90'], function(text, i) {
                        data.push({
                            value: nums[i],
                            name: text + '分',
                            itemStyle: {color: colors[i++]}
                        });
                    });
        
                    var option = {
                        title: {
                            text: '老年人评估状况',
                            textStyle: textStyle,
                            left: 'center'
                        },
                
                        tooltip : {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : ({c})"
                        },
                        series : [
                            {
                                name:'评估分数',
                                type:'pie',
                                radius : '40%',
                                center: ['50%', '50%'],
                                data: data,
                                itemStyle: {
                                    emphasis: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                },
                                label: {
                                    formatter: '{b} {d}% ({c})'
                                }
                            }
                        ],
                        textStyle: textStyle
                    };
                    echarts.init(document.getElementById('ability')).setOption(option);
                })();
        
                //健康状态
                (function() {
                    return;
                    var indicator = [];
                    var value = [];
                    _.forEach(DictMan.itemMap("user.disease"),function(text,key){
                       indicator.push({name: text, max: total});
                       value.push(stat.userProfile['user.disease'][key]);         
                    });
                    var data = [{value:value,  name : '健康状态'}]
                    var option = {
                        title: {
                            text: '老年人健康状态',
                            textStyle: textStyle,
                            left: 'center'
                        },
                        legend: {
                            data: ['健康状态'],
                            right: 100,
                            bottom: 20,
                            textStyle: textStyle
                        },
                        tooltip: {},
                        radar: {
                            //shape: 'circle',
                            name: {
                                textStyle: {
                                    color: '#fff',            
                                    borderRadius: 3,
                                    padding: [3, 5]
                               }
                            },
                            indicator: indicator
                        },
                        series: [{
                            name: '健康状态',
                            type: 'radar',
                            areaStyle: {normal: {}},
                            data :data
                        }],
                        textStyle: textStyle
                    };
                    echarts.init(document.getElementById('health')).setOption(option);
                })();
                
                //居住状况
                (function() {
                    var colors =["#ff8050","#6396ec","#86cef7"];
                    var data = [];
                    var i = 0;
                    _.forEach(DictMan.itemMap('user.liveStyle'), function(text, key) {
                          data.push({
                              value: stat.userProfile['user.liveStyle'][key],
                              name: text,
                              itemStyle: {color: colors[i++]}
                          });
                    });
                    var option = {
                        title: {
                            text: '老年人居住状况',
                            textStyle: textStyle,
                            left: 'center'
                        },
                
                        tooltip : {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {d}% ({c})"
                        },
                        series : [
                            {
                                name:'居住状况',
                                type:'pie',
                                radius : '40%',
                                center: ['50%', '50%'],
                                data: data,
                                itemStyle: {
                                    emphasis: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                },
                                label: {
                                    formatter: '{b} {d}% ({c})'
                                }
                            }
                        ],
                        textStyle: textStyle
                    };
                    echarts.init(document.getElementById('liveStyle')).setOption(option);
                })();
                
                // 服务需求
                (function() {
                   var colors = ['#6396ec','#fe69b3','#3bcc44', "#86cef7","#ff8050"];
                   var data=[];
                   var i = 0;
                  _.forEach(DictMan.itemMap("user.serviceNeed"),function(text,key){
                      data.push({
                          value: stat.userProfile['user.serviceNeed'][key],
                          name: text,
                          itemStyle: {color: colors[i++]}
                      });
                  });
                  var option = {
                       title: {
                           text: '服务需求',
                           textStyle: textStyle,
                           left: 'center'
                       },
                       tooltip : {},
                       xAxis: {
                           type: 'category',
                           data: _.values(DictMan.itemMap('user.serviceNeed')),
                           axisLine: {
                               lineStyle: {
                                   color: '#d9eff2'
                               }
                           },
                           axisTick: {show: false},
                           splitLine: {show:false}
                       },
                       yAxis: {
                           name: '人数',
                           type: 'value',
                           axisLine: {
                               lineStyle: {
                                   color: '#d9eff2'
                               }
                           },
                           axisTick: {show: false},
                           splitLine: {show:false}
                       },
                       series: [{
                           data:data,
                           type: 'bar',
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
                   echarts.init(document.getElementById('serviceNeed')).setOption(option);
                    
                })();
                
                $.get(CONFIG.baseUrl + 'datastat/userTypeCounts.do', function(stat) {
                    //用户类型
                    (function() {
                        var countMap = {};
                        stat.forEach(function(c) {
                            countMap[c.userType] = c.count;
                        });
                        var data = [];
                        var i = 0;
                        var colors =['#86cef7', '#6396ec', '#ff8050', '#3bcc44'];
                        _.forEach(DictMan.itemMap('user.type'), function(text, key) {
                            data.push({
                                value: countMap[key],
                                name: text,
                                itemStyle: {color: colors[i++]}
                            });
                        });
            
                        var option = {
                            title: {
                                text: '用户类型',
                                textStyle: textStyle,
                                left: 'center'
                            },
                    
                            tooltip : {
                                trigger: 'item',
                                formatter: "{a} <br/>{b} : {d}% ({c})"
                            },
                            series : [
                                {
                                    name:'用户类型',
                                    type:'pie',
                                    radius : '40%',
                                    center: ['50%', '50%'],
                                    data: data,
                                    itemStyle: {
                                        emphasis: {
                                            shadowBlur: 10,
                                            shadowOffsetX: 0,
                                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                                        }
                                    },
                                    label: {
                                        formatter: '{b} {d}% ({c})'
                                    }
                                }
                            ],
                            textStyle: textStyle
                        };
                        echarts.init(document.getElementById('userType')).setOption(option);
                    })();
                });
                    
                //经济状况
                (function() {
                    return;
                    var colors = ['#6396ec','#fe69b3','#3bcc44'];
                    var data=[];
                    var i = 0;
                   _.forEach(DictMan.itemMap("user.economy"),function(text,key){
                       data.push({
                           value: stat.userProfile['user.economy'][key],
                           name: text,
                           itemStyle: {color: colors[i++]}
                       });
                   });
                   var option = {
                        title: {
                            text: '老年人经济状况',
                            textStyle: textStyle,
                            left: 20
                        },
                        tooltip : {},
                        xAxis: {
                            type: 'category',
                            data: _.values(DictMan.itemMap('user.economy')),
                            axisLine: {
                                lineStyle: {
                                    color: '#d9eff2'
                                }
                            },
                            axisTick: {show: false},
                            splitLine: {show:false}
                        },
                        yAxis: {
                            name: '人数',
                            type: 'value',
                            axisLine: {
                                lineStyle: {
                                    color: '#d9eff2'
                                }
                            },
                            axisTick: {show: false},
                            splitLine: {show:false}
                        },
                        series: [{
                            data:data,
                            type: 'bar',
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
                    echarts.init(document.getElementById('economy')).setOption(option);
                })();

                //生活区域
                (function() {
                    return;
                    var colors = ['#6396ec','#fe69b3'];
                    var data=[];
                    var i = 0;
                    _.forEach(DictMan.itemMap("user.regionDist"),function(text,key){
                       data.push({
                           value: stat.userProfile['user.regionDist'][key],
                           name: text,
                           itemStyle: {color: colors[i++]}
                       });
                    });
                    var option = {
                        title: {
                            text: '老年人生活区域分布',
                            textStyle: textStyle,
                            left: 20
                        },
                
                        tooltip : {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c} ({d}%)"
                        },
                        series : [
                            {
                                name:'生活区域',
                                type:'pie',
                                radius : '55%',
                                center: ['50%', '50%'],
                                data: data,
                                itemStyle: {
                                    emphasis: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ],
                        textStyle: textStyle
                    };
                    echarts.init(document.getElementById('regionDist')).setOption(option);
                })();
                
                //婚姻
                (function() {
                    return;
                    var colors = ['#6396ec','#fe69b3','#3bcc44','#ff8050','#86cef7'];
                    var data=[];
                    var i = 0;
                    _.forEach(DictMan.itemMap("user.marriage"),function(text,key){
                       data.push({
                           value: (stat.userProfile['user.marriage'][key] > 0 ) ? stat.userProfile['user.marriage'][key] : 0,
                           name: text,
                           itemStyle: {color: colors[i++]}
                       });
                    });
                    var option = {
                        title: {
                            text: '老年人婚姻状态',
                            textStyle: textStyle,
                            left: 20
                        },
                        tooltip : {},
                        xAxis: {
                            type: 'category',
                            data: _.values(DictMan.itemMap('user.marriage')),
                            axisLine: {
                                lineStyle: {
                                    color: '#d9eff2'
                                }
                            },
                            axisTick: {show: false},
                            splitLine: {show:false}
                        },
                        yAxis: {
                            name: '人数',
                            type: 'value',
                            axisLine: {
                                lineStyle: {
                                    color: '#d9eff2'
                                }
                            },
                            axisTick: {show: false},
                            splitLine: {show:false}
                        },
                        series: [{
                            data:data,
                            type: 'bar',
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
                    echarts.init(document.getElementById('marriage')).setOption(option);
                })();
            });
        }
    }
    
    
});
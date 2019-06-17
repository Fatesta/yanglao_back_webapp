require(['/lib/echarts/echarts.min.js'], function(echarts) {
    redrawCharts();
    
    $('.main-title').title('活动数据统计分析');
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
        
        $.get(CONFIG.baseUrl + 'datastat/activity/get.do', function(ret) { 
        	
        	//总数
            (function() {
                $('#totalpeople').styledNumber(ret.peopletotal);
            })();
            (function() {
                $('#totalcount').styledNumber(ret.total);
            })();
           
        	
        	//各个根据次数对比--柱状图
            (function() {
            	 var data = [];
            	 var categorys =[];
                 _.forEach(DictMan.items('activity.category'), function(item) {
                     data[item.value] = {
                         value: 0,
                         name: item.text,
                         itemStyle: {
                        	 color: '#fe69b3'
                         }
                     }
                     categorys.push(item.text);
                 });
                 _.forEach(ret.activityCounts, function(item) {
                     data[item.categoryCode].value = item.count;
                 });
                 data = _.values(data);
                var option = {
                	
	            		title : {
	                             text: '各类型活动次数对比统计图',
	                             textStyle: textStyle,
	                             left:'center'
	                         },
	                   
	                    
	                    legend : {
	                	     x: 'center',
	                	     
	                    	 data:['总活动次数'],
	                    	 left:'center',
	                         top:'5%',
	                        
	                         textStyle:{//图例文字的样式
	                             color:'#ccc',
	                             fontSize:16
	                         }
	                    },
	                    tooltip : {  show: true,
	                        trigger: 'item'},
	                    xAxis: {
	                        type: 'category',
	                        data: categorys,
	                        axisLine: {
	                            lineStyle: {
	                                color: '#d9eff2'
	                            }
	                        },
	                        axisLabel:{
	                        	rotate:60
	                        },
	                        splitLine: {show:false}
	                    },
	                    yAxis: {
	                    	name: '数量',
	                        type: 'value',
	                        axisLine: {
	                            lineStyle: {
	                                color: '#d9eff2'
	                            }
	                        },
	                        splitNumber:1,
	                        axisTick: {show: false},
	                        splitLine: {show:false}
	                    },
	                    series : [{
	                    	name:'活动次数',
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
                echarts.init(document.getElementById('activitymanager1')).setOption(option);
            })();   
            
          //各个行业总活动参与人数对比统计图--柱状图
            (function() {
            	 var data = [];
            	 var categorys =[];
                 _.forEach(DictMan.items('activity.category'), function(item) {
                     data[item.value] = {
                         value: 0,
                         name: item.text,
                         itemStyle: {color:'#86cef7'}
                     }
                     categorys.push(item.text);
                 });
                 _.forEach(ret.paCounts, function(item) {
                     data[item.categoryCode].value = item.count;
                 });
                 data = _.values(data);

                var option = {
                		 title : {
                             text: '各类型活动总参与人数对比统计图',
                             textStyle: textStyle,
                             left:'center'
                         },
                
                    
                    legend : {
                	     x: 'center',
                	     
                    	 data:['总参与人数' ],
                    	 left:'center',
                         top:'5%',
                         
                         textStyle:{//图例文字的样式
                             color:'#ccc',
                             fontSize:16
                         }
                    },
                    tooltip : {  show: true,
                        trigger: 'item'},
                    xAxis: {
                        type: 'category',
                        data: categorys,
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisLabel:{
                        	rotate:60
                        }, 	
                        splitLine: {show:false}
                    },
                    yAxis: {
                        name: '数量',
                        type: 'value',
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2'
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:false}
                    },
                    series : [
                    {	
                    	name:'参与人数',
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
                    } ],
                    textStyle: textStyle
                };
                echarts.init(document.getElementById('activitymanager2')).setOption(option);
            } )();
        });         
    }   
});
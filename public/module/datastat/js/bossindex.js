require(['/lib/echarts/echarts.min.js'], function(echarts) {
    redrawCharts();
    
    $('.main-title').title('服务商数据统计分析');
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
        
        $.get(CONFIG.baseUrl + 'datastat/bossAbout.do', function(ret) { 
        	
        	//总数
            (function() {
                $('#bosscount').styledNumber(ret.bosscount);
            })();
            (function() {
                $('#shopcount').styledNumber(ret.shopcount);
            })();
            (function() {
                $('#productcount').styledNumber(ret.productcount);
            })();
            (function() {
                $('#ordercount').styledNumber(ret.ordercount);
            })();
        	//各个行业根据店铺分布--饼状
        	(function(){
        		var data=[];
        		if(ret.sysOperator!=1){
        		 data = [
    		                {value: ret.housekeepingshop, name:'家政', itemStyle: {color: '#6396ec'}},
		                    {value: ret.cateringshop, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
		                   
		                    {value: ret.activityshop, name:'活动', itemStyle: {color: '#fff495'}},
		                    {value: ret.mallshop, name:'电子商城', itemStyle: {color: '#ff8050'}}
		                    ];
        		}else{
        			data = [
    		                {value: ret.housekeepingshop, name:'家政', itemStyle: {color: '#6396ec'}},
		                    {value: ret.cateringshop, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
		                    {value: ret.integralmallshop, name:'积分商城', itemStyle: {color: '#3bcc44'}},
		                    {value: ret.activityshop, name:'活动', itemStyle: {color: '#fff495'}},
		                    {value: ret.mallshop, name:'电子商城', itemStyle: {color: '#ff8050'}}
		                    ];	
        		}
        		var option = {
        				title :{
        					text:'各行业的店铺统计图',
        					textStyle:textStyle,
        					left:'center'
        				},
        				
        				tooltip:{
        					trigger:'item',
        					formatter:"{a} <br/>{b} : {c} ({d}%)"
        				},
        				
        				series :[{
        					name:'各行业店铺数量',
        					type:'pie',
        					radius:'55%',
        					center:['50%','50%'],
        					data:data,
        					itemStyle:{
        						emphasis:{
        							shadowBlur:10,
        							shadowOffsetX:0,
        							shadowColor:'rgba(0,0,0,0.5)'
        						}
        					},
        					 label:{
                                 show:true,
                                 formatter:'{b} {d}% ({c})'
                             }
        				}],
        				textStyle: textStyle
        		};
        		echarts.init(document.getElementById('shopanalysis')).setOption(option);
        	})();
        	
        	//各个行业根据商品分布--饼状
        	(function(){
        		var data=[];
        		if(ret.sysOperator!=1){
        		 data = [
        		            {value: ret.housekeepingproduct, name:'家政', itemStyle: {color: '#6396ec'}},
		                    {value: ret.cateringproduct, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
		                   
		                /*    {value: ret.activityproduct, name:'活动', itemStyle: {color: '#fff495'}},*/
		                    {value: ret.mallproduct, name:'电子商城', itemStyle: {color: '#ff8050'}}
        		            ];
        		}else{
    			 data = [
     		            {value: ret.housekeepingproduct, name:'家政', itemStyle: {color: '#6396ec'}},
	                    {value: ret.cateringproduct, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
	                    {value: ret.integralmallproduct, name:'积分商城', itemStyle: {color: '#3bcc44'}},
	                /*    {value: ret.activityproduct, name:'活动', itemStyle: {color: '#fff495'}},*/
	                    {value: ret.mallproduct, name:'电子商城', itemStyle: {color: '#ff8050'}}
     		            ];	
        		}
        		var option = {
        				title:{
        					text:'各行业的商品数量统计图',
        					textStyle:textStyle,
        					left:'center'
        				},
        				tooltip:{
        					trigger:'item',
        					formatter:"{a} <br/>{b} : {c} ({d}%)"
        				},
        				series:[{
        					name:'各行业商品数量',
        					type:'pie',
        					radius:'55%',
        					center:['50%','50%'],
        					data:data,        				
        					itemStyle:{
        						emphasis:{
        							shadowBlur:10,
        							shadowOffsetX:0,
        							shadowColor:'rgba(0,0,0,0.5)'
        						}
        					},
        					 label:{
                                 show:true,
                                 formatter:'{b} {d}% ({c})'
                             }
        					
        				}],
        				textStyle: textStyle  				
        		};
        		echarts.init(document.getElementById('productanalysis')).setOption(option);
        	})();
        	
        	//各个行业根据订单分布--柱状图
            (function() {
            	var data=[];
        		if(ret.sysOperator!=1){
        			data = [
				            {value: ret.housekeepingorder, name:'家政', itemStyle: {color: '#6396ec'}},
		                    {value: ret.cateringorder, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
		                  
		                    {value: ret.activityorder, name:'活动', itemStyle: {color: '#fff495'}},
		                    {value: ret.mallorder, name:'电子商城', itemStyle: {color: '#ff8050'}}
		                    ];
        		}else{
        			data = [
				            {value: ret.housekeepingorder, name:'家政', itemStyle: {color: '#6396ec'}},
		                    {value: ret.cateringorder, name:'社区食堂', itemStyle: {color: '#ef76b8'}},
		                    {value: ret.integralmallorder, name:'积分商城', itemStyle: {color: '#3bcc44'}},
		                    {value: ret.activityorder, name:'活动', itemStyle: {color: '#fff495'},barWidth:20},
		                    {value: ret.mallorder, name:'电子商城', itemStyle: {color: '#ff8050'},barWidth:20}
		                    ];
        		}
                var xAxisData = _.pluck(data, 'name');

                var option = {
                    title : {
                        text: '各行业的订单统计图',
                        textStyle: textStyle,
                        left:'center'
                    },
                    tooltip : {},
                    xAxis: {
                        type: 'category',
                        data: xAxisData,
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2',  //x坐标轴的抽线颜色
                                width: 2 //这里是坐标轴的宽度，为0就是不显示
                            }
                        },
                        axisTick: {show: true},
                        axisLabel:{show:true}//控制坐标轴x轴的文字是否显示
                    },
                    yAxis: {
                        name: '数量',
                        type: 'value',
                        axisLine: {
                            lineStyle: {
                                color: '#d9eff2',
                                width: 2
                            }
                        },
                        axisTick: {show: false},
                        splitLine: {show:true,
                        	color: 'ffe4e1',
                        	lineStyle:{
                                color: ['#ccc'],
                                width: 0.7,
                                type: 'dashed'
                        	}},
                        axisLabel:{show:true}//控制坐标轴y轴的文字是否显示
                    },
                    series : [{
                        type: 'bar',
                        data: data,
                        barWidth:37,
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
                echarts.init(document.getElementById('bossmanagernumbers')).setOption(option);
            })();        
        });         
    }   
});
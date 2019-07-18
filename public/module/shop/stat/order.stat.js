define([CONFIG.modulePath + 'shop/stat/statquerier.js?v=1.4'], function(StatQuerier) {
    return function() {
        return new StatQuerier({
            elem: "#order",
            onQuery: function(params) {
                $("#order #countCanvasDiv").hide();
                $.get(CONFIG.baseUrl + "shop/stat/queryOrdersStats.do", params, function(data){
                    if(data.length == 0) {
                        showAlert("提示", params.timeTitle + " 无数据", "info");
                        return;
                    }
                    drawCount(params, data);
                });
            }
        });
    }
    
    function drawCount(params, statData) {
        $("#order #countCanvasDiv").fadeIn('fast');
        
        var data = [{
            name : '订单数',
            value: _.pluck(statData, 'ordersQuantity'),
            color:'#ec4646',
            line_width:2
        }];
        var labels = _.map(statData, 'statDate').map(function(date) {
            return date.split('-').map(function(s) {
                return s[0] == '0' ? s.substring(1) : s;
            }).join('-');
        });

        // 计算累计
        function plus(x, y) { return x + y; }
        var totalOrdersQuantity = _.reduce(_.pluck(statData, "ordersQuantity"), plus);
        
        // 标题
        var titleText = params.timeTitle + '订单数统计';
        var subtitleText = "累计订单数:{0}".format(totalOrdersQuantity);
        
        var endScale = Math.max(8, Math.ceil(Math.max.apply(null, _.pluck(statData, "ordersQuantity"))));
        var scaleSpace = endScale / statData.length;
        
        var line = new iChart.LineBasic2D({
            render : 'countCanvasDiv',
            data: data,
            align:'center',
            title: titleText,
            width : $(document).width() - 160,
            height : ($(document).height() - 200) / 1,
            tip:{
                enable:true,
                shadow:true
            },
            crosshair:{
                enable:true,
                line_color:'#ec4646'
            },
            sub_option : {
                point_size:8
            },
            coordinate:{
                width : "94%",
                height: "90%",
                axis:{
                    color:'#9f9f9f',
                    width:[0,0,2,2]
                },
                grids:{
                    vertical:{
                        way:'share_alike',
                        value:5
                    }
                },
                scale:[{
                     position:'left',   
                     start_scale:0,
                     end_scale: endScale,
                     scale_space: scaleSpace,
                     scale_size:2,
                     scale_color:'#9f9f9f',
                     listeners:{
                         parseText:function(t,x,y){
                             return {text: parseInt(t)};
                         }
                     }
                },{
                     position:'bottom', 
                     labels:labels
                }]
            },
            animation: true
        });

        line.draw();
    }

})
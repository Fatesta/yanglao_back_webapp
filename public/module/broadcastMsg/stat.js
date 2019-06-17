/**
@author hulang 
*/
$(function() {
    $("[name=query]").click(function(){
        var params = $("#frmQuery").serializeObject();
        
        // 设置未输入值
        if(!params.startCreateTime && !params.endCreateTime) {
            // 默认查询最近一月
            params.startCreateTime = moment().subtract(15, 'day').format('YYYY-MM-DD');
            params.endCreateTime = moment().format('YYYY-MM-DD');
        }
        else if(!params.startCreateTime && params.endCreateTime)
            params.startCreateTime = moment(params.endCreateTime).subtract(15, 'day').format('YYYY-MM-DD');
        else if(params.startCreateTime && !params.endCreateTime)
            params.endCreateTime = moment(params.startCreateTime).add(15, 'day').format('YYYY-MM-DD');
        
        $("#startCreateTime").datebox("setValue", params.startCreateTime);
        $("#endCreateTime").datebox("setValue", params.endCreateTime);
        
        var diffDays = moment(params.endCreateTime).diff(moment(params.startCreateTime), 'days');
        if(diffDays < 0) {
            showAlert("提示", "开始时间大于结束时间", "info");
            return;
        }
        // 判断差值大于31天
        if(diffDays + 1 > 31) {
            showAlert("提示", "开始时间与结束时间相差大于一个月", "info");
            return;
        }
        
        queryForDraw(params);
    });

    $("[name=query]").click();
    
    // 根据条件查询
    function queryForDraw(queryParams, callback) {
        $.get(CONFIG.baseUrl + "broadcastMsg/queryCount.do", queryParams, function(queryCounts){
            if(queryCounts.length == 0) {
                $("#canvasDiv").hide();
                showAlert("提示", "无数据", "info");
                return;
            }
            callback && callback();
            draw(queryParams, queryCounts);
        });
    }
    
    function draw(dates, counts) {
        counts.forEach(function(p){ return p.other = p.total - p.success; });
        
        // 计算累计
        function add(x, y) { return x + y; }
        totalTimes = _.reduce(_.pluck(counts, "count"), add);;
        totalUsers = _.reduce(_.pluck(counts, "total"), add);
        totalSuccessUsers = _.reduce(_.pluck(counts, "success"), add);
        totalOtherUsers = _.reduce(_.pluck(counts, "other"), add);
        
        // 将日期填满
        var fullCounts = [];
        var itrDate = moment(dates.startCreateTime);
        var maxDate = moment(dates.endCreateTime);
        itrDate.subtract(1, 'days');
        for(var d = 0, end = maxDate.diff(itrDate, 'days'); d < end; d++) {
            var cnt = {date: itrDate.add(1, 'days').format("YYYY-MM-DD"), total: 0, success: 0, count: 0};
            fullCounts[cnt.date] = cnt;
        }
        counts.forEach(function(cnt){
            fullCounts[cnt.date] = cnt;
        });
        counts = _.values(fullCounts);

        // 转换为ichart数据结构
        // 堆积柱形图数据
        var columnStackedData = [];
        columnStackedData.push({
            name: "未收听",
            value: _.pluck(counts, "other"),
            color:'#9F2626'
        });
        columnStackedData.push({
            name: "已收听",
            value: _.pluck(counts, "success"),
            color:'#3A68D3'
        });
        // 对应底部标签
        var columnStackedLabels = counts.map(function(cnt){ return moment(cnt.date).format("M.D"); });
        
        // 折线图数据
        var lineData = {
            name : '传达次数',
            value: _.pluck(counts, "count"),
            color:'#0d8ecf',
            line_width:2
        };
        var lineEndScale = Math.max.apply(null, _.pluck(counts, "count"));

        // 标题
        var titleText = moment(dates.startCreateTime).format("YYYY年M月D日");
        if(dates.startCreateTime != dates.endCreateTime)
            titleText += '到' + moment(dates.endCreateTime).format("YYYY年M月D日");
        titleText += '传达统计';
        var subtitleText = "累计传达次数:{0}；累计发送人数:{1}；累计已收听人数:{2}；累计未收听人数:{3}".format(
            totalTimes, totalUsers, totalSuccessUsers, totalOtherUsers);
        
        $("#canvasDiv").show(); // 为新数据显示
        // draw chart
        var chart = new iChart.ColumnStacked3D({
            render : 'canvasDiv',
            data : columnStackedData,
            labels: columnStackedLabels,
            title:{
                text: titleText,
                fontsize:20,
                font:"微软雅黑",
                textAlign:'center',
            },
            subtitle: {
                text: subtitleText,
                fontsize:16,
                font:"微软雅黑",
                textAlign:'center',
            },
            width : $(document).width() - 40,
            height : $(document).height() - 60,
            align:"center",
            shadow : true,
            shadow_color:'#080808',
            column_width: 20,
            sub_option : {
                label:{color:'#ffffff',fontsize:12,fontweight:600},
                listeners:{
                    parseText:function(r,t){
                        return t ? t : "";
                    }
                }
            },
            legend:{
                enable:true,
                border:{radius:2},
                line_height:15,
                color: '0d8ecf',
                align: 'right',
                valign: 'top',
                row: 'max',
                fontweight:600,
                offsetx:-10,
                offsety:-26,
                column: 1
            },
            tip:{
                enable :true,
                listeners:{
                    //tip:提示框对象、name:数据名称、value:数据值、text:当前文本、i:数据点的索引
                    parseText:function(tip,name,value,text,i){
                        return value > 0 ? name+"："+value : "";
                    }
                } 
            },
            text_space : 14,
            coordinate : {
                grid_color : '#ffffff',
                width : "97%",
                height: "90%",
                board_deep:10,//背面厚度
                pedestal_height:10,//底座高度
                left_board:false,//取消左侧面板 
                axis : {
                    color:'#9f9f9f',
                    width : [0, 0, 1, 0]
                },
                scale : [{
                    position : 'left',
                    scale_enable : lineData.value.length > 1,
                    scaleAlign:'left',
                    listeners:{
                        parseText:function(t,x,y){
                            return {text:
                                lineData.value.length > 1 ?
                                    (parseInt(t) == t ? parseInt(t) : "") : ""};
                        }
                    }
                }]
            }
        });
        //构造折线图
        var line = new iChart.LineBasic2D({
            z_index:1000,
            data: [ lineData ],
            animation : true,//开启过渡动画
            animation_duration:800,
            point_space:chart.get('column_width')+chart.get('column_space'),
            scaleAlign : 'left',
            sub_option : {
                label : {
                    color:'#000000',fontsize:14,fontweight:600
                },
                listeners:{
                    parseText:function(r,t){
                        return t ? t : "";
                    }
                },
                point_size: 8,
                point_hollow : false
            },
            tip:{
                enable :true,
                listeners:{
                    //tip:提示框对象、name:数据名称、value:数据值、text:当前文本、i:数据点的索引
                    parseText:function(tip,name,value,text,i){
                        return "<h1>" + moment(counts[i].date).format("YYYY年M月D日") + "</h1>"
                            + "<p>传达次数：" + value
                            + "<p>发送人数：" + counts[i].total;
                    }
                }
            },
            legend : {
                enable : true,
                row:1,//设置在一行上显示，与column配合使用
                column : 'max',
                valign:'top',
                align: 'left',
                sign:'bar',
                background_color:null,//设置透明背景
                fontweight:600,
                offsety:-10,
                offsetx:20,
                border : true
            },
            coordinate: chart.coo//共用坐标系
        });
        
        chart.plugin(line);

        chart.draw();
    }

});

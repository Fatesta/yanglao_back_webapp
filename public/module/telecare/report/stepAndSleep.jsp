<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<style>
#telecare-stepAndSleep-layout .chart {
    margin-top: 10px;
    float: left;
}
/* 网格布局 */
.row {
    margin-top: 20px;
    position: relative;
    width: 100%;
    height: 100px;
}

.col-6 {
    position: relative;
    width: 50%;
    height: 100%;
    float: left;
}

</style>
<div id="telecare-stepAndSleep-layout" class="easyui-layout">
    <div class="chart">
        <div></div>
		<div id="telecare-stepAndSleep-week-exercisea-chart" class="chart-container"></div>
    </div>
    <div class="chart">
        <div></div>
        <div id="telecare-stepAndSleep-week-sleep-chart" class="chart-container"></div>
    </div>
</div>

<script>
define('telecare.report.stepAndSleep', ['echarts'], function(echarts) {
    return function (queryParams) {
        var width = $('#telecare-stepAndSleep-layout').width();
        var height = $('#telecare-stepAndSleep-layout').height();
        
        // 最近一周日期
        var dates = [];
        var mdate = moment(queryParams.date).subtract(7, 'days');
        for (var i = 0; i < 7; i++) {
            mdate.add(1, 'days');
            dates.push(mdate.format('MM-DD'));
        }
        var option = {
            title: {
                text: '近一周步数',
                left: 'center'
            },
            tooltip: {
                show: true,
                trigger: 'axis'
            },
            xAxis: {
                type: 'category',
                data: dates
            },
            yAxis: {
                name: '步数',
                type: 'value'
            },
            series: [{
                data: [820, 932, 901, 934, 1290, 1330, 1320],
                type: 'line'
            }],
            color: '#41a4f5'
        };
        var container = $('#telecare-stepAndSleep-week-exercisea-chart');
        container.width(width * 0.5);
        container.height(height);
        echarts.init(container.get(0)).setOption(option);

        $.get(CONFIG.baseUrl + 'device/listHistorySteps.do?days=7&deviceCode=' + user.deviceCode, function(items){
            items.forEach(function(item, i){
                option.series[0].data[i] = item.stepCount;
            });
            echarts.init(container.get(0)).setOption(option);
        });

        var option = {
            title: {
                text: '近一周睡眠时间',
                left: 'center'
            },
            tooltip: {
                show: true,
                trigger: 'axis'
            },
            xAxis: {
                type: 'category',
                data: dates
            },
            yAxis: {
                name: '小时数',
                type: 'value',
                data: [3, 6, 9, 10]
            },
            series: [{
                data: [6, 6, 6, 7, 6, 9, 8],
                type: 'line'
            }],
            color: '#41a4f5'
        };
    
        var container = $('#telecare-stepAndSleep-week-sleep-chart');
        container.width(width * 0.5);
        container.height(height);
        echarts.init(container.get(0)).setOption(option);
    }
})
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<style>
#telecare-activityLevel-chart {
    margin: 10px auto;
}

</style>
<div id="telecare-activityLevel-layout" class="easyui-layout">
    <div id="telecare-activityLevel-chart" class="chart-container"></div>
</div>

<script>
define('telecare.report.activityLevel', ['echarts'], function(echarts) {
    return function (queryParams) {
        var width = $('#telecare-activityLevel-layout').width();
        var height = $('#telecare-activityLevel-layout').height();

        function draw(items) {
            // 最近一周日期
            var dates = [];
            var times = [];
            var mdate = moment(queryParams.date).subtract(7, 'days');
            for (var i = 0; i < 7; i++) {
                mdate.add(1, 'days');
                var date = mdate.format('MM-DD');
                dates.push(date);
                times.push(0);
            }

            items.forEach(function(item) {
                for (var i in dates) {
                    if (item.date.substring(5) == dates[i]) {
                        times[i] = item.times;
                        break;
                    }
                }
            });


            var option = {
                title: {
                    text: '近一周家中无人活动报警次数',
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
                    name: '次数',
                    type: 'value'
                },
                series: [{
                    data: times,
                    type: 'bar',
                    barWidth: 20
                }],
                color: '#41a4f5'
            };
            var container = $('#telecare-activityLevel-chart');
            container.width(width * 0.5);
            container.height(height);
            echarts.init(container.get(0)).setOption(option);
        }

        $.get(CONFIG.baseUrl + 'telecare/report/activityTimes.do?userId=' + user.userId + '&endDate=' + queryParams.date, function(items){
            draw(items);
        });

    }
})
</script>
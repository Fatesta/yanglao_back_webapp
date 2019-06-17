<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<style>
.highcharts-credits {
  display: none
}
</style>

<div id="telecare-dailyActivities-layout" class="easyui-layout">
	<div id="telecare-dailyActivities-charts-container" style="padding: 20px 10px 0 20px;"></div>
</div>

<script>
define('telecare.report.dailyActivities', ['highcharts'], function() {
    return function (queryParams) {
	    var container = $('#telecare-dailyActivities-charts-container');
	    container.height($('#telecare-dailyActivities-layout').height() - 50);
	    
	    // 定义任务
		var tasks = [{
		        title: '浴室',
		        color: '#21cafe',
		        intervals: [{ // From-To pairs
		                from: Date.UTC(2018, 6, 10, 18, 00),
		                to: Date.UTC(2018, 6, 10, 18, 30)
		        }]
		}, {
		        title: '卧室',
		        color: '#ac57e3',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 0, 0),
		                to: Date.UTC(2018, 6, 10, 7, 30)
		        }, {
		                from: Date.UTC(2018, 6, 10, 14, 0),
		                to: Date.UTC(2018, 6, 10, 15, 0)
		        }, {
		                from: Date.UTC(2018, 6, 10, 21, 30),
		                to: Date.UTC(2018, 6, 10, 24, 0)
		        }]
		}, {
		        title: '出门',
		        color: '#e55e5c',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 13, 20),
		                to: Date.UTC(2018, 6, 10, 14, 0)
		        }]
		}, {
		        title: '客厅',
		        color: '#50abf8',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 9, 30),
		                to: Date.UTC(2018, 6, 10, 12, 30)
		        }, {
		                from: Date.UTC(2018, 6, 10, 15, 0),
		                to: Date.UTC(2018, 6, 10, 16, 30)
		        }]
		}, {
		        title: '洗手间',
		        color: '#4182fb',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 7, 40),
		                to: Date.UTC(2018, 6, 10, 7, 45)
		        }, {
		                from: Date.UTC(2018, 6, 10, 17, 40),
		                to: Date.UTC(2018, 6, 10, 17, 43)
		        }]
		}, {
		        title: '餐厅',
		        color: '#fb990c',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 7, 50),
		                to: Date.UTC(2018, 6, 10, 8, 35)
		        }, {
		                from: Date.UTC(2018, 6, 10, 18, 30),
		                to: Date.UTC(2018, 6, 10, 19, 3)
		        }]
		}, {
		        title: '其它房间',
		        color: '#54b837',
		        intervals: [{
		                from: Date.UTC(2018, 6, 10, 20, 30),
		                to: Date.UTC(2018, 6, 10, 21, 30)
		        }]
		}];
	    
	    $.get(CONFIG.baseUrl + 'telecare/report/dailyTasks.do', queryParams, function(tasks) {
	        draw(tasks);
	    });
	    
	    
	    function draw(tasks) {
	        //重新构造“任务”数据结构
	        var series = [];
	        /*
	        var otherTask = tasks[tasks.length - 1];
	        otherTask.title = '其它位置';
	        otherTask.color = '54b837';
	        otherTask.icon = CONFIG.imagePath + 'telecare/other_time.png';
	        */
	        $.each(tasks.reverse(), function(i, task) {
	            var item = {
	                title: task.title,
	                color: '#' + task.color,
	                data: []
	            };
                if (task.intervals.length == 0) {
                    var emptyInterval = {
                        from: moment(queryParams.date + ' 00:00:00').unix() * 1000,
                        to: moment(queryParams.date + ' 23:59:59').unix() * 1000,
                    };
                    item.color = 'transparent';
                    task.empty = true;
                    task.intervals.push(emptyInterval);
                }
	            task.intervals.forEach(function(interval) {
                    var toM = function(time) {
                        var date = new Date(time);
                        return Date.UTC(date.getFullYear(), date.getMonth() + 1, date.getDate(),
                            date.getHours(), date.getMinutes())
                    };
                    interval.from = toM(interval.from);
                    interval.to = toM(interval.to);
	            });

	            task.intervals.forEach(function(interval, j) {
	                item.data.push({
	                    x: interval.from,
	                    y: i,
	                    label: interval.label,
	                    from: interval.from,
	                    to: interval.to
	                }, {
	                     x: interval.to,
	                     y: i,
	                     from: interval.from,
	                     to: interval.to
	                });
	                // add a null value between intervals
	                if (task.intervals[j + 1]) {
	                     item.data.push(
	                         [(interval.to + task.intervals[j + 1].from) / 2, null]
	                     );
	                }
	            });
	            series.push(item);
	        });
	        
	        // 创建chart
	        var chart = new Highcharts.Chart({
	            chart: {
	                renderTo: container.attr('id')
	            },
	            title: {
	                text: queryParams.date + '全天活动',
	                style: {fontSize: '1.5em', fontFamily: '微软雅黑'},
	                useHTML: true,
	                margin: 0,
	            },
	            xAxis: {
	                type: 'datetime',
	                gridLineWidth: 1,
	                tickInterval: 3600 * 1000,
	                tickLength: 20,
	                showFirstLabel: false,
	                showLastLabel: false,
	                crosshair: true,
	                labels: {
	                    y: 40,
	                    style: {fontSize: '1.1em', fontFamily: '微软雅黑'}
	                }
	            },
	            yAxis: {
	                offset: 100,
	                tickInterval: 1,
	                labels: {
	                    useHTML: true,
	                    align: 'left',
	                    formatter: function() {
	                        var task = tasks[this.value];
	                        if (task) {
	                            var html = '';
	                            html += '<img style="vertical-align: middle;" src="' + task.icon + '" width=40 height=40>';
	                            html += '<span style="margin-left: 4px; vertical-align: middle;font-size: 1.2em;">' + task.title + '</span>';
	                            return html;
	                        }
	                    },
	                     style: {
	                        fontSize: '1em',
	                        fontFamily: '微软雅黑',
	                     }
	                },
	                startOnTick: false,
	                endOnTick: false,
	                title: {
	                    enabled: false
	                },
	                minPadding: 0.1,
	                maxPadding: 0.1,
	                gridLineWidth: 12,
	                gridLineColor: '#f5f5f5'
	            },
	            legend: {
	                enabled: false
	            },
	            tooltip: {
	                formatter: function() {
	                    var task = tasks[this.y];
	                    return task.empty ? '无活动' : '<b>'+ task.title + '</b><br/>' +
	                         Highcharts.dateFormat('%H:%M', this.point.options.from)  +
	                         ' - ' + Highcharts.dateFormat('%H:%M', this.point.options.to); 
	                }
	            },
	            plotOptions: {
	                line: {
	                    className: 'intervalLine',
	                    lineWidth: 22,
	                    marker: {
	                        enabled: false
	                    },
	                    dataLabels: {
	                        enabled: true,
	                        align: 'left',
	                        formatter: function() {
	                            return this.point.options && this.point.options.label;
	                        }
	                    }
	                }
	            },
	            series: series
	        });
	    }
    }
});
</script>
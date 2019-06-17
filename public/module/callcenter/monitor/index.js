$(function() {
    $('#timeRange').combobox({
        onChange: function(value) {
            var params = {};
            var startTime, endTime;//查询日期区间
            switch (value) {
            case 'today':
                startTime = moment();
                endTime = startTime;
                params.PageSize = 1;
                break;
            case 'this_week':
                startTime = moment().startOf('week').add(1, 'd');
                endTime = moment().endOf('week').add(1, 'd');
                params.PageSize = 7;
                break;
            case 'this_month':
                startTime = moment().startOf('month');
                endTime = moment().endOf('month');
                params.PageSize = endTime.diff(startTime, 'days') + 1;
                break;
            case 'last_7days':
                startTime = moment().subtract(7, 'days');
                endTime = moment();
                params.PageSize = 7;
                break;
            }
    
            params.PageNumber = 1;
            params.Interval = 'Daily';
            params.StartTime = startTime.format('YYYY-MM-DD 00:00:00');
            params.EndTime = endTime.format('YYYY-MM-DD 23:59:59');
            query(params);
        }
    });
    $('#timeRange').combobox('select', 'this_week');
    $('#timeRange').combobox('setValue', 'this_week');
});

function query(params) {
    $.get(CONFIG.baseUrl + 'callcenter/report/GetInstanceSummaryReportByInterval.do', params, function(ret) {
        refresh(ret.instanceTimeIntervalReport.intervalList)
    });
}

function refresh(intervalList) {
    var series = [
      {
          name: '呼入数',
          type: 'line',
          data: []
      },
      {
          name: '呼入接通数',
          type: 'line',
          data: []
      },
      {
          name: '呼出数',
          type: 'line',
          data: []
      },
      {
          name: '呼出接通数',
          type: 'line',
          data: []
      }
    ];
    
    var dates = [];
    
    intervalList.forEach(function(interval, i) {
        series[0].data.push(interval.inbound.callsOffered);
        series[1].data.push(interval.inbound.callsHandled);
        series[2].data.push(interval.outbound.callsDialed);
        series[3].data.push(interval.outbound.callsAnswered);
        dates.push(moment(interval.timestamp).format('MM-DD'));
    });
    
    var option = {
        title: {
            //text: '电话统计',
            //subtext: ''
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        toolbox: {
            top: 0,
            feature: {
                magicType: {show: true, type: ['line', 'bar']},
            }
        },
        legend: {
            data: ['呼入数', '呼入接通数', '呼出数', '呼出接通数']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        yAxis: {
            type: 'value',
            boundaryGap: [0, 0.01]
        },
        xAxis: {
            type: 'category',
            data: dates
        },
        series: series
    };
    echarts.init($('#summary').get(0)).setOption(option);

}
define([CONFIG.modulePath + 'shop/stat/dateselector.js'], function(DateSelector) {
    return function(spec) {
        var parentElem = $(spec.elem);
        init(spec);
        
        this.query = function() {
            parentElem.find("[name=query]").click();
        }
        
        function init(spec) {
            var TIME_SPAN_MAX = {day: 30, month: 12, year: 30};
            
            $(function(){
                function queryOrg() {
                    parentElem.find("#orgId").combobox({
                        url: CONFIG.baseUrl + 'org/communities.do',
                        valueField: 'id',
                        textField: 'name',
                        required: true,
                        loadFilter: function (data) {
                            data.unshift({id: '', name: '全部'});
                            return data;
                        },
                        onSelect: function () {
                            queryBoss();
                        },
                        onLoadSuccess: function () {
                            $(this).combobox("select", '');
                        }
                    });
                }
                function queryBoss() {
                    var params = parentElem.find('#frmQuery').serializeObject();
                    parentElem.find("#cboBoss").combobox({
                        valueField:'bossId',
                        textField:'realName',
                        url: CONFIG.baseUrl + 'shop/boss/bossPage.do?' + $.param(params),
                        queryParams: {page:1, rows:10000},
                        required: true,
                        loadFilter:function(data){
                            data.rows.unshift({bossId:'0', realName: '全部'});
                            return data.rows;
                        },
                        onSelect: function(record) {
                            parentElem.find("#frmQuery [name=bossId]").val(record.bossId == '0' ? '' : record.bossId);
                            queryProvider();
                        },
                        onLoadSuccess: function() {
                            $(this).combobox("select", '0');
                        }
                    });
                }
                
                function queryProvider(cond) {
                    var params = parentElem.find('#frmQuery').serializeObject();
                    params.page = 1;
                    params.rows = 100000;
                    parentElem.find("#cboProvider").combobox({
                        valueField: 'providerId',
                        textField: 'name',
                        url: CONFIG.baseUrl + 'shop/pro/proPage.do?' + $.param(params),
                        loadFilter: function(data) {
                            data.rows.unshift({providerId: '0', name: "全部"});
                            return data.rows;
                        },
                        onLoadSuccess: function() {
                            $(this).combobox("select", '0');
                        }
                    });
                }

                queryOrg();
                queryBoss();
                queryProvider();
            });
            
            var startDateSelect = new DateSelector({
                elem: parentElem.find("#startTime"), minYear: 2017, maxYearIsNow: true, yearOrder: 'asc'});
            var endDateSelect = new DateSelector({
                elem: parentElem.find("#endTime"), minYear: 2017, maxYearIsNow:true, yearOrder: 'desc'});
            
            parentElem.find("#timeUnit").combobox({
                onSelect: function(record) {
                    [startDateSelect, endDateSelect].forEach(function(dateSelector){
                        var timeUnit = record.value;
                        dateSelector.setUnit(timeUnit);
                        
                        /* 设置默认值*/
                        var format = 'YYYY-MM-DD'.substring(0, TIME_SPAN_MAX[timeUnit]);
                        var startTime, endTime;
                        switch(timeUnit) {
                        case 'day':
                            startTime = moment().subtract(TIME_SPAN_MAX[timeUnit] - 1, 'days').format(format);
                            endTime = moment().format(format);
                            break;
                        case 'month':
                            startTime = moment().subtract(TIME_SPAN_MAX[timeUnit], 'month').format(format);
                            endTime = moment().format(format);
                            break;
                        case 'year':
                            startTime = moment().format(format);
                            endTime = startTime;
                            break;
                        }
                        startDateSelect.setValue(startTime);
                        endDateSelect.setValue(endTime);
                    });
                }
            });
            
            parentElem.find("[name=query]").click(function(){
                var params = parentElem.find("#frmQuery").serializeObject();
                params.providerId = params.providerId == '0' ? '' : params.providerId;
        
                var timeUnit = params.timeUnit;
        
                var format = 'YYYY-MM-DD'.substring(0, {day: 10, month: 7, year: 4}[timeUnit]);
                
                // 设置未输入值
                if(!startDateSelect.isFull() && !endDateSelect.isFull()) {
                    // 最近TIME_SPAN_MAX天
                    params.startTime = moment().subtract(TIME_SPAN_MAX[timeUnit] - 1, timeUnit).format(format);
                    params.endTime = moment().format(format);
                }
                else if(!startDateSelect.isFull() && endDateSelect.isFull())
                    params.startTime = moment(params.endTime).subtract(TIME_SPAN_MAX[timeUnit] - 1, timeUnit).format(format);
                else if(startDateSelect.isFull() && !endDateSelect.isFull())
                    params.endTime = moment().format(format);
        
                startDateSelect.setValue(params.startTime);
                endDateSelect.setValue(params.endTime);
                params.startTime = startDateSelect.getValue();
                params.endTime = endDateSelect.getValue();
                
                var diffs = timeUnit != 'year' ?
                    moment(params.endTime).diff(moment(params.startTime), timeUnit) : params.endTime - params.startTime;
                if(diffs < 0) {
                    showAlert("提示", "开始时间大于结束时间", "info");
                    return;
                }
                // 判断差值
                if(diffs + 1 > TIME_SPAN_MAX[timeUnit]) {
                    var unitText = {day:'日',month:'月',year:'年'}[timeUnit];
                    showAlert("提示", "按" + unitText + "统计时间跨度不能超过" + TIME_SPAN_MAX[timeUnit] + unitText, "info");
                    return;
                }
                
                function ymdInTitle(dateStr, timeUnit) {
                    var u = ['年','月','日'];
                    var strs = dateStr.substring(0, {day: 10, month: 7, year: 5}[timeUnit]);
                    return strs.split('-').map(function(s, i){ return s + u[i]; }).join('');
                }
                params.timeTitle = ymdInTitle(params.startTime);
                if(params.startTime != params.endTime) {
                    params.timeTitle += '到' + ymdInTitle(params.endTime);
                }
                
                spec.onQuery(params);
            });
        }
    }
});
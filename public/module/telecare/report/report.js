define(function() {
    var reporterNames = [
        'activityLevel',
        'stepAndSleep',
        'weekStat',
        'doorOpen',
        'alarmRecord'
    ].map(function(name) { return 'telecare.report.' + name });

    return function(queryParams) {
        var selectedReporterIndex = -1;
        
        var tabs = $('#telecare-report-tabs');
        var datebox = $('#telecare-report-layout input[textboxname=date]');
        datebox.datebox({
            onChange: function(newVal, oldVal, notApply) {
                queryParams.date = newVal;
                require(reporterNames, function() {
                    var fs = [].slice.call(arguments);
                    fs.forEach(function(f, index) {
                        f.updated = false;
                        if (!notApply && index == selectedReporterIndex) {
                            applyReporter(f);
                        }
                    });
                });
            }
        }).datebox('options').onChange(datebox.datebox('getValue'), '', true);
        
        tabs.tabs({
            onSelect: function(_, index) {
                selectedReporterIndex = index;
                require(reporterNames.slice(index, index + 1), function(f) {
                    if (!f.updated) {
                        applyReporter(f);
                    }
                });
            }
        }).tabs('options').onSelect(null, 0);
        
        function applyReporter(f) {
            f.call(this, queryParams);
            f.updated = true;
        }

        $.get('/user/getBasicInfo.do?userId=' + user.userId, function(_user) {
            user = _user;
            for (var p in user)
                $('#telecare-report-layout .user-info [name=' + p + ']').text(user[p] || '');
        });

        $('#openVideo').click(function() {
            new VideoArrayWindow().openVideo(user.deviceCode, user.aliasName);
        });
    }
    
});
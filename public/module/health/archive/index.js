var healthHistoryGroup;
$(function() {
    healthHistoryGroup = new HealthHistoryGroup({
        onLoadSuccess: function() {
            if (userId) {
                loadAllInfo(userId);
            }
        }
    });

});


$('#selectUser').click(function() {
    openUserSelectDialog({
        onSelectDone: function(user) {
            userId = user.userId;
            loadAllInfo(userId);
            return true;
        }
    });
});

$('#user-more-more').click(function() {
    var user = datagrid.datagrid("getSelected");
    if(!user){
        return;
    }
    openTab("mainTab", CONFIG.baseUrl + "user/extends.do?userId=" + user.userId, "用户[{0}]的健康数据".format(user.aliasName));
});

$('#data-input').click(function() {
    if (!userId) {
        alertInfo('请先选择用户');
        return;
    }
    openTab({
        title: '健康数据录入',
        url: "view/health/archive/healthDataForm.do?userId=" + userId
    });
});

function loadAllInfo(userId) {
    loadUserBasicInfo();
    loadLatestHealthData();
    healthHistoryGroup.loadByUserId(userId);
    loadAlarmHistory();

    function loadUserBasicInfo() {
        $('.value').text('');
        axios.get('user/getBasicInfo.do?userId=' + userId)
            .then(function(user) {
                for (var p in user)
                    $('#basicInfo [name=' + p + ']').text(user[p] || '');
            });
    }

    function loadLatestHealthData() {
        $('#healthData p[data-key]').each(function() {
            var p = $(this);
            p.find('.jksj-num').empty();
            p.find('.jksj-text').empty();
            p.find('.jksj-date').empty();
        });
        $('#h_height').empty();
        $('#h_weight').empty();
        $.get(CONFIG.baseUrl + 'health/items.do?userId=' + userId, function(items) {
            var typeMap = {};
            items.forEach(function(item) {
                typeMap[item.dataType] = item;
                var p = $('#healthData p[data-key=' + item.dataType + ']');
                if (p) {
                    p.find('.jksj-num').text(item.dataValue);
                    p.find('.jksj-text').text(item.unit);
                    p.find('.jksj-date').text(item.createTime.substring(0, 19));
                }
            });
            if (typeMap[1])
                $('#h_height').text(+typeMap[1].dataValue + 'cm');
            if (typeMap[2])
                $('#h_weight').text(+typeMap[2].dataValue + 'kg');
        });
    }

    function loadAlarmHistory() {
        $('#alarmHistory').datagrid('clear');
        $('#alarmHistory').datagrid({
            url: CONFIG.baseUrl + 'health/arthive/aralmHistory.do?userId=' + userId
        });
    }
}


function HealthHistoryGroup(options) {
    var historyTypePanelMap = {};
    var tabPanels = $('#tabs').tabs('tabs');
    tabPanels.forEach(function (panel) {
        var historyType = panel.data('history_type');
        if (historyType) {//健康历史信息面板
            panel.append('<div class="health-history-item-card"></div>');
            historyTypePanelMap['health.arthive.' + historyType] = panel.find('div');
        }
    });
    axios.get('health/arthive/allHealthHistoryItems.do')
        .then(function (items) {
            items.forEach(function (item) {
                var panel = historyTypePanelMap[item.dictName];
                panel.append(new HealthHistoryItemTag({
                    item: {
                        type: item.dictName,
                        key: item.key,
                        text: item.value
                    },
                    onClick: function() {
                        if (!userId)
                            return;
                        var tag = this;
                        tag.toggleCheck();
                        axios.post('health/arthive/healthHistory/setItems.do', {
                            userId: userId,
                            type: tag.data('type'),
                            keyCsv: getCheckedKeys(panel).join(',')
                        }).then(function(ret) {
                            if (ret.success) {
                                showOpOkMessage('设置成功');
                            } else {
                                tag.toggleCheck();
                            }
                        }).catch(function() {
                            tag.toggleCheck();
                        });

                        function getCheckedKeys(panel) {
                            var keys = [];
                            panel.find('.checked').each(function() {
                                keys.push($(this).data('key'));
                            });
                            return keys;
                        }
                    }
                }));
            });
        })
        .then(options.onLoadSuccess);

    this.loadByUserId = function(userId) {
        for (var type in historyTypePanelMap) {
            historyTypePanelMap[type].find('.checked').removeClass('checked');
        }
        axios.get('health/arthive/healthHistory/getByUserId.do?userId=' + userId)
            .then(function (items) {
                items.forEach(function (item) {
                    if (!item.keyCsv)
                        return;
                    var panel = historyTypePanelMap[item.type];
                    item.keyCsv.split(',').forEach(function (key) {
                        panel.find('[data-key="' + key + '"]').addClass('checked');
                    });
                });
            });
    }

    function HealthHistoryItemTag(props) {
        var item = props.item;
        var elem = $('<div class="health-history-item" data-type="'
            + item.type + '" data-key="' + item.key + '">' + item.text + '</div>');
        elem.click(function() { props.onClick.call(elem) });
        elem.toggleCheck = function() {
            var tag = $(this);
            if (tag.is('.checked')) {
                tag.removeClass('checked');
            } else {
                tag.addClass('checked')
            }
        };
        return elem;
    }
}
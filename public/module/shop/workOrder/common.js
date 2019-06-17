var workOrder = (function() {
    var statusItems = [
       {value: '10,11', text: '服务未开始'},
       {value: '12,13,14', text: '服务进行中'},
       {value: '15', text: '服务已完成'},
       {value: '16', text: '服务已取消'}];

    var statusMap = {};
    statusItems.forEach(function(item) {
        item.value.split(',').forEach(function(k) {
            statusMap[k] = item.text;
        });
    });

    var colorMap = {
        '10': 'blue',
        '11': 'blue',
        '12': 'orange',
        '13': 'orange',
        '14': 'orange',
        '15': 'green',
        '16': 'red'
    };
    
    return {
        statusItems: statusItems,
        statusTextByValue: function(v) {
            return statusMap[v] || DictMan.itemMap('productOrder.status')[v];
        },
        statusCssByValue: function(v) {
            if (statusMap[v]) {
                return {color: colorMap[v]};
            } else {
                return {};
            }
        },
        statusHtmlByValue: function(v) {
            if (statusMap[v]) {
                return '<span style="color: ' + colorMap[v] + '">' + statusMap[v] + '</span>';
            } else {
                return DictMan.itemMap('productOrder.status')[v];
            }
        }
    };
})()
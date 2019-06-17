var now = moment();
var todayDateStr = now.format('YYYY-MM-DD');
var userManage = window.userManage || {};
userManage.formatters = {
    onLine: (function() {
        var iconTable = {
            0: ['icon-app-user', 'icon-app-user'],
            1: ['icon-app-user','icon-app-user'],
            2: ['icon-vipcard', 'icon-vipcard'],
            3: ['icon-telephone-offline', 'icon-telephone-online'],
            9: ['icon-offline', 'icon-online'],
        };
        return function(value, user) {
            return '<div title=' + (value ? '在线' : '离线')
                + ' class=' + iconTable[user.userType][+value] + '>&nbsp;</div>';
        }
    })(),
    deviceCode: function(value, user, rowIndex) {
        return [2,3,9].indexOf(user.userType) > -1 ? user.deviceCode : '-';
    },
    unknownIfEmpty: function(v) { return v ? v : '未知' },
    sex: function(v) {
        return v == 0 ? '男' : '女';
    },
    age: function(v, user) {
        return user.idcard ? v :'未知';
    },
    applyTypesText: function(s) {
        return s || '未申请';
    },
    evalScore: function(v) { return v || 0; },
    allowanceMoney: function(v) { return v || 0; },
    registerTime: function(s) {
        if (todayDateStr === s.substring(0, 10)) {
            return '今天' + s.substring(10);
        } else {
            return s;
        }
    },
    op: function(value,user,rowIndex) {
        var html = "";
        if(viewType == 1) {
            html = '<a href="#" title="关爱设置" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="showCareGrid(' + rowIndex + ')">'
                +'<div class=\'icon-care-setting\' style=\'float:left;width:20px;\'>&nbsp;</div></a>';
        }
        if(viewType == 2) {
            html = '<a href="#" title="安全定位" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="showSafePositions(' + rowIndex + ')">'
                +'<div class=\'icon-safe-location\' style=\'float:left;width:20px;\'>&nbsp;</div></a>';
        }

        return html;
    }
}
userManage.openEvalInfoModal = function(idcard) {
    openSimpleDialog({
        width: 500,
        height: 300,
        title: '评估详情',
        href: 'view/user/evalOldman/evalInfo.do?idcard=' + idcard
    });
}
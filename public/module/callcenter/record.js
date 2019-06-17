var callcenterCallRecordManage = (function(){

    var dicts = {
        contactType: {'Inbound': '呼入', 'Outbound': '呼出'},
        contactDisposition: new Dict([
            {value: 'Success', text: '正常'},
            {value: 'NoAnswer', text: '无应答'},
            {value: 'Rejected', text: '拒绝'},
            {value: 'Busy', text: '忙'},
            {value: 'AbandonedInContactFlow', text: 'IVR呼损'},
            {value: 'AbandonedInQueue', text: '队列呼损'},
            {value: 'AbandonedRing', text: '久振不接'},
            {value: 'QueueOverflow', text: '等待超时被挂断'}
        ])
    };

    $('#contactType').comboboxFromDict({
        dict: dicts.contactType,
        emptyItem: new DictItem('all', '全部'),
        defaultValue: 'all'
    });
    $('#contactDisposition').comboboxFromDict({
        dict: dicts.contactDisposition,
        emptyItem: new DictItem('all', '全部'),
        defaultValue: 'all'
    });

    var inited = false;
    $('#tbrCallRecord #query').click(function(){
        var startTime = 0;
        var stopTime = 0;
        
        var days = $('#tbrCallRecord #frmQuery #days').combobox('getValue');
        if (days.length) {
            days = +days;
            switch (days) {
            case 0:
                startTime = stopTime = 0;
                break;
            case 1:
                var today = new Date(moment().format('YYYY-MM-DD 00:00:00')).getTime();
                startTime = today - 1000*60*60*24 * days;
                stopTime = today;
                break;
            default:
                startTime = new Date(moment().subtract(days - 1, 'days').format('YYYY-MM-DD 00:00:00')).getTime();
                stopTime = 0;
                break;
            }
            $('#tbrCallRecord #frmQuery #startDate').datebox('clear');
            $('#tbrCallRecord #frmQuery #endDate').datebox('clear');
        } else {
            var startDate = $('#tbrCallRecord #frmQuery #startDate').datebox('getValue');
            var endDate = $('#tbrCallRecord #frmQuery #endDate').datebox('getValue');
            if (startDate) {
                startTime = +new Date(startDate + ' 00:00:00');
            }
            if (endDate) {
                stopTime = +new Date(endDate + ' 00:00:00');
            }
        }
        $('[name=startTime').val(startTime);
        $('[name=stopTime').val(stopTime);
        
        var params = $('#tbrCallRecord #frmQuery').serializeObject();
        if (!inited) {
            $('#dgRecord').datagrid({
                url: CONFIG.baseUrl + 'callcenter/record/page.do',
                queryParams: params,
                pageSize: 30,
                fit:true,
                loadFilter: function(data) {
                    if (!data.callDetailRecords)
                        return [];
                    data.callDetailRecords.list.forEach(function(row) {
                        $.extend(row, row.user);
                    });
                    return {total: data.callDetailRecords.totalCount, rows: data.callDetailRecords.list};
                }
            });
            inited = true;
        } else {
            $('#dgRecord').datagrid('load', params); 
        }
    });

    $('#order').click(function() {
        var row = $('#dgRecord').datagrid('getSelected');
        if (!row) return;
        if (row.userId)
            openFastOrder(row); 
    });
    $('#openLocation').click(function() {
        var row = $('#dgRecord').datagrid('getSelected');
        if (!row) return;
        top.stat.deviceQuery.gotoPositionByTelephone(row.telphone); 
    });
    
    $(function() {
        setTimeout(function() {
            $('#tbrCallRecord #query').click();
        }, 100);
    });

    /* @return mobile, uniom, telcom , other */
    var carrierPhone = function() {
        var mobileReg = new RegExp("^134[0-8]\\d{7}$|^(?:13[5-9]|147|15[0-27-9]|178|1703|1705|1706|18[2-478])\\d{7,8}$"); //移动
        var unicomReg = new RegExp("^(?:13[0-2]|145|15[56]|176|1704|1707|1708|1709|171|18[56])\\d{7,8}$"); //联通
        var telcomReg = new RegExp("^(?:133|153|1700|1701|1702|177|173|18[019])\\d{7,8}$");//电信
        return function(number) {
            if (mobileReg.test(number))
                return 'mobile';
            if (unicomReg.test(number))
                return 'unicom';
            if (telcomReg.test(number))
                return 'telcom';
            return 'other';
        }
    }();

    return {
        formatters: {
            startTime: function(t) {
                return moment(t).format('YYYY-MM-DD HH:mm:ss')
            },
            customerNumber: function(s) {
                if (!s) return s;
                var html = '';
                var carrier = carrierPhone(s);
                html += s.substring(0, 3) + ' ' + s.substring(3, 7) + ' ' + s.substring(7, 11);
                for (var i = 11 - s.length; i > 0; i--)
                    html += '&nbsp;&nbsp;';
                html += '&nbsp;(' + {'mobile': '移动', unicom: '联通', 'telcom': '电信', 'other': '其它'}[carrier] + ')';
                return html;
            },
            contactType: function(t) {
                return dicts.contactType[t];
            },
            contactDisposition: UICommon.datagrid.formatter.generators.dict(dicts.contactDisposition),
            duration: function(v) {
                return TimeUtils.formatToDurationText(v * 1000);
            },
            userAliasName: function(v, row) {
                return v ? UICommon.linkHtml({
                    text: v,
                    clickCode: 'callcenterCallRecordManage.openUserInfo("' + row.userId + '")'
                }) : '';
            },
            op: function(_, row, index) {
                if(row.recordings.length) {
                    var html = '';
                    html += UICommon.buttonHtml({
                        text: '播放录音',
                        icon: 'record-play',
                        clickCode: 'callcenterCallRecordManage.play(' + index + ')'});
                    html += UICommon.buttonHtml({
                        text: '下载录音',
                        icon: 'download',
                        clickCode: 'callcenterCallRecordManage.download(' + index + ')'});
                    return html;
                } else {
                    return '';
                }
            }
        },
        play: function(rowIndex) {
            var row = $('#dgRecord').datagrid('getRows')[rowIndex];
            var url = CONFIG.baseUrl + 'callcenter/record/raw.do?fileName=' + row.recordings[0].fileName;
            DialogManager.openSimpleDialog({
                width: 400,
                height: 100,
                href: 'view/callcenter/recordPlayer.do?src=' + url,
                buttons: []
            });
        },
        download: function(rowIndex) {
            var row = $('#dgRecord').datagrid('getRows')[rowIndex];
            location.href = CONFIG.baseUrl + 'callcenter/record/download.do?fileName='
                + row.recordings[0].fileName + '&returnFileName=' + row.recordings[0].fileDescription + '.wav';
        },
        openUserInfo: function(userId) {
            openUserBasicInfo(userId);
        }
    };
})();
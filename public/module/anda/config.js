function initHostUserConfig(userId, bindUserType) {
    $.get(CONFIG.baseUrl + 'anda/hostUser/getByUserId.do?bindUserType='
        + bindUserType + '&userId=' + userId, function(d) {
        if (d.hostId) {
            $('#frmHostUserConfig').form('load', d);
            $('#bind').hide();
            $('#frmHostUserConfig [textboxname=hostId]').textbox('disable');
        }
    });
    $('#bind').click(function() {
        formSubmit('#frmHostUserConfig', {
            url: 'anda/hostUser/add.do',
            success: function(ret) {
                if (ret.code == 2)
                    ret.message = '不存在的主机ID';
                if (ret.code == 3)
                    ret.message = '该主机ID已绑定其它用户';
                if (ret.success) {
                    $('#bind').hide();
                    $('#frmHostUserConfig [textboxname=hostId]').textbox('disable');
                    $('#dgAlarmNoticePhone').datagrid('reload');
                }
                showOpResultMessage(ret);
            }
        });
    });
    $('#unbind').click(function() {
        var hostId = $('#frmHostUserConfig [textboxname=hostId]').textbox('getValue');
        if (!hostId) {
            return;
        }
        $.post('/anda/hostUser/delete.do?hostId=' + hostId, function(ret) {
            if (ret.success) {
                $('#frmHostUserConfig [textboxname=hostId]').textbox('clear');
                $('#bind').show();
                $('#frmHostUserConfig [textboxname=hostId]').textbox('enable');
                $('#dgAlarmNoticePhone').datagrid('clear');
            }
            showOpResultMessage(ret);
        });
    });
}

/* 报警通知 */
function AlarmNoticePhoneManage(userId, bindUserType) {
    $('#alarmNoticePhoneAdd').click(function() {
        $.get(CONFIG.baseUrl + 'anda/hostUser/getByUserId.do?bindUserType='
            + bindUserType + '&userId=' + userId, function(d) {
            var hostId = d.hostId;
            if (!hostId) {
                alertInfo('请先设置智能电话机主机ID');
                return;
            }
            openEditDialog({
                width: 340,
                height: 180,
                title: '增加手机号码',
                href: 'view/anda/noticePhone/noticePhoneConfigForm.do?hostId=' + hostId,
                onLoad: function() {
                    $('#alarmNoticePhoneTest').click(function() {
                        var phone = $('[textboxname=phone]').textbox('getValue');
                        if (!phone) {
                            alertInfo('请先输入正确的手机号');
                            return;
                        }
                        $.post('/sendSms/send.do',
                            {
                                mobileInputType: 'cvs',
                                mobileCsv: phone,
                                content: '温馨提示：这是一条测试短信，用于测试您的手机号是否能正确接收短信，现在您的手机号能够接收短信。' +
                                    '（如果该操作不是您本人的操作，可能是其他呼贝服务人员的操作。）'
                            },
                            function() {
                                showOpOkMessage('操作成功，请等待短信到达');
                            });
                    });
                },
                onSave: function(dlg) {
                    formSubmit('#alarmNoticePhoneConfigForm', {
                        url: 'anda/alarmNoticePhone/add.do',
                        success: function(ret) {
                            if (ret.success) {
                                $('#dgAlarmNoticePhone').datagrid('reload');
                                dlg.dialog('destroy');
                            }
                            showOpResultMessage(ret);
                        }
                    });
                }
            });
        });

    });
}

AlarmNoticePhoneManage.formatters = {
    op: function(_, __, index) {
        return UICommon.buttonHtml({
            icon: 'delete',
            clickCode: 'AlarmNoticePhoneManage.deleteByIndex(' + index + ')'
        })
    }
};
AlarmNoticePhoneManage.deleteByIndex = function(index) {
    var row = $('#dgAlarmNoticePhone').datagrid('getRows')[index];
    $.post(CONFIG.baseUrl + 'anda/alarmNoticePhone/delete.do', {hostId: row.hostId, phone: row.phone}, function(ret) {
        showOpResultMessage(ret);
        if (ret.success) {
            $('#dgAlarmNoticePhone').datagrid('reload');
        }
    });
};
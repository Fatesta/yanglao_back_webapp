var formatters = {
    bounded: function(v, row) {
        if (v) {
            return '<span style="color:green">已绑定' + ({1: '<span class="icon-berth"></span>用户', 2: '床位'}[row.bindUserType]) + '</span>';
        } else
            return '未绑定';
    },
    op: function(_, row) {
        var html = '';
        html += UICommon.buttonHtml({
            text: '修改',
            icon: 'edit',
            clickCode: 'updateHost(\'' + row.hostId + '\')'
        });
        if (!row.bounded) {
            html += UICommon.buttonHtml({
                text: '删除',
                icon: 'delete',
                clickCode: 'removeHost(\'' + row.hostId + '\')'
            });
        }
        if (row.bounded) {
            html += UICommon.buttonHtml({
                text: '解绑',
                icon: 'set',
                clickCode: 'unbindHost(\'' + row.hostId + '\')'
            });
        }
        html += UICommon.buttonHtml({
            text: '报警记录',
            icon: 'order-trace',
            clickCode: 'openHostAlarmRecord(\'' + row.hostId + '\')'
        });
        html += UICommon.buttonHtml({
            text: '状态',
            icon: 'order-trace ',
            clickCode: 'openHostStatePage(\'' + row.hostId + '\')'
        });
        return html;
    }
}

$('#query').click(function () {
    var params = $('#frmQuery').serializeObject();
    $('#dg').datagrid('load', params);
});

$('#add').click(function () {
    openEditDialog({
        width: 300,
        height: 180,
        title: '增加主机信息',
        href: 'view/anda/host/hostForm.do',
        onSave: function(dlg) {
            formSubmit('#frmHost', {
                url: 'anda/host/add.do',
                success: function(ret) {
                    if (ret.success) {
                        $('#dg').datagrid('reload');
                        dlg.dialog('destroy');
                    }
                    showOpResultMessage(ret);
                }
            });
        }
    });
});

function openHostStatePage(hostId) {
    openTab({
        url: 'view/anda/host/hostState.do?hostId=' + hostId,
        title: hostId + ' - 智能电话实时状态'
    });
}

function openHostAlarmRecord(hostId) {
    openTab({
        url: 'view/anda/host/alarmRecord.do?hostId=' + hostId,
        title: '智能电话报警记录'
    });
}
function unbindHost(hostId) {
    openConfirmDialog("确认解绑？", function() {
        $.post('/anda/hostUser/delete.do?hostId=' + hostId, function(ret) {
            if (ret.success) {
                $('#dg').datagrid('reload');
            }
            showOpResultMessage(ret);
        });
    });
}

function updateHost(hostId) {
    openEditDialog({
        width: 300,
        height: 180,
        title: '修改主机信息',
        href: 'view/anda/host/hostForm.do',
        onLoad: function() {
            $('#frmHost [textboxname=hostId]').textbox({readonly: true});
            $.get('/anda/host/getById.do?hostId=' + hostId, function(host) {
                $('#frmHost').form('load', host);
            });
        },
        onSave: function(dlg) {
            formSubmit('#frmHost', {
                url: 'anda/host/update.do',
                success: function(ret) {
                    if (ret.success) {
                        $('#dg').datagrid('reload');
                        dlg.dialog('destroy');
                    }
                    showOpResultMessage(ret);
                }
            });
        }
    });
}

function removeHost(hostId) {
    openConfirmDeleteDialog(function() {
        $.post('/anda/host/delete.do?hostId=' + hostId, function (ret) {
            if (ret.success) {
                $('#dg').datagrid('reload');
            }
            showOpResultMessage(ret);
        });
    });
}
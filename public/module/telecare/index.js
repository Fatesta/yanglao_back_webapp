initUserQuerier('#userQuerier', '#frmQuery', '#dgUser');

$('#user-query').click(function() {
    $("#dgUser").datagrid('load', $('#frmQuery').serializeObject());
});

$('#enter').click(function() {
    var user = $("#dgUser").datagrid('getSelected');
    if (!user) return;
    parent.openTab({
        url: 'view/telecare/report/index.do?userId=' + user.userId + '&deviceCode=' + user.deviceCode,
        title: '远程看护 - 用户[' + user.aliasName + ']'
    });
});

$('#userConfig').click(function() {
    var user = $("#dgUser").datagrid('getSelected');
    if (!user) return;
    openTab({
        url: 'view/telecare/userConfig/index.do?userId='
            + user.userId + '&deviceCode=' + user.deviceCode + '&_func_code=userConfig',
        title: '用户[' + user.aliasName + '] 远程看护配置'
    });
});
var formatters = {
    status: function(v) {
        return {0: '待完成', 1: '已完成', 2: '过期未完成'}[v];
    }
};
var lastSelectedUser = null;

function onSelect(_, row) {
    var queryParams = {userId: row.userId};
    if (!$('#dgPlan').datagrid('options').url) {
        $('#dgPlan').datagrid({
            url: CONFIG.baseUrl + 'servicePlan/findAllPlansByUserId.do',
            queryParams: queryParams,
            pageSize: 30
        });
    } else {
        $('#dgPlan').datagrid('load', queryParams);
    }
}

function onLoadSuccess() {
    if (lastSelectedUser) {
        $('#dg').datagrid('selectRecord', lastSelectedUser.userId);
    } else {
        $('#dg').datagrid('unselectAll');
        $('#dgPlan').datagrid('clear');
    }
    lastSelectedUser = null;
}

$(function(){
    $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject());
    });

    $('#selectUser').click(function() {
        if ($('[name=userId]').val()) {
            $('[name=userId]').val('');
            $('#userAliasName').textbox('clear');
            return;
        }
        openUserSelectDialog({
            onSelectDone: function(user){
                $('[name=userId]').val(user.userId);
                $('#userAliasName').textbox('setValue', user.aliasName);
                return true;
            }
        });
    });

});
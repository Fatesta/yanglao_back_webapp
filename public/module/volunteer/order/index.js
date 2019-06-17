var dicts = {
    status: new Dict({
        "1":"已接单",
        "2":"完成任务",
        "3":"任务已取消",
        "4":"交易完成",
        "5":"交易未完成"})
}
var formatters = {
    status: UICommon.datagrid.formatter.generators.dict(dicts.status)
};

$(function(){
    $('#status').comboboxFromDict({
        dict: dicts.status
    });
    $('#query').click(function(){
        $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
    });
    $('#add').click(function(){
        edit(false);
    });
    $('#update').click(function(){
        edit(true);
    });
    $('#delete').click(function(){
        var row = $('#dg').datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'volunteerHelpOrder/delete.do?orderno=' + row.orderno, function(ret){
                showOpResultMessage(ret);
                $('#dg').datagrid('load');
            });
        });
    });
    
    function edit(update) {
        var url = 'volunteerHelpOrder/form.do';
        if (update) {
            var row = $('#dg').datagrid('getSelected')
            if (!row) return;
            url += '?orderno=' + row.orderno;
        }
         
        var dlg = openEditDialog({
            width: 500,
            height: 440,
            href: url,
            onSave: function() {
                formSubmit({
                    url: 'volunteerHelpOrder/save.do',
                    success: function(ret) {
                        if (ret.success) {
                            dlg.dialog('destroy');
                            $('#dg').datagrid('load');
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }
});
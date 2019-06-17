$(function(){
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
            $.post(CONFIG.baseUrl + 'activityParticipant/delete.do?activityId=' + row.activityId, function(ret){
                showOpResultMessage(ret);
                $('#dg').datagrid('load');
            });
        });
    });
    
    function edit(isUpdate) {
        var url = 'activityParticipant/form.do';
        if (isUpdate) {
            var row = $('#dg').datagrid('getSelected')
            if (!row) return;
            url += '?activityId=' + row.activityId;
        }
         
        var dlg = openEditDialog({
            width: 500,
            height: 440,
            href: url,
            onSave: function() {
                formSubmit({
                    url: 'activityParticipant/save.do',
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
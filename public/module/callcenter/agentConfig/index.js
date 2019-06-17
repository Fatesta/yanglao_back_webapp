$(function(){
    $('#query').click(function(){
        $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
    });
    $('#add').click(function(){
        var dlg = openEditDialog({
            width: 300,
            height: 140,
            href: 'view/callcenter/agentConfig/form.do',
            onLoad: function() {
                $('#selectAdmin').click(function() {
                    openEditDialog({
                         title: "请选择用户",
                         width: 800,
                         height: 500,
                         href: "admin/adminGrid.do",
                         onSave: function(dlg){
                             var admin = $("#adminGrid").datagrid('getSelected');
                             if (!admin) return;
                             dlg.dialog('destroy');
                             
                             $('[name=adminId]').val(admin.id);
                             $('#adminUsername').textbox('setValue', admin.username);
                         }
                     });
                });
            },
            onSave: function() {
                formSubmit({
                    url: 'callcenter/agentConfig/add.do',
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
    });

    $('#delete').click(function(){
        var row = $('#dg').datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'callcenter/agentConfig/delete.do?' + $.param(row), function(ret){
                showOpResultMessage(ret);
                $('#dg').datagrid('load');
            });
        });
    });
});
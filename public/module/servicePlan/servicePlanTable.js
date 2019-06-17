$('#tbrPlan #add').click(function(){
    var row = $('#dg').datagrid('getSelected');
    var dlg = openEditDialog({
        title: '增加服务计划',
        width: 500,
        height: 240,
        href: 'view/servicePlan/form.do',
        onLoad: function() {
            if (row) {
                $.get(CONFIG.baseUrl + 'user/getBasicInfo.do?userId=' + row.userId, function(user) {
                    $('[name=userId]', dlg).val(user.userId);
                    $('#userAliasName', dlg).textbox('setValue', user.aliasName);
                    lastSelectedUser = user;
                });
            }
            $('#selectUser', dlg).click(function() {
                openUserSelectDialog({
                    onSelectDone: function(user){
                        $('[name=userId]', dlg).val(user.userId);
                        $('#userAliasName', dlg).textbox('setValue', user.aliasName);
                        lastSelectedUser = user;
                        return true;
                    }
                });
            });
            $('#selectProduct', dlg).click(function() {
                openProviderToProductSelectDialog({
                    onSubmit: function(product) {
                        $('#productName', dlg).textbox('setValue', product.name);
                        $('[name=productId]', dlg).val(product.productId);
                    }
                });
            });
        },
        onSave: function() {
            formSubmit({
                url: 'servicePlan/save.do',
                success: function(ret) {
                    if (ret.success) {
                        dlg.dialog('destroy');
                        $('#dg').datagrid('reload');
                    }
                    showOpResultMessage(ret);
                }
            });
        }
    });
});

$('#tbrPlan #delete').click(function(){
    var row = $('#dgPlan').datagrid('getSelected');
    if(!row) return;
    openConfirmDeleteDialog(function(){
        $.post(CONFIG.baseUrl + 'servicePlan/delete.do?id=' + row.id, function(ret){
            showOpResultMessage(ret);
            $('#dgPlan').datagrid('reload');
        });
    });
});

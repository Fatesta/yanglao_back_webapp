var berthType = (function() {
    var datagrid = $('#dgCommunityBerthType');

    $('#tbrCommunityBerthType [name=query]').click(function(){
        datagrid.datagrid("load", $('#tbrCommunityBerthType [name=frmQuery]').serializeObject());
    });

    $('#tbrCommunityBerthType [name=update]').click(function(){
        edit(true);
    });
    
    $('#tbrCommunityBerthType [name=add]').click(function(){
        edit(false);
    });
    
    $('#tbrCommunityBerthType [name=delete]').click(function(){
        var row = datagrid.datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'community/berth/berthType/delete.do?id=' + row.id, function(ret){
                if (code == 0) {
                    datagrid.datagrid('load');
                    showOpOkMessage();
                } else if (code == 1) {
                    showOpFailMessage();
                } else if (code == 2) {
                    showOpResultMessage({success:false, message: '已有床位关联了该床位类型，不能删除'});
                }                
            });
        });
    });

    function edit(isUpdate) {
        var href = 'community/berth/berthType/form.do';
        if (isUpdate) {
            var row = datagrid.datagrid('getSelected');
            if(row) {
                href += '?id=' + row.id;
            }
        }
        var dlg = openEditDialog({
            width: 500,
            height: 220,
            href: href,
            title: '编辑床位类型',
            onSave: function() {
                formSubmit('#frmCommunityBerthType', {
                    url: 'community/berth/berthType/save.do',
                    success: function(code) {
                        if (code == 0) {
                            dlg.dialog('destroy');
                            datagrid.datagrid('load');
                        }
                        showOpResultMessage(code);
                    }
                });
            }
        });
    }
    
    return {
        formatters: {
            remark: UICommon.datagrid.formatter.generators.omit({dgId: 'dgCommunityBerthType', field: 'remark', min: 50})
        }
    }
})()
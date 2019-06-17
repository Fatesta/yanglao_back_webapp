var planManage = (function(){
    $('#query').click(function(){
        $('#dgPlan').datagrid('load', $('#frmQuery').serializeObject());
    });
    $('#add').click(function(){
        edit(false);
    });
    $('#update').click(function(){
        var row = $('#dgPlan').datagrid('getSelected');
        if (row.state == 0) {
            edit(true);
        } else {
            alertInfo('此状态不能修改');
        }
    });
    $('#publish').click(function(){
        var row = $('#dgPlan').datagrid('getSelected');
        if (!row || row.state == 1) return;
        openConfirmDialog('确认发布?', function(){
            $.post(CONFIG.baseUrl + 'health/house/plan/plan/publish.do', {id: row.id}, function(ret){
                showOpResultMessage(ret);
                $('#dgPlan').datagrid('reload');
            });
        });
    });
    $('#close').click(function(){
        var row = $('#dgPlan').datagrid('getSelected');
        if (!row || row.state == 2) return;
        openConfirmDialog('确认关闭?', function(){
            $.post(CONFIG.baseUrl + 'health/house/plan/plan/close.do', {id: row.id}, function(ret){
                showOpResultMessage(ret);
                $('#dgPlan').datagrid('reload');
            });
        });
    });

    function edit(update) {
        var url = 'health/house/plan/plan/form.do';
        if (update) {
            var row = $('#dgPlan').datagrid('getSelected')
            if (!row)
                return;
            url += '?id=' + row.id;
        }

        var dlg = openEditDialog({
            title: '编辑计划基本信息',
            width: 400,
            height: 400,
            href: url,
            onLoad: function() {
                $('#imgUploadButton').click(function(){
                    openUploadImageDialog({
                        onSuccess: function(data) {
                            $('#img').attr('src', data.url);
                            $('[name=coverUrl]').val(data.url);
                        }
                    });
                });
            },
            onSave: function() {
                formSubmit({
                    url: 'health/house/plan/plan/save.do',
                    success: function(ret) {
                        if (ret.success) {
                            dlg.dialog('destroy');
                            $('#dgPlan').datagrid('reload');
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }

    var signals = {
        selected: new Signal(),
        loaded: new Signal()
    };
    return {
        signals: signals,
        formatters: {
            state: function(val) {
                return {
                    0: '<span style="color:red">编辑中<span>',
                    1: '<span style="color:green">已发布<span>',
                    2: '<span style="color:gray">已关闭<span>'
                }[val];
            }
        },
        onLoadSuccess: function() {
            signals.loaded.dispatch();
        },
        onSelect: function(_, row) {
            signals.selected.dispatch(row);
        }
    };
})();


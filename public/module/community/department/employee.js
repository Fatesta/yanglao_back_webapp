var employee = (function(){
    var self = {};
    var datagrid = $('#dgCommunityDepartmentEmployee');
    var departmentId = 0;

    self.query = function() {
        var form = $('#tbrCommunityDepartmentEmployee [name=frmQuery]');
        form.find('[name=departmentId]').val(departmentId);
        var params = form.serializeObject();
        params.departmentId = departmentId;
        if (datagrid.datagrid('options').url == null) {
            datagrid.datagrid({
                url: CONFIG.baseUrl + 'community/department/employee/page.do',
                queryParams: params
            });
        } else {
            datagrid.datagrid('load', params);
        }
    }
    
    self.queryByDepartmentId = function(id) {
        departmentId = id;
        self.query();
    }

    $('#tbrCommunityDepartmentEmployee [name=query]').click(function(){
        self.query();
    });

    $('#tbrCommunityDepartmentEmployee [name=add]').click(function(){
        if (!departmentId) {
            alertInfo('请先选择一个部门');
            return;
        }
        edit(false);
    });

    $('#tbrCommunityDepartmentEmployee [name=update]').click(function(){
        edit(true);
    });
    
    $('#tbrCommunityDepartmentEmployee [name=delete]').click(function(){
        var row = datagrid.datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'community/department/employee/delete.do?id=' + row.id, function(ret){
                showOpResultMessage(ret);
                datagrid.datagrid('load');
            });
        });
    });
    
    function edit(isUpdate) {
        var url = 'community/department/employee/form.do';
        if (isUpdate) {
            var row = datagrid.datagrid('getSelected')
            if (!row) return;
            url += '?id=' + row.id;
        }
         
        var dlg = openEditDialog({
            width: 300,
            height: 300,
            href: url,
            onLoad: function() {
                if (!isUpdate) {
                    $('#frmCommunityDepartmentEmployee [name=departmentId]').val(departmentId);
                }
                $("#uploadButton", dlg).click(function(){
                    openUploadImageDialog({
                        onSuccess: function(data) {
                            $("#headImg", dlg).attr("src", data.url);
                            $("[name=imagePath]", dlg).val(data.url);
                        }
                    });
                });
            },
            onSave: function() {
                formSubmit('#frmCommunityDepartmentEmployee', {
                    url: 'community/department/employee/save.do',
                    success: function(success) {
                        if (success) {
                            dlg.dialog('destroy');
                            datagrid.datagrid('load');
                        }
                        showOpResultMessage(success);
                    }
                });
            }
        });
    }
    
    return self;
})();

employee.formatters = {
    imagePath: function(value) {
        return value ? '<img src="' + value  + '" width="60px" height="50px"/>' : '<div class="empty-value-box" style="width:60px;height:50px;"></div>';
    },
    sex: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.gender'))
}
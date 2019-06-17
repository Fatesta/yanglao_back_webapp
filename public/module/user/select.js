if (!window.openDataSelectDialog) {
    alert('无法调用user/select.js');
}
function openUserSelectDialog(options) {
    //是否必须选择一个用户，默认是
    var required = typeof options.required == 'undefined' ? true : options.required;
    //参数
    var urlParams = '';
    if (options.userTypes) {
        urlParams += 'userType=' + options.userTypes.join(',');
    }
    if (urlParams) {
        urlParams = '?' + urlParams;
    }

    var dlg = openDataSelectDialog({
        width: 610,
        height: 410,
        title: "选择用户",
        href: "user/dgUser.do" + urlParams,
        modal: true,
        okButtonText: options.okButtonText,
        onLoad: function() {
            //默认选择用户类型
            if (options.userTypes && options.userTypes.length == 1)
                $('#userType', dlg).combobox('setValue', options.userTypes[0]).combobox('readonly');
        },
        onSave: function() {
            var user = $("#dgUser", dlg).datagrid('getSelected');
            if (required) {
                if (!(user && user.userId)) {
                    showAlert('提示','请选择一个用户');
                    return;
                }
            }
            var success = options.onSelectDone(user);
            if (success) {
                dlg.dialog('destroy');
            }
        }
    });
    return dlg;
}
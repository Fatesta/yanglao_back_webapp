function initUserQuerier(btn, basicQueryForm, datagrid, onSave, options) {
    options = options || {};
    datagrid = $(datagrid);
    $(btn).click(function(){
        openQueryDialog({
            width: options.width || 480,
            height: 420,
            title: '用户高级查询',
            href: 'view/user/userQuerier.do?disableApplyTypes=' + options.disableApplyTypes,
            modal: false,
            inline: true,
            onLoad: function() {
                $('#userQuerierForm #specialFilter').change(function() {
                    $('#userQuerierForm [name=role]').val(this.checked ? '-1' : '');
                });
                var allUserTypeValue = options.allUserTypeValue || -1;
                $('#userQuerierForm [comboname=userType]').comboboxFromDict({
                    dict: top.DictMan.items('user.type'),
                    emptyItem: new top.DictItem(allUserTypeValue, '全部'),
                    defaultValue: allUserTypeValue,
                    onSelect: function(item) {
                        $('[name=deviceCondTr],[name=cardUserCondTr]').hide();
                        $('#userQuerierForm [textboxname=deviceCode]').textbox('setValue', '');
                        $('#userQuerierForm [textboxname=cardCode]').textbox('setValue', '');
                        switch(+item.value) {
                        case 0:
                        case 1:
                            break;
                        case 2:
                            $('#userQuerierForm [name=cardUserCondTr]').show();
                            break;
                        case 9:
                            $('#userQuerierForm [name=deviceCondTr]').show();
                            break;
                        }
                    }
                });
                var qparams = $(basicQueryForm).serializeObject();
                if (qparams.cardCode) {
                    $('#userQuerierForm [comboname=userType]').combobox('setValue', 2);
                    $('[comboname=userType]').combobox('setValue', 2);
                    qparams.userType = 2;
                }
                if (qparams.deviceCode) {
                    $('#userQuerierForm [comboname=userType]').combobox('setValue', 9);
                    $('[comboname=userType]', basicQueryForm).combobox('setValue', 9);
                    qparams.userType = 9;
                }
                $('#userQuerierForm [comboname=userType]').combobox('options').onSelect({value: qparams.userType});
                qparams = $.extend(qparams, options.queryParams);
                $('#userQuerierForm').form('load', qparams);
            },
            onSave: function() {
                var qparams = $('#userQuerierForm').serializeObject();

                if (!options.disableApplyTypes) {
                    qparams.applyTypes = $('#userQuerierForm [comboname=applyTypes]').combobox('getValues').filter(Boolean).join(',');
                }
                $(basicQueryForm).form('load', qparams);
                
                if (qparams.deviceCode) {
                    $('[comboname=userType]').combobox('setValue', 9);
                    qparams.userType = 9;
                }
                var showCols = [];
                if (qparams.userType == 9) {
                    showCols = ['deviceCode'];
                } else if (qparams.userType == 2) {
                    showCols = ['cardCode'];
                } else {
                    showCols = [];
                }
                var cols = datagrid.datagrid('getColumnFields');
                var opCols = _.intersection(cols, ['cardCode', 'deviceCode']);
                _.intersection(showCols, opCols).forEach(function(c) {
                    datagrid.datagrid('showColumn', c);
                });
                _.difference(opCols, showCols).forEach(function(c) {
                    datagrid.datagrid('hideColumn', c);
                });
                datagrid.datagrid("load", qparams);
                onSave && onSave(qparams);
            }
        });
    });

}
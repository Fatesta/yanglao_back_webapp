/**
选择一个店铺
@param options
  displayIndustries 只显示指定行业选项
  defaultSelectIndustry 
  onDone function(provider)
*/
function openProviderSelectDialog(options) {
    //是否必须选择一个，默认是
    var required = typeof options.required == 'undefined' ? true : options.required;
    var lastSelectedIndustry = null;
    var dlg = openEditDialog({
        title: '选择店铺',
        width: 1254,
        height: 600,
        href: 'view/shop/pro/selectProvider.do?disableAllOption=' + !(typeof options.displayIndustries == 'undefined'),
        modal: true,
        onLoad: function() {
            var loaded = false;
            dlg.find('#industryId').combobox({
                url: null,
                onLoadSuccess: function(industries) {
                    if (loaded) return;
                    loaded = true;
                    
                    if (options.displayIndustries) {
                        industries = industries.filter(function(i) {
                            return options.displayIndustries.includes(i.value);
                        });
                        $(this).combobox('loadData', industries);
                    }
                    if (options.defaultSelectIndustry) {
                        lastSelectedIndustry = options.defaultSelectIndustry;
                    }
                    if (lastSelectedIndustry) {
                        $(this).combobox('setValue', lastSelectedIndustry);
                    }
                    
                    pro.query();
                },
                onChange: function() {
                    pro.query();
                }
            });
        },
        onSave: function() {
            var provider = dlg.find('#dgPro').datagrid('getSelected');
            if (required) {
                if (!provider) {
                    alertInfo('请选择一个店铺');
                    return;
                }
            }
            
            var success = options.onDone(provider);
            if (success) {
                dlg.dialog('destroy');
            }
        }
    });
    
    return dlg;
}
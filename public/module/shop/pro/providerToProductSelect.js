/**
选择一个商品
先显示店铺数据，选择店铺后显示该店铺商品，选择商品后返回
@param options
  displayIndustries 只显示指定行业选项
  defaultSelectIndustry 
  onSubmit function(product, provider)
*/
function openProviderToProductSelectDialog(options) {
    var lastSelectedIndustry = null;
    var add = function(){
        var selectProviderDialog = openEditDialog({
            title: '选择店铺',
            width: 1300,
            height: 600,
            href: 'view/shop/pro/selectProvider.do',
            modal: true,
            onLoad: function() {
                var loaded = false;
                selectProviderDialog.find('#industryId').combobox({
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
            buttons:[{
                text:"下一步",
                handler: function() {
                    var provider = selectProviderDialog.find('#dgPro').datagrid('getSelected');
                    if (!provider) {
                        alertInfo('请选择一个店铺');
                        return;
                    }
                    
                    lastSelectedIndustry = selectProviderDialog.find('#industryId').combobox('getValue');

                    selectProviderDialog.dialog('destroy');
                    
                    var datagridId = 'dgProduct';
                    var href;
                    if (provider.industryId == 'activity') {
                        href = 'view/activity/productSelect.do';
                        datagridId = 'dgActivity';
                    } else {
                        href = 'view/shop/product/productSelect.do';
                    }
                    href += '?industryId=' + provider.industryId + '&providerId=' + provider.id;
                    var selectProductDialog = openEditDialog({
                        title: '选择 ' + DictMan.itemMap('product.industry')[provider.industryId] + ' 商品',
                        width: 1000,
                        height: 600,
                        href: href,
                        modal: true,
                        buttons:[
                            {
                                text:"确定",
                                handler:function() {
                                    var product = selectProductDialog.find('#' + datagridId).datagrid('getSelected');
                                    
                                    options.onSubmit(product, provider);
                                    
                                    selectProductDialog.dialog('destroy');
                                }
                            },{
                                text: "返回",
                                handler:function(){
                                    selectProductDialog.dialog('destroy');
                                    add();
                                }
                            },{
                                text:"取消",
                                handler:function(){
                                    selectProductDialog.dialog("destroy");    
                                }
                            }]
                    });
                }
            },{
                text:"取消",
                handler:function(){
                    selectProviderDialog.dialog("destroy");    
                }
            }],
        });
    }
    
    add();
}
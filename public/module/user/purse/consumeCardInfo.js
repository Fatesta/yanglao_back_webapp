var formatters = $.extend(formatters, {
    serverFlag: function(v) {
        return {0: "实体服务", 1: "课程服务", 2: "产品服务"}[v];
    },
    industryId: function(v) {
        return {mall: "电子商城", catering: "外卖", housekeeping: "家政", activity: "旅游"}[v];
    },
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    }
});

var consumeCardManage = (function(){
    function queryService(cardNumber, cardId) {
        var queryParams = {userId: PAGE_CONFIG['userId'], cardNumber: cardNumber, cardId: cardId};
        if (!$('#dgService').datagrid('options').url) {
            $('#dgService').datagrid({
                url: CONFIG.baseUrl + 'user/purse/serviceCard/service/list.do',
                queryParams: queryParams,
                fit:true,
                pagination: false,
                onSelect: function(index, row) {
                    var serviceProductTab = $('#serviceRelatedTabs').tabs('getTab', 0).panel('options').tab;
                    if (row.serverFlag == 2) {
                        $('#serviceRelatedTabs').tabs('select', 0);
                        serviceProductTab.show();
                        queryServiceProduct(row.serviceCode, row.cardId);
                    } else {
                        $('#serviceRelatedTabs').tabs('select', 1);
                        serviceProductTab.hide();
                        $('#dgServiceProduct').datagrid('clear');
                    }
                    queryServiceProvider(row.serviceCode, row.cardId);
                },
                onLoadSuccess: function() {
                    $('#dgServiceProduct, #dgServiceProvider').datagrid('clear');
                }
            });
        } else {
            $('#dgService').datagrid('load', queryParams);
        }
    }
    
    function queryServiceProvider(serviceCode, cardId) {
        var queryParams = {serviceCode: serviceCode, cardId: cardId};
        
        var dg = $('#dgServiceProvider');
        if (!dg.datagrid('options').url) {
            dg.datagrid({
                url: CONFIG.baseUrl + 'user/purse/serviceCard/provider/list.do',
                queryParams: queryParams,
                fit:true,
                pagination: false
            });
        } else {
            dg.datagrid('load', queryParams);
        }
    }
    
    function queryServiceProduct(serviceCode, cardId) {
        var queryParams = {serviceCode: serviceCode, cardId: cardId};
        
        var dg = $('#dgServiceProduct');
        if (!dg.datagrid('options').url) {
            dg.datagrid({
                url: CONFIG.baseUrl + 'user/purse/serviceCard/product/list.do',
                queryParams: queryParams,
                fit:true,
                pagination: false
            });
        } else {
            dg.datagrid('load', queryParams);
        }
    }
    
    $('#buy').click(function(){
        var dlg = openEditDialog({
            title: '选择要购买的服务卡',
            width: 1000,
            height: 400,
            href: 'view/cardConsume/card/cardDatagrid.do',
            onSave: function(dlg) {
                var selCard = dlg.find('#dgConsumeCard').datagrid('getSelected');
                $.post(CONFIG.baseUrl + 'user/purse/buyServiceCard.do',
                    {cardId: selCard.cardId, userId: PAGE_CONFIG['userId']},
                    function(code) {
                        if (code == '000') {
                            dlg.dialog('destroy');
                            dlg.find('#dgConsumeCard').datagrid('reload');
                            purse.refresh();
                        } else if (code == '210') {
                            alertInfo('支付密码错误');
                        } else if (code == '212') {
                            alertInfo('用户余额不足');
                        } else {
                            showOpFailMessage();
                        }
                    });
            }
        });
    });
    
    return {
        loadData: function(data) {
            $('#dgConsumeCard').datagrid({
                data: data,
                fit: true,
                pagination: false,
                onSelect: function(index, row) {
                    queryService(row.cardNumber, row.cardId);
                },
                onLoadSuccess: function() {
                    $('#dgService').datagrid('clear');
                }
            });
        }
    };
    
})();
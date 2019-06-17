/**
 * 商品选择器
 */
var productManager = (function () {
    var that = {};
    
    that.query = function() {
        var params = $("#frmQueryProduct").serializeObject()
        if($("#dgProduct").datagrid("options").url == null) {
            $("#dgProduct").datagrid({
                url: CONFIG.baseUrl + "shop/product/productPage.do",
                fit:true,
                queryParams: params
            });
        } else {
            $("#dgProduct").datagrid("load", params);
        }
    }

    var queryParams = {industryId: PAGE_CONFIG['industryId']};
    var industryId = PAGE_CONFIG['industryId'];
    switch (industryId) {
    case 'catering':
        queryParams.providerId = PAGE_CONFIG['providerId'];
        break;
    case 'housekeeping':
        queryParams.providerId = 0;
        break;
    case 'mall':
        queryParams.providerId = '';
        break;
    }
    makeCategoryManager({
        queryParams: queryParams,
        onSelect: that.query
    });
    
    $('#query').click(that.query);
    
    return that;
})();

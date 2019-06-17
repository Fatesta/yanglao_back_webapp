$(function() {
    $('#tbrDgPro [name=manageProduct]').click(function() {
        var pro = $("#dgPro").datagrid("getSelected");
        if(pro.industryId == "activity") {
            openTab("mainTab", CONFIG.baseUrl + "activity/index.do?providerId=" + pro.providerId + '&_func_code=activityManager',
                pro.name + " - 活动管理");
        } else {
            openTab("mainTab", CONFIG.baseUrl + "shop/product/index.do?providerId=" + pro.providerId,
                pro.name + " - 商品管理");
        }
    });
    
    pro.query();
});
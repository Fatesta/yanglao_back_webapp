$(function() {

    $('#tbrDgPro [name=manageOrder]').click(function() {
        var pro = $("#dgPro").datagrid("getSelected");
        if (pro.industryId == 'integral_mall') {
            openTab("mainTab", CONFIG.baseUrl + "shop/order/index.do?providerId=" + pro.providerId + '&industryId=' + pro.industryId,
              pro.name + " - " + pro.industryText + "订单管理");
        } else {
            top.app.pushPage({
                path: '/shop/order/index',
                subTitle: pro.name,
                params: {providerId: pro.providerId},
                key: pro.providerId
            });
        }
    });
    
    $('#tbrDgPro [name=addOrder]').click(function() {
        var pro = $("#dgPro").datagrid("getSelected");
        if (pro.industryId == 'activity') {
            alertInfo('不支持活动下单');
            return;
        }
        
        if (pageConfig.fastOrderMode) {
          openTab("mainTab", CONFIG.baseUrl + "shop/order/orderAdd.do?providerId=" + pro.providerId + '&fastOrderMode=1&userId=' + pageConfig.userId,
              '快速下单-' + pro.name);
        } else {
            if (pro.industryId == 'housekeeping') {
                top.app.pushPage({
                    path: '/shop/order/flow/place/index',
                    params: {providerId: pro.providerId, industryId: pro.industryId},
                    subTitle: pro.name
                });
            } else {
                openTab("mainTab", CONFIG.baseUrl + "shop/order/orderAdd.do?providerId=" + pro.providerId,
                  pro.name + " - 下单");
            }
        }

    });

    pro.columns.push({field:'unprocessedOrderCount',title:'未处理订单数', width:'6%',align:'center'});
    pro.query();
});
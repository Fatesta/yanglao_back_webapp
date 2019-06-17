

$(function() {
    $('#statuses').comboboxFromDict({
        dict: workOrder.statusItems,
        enableEmptyItem: false,
        emptyItem: {text: '全部', value: ''},
        value: '',
        formatter: function(row) {
            return row.value ? workOrder.statusHtmlByValue(row.value.split(',')[0]) : row.text;
        },
        onSelect: function(row) {
            var textbox = $(this).next().find('.textbox-text');
            if (row.value)
                textbox.css(workOrder.statusCssByValue(row.value.split(',')[0]));
            else {
                textbox.css({color: 'black'});
            }
        }
    });
    
    $('[name=query]').click(query);

    $('#selectUser').click(function() {
        $('#frmQueryOrder [name=creator]').val('');
        $('#frmQueryOrder #creatorName').textbox('clear');
        openUserSelectDialog({
            onSelectDone: function(user){
                $('#frmQueryOrder [name=creator]').val(user.uesrId);
                $('#frmQueryOrder #creatorName').textbox('setValue', user.aliasName);
                return true;
            }
        });
    });
    
    $("#tbrDgOrder #selectProvider").click(function(){
        $("#frmQueryOrder #providerName").textbox('clear');
        $("#frmQueryOrder [name=providerId]").val('');
        openProviderSelectDialog({
           onDone: function(provider) {
               $("#frmQueryOrder #providerName").textbox('setValue', provider.name);
               $("#frmQueryOrder [name=providerId]").val(provider.providerId);
               return true;
           }
        });
    });
    
    query();
    
    function query() {
        var params = $("#frmQueryOrder").serializeObject();
        // 设置时间为当天
        params.startCreateTime = params.startCreateTime && params.startCreateTime + " 00:00:00";
        params.endCreateTime = params.endCreateTime && params.endCreateTime + " 23:59:59";
        params.industryIds = "'mall','activity','catering','housekeeping'";
        if($("#dgOrder").datagrid("options").url == null) {
            $("#dgOrder").datagrid({
                url: CONFIG.baseUrl + 'shop/order/orderPage.do',
                fit:true,
                queryParams: params,
                pageSize: 30
            });
        }
        else {
            $("#dgOrder").datagrid("load", params);
        }
    }
});

function viewOrderDetail(orderCode) {
    openTab({
        title: '跟踪工单 - ' + orderCode,
        url: CONFIG.baseUrl + 'view/shop/workOrder/orderDetail.do?orderCode=' + orderCode,
    });
}

function gotoOrderLoc(orderno) {
    if (getModuleContext('shop.orderLocation') && getModuleContext('shop.orderLocation').isCreated()) {
        openModuleByCode('shop.orderLocation');
        setTimeout(function() {
            getModuleContext('shop.orderLocation').gotoOrder(orderno);
        }, 1000);
    } else {
        openModuleByCode('shop.orderLocation', {onLoad: function() {
            setTimeout(function() {
                getModuleContext('shop.orderLocation').gotoOrder(orderno);
            }, 1000);
        }});
    }
}

var formatters = {
    status: workOrder.statusHtmlByValue,
    industryId: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('product.industry')),
    lineState: function(v) {
        return v ? '线上' : '线下';
    },
    op: function(_, order) {
        var html = '';
        html += UICommon.buttonHtml({
            text: '跟踪工单 ',
            icon: 'order-trace',
            clickCode: 'viewOrderDetail(\'' + order.orderno + '\')'
        });
        if (order.longitude && order.latitude) {
            html += UICommon.buttonHtml({
                text: '定位',
                icon: 'location',
                clickCode: 'gotoOrderLoc(\'' + order.orderno + '\')'});
        }

        return html;
    }
}

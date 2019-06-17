/**
 * 增加订单
 * @author: hulang
 *
 */

var orderAdd = (function () {
    var addedProducts = {};
    var that = makeLinkmanSelect();
    
    that.nextStep = function() {
        if(_.keys(addedProducts).length == 0) {
            alertInfo("请先选择商品");
            return;
        }
        if(_.keys(addedProducts).length > 1) {
            alertInfo("一个家政订单只能包含一个家政服务，<br>请分多次下单");
            return;
        }
        var dlg = openEditDialog({
            width: 600,
            height: '90%',
            modal: true,
            href: 'view/shop/order/housekeeping/editOrderInfo.do',
            title: '确认以及填写订单信息',
            onLoad: function() {
                $("#dgAddedProduct").datagrid({
                    data: _.values(addedProducts)
                });

                $('#payType').combobox({
                    onSelect: function(item) {
                        $('#trSelectedForCardPay').hide();
                        $("#creator").val("");
                        $("#linkphone").numberbox("setValue", '');
                        // 如果选择消费卡支付方式
                        if (item.value == 34) {
                            $('#trLinkphone').hide();
                            selectUser();
                        } else {
                            $('#trLinkphone').show();
                        }
                    }
                });
                
                that.onOrderEdit();
                function selectUser() {
                    var dlg = openUserSelectDialog({
                        onSelectDone: function(user){
                            if ($('#payType').combobox('getValue') == 34) {
                                var selectCardDialog = openEditDialog({
                                    title: '选择用户[' + user.aliasName  + ']支持下单商品的消费卡',
                                    width: 600,
                                    height: 400,
                                    href: 'view/shop/order/housekeeping/cardAndService.do?' + $.param({userId: user.userId, productId: _.keys(addedProducts)[0]}),
                                    buttons:[{
                                        text:"提交",
                                        iconCls:"icon-save",
                                        handler:function() {
                                            var row = $('#dgCardAndService').datagrid('getSelected');
                                            if (!row) {
                                                alertInfo('请选择一个消费卡');
                                                return;
                                            }
                                            
                                            $('#frmOrder [name=creator]').val(user.userId);
                                            $("#linkphone").numberbox("setValue", user.telphone);
                                            
                                            $('#frmOrder [name=cardId]').val(row.cardId);
                                            $('#frmOrder [name=cardNumber]').val(row.cardNumber);
                                            $('#frmOrder [name=serviceCode]').val(row.serviceCode);
                                            $('#trSelectedForCardPay').show();
                                            $('#trSelectedForCardPay [name=user]').text(user.aliasName + '(' + user.telphone + ')');
                                            $('#trSelectedForCardPay [name=cardService]').text(row.cardName + '(' + row.cardNumber + ')' + ', ' + row.serviceName);
                                            selectCardDialog.dialog('destroy');
                                        }
                                    },{
                                        text: "返回",
                                        iconCls: 'icon-back',
                                        handler:function(){
                                            selectCardDialog.dialog('destroy');
                                            selectUser();    
                                        }
                                    },{
                                        text:"取消",
                                        iconCls:'icon-cancel',
                                        handler:function(){
                                            selectCardDialog.dialog("destroy");    
                                        }
                                    }]
                                });
                            } else {
                                $('#frmOrder [name=creator]').val(user.userId);
                                $("#linkphone").numberbox("setValue", user.telphone);
                            }
                        }
                    });
                }
            },
            onSave: function() {
                that.submit(function() {
                    dlg.dialog('destroy');
                });
            }
        });
    }
    
    that.submit = function(onSuccess) {
        // 如果选择了消费卡支付方式
        if ($('#payType').combobox('getValue') == 34) {
            if (!($('#frmOrder [name=creator]').val() && $('#frmOrder [name=cardId]').val())) {
                alertInfo("请选择用户和消费卡");
                return;
            }
        } else {
            if(!that.validateLinkmanSelect()) {
                return;
            }
        }
        
        // 已选中商品
        var products = _.values(addedProducts);
        // 保留商品主要字段并全部转换为字符串类型在JSON中
        products = products.map(function(p){
            return {
                productId: p.productId.toString(),
                productName: Base64.encode(p.name, true),// base64 with utf8encode
                price: "0",
                imageFile: p.imageFile,
                quantity: "1",
            };
        });
        // JSON赋值到表单
        $("#frmOrder [name=productListJSON]").val(JSON.stringify(products));
        // 店铺数据赋值到表单
        $("#frmOrder").form("load", {industryId: 'housekeeping', providerId: PAGE_CONFIG["providerId"]});
        
        // 提交
        $("#frmOrder").form("submit", {
            url:CONFIG.baseUrl + "shop/order/addOrder.do",
            success:function(ret){
                var ret = JSON.parse(ret);
                if (ret.success) {
                    showOpOkMessage();
                    // 重置表单
                    $("#frmOrder").form("reset");
                    $('#trSelectedForCardPay').hide();
                    $('#trSelectedForCardPay [name=user]').text('');
                    $('#trSelectedForCardPay [name=cardService]').text('');
                    $("#linkphone").numberbox("setValue", '');
                    $('#trLinkphone').show();
                    onSuccess();
                } else {
                    alertError({222: '服务已用完', 223: '消费卡过期', 228: '消费卡预约服务次数达到上限'}[ret.code]);
                }
            }
        });
    }
    
    that.deleteAddedProduct = function(productId) {
        delete addedProducts[productId];
        $("#dgAddedProduct").datagrid({
            data: _.values(addedProducts)
        });
    }
    
    $(function(){
        $("#step1").panel("expand").panel("maximize");
        var queryParams = {industryId: 'housekeeping', providerId: 0};
        makeCategoryManager({
            queryParams: queryParams,
            onSelect: function(node) {
                queryProduct({categoryId: node.id, providerId: PAGE_CONFIG['providerId']});
            }
        });
        queryProduct(queryParams);
    });
    
    function queryProduct(params) {
        if($("#dgProduct").datagrid("options").url == null) {
            $("#dgProduct").datagrid({
                url: CONFIG.baseUrl + "shop/product/productPage.do",
                fit:true,
                queryParams: params,
                onLoadSuccess: function(data){
                    for(var productId in addedProducts) {
                        $('#check_' + productId).prop('checked', true);
                    }
                    data.rows.forEach(function(product){
                        $('#check_' + product.productId).change(function(){
                            if($(this).prop("checked")) {
                                addedProducts[product.productId] = product;
                            } else {
                                delete addedProducts[product.productId];
                            }
                        });
                    });
                }
            });
        } else {
            $("#dgProduct").datagrid("load", params);
        }
    }
    
    return that;
})();

orderAdd.formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="50px" />';
    },
    description: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "description", min: 80
    }),
    check: function(value,rowData,rowIndex) {
        return '<input id="check_' + rowData.productId + '" type="checkbox" style="width:50px;" />';
    },
    addedProductOp: function(value,rowData,rowIndex) {
        return '<a href="#" class="easyui-linkbutton" title="删除" data-options="iconCls:\'color:fff\'" onclick=orderAdd.deleteAddedProduct(' + rowData.productId + ')>'
            +'<span class=\'icon-delete \' style=\'float:left;width:20px;\'>&nbsp;</span></a>';
    }
};
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

        var dlg = openEditDialog({
            width: 600,
            height: '90%',
            modal: true,
            href: 'view/shop/order/catering/editOrderInfo.do',
            title: '确认以及填写订单信息',
            onLoad: function() {
                calcOrderTotalFee();
                $("#dgAddedProduct").datagrid({
                    data: _.values(addedProducts)
                });
                
                that.onOrderEdit();
            },
            onSave: function(dlg) {
                that.submit(function() {
                    dlg.dialog('destroy');
                });
            }
        });
    }
    
    that.submit = function(onSuccess) {
        if(_.keys(addedProducts).length == 0) {
            showMessage("提示", "请选择商品");
            return;
        }
        if(!that.validateLinkmanSelect()) return;
        // 已选中商品
        var products = _.values(addedProducts);
        // 保留商品主要字段
        products = products.map(function(p){
            return {
                productId: p.productId,
                productName: Base64.encode(p.name, true),// base64 with utf8encode
                price: p.price,
                cateringIntegral: Math.floor(p.price),
                quantity: p.quantity,
                imageFile: p.imageFile,
                productStatus: p.productStatus,
                orderDesc: "",
            };
        });
        // 第一个商品图作为订单封面
        $("#frmOrder [name=productImgurl]").val(products[0].imageFile);
        // JSON赋值到表单
        $("#frmOrder [name=productListJSON]").val(JSON.stringify(products));
        // 店铺数据赋值到表单
        $("#frmOrder").form("load", {industryId: 'catering', providerId: PAGE_CONFIG["providerId"]});
        
        // 提交
        $("#frmOrder").form("submit", {
            url:CONFIG.baseUrl + "shop/order/addOrder.do",
            success:function(data){
                var data = str2Json(data);
                if (data.success) {
                    showMessage('提示', data.message);
                    // 重置表单
                    $("#frmOrder").form("reset");
                    $("#frmOrder #spanPaymentFee").empty();
                    $("#frmOrder").form("load", {mealNumber: 0});
                    onSuccess();
                } else {
                    showAlert("提示", data.message,'error');
                }
            }
        });
    }
    
    that.deleteAddedProduct = function(productId) {
        delete addedProducts[productId];
        $("#dgAddedProduct").datagrid({
            data: _.values(addedProducts)
        });
        calcOrderTotalFee();
    }
    
    $(function(){
        $("#step1").panel("expand").panel("maximize");

        var queryParams = {industryId: 'catering', providerId: PAGE_CONFIG["providerId"]};
        makeCategoryManager({
            queryParams: queryParams,
            onSelect: function(node) {
                queryProduct({categoryId: node.id, providerId: PAGE_CONFIG["providerId"]});
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
                        $('#quantity_' + productId).numberspinner({value: addedProducts[productId].quantity});
                    }
                    data.rows.forEach(function(product){
                        $('#quantity_' + product.productId).numberspinner({    
                            min: 0,  
                            editable: false,
                            onChange: function(now, old) {
                                if(now == 0)
                                    delete addedProducts[product.productId];
                                else {
                                    product.quantity = now;
                                    addedProducts[product.productId] = product;
                                }
                            }
                        });
                    });
                }
            });
        } else {
            $("#dgProduct").datagrid("load", params);
        }
    }
    
    // 计算订单总金额
    function calcOrderTotalFee() {
        var total = 0;
        var sendIntegral = 0;
        for(var i in addedProducts) {
            var product = addedProducts[i];
            product.totalPrice = product.price * product.quantity;
            total += product.totalPrice;
            product.totalPrice = product.totalPrice.toFixed(2);
            sendIntegral += Math.floor(product.price);
        }
        
        var totalFee = total.toFixed(2);
        $("#frmOrder #totalFee").val(totalFee);
        $("#frmOrder #paymentFee").val(totalFee);
        $("#frmOrder #sendIntegral").val(sendIntegral);
        $("#spanTotalFee").text(totalFee);
        $("#frmOrder #spanPaymentFee").text(totalFee);
    }
    
    return that;
})();

orderAdd.formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="50px" />';
    },
    description: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "description", min: 20
    }),
    price: function(value,rowData,rowIndex) {
        return value.toString().indexOf(".") == -1 ? value + ".00" : value;
    },
    quantity: function(value,rowData,rowIndex) {
        return '<input id="quantity_' + rowData.productId + '" class="easyui-numberspinner" style="width:50px;" required="required" value=0/>';
    },
    addedProductOp: function(value,rowData,rowIndex) {
        return '<a href="#" class="easyui-linkbutton" title="删除" data-options="iconCls:\'color:fff\'" onclick=orderAdd.deleteAddedProduct(' + rowData.productId + ')>'
            +'<span class=\'icon-delete \' style=\'float:left;width:20px;\'>&nbsp;</span></a>';
    }
};
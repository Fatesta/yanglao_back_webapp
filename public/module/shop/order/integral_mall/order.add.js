/**
 * 增加订单
 * @author: hulang
 *
 */

var orderAdd = (function () {
    var addedProducts = {};
    var addedProductAttrMap = {};
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
            href: 'view/shop/order/integral_mall/editOrderInfo.do',
            title: '确认以及填写订单信息',
            onLoad: function() {
                calcOrderTotalFee();
                $("#dgAddedProduct").datagrid({
                    data: _.values(addedProducts)
                });
                
                that.onOrderEdit();
            },
            onSave: function() {
                that.submit(function() {
                    dlg.dialog('destroy');
                });
            }
        });
    }

    that.selectProductDetail = function(rowIndex) {
        var product = $("#dgProduct").datagrid("getRows")[rowIndex];
        var dialog = openEditDialog({
            width: 400,
            height: 300,
            modal: true,
            title: "购买数量",
            content: '<div id="content"></div>',
            onSave: save
        });
        if(product.detail) {
            dialog.find("#content").html(template("productDetailTpl",
                {productAttrs: product.detail.attributeList}));
            var quantity = addedProducts[product.productId] ? (addedProducts[product.productId].quantity || 0) : 1;
            $("#quantity").numberspinner({value: quantity});
            initAttrButtons();
        } else {
            $.get(CONFIG.baseUrl + "shop/order/mall/productDetail.do?productId=" + product.productId, function(productDetail){
                product.detail = productDetail || {attributeList: []};
                product.detail.attributeList.forEach(function(attr){
                    attr.name = attr.attributeName;
                    attr.values = attr.attributeValue.split(",");
                });
                
                dialog.find("#content").html(template("productDetailTpl",
                    {productAttrs: product.detail.attributeList}));
                // 初始数量微调器
                $("#quantity").numberspinner();
                
                initAttrButtons();
            });
        }
        
        var editingAttrMap = _.clone(addedProductAttrMap[product.productId]) || {};
        // 保存属性选择
        function save() {
            // 确定已加属性
            addedProductAttrMap[product.productId] = editingAttrMap;
            // 如果输入数量等于0
            if($("#quantity").val() == 0) {
                // 从已加商品中删除该商品
                delete addedProducts[product.productId];
                // 并清空已加属性数组
                addedProductAttrMap[product.productId] = {};
            } else {
                var selectedAttrMap = addedProductAttrMap[product.productId];
                // 如果该商品具有规格属性
                if(product.detail.attributeList.length > 0) {
                    if(_.keys(selectedAttrMap).length != product.detail.attributeList.length) {
                        showMessage("提示", "请选择属性");
                        return;
                    }
                    // 将已选属性写到商品备注字段里
                    var attrs = [];
                    _.each(selectedAttrMap, function(val, type){
                        attrs.push(type + "-" + val);
                    });
                    product.memo = "已选择:" + attrs.join(", ");
                }
                
                // 加入已加商品
                addedProducts[product.productId] = _.extend(product, {quantity: $("#quantity").val()});
            }
            dialog.dialog("close");
        }
        
        // 初始化属性按钮
        function initAttrButtons() {
            if(product.detail.attributeList.length == 0)
                return;
            /// 属性选择按钮事件
            var attrNameCells = dialog.find("#content [name=attrName]");
            // 遍历所有属性名列
            attrNameCells.each(function(){
                var attrType = $(this).data("type");
                var btns = $(this).parent().next().find("[name=attrValue]");
                // 遍历该属性的每个属性值按钮
                btns.each(function(){
                    var attrVal = $(this).data("value");
                    $(this).linkbutton({
                        toggle: false,
                        onClick: function() {
                            // 为实现单选按钮, 先设所有不选中
                            btns.each(function(){
                                setSelectedCss(this, false);
                            });
                            // 然后设该单击目标选中
                            setSelectedCss(this, true);
                            editingAttrMap[attrType] = attrVal;
                        }
                    });
                    
                    this.initBorderCss = $(this).css("border");

                    if(editingAttrMap) {
                        setSelectedCss(this, editingAttrMap[attrType] == attrVal);
                    }
                });
            });
            
            function setSelectedCss(elem, selected) {
                $(elem).css({"border-color": selected ? "red" : elem.initBorderCss});
            }
        }
    }
    
    that.deleteAddedProduct = function(productId) {
        delete addedProducts[productId];
        $("#dgAddedProduct").datagrid({
            data: _.values(addedProducts)
        });
        calcOrderTotalFee();
    }
    
    that.submit = function(onSuccess) {
        if(_.keys(addedProducts).length == 0) {
            showMessage("提示", "请选择商品");
            return;
        }
        if(!that.validateLinkmanSelect()) return;
        
        var products = _.values(addedProducts);
        // 保留商品主要字段并全部转换为字符串类型
        products = products.map(function(p){
            return {
                productId: p.productId.toString(),
                productName: Base64.encode(p.name, true),// base64 with utf8encode
                price: p.price.toString(),
                quantity: p.quantity.toString(),
                orderDesc: p.memo ? Base64.encode(p.memo, true) : "",
                imageFile : p.imageFile
            };
        });
        // 第一个商品图作为订单封面
        $("#frmOrder [name=productImgurl]").val(products[0].imageFile);
        // 将其JSON赋值到表单
        $("#frmOrder [name=productListJSON]").val(JSON.stringify(products));
        // 店铺数据赋值到表单
        $("#frmOrder").form("load", PAGE_CONFIG["provider"]);
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
                    // 清空选择记录
                    addedProducts = {};
                    addedProductAttrMap = {};
                    onSuccess();
                } else {
                    showAlert("提示", data.message,'error');
                }
            }
        });
    }

    $(function(){
        $("#step1").panel("expand").panel("maximize");
    });
    
    // 计算订单总金额
    function calcOrderTotalFee() {
        var total = 0;
        for(var i in addedProducts) {
            var product = addedProducts[i];
            product.totalPrice = product.price * product.quantity;
            total += product.totalPrice;
        }
        var totalFee = total.toFixed(0);
        $("#frmOrder #totalFee").val(totalFee);
        $("#frmOrder #paymentFee").val(totalFee);
        $("#spanTotalFee").text(totalFee);
        $("#frmOrder #spanPaymentFee").text(totalFee);
    }
    
    return that;
})();

orderAdd.formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    price: function(value,rowData,rowIndex) {
        return value.toString().indexOf(".") == -1 ? value + ".00" : value;
    },
    op: function(value,rowData,rowIndex) {
        return '<a href="#" class="easyui-linkbutton" title="增加购买数量" data-options="iconCls:\'color:fff\'" onclick=orderAdd.selectProductDetail(' + rowIndex + ')>'
            +'<span class=\'icon-add \' style=\'float:left;width:20px;\'>&nbsp;</span></a>';
    },
    addedProductOp: function(value,rowData,rowIndex) {
        return '<a href="#" class="easyui-linkbutton" title="删除" data-options="iconCls:\'color:fff\'" onclick=orderAdd.deleteAddedProduct(' + rowData.productId + ')>'
            +'<span class=\'icon-delete \' style=\'float:left;width:20px;\'>&nbsp;</span></a>';
    }
};
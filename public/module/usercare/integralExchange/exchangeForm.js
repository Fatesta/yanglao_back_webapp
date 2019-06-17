var formatters = {
    imageFile : function(value, rowData, rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    addOp : function(value, product, rowIndex) {
        return UICommon.buttonHtml({icon: 'add', clickCode: 'selectProduct(' + product.productId + ')'});
    },
    quantityOp: function(value, rowData, rowIndex) {
        return '<input id="product_'+rowData.productId+'" class="easyui-numberspinner" data-product-id="' + rowData.productId + '" style="width:50px;"/>';
    }
};

//查询用户信息
$("#userForm [name=selectUser]").click(function(){
	openUserSelectDialog({
		onSelectDone:function(user){
		    user.userName = user.aliasName;
		    user.accountId = user[{0: 'userId', 1: 'userId', 2: 'deviceCode', 9: 'deviceCode'}[user.userType]];
			$("#userForm").form('load', user);
			$.get(CONFIG.baseUrl+'user/integral/number.do?userId='+user.userId,function(ret){
				$("#userForm [textboxname=integral]").textbox('setValue', ret);
			});
			return true;
		}
	})
});

//查询礼品
$("#frmProductQuery [name=query]").click(function(){
	$("#dgProduct").datagrid('reload', $("#frmProductQuery").serializeObject());
});

var shopCar = new ShopCar();

$("#dgProduct").datagrid({
    url: CONFIG.baseUrl + 'integralExchange/productPage.do',
    fit: false,
    idField: 'productId',
    loadFilter: function(page) {
        page.rows = page.rows.filter(function(product) {
            return !shopCar.getProductSlots()[product.productId];
        });
        return page;
    },
    onLoadSuccess: function() {
        $(this).datagrid('unselectAll');
    }
});

function selectProduct(productId) {
    var index = $("#dgProduct").datagrid('getRowIndex', productId);
    var product = $("#dgProduct").datagrid('getRows')[index];
    var success = shopCar.addProduct(product);
    if(success) {
        $("#dgProduct").datagrid('deleteRow', index);
    }
}

var submiting = false;
function submit(dlg) {
    var accountId = $("#userForm [name=accountId]").val();
    if (!accountId) {
        alertInfo('请选择用户');
        return;
    }
    var userIntegral = +$('#userForm [textboxname=integral]').numberbox('getValue');
    if(userIntegral < +$('#totalIntegral').numberbox('getValue')) {
        alertInfo('用户积分不足');
        return;
    }
    var items = shopCar.getItems();
    if(items.length == 0) {
        alertInfo('未选择兑换商品');
        return;
    }
    submiting = true;
    $.ajax({
        type: 'POST',
        url: CONFIG.baseUrl+'integralExchange/exchange.do',
        contentType: 'application/json;charset=utf-8',
        data: JSON.stringify({accountId: accountId, items: items}),
        success: function(ret){
            if (ret.success) {
                $('#userForm').form('clear');
                $('#dgProduct').datagrid('reload');
                shopCar.clear();
                $('#dgIntegralExchangeRecord').datagrid('reload');
                showOpOkMessage();
            } else {
                var html = '';
                if(ret.code != '000')
                    html += '<p>商品兑换失败: ' + {'213': '库存不足', 233: '用户积分不足'}[ret.code] + '</p>';
                showOpFailMessage(html);
            }
            submiting = false;
        }
    });
}


function ShopCar() {
    var datagrid = $("#dgSelectedProduct");
    var productSlots = {};//productId -> {product, quantity}

    this.addProduct = function(product) {
        if(product.stock == 0) {
            alertInfo('该商品库存为0');
            return false;
        }
        if(productSlots[product.productId]) {
            datagrid.datagrid('selectRecord', product);
            setTimeout(function() {
                $("#product_" + product.productId).numberspinner('setValue', ++productSlots[product.productId].quantity);                
            }, 100);
            return false;
        }
        datagrid.datagrid('appendRow', product);
        datagrid.datagrid('selectRecord', product);
        productSlots[product.productId] = {product: product, quantity: 1};
        calcIntegral();
        $("#product_" + product.productId).numberspinner({
            min: 0,
            max: product.stock,
            value: 1,
            onChange: function(value) {
                var productId = $(this).data('product-id');
                productSlots[productId].quantity = +value;
                calcIntegral();
                if(value == 0) {
                    setTimeout(function() {
                        removeProduct(productId);
                    }, 100);
                }
            }
        });
        return true;
    }

    this.getProductSlots = function() {
        return productSlots;
    }

    this.getItems = function() {
        return _.map(productSlots, function(item, productId) {
            return {productId: productId, productName: item.product.name, quantity: item.quantity, points: item.product.price};
        });
    }
    
    this.clear = function() {
        for(var productId in productSlots) {
            removeProduct(productId);
        }
    }
    
    function removeProduct(productId) {
        datagrid.datagrid('deleteRow', datagrid.datagrid('getRowIndex', productId));
        
        //还原到“可选择商品”数据列表
        var product = productSlots[productId].product;
        var index = Math.max(_.findIndex($("#dgProduct").datagrid('getRows'),
            function(row) { return +product.productId <= row.productId; }), 0);
        $("#dgProduct").datagrid('insertRow', {
            index: index,
            row: product
        });
        
        delete productSlots[productId];
    }
    
    function calcIntegral() {
        var total = 0;
        _.forEach(productSlots, function(item) {
            total += item.product.price * item.quantity;
        });
        $('#totalIntegral').numberbox('setValue', total);
        $('#exchangeIntegral').numberbox('setValue', total);
    }
}
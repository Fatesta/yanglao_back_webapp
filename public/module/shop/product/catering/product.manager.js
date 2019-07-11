/**
 * 商品管理
 * @author: hulang
 */
var productManager = (function () {
    var that = new Observable();
    
    that.query = function() {
        var params = $("#frmQueryProduct").serializeObject()
        if($("#dgProduct").datagrid("options").url == null) {
            $("#dgProduct").datagrid({
                url: CONFIG.baseUrl + "shop/product/productPage.do",
                fit:true,
                queryParams: params,
                onSelect: function(rowIndex, rowData){
                    that.setChanged().notifyObservers({
                        event: "onSelect",
                        args: {rowIndex: rowIndex, rowData: rowData}});
                },
                onLoadSuccess: function(data){
                    that.setChanged().notifyObservers({event: "onLoadSuccess", args: data});
                }
            });
        } else {
            $("#dgProduct").datagrid("load", params);
        }
    }

    
    $("#tbrDgProduct [name=add]").click(function(){
        var cgNode = $('#treeCategory').tree("getSelected");
        if(!cgNode || cgNode.id == -1) {
            showMessage("提示","请先选择一个分类");
            return;
        }
        edit({
            providerId: PAGE_CONFIG["provider"].providerId,
            categoryId: cgNode.attributes.categoryId});
    });
    
    $("#tbrDgProduct [name=update]").click(function(){
        var row = $("#dgProduct").datagrid("getSelected");
        if(!row) return;
        edit({productId: row.productId});
    });
    
    $("#tbrDgProduct [name=delete]").click(function(){
        var rows = $("#dgProduct").datagrid("getSelections");
        if(rows.length == 0)
            return;
        showConfirm("提示","您真的要删除吗？", function(){
            $.post(CONFIG.baseUrl + "shop/product/deleteByProductIds.do?" + $.arrayPickParam("productIds", rows, "productId"), function(ret){
                showMessage("操作提示", ret.message);
                $("#dgProduct").datagrid('reload');
            });
        });
    });
    
    function edit(params) {
        var dlg = openEditDialog({
            title: "编辑菜品",
            width: 500,
            height: 400,
            href: "shop/product/catering/frmProduct.do?" + $.param(params),
            onSave: function(){
                if (!$("#frmProduct").form('validate'))
                    return;
                
                var price = $('#frmProduct [name=price]').val();
                // 如果未输入折后价则表示不打折,设为原价
                var discountedPrice = $('#frmProduct [name=discountedPrice]').val();
                if (!discountedPrice) {
                    $('#frmProduct [name=discountedPrice]').val(price);
                } else {
                    if (+discountedPrice > +price) {
                        alertInfo('折后价大于原价！');
                        return;
                    }
                }
                formSubmit("#frmProduct", {
                    url: "shop/product/saveProduct.do",
                    success:function(ret){
                        if (ret.success) {
                            dlg.dialog('close');
                            $("#dgProduct").datagrid("load");
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }
    
    makeCategoryManager({
        queryParams: {industryId: 'catering', providerId: PAGE_CONFIG["provider"].providerId},
        onSelect: that.query
    });
    
    return that;
})();

productManager.formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    imgPath: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    price: function(value,rowData,rowIndex) {
        return value == null ? "" : value.toString().indexOf(".") == -1 ? value + ".00" : value;
    },
    discountedPrice: function(val, row) {
      return parseFloat(val) == parseFloat(row.price) ? '未打折' : productManager.formatters.price(val);  
    },
    description: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "description", min: 40
    }),
    isvalid: function(value,rowData,rowIndex) {
        return {0:"<span style='color:red'>否</span>", 1:"<span style='color:green'>是</span>"}[value];
    }
};
$(function() {
    productManager.query();
});
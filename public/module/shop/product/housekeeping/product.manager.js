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
            title: "编辑信息",
            width: 750,
            height: 520,
            href: "shop/product/housekeeping/frmProduct.do?" + $.param(params),
            onSave: function(){
                $('[name=discountedPrice]', dlg).val($('[textboxname=price]', dlg).textbox('getValue'));
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
        queryParams: {industryId: 'housekeeping', providerId: PAGE_CONFIG["provider"].providerId},
        onSelect: that.query
    });
    
    return that;
})();

productManager.formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    description: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "description", min: 80
    }),
    simpleDescription: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "simpleDescription"
    }),
};
if (window['ProductImageManager']) {
    productManager.addObserver(new ProductImageManager());
}
$(function() {
    productManager.query();
});

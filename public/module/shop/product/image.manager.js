var ProductImageManager = function() {
    var that = {};
    var resourceId;
    
    var imageManagers = [
        new ImageManager(4, '#tbrDgProductImage1', '#dgProductImage1'),
        new ImageManager(11, '#tbrDgProductImage2', '#dgProductImage2'),
    ];
    
    that.update = function(obable, data) {
        switch(data.event) {
        case "onSelect":
            resourceId = data.args.rowData.productId;
            imageManagers.forEach(function(o) {  o.query() });
            break;
        case "onLoadSuccess":
            resourceId = '';
            imageManagers.forEach(function(o) { o.dg.datagrid("clear"); });
            break;
        }
    }
    
    function ImageManager(type, toolbar, dg) {
        var that = this;
        toolbar = $(toolbar);
        dg = $(dg);
        
        this.dg = dg;
        this.query = function() {
            var queryParams = {resourceId: resourceId, type: type};
            if(dg.datagrid("options").url == null) {
                dg.datagrid({
                    url: CONFIG.baseUrl + "uploadfile/uploadfilePage.do",
                    singleSelect: false,
                    fit:true,
                    queryParams: queryParams
                });
            } else {
                dg.datagrid("load", queryParams);
            }
        }

        toolbar.find("[name=add]").click(function(){
            if(!resourceId)
                return;
            openUploadImageDialog({
                onSuccess: function(data){
                    var file = {
                        type: type,
                        resourceId: resourceId,
                        fileName: data.originalFilename,
                        imgPath: data.url
                    };
                    $.post(CONFIG.baseUrl + 'uploadfile/insert.do', file,
                        function(){
                            that.query();
                        });
                }
            });
        });
        
        toolbar.find("[name=delete]").click(function(){
            var rows = dg.datagrid("getSelections");
            if(rows.length == 0)
                return;
            showConfirm("提示","您真的要删除吗？", function(){
                $.post(CONFIG.baseUrl + "uploadfile/deleteByFileIds.do?" + $.arrayPickParam("fileIds", rows, "fileId"), function(ret){
                    showMessage("操作提示", ret.message);
                    dg.datagrid('reload');
                });
            });
        });
    }

    return that;
};

ProductImageManager.formatters = {
    imgPath: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    }
};

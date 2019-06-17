var formatters = {
    thumbnailUrl: function(value) {
    	
        return value ? '<img src="' + value  + '" height="60px"/>' : '<div class="empty-value-box-100">无</div>';
   
    },
    status: function(v) {
	    var s = "";
	    if (v == 1)
	        s = "是"	
	        else s="否"
	    return s;
}	 

};

initCategorySelect({hasNoselected: true, toolbar: document});

$('#query').click(function(){
	
    $("#dg").datagrid("load", $("#frmQuery").serializeObject()); 
});

$('#add').click(function(){
	
    var dlg = openEditDialog({
        title: "选择资讯",
        width: 1120,
        height: 700,
        href: "view/info/index.do?category=information_health_exercises&infoStatus=1&hide_status_column=true&singleSelect=false",
        onSave: function(){
        	var infos  = (dlg.find("#dgInfo").datagrid('getSelections'));
            if (!infos) {
                alertInfo('请选择一个资讯');
                return;
            }

            $.post(CONFIG.baseUrl + 'mbkf/manageInfo/save.do?'+ $.arrayPickParam("ids", infos, "id"),
                {classesId: PAGE_CONFIG['classesId'] },
                function(ret){
                    if (ret.success) {
                        showOpOkMessage();
                    } else  {
                    	showOpResultMessage({message: ret.data + '个课件保存失败,原因已存在'});
                    }
                    dlg.dialog('destroy');
                    $('#dg').datagrid('reload');
                });
        }
    });
});


$('#delete').click(function(){
    var row = $('#dg').datagrid('getSelected');
    if(!row) return;
    openConfirmDeleteDialog(function(){
        $.post(CONFIG.baseUrl + 'mbkf/manageInfo/delete.do?classesId='
            + PAGE_CONFIG['classesId'] + '&informationId=' + row.informationId, function(ret){
            showOpResultMessage(ret);
            $('#dg').datagrid('reload');
        });
    });
 });



$('#setStatus').click(function(){
	 var row = $('#dg').datagrid('getSelected');
     if(!row) return;
     var val = +!row.recommendStatus;
        $.post(CONFIG.baseUrl + "mbkf/manageInfo/setStatus.do?", {classesId:row.classesId,informationId: row.informationId, recommendStatus: val}, function(ret){
            if (ret.success) {
                showMessage('操作提示', ret.message);
                $('#dg').datagrid('reload');
            } else {
                showAlert("操作提示", ret.message);
            }
      
    });
      
});



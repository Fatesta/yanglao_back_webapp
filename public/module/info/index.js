$(function(){
   $('#tbrInfo #query').click(function(){
	   
       $("#dgInfo").datagrid("load", $("#tbrInfo #frmQuery").serializeObject()); 
   });
   $("#tbrInfo #add").click(function(){
	 
       parent.openTab({
    	  
           url: 'view/info/edit.do',
           title: "编辑资讯"
       });
   });
   $("#tbrInfo #update").click(function(){
       var row = $("#dgInfo").datagrid("getSelected");
       if (!row)
           return;
       parent.openTab({
           url: 'view/info/edit.do?id=' + row.id,
           title: "编辑资讯 - " + row.title
       });
	});
   $("#tbrInfo #delete").click(function(){
       var rows = $("#dgInfo").datagrid("getSelections");
       if(rows.length == 0)
           return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + "info/delete.do?" + $.arrayPickParam("ids", rows, "id"), function(ret){
               showOpResultMessage(ret);
               $("#dgInfo").datagrid('reload');
           });
       });
    });
   
   $("#tbrInfo #publish").click(function(){
       var row = $("#dgInfo").datagrid("getSelected");
       if (!row || row.status != 0)
           return;
       post(CONFIG.baseUrl + 'info/publish.do', {id: row.id}, function(ret){
           if (ret.success)
               $("#dgInfo").datagrid("reload");
           showOpResultMessage(ret);
       });
   });

   $("#tbrInfo #view").click(function(){
       var row = $("#dgInfo").datagrid("getSelected");
       if(!row) return;
       var ww = $(window.top).width(),
           wh = $(window.top).height(),
           w = ww / 2,
           h = wh / 1.2;
       window.open(CONFIG.baseUrl + '/info/' + row.id + '.do', row.id,
           'width=' + w + ',height=' + h + ',left=' + ((ww - w) / 2) + ',top=' + ((wh - h) / 2));
    });

   initCategorySelect({hasNoselected: true});
});

var formatters = {
    status: function(value) {
        return {0: '编辑中', 1: '已发布'}[value];
    },
    thumbnailUrl: function(value) {
        return value ? '<img src="' + value  + '" height="100px"/>' : '<div class="empty-value-box-100">无</div>';
    }
};
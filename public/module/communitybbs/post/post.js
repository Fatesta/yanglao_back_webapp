var formatters = {
    status: function(v) {
        return {0: '编辑中', 1: '已发布'}[v];
    },
    thumbnailUrl: function(urls) {
        return urls ? UICommon.datagrid.formatter.generators.image({height: 100})(urls.split(',')[0])
            : '<div class="empty-value-box-100">无</div>';
    }
}
$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       parent.openTab({
           url: 'view/communitybbs/post/form.do',
           title: "编辑帖子"
       });
   });
   $("save").click(function(){
	   $("#dg").datagrid('load',$('#frmQuery').serializaObject());
   })
   $('#update').click(function(){
       var row = $("#dg").datagrid("getSelected");
       if (!row)
           return;
       parent.openTab({
           url: 'view/communitybbs/post/form.do?id=' + row.id,
           title: "编辑帖子 - " + row.title
       });
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'communitybbs/post/delete.do?id=' + row.id, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   $("#publish").click(function(){
       var row = $("#dg").datagrid("getSelected");
       if (!row || row.status != 0)
           return;
       post(CONFIG.baseUrl + 'communitybbs/post/publish.do', {id: row.id}, function(ret){
           if (ret.success)
               $("#dg").datagrid("reload");
           showOpResultMessage(ret);
       });
   });
});
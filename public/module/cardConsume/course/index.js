$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       var url = 'view/cardConsume/course/add.do?serviceCode=' + PAGE_CONFIG['serviceCode'];
       
       var dlg = openEditDialog({
           title: '增加课程',
           width: 500,
           height: 150,
           href: url,
           onSave: function() {
               formSubmit({
                   url: 'cardConsume/course/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dg').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'cardConsume/course/delete.do?',
               {serviceCode: row.serviceCode, infoCategoryId: row.infoCategoryId},
               function(ret){
                   showOpResultMessage(ret);
                   $('#dg').datagrid('reload');
           });
       });
    });

});
$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       openUserSelectDialog({
           onSelectDone: function(user){
               $.post(CONFIG.baseUrl + 'mbkf/student/save.do',
                   {classesId: PAGE_CONFIG['classesId'], userId: user.userId},
                   function(ret){
                       if (ret.success) {
                           $('#dg').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   });
               return true;
           }
       });
   });

   $('#delete').click(function(){
       var rows = $('#dg').datagrid('getSelections');
       if(rows.length == 0)
           return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'mbkf/student/delete.do?classesId='
               + PAGE_CONFIG['classesId'] + '&' + $.arrayPickParam('ids', rows, 'userId'), function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
    });
});
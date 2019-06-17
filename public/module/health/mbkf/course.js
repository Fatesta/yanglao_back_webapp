$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       edit();
   });
   $('#update').click(function(){
       edit(true);
   });
   $('#delete').click(function(){
       var rows = $('#dg').datagrid('getSelections');
       if(rows.length == 0)
           return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'mbkf/course/delete.do?' + $.arrayPickParam('ids', rows, 'courseId'), function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
    });
   
   function edit(update) {
       var url = 'mbkf/course/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;
           url += '?courseId=' + row.courseId;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 500,
           height: 300,
           href: url,
           onSave: function() {
               $('[name=classesId]').val(PAGE_CONFIG['classesId']);
               formSubmit({
                   url: 'mbkf/course/save.do',
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
   }
});
$(function(){
   $('#add').click(function(){
       var selectProviderDialog = openProviderSelectDialog({
           onDone: function(provider) {
               $.post(CONFIG.baseUrl + 'cardConsume/serviceProvider/save.do',
                   {providerId: provider.providerId, serviceCode: SERVICE_PROVIDER_PPAGE_CONFIG['serviceCode']},
                   function(ret) {
                       if (ret.code == 0) {
                           selectProviderDialog.dialog('destroy');
                           $('#dg').datagrid('reload');
                       } else if (ret.code == 1) {
                           showOpFailMessage();
                       } else if (ret.code == 2) {
                           alertInfo('选择店铺已存在');
                       }
                   });
           }
       });
   });
   
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'cardConsume/serviceProvider/delete.do',
               {providerId: row.providerId, serviceCode: SERVICE_PROVIDER_PPAGE_CONFIG['serviceCode']},
               function(ret){
                   showOpResultMessage(ret);
                   $('#dg').datagrid('reload');
           });
       });
   });

});
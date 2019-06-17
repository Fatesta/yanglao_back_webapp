$(function(){
   $('#add').click(function(){
       var dlg = openEditDialog({
           title: '选择服务',
           width: 800,
           height: 400,
           href: 'view/cardConsume/service/serviceDatagrid.do?categoryTypes=0,2',
           onSave: function(dlg) {
               var sel = dlg.find('#dg').datagrid('getSelected');
               $.post(CONFIG.baseUrl + 'shop/proService/save.do',
                   {providerId: PAGE_CONFIG['providerId'], serviceCode: sel.serviceCode},
                   function(ret) {
                       if (ret.code == 0) {
                           dlg.dialog('destroy');
                           $('#dgProService').datagrid('reload');
                       } else if (ret.code == 1) {
                           showOpFailMessage();
                       } else if (ret.code == 2) {
                           alertInfo('选择服务已存在');
                       }
                   });
           }
       });
   });
   $('#delete').click(function(){
       var row = $('#dgProService').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'shop/proService/delete.do',
               {providerId: PAGE_CONFIG['providerId'], serviceCode: row.serviceCode},
               function(ret){
                   showOpResultMessage(ret);
                   $('#dgProService').datagrid('reload');
           });
       });
    });
});
$(function(){
   $('#add').click(function(){
       openProviderToProductSelectDialog({
           onSubmit: function(product, provider) {
               $.post(CONFIG.baseUrl + 'cardConsume/serviceProduct/save.do',
                   {providerId: provider.providerId, productId: product.productId, serviceCode: SERVICE_PRODUCT_PPAGE_CONFIG['serviceCode']},
                   function(ret) {
                       if (ret.code == 0) {
                           $('#dg').datagrid('reload');
                       } else if (ret.code == 1) {
                           showOpFailMessage();
                       } else if (ret.code == 2) {
                           alertInfo('选择商品已存在');
                       }
                   });
           }
       });
   });
   
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'cardConsume/serviceProduct/delete.do',
               {providerId: row.providerId, serviceCode: SERVICE_PRODUCT_PPAGE_CONFIG['serviceCode'], productId: row.productId},
               function(ret){
                   showOpResultMessage(ret);
                   $('#dg').datagrid('reload');
           });
       });
   });

});
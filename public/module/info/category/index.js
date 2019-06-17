var formatters = {
    free: function(val, row) {
        return row.parentId ? (val ? '收费' : '免费') : '';
    }
}

$(function(){
   $('#add').click(function(){
       edit();
   });
   $('#update').click(function(){
       var row = $('#dg').treegrid('getSelected');
       if (!row.tag) {
          alertInfo('该级分类不能修改');
          return;
       }
       edit(true);
   });
   $('#delete').click(function(){
       var row = $('#dg').treegrid('getSelected');
       if(!row) return;
       if (!row.tag) {
          alertInfo('该级分类不能删除');
          return;
       }
       if (row.children.length) {
           alertInfo('该分类下有子分类,不能删除!');
           return;
       }
       openConfirmDialog('该分类有可能已被使用,确认删除?', function(){
           $.post(CONFIG.baseUrl + 'info/category/delete.do?id=' + row.id, function(ret){
               showOpResultMessage(ret);
               $('#dg').treegrid('reload');
           });
       });
    });
   
   function edit(update) {
       var url = 'info/category/form.do';
       var row = $('#dg').treegrid('getSelected')
       if (!row) return;
       
       if (update) {
           url += '?id=' + row.id;
       } else { // add
           url += "?parentId=" + (row ? row.id : 0);
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 500,
           height: 350,
           href: url,
           onSave: function() {
               formSubmit({
                   url: 'info/category/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dg').treegrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
});
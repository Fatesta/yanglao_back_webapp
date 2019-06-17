$(function(){
   $('#query').click(function(){
       $('#dgEvalInfo').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       edit(false);
   });
   $('#update').click(function(){
       var row = $('#dgEvalInfo').datagrid('getSelected');
       if (row.state == 0) {
           edit(true);
       } else {
           alertInfo('此状态不能修改');
       }
   });
   $('#publish').click(function(){
       var row = $('#dgEvalInfo').datagrid('getSelected');
       if (!row || row.state == 1) return;
       openConfirmDialog('确认发布?', function(){
           $.post(CONFIG.baseUrl + 'health/house/eval/evalInfo/publish.do', {id: row.id}, function(ret){
               showOpResultMessage(ret);
               $('#dgEvalInfo').datagrid('reload');
           });
       });
   });
   $('#close').click(function(){
       var row = $('#dgEvalInfo').datagrid('getSelected');
       if (!row || row.state == 2) return;
       openConfirmDialog('确认关闭?', function(){
           $.post(CONFIG.baseUrl + 'health/house/eval/evalInfo/close.do', {id: row.id}, function(ret){
               showOpResultMessage(ret);
               $('#dgEvalInfo').datagrid('reload');
           });
       });
   });
   $('#delete').click(function(){
       var row = $('#dgEvalInfo').datagrid('getSelected');
       if(!row) return;
       if (row.state != 0) {
           alertInfo('此状态不能删除');
           return;
       }
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'health/house/eval/evalInfo/delete.do?id=' + row.id, function(ret){
               showOpResultMessage(ret);
               $('#dgEvalInfo').datagrid('reload');
           });
       });
   });
   $('#manageQuestion').click(function(){
       var row = $('#dgEvalInfo').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab',
           'health/house/eval/question/index.do?_func_id=' + $(this).data('funcid') + '&evalId=' + row.id,
           '健康评估[' + row.title.substring(0, 8) + '] - 问题管理');
   });
   
   function edit(update) {
       var url = 'health/house/eval/evalInfo/form.do';
       if (update) {
           var row = $('#dgEvalInfo').datagrid('getSelected')
           if (!row)
               return;
           url += '?id=' + row.id;
       }
       
       var dlg = openEditDialog({
           title: '编辑评估',
           width: 400,
           height: 360,
           href: url,
           onLoad: function() {
               $('#imgUploadButton').click(function(){
                   openUploadImageDialog({
                       onSuccess: function(data) {
                           $('#img').attr('src', data.url);
                           $('[name=imgUrl]').val(data.url);
                       }
                   });
               });
           },
           onSave: function() {
               formSubmit({
                   url: 'health/house/eval/evalInfo/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dgEvalInfo').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
   
});

var formatters = {
    state: function(val) {
        return {0: '<span style="color:red">编辑中<span>',
                1: '<span style="color:green">已发布<span>',
                2: '<span style="color:gray">已关闭<span>'}[val];
    }
}
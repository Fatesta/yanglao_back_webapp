function onSelect(index, row) {
    $('#stat,#userAnswer')[row.state == 0 ? 'hide' : 'show']();
}

$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       edit(false);
   });
   $('#update').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (row.state == 0) {
           edit(true);
       } else {
           alertInfo('此状态不能修改');
       }
   });
   $('#publish').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (!row || row.state == 1) return;
       openConfirmDialog('确认发布?', function(){
           $.post(CONFIG.baseUrl + 'survey/surveyInfo/publish.do', {id: row.id, state: 1}, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   $('#close').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (!row || row.state == 2) return;
       openConfirmDialog('确认关闭?', function(){
           $.post(CONFIG.baseUrl + 'survey/surveyInfo/close.do', {id: row.id, state: 2}, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       if (row.state != 0) {
           alertInfo('此状态不能删除');
           return;
       }
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'survey/surveyInfo/delete.do?id=' + row.id, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   $('#manageQuestion').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab', 'view/survey/question/index.do?_func_id=' + $(this).data('funcid') + '&surveyId=' + row.id, '问卷[' + row.title + '] - 问题管理');
   });
   $('#userAnswer').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab', 'view/survey/userAnswer.do?_func_id=' + $(this).data('funcid') + '&surveyId=' + row.id, '问卷[' + row.title + '] - 用户答案');
   });
   $('#stat').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab', 'view/survey/stat/index.do?_func_id=' + $(this).data('funcid') + '&surveyId=' + row.id, '问卷[' + row.title + '] - 统计报告');
   });
   
   function edit(update) {
       var url = 'survey/surveyInfo/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;
           url += '?id=' + row.id;
       }
       
       var dlg = openEditDialog({
           title: '编辑问卷',
           width: 600,
           height: 340,
           href: url,
           onSave: function() {
               formSubmit({
                   url: 'survey/surveyInfo/save.do',
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

var formatters = {
    state: function(val) {
        return {0: '<span style="color:red">编辑中<span>',
                1: '<span style="color:green">已发布<span>',
                2: '<span style="color:gray">已关闭<span>'}[val];
    }
}
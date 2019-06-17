var QuestionOptionManager = function(questionManager){
   $('#tbrQuestionOption #add').click(function(){
       var ques = $('#dgQuestion').datagrid('getSelected');
       if (!ques || ques.type == 0) {
           return;
       }
       canModifyThen(function(){
           var params = {};
           params.questionId = ques.id;
           
           var url = 'view/health/house/eval/questionOption/form.do?' + $.param(params);
           var dlg = openEditDialog({
               title: '增加选择题选项',
               width: 500,
               height: 300,
               href: url,
               onSave: function() {
                   formSubmit({
                       url: 'health/house/eval/questionOption/save.do',
                       success: function(ret) {
                           if (ret.success) {
                               dlg.dialog('destroy');
                               $('#dgQuestionOption').datagrid('reload');
                           }
                           showOpResultMessage(ret);
                       }
                   });
               }
           });
       });
   });

   $('#tbrQuestionOption #delete').click(function(){
       var row = $('#dgQuestionOption').datagrid('getSelected');
       if(!row) return;
       canModifyThen(function(){
           openConfirmDeleteDialog(function(){
               $.post(CONFIG.baseUrl + 'health/house/eval/questionOption/delete.do?id=' + row.id, function(ret){
                   showOpResultMessage(ret);
                   $('#dgQuestionOption').datagrid('reload');
               });
           });
       });
   });

   var inited = false;
   function query(params) {
       if (!inited) {
           $('#dgQuestionOption').datagrid({
               url: CONFIG.baseUrl + 'health/house/eval/questionOption/page.do',
               queryParams: params,
               fit: true,
               rownumbers: false
           });
           inited = true;
       } else {
           $('#dgQuestionOption').datagrid("load", params);
       }
   }

   var expanded = false;
   // 当问题管理列表行被选择
   questionManager.signals.selected.add(function(index, row){
       if(row.type > 0) {
           if(! expanded) {
               $(document.body).layout('expand', 'south');
           }
           query({questionId: row.id});
           expanded = true;
       } else {
           $(document.body).layout('collapse', 'south');
           $('#dgQuestionOption').datagrid('clear');
           expanded = false;
       }
   });
   // 当问题管理列表加载
   questionManager.signals.loaded.add(function(){
       $('#dgQuestionOption').datagrid('clear');;
   });

}

function canModifyThen(contin) {
    if (PAGE_CONFIG['canModify']) {
        contin();
    } else {
        alertInfo('该评估处于不能修改状态');
    }
}
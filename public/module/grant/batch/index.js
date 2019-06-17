var formatters = {
    url: function(v, row) {
        return v ? UICommon.buttonHtml({text: '下载', icon: 'download', clickCode: 'location.href=\'' + v + '\''}) : '-';
    },
    state: function(v) {
        return {0: '待执行', 1: '已执行'}[v];
    }
};

$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       edit(false);
   });
   $('#update').click(function(){
       edit(true);
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row || row.state == 1) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'grant/batch/delete.do?batch=' + row.batch, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   
   $('#execute').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       if (row.state != 0) {
           alertInfo('不能重复执行');
           return;
       }
       openConfirmDialog("确认执行？", function(){
           $.post(CONFIG.baseUrl + 'grant/batch/execute.do?batch=' + row.batch, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
   });
   
   $('#downloadTemplate').click(function() {
       location.href = CONFIG.modulePath + 'grant/grant_template.xls';
   });
   
   $('#queryDetail').click(function() {
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openTab('mainTab', CONFIG.baseUrl + 'view/grant/accountIndex.do?batch=' + row.batch, '补助详情');
   });
   
   function edit(update) {
       var url = 'grant/batch/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected');
           if (!row)
               return;
           url += '?batch=' + row.batch;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 500,
           height: 320,
           href: url,
           onLoad: function() {
               $('#filebox').filebox({
                   onChange: function() {
                       $('#match').show();
                   }
               });
               
               $('#match').click(function() {
                   formSubmit({
                       notValidate: true,
                       url: 'grant/batch/match.do',
                       success: function(ret) {
                           var dlg = DialogManager.openSimpleDialog({
                               title: '匹配结果',
                               width: 240,
                               height: 180,
                               href: 'view/grant/batch/matchReport.do?' + $.param(ret),
                               onLoad: function() {
                                   dlg.find('[name=downloadFile]').click(function() {
                                       formSubmit({
                                           notValidate: true,
                                           url: 'grant/batch/downloadMatchResult.do?type=' + $(this).data('type')
                                       });
                                   });
                               }
                           });
                       }
                   });
               });
           },
           onSave: function() {
               var pad0 = function(n) { return n > 9 ? n : '0' + n; }
               $('[name=logDate]').val($('#logYear').numberspinner('getValue') + pad0($('#logMonth').numberspinner('getValue')));
               formSubmit({
                   url: 'grant/batch/save.do',
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
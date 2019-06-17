
var templateManager = (function(){
   $('#tbrServicePlanTemplate #query').click(function(){
       $('#dgServicePlanTemplate').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#tbrServicePlanTemplate #add').click(function(){
       edit(false);
   });
   $('#tbrServicePlanTemplate #update').click(function(){
       edit(true);
   });
   $('#tbrServicePlanTemplate #delete').click(function(){
       var row = $('#dgServicePlanTemplate').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'servicePlan/template/delete.do?tid=' + row.tid, function(ret){
               showOpResultMessage(ret);
               $('#dgServicePlanTemplate').datagrid('reload');
           });
       });
   });
   $('#tbrServicePlanTemplate #setState').click(function(){
       var row = $('#dgServicePlanTemplate').datagrid('getSelected');
       if (!row) return;
       if (row.state == 2) {//禁用后不能再启用
           return;
       }
       var toState = {0: 1, 1: 2, 2: 1}[row.state];
       
       $.post(CONFIG.baseUrl + 'servicePlan/template/save.do', {tid: row.tid, state: toState}, function(ret){
           showOpResultMessage(ret);
           $('#dgServicePlanTemplate').datagrid('reload');
       });
   });
   
   function edit(update) {
       var url = 'servicePlan/template/form.do';
       if (update) {
           var row = $('#dgServicePlanTemplate').datagrid('getSelected')
           if (!row)
               return;
           url += '?tid=' + row.tid;
       }
       
       var dlg = openEditDialog({
           title: '编辑计划模板基本信息',
           width: 550,
           height: 230,
           href: url,
           onSave: function() {
               formSubmit({
                   url: 'servicePlan/template/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dgServicePlanTemplate').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
   
   var signals = {
       selected: new Signal(),
       loaded: new Signal()
   };
   return {
       signals: signals,
       onSelect: function(_, row) {
           signals.selected.dispatch(row);
       },
       onLoadSuccess: function(data) {
           signals.loaded.dispatch(data);
       },
       formatters: {
           state: function(v) {
               return {0: '编辑中', 1: '启用', 2: '禁用'}[v];
           }
       }
   }
})();
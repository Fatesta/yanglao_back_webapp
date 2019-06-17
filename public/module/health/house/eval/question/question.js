var questionManager = (function(){
   var lastAction = null;

   $('#tbrQuestion #query').click(function(){
       query();
   });
   $('#tbrQuestion #add').click(function(){
       edit(false);
   });
   $('#tbrQuestion #update').click(function(){
       edit(true);
   });
   $('#tbrQuestion #delete').click(function(){
       canModifyThen(function(){
           var row = $('#dgQuestion').datagrid('getSelected');
           if(!row) return;
           openConfirmDeleteDialog(function(){
               var params = {evalId: PAGE_CONFIG['evalId'], id: row.id};
               $.post(CONFIG.baseUrl + 'health/house/eval/question/delete.do', params, function(ret){
                   if (ret.success) {
                       $('#dgQuestion').datagrid('reload');
                   }
                   showOpResultMessage(ret);
               });
               lastAction = 'delete';
           });
       });
   });
   
   $('#tbrQuestion #moveUp').click(function(){
       move(-1);
   });
   $('#tbrQuestion #moveDown').click(function(){
       move(+1);
   });
      
   function edit(update) {
       canModifyThen(function(){
           var params = {evalId: PAGE_CONFIG['evalId']};
           if (update) {
               var row = $('#dgQuestion').datagrid('getSelected')
               if (!row)
                   return;
               params.id = row.id;
           }
           var url = 'health/house/eval/question/form.do?' + $.param(params);
           var oldOrderno = null;//用以记录修改前序号
           var dlg = openEditDialog({
               title: (update ? '修改' : '增加') + '问题',
               width: 500,
               height: 300,
               href: url,
               onLoad: function(){
                 if (update) {
                     oldOrderno = $('#orderno').numberbox('getValue');
                 }
               },
               onSave: function() {
                   if (update) {
                       var nowOrderno = $('#orderno').numberbox('getValue');
                       $('[name=ordernoUpdate]').val(nowOrderno != oldOrderno);
                   }
                   formSubmit({
                       url: 'health/house/eval/question/save.do',
                       success: function(ret) {
                           if (ret.success) {
                               $('#dgQuestion').datagrid('reload');
                               dlg.dialog('destroy');
                           }
                           showOpResultMessage(ret);
                       }
                   });
                   lastAction = update ? 'update' : 'add';
               }
           });
       });
   }

   
   var inited = false;
   function query() {
       var params = $("#frmQuery").serializeObject();
       $.extend(params, {evalId: PAGE_CONFIG['evalId']});
       
       if (!inited) {
           $('#dgQuestion').datagrid({
               url: CONFIG.baseUrl + 'health/house/eval/question/page.do',
               queryParams: params,
               idField: 'id',
               pageList: [10, 20, 50],
               fit: true,
               fitColumns: true,
               rownumbers: false,
               onSelect: questionManager.signals.selected.dispatch,
               onLoadSuccess: function(page){
                   if (lastAction == 'add') {
                       $('#dgQuestion').datagrid('selectRow', page.rows.length - 1);
                   } else {
                       $('#dgQuestion').datagrid('unselectAll');
                   }
                   
                   questionManager.signals.loaded.dispatch();
               }
           });
           inited = true;
       } else {
           $('#dgQuestion').datagrid("load", params);
       }
   }
   
   var questionManager = {
       signals: {
           selected: new Signal(),
           loaded: new Signal()
       },
       query: query
   };

   return questionManager;
})();

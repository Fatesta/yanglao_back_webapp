$(function(){
   $('#add').click(function(){
       edit();
   });
   $('#update').click(function(){
       edit(true);
   });
   
   $('#setValid').click(function() {
       var row = $('#dg').datagrid('getSelected')
       if (!row) return;
       $.post(CONFIG.baseUrl + 'cardConsume/card/setValid.do', {cardId: row.cardId, isvalid: !row.isvalid}, function(ret) {
         if (ret.code == 0) {
             $('#dg').datagrid('reload');
         } else if (ret.code == 1) {
             showOpFailMessage();
         } else if (ret.code == 2) {
             alertInfo('未包含服务,不能启用');
         }
       });
   });
   
   $('#manageService').click(function() {
       var row = $('#dg').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab', 'view/cardConsume/cardService/index.do?cardId=' + row.cardId, '卡[' + row.cardName + '] - 服务管理');
   });
   
   function edit(update) {
       var url = 'cardConsume/card/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;
           url += '?cardId=' + row.cardId;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 700,
           heightFit: true,
           href: url,
           onLoad: function() {
             $('#cardTypeSelect').combobox({
                 onSelect: function(item) {
                     var val = item.value;
                     if (!val) return;
                     $('#coverImage').attr('src', val);
                     $('[name=coverImage]').val(val);
                 }
             });
             $('#uploadButton').click(function(){
               openUploadImageDialog({
                   onSuccess: function(data) {
                       $('#coverImage').attr('src', data.url);
                       $('[name=coverImage]').val(data.url);
                   }
               });
             });
             var val = $('#expirationDate').attr('value');
             $('#expirationDate').combobox({
                 valueField: 'days',
                 textField: 'text',
                 data: [
                   {days: 15, text: '15天'},
                   {days: 30, text: '1月(30天)'},
                   {days: 30*3, text: '3月'},
                   {days: 30*6, text: '6月'},
                   {days: 30*9, text: '9月'},
                   {days: 365, text: '1年(365天)'},
                   {days: 365*2, text: '2年'}
                 ],
                 value: val,
                 required:true,
                 editable: true
             });
           },
           onSave: function() {
               formSubmit({
                   url: 'cardConsume/card/save.do',
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
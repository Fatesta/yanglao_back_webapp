var formatters = {
    provAreaCity: function(_, row) {
        return [row.province, row.city, row.area].filter(function(s) { return s; }).join('-');
    },
    linkman: function(v, row) {
        return v + ' (' + {0: '女', 1: '男'}[row.sex] + ')';
    },
    flag: function(v) {
        return v ? UICommon.iconHtml('ok') : '';
    },
    isvalid: function(v) {
        return UICommon.iconHtml(v ? 'enable' : 'disable');
    }
}

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
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'user/address/delete.do?id=' + row.id, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('load');
           });
       });
   });
   $('#setDefault').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       $.post(CONFIG.baseUrl + 'user/address/setDefault.do?id=' + row.id + '&userId=' + row.userId, function(ret){
           showOpResultMessage(ret);
           $('#dg').datagrid('load');
       });
   });
   
   function edit(update) {
       var url = 'user/address/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;
           url += '?id=' + row.id;
       }
       
       var dlg = openEditDialog({
           title: '编辑收货地址',
           width: 540,
           height: 240,
           href: url,
           onLoad: function() {
               new CitySelect({
                   prov: "#province",
                   city: "#city",
                   dist: "#area",
                   valueField: "text",
                   textField: "text"
               });
               
               if (!update) {
                   $('[name=userId]').val(PAGE_CONFIG['userId']);
               }
           },
           onSave: function() {
               formSubmit({
                   url: 'user/address/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dg').datagrid('load');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
});
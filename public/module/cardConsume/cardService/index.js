$(function(){
   $('#add').click(function(){
       var url = 'view/cardConsume/cardService/add.do?cardId=' + PAGE_CONFIG['cardId'];
       var formAddDlg = openEditDialog({
           title: '增加服务',
           width: 500,
           height: 200,
           href: url,
           onLoad: function() {
               formAddDlg.find('#selectService').click(function() {
                   var dlg = openEditDialog({
                       title: '选择服务',
                       width: 800,
                       height: 400,
                       href: 'view/cardConsume/service/serviceDatagrid.do',
                       onSave: function(dlg) {
                           var sel = dlg.find('#dg').datagrid('getSelected');
                           formAddDlg.find('[name=serviceCode]').val(sel.serviceCode);
                           formAddDlg.find('#selected').text(sel.serviceName);
                           formAddDlg.find('#unit').text(sel.unit);
                           if (sel.categoryType == 1) {
                               formAddDlg.find('#chkLimitTimes').prop('checked', false).change();
                           } else {
                               formAddDlg.find('#chkLimitTimes').prop('checked', true).change();
                           }
                           dlg.dialog('destroy');
                       }
                   });
               });
               
               formAddDlg.find('#chkLimitTimes').change(function(){
                   formAddDlg.find('#times').numberbox('setValue', this.checked ? '' : -1);
               });
           },
           onSave: function(dlg) {
               if (!dlg.find('[name=serviceCode]').val())
                   return;
               if (!formAddDlg.find('#chkLimitTimes').attr('checked')) {
                   formAddDlg.find('#times').numberbox('setValue', '-1');
               }
               
               dlg.find('#form').form('submit', {
                   url: CONFIG.baseUrl + 'cardConsume/cardService/save.do',
                   success: function(ret) {
                       ret = JSON.parse(ret);
                       if (ret.code == 0) {
                           dlg.dialog('destroy');
                           $('#dg').datagrid('reload');
                       } else if (ret.code == 1) {
                           showOpFailMessage();
                       } else if (ret.code == 2) {
                           alertInfo('选择服务已存在');
                       }
                   }
               });
           }
       });
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'cardConsume/cardService/delete.do',
               {cardId: PAGE_CONFIG['cardId'], serviceCode: row.serviceCode},
               function(ret){
                   showOpResultMessage(ret);
                   $('#dg').datagrid('reload');
           });
       });
    });
});

var formatters = {
    times: function(val){
        return val == -1 ? '不限制' : val;
    }
}
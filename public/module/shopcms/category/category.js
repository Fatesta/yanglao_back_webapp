$(function(){
   $('#tbrCategory #add').click(function(){
       edit();
   });
   $('#tbrCategory #update').click(function(){
       edit(true);
   });
   
   function edit(isUpdate) {
       var row = $('#dgCategory').treegrid('getSelected');
       if (!row) return;
       var params = {};
       if (isUpdate) {
           if (row.categoryId <= 0) { //行业节点不能修改
               return;
           }
           params.categoryId = row.categoryId;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 400,
           height: 340,
           href: 'shopcms/category/form.do?' + $.param(params),
           onLoad: function() {
               if (!isUpdate) {
                   var cg = {};
                   if (row.categoryId <= 0) {
                       cg.industryId = row.industryId;
                       cg.parentId = -1;
                   } else {
                       cg.parentId = row.categoryId;
                   }
                   cg.level = row.level + 1;
                   cg.providerId = 0;
                   $('#form').form('load', cg);
               }
               
               $('#uploadButton').click(function(){
                   openUploadImageDialog({
                       onSuccess: function(data) {
                           $('#image').attr('src', data.url);
                           $('[name=pictureUrl]').val(data.url);
                       }
                   });
               });
           },
           onSave: function() {
               formSubmit({
                   url: 'shopcms/category/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dgCategory').treegrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
});

var formatters = {
    pictureUrl: function(val) {
        return val ? UICommon.datagrid.formatter.generators.image({height:40})(val) : '';
    }
}
$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   
   $(' #add').click(function(){
       edit();
   });
   $('#update').click(function(){
       edit(true);
   });
   $("#delete").click(function(){
       var rows = $("#dg").datagrid("getSelections");
       if(rows.length == 0)
           return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + "mbkf/classes/delete.do?" + $.arrayPickParam("ids", rows, "id"), function(ret){
               showOpResultMessage(ret);
               $("#dg").datagrid('reload');
           });
       });
    });

   $('#manageStudent').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row)
           return;
       openTab("mainTab", CONFIG.baseUrl + "view/health/mbkf/studentIndex.do?_func_id=" + $(this).data('id')  + "&classesId=" + row.id, String.format("班次[{0}] - 管理学员", row.className));
   });
   
   $('#manageCourse').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row)
           return;
       openTab("mainTab", CONFIG.baseUrl + "view/health/mbkf/courseIndex.do?_func_id=" + $(this).data('id')  + "&classesId=" + row.id, String.format("班次[{0}] - 管理课程", row.className));
   });
   
   $('#managePlan').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row)
           return;
       openTab("mainTab", CONFIG.baseUrl + "view/health/mbkf/classesLearningPlanIndex.do?_func_id=" + $(this).data('id')  + "&classesId=" + row.id, String.format("班次[{0}] - 管理学习计划", row.className));
   });
   $('#manageInfo').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row)
           return;
       openTab("mainTab", CONFIG.baseUrl + "view/health/mbkf/infoIndex.do?_func_id=" + $(this).data('id') + "&classesId=" + row.id, String.format("班次[{0}] - 管理课件", row.className));
   });
   
   
   function edit(update) {
       var url = 'mbkf/classes/classForm.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;	
           url += '?id=' + row.id;
       }
       

       var dlg = openEditDialog({
           title: '编辑',
           width: 550,
           height: 550,
           href: url,
           onLoad: function(){
               $('#updateImg').click(function(){
                   openUploadImageDialog({
                       onSuccess: function(data) {
                           $('#imgPro').attr('src', data.url);
                           $('[name=thumbnailUrl]').val(data.url);
                       }
                   });
                 });
           },
           onSave: function() {
               formSubmit({
                   url: 'mbkf/classes/save.do',
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
	    thumbnailUrl: function(value) {
	        return value ? '<img src="' + value  + '" height="60px"/>' : '<div class="empty-value-box-100">无</div>';
	    }
	};
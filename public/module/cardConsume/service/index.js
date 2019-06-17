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
   
   function edit(update) {
       var url = 'cardConsume/service/form.do';
       if (update) {
           var row = $('#dg').datagrid('getSelected')
           if (!row)
               return;
           url += '?serviceCode=' + row.serviceCode;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 660,
           height: 400,
           href: url,
           onLoad: function() {
               $('#categoryCode').combobox({
                   onSelect: function(item) {
                       if (item.categoryCode == 'product_service') {
                           $('#serviceDescTr td').hide();
                       } else {
                           $('#serviceDescTr td').show();
                       }
                   }
               });
           },
           onSave: function() {
               formSubmit({
                   url: 'cardConsume/service/save.do?update=' + update,
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

function serviceNameOnBlur() {
    $.post(CONFIG.baseUrl + 'cardConsume/service/serviceCodeByServiceName.do', {serviceName: this.value.trim()}, function(r){
        $('#serviceCode').textbox('setValue', r);
    });
}

function manageCourse(rowIndex) {
    var row = $('#dg').datagrid('getRows')[rowIndex];
    openTab('mainTab', 'view/cardConsume/course/index.do?serviceCode=' + row.serviceCode, '课程服务[' + row.serviceName + '] - 课程管理');
}

function manageProduct(rowIndex) {
    var row = $('#dg').datagrid('getRows')[rowIndex];
    var params = {serviceCode: row.serviceCode};
    openTab('mainTab', 'view/cardConsume/serviceProduct/index.do?' + $.param(params), '产品服务[' + row.serviceName + '] - 产品管理');
}

function manageProvider(rowIndex) {
    var row = $('#dg').datagrid('getRows')[rowIndex];
    var params = {serviceCode: row.serviceCode};
    openTab('mainTab', 'view/cardConsume/serviceProvider/index.do?' + $.param(params), '实体服务[' + row.serviceName + '] - 店铺管理');
}

var formatters = {
    op: function(value, row, rowIndex) {
        if (row.categoryCode == 'course_service') {
            return '<a href="#" class="easyui-linkbutton" onclick="manageCourse(' + rowIndex + ')" data-options="iconCls:\'icon-edit\'">管理课程</a>';
        } else if (row.categoryCode == 'product_service') {
            return '<a href="#" class="easyui-linkbutton" onclick="manageProduct(' + rowIndex + ')" data-options="iconCls:\'icon-edit\'">管理产品</a>';
        } else if (row.categoryCode == 'offline_service') {
            return '<a href="#" class="easyui-linkbutton" onclick="manageProvider(' + rowIndex + ')" data-options="iconCls:\'icon-edit\'">管理店铺</a>';
        }
    }
}
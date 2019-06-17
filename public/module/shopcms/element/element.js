function ElementManage(spec) {
   spec.preconds = spec.preconds || {};
   var parent = $(spec.parent);
   var fields;
   
   parent.find('#add').click(function(){
       if (spec.preconds.add && !spec.preconds.add())
           return;
       edit(false);
   });
   
   parent.find('#update').click(function(){
       edit(true);
   });
   
   parent.find('#delete').click(function(){
       var row = parent.find('#dgElement').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'shopcms/element/delete.do?elementId=' + row.elementId, function(ret){
               showOpResultMessage(ret);
               parent.find('#dgElement').datagrid('reload');
           });
       });
   });
   
   function edit(update) {
       var url = 'shopcms/element/form.do?isvalid=1&blockType=' + spec.blockType + '&pageLevel=' + spec.pageLevel;
       if (update) {
           var row = parent.find('#dgElement').datagrid('getSelected')
           if (!row)
               return;
           url += '&elementId=' + row.elementId;
       }
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 500,
           height: 440,
           href: url,
           onLoad: function() {
               $('#uploadButton').click(function(){
                   openUploadImageDialog({
                       onSuccess: function(data) {
                           $('#image').attr('src', data.url);
                           $('[name=elementUrl]').val(data.url);
                       }
                   });
               });
               
               var elementTypes = [{value: '1', text:'分类'}, {value:'8', text:'商品'}, {value:'9', text:'网页'}];
               if (spec.enableElementTypes) {
                   elementTypes = elementTypes.filter(function(item){
                       return spec.enableElementTypes.indexOf(+item.value) != -1;
                   });
               }
               $('#elementType').combobox({
                   disabled: update,
                   required: true,
                   editable:false, 
                   valueField:'value',
                   textField:'text',
                   data: elementTypes,
                   onSelect: function(item) {
                       $('#productSelectTr,#categorySelectTr,#urlTr').hide();
                       if (!update) {
                           $("[name=sourceResource]").val("");
                           $("[name=categoryId]").val("");
                       }
                       // 如果选择 分类类型
                       switch (+item.value) {
                       case ElementManage.elementType.category:
                           $("#categoryName").text("");
                           $("#url").textbox('setValue','');
                           $('#categorySelectTr').show();
                           break;
                       case ElementManage.elementType.product:
                           $("#productName").text("");
                           $("#url").textbox('setValue','');
                           $('#productSelectTr').show();
                           break;
                       case ElementManage.elementType.web:
                           $('#urlTr').show();
                           break;
                       }
                   }
               });
               
               var val = $('#elementType').combobox('getValue');
               $('#elementType').combobox('clear').combobox('select', val);
               
               // 选择商品点击事件
               $('#selectProduct').click(function() {
                   openProviderToProductSelectDialog({
                       onSubmit: function(product) {
                           if (!product) return;
                           $('#productName').text(product.name);
                           $('[name=sourceResource]').val(product.productId);
                       }
                   });
               });
               
               // 选择分类点击事件
               $('#selectCategory').click(function(){
                   var dialog = openEditDialog({
                       title: '选择分类',
                       width: $(document).width() - 200,
                       height: 600,
                       href: 'view/shopcms/category/categoryTreegrid.do',
                       onSave: function(selectProviderDialog) {
                           var category = $('#dg').datagrid('getSelected');
                           if (!category) {
                               alertInfo('请选择一个分类');
                               return;
                           }
                           $('#categoryName').text(category.name);
                           $("[name=categoryId]").val(category.categoryId);
                           
                           dialog.dialog('destroy');
                       }
                   });
               });
           },
           onSave: function() {
               // 验证输入
               switch (+$('#elementType').combobox('getValue')) {
               case ElementManage.elementType.category:
                   if (!$('[name=categoryId]').val()) {
                       return;
                   }
                   $("[name=sourceResource]").val("");
                   break;
               case ElementManage.elementType.product:
                   if (!$('[name=sourceResource]').val()) {
                       return;
                   }
                   $("[name=categoryId]").val("");
                   break;
               case ElementManage.elementType.web:
                   $("[name=sourceResource]").val($("#url").textbox('getValue') );
                   $("[name=categoryId]").val("");
                   break;
               }
               
               if (fields) {
                   $('#form').form('load', fields);
               }
               
               formSubmit({
                   url: 'shopcms/element/save.do',
                   notValidate: true,
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           parent.find('#dgElement').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
   
   var phase = 0;
   
   function query(queryParams) {
       queryParams = queryParams || {};
       $.extend(queryParams, {blockType: spec.blockType, pageLevel: spec.pageLevel});
       
       if(phase == 0) {
           parent.find('#dgElement').datagrid({
               data: [],
               fit: true,
               toolbar: parent.find('#tbrElement')
           });
           phase = 1;
       } else if (phase == 1) {
           parent.find('#dgElement').datagrid({
               url:  CONFIG.baseUrl + 'shopcms/element/page.do',
               queryParams: queryParams,
           });
           phase = 2;
       } else {
           parent.find('#dgElement').datagrid("load", queryParams);
       }
   }
   
   query();
   
   this.query = query;
   
   this.setFields = function(_fields) {
       fields = _fields;
   };
}

ElementManage.elementType = {
    category: 1,
    product: 8,
    web: 9
};
ElementManage.blockType = {
    lunbo: 1,
    guanggaowei: 2,
    categoryRecommend: 3
};
ElementManage.formatters = {
    elementType: function(val) {
        return {1: '分类', 8: '商品', 9: '网页'}[val];
    }
};
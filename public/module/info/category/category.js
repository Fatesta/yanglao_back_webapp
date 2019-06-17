function initCategorySelect(options) {
   var isUpdate = !!$('[name=id]').val();
   var cgCmbs = $('#category, #category2', options.toolbar || options.context || '#tbrInfo');

   $.get(CONFIG.baseUrl + 'info/category/tree.do', function(tree) {
       cgCmbs.each(function(cmbIndex) {
           $(this).combobox({
               required: options.required,
               valueField: 'id',
               textField: 'name',
               disabled: isUpdate,
               editable: false,
               onSelect: function (sel) {
                   if (cmbIndex == cgCmbs.length - 1)
                       return;
                   $(cgCmbs[cmbIndex + 1])
                       .combobox("disable")
                       .combobox("clear")
                       .combobox("loadData", []);
                   if (sel.children && sel.children.length)
                       $(cgCmbs[cmbIndex + 1])
                           .combobox("enable")
                           .combobox('loadData', sel.children);
               }
           });
           $(this).combobox('loadData', []);
       });
       
       if (options.hasNoselected) {
           tree.unshift({id: '', name: '全部'});
       }
       $(cgCmbs[0]).combobox('loadData', tree);
   });
}

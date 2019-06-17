/**
@param options
@param #frmCategory[form]
*/
function makeCategoryManager(options) {
    var that = {};
    
    options = options || {};
    
    var menuCategory = $("#menuCategory");
    var treeCategory = $("#treeCategory");
    
    that.query = function() {
        treeCategory.tree({
             url: CONFIG.baseUrl + "shop/product/categoryList.do?" + $.param(options.queryParams),
             onSelect: function(node) {
                 var nodeId = node.id == -1 ? '' : node.id;
                 $("#frmQueryProduct").form("load", {
                     categoryId: nodeId
                 });
                 options.onSelect(node);
             },
             loadFilter: function(data, parent) {
                 function toNodes(categorys) {
                     return categorys.map(function(cg){
                         return {
                             id: cg.categoryId,
                             text: cg.name,
                             state: "open",
                             children: cg.children ? toNodes(cg.children) : [],
                             attributes: cg
                         };
                     });
                 }
                 return [{
                     id: -1,
                     text: "全部",
                     state: "open",
                     children: toNodes(data)
                 }];
             },
             onLoadSuccess: function() {
                 $(this).tree("select", $(this).tree("getRoots")[0].target);
             },
             onContextMenu: function(e, node){
                 if(options.disableMenu)
                     return;
                 
                 e.preventDefault();
                 
                 // 计算节点层级
                 var level = -1;
                 for(var parent = node; parent != null; parent = $(this).tree("getParent", parent.target))
                     level++;
                                
                 var menuAddChild = menuCategory.menu('findItem', '增加子分类');
                 var menuUpdate = menuCategory.menu('findItem', '修改');
                 var menuDelete = menuCategory.menu('findItem', '删除');
     
                 if (level == 0) {
                     menuCategory.menu('enableItem', menuAddChild.target);
                     menuCategory.menu('disableItem', menuUpdate.target);
                     menuCategory.menu('disableItem', menuDelete.target);
                 } else if (node.attributes.isgeneral) {
                     menuCategory.menu('disableItem', menuAddChild.target);
                     menuCategory.menu('disableItem', menuUpdate.target);
                     menuCategory.menu('disableItem', menuDelete.target);
                 } else {
                     menuCategory.menu('disableItem', menuAddChild.target);
                     menuCategory.menu('enableItem', menuUpdate.target);
                     menuCategory.menu('enableItem', menuDelete.target);
                 }
     
                 $(this).tree('select', node.target);
                 menuCategory.menu('show', {
                     left: e.pageX,
                     top: e.pageY
                 });
             }
         });
     }
    
    $(function(){
        that.query();
        
        if(options.disableMenu)
            return;

        menuCategory.menu('appendItem', {
            text: '增加子分类',
            iconCls: 'icon-add',
            onclick: function(){
                var node = treeCategory.tree("getSelected");
                var incSort = node.children.length > 0 ?
                    Math.max.apply(null, node.children.map(function(node){ return node.attributes.sort || 0 })) + 1 : 1;
                editCategory({
                    parentId: node.id,
                    sort: incSort,
                    level: 1,
                    isbottom: 1});
            }
        });
        
        menuCategory.menu('appendItem', {
            text: '修改',
            iconCls: 'icon-edit',
            onclick: function(){
                var node = treeCategory.tree("getSelected");
                var incSort = node.children.length > 0 ?
                    Math.max.apply(null, node.children.map(function(node){ return node.attributes.sort || 0 })) + 1 : 1;
                editCategory({
                    categoryId: node.id,
                    sort: incSort,
                    level: 1});
            }
        });
        
        menuCategory.menu('appendItem', {
            text: '删除',
            iconCls: 'icon-delete',
            onclick: function(){
                var node = treeCategory.tree("getSelected");
                if(node.children.length > 0) {
                    showMessage("操作提示", "该分类下有子分类，不能删除");
                    return;
                }
                
                showConfirm("提示","您真的要删除该分类以及分类中的所有商品吗？", function(){
                    $.post(CONFIG.baseUrl + "shop/product/deleteCategory.do?", {categoryId: node.id}, function(ret){
                        showMessage("操作提示", ret.message);
                        treeCategory.tree('reload');
                        $("#dgProduct").datagrid("loadData", {total:0,rows:[]});
                    });
                });
            }
        });

    });
        
    function editCategory(params) {
        $.extend(params, options.queryParams);
        var dlg = openEditDialog({
            title: "编辑分类",
            width: 400,
            height: 340,
            href: "shop/product/frmCategory.do?" + $.param(params),
            onLoad: function() {
                $('#uploadButton').click(function(){
                    openUploadImageDialog({
                        onSuccess: function(data) {
                            $('#image').attr('src', data.url);
                            $('[name=pictureUrl]').val(data.url);
                        }
                    });
                });
            },
            onSave: function(){
                formSubmit("#frmCategory", {
                    url: "shop/product/saveCategory.do",
                    success:function(ret){
                        if (ret.success) {
                            dlg.dialog('close');
                            treeCategory.tree("reload");
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }
    
    return that;
}
    

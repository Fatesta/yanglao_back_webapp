var department = (function() {
    var tree = $("#departmentTree");
    var menu = $("#departmentMenu");
    
    var self = {};
    self.signals = {
        selected: new Signal(),
        loaded: new Signal()
    }

    tree.tree({
        url: CONFIG.baseUrl + "community/department/treeNodes.do?communityId=" + communityId,
        onSelect: function(node) {
            self.signals.selected.dispatch(node);
        },
        loadFilter: function(data) {
            return (function f(nodes){
                nodes.forEach(function(node) {
                    node.iconCls = 'icon-department';
                    f(node.children);
                });
                return nodes;
            })([{
                id: 0,
                text: "全部",
                state: "open",
                children: data
            }]);
        },
        onLoadSuccess: function() {
            self.signals.loaded.dispatch();
        },
        onContextMenu: function(e, node){
            e.preventDefault();
            
            // 计算节点层级
            var level = -1;
            for(var parent = node; parent != null; parent = $(this).tree("getParent", parent.target))
                level++;
                           
            var menuAddChild = menu.menu('findItem', '增加下级部门');
            var menuUpdate = menu.menu('findItem', '修改');
            var menuDelete = menu.menu('findItem', '删除');

            if (level == 0) {
                menu.menu('enableItem', menuAddChild.target);
                menu.menu('disableItem', menuUpdate.target);
                menu.menu('disableItem', menuDelete.target);
            } else if (level < 3) {
                menu.menu('enableItem', menuAddChild.target);
                menu.menu('enableItem', menuUpdate.target);
                menu.menu('enableItem', menuDelete.target);
            } else {
                menu.menu('disableItem', menuAddChild.target);
                menu.menu('enableItem', menuUpdate.target);
                menu.menu('enableItem', menuDelete.target);
            }

            $(this).tree('select', node.target);
            menu.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        }
    });

    $(function() {
        menu.menu('appendItem', {
            text: '增加下级部门',
            iconCls: 'icon-add',
            onclick: function(){
                var node = tree.tree("getSelected");
                edit({
                    parentId: node.id
                });
            }
        });
        
        menu.menu('appendItem', {
            text: '修改',
            iconCls: 'icon-edit',
            onclick: function(){
                var node = tree.tree("getSelected");
                edit({
                    id: node.id
                });
            }
        });
        
        menu.menu('appendItem', {
            text: '删除',
            iconCls: 'icon-delete',
            onclick: function(){
                var node = tree.tree("getSelected");
                
                showConfirm("提示","您真的要删除该部门吗？", function(){
                    $.post(CONFIG.baseUrl + "community/department/delete.do", {id: node.id}, function(retCode){
                        if (retCode == 0) {
                            showOpOkMessage();
                            tree.tree('reload');
                        } else if (retCode == 2) {
                            alertInfo("该分类下有下级部门，不能删除");
                        } else if (retCode == 3) {
                            alertInfo('该分类下有员工，不能删除');
                        }
                    });
                });
            }
        });
        
    });
        
    function edit(params) {
        var dlg = openEditDialog({
            width: 400,
            height: 200,
            title: "编辑部门",
            href: "community/department/form.do?" + $.param(params),
            onSave: function() {
                formSubmit("#communityDepartmentForm", {
                    url: "community/department/save.do",
                    success: function(ret) {
                        if (ret) {
                            dlg.dialog('destroy');
                            tree.tree("reload");
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }
    
    return self;
})();
    

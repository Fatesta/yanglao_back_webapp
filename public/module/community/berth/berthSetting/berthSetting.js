(function() {
    var placeTree = (function() {
        var tree = $("#treePlace");
        var lastSelectedNodeId = null;
        
        var self = {};
        self.signals = {
            selected: new Signal(),
            loaded: new Signal()
        }
    
        self.query = function() {
            reload();
        }

        reload();
        
        function reload() {
            $.get(CONFIG.baseUrl + "community/berth/berthSetting/trees.do", function(data) {
                tree.tree({
                    data: data,
                    onSelect: function(node) {
                        if (!node)
                            return;
                        lastSelectedNodeId = node.id;
                        loadChildren(node);
                        self.signals.selected.dispatch(node);
                    },
                    onExpand: function(node) {
                        loadChildren(node);
                    },
                    loadFilter: function(data) {
                        var root = {
                            id: 0,
                            text: "全部楼栋",
                            state: "open",
                            iconCls: 'icon-buildings',
                            type: 'root'
                        };
                        if (data.length == 0) {
                            return [root];
                        } else {
                            if (typeof data[0].buildingNo != 'undefined') {
                                root.children = data.map(function(building) {
                                    return {
                                        id: 'd' + building.id,
                                        text: building.buildingNo,
                                        state: "closed",
                                        iconCls: 'icon-building',
                                        type: 'building',
                                        data: building,
                                        children: building.floors.map(function(floor) {
                                            return {
                                                id: 'd' + building.id + 'f' + floor.floorNo,
                                                text: floor.floorNo + '层',
                                                state: floor.rooms.length == 0 ? "open" : "closed",
                                                iconCls: 'icon-floor',
                                                type: 'floor',
                                                data: floor,
                                                building: building,
                                                children: floor.rooms.map(function(room) {
                                                    return {
                                                        id: 'r' + room.id,
                                                        text: room.roomNo,
                                                        state: room.berthCount == 0 ? 'open' : "closed",
                                                        iconCls: 'icon-room',
                                                        type: 'room',
                                                        data: room,
                                                        children: room.berthCount == 0 ? null : [{
                                                            text: '等待加载...',
                                                            state: 'open',
                                                            iconCls: 'icon-blank'
                                                        }]
                                                    };
                                                })
                                            };
                                        })
                                    };
                                });
                                return [root];
                            } else {
                                return data;
                            }
                        }
                    },
                    onLoadSuccess: function() {
                        self.signals.loaded.dispatch();
                        if (lastSelectedNodeId) {
                            var node = tree.tree('find', lastSelectedNodeId);
                            if (node) {
                                tree.tree('select', node.target);
                                tree.tree('expandTo', node.target);
                                tree.tree('expand', node.target);
                            }
                        } else {
                            var node = tree.tree('find', 0);
                            if (node) {
                                tree.tree('select', node.target);
                            }
                        }
                    }
                });
            });

            function loadChildren(node) {
                if (node.type == 'room' && !node.loaded) {
                    $.get(CONFIG.baseUrl + 'community/berth/berthSetting/berth/treeNodes.do', {roomId: node.data.id}, function(arr) {
                        tree.tree('remove', tree.tree('getChildren', node.target)[0].target);
                        if (arr.length) {
                            tree.tree('append', {
                                parent: node.target,
                                data: arr.map(function(b) {
                                    var node = {
                                        id: 'b' + b.id,
                                        text: b.berthNo,
                                        iconCls: 'icon-berth',
                                        type: 'berth'
                                    };
                                    return node;
                                })
                            });
                        }
                        tree.tree('select', node.target);
                    });
                    node.loaded = true;
                }
            }
        }
        
        
        return self;
    })();

    var building = (function() {
        var self = {title: '楼栋'};
        var datagrid = $('#dgPlace');

        self.signals = {
            loaded: new Signal()
        }
        
        self.query = function() {
            var columns = [
                {field:'buildingNo',title:"楼栋编号",width:'140',halign:'center', align:'center'},  
                {field:'name',title:"楼栋名称",width:'200',halign:'center'},
                {field:'floorsNum',title:"楼层数量",width:'60',halign:'center', align:'center'}
            ];
            datagrid.datagrid({
                url: CONFIG.baseUrl + 'community/berth/berthSetting/building/page.do',
                columns: [columns]
            });
        }

        self.edit = function(isUpdate) {
            var url = 'community/berth/berthSetting/building/form.do';
            if (isUpdate) {
                var row = datagrid.datagrid('getSelected')
                if (!row) return;
                url += '?id=' + row.id;
            }
             
            var dlg = openEditDialog({
                width: 400,
                height: 200,
                href: url,
                title: '编辑楼栋信息',
                modal: true,
                onSave: function() {
                    formSubmit('#frmCommunityBuilding', {
                        url: 'community/berth/berthSetting/building/save.do',
                        success: function(ret) {
                            if (ret == 0) {
                                dlg.dialog('destroy');
                                self.signals.loaded.dispatch();
                                showOpOkMessage();
                            } else if (ret == 1) {
                                showOpFailMessage();
                            } else if (ret == 2) {
                                showOpFailMessage('楼栋编号已存在');
                            }
                        }
                    });
                }
            });
        }

        self.delete = function(row) {
            openConfirmDeleteDialog(function(){
                $.post(CONFIG.baseUrl + 'community/berth/berthSetting/building/delete.do?id=' + row.id, function(ret){
                    if (ret == 0) {
                        datagrid.datagrid('load');
                        self.signals.loaded.dispatch();
                        showOpOkMessage();
                    } else if (ret == 1) {
                        showOpFailMessage();
                    }  else if (ret == 2) {
                        showOpFailMessage('不能删除，因为已有房间关联');
                    }
                });
            });
        }
        
        return self;
    })();

    var floor = (function() {
        var self = {title: '楼层'};
        var datagrid = $('#dgPlace');

        self.signals = {
            loaded: new Signal()
        }
        
        self.query = function(queryParams) {
            var columns = [
                {field:'floorNo',title:"楼层编号",width:'140',halign:'center', align:'center'}
            ];
            var floors = [];
            for (var n = queryParams.floorsNum; n >= 1; n--) {
                floors.push({floorNo: n});
            }
            datagrid.datagrid({
                url: null,
                data: floors,
                columns: [columns]
            });
        }
        
        self.edit = function(isUpdate, parentInfo) {
            alertInfo('不能编辑');
        }
        
        self.delete = function(row) {
            alertInfo('不能删除，但可以编辑楼房楼层数');
        }

        return self;
    })();

    var room = (function() {
        var self = {title: '房间'};
        var datagrid = $('#dgPlace');

        self.signals = {
            loaded: new Signal()
        }
        
        self.query = function(queryParams) {
            var columns = [
                {field:'roomNo',title:"房间编号",width:'140',halign:'center', align:'center'},
                {field:'remark',title:"房间描述",width:'500',halign:'center',
                    formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgPlace', field: 'remark', min: 50})}
            ];
            datagrid.datagrid({
                url: CONFIG.baseUrl + 'community/berth/berthSetting/room/page.do',
                queryParams: queryParams,
                columns: [columns]
            });
        }
        
        self.edit = function(isUpdate, parentInfo) {
            var url = 'community/berth/berthSetting/room/form.do';
            if (isUpdate) {
                var row = datagrid.datagrid('getSelected')
                if (!row) return;
                url += '?id=' + row.id;
            }
             
            var dlg = openEditDialog({
                width: 400,
                height: 180,
                href: url,
                title: '编辑房间信息',
                modal: true,
                onLoad: function() {
                    $('#frmRoom [name=buildingId]').val(parentInfo.buildingId);
                    $('#frmRoom [name=floorNo]').val(parentInfo.floorNo);
                },
                onSave: function() {
                    formSubmit('#frmRoom', {
                        url: 'community/berth/berthSetting/room/save.do',
                        success: function(ret) {
                            if (ret == 0) {
                                dlg.dialog('destroy');
                                self.signals.loaded.dispatch();
                                showOpOkMessage();
                            } else if (ret == 1) {
                                showOpFailMessage();
                            } else if (ret == 2) {
                                showOpFailMessage('房间编号已存在');
                            }
                        }
                    });
                }
            });
        }
        
        self.delete = function(row) {
            openConfirmDeleteDialog(function(){
                $.post(CONFIG.baseUrl + 'community/berth/berthSetting/room/delete.do?id=' + row.id, function(ret){
                    if (ret == 0) {
                        datagrid.datagrid('load');
                        self.signals.loaded.dispatch();
                        showOpOkMessage();
                    } else if (ret == 1) {
                        showOpFailMessage();
                    } else if (ret == 2) {
                        showOpFailMessage('不能删除，因为已有床位关联');
                    }
                });
            });
        }

        return self;
    })();

    var berth = (function() {
        var self = {title: '床位'};
        var datagrid = $('#dgPlace');

        self.signals = {
            loaded: new Signal()
        }
        
        self.query = function(queryParams) {
            var columns = [
                {field:'berthNo',title:"床位编号",width:'140',halign:'center', align:'center'},
                {field:'berthTypeName',title:"床位类型",width:'150',halign:'center'}
            ];
            datagrid.datagrid({
                url: CONFIG.baseUrl + 'community/berth/berthSetting/berth/page.do',
                queryParams: queryParams,
                columns: [columns]
            });
        }
        
        self.edit = function(isUpdate, parentInfo) {
            var url = 'community/berth/berthSetting/berth/form.do';
            if (isUpdate) {
                var row = datagrid.datagrid('getSelected')
                if (!row) return;
                url += '?id=' + row.id;
            }
             
            var dlg = openEditDialog({
                width: 260,
                height: 160,
                href: url,
                title: '编辑床位信息',
                modal: true,
                onLoad: function() {
                    $('#frmBerth [name=roomId]').val(parentInfo.roomId);
                },
                onSave: function() {
                    formSubmit('#frmBerth', {
                        url: 'community/berth/berthSetting/berth/save.do',
                        success: function(ret) {
                            if (ret == 0) {
                                dlg.dialog('destroy');
                                self.signals.loaded.dispatch();
                                showOpOkMessage();
                            } else if (ret == 1) {
                                showOpFailMessage();
                            } else if (ret == 2) {
                                showOpFailMessage('床位编号已存在');
                            } else if (ret == 3) {
                                showOpFailMessage('不能修改该床位的床位类型，因为当前有入住者');
                            }
                        }
                    });
                }
            });
        }
        
        self.delete = function(row) {
            openConfirmDeleteDialog(function(){
                $.post(CONFIG.baseUrl + 'community/berth/berthSetting/berth/delete.do?id=' + row.id, function(ret){
                    if (ret == 0) {
                        datagrid.datagrid('load');
                        self.signals.loaded.dispatch();
                        showOpOkMessage();
                    } else if (ret == 1) {
                        showOpFailMessage();
                    } else if (ret == 2) {
                        showOpFailMessage('不能删除，因为当前有入住者');
                    }
                });
            });
        }

        return self;
    })();

    placeTree.signals.selected.add(function(node) {
        $('#tbrPlace .easyui-linkbutton').each(function() {
            $(this).linkbutton({disabled: true, text: ''}).unbind('click');
        });

        var module = null;
        var parentInfo;
        if (node.type == 'root') {
            building.query();
            module = building;
        } else if (node.type == 'building') {
            floor.query({floorsNum: node.data.floorsNum});
            module = floor;
        }  else if (node.type == 'floor') {
            parentInfo = {buildingId: node.building.id, floorNo: node.data.floorNo};
            room.query(parentInfo);
            module = room;
        } else if (node.type == 'room') {
            parentInfo = {roomId: node.data.id}
            berth.query(parentInfo);
            module = berth;
        } else {
            $('#dgPlace').datagrid({url: null, columns: [], data: []});
        }

        if (module == floor) {
            
        } else if (module) {
            $('#tbrPlace .easyui-linkbutton').each(function() {
                $(this).linkbutton('enable');
            });
            $('#tbrPlace [name=add]').linkbutton({text: '增加' + module.title}).click(function(){
                module.edit(false, parentInfo);
            });
    
            $('#tbrPlace [name=update]').linkbutton({text: '修改' + module.title}).click(function(){
                module.edit(true);
            });
            
            $('#tbrPlace [name=delete]').linkbutton({text: '删除' + module.title}).click(function(){
                var row = $('#dgPlace').datagrid('getSelected');
                if(!row) return;
                module.delete(row);
            });
        }
        
        var paths = [];
        var parent = node;
        while (parent) {
            paths.unshift(parent.text);
            parent = $('#treePlace').tree('getParent', parent.target);
        }

        var title = '';
        if (paths.length == 1) {
            title = paths[0];
        } else {
            paths = paths.slice(1);
            if (module) {
                paths.push('所有' + module.title)
            }
            title = paths.join(' > ');
        }
        $('#panelPlace').panel('setTitle', title);
    });
    
    [building, floor, room, berth].forEach(function(module) {
        module.signals.loaded.add(function() {
            placeTree.query();
        });
    });
    

})();
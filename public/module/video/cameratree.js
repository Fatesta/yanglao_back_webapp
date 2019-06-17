/*
视频监控左侧树
author: hu lang
*/
var CameraTree = function() {
    var tree = $("#tree");
    
    tree.signals = {
        selected: new Signal() // 声明选中摄像头信息节点信号
    };
    
    tree.setVideoCtrl = function(videoCtrl) {
        videoCtrl.signals.failed.add(function(node){
            node.status = 'failed';
            setStatusIcon(node);
        });
        videoCtrl.signals.played.add(function(node){
            node.status = 'played';
            setStatusIcon(node);
        });
        videoCtrl.signals.stoped.add(function(node){
            node.status = 'stoped';
            setStatusIcon(node);
        });
    }
    
    // 初始化树
    tree.tree({
        url: CONFIG.baseUrl + 'org/listOrg.do',
        loadFilter: function(nodes) {
            (function f(nodes) {
                nodes && nodes.forEach(function(node) {
                    if (!node.iconCls) {
                        node.iconCls = node.isCommunity ? 'icon-community' : 'icon-org';
                        f(node.children);
                    }
                });
            })(nodes);
            return nodes;
        },
        onSelect: function(node) {
            load(node);
        },
        onDblClick: function(node) {
            if(node.hasOwnProperty('attributes')) {
                if(node.attributes.type == 1 || node.attributes.deviceSerial || node.attributes.hasOwnProperty('nodeno')) {                    
                    tree.signals.selected.dispatch(node, tree.tree('getParent', node.target));
                }
            }
                
        },
        onBeforeExpand: function(node){
            load(node);
            return true;
        }
    });
    
    function setStatusIcon(node) {
        var icons = $(node.target).find("span.tree-icon");
        switch(node.status) {
        case 'start':
            $(icons[0]).removeClass('icon-no icon-look').addClass("icon-start-view");
            break;
        case 'played':
            $(icons[0]).removeClass('icon-start-view icon-no').addClass("icon-look");
            break;
        case 'stoped':
            $(icons[0]).removeClass('icon-start-view icon-look icon-no');
            break;
        case 'failed':
            $(icons[0]).removeClass('icon-start-view icon-look').addClass("icon-no");
            break;
        }
    }
    
    // 懒加载数据
    function load(node) {
        if(node.loaded || node.id == 0)
            return false;
        
        // 如果点击了社区节点，加载社区的摄像头
        if(tree.tree('isLeaf', node.target) && !node.hasOwnProperty('attributes')) {
            node.loaded = true; // 标记为已加载
            $.get(CONFIG.baseUrl + '/orgcamera/list.do', {orgId: node.id}, function(page) {
                var treeData = page.rows.map(function(r) {
                    var node = {
                        id: r.id,
                        text: r.note,
                        iconCls: 'icon-camera',
                        attributes: r
                    };
                    // 如果是多路的，设置state以显示非叶子节点
                    if(r.type == 2) {
                        node.state = 'closed';
                        node.children = [ {id: 0, text: '(空)'} ]
                    }
                    return node;
                });
                tree.tree('append', {
                    parent: node.target,
                    data: treeData
                });
            });
        }
        // 如果点击了多路摄像头节点，加载多路节点
        else if(node.hasOwnProperty('attributes') && node.attributes.type == 2) {
            node.loaded = true;
            $.get(CONFIG.baseUrl + '/orgcamera/node/list.do', {cameraId: node.id}, function(page) {
                var treeData = page.rows.map(function(r) {
                    var node = {
                        id: r.id,
                        text: r.note,
                        iconCls: 'icon-camera',
                        attributes: r
                    };
                    return node;
                });
                // 判断如果有数据，替换空
                if(treeData.length > 0) {
                    tree.tree('remove', tree.tree('getChildren', node.target)[0].target);
                    tree.tree('append', {
                        parent: node.target,
                        data: treeData
                    });
                }
            });
        }
    }
    
    return tree;
}
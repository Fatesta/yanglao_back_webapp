var dgOrgCamera = (function(){
    var dg = $('#dgOrgCamera');
    
    var signals;
    dg.signals = signals = {
        selected: new Signal(),
        loaded: new Signal()
    };
    
    $('#tbrDgOrgCamera [name=query]').click(function(){
        query();
    });
    
    $("#tbrDgOrgCamera [name=add]").click(function(){
        edit();
    });
    
    $("#tbrDgOrgCamera [name=update]").click(function(){
        var row = dg.datagrid('getSelected');
        if(row)
            edit(row.id);
    });
    
    $("#tbrDgOrgCamera [name=delete]").click(function(){
        var row = dg.datagrid("getSelected");
        if(!row)
            return;
        showConfirm("提示","您真的要删除吗？", function(){
            $.post(CONFIG.baseUrl + "orgcamera/delete.do?", {id: row.id}, function(ret){
                showMessage("操作提示", ret.message);
                dg.datagrid('reload');
            });
        });
    });
    
    var orgCameraDgInited = false;

    function query() {
        var params = $("#frmQuery").serializeObject();
        
        if(!orgCameraDgInited) {
            dg.datagrid({
                url: CONFIG.baseUrl + 'orgcamera/list.do',
                queryParams: params,
                onSelect: signals.selected.dispatch,
                onLoadSuccess: signals.loaded.dispatch
            });
            orgCameraDgInited = true;
        } else {
            dg.datagrid("load", params);
        }
    }
    
    function edit(id) {
        var params = _.pick(PAGE_CONFIG, 'orgId');
        if(id)  params.id = id;
        var dlg = openEditDialog({
            title: "摄像头配置",
            width: 360,
            height: 200,
            href: "orgcamera/frm.do?" + $.param(params),
            onSave: function(){
                submitForm("frmOrgCameraConfig", CONFIG.baseUrl + "orgcamera/save.do", function(data){
                    data = JSON.parse(data);
                    if (data.success) {
                        showMessage("操作提示", "操作成功");
                        dlg.dialog('close');
                        dg.datagrid('reload');
                    } else {
                        showAlert("错误提示", data.message, "warning");
                    }
                    
                });
            }
        });
    }
    
    query();
    
    return dg;
})();

var dgMutilCameraNode = (function(/*dgOrgCamera*/) {
    var dg = $("#dgMutilCameraNode");
    
    $('#tbrDgMutilCameraNode [name=get]').click(function(){
        var button = this;
        if($(button).linkbutton('options').disabled)
            return;
        $(button).linkbutton('disable');
        var enableButton = function() { $(button).linkbutton('enable', false); };
        
        var cameraCfg = dgOrgCamera.datagrid('getSelected');
        if(!(cameraCfg && cameraCfg.type == 2))
            return;
        
        if(!WebVideoCtrl.initialized) {
            $('<div id="videoContainer"></div>').appendTo(document.body);
            // 初始化插件
            WebVideoCtrl.I_InitPlugin("0%", "0%", {
                szContainerID: "videoContainer",
                iWndowType: 1
            });
            WebVideoCtrl.I_InsertOBJECTPlugin("videoContainer");
            WebVideoCtrl.initialized = true;
        }
        
        // 获取设备IP
        if(cameraCfg.ip) {
        } else {
            if(cameraCfg.cameraNo) {
                var ipInfo = WebVideoCtrl.I_GetIPInfoByMode(2, "www.hiddns.com", 80, cameraCfg.cameraNo);
                if (ipInfo) {
                    cameraCfg.ip = ipInfo.split("-")[0];
                } else {
                    enableButton();
                    alert("自动获取失败，原因：根据设备序列号获取设备IP失败！");
                    return;
                }
            } else {
                enableButton();
                alert("请先填写设备序列号或和设备IP");
                return;
            }
        }
        
        function login(success) {
            var iRet = WebVideoCtrl.I_Login(cameraCfg.ip, 1, cameraCfg.port, cameraCfg.username, cameraCfg.password, {
                success: function (xmlDoc) {
                    setTimeout(function () {
                        success && success();
                    }, 10);
                },
                error: function () {
                    enableButton();
                    alert("登录失败！");
                }
            });
            if(iRet == -1) {
                success && success();
            }
        }
        
        login(function(){
            // 根据设备IP获取数字通道
            WebVideoCtrl.I_GetDigitalChannelInfo(cameraCfg.ip, {
                async: true,
                success: function (xmlDoc) {
                    // 转换为mutilCameraNode数组
                    var channels = [];
                    $(xmlDoc).find("InputProxyChannelStatus").each(function() {
                        var id = $(this).find("id").text();
                        var name = $(this).find("name").text();
                        var online = $(this).find("online").text() == "true";
                        var ipaddress = $(this).find("ipAddress").text();
                        name = name || ("摄像头" + id);
                        channels.push({cameraId: cameraCfg.id, ip: ipaddress, nodeno: id, desc: name});
                    });
                    // JSON化并提交
                    $.ajax({
                        type: 'post',
                        url: CONFIG.baseUrl + "orgcamera/node/add_list.do",
                        data: JSON.stringify(channels),
                        contentType: 'application/json',
                        dataType: 'json',
                        success: function(ret) {
                            enableButton();
                            showMessage("操作提示", ret.message);
                            dg.datagrid('reload');
                        }
                    });
                },
                error: function() {
                    enableButton();
                    alert("自动获取失败，原因：获取数字通道失败！");
                }
            });
        });
        
    });
    
    $('#tbrDgMutilCameraNode [name=query]').click(function(){
        query();
    });
    
    $("#tbrDgMutilCameraNode [name=add]").click(function(){
        var row = dgOrgCamera.datagrid('getSelected');
        if(row && row.type == 2)
            edit();
    });
    
    $("#tbrDgMutilCameraNode [name=update]").click(function(){
        var row = dg.datagrid('getSelected');
        if(row)
            edit(row.id);
    });
    
    $("#tbrDgMutilCameraNode [name=delete]").click(function(){
        var rows = dg.datagrid("getSelections");
        if(!rows)
            return;
        showConfirm("提示","您真的要删除吗？", function(){
            rows.forEach(function(row, index){
                $.post(CONFIG.baseUrl + "orgcamera/node/delete.do?", {id: row.id}, function(ret){
                    if(index == rows.length - 1) {
                        showMessage("操作提示", ret.message);
                        dg.datagrid('reload');
                    }
                });
            });
        });
    });
    
    function query(cameraId) {
        var params = $("#tbrDgMutilCameraNode #frmQuery").serializeObject();
        params.cameraId = cameraId;
        if(dg.datagrid("options").url == null) {
            dg.datagrid({
                url: CONFIG.baseUrl + 'orgcamera/node/list.do',
                queryParams: params,
                pageSize: 10,
                pageList: [5, 10, 20],
                fit: true,
                fitColumns: true,
                singleSelect: false
            });
        } else {
            dg.datagrid("load", params);
        }
    }
    
    function edit(id) {
        var params = _.pick(PAGE_CONFIG, 'orgId');
        if(id)  params.id = id;
        var url = CONFIG.baseUrl + "orgcamera/node/frm.do?" + $.param(params);
        var dlg = $("#dlg").dialog({
            title: "设备摄像头配置信息",
            width: 450,
            height: 350,
            closed: false,
            cache: false,
            href: url,
            buttons:[{
                text:"提交",
                iconCls:"icon-save",
                handler:function(){
                    $("#frmMutilCameraNode [name=cameraId]").val(dgOrgCamera.datagrid('getSelected').id);
                    submitForm("frmMutilCameraNode", CONFIG.baseUrl + "orgcamera/node/save.do", function(data){
                        data = JSON.parse(data);
                        if (data.success) {
                            showMessage("操作提示", "操作成功");
                            dlg.dialog('close');
                            dg.datagrid('reload');
                        } else {
                            showAlert("错误提示", data.message, "warning");
                        }
                        
                    });
                }
            },{
                text:"取消",
                iconCls:'icon-cancel',
                handler:function(){
                    dlg.dialog('close');    
                }
            }],
            modal: true
        });
    }

    dgOrgCamera.signals.selected.add(function(rowIndex, rowData){
        if(rowData.type == 2) {//多路摄像头
            if(! dg.expanded) {
                $(document.body).layout('expand', 'south');
            }
            query(rowData.id);
            dg.expanded = true;
        } else {
            $(document.body).layout('collapse', 'south');
            dg.datagrid('clear');
            dg.expanded = false;
        }
    });
    
    dgOrgCamera.signals.loaded.add(function(){
        dg.datagrid('clear');
    });
})();

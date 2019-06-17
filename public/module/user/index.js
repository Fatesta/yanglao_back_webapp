define(function() {
    var datagrid;
    var toolbar;
    var options = {
        functions: [
            {
                code: 'user.query',
                onClick: function() {
                    datagrid.datagrid("load", handleUserQueryParams());
                }
            },{
                code: 'user.resetQuery',
                onClick: function() {
                    $(".filter").each(function(){
                        $(this).textbox("clear");
                    });
                }
            },{
                code: 'user.add',
                onClick: function() {
                    var dlg = openEditDialog({
                        width: 440,
                        height: 560,
                        title: "注册用户",
                        href: "user/showRegistUserForm.do",
                        onLoad: function() {
                            $('#registUserForm #userType').comboboxFromDict({
                                dict: DictMan.items('user.type').filter(function(item) { return [1, 2, 3, 9].includes(+item.value)}),
                                enableEmptyItem: false,
                                defaultValue: '',
                                onSelect: function(item) {
                                    $('#trCardCode, #trPassword, #trDeviceCode').hide();
                                    $('#cardCode, #password, #repassword, #deviceCode').textbox('setValue', '').textbox({required: false, disabled: true});
                                    var userType = +item.value;
                                    switch (userType) {
                                    case 1:
                                        $('#password, #repassword').textbox({required: true, disabled: false});
                                        $('#trPassword').show();
                                        break;
                                    case 2:
                                        $('#cardCode').textbox({required: true, disabled: false});
                                        $('#trCardCode').show();
                                        break;
                                    case 9:
                                        $('#deviceCode').textbox({required: true, disabled: false});
                                        $('#trDeviceCode').show();
                                        break;
                                    }
                                    $('#telephone', dlg).textbox({required: telphoneIsRequired(userType)});
                                    $.fn[imageIsOptional(userType) ? 'show' : 'hide'].call($('[name=imageTr]'));
                                }
                            });
   
                            $("#uploadButton", dlg).click(function(){
                                openUploadImageDialog({
                                    onSuccess: function(data) {
                                        $("#headImg", dlg).attr("src", data.url);
                                        $("[name=imagePath]", dlg).val(data.url);
                                    }
                                });
                            });
                        },
                        onSave: function(){
                            var valid = $("#registUserForm").form("validate");
                            if (!valid) {
                                return false;
                            }
                            
                            var user = $("#registUserForm").serializeObject();
                            $.post(CONFIG.baseUrl + "user/registUser.do", user, function(ret){
                                if (ret.success) {
                                    dlg.dialog("close");
                                    datagrid.datagrid("load");
                                }
                                showOpResultMessage(ret);
                            });
                        }
                    });
                }
            },{
                code: 'user.update',
                onClick: function(user) {
                    var form;
                    var href;
                    if (user.userType == 9) {
                        form = '#deviceForm';
                        href = "device/showEditDeviceForm.do?deviceId=" + user.userId;
                    } else {
                        form = '#userForm';
                        href = "user/showUserForm.do?userId=" + user.userId;
                    }
                    var dlg = openEditDialog({ 
                        title: "编辑用户",
                        width: 440,
                        height: 560,
                        href: href,
                        onLoad: function() {
                            $("#uploadButton", dlg).click(function(){
                                openUploadImageDialog({
                                    onSuccess: function(data) {
                                        $("#headImg", dlg).attr("src", data.url);
                                        $("[name=imagePath]", dlg).val(data.url);
                                    }
                                });
                            });
                            var userType = $('[name=userType]', dlg).val()
                            $('#telephone', dlg).textbox({required: telphoneIsRequired(userType)});
                            $.fn[imageIsOptional(userType) ? 'show' : 'hide'].call($('[name=imageTr]'));
                        },
                        onSave: function(){
                            var valid = $(form).form("validate");
                            if (!valid) {
                                return false;
                            }
                            
                            var userForm = $(form).serializeObject();
                            userForm.userType = user.userType;
                            $.post(CONFIG.baseUrl + "user/updateUser.do", userForm, function(ret){
                                if (ret.success) {
                                    dlg.dialog("close");
                                    datagrid.datagrid("load");
                                }
                                showOpResultMessage(ret);
                            });
                        }
                    });
                }
            },{
                code: 'user.care',
                onClick: function(user) {
                    showCareGrid(datagrid.datagrid('getRowIndex', user));
                }
            },{
                code: 'user.safe',
                onClick: function(user) {
                    showSafePositions(datagrid.datagrid('getRowIndex', user));
                }
            }
        ]
    };
    
    function handleUserQueryParams() {
        var qparams = toolbar.find('#searchUser').serializeObject();
        if (qparams.cardCode) {
            $('[comboname=userType]').combobox('setValue', 2);
            qparams.userType = 2;
        }
        if (qparams.deviceCode) {
            $('[comboname=userType]').combobox('setValue', 9);
            qparams.userType = 9;
        }
        if (qparams.userType == 9) {
            datagrid.datagrid('hideColumn', 'cardCode');
            datagrid.datagrid('showColumn', 'deviceCode');
        } else if (qparams.userType == 2) {
            datagrid.datagrid('showColumn', 'cardCode');
            datagrid.datagrid('hideColumn', 'deviceCode');
        } else {
            datagrid.datagrid('hideColumn', 'cardCode');
            datagrid.datagrid('hideColumn', 'deviceCode');
        }
        
        return qparams;
    }
    
    function telphoneIsRequired(userType) {
        return [0, 1].includes(+userType);
    }
    function imageIsOptional(userType) {
        return [0, 1].includes(+userType);
    }

    return function(viewType) {
        toolbar = $('#userGridToolbar' + viewType);
        datagrid = $('#userGrid' + viewType);

        var userTypes = [0, 1, 2, 9];       //限制用户类型们
        var allOptionValue = -1;//表示 全部 的值;
        switch (+viewType) {
        case 0:
            break;
        case 1://关爱设置
            userTypes = [1, 9];
            allOptionValue = -3;
            break;
        case 2:
            userTypes = [1,9];
            allOptionValue = -3;
            break;
            break;
        }

        datagrid.datagrid({
            url: CONFIG.baseUrl + 'user/listUser.do',
            queryParams: {userType: allOptionValue},
            onSelect: function(i, user) {
                //特定用户类型特有的功能表
                var userTypeFuncCodeMap = {
                    0: ['user-resetPwd'],
                    1: ['user-resetPwd'],
                    2: ['changeCard'],
                    9: ['device-update','device-changeDeviceCode','device-powerOff','device-cancel','device-remoteCall','device-detail']
                }
                _.flatten(_.values(userTypeFuncCodeMap)).forEach(function(id) {
                    $('#' + id).hide();
                });
                userTypeFuncCodeMap[user.userType].forEach(function(id) {
                    $('#' + id).show();
                });
            }
        });
        
        options.datagrid = datagrid;
        toolbar.find('[comboname=userType]').comboboxFromDict({
            dict: DictMan.items('user.type').filter(function(t) { return userTypes.includes(+t.value) }),
            emptyItem: new DictItem(allOptionValue, '全部'),
            value: allOptionValue,
            onSelect: function(item) {
                var userType = +item.value;
                switch (userType) {
                case -1:
                case 0:
                case 1:
                    $('[textboxname=deviceCode]').textbox('clear');
                    $('[textboxname=cardCode]').textbox('clear');
                    break;
                case 2:
                    $('[textboxname=deviceCode]').textbox('clear');
                    break;
                case 9:
                    $('[textboxname=cardCode]').textbox('clear');
                    break;
                }
            }
        });
        var lastQueryParams = {};
        new DatagridToolbarFunctions(options);
        initUserQuerier($('#userQuerier', toolbar), '#searchUser', datagrid, function(params) {
            lastQueryParams = params;
        });
        
        $('#user-cancel').click(function(){
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            openConfirmDialog('确认注销?', function(){
                post(CONFIG.baseUrl + "user/cancelUser.do", {userType: user.userType, userId: user.userId}, function(data){
                    if (data.success) {
                        showMessage("操作提示", data.message);
                        datagrid.datagrid("reload");
                    } else {
                        showAlert("操作提示", data.message);
                    }
                }, "json");
            });
        });
        
        $('#user-resetPwd').click(function(){
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            showConfirm("确认操作", "确认重置密码！", function(){
                post(CONFIG.baseUrl + "user/resetPassword.do", {userId: user.userId}, function(data){
                    datagrid.datagrid("load");
                    showMessage('系统提示', data.message);
                });
            });
        });
        
        $('#user-purse').click(function(){
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            openTab("mainTab", "view/user/purse/index.do?userId=" + user.userId + '&deviceCode=' + user.deviceCode + '&userType=' + user.userType,
                "用户[" + user.aliasName + "] - 钱包");
        });
        
        $('#device-detail').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            openTab("mainTab", CONFIG.baseUrl + "device/showDeviceDetail.do?_func_code=device-detail&deviceId=" + user.userId, "设备明细");
        });
        
        $('#device-add').click(function() {
            var dlg = openEditDialog({
                title: "注册设备用户",
                width: 580,
                height: 250,
                href: "device/showAddDeviceForm.do",
                onSave:function(){
                    submitForm("deviceForm", CONFIG.baseUrl + "device/addDevice.do", function(data){
                        data = str2Json(data);
                        if (data.success) {
                            datagrid.datagrid("load");
                            showMessage("操作提示", "操作成功");
                        } else {
                            showAlert("错误提示", data.message, "warning");
                        }
                        dlg.dialog("close");
                    });
                }
            });
        });
        
        $('#device-remoteCall').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            var dlg = openEditDialog({
                title: "代理拨号",
                width: 260,
                height: 150,
                href: "device/showRemoteCallForm.do?deviceCode=" + user.deviceCode,
                onSave: function(){
                    var isValid = $("#callForm").form('validate');
                    if (!isValid){
                        return false;
                    }
                    
                    var arr = $("#callForm").serializeArray();
                    var params = {};
                    $.each(arr, function(idx, val){
                        var value = val.value;
                        if (val.name == "name") {
                            value = Base64.encode(value, true);
                        }
                        params[val.name] = value;
                    });
                    
                    post(CONFIG.baseUrl + "device/remoteCall.do", {json:$.objToStr(params)}, function(data){
                        if (data.success) {
                            dlg.dialog("close");
                            showMessage('系统提示', data.message);
                        } else {
                            showAlert("错误提示",data.message,'error');
                        }
                    }, "json");
                }
            });
        });
        $('#device-changeDeviceCode').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            $.messager.confirmInput("更换设备号", "请输入新的设备号：", function(okBtn, input){
                if (okBtn) {
                    post(CONFIG.baseUrl + "device/changeDeviceCode.do", {deviceCode:input,oldDeviceId:user.userId,oldDeviceCode:user.deviceCode}, function(data){
                        if (data.success) {
                            showMessage("操作提示", "操作成功");
                        } else {
                            showAlert("操作提示", data.message, "warning");
                        }
                    }, "json");
                }
            }, {required:true});
        });
        
        $('#device-powerOff').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            showConfirm("确认操作", "确认关机", function(){
                var json = "{\"deviceId\":\"" + user.userId + "\"}";
                post(CONFIG.baseUrl + "device/powerOff.do", {json:json}, function(data){
                    if (data.success) {
                        showMessage('系统提示', data.message);
                    } else {
                        showAlert("错误提示", data.message, 'error');
                    }
                }, "json");
            });
        });
        
        $('#device-setValid').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            var now = user.isvalid ? "" : "当前已挂失，";
            var act = user.isvalid ? "挂失" : "激活";
            var val = +!user.isvalid;
            showConfirm("确认操作", now + "确认" + act + "？", function(){
                $.post(CONFIG.baseUrl + "device/setValid.do", {deviceId: user.userId, isvalid: val}, function(ret){
                    if (ret.success) {
                        showMessage('操作提示', ret.message);
                    } else {
                        showAlert("操作提示", ret.message);
                    }
                });
            });
        });
        $('#device-import').click(function() {
            var dlg = openEditDialog({
                title: '批量导入设备用户',
                width: 240,
                height: 160,
                href: 'view/device/deviceImport.do',
                onLoad: function() {
                    $('#downloadFile', dlg).click(function() {
                        location.href = CONFIG.modulePath + "device/device_template.xls"
                    });
                },
                onSave: function() {
                    $.messager.progress();
                    formSubmit("deviceImportForm",{
                        url: "device/importDevice.do",
                        success: function(ret){
                            if (ret.success) {
                                showMessage("操作提示", "操作成功");
                            } else {
                                showAlert("错误提示", ret.message, "warning");
                            }
                            $("[name=file]").filebox("clear");
                            datagrid.datagrid("reload");
                            $.messager.progress('close');
                        }
                    });
                }
            });
        });
        $('#integraldetail').click(function(){
            var row = datagrid.datagrid("getSelected");
            if(!row){
                return;
            }
            openTab("mainTab","view/user/userIntegral/userIntegralDetailFom.do?accountId="+row.userId, "用户[{0}] - 积分详情".format(row.aliasName));
        })
        $('#userbalance').click(function(){ 
            var row = datagrid.datagrid("getSelected");
            if(!row){
                return;
            }
            openTab("mainTab","view/user/userTradeRecord.do?accountId="+row.userId, "用户[{0}] - 消费记录".format(row.aliasName));
        });
        
        $('#user-address').click(function() {
            var user = datagrid.datagrid("getSelected");
            if(!user){
                return;
            }
            openTab("mainTab", "view/user/address/index.do?userId=" + user.userId + '&_func_code=user-address',
                "用户[" + user.aliasName + "] - 收货地址");
        });

        $('#userProfile').click(function(){
            var user=datagrid.datagrid('getSelected');
            if(!user){
                return;
            }
            var dlg= openEditDialog({
                width:300,
                height:260,
                title:'用户统计信息项录入',
                href:'user/userprofile/userprofileForm.do?userId='+user.userId,
                onLoad:function(){
                    var profileKeyMap = DictMan.itemMap('user.profile.key');
                    for (var key in profileKeyMap) {
                        //加载下拉框
                        var vals = profileKeyMap[key].split(',');
                        $('[comboname=' + key + ']').combobox({
                            multiple: vals[1] == '2',
                            data: DictMan.items(vals[0]),
                            //value: vals[2]
                        });
                    };
                                
                    //给弹框赋值，讲数据回显
                    $.get(CONFIG.baseUrl + 'user/userprofile/getValues.do?userId=' + user.userId, function(items){
                        items.forEach(function(item) {
                            $('[comboname=' + item.itemKey + ']').combobox('setValues', item.itemValue);
                        });
                    });
                },
                onSave:function(){   
                 formSubmit('#userDataForm', {
                       url:"user/userprofile/save.do?",                 
                       success: function(ret){
                           if (ret.success) {
                               dlg.dialog("close");
                           }                 
                           showOpResultMessage(ret);
                       }
                   });
                }
                
            });
        });
        
        $('#user-returnvisit').click(function() {
            var user = datagrid.datagrid('getSelected');
            if (!user) return;
            openTab('mainTab',
                'view/community/returnvisit/index.do?userId=' + user.userId,
                '用户[' + user.aliasName  + ']的回访记录');
        });
        
        $('#user-health-archive').click(function() {
            var user = datagrid.datagrid('getSelected');
            if (!user) return;
            openModuleByCode('health_arthive', {
                params: {userId: user.userId}
            });
        });

        $('#userSensorConfig').click(function() {
            var user = datagrid.datagrid('getSelected');
            if (!user) return;
            openTab({
                url: 'view/telecare/userConfig/index.do?userId='
                    + user.userId + '&deviceCode=' + user.deviceCode + '&_func_code=userConfig',
                title: '用户[' + user.aliasName + '] 远程看护配置'
            });
        });
        
        $('#user-basicinfo').click(function() {
            var user = datagrid.datagrid('getSelected');
            if (!user) return;
            openUserBasicInfo(user.userId);
        });

        $('#changeCard').click(function() {
            var user = datagrid.datagrid('getSelected');
            if (!user) return;
            openCardChange(user.userId);
        });
        $('#user_vipcard_changeRecord').click(function() {
            openTab({
                url: 'view/user/vipcard/change/record.do',
                title: '会员卡更换记录'
            });
        });

        $('#user-export').click(function() {
            showMessage("提示", "后台正在处理导出，请稍等...");
            location.href = CONFIG.baseUrl +"user/export.do?" + $.param( $.extend(handleUserQueryParams(),lastQueryParams) );
        });
    }
});
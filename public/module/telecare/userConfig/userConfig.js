initHostUserConfig(userId, 1);
new AlarmNoticePhoneManage(userId, 1);

(function() {
    $('#dailyActivity-userSensorConfig_add').click(function() {
        openEditDialog({
            width: 340,
            height: 180,
            title: '增加区域项目',
            href: 'view/telecare/userConfig/dailyActivitySensorConfigForm.do?userId=' + userId,
            onLoad: function(dlg) {
                $('[comboname=location]').combobox({
                    valueField: 'location',
                    textField: 'location',
                    url: CONFIG.baseUrl + 'telecare/locIcon/page.do',
                    loadFilter: function(page) {
                        return page.rows;
                    },
                });
                $('[comboname=sensorType]').combobox({
                    multiple: true,
                    data: DictMan.items('sensor')
                });
            },
            onSave: function(dlg) {
                formSubmit('#frmUserSensorConfig', {
                    url: 'telecare/userConfig/sensorConfig/save.do',
                    success: function(ret) {
                        if (ret.success) {
                            $('#dgUserSensorConfig').datagrid('reload');
                            dlg.dialog('destroy');
                        }
                        ret.message = ret.code == 2 ? '区域已存在' : ret.message;
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    });
    
    $('#dailyActivity-userSensorConfig_delete').click(function() {
        var row = $('#dgUserSensorLocConfig').datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'telecare/userConfig/sensorConfig/delete.do', row, function(ret){
                showOpResultMessage(ret);
                $('#dgUserSensorLocConfig').datagrid('reload');
            });
        });
    });

})();

//大门进出记录
(function() {
    var isUserTiggerMode = true;
    $.get(CONFIG.baseUrl + 'telecare/userConfig/sensorConfig/list.do?userId=' + userId + '&sceneId=2', function(d) {
        isUserTiggerMode = false;
        $('#useDoorSensor').switchbutton('enable').switchbutton((d && d.length > 0) ? 'check' : 'uncheck');
        isUserTiggerMode = true;
    });

    $('#useDoorSensor').switchbutton({
        onChange: function(checked) {
            if (!isUserTiggerMode) return;
            if (checked) {
                $('#useDoorSensor').switchbutton("options").checked
                formSubmit('#frmUserDoorSensorConfig', {
                    url: 'telecare/userConfig/sensorConfig/save.do',
                    success: function(ret) {
                        showOpResultMessage(ret);
                    }
                });
            } else {
                $.post(CONFIG.baseUrl + 'telecare/userConfig/sensorConfig/delete.do?', {userId: userId, defenceArea: 9}, function(ret) {
                    showOpResultMessage(ret);
                });
            }
        }
    });
})();

(function() {
    $.get(CONFIG.baseUrl + 'video/user/camera.do?userId=' + userId, function(d) {
        d.isvalid = d.isvalid || 1;
        $('#cameraForm').form('load', d);
    });
    $('#cameraForm').next('[name=submit]').click(function() {
        formSubmit('#cameraForm', {
            url: 'video/user.do',
            success: function(ret) {
                showOpResultMessage(ret);
            }
        });
    });
})();


var formatters = {
    sensorTypes: function(types) {
        return types.split(',').map(function(k) {
            return DictMan.itemMap('sensor')[k];
        }).join('、');
    }
}
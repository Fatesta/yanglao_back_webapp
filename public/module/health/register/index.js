var formatters = {
    status: UICommon.datagrid.formatter.generators.dict(new Dict([
      new DictItem(1, "等待"),
      new DictItem(2, "成功"),
      new DictItem(0, "取消")])),
    op: function(value,rowData,rowIndex) {
        var fns = [];
        fns.push({name: "查看详情", code: "viewDetail", icon: "icon-edit"});
        
        /*
        if (rowData.status != 1)
            fns.push({name: "推送消息", code: "sendMsg", icon: "icon-message"});

        if (rowData.status != 0) {
            if (rowData.status == 1)
                fns.push({
                    name: "预约成功",
                    code: "setOkStatus",
                    icon: 'icon-enable'});
            fns.push({
                name: "预约取消",
                code: "setCancelStatus",
                icon: 'icon-disable'});
        }*/
        
        return fns.map(function(fn){
            return ('<a href="#" class="easyui-linkbutton" title="{0}" onclick="reg.doOp(\'{1}\', {2})">'
                +'<div class=\'{3}\' style=\'float:left;width:20px;\'>&nbsp;</div></a>')
                .format(fn.name, fn.code, rowIndex, fn.icon);
        }).join('');
    }
};

var reg = (function() {
    var dg = $('#dgReg');
    
    $('[name=query]').click(function(){
        query();
    });
    
    $("[name=add]").click(function(){
        var dlg = openEditDialog({
            width: 460,
            height: '60%',
            href: "health/register/frmAdd.do",
            title: "代挂号",
            onLoad: function() {
                $('#selectUser').click(function() {
                    openUserSelectDialog({
                        onSelectDone: function(user){
                            if (!user.realName) {
                                alertInfo('请先完善该用户真实姓名');
                                return;
                            }
                            var userName = user.realName;
                            $('#frm [name=userId]').val(user.userId);
                            $('#frm #userName').textbox("setValue", userName);
                            $('#frm #idcard').textbox("setValue", user.idcard);
                            $('#frm #phone').textbox("setValue", user.telphone);
                            return true;
                        }
                    });
                });
            },
            onSave: function() {
                if (!$("#frm").form('validate'))
                    return;
                submitForm("frm", CONFIG.baseUrl + "health/register/save.do", function(ret){
                    ret = JSON.parse(ret);
                    var id = ret.data;
                    if (ret.success) {
                        showConfirm("提示","信息录入成功，现在是否发送挂号短信？", function(){
                            $.post(CONFIG.baseUrl + "health/register/sendMessage.do?id=" + id,
                                function(ret){
                                    showAlert('提示',ret.success ? '已发送' : '发送失败', 'info');
                                    if (ret.success) {
                                        dlg.dialog('destroy');
                                        dg.datagrid('reload');
                                    }
                                });
                        });
                    } else {
                        showAlert("错误提示", ret.message, "warning");
                    }
                });
            }
        });
    });
    
    $("[name=delete]").click(function(){
        var row = dg.datagrid("getSelected");
        if(!row)
            return;
        showConfirm("提示","您真的要删除吗？", function(){
            $.post(CONFIG.baseUrl + "health/register/delete.do?", {id: row.id}, function(ret){
                showMessage("操作提示", ret.message);
                dg.datagrid('reload');
            });
        });
    });
    
    function query() {
        var params = $("#frmQuery").serializeObject();
        
        dg.datagrid("load", params);
    }

    // 设置挂号状态
    function setOkStatus(row) {
        $.post(CONFIG.baseUrl + "health/register/updateState.do",
            {status: 2, id: row.id},
            function(ret){
                if (ret.success) {
                    dg.datagrid('reload');
                }
                showMessage("操作提示", ret.message);
            });
    }
    
    function setCancelStatus(row) {
        var dlg = openEditDialog({
            title: "取消挂号原因",
            width: 450,
            height: 500,
            closed: false,
            cache: false,
            href: "view/health/register/frmCancelReason.do?id=" + row.id,
            onSave: function(){
                if (!$("#frm").form('validate'))
                    return;
                submitForm("frm", CONFIG.baseUrl + "health/register/cancel.do", function(data){
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
    
    // 查看详情
    function viewDetail(row) {
        openSimpleDialog({
            title: "挂号详情",
            width: 450,
            height: 500,
            href: "health/register/detail.do?" + $.param({id: row.id})
        });
    }
    
    // 发送短信
    function sendMsg(row) {
        if (!row.phone) {
            showAlert('提示','请先编辑挂号手机号', 'question');
            return;
        }
        showConfirm("提示","确定推送挂号消息？", function(){
            $.post(CONFIG.baseUrl + "health/register/pushMessage.do?",
                {id: row.id},
                function(ret){
                    showAlert('提示',ret.success ? '已推送' : '推送失败', 'info');
                });
        });
    }
    
    return {
        query: query,
        doOp: function(code, rowIndex) {
            var row = dg.datagrid('getRows')[rowIndex];
            eval(code).call(this, row);
        }
    };
})();

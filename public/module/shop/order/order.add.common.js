function makeLinkmanSelect() {
    var lastInputPhone;
    var creatorIsSet = false;
    var userIsSelected = false;
    var that = {};
    
    
    that.onOrderEdit = function() {
        if (!PAGE_CONFIG['fastOrderMode'])
            return;
        userIsSelected = true;
        creatorIsSet = true;
        var userId = PAGE_CONFIG['userId'];
        $("#frmOrder #creator").val(userId);
        $.get(CONFIG.baseUrl + "shop/order/getRecentOrder.do", {creator: userId},
            function(order) {
                if(order) {
                    setOrderInfo(order);
                } else {
                    $.get(CONFIG.baseUrl + "shop/order/getDefaultUserAddress.do", {creator: userId}, function(d) {
                        if (d) {
                            setOrderInfo(d);
                        } else {
                            $.get(CONFIG.baseUrl + 'user/getBasicInfo.do?userId=' + userId, function(user) {
                                setOrderInfo({
                                    linkphone: user.telphone,
                                    linkman: user.realName || user.aliasName,
                                    address: user.address});
                            });
                        }
                        
                    });
                }
            });
        
        function setOrderInfo(order) {
            $("#frmOrder #linkphone").textbox("setValue", order.linkphone);
            $("#frmOrder #linkman").textbox("setValue", order.linkman);
            $("#frmOrder #address").textbox("setValue", order.address);
            lastInputPhone = order.linkphone;
        }
    }

    that.linkphoneOnBlur = function() {
        var currValue = this.value.trim();
        var changed = lastInputPhone != currValue;
        lastInputPhone = currValue;
        if(!changed)
            return;
        
        userIsSelected = false;
        creatorIsSet = false;
        $("#frmOrder #linkman").textbox("clear");
        $("#frmOrder #address").textbox("clear");
        that.selectUser(true);
    }

    that.selectUser = function(notSelectDialog) {
        if(!lastInputPhone) {
            showAlert("提示","请先输入联系电话");
            return false;
        }
        $.get(CONFIG.baseUrl + "user/getPageByCond.do", {telphone: lastInputPhone}, function(page) {
            // 选择一个作为下单人
            if(page.rows.length == 0) {// 没有
                $("#frmOrder #creator").val("");
                userIsSelected = true;
                creatorIsSet = true;
            } else if(page.rows.length == 1) {// 只有一个,默认该用户
                userIsSelected = true;
                getRecentOrderLinkmanByCreatorAndSetForm(page.rows[0].userId);
            } else if (!notSelectDialog) {
                var dlg = openEditDialog({
                    title: "选择用户",
                    width: 600,
                    height: 400,
                    modal: true,
                    content: "<table></table>",
                    onSave:  function(){
                        var selected = userDg.datagrid("getSelected");
                        if(selected) {
                            userIsSelected = true;
                            $("#frmOrder #linkphone").numberbox("setValue", selected.telphone);
                            $("#frmOrder #linkman").textbox("setValue", '');
                            $("#frmOrder #address").textbox("setValue", '');
                            getRecentOrderLinkmanByCreatorAndSetForm(selected.userId);
                        }
                        dlg.dialog('destroy');
                    }
                });
                var userDg = dlg.find('table');
                var userDgOpts = {
                    url: CONFIG.baseUrl + "user/getPageByCond.do",
                    queryParams: {telphone: lastInputPhone},
                    pageList:[5,10,20],
                    fit:true,
                    columns: [[
                        {field:'aliasName', title:'昵称', width:'24%'},
                        {field:'deviceCode', title:'设备号', width:'50%'},
                        {field:'telphone', title:'手机号', width:'20%'}
                    ]]
                };
                userDg.datagrid(userDgOpts);
            }
        });
    }
    
    that.validateLinkmanSelect = function() {
        if(!lastInputPhone)
            return false;
        if(!userIsSelected) {
            showAlert("提示","请选择一个用户");
            return false;
        }
        if(!creatorIsSet) {
            showAlert("提示","未设置下单人");
            return false;
        }
        return true;
    }
    
    function getRecentOrderLinkmanByCreatorAndSetForm(creator) {
        $("#frmOrder #creator").val(creator);
        creatorIsSet = true;
        $.get(CONFIG.baseUrl + "shop/order/getRecentOrder.do",
            {creator: creator},
            function(order) {
                if(!order) {
                    $.get(CONFIG.baseUrl + "shop/order/getDefaultUserAddress.do", {creator: creator}, setOrderInfo);
                    return;
                }
                setOrderInfo(order);
            });
        function setOrderInfo(order) {
            if(!order)
                return;
            $("#frmOrder #linkman").textbox("setValue", order.linkman);
            $("#frmOrder #address").textbox("setValue", order.address);
            $("#frmOrder #address").next("span").children().focus();
        }
    }
    
    
    return that;
}

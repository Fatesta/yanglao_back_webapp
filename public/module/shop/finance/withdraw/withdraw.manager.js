/* 提现管理
 * @author: hulang
 */
var withdrawManager = (function () {
    var that = {};

    that.query = function() {
        var params = $("#frmQuery").serializeObject()
        if($("#dgProductOrderFlow").datagrid("options").url == null) {
            $("#dgProductOrderFlow").datagrid({
                url: CONFIG.baseUrl + "shop/finance/withdraw/list.do",
                fit:true,
                queryParams: params
            });
        } else {
            $("#dgProductOrderFlow").datagrid("load", params);
        }
    }

    that.finish = function(orderno){
        showConfirm("提示","确认完成提现?", function(){
            $.post(CONFIG.baseUrl + "shop/finance/withdraw/finish.do", {orderno: orderno}, function(ret){
                if(ret.success)
                    $("#dgProductOrderFlow").datagrid("reload");
                showMessage("提示", ret.message);
            });
        });
    }
    
    return that;
})();
withdrawManager.formatters = {
    status: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('withdraw.status')),
    updateTime: function(_, row) {
        return row.status == 21 ? row.updateTime : '-';
    },
    op: function(value, row, index) {
        if (row.status != 21) {
            return '<a href="#" class="easyui-linkbutton" title="完成" onclick=withdrawManager.finish("' + row.orderno + '")>'
            + '<div class=\'icon-cash-finish \' style=\'float:left;width:20px;\'>&nbsp;</div></a>';
        }
    }
};

$(function(){
    withdrawManager.query();
});

/* 用户账号交易管理
 * @author: hulang
 */
var tradeDetailManager = (function () {
    var self = new Observer();

    if (window["BossManager"]) {
        boss.signals.selected.add(function(data) {
            $("#tbrDgTradeDetail #frmQuery [name=providerAccount]").val(data.args.rowData.adminId);
            $("#tbrDgTradeDetail #frmQuery [name=bossId]").val(data.args.rowData.adminId);
            $("#tbrDgTradeDetail #frmQuery [name=providerId]").val('');
            self.queryProvider();
            self.query();
        });
        boss.signals.loaded.add(function() {
            $("#tbrDgTradeDetail #frmQuery [name=providerAccount]").val("");
            $("#tbrDgTradeDetail #frmQuery [name=bossId]").val('');
            self.queryProvider();
            $("#dgTradeDetail").datagrid("clear");
        });
        
        $('[name=withdrawManager]').click(function() {
            var row = $("#dgBoss").datagrid("getSelected");
            if(!row) return;
            if (row.moneyType != 1) {
                alertInfo('该余额类型无法提现');
                return;
            }
            openTab("mainTab", CONFIG.baseUrl + "shop/finance/withdraw/index.do?operator=" + row.adminId,
                row.realName + " - 提现管理");
        });
    }
    
    // 查询店铺
    self.queryProvider = function() {
        var params = $("#tbrDgTradeDetail #frmQuery").serializeObject();
        params.page = 1;
        params.rows = 1000;
        $("#tbrDgTradeDetail #cboProvider").combobox({
            url: CONFIG.baseUrl + 'shop/pro/proPage.do',
            queryParams: params,
            loadFilter: function(data) {
                data.rows.unshift({providerId: "0", name: "平台运营商"});
                data.rows.unshift({providerId: "", name: "全部"});
                return data.rows;
            },
            valueField: 'providerId',
            textField: 'name',
        });
    }

    self.gotoOrderDetail = function(orderCode) {
        openTab({
            title: '跟踪工单 - ' + orderCode,
            url: CONFIG.baseUrl + 'view/shop/workOrder/orderDetail.do?orderCode=' + orderCode,
        });
    }

    var inited = false;
    self.query = function() {
        var params = $("#tbrDgTradeDetail #frmQuery").serializeObject();
        // 设置时间为当天
        params.startCreateTime = params.startCreateTime && params.startCreateTime + " 00:00:00";
        params.endCreateTime = params.endCreateTime && params.endCreateTime + " 23:59:59";

        if(!inited) {
            $("#dgTradeDetail").datagrid({
                url: CONFIG.baseUrl + "shop/finance/tradeDetailPage.do",
                fit:true,
                pageSize: 100,
                queryParams: params
            });
            inited = true;
        } else {
            $("#dgTradeDetail").datagrid("load", params);
        }
    }
    
    $("#tbrDgTradeDetail [name=query]").click(self.query);
    
    $("#tbrDgTradeDetail [name=export]").click(function(){
        showMessage("提示", "后台正在处理导出，请稍等...");
        var params = $("#tbrDgTradeDetail #frmQuery").serializeObject();
        // 设置时间为当天
        params.startCreateTime = params.startCreateTime && params.startCreateTime + " 00:00:00";
        params.endCreateTime = params.endCreateTime && params.endCreateTime + " 23:59:59";
        location.href = CONFIG.baseUrl +"shop/finance/exportTradeDetail.do?t=" + new Date()+"&"
            +$.param(params);
    });

    return self;
})();

tradeDetailManager.formatters = {
    op: function(value, rowData, rowIndex) {
        var html = "";
        var fn;
        if(fn = PAGE_CONFIG['fn_map'][169])
            html += '<a href="#" class="easyui-linkbutton" title="' + fn.name + '" onclick=tradeDetailManager.gotoWithdrawManager(' + rowIndex + ')>'
                + '<div class=\'' + fn.icon + '\' style=\'float:left;width:20px;\'>&nbsp;</div></a>';
        return html;
    },
    orderno: function(orderno, row) {
        return (orderno && orderno.substring(0, 4) != 'PPCW') ? UICommon.linkHtml({
            text: orderno,
            clickCode: 'tradeDetailManager.gotoOrderDetail("' + orderno + '")'
        }) : '';
    }
};

$(function(){
    $('#tbrDgTradeDetail #cboTradeType').comboboxFromDict({
        dict: DictMan.items('tradeType').filter(function(item) { return item.value != 9; })
    });
    $('#tbrDgTradeDetail #cboPayType').comboboxFromDict({
        dict: DictMan.items('payType')
    });
});


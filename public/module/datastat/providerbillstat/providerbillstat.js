$("#tbrproviderbillstat [name=query]").click(
		function() {
			var params = $("#tbrproviderbillstat #frmQuery").serializeObject();
		
			 var diffDays = moment(params.endCreateTime).diff(moment(params.startCreateTime), 'days');
			if(diffDays<0){
				showAlert('提示','开始时间大于结束时间','info');
				return;
			}			
			$("#dgProviderTradeAmount").datagrid('reload',params);			
		});

$("#tbrproviderbillstat [name=export]").click(
		function() {
			var params = $("#tbrproviderbillstat #frmQuery").serializeObject();
			var diffDays = moment(params.endCreateTime).diff(moment(params.startCreateTime), 'days');
			if(diffDays<0){
				showAlert('提示','开始时间大于结束时间','info');
				return;
			};
			showMessage("提示", "后台正在处理导出，请稍等...");			
			location.href = CONFIG.baseUrl + "providerbillstat/exportTradeBill.do?" + $.param(params);
		});

var formatters = {
    value: UICommon.datagrid.formatter.money,
    op: function(_, __, index) {
        var html = '';
        html += UICommon.buttonHtml({
            title: '查看明细',
            icon: 'detail',
            clickCode: 'openDetail(' + index + ')'
        });
        html += UICommon.buttonHtml({
            title: '导出明细',
            icon: 'export',
            clickCode: 'exportDetail(' + index + ')'
        });

        return html;
    }
};
$("#tbrproviderbillstat #selectProvider").click(function(){
    $("#tbrproviderbillstat #providerName").textbox('clear');
    $("#tbrproviderbillstat [name=providerId]").val('');
    openProviderSelectDialog({
       onDone: function(provider) {
    	   $("#tbrproviderbillstat #providerName").textbox('setValue', provider.name);
    	   $("#tbrproviderbillstat [name=providerId]").val(provider.providerId);
    	   return true;
       }
    });
});

function openDetail(index) {
    var row = $("#dgProviderTradeAmount").datagrid('getRows')[index];
    var params = $("#tbrproviderbillstat #frmQuery").serializeObject();
    openTab({
        title: '店铺[' + row.providerName + ']账单明细',
        url: 'view/datastat/providerbillstat/dailyTrade.do?' + $.param({
            providerId: row.providerId,
            startCreateTime: params.startCreateTime, endCreateTime: params.endCreateTime})
    });
}

function exportDetail(index) {
    var row = $("#dgProviderTradeAmount").datagrid('getRows')[index];
    var params = $("#tbrproviderbillstat #frmQuery").serializeObject();
    location.href = CONFIG.baseUrl + "providerbillstat/exportTradeDetail.do?" + $.param({
        providerId: row.providerId,
        startCreateTime: params.startCreateTime, endCreateTime: params.endCreateTime})
}
$("#tbrDgBillList [name=query]").click(
		function() {
			var params = $("#tbrDgBillList #frmQuery").serializeObject();
			// 设置时间为当天
			params.startCreateTime = params.startCreateTime
					&& params.startCreateTime + " 00:00:00";
			params.endCreateTime = params.endCreateTime && params.endCreateTime
					+ " 23:59:59";
		

			var diffDays = moment(params.endCreateTime).diff(moment(params.startCreateTime), 'days');
			if(diffDays<0){
				showAlert('提示','开始时间大于结束时间','info');
				return;
			}
			if ($("#dgBillList").datagrid("options").url == null) {
				$("#dgBillList").datagrid({
					url : CONFIG.baseUrl + "platformData/page.do",
					pagination : true,
					pagePosition : 'bottom',
					pageNumber : 1,
					pageSize : 20,
					pageList : [ 10, 20, 50, 100 ],
					singleSelect : true,
					multiSort : false,
					sortOrder : 'desc',
					rownumbers : true,
					fit : true,
					queryParams : params
				});
			} else {
				$("#dgBillList").datagrid("load", params);
			}
		});

$("#tbrDgBillList [name=export]").click(
		function() {
			showMessage("提示", "后台正在处理导出，请稍等...");
			var params = $("#tbrDgBillList #frmQuery").serializeObject();
			// 设置时间为当天
			params.startCreateTime = params.startCreateTime
					&& params.startCreateTime + " 23:59:59";
			params.endCreateTime = params.endCreateTime && params.endCreateTime
					+ " 00:00:00";
			var diffDays = moment(params.endCreateTime).diff(moment(params.startCreateTime), 'days');
			if(diffDays<0){
				showAlert('提示','开始时间大于结束时间','info');
				return;
			}
			location.href = CONFIG.baseUrl
					+ "platformData/exportTradeBill.do?t=" + new Date() + "&"
					+ $.param(params);
		});

$(function() {
	$('#cboTradeType').comboboxFromDict(
			{
				dict : DictMan.itemMap('platform.tradeType'),
						emptyItem: new DictItem(-1, '全部'),
						value: -1,	
						onChange:function(val){
							toggleColumns({
								datagrid: '#dgBillList',
								hideColumns:  {
									0:['realName'],
									1:['aliasName'],
									2:['aliasName'],
									3:['aliasName'],
									4:['realName','aliasName'],
									7:['operationPhoneLogo']
								}[val]
							});
						}
			});
});
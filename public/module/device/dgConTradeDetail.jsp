<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
	<div id="tbr">
		<form id="frmQuery">
		    <table class="form">
		        <tr>
		            <td colspan="6">
		                      总共消费总额: ${totalMoney}
		            </td>
		        </tr>
		    </table>
		</form>
	</div>
    <table class="easyui-datagrid" toolbar="#tbr"
        data-options="url:'${urlPath }shop/finance/tradeDetailPage.do',
              fit:true,
              queryParams: {userAccount: '${userAccount}', tradeType: 3}">
        <thead>
            <tr>
                <th data-options="field:'tradePrice',width:'8%',halign:'center',formatter:UICommon.datagrid.formatter.money">消费金额</th>
                <th data-options="field:'userAccountDeviceCode',width:'9%',halign:'center'">设备号</th>
                <th data-options="field:'operationAccountUsername',width:'8%',halign:'center'">商户操作工号</th>
                <th data-options="field:'providerName',width:'10%',halign:'center'">店铺</th>
                <th data-options="field:'createTime',width:'10%',halign:'center'">消费时间</th>
            </tr>
        </thead>
    </table>

</body>
</html>
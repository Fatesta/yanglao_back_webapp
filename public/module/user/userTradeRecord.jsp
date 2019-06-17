<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>

</head>
<body>
	<div id="toolbar">
		<form id="form">
			<table class="form">
				<tr>
					<td>交易类型</td>
					<td>
						<select class="easyui-combobox" id="cboTradeType" name="tradeType" style="width: 130px;" ></select>
				    </td>
				    <td>开始时间</td>
					<td><input class="easyui-datebox filter"
						name="startCreateTime" type="text" style="width: 100px" value="${startCreateTime}"></td>
					<td>结束时间</td>
					<td><input class="easyui-datebox filter"
						name="endCreateTime" type="text" style="width: 100px"></td> 
					<td colspan="7"><a href="#"
						class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						name="query">查询</a></td>
					
				</tr>
			</table>
		</form>
	</div>
	<table id="dgTradeRecord" class="easyui-datagrid"
		data-options="url:'${urlPath}shop/finance/tradeDetailPage.do?userAccount=${accountId}',
		          queryParams: {startCreateTime: '${startCreateTime}'},
				  toolbar:'#toolbar',
				  fit:true
				  ">
		<thead>
			<tr>
				<th data-options="field:'createTime',width:130,halign:'center',align:'center'">交易时间</th>
	            <th data-options="field:'formattedTradeType',width:100,halign:'center',align:'center'">交易类型</th>
	            <th data-options="field:'formattedPayType',width:100,halign:'center',align:'center'">支付方式</th>
                <th data-options="field:'totalFee',width:60,halign:'center',align:'center', formatter: UICommon.datagrid.formatter.money">原价</th>
                <th data-options="field:'tradePrice',width:60,halign:'center',align:'center', formatter: UICommon.datagrid.formatter.money">实收</th>
	            <th data-options="field:'formattedCouponAmount',width:200,halign:'center',align:'center'">优惠</th>
	            <th data-options="field:'operationAccountUsername',width:100,align:'center'">商户操作工号</th>
	            <th data-options="field:'providerName',width:200,halign:'center'">店铺</th>
			</tr>
	
		</thead>
	</table> 
	
<script >

$(function() {
	$('#cboTradeType').comboboxFromDict({
		dict : DictMan.items('tradeType').filter(function(item){
		    return [3,4,5,6,7,10,11].includes(+item.value);
		})
	});
});

$("#toolbar [name=query]").click(function() {
	var params = $("#toolbar #form").serializeObject();
	// 设置时间为当天
	params.startCreateTime = params.startCreateTime && params.startCreateTime + " 00:00:00";
	params.endCreateTime = params.endCreateTime && params.endCreateTime + " 23:59:59";
	$("#dgTradeRecord").datagrid("load", params);
});

</script>
</body>
</html>
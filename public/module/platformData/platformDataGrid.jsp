<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp"%>
</head>
<body>
	<div id="tbrDgBillList">
		<form id="frmQuery">
			<table class="form">
				<tr>
					<td>交易类型</td>
					<td>
						<select class="easyui-combobox"
						id="cboTradeType" name="tradeType" style="width: 130px;" >
						</select></td>
					<td>开始时间</td>
					<td><input class="easyui-datebox filter"
						name="startCreateTime" type="text" style="width: 100px"></td>
					<td>结束时间</td>
					<td><input class="easyui-datebox filter"
						name="endCreateTime" type="text" style="width: 100px"></td>
					<td colspan="7"><a href="#"
						class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						name="query">查询</a></td>
					<td colspan="7"><a href="#"
						class="easyui-linkbutton" data-options="iconCls:'icon-export'"
						name="export">导出为Excel</a></td>
				</tr>
			</table>
		</form>
	</div>
	<table id="dgBillList" class="easyui-datagrid" toolbar="#tbrDgBillList"
		 data-options="url:'${urlPath}/platformData/page.do',
					pagination : true,
					pageNumber : 1,
					pageSize : 20,
					pageList : [ 10, 20, 50, 100 ],
					singleSelect : true,
					multiSort : false,
					sortOrder : 'desc',
					rownumbers : true,
					fit : true">
		<thead>
			<tr>
				<th data-options="field:'serialId',width:'150',halign:'center',align:'left'">流水号</th>						
				<th data-options="field:'realName',width:'100',halign:'center',align:'left'">商户账户</th>
				<th data-options="field:'tradeTyped',width:'120',align:'center'">交易类型</th>
				<th data-options="field:'totalPrice',width:'60',align:'center',formatter: UICommon.datagrid.formatter.money">售价(元)</th>
				<th data-options="field:'tradePrice',width:'60',align:'center',formatter: UICommon.datagrid.formatter.money">实收(元)</th>			
				<th data-options="field:'aliasName',width:'100',halign:'center',align:'left'">用户昵称</th>				
				<th data-options="field:'payTyped',width:'80',align:'center'">支付方式</th>
				<th data-options="field:'operationPhoneLogo',width:'190',align:'center',formatter: UICommon.datagrid.formatter.wraptip">商户操作手机标识</th>
				<th data-options="field:'providerName',width:'180',halign:'center',align:'left'">店铺名称</th>
				<th data-options="field:'createTime',width:'135',align:'center'">交易时间</th>
				<th data-options="field:'remark',width:'180',halign:'center',align:'left'">备注</th>
			</tr>
		</thead>
	</table>
	<script src="${modulePath}platformData/billList.js"></script>
</body>
</html>
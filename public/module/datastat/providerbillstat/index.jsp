<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
<%@ include file="/module/common.jsp"%>
</head>
<body>
<div id="tbrproviderbillstat">
	<form id="frmQuery">
	    <input name="providerId" type="hidden"/>
		<table class="form">
			<tr>			 
				<td>选择店铺</td>
				<td id="selectProvider"><input class="easyui-textbox filter" id="providerName"  style="width: 100px;" 
				data-options="readonly:true"></td>
				<td>查询日期</td>
				<td>
				    <input class="easyui-datebox filter" name="startCreateTime"   style="width: 100px;">
				    <span>至</span>
				    <input class="easyui-datebox filter" id = "attYearMonth"   name="endCreateTime"  style="width: 100px;">
				</td>
				<td><a href="#"
						class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						name="query">查询</a></td>
				<td><a href="#"
					class="easyui-linkbutton" data-options="iconCls:'icon-export'"
					name="export">导出</a></td>	
			</tr>
		</table>
	</form>
</div>
<table id="dgProviderTradeAmount" class="easyui-datagrid" toolbar='#tbrproviderbillstat' 
		data-options="url:'${urlPath }providerbillstat/page.do',
		          pageSize: 30,
				  loadFilter: function(page) {
				    page.rows.forEach(function(row){
				    	_.forEach(row.tradeTypeAmountMap, function(v, k){
				    		row['total' + k] = v;
				    	});
				    });
				    return page;
				  }"
				  >
	<thead>
		<tr>
			<th data-options="field:'providerName',width:'240',hhalign:'center'">店铺名称</th>
			<c:if test="${adminRole.id == 1}">
			<th data-options="field:'total1',width:'100',halign:'center',precision:'2',formatter:formatters.value">购买余额</th>
			</c:if>
			<th data-options="field:'total3',width:'100',halign:'center',precision:'2',formatter:formatters.value">用户总消费</th>
			<th data-options="field:'total3_online',width:'100',halign:'center',precision:'2',formatter:formatters.value">用户线上消费</th>
			<th data-options="field:'total3_cash',width:'100',halign:'center',precision:'2',formatter:formatters.value">用户现金消费</th>
			<th data-options="field:'total4',width:'100',halign:'center',precision:'2',formatter:formatters.value">给用户充值</th>
            <th data-options="field:'totalpp',width:'100',halign:'center',precision:'2',formatter:formatters.value">赠送金额</th>
			<th data-options="field:'total5',width:'100',halign:'center',precision:'2',formatter:formatters.value">用户退款</th>
			<th data-options="field:'total11',width:'100',halign:'center',precision:'2',formatter:formatters.value">返还余额</th>
            <th data-options="field:'totalincome',width:'180',halign:'center',precision:'2',formatter:formatters.value">销售额=用户总消费-返还余额</th>
            <th data-options="field:'op',width:'80',halign:'center',formatter:formatters.op">操作</th>
		</tr>
	</thead>
</table>
<script src="${modulePath}datastat/providerbillstat/providerbillstat.js?v=1"></script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
</body></html>


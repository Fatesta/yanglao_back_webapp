<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
<div data-options="region:'center',split:true,collapsible:true" style="height:70%;">
	<div id="tbrDgOrder">
		<form id="frmQueryOrder">
			<input name="providerId" type="hidden" value="${providerId}"/>
			<table class="form">
				<tr>
					<td>
						订单号
					</td>
					<td>
						<input class="easyui-textbox" name="orderno" type="text">
					</td>
					<td>
						订单状态
					</td>
					<td>
					    <select class="easyui-combobox" id="status" name="status" style="width: 100px;"></select>
					</td>
					<td>
						支付状态
					</td>
					<td>
					    <select class="easyui-combobox" id="payStatus" name="payStatus" style="width: 80px;"></select>
					</td>
                    <td>
                                                     支付方式
                    </td>
                    <td>
                        <select class="easyui-combobox" id="payType" name="payType" style="width: 100px;"></select>
                    </td>
					<td>
						开始日期
					</td>
					<td>
						<input class="easyui-datebox filter" name="startCreateTime" type="text" style="width:100px;">
					</td>
					<td>
						结束日期
					</td>
					<td>
						<input class="easyui-datebox filter" name="endCreateTime" type="text" style="width:100px;">
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>
					</td>
			    	<td>
			    		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="viewOrderFlow">查看订单流程</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<table id="dgOrder" class="easyui-datagrid" toolbar='#tbrDgOrder'>
	    <thead>
	        <tr>
	        	<th data-options="field:'orderno',width: 150,halign:'center'">订单号</th>
	            <th data-options="field:'status',width:90,halign:'center', align:'center', formatter:OrderManager.formatters.status">订单状态</th>
	            <th data-options="field:'paymentFee',width:70,halign:'center', align:'center', formatter:OrderManager.formatters.money">金额(¥)</th>
	            <th data-options="field:'quantity',width:50,halign:'center', align:'center'">数量</th>
	            <th data-options="field:'payStatus',width:60,halign:'center', align:'center', formatter:OrderManager.formatters.payStatus">支付状态</th>
	            <th data-options="field:'payType',width:70,halign:'center', align:'center', formatter:OrderManager.formatters.payType">支付方式</th>
				<th data-options="field:'linkman',width:100,halign:'center'">下单人</th>
	            <th data-options="field:'linkphone',width:100,halign:'center'">联系电话</th>
	            <th data-options="field:'address',width:160,halign:'center', formatter: OrderManager.formatters.address">订单地址</th>
	            <th data-options="field:'createTime',width:132,halign:'center'">下单时间</th>
	        </tr>
	    </thead>
	</table>
</div>
<div data-options="region:'south',title:'订单明细',split:true,collapsible:true" style="height:30%;">
	<div id="tbrDgOrderDetail">
		<form id="frmQueryOrderDetail">
			<input name="orderno" type="hidden" />
			<table class="form">
				<tr>
				</tr>
			</table>
		</form>
	</div>
	<table id="dgOrderDetail" class="easyui-datagrid" toolbar='#tbrDgOrderDetail'>
	    <thead>
	        <tr>
	            <th data-options="field:'productName',width:'20%',halign:'center'">商品名称</th>
<!-- 	            <th data-options="field:'imageFile',width:'10%',halign:'center', formatter:OrderDetailManager.formatters.imageFile">商品图片</th> -->
	            <th data-options="field:'price',width:'6%',halign:'center', formatter:OrderManager.formatters.money">单价(¥)</th>
	            <th data-options="field:'quantity',width:'4%',halign:'center'">数量</th>
				<th data-options="field:'amount',width:'8%',halign:'center', formatter:OrderManager.formatters.money">总金额(¥)</th>
	            <th data-options="field:'orderDesc',width:'14%',halign:'center', formatter:OrderDetailManager.formatters.orderDesc">备注</th>
	        </tr>
	    </thead>
	</table>
</div>
<div id="dlgOrder"></div>
<div id="dlg"></div>
<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}shop/order/order.manager.js?v=1.2"></script>
</body>
</html>
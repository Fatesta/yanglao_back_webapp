<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbrDgProductOrderFlow">
	<form id="frmQuery">
		<input name="operator" type="hidden" value="${operator}"/>
	</form>
</div>
<table id="dgProductOrderFlow" class="easyui-datagrid" toolbar='#tbrDgProductOrderFlow'>
    <thead>
        <tr>
            <th data-options="field:'orderno',width: 150,halign:'center'">订单号</th>
            <th data-options="field:'flowTime',width: 130,halign:'center'">申请时间</th>
            <th data-options="field:'money',width: 80,align:'center',formatter:UICommon.datagrid.formatter.money">申请金额</th>
            <th data-options="field:'remark',width:600,halign:'center',
            	formatter:UICommon.datagrid.formatter.generators.omit({dgId: 'dgProductOrderFlow', field: 'remark', min: 80})">提现帐号</th>
            <th data-options="field:'status',width:100,align:'center',formatter:withdrawManager.formatters.status">状态</th>
            <th data-options="field:'updateTime',width: 130,align:'center',formatter:withdrawManager.formatters.updateTime">到账时间</th>
            <th data-options="field:'-',width:40,halign:'center',formatter:withdrawManager.formatters.op">操作</th>
        </tr>
    </thead>
</table>
<script src="${modulePath}shop/finance/withdraw/withdraw.manager.js"></script>
</body>
</html>
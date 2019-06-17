<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<div data-options="title: '基本信息', region: 'center', split: true, collapsible: true" style="width:50%">
		<div id="tbr">
			<form id="frmQuery">
				<table class="form">
				   <tr>
					   <td colspan="10">
					   <c:forEach var="func" items="${ROLE_FUNCS}">
						   <c:if test="${func.code != 'hh_plan_cycle_step'}">
						   <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
						   </c:if>
					   </c:forEach>
					   </td>

					   <td>标题</td>
					   <td>
						   <input class="easyui-textbox" name="title" type="text" style="width:264px">
					   </td>
					   <td colspan="8">
						   <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					   </td>
					</tr>
				</table>
			</form>
		</div>
		<table id="dgPlan" class="easyui-datagrid" toolbar="#tbr"
			data-options="url:'${urlPath}health/house/plan/plan/page.do',
						  fit:true,
						  onLoadSuccess: planManage.onLoadSuccess,
						  onSelect: planManage.onSelect">
			<thead>
				<tr>
					<th data-options="field:'coverUrl', width:60, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.image({width: 60, height: 50})">图片</th>
					<th data-options="field:'title', width:200, halign: 'center', align:'left'">标题</th>
					<th data-options="field:'cycleDayNum', width:70, halign: 'center', align:'center'">周期天数</th>
					<th data-options="field:'intro', width:250, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgPlan', min: 20, field: 'intro'})">简介</th>
					<th data-options="field:'state', width:80, halign: 'center', align:'center', formatter: planManage.formatters.state">状态</th>
					</tr>
			</thead>
		</table>
	</div>
	<div data-options="region: 'east', split: true, collapsible: true" style="width: 50%">
		<%@ include file="cycle/index.jsp" %>
	</div>

	<script src="${modulePath}health/house/plan/plan/index.js"></script>
	<script src="${modulePath}health/house/plan/plan/cycle/cycle.js?v=1"></script>
</body>
</html>
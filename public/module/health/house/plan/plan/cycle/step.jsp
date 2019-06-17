<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<div id="tbrDayStep">
	<form id="frmDayStepQuery">
		<table class="form">
		   <tr>
			   <td colspan="10">
			   <c:forEach var="func" items="${ROLE_FUNC_MAP['hh_plan_cycle_step'].children}">
				   <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
			   </c:forEach>
			   </td>
		   </tr>
		</table>
	</form>
</div>
<table id="dgPlanDayStep" class="easyui-datagrid" toolbar="#tbrDayStep" data-options="pagination:false">
	<thead>
	<tr>
		<th data-options="field:'step', width:60, halign: 'center', align:'center'">第几步</th>
		<th data-options="field:'articleCoverUrl', width:60, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.image({width: 60, height: 50})">文章封面</th>
		<th data-options="field:'articleTitle', width:200, halign: 'center', align:'left'">文章标题</th>
		<th data-options="field:'-', width:200, halign: 'center', formatter: planCycleDayStepManage.formatters.op">操作</th>

	</tr>
	</thead>
</table>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrDgActivity">
	<form id="frmQuery">
	    <input name="providerId" value="${providerId}" type="hidden"> 
		<table class="form">
			<tr>
			    <c:if test="${providerId == null}">
                <td>店铺</td>
                <td id="selectProvider">
                    <input class="easyui-textbox" name="providerName" data-options="readonly: true" type="text" style="width:100px;">
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"></a>
                </td>
                </c:if>
				<td>标题</td>
				<td><input class="easyui-textbox filter" name="title" type="text" style="width: 100px;"></td>
					<td>活动时间</td>
				<td><input class="easyui-datebox filter" name="time" type="text" style="width: 100px;"></td>
				<td>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
				            onclick="activityManager.query()">查询</a>
				</td>
				<c:if test="${ROLE_FUNC.code == 'activityManager'}">
				<c:forEach var="fn" items="${ROLE_FUNCS}">
					<td>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
					</td>
				</c:forEach>
				</c:if>
			</tr>
		</table>
	</form>
</div>
<table id="dgActivity" class="easyui-datagrid" toolbar='#tbrDgActivity'>
	<thead>
		<tr>
			<th data-options="field:'title',width:'220',halign:'center'">标题</th>
			<th data-options="field:'categoryName',width:'80',align:'center'">分类</th>
			<th data-options="field:'publisherName',width:'120',align:'center'">发布者</th>
            <th data-options="field:'isLive',width:'60',align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-yesno'))">是否直播</th>
            <th data-options="field:'status',width:'40',align:'center', formatter: formatters.status">状态</th>
			<th data-options="field:'startTime',width:'130',align:'center',align:'center'">开始时间</th>
			<th data-options="field:'endTime',width:'130',align:'center',align:'center'">结束时间</th>
			<th data-options="field:'telephone',width:'100',halign:'center'">联系电话</th>
			<th data-options="field:'address',width:'200',halign:'center'">活动地址</th>
			<th data-options="field:'orgName',width:'100',halign:'center',formatter:formatters.orgset">活动范围</th>
			<th data-options="field:'signCount',width:'55',halign:'center'">参与人数</th>	
			<c:if test="${ROLE_FUNC.code == 'activityManager'}">
			    <th data-options="field:'formatOper',width:'140',halign:'center',align:'center',formatter:formatters.formatOper">操作</th>
		    </c:if>
		</tr>
	</thead>
</table>
<script>
var providerId = "${providerId}";
</script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
<script src="${modulePath}activity/activity.manager.js?v=1.3"></script>


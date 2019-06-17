<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/module/common.jsp" />
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
		<table class="form">
		   <tr>
	            <td>
	            	<a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	            </td>
	            <c:forEach var="func" items="${ROLE_FUNCS}">
					<td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	            </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}activityParticipant/page.do',
	    fit:true">
    <thead>
        <tr>
            <th data-options="field:'activityId', width:'100', halign: 'center', align:'left'">活动id</th>
            <th data-options="field:'createTime', width:'100', halign: 'center', align:'left'">参与时间</th>
            <th data-options="field:'signStatus', width:'100', halign: 'center', align:'left'">是否签到</th>
            <th data-options="field:'userId', width:'100', halign: 'center', align:'left'">参与用户id</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}activityStat/index.js"></script>

</body>
</html>
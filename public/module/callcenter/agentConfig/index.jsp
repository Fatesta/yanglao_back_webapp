<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	            <c:forEach var="func" items="${ROLE_FUNCS}">
					<td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	            </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'/callcenter/agentConfig/page.do',
	    fit:true">
    <thead>
        <tr>
            <th data-options="field:'adminUsername', width:'100', halign: 'center', align:'left'">用户名</th>
            <th data-options="field:'displayName', width:'100', halign: 'center', align:'left'">坐席名</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}callcenter/agentConfig/index.js"></script>

</body>
</html>
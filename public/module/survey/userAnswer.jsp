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
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'" data-funcid="${func.id}">${func.funcName}</a></td>
	           </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dgAnswerer" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}survey/userAnswer/page.do?surveyId=${surveyId}',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'userName', width:'10%', halign: 'center', align:'left'">用户名</th>
            <th data-options="field:'createTime', width:'10%', halign: 'center', align:'left'">提交时间</th>
        	</tr>
    </thead>
</table>

<script>
var PAGE_CONFIG = {surveyId: '${surveyId}'};
</script>
<script src="${modulePath}survey/userAnswer.js"></script>

</body>
</html>
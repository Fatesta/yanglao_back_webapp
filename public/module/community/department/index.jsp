<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="layout" class="easyui-layout">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'west',split:true,collapsible:true" title="部门结构" style="width:300px">
			<ul id="departmentTree"></ul>
		</div>

		<div id="panelEmployee" data-options="region:'center'" title="部门员工">
            <%@ include file="employee/index.jsp" %>
		</div>
	</div>

	<div id="departmentMenu" class="easyui-menu" style="width:120px;">
	</div>

<script>
var communityId = ("${curAdmin.roleId != 1 ? curAdmin.orgId : ''}");
</script>
<script src="${modulePath}community/department/department.js?v=1"></script>
<script src="${modulePath}community/department/employee.js?v=1.1"></script>
<script src="${modulePath}community/department/index.js?v=1"></script>
</body>
</html>
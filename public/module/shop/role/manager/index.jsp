<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">

<div data-options="region:'north',title:'店铺', split:true,collapsible:true" style="height:30%;">
	<%@ include file="../../pro/dgPro.jsp" %>
</div>
<div data-options="region:'center',title:'店员',split:true,collapsible:true" style="height:70%;">
	<%@ include file="../../employee/dgEmployee.jsp" %>
</div>
	
<script src="${modulePath}shop/pro/pro.js?v=1.5"></script>
<script src="${modulePath}shop/employee/employee.js?v=1"></script>
<script>
pro.query();
</script>
</body>
</html>
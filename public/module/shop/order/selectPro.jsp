<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<%
	request.setAttribute("funcs", request.getAttribute("ROLE_FUNCS"));
	%>
	<%@ include file="../pro/dgPro.jsp" %>

<script>
var pageConfig = {
    fastOrderMode: '${fastOrderMode}',
    userId: '${userId}'
}
</script>
<script src="${modulePath}shop/pro/pro.js?v=1"></script>
<script src="${modulePath}shop/order/selectPro.js?v=20190530"></script>
</body>
</html>
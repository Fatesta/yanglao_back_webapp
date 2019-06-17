<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<%@ include file="../../dgTradeDetail.jsp" %>
	
	<script src="${modulePath}shop/finance/tradedetail.manager.js?v=1.3"></script>
	<script>
	$(function() {
		tradeDetailManager.queryProvider();
		tradeDetailManager.query();
	});
	</script>
</body>
</html>
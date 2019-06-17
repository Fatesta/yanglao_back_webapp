<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<div data-options="region:'center',split:true,collapsible:true" style="height:25%;">
		<%@ include file="../../../boss/dgBoss.jsp" %>
	</div>
	<div data-options="region:'south',title:'交易流水',split:true,collapsible:true" style="height:75%;">
		<%@ include file="../../dgTradeDetail.jsp" %>
	</div>
	
	<script src="${modulePath}shop/finance/tradedetail.manager.js?v=1.3"></script>
	<script>
	    boss.query();
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
<div data-options="region: 'center', split: true, collapsible: true" style="height: 50%">
    <%@ include file="datagrid.jsp" %>
</div>
<div data-options="title: '计划细节', region: 'south', split: true, collapsible: true" style="height: 50%">
    <%@ include file="detail/index.jsp" %>
</div>
<script src="${modulePath}shop/pro/providerToProductSelect.js"></script>
<script src="${libPath}easyui/plugins/datagrid-detailview.js"></script>
<script src="${modulePath}servicePlan/template/manager.js"></script>
<script src="${modulePath}servicePlan/template/detail/detail.js?v=2"></script>
</body>
</html>
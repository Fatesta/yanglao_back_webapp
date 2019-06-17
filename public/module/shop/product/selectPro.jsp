<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.xtxk.hb.security.model.Func" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
    <%
    List<Func> funcs = new ArrayList<Func>();
    Func func = new Func();
    func.setCode("manageProduct");
    func.setFuncName("管理商品");
    func.setIcon("icon-add");
    funcs.add(func);
    request.setAttribute("funcs", funcs);
    %>
	<%@ include file="../pro/dgPro.jsp" %>

<script src="${modulePath}shop/pro/pro.js?v=1"></script>
<script src="${modulePath}shop/product/selectPro.js?v=1.2"></script>
</body>
</html>
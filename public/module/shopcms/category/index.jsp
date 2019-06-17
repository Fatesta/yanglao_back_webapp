<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbrCategory">
    <form id="frmQuery">
		<table class="form">
		   <tr>
               <c:forEach var="func" items="${ROLE_FUNCS}">
                   <td><a id="${func.code}" data-funcid="${func.id}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
               </c:forEach>
			</tr>
		</table>
    </form>
</div>
<%@ include file="categoryTreegrid.jsp" %>
<script src="${modulePath}shopcms/category/category.js?v=2.2"></script>

</body>
</html>
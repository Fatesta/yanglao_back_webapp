<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<form id="callForm" method="post">
		<input type="hidden" name="deviceCode" value="${deviceCode }">
		<table class="form">
	    	<tr>
	    		<td><label for="name">昵称</label></td>
	    		<td><input class="easyui-textbox" value="${name }" name="name" data-options="validType:'length[1,50]'" ></td>
	    	</tr>
	    	<tr>
	    		<td><label for="phoneNumber">联系电话</label></td>
	    		<td><input class="easyui-textbox" value="${phoneNumber }" name="phoneNumber" data-options="required:true" ></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>
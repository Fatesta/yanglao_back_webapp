<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="roleForm" method="post">
    	<input type="hidden" name="id" value="${role.id }">
	    <table class="form">
	    	<tr>
	    		<td><label for="roleName">角色名</label></td>
	    		<td><input class="easyui-textbox" name="roleName" value="${role.roleName}" data-options="required:true,validType:'length[1,20]'"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="remark">备注</label></td>
	    		<td><textarea rows="3" cols="40" class="easyui-validatebox" name="remark" data-options="validType:'length[0,100]'">${role.remark}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>
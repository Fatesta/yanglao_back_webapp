<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<form id="frmMutilCameraNode" method="post">
		<input type="hidden" name="id" value="${mutilCameraNode.id}">
		<input type="hidden" name="cameraId" value="${mutilCameraNode.cameraId}">
		<table class="form">
	    	<tr>
	    		<td>编号</td>
	    		<td><input name="nodeno" class="easyui-numberbox" value="${mutilCameraNode.nodeno}" data-options="precision:0,min:0,max:10000"  style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td>描述</td>
	    		<td><textarea name="desc" rows="4" class="easyui-validatebox" data-options="validType:'length[0,32]'"  style="width:300px">${mutilCameraNode.desc}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>
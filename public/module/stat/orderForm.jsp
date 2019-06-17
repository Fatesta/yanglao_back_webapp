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
    <form id="orderForm" method="post">
    	<input type="hidden" name="deviceCode" value="${device.deviceCode }">
    	<input type="hidden" name="serviceId" value="${serviceId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="aliasName">昵称</label></td>
	    		<td><input class="easyui-textbox" name="aliasName" value="${device.aliasName}" data-options="editable:false"></td>
	    		<td><label for="telephone">手机号</label></td>
	    		<td><input class="easyui-numberbox" name="telephone" value="${device.telphone}" data-options="editable:false"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="aliasName">地址</label></td>
	    		<td colspan="3" class="form">
	    			<input class="easyui-textbox" name="address" value="${device.address}" data-options="editable:false" style="width: 350px;">
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="remark">备注</label></td>
	    		<td colspan="3" class="form"><textarea style="width: 350px;" rows="5" class="easyui-validatebox" name="remark" data-options="validType:'length[0,255]'"></textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>
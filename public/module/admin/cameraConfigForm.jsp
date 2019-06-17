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
	<form id="cameraConfigForm" method="post">
		<input type="hidden" name="id" value="${cameraConfig.id}">
		<input type="hidden" name="adminId" value="${cameraConfig.adminId}">
		<input type="hidden" name="roleId" value="${cameraConfig.roleId}">
        <input type="hidden" name="orgId" value="${cameraConfig.orgId}">

		<table class="form">
            <tr>
                <td>设备序列号</td>
                <td><input class="easyui-textbox" value="${cameraConfig.cameraNo }" name="cameraNo" data-options="validType:'length[0,40]'" ></td>
            </tr>
            <tr>
                <td>设备9位序列号</td>
                <td><input class="easyui-textbox" value="${cameraConfig.deviceSerial }" name="deviceSerial" data-options="validType:'length[9,9]'" ></td>
            </tr>
            <tr>
                <td>设备6位验证码</td>
                <td><input class="easyui-textbox" value="${cameraConfig.validateCode}" name="validateCode" data-options="validType:'length[6,6]'" ></td>
            </tr>
			<!--
            <tr>
                <td>LAN IP</td>
                <td><input class="easyui-textbox" value="${cameraConfig.lanip }" name="lanip" data-options="validType:'length[0,15]'" ></td>
            </tr>
	    	<tr>
	    		<td><label for="port">HTTP端口</label></td>
	    		<td><input class="easyui-numberbox" value="${cameraConfig.port }" name="port" data-options="precision:0,min:0,max:65535" ></td>
	    	</tr>
	    	<tr>
	    		<td><label for="username">用户名</label></td>
	    		<td><input class="easyui-textbox" value="${cameraConfig.username}" name="username" data-options="validType:'length[0,32]'" ></td>
	    	</tr>
	    	<tr>
	    		<td><label for="password">密码</label></td>
	    		<td><input class="easyui-textbox" value="${cameraConfig.password}" name="password" data-options="validType:'length[0,20]'" ></td>
	    	</tr>
	    	-->
	    </table>
	</form>
</body>
</html>
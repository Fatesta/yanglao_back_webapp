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
	<form id="frmOrgCameraConfig" method="post">
		<input type="hidden" name="id" value="${orgCameraConfig.id}">
		<input type="hidden" name="orgId" value="${orgCameraConfig.orgId}">
		<table class="form">
            <tr>
                <td>名称</td>
                <td><input class="easyui-textbox" name="note" value="${orgCameraConfig.note}" data-options="validType:'length[0,32]'"  style="width:200px"></td>
            </tr>
            <tr>
                <td>设备9位序列号</td>
                <td><input class="easyui-textbox" value="${orgCameraConfig.deviceSerial }" name="deviceSerial" data-options="validType:'length[9,9]'" ></td>
            </tr>
            <tr>
                <td>设备6位验证码</td>
                <td><input class="easyui-textbox" value="${orgCameraConfig.validateCode}" name="validateCode" data-options="validType:'length[6,6]'" ></td>
            </tr>
	    	<!--
	    	<tr>
	    		<td>设备IP</td>
	    		<td><input class="easyui-textbox" value="${orgCameraConfig.ip }" name="ip" data-options="validType:'length[0,15]'"  style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td>HTTP端口</td>
	    		<td><input class="easyui-numberbox" value="${orgCameraConfig.port }" name="port" data-options="precision:0,min:0,max:65535"  style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td>用户名</td>
	    		<td><input class="easyui-textbox" value="${orgCameraConfig.username}" name="username" data-options="validType:'length[0,32]'"  style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td>密码</td>
	    		<td><input class="easyui-textbox" value="${orgCameraConfig.password}" name="password" data-options="validType:'length[0,20]'"  style="width:200px"></td>
	    	</tr>
	    	  -->
	    	<tr>
	    		<td>类型</td>
	    		<td>
	    			<input name="type" class="easyui-combobox" value="${orgCameraConfig.type}"
	    				data-options="value: 3, required:true, readonly:true,
	    					data:[{value:3, text: '萤石云摄像头'}, {value:'1',text:'单路摄像头'},{value:'2',text:'多路摄像头'}]"
						style="width:150px">
	    			</input>
	    		</td>
	    	</tr>
	    </table>
	</form>
</body>
</html>